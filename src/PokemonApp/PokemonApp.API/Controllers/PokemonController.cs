using Microsoft.AspNetCore.Mvc;

namespace PokemonApp.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll()
    {
        return Ok(new { message = "GetAll Pokemon endpoint" });
    }

    [HttpGet("{id}")]
    public IActionResult GetById(int id)
    {
        return Ok(new { message = $"GetById Pokemon endpoint - ID: {id}" });
    }

    [HttpPost]
    public IActionResult Create()
    {
        return Ok(new { message = "Create Pokemon endpoint" });
    }

    [HttpPut("{id}")]
    public IActionResult Update(int id)
    {
        return Ok(new { message = $"Update Pokemon endpoint - ID: {id}" });
    }

    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        return Ok(new { message = $"Delete Pokemon endpoint - ID: {id}" });
    }
}
