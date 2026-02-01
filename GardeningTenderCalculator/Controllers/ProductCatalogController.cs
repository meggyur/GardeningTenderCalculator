using Microsoft.AspNetCore.Mvc;
using GardeningTenderCalculator.DTOs;
using GardeningTenderCalculator.Data;


namespace Controllers.ProductCatalogController
{
    
    [ApiController]
    [Route("[controller]")]
    public class ProductCatalogController : ControllerBase
    {
        private readonly DataContextDapper _daper;

        public ProductCatalogController(IConfiguration config)
        {
            _daper = new DataContextDapper(config);
        }

        [HttpPost("AddProductCatalogValues")]
        public IActionResult AddProductCatalogValues(ProductCatalogDTO productCatalog)
        {
            string sql = @"INSERT INTO PricingSchema.ProductCatalog( 
                [Category],
                [Name],
                [Type],
                [QuantityUnit],
                [UnitPriceModifier],
                [UnitTimePerMin],
                [MaterialCostPerUnit],
                [FuelNeededPerUnit]
                ) VALUES ( 
                    @Category,
                    @Name,
                    @Type,
                    @QuantityUnit,
                    @UnitPriceModifier,
                    @UnitTimePerMin,
                    @MaterialCostPerUnit,
                    @FuelNeededPerUnit
                    )";

            Console.WriteLine(sql, productCatalog);

            if( _daper.ExecuteSql<object>(sql, productCatalog))
            {
                return Ok();
            }
         throw new Exception("Failed to add project catalog values");   
        }

        

        

    }
}