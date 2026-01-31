namespace GardeningTenderCalculator
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
        public int UnitPrice { get; set; }
        public int UnitPriceModifier { get; set; }
        public int PricePerSession { get; set; }
        public int PricePerYear { get; set; }
        public int UnitTimePerMin { get; set; }
        public int UnitTimeModifier { get; set; }
        public int MaterialCostPerUnit { get; set; }
        public int MaterialCostPerSession { get; set; }
        public int MaterialCostPerYear { get; set; }
        public int FuelCostPerUnit { get; set; }
        public int FuelCostPerSession { get; set; }
        public int FuelCostPerYear { get; set; }
        public int LaborTimePerSessionInHours { get; set; }
        public int LaborTimePerYearInHours { get; set; }

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