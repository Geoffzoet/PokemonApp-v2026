using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MyApp.Namespace
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        [HttpGet]
        public IActionResult GetAll()
        {
            return Ok(new []{"Product 1","Product 2","Product 3"});
        }

        [HttpGet("{id}")]
        public IActionResult GetById(int id)
        {
            return Ok($"Product {id}");
        }
    }
}
