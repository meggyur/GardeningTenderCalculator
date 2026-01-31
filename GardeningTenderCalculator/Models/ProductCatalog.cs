namespace GardeningTenderCalculator
{
    public partial class ProductCatalog
    {
        public int ProductCatalogID { get; set; }
        public string Category { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public string QuantityUnit { get; set; }
        public int UnitPriceModifier { get; set; }
        public int UnitTimePerMin { get; set; }
        public int MaterialCostPerUnit { get; set; }
        public int FuelNeededPerUnit { get; set; }

        public ProductCatalog()
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