CREATE DATABASE GardeningTenderCalculatorDatabase
GO

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

CREATE TABLE [PricingSchema].[Auth](
    [Email] NVARCHAR(255)  NULL ,
    [PasswordHash] VARBINARY(MAX)  NULL ,
    [PasswordSalt] VARBINARY(MAX)  NULL
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
    [Margin] decimal(18,2)  NULL ,
    [WorkDayPerMonth] int  NULL ,
    [WorkTimePerDay] decimal(18,2)  NULL ,
    [FuelCost] decimal(18,2)  NULL ,
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
    [Margin] decimal(18,2)  NOT NULL ,
    [WorkDayPerMonth] int  NOT NULL ,
    [WorkTimePerDay] decimal(18,2)  NOT NULL ,
    [FuelCost] decimal(18,2)  NOT NULL 
)

CREATE TABLE [PricingSchema].[Product] (
    [ProductID] int  IDENTITY(1,1) NOT NULL ,
    [ProjectID] int  NOT NULL ,
    [Category] NVARCHAR(255)  NULL ,
    [Name] NVARCHAR(255)  NULL ,
    [Type] NVARCHAR(255)  NULL ,
    [Quantity] int  NULL ,
    [QuantityUnit] NVARCHAR(255)  NULL , -- Copyed data via trigger
    [Frequency] int   NULL ,
    [UnitPrice] decimal(18,2)  NULL , -- Calculated via Trigger (Cross-table)
    [UnitPriceModifier] decimal(18,2)  NULL, -- Copyed data via trigger
    [PricePerSession]  AS (CAST([Quantity] * [UnitPrice] AS decimal(18,2))) PERSISTED,
    [PricePerYear]  AS (CAST([Quantity] * [UnitPrice] * [Frequency] AS decimal(18,2))) PERSISTED,
    [UnitTimePerMin] decimal(18,2)  NULL , -- Copyed data via trigger
    [UnitTimeModifier] decimal(18,2)  NULL DEFAULT 1 ,
    [MaterialCostPerUnit] decimal(18,2)  NULL , -- Copyed data via trigger
    [MaterialCostPerSession]  AS (CAST([Quantity] * [MaterialCostPerUnit] AS decimal(18,2))) PERSISTED,
    [MaterialCostPerYear]  AS (CAST(([Quantity] * [MaterialCostPerUnit]) * [Frequency] AS decimal(18,2))) PERSISTED,
    [FuelCostPerUnit] decimal(18,2)  NULL , --the machine's fuel needs to work, calculated via trigger (Cross-table)
    [FuelCostPerSession]  AS (CAST([Quantity] * [FuelCostPerUnit] AS decimal(18,2))) PERSISTED,
    [FuelCostPerYear]  AS (CAST(([Quantity] * [FuelCostPerUnit]) * [Frequency] AS decimal(18,2))) PERSISTED,
    [LaborTimePerSessionInHours]  AS (CAST([Quantity] * ([UnitTimePerMin] * [UnitTimeModifier] / 60) AS decimal(18,2))) PERSISTED,
    [LaborTimePerYearInHours]  AS (CAST(([Quantity] * ([UnitTimePerMin] * [UnitTimeModifier] / 60)) * [Frequency] AS decimal(18,2))) PERSISTED,
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
    [UnitPriceModifier] decimal(18,2)  NOT NULL ,
    [UnitTimePerMin] decimal(18,2)  NOT NULL ,
    [MaterialCostPerUnit] decimal(18,2)  NULL ,
    [FuelNeededPerUnit] decimal(18,6)  NULL ,
    CONSTRAINT [PK_ProductCatalog] PRIMARY KEY CLUSTERED (
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
        pd.FuelCostPerUnit = CAST(pc.FuelNeededPerUnit * pj.FuelCost AS decimal(18,2)),
        pd.UnitPrice = CAST(( 100 * ( pd.UnitTimePerMin/60 * pj.HourlyRate * pd.UnitPriceModifier + pd.MaterialCostPerUnit + pd.FuelCostPerUnit ) ) / ( 100 - pj.Margin ) AS decimal(18,6))
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