namespace Controllers
{
    using System.Data.Common;
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
        public DateTime TestConnection()
        {
            return _daper.LoadDataSingle<DateTime>("SELECT GETDATE()");
        }

    }
}