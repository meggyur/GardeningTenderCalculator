namespace GardeningTenderCalculator
{
    public partial class Project
    {
        public int ProjectID { get; set; }
        public int CustomerID { get; set; }
        public string Name { get; set; }
        public string CompanyName { get; set; }
        public string CompanyAdress { get; set; }
        public DateTime CreationDate { get; set; }
        public DateTime Deadline { get; set; }
        public string Comment { get; set; }
        public int HourlyRate { get; set; }
        public int Margin { get; set; }
        public int WorkDayPerMonth { get; set; }
        public int WorkTimePerDay { get; set; }
        public int FuelCost { get; set; }

        public Project()
        {
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
            if(CreationDate == null)
            {
                CreationDate = DateTime.Now;
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