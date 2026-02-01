namespace GardeningTenderCalculator.DTOs
{
    public partial class ProductDTO
    {
        public int ProjectId { get; set; }
        public string Category { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public int Quantity { get; set; }
        public int Frequency { get; set; }

        public ProductDTO()
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
        }
    }
}