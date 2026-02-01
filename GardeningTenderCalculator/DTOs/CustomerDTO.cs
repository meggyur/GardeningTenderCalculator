namespace GardeningTenderCalculator.DTOs
{
    public partial class CustomerDTO
    {
        public string Name { get; set; }
        public string Email { get; set; }
        public string CompanyName { get; set; }

        public CustomerDTO()
        {
            if(Name == null)
            {
                Name = "";
            }
            if(Email == null)
            {
                Email = "";
            }
            if(CompanyName == null)
            {
                CompanyName = "";
            }
            
        }
    }
}