    namespace GardeningTenderCalculator.DTOs
{
    public partial class ProductCatalogDTO
    {
        public string Category { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public string QuantityUnit { get; set; }
        public decimal UnitPriceModifier { get; set; }
        public decimal UnitTimePerMin { get; set; }
        public decimal MaterialCostPerUnit { get; set; }
        public decimal FuelNeededPerUnit { get; set; }

        public ProductCatalogDTO()
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