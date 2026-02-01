using Microsoft.AspNetCore.Mvc;
using GardeningTenderCalculator.Models;
using GardeningTenderCalculator.Data;


namespace Controllers.ProjectCatalogController
{
    
    [ApiController]
    [Route("[controller]")]
    public class ProjectCatalogController : ControllerBase
    {
        private readonly DataContextDapper _daper;

        public ProjectCatalogController(IConfiguration config)
        {
            _daper = new DataContextDapper(config);
        }

        [HttpPost("AddProjectCatalogValues")]
        public IActionResult AddProjectCatalogValues(ProjectCatalog projectCatalog)
        {
            string sql = @"INSERT INTO PricingSchema.ProjectCatalog( 
                [HourlyRate],
                [Margin],
                [WorkDayPerMonth],
                [WorkTimePerDay],
                [FuelCost]
                ) VALUES (
                    @HourlyRate,
                    @Margin,
                    @WorkDayPerMonth,
                    @WorkTimePerDay,
                    @FuelCost)";

            Console.WriteLine(sql, projectCatalog);

            if( _daper.ExecuteSql<object>(sql, projectCatalog))
            {
                return Ok();
            }
         throw new Exception("Failed to add project catalog values");   
        }

        

        

    }
}