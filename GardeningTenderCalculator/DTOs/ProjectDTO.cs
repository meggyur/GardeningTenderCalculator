namespace GardeningTenderCalculator.DTOs
{
    public partial class ProjectDTO
    {
        public int CustomerId { get; set; }
        public string Name { get; set; }
        public string CompanyName { get; set; }
        public string CompanyAdress { get; set; }
        public string Deadline { get; set; }
        public string Comment { get; set; }

        public ProjectDTO()
        {
            if(CustomerId == 0)
            {
                CustomerId = 1;
            }
            if(Name == null)
            {
                Name = "";
            }
            if(CompanyName == null)
            {
                CompanyName = "";
            }
            if(CompanyAdress == null)
            {
                CompanyAdress = "";
            }
            if(Deadline == null)
            {
                Deadline = "";
            }
            if(Comment == null)
            {
                Comment = "";
            }
        }
    }
}