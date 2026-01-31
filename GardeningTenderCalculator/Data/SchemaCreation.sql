USE GardeningTenderCalculatorDatabase
GO

CREATE SCHEMA PricingSchema
GO

SET XACT_ABORT ON

BEGIN TRANSACTION QUICKDBD

CREATE TABLE [PricingSchema].[Customer] (
    [CustomerID] INT IDENTITY(1,1) NOT NULL ,
    [Name] NVARCHAR(255)  NOT NULL ,
    [Email] NVARCHAR(255)  NOT NULL ,
    [PasswordHash] VARBINARY(256)  NULL , -- It depends on the Hash's form
    [CompanyName] NVARCHAR(255)  NULL ,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED (
        [CustomerID] ASC
    ),
    CONSTRAINT [UK_Customer_Name] UNIQUE (
        [Name]
    ),
    CONSTRAINT [UK_Customer_E-mail] UNIQUE (
        [Email]
    )
)

CREATE TABLE [PricingSchema].[Project] (
    [ProjectID] INT IDENTITY(1,1) NOT NULL ,
    [CustomerID] INT   NOT NULL ,
    [Name] NVARCHAR(255)  NOT NULL ,
    [CompanyName] NVARCHAR(255)  NOT NULL ,
    [CompanyAdress] NVARCHAR(255)  NOT NULL ,
    [CreationDate] DATETIME  DEFAULT GETDATE() ,
    [Deadline] NVARCHAR(255)  NULL ,
    [Comment] NVARCHAR(255)  NULL ,
    [HourlyRate] int   NULL ,
    [Margin] int   NULL ,
    [WorkDayPerMonth] int   NULL ,
    [WorkTimePerDay] int   NULL ,
    [FuelCost] int   NULL ,
    CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED (
        [ProjectID] ASC
    ),
    CONSTRAINT [FK_Project_Customer]
        FOREIGN KEY ([CustomerID])
        REFERENCES [PricingSchema].[Customer]([CustomerID]
    ),
    CONSTRAINT [UK_Project_Customer_Name]
    UNIQUE (CustomerID, Name)
)

CREATE TABLE [PricingSchema].[ProjectCatalog] (
    [HourlyRate] int  NOT NULL ,
    [Margin] int  NOT NULL ,
    [WorkDayPerMonth] int  NOT NULL ,
    [WorkTimePerDay] int  NOT NULL ,
    [FuelCost] int  NOT NULL 
)

CREATE TABLE [PricingSchema].[Product] (
    [ProductID] int  IDENTITY(1,1) NOT NULL ,
    [ProjectID] int   NOT NULL ,
    [Category] NVARCHAR(255)   NULL ,
    [Name] NVARCHAR(255)   NULL ,
    [Type] NVARCHAR(255)  NULL ,
    [Quantity] int  NULL ,
    [QuantityUnit] NVARCHAR(255)   NULL ,
    [Frequency] int   NULL ,
    [UnitPrice] int  NULL , -- Calculated via Trigger (Cross-table)
    [UnitPriceModifier] int  NOT NULL,
    [PricePerSession] AS ([Quantity] * [UnitPrice]) PERSISTED,
    [PricePerYear] AS (([Quantity] * [UnitPrice]) * [Frequency]) PERSISTED,
    [UnitTimePerMin] int   NULL ,
    [UnitTimeModifier] int   NULL DEFAULT 1 ,
    [MaterialCostPerUnit] int  NULL ,
    [MaterialCostPerSession] AS ([Quantity] * [MaterialCostPerUnit]) PERSISTED,
    [MaterialCostPerYear] AS (([Quantity] * [MaterialCostPerUnit]) * [Frequency]) PERSISTED,
    [FuelCostPerUnit] int  NULL , --the machine's fuel needs to work, calculated via trigger (Cross-table)
    [FuelCostPerSession] AS ([Quantity] * [FuelCostPerUnit]) PERSISTED,
    [FuelCostPerYear] AS (([Quantity] * [FuelCostPerUnit]) * [Frequency]) PERSISTED,
    [LaborTimePerSessionInHours] AS ([Quantity] * ([UnitTimePerMin] * [UnitTimeModifier] / 60)) PERSISTED,
    [LaborTimePerYearInHours] AS (([Quantity] * ([UnitTimePerMin] * [UnitTimeModifier] / 60)) * [Frequency]) PERSISTED,
    CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED (
        [ProductID] ASC
    ),
    CONSTRAINT [FK_Product_Project]
        FOREIGN KEY ([ProjectID])
        REFERENCES [PricingSchema].[Project]([ProjectID]
    ),
)

