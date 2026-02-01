using GardeningTenderCalculator.Data;
using GardeningTenderCalculator.DTOs;
using Microsoft.AspNetCore.Mvc;

namespace Controllers.ProjectController    
 {
    [ApiController]
    [Route("[controller]")]

    public class ProjectController : ControllerBase
    {
    
    private readonly DataContextDapper _daper;

    public ProjectController(IConfiguration config)
    {
        _daper = new DataContextDapper(config);
    }
    
    [HttpPost("AddNewProject")]
            public IActionResult AddNewProject(ProjectDTO project)
            {
                string sql = @"INSERT INTO PricingSchema.Project(
                    [CustomerId],
                    [Name],
                    [CompanyName],
                    [CompanyAdress],
                    [Deadline],
                    [Comment]
                    ) VALUES (
                        @CustomerId,
                        @Name,
                        @CompanyName,
                        @CompanyAdress,
                        @Deadline,
                        @Comment)";

                Console.WriteLine(sql, project);

                if( _daper.ExecuteSql<object>(sql, project))
                {
                    return Ok();
                }
            throw new Exception("Failed to add project catalog values");   
            }
    }
 }