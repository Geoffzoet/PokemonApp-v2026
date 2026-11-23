using Microsoft.AspNetCore.Mvc;

namespace PokemonApp.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    /// <summary>
    /// Get all Pokemon - Returns 200 OK
    /// </summary>
    [HttpGet]
    public IActionResult GetAll()
    {
        // TODO: Will implement with database later
        var pokemon = new[] { new { id = 1, name = "Pikachu" } };
        return Ok(pokemon);  // 200 OK
    }

    /// <summary>
    /// Get Pokemon by ID - Returns 200 OK or 404 Not Found
    /// </summary>
    [HttpGet("{id}")]
    public IActionResult GetById(int id)
    {
        // TODO: Will implement with database later
        // Simulate not found for demonstration
        if (id > 100)
        {
            return NotFound(new { message = $"Pokémon avec l'ID {id} introuvable" });  // 404 Not Found
        }

        var pokemon = new { id, name = "Pikachu" };
        return Ok(pokemon);  // 200 OK
    }

    /// <summary>
    /// Create new Pokemon - Returns 201 Created with Location header
    /// </summary>
    [HttpPost]
    public IActionResult Create()
    {
        // TODO: Will implement with database and DTO later
        var newPokemon = new { id = 1, name = "Pikachu" };

        // 201 Created with Location header pointing to the new resource
        return CreatedAtAction(nameof(GetById), new { id = newPokemon.id }, newPokemon);
    }

    /// <summary>
    /// Update Pokemon - Returns 200 OK or 404 Not Found
    /// </summary>
    [HttpPut("{id}")]
    public IActionResult Update(int id)
    {
        // TODO: Will implement with database and DTO later
        // Simulate not found for demonstration
        if (id > 100)
        {
            return NotFound(new { message = $"Pokémon avec l'ID {id} introuvable" });  // 404 Not Found
        }

        var updatedPokemon = new { id, name = "Pikachu Updated" };
        return Ok(updatedPokemon);  // 200 OK
    }

    /// <summary>
    /// Delete Pokemon - Returns 204 No Content or 404 Not Found
    /// </summary>
    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        // TODO: Will implement with database later
        // Simulate not found for demonstration
        if (id > 100)
        {
            return NotFound(new { message = $"Pokémon avec l'ID {id} introuvable" });  // 404 Not Found
        }

        return NoContent();  // 204 No Content (successful deletion, no body)
    }
}
