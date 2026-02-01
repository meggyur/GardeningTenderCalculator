namespace GardeningTenderCalculator.Models
{
    public partial class ProjectCatalog
    {
        public int HourlyRate { get; set; }
        public decimal Margin { get; set; }
        public int WorkDayPerMonth { get; set; }
        public decimal WorkTimePerDay { get; set; }
        public decimal FuelCost { get; set; }
    }
}   