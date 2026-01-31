namespace GardeningTenderCalculator
{
    public partial class Customer
    {
        public int CustomerID { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }
        public string CompanyName { get; set; }

        public Customer()
        {
            if(Name == null)
            {
                Name = "";
            }
            if(Email == null)
            {
                Email = "";
            }
            if(PasswordHash == null)
            {
                PasswordHash = "";
            }
            if(CompanyName == null)
            {
                CompanyName = "";
            }
            
        }
    }
}