namespace GardeningTenderCalculator.Models
{
    public partial class Product
    {
        public int ProductID { get; set; }
        public int ProjectID { get; set; }
        public string Category { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public int Quantity { get; set; }
        public string QuantityUnit { get; set; }
        public int Frequency { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal UnitPriceModifier { get; set; }
        public decimal PricePerSession { get; set; }
        public decimal PricePerYear { get; set; }
        public decimal UnitTimePerMin { get; set; }
        public decimal UnitTimeModifier { get; set; }
        public decimal MaterialCostPerUnit { get; set; }
        public decimal MaterialCostPerSession { get; set; }
        public decimal MaterialCostPerYear { get; set; }
        public decimal FuelCostPerUnit { get; set; }
        public decimal FuelCostPerSession { get; set; }
        public decimal FuelCostPerYear { get; set; }
        public decimal LaborTimePerSessionInHours { get; set; }
        public decimal LaborTimePerYearInHours { get; set; }

        public Product()
        {
            if(Category == null)
            {
                Category = "";
            }
            if(Name == null)
            {
                Name = "";
            }
            if(Type == null)
            {
                Type = "";
            }
            if(QuantityUnit == null)
            {
                QuantityUnit = "";
            }
        }
    }
}