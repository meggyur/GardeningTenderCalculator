using GardeningTenderCalculator.Data;
using GardeningTenderCalculator.DTOs;
using Microsoft.AspNetCore.Mvc;

namespace GardeningTenderCalculator.Controllers
{
    [ApiController]
    [Route("controller")]

    public class ProductController : ControllerBase
    {
        private readonly DataContextDapper _daper;

        public ProductController(IConfiguration config)
        {
            _daper = new DataContextDapper(config);
        }

        [HttpPost("AddNewProduct")]
        public IActionResult AddNewProduct(ProductDTO product)
        {
            string sql = @"INSERT INTO PricingSchema.Product(
                [ProjectId],
                [Category],
                [Name],
                [Type],
                [Quantity],
                [Frequency]
                ) VALUES (
                    @ProjectId,
                    @Category,
                    @Name,
                    @Type,
                    @Quantity,
                    @Frequency)";

            Console.WriteLine(sql, product);

            if( _daper.ExecuteSql<object>(sql, product))
            {
                return Ok();
            }
         throw new Exception("Failed to add product");   
        }
    }
}