CREATE TABLE [PricingSchema].[ProductCatalog] (
    [ProductCatalogID] int  IDENTITY(1,1) NOT NULL ,
    [Category] NVARCHAR(255)  NOT NULL ,
    [Name] NVARCHAR(255)  NOT NULL ,
    [Type] NVARCHAR(255)  NULL ,
    [QuantityUnit] NVARCHAR(255)  NOT NULL ,
    [UnitPriceModifier] int  NOT NULL ,
    [UnitTimePerMin] int  NOT NULL ,
    [MaterialCostPerUnit] int  NULL ,
    [FuelNeededPerUnit] int  NULL ,
    constRAINT [PK_ProductCatalog] PRIMARY KEY CLUSTERED (
        [ProductCatalogID] ASC
    ),
    CONSTRAINT [UK_ProductCatalog_Category_Name_Type] UNIQUE (
        [Category],
        [Name],
        [Type]
    )   
)


GO

CREATE TRIGGER [trg_Project_Insert]
ON [PricingSchema].[Project]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update Project fields from the single row in ProjectCatalog
    -- We use TOP 1 because ProjectCatalog seems to be a global settings table
    UPDATE pj
    SET 
        pj.HourlyRate = pc.HourlyRate,
        pj.Margin = pc.Margin,
        pj.WorkDayPerMonth = pc.WorkDayPerMonth,
        pj.WorkTimePerDay = pc.WorkTimePerDay,
        pj.FuelCost = pc.FuelCost
    FROM [PricingSchema].[Project] pj
    INNER JOIN [inserted] i ON pj.ProjectID = i.ProjectID
    CROSS JOIN (SELECT TOP 1 * FROM [PricingSchema].[ProjectCatalog]) pc
END
GO

CREATE TRIGGER [trg_Product_Insert]
ON [PricingSchema].[Product]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update Product fields from Catalog if they match Category/Name/Type
    -- This handles the "Cross-table" default value logic
    UPDATE pd
    SET 
        pd.QuantityUnit = pc.QuantityUnit,
        pd.UnitPriceModifier = pc.UnitPriceModifier, 
        pd.MaterialCostPerUnit = pc.MaterialCostPerUnit,
        pd.UnitTimePerMin = pc.UnitTimePerMin
    FROM [PricingSchema].[Product] pd
    INNER JOIN [inserted] i ON pd.ProductID = i.ProductID
    INNER JOIN [PricingSchema].[ProductCatalog] pc ON 
        pd.Category = pc.Category AND 
        pd.Name = pc.Name AND 
        (pd.Type = pc.Type OR (pd.Type IS NULL AND pc.Type IS NULL))
END
GO

CREATE TRIGGER [trg_Product_Calculate]
ON [PricingSchema].[Product]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE pd
    SET 
        pd.UnitPrice = ( 100 * ( pd.UnitTimePerMin * pj.HourlyRate * pd.UnitPriceModifier + pd.MaterialCostPerUnit + pd.FuelCostPerUnit ) ) / ( 100 - pj.Margin ),
        pd.FuelCostPerUnit = pc.FuelNeededPerUnit * pj.FuelCost
    FROM [PricingSchema].[Product] pd
    INNER JOIN [inserted] i ON pd.ProductID = i.ProductID
    INNER JOIN [PricingSchema].[Project] pj ON 
        pd.ProjectID = pj.ProjectID
    INNER JOIN [PricingSchema].[ProductCatalog] pc ON 
        pd.Category = pc.Category AND 
        pd.Name = pc.Name AND 
        (pd.Type = pc.Type OR (pd.Type IS NULL AND pc.Type IS NULL))
END
GO  

COMMIT TRANSACTION QUICKDBD