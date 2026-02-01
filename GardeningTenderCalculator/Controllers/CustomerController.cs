using Microsoft.AspNetCore.Mvc;
using GardeningTenderCalculator.DTOs;
using GardeningTenderCalculator.Data;


namespace Controllers.CustomerController
{
    
    [ApiController]
    [Route("[controller]")]
    public class CustomerController : ControllerBase
    {
        private readonly DataContextDapper _daper;

        public CustomerController(IConfiguration config)
        {
            _daper = new DataContextDapper(config);
        }

        
        [HttpPost("CreateNewCustomer")]
        public IActionResult CreateNewCustomer(CustomerDTO customer)
        {
            string sql = @"INSERT INTO PricingSchema.Customer(  
                [Name],
                [Email],
                [CompanyName]
                ) VALUES (
                    @Name,
                    @Email,
                    @CompanyName)";

            Console.WriteLine(sql, customer);

            if( _daper.ExecuteSql<object>(sql, customer))
            {
                return Ok();
            }
         throw new Exception("Failed to add a new customer");   
        }



        

        

    }
}