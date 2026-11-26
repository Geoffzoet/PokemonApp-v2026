using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll()
    {
        return Ok(new {message = "Pokemon endpoint is working great!"});
    }

    [HttpGet("{id}")]
    public IActionResult GetById(int id)
    {
        return Ok(new {message = "Pokemon ${id} has been caught!"});
    }

    [HttpPost]
    public IActionResult Create([FromBody] CreatePokemonDto dto)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);  // Returns 400 with validation errors
        }

        // Process valid data
    }
}