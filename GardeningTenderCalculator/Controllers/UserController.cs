namespace Controllers
{
    using Data;
    using Microsoft.AspNetCore.Mvc;
    
    [ApiController]
    [Route("[controller]")]
    public class UserController : ControllerBase
    {
        private readonly DataContextDapper _daper;

        public UserController(IConfiguration config)
        {
            _daper = new DataContextDapper(config);
        }

        [HttpGet("TestConnection")]
        public ActionResult<string> TestConnection()
        {
            return Ok("Connection successful");
        }

    }
}