using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PokemonApp.API.DTOs;
using PokemonApp.API.Interfaces;

namespace PokemonApp.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    private readonly IPokemonService _pokemonService;
    private readonly ILogger<PokemonController> _logger;

    public PokemonController(IPokemonService pokemonService, ILogger<PokemonController> logger)
    {
        _pokemonService = pokemonService;
        _logger = logger;
    }

    /// <summary>
    /// Retrieves all Pokemon
    /// </summary>
    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<PokemonDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetAll()
    {
        try
        {
            var pokemon = await _pokemonService.GetAllAsync();
            return Ok(pokemon);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching all Pokemon");
            return StatusCode(500, new { message = "An error occurred while fetching Pokemon" });
        }
    }

    /// <summary>
    /// Retrieves a specific Pokemon by ID
    /// </summary>
    [HttpGet("{id}")]
    [ProducesResponseType(typeof(PokemonDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(int id)
    {
        var pokemon = await _pokemonService.GetByIdAsync(id);

        if (pokemon == null)
        {
            return NotFound(new { message = $"Pokémon avec l'ID {id} introuvable" });
        }

        return Ok(pokemon);
    }

    /// <summary>
    /// Creates a new Pokemon
    /// </summary>
    [HttpPost]
    // [Authorize(Roles = "Admin")] // Disabled for frontend compatibility
    [ProducesResponseType(typeof(PokemonDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    // [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    // [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> Create([FromBody] CreatePokemonDto dto)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        try
        {
            var created = await _pokemonService.CreateAsync(dto);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating Pokemon");
            return StatusCode(500, new { message = "An error occurred while creating Pokemon" });
        }
    }

    /// <summary>
    /// Updates an existing Pokemon
    /// </summary>
    [HttpPut("{id}")]
    // [Authorize(Roles = "Admin")] // Disabled for frontend compatibility
    [ProducesResponseType(typeof(PokemonDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    // [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    // [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(int id, [FromBody] UpdatePokemonDto dto)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        try
        {
            var updated = await _pokemonService.UpdateAsync(id, dto);

            if (updated == null)
            {
                return NotFound(new { message = $"Pokémon avec l'ID {id} introuvable" });
            }

            return Ok(updated);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating Pokemon with ID {Id}", id);
            return StatusCode(500, new { message = "An error occurred while updating Pokemon" });
        }
    }

    /// <summary>
    /// Deletes a Pokemon
    /// </summary>
    [HttpDelete("{id}")]
    // [Authorize(Roles = "Admin")] // Disabled for frontend compatibility
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    // [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    // [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(int id)
    {
        var deleted = await _pokemonService.DeleteAsync(id);

        if (!deleted)
        {
            return NotFound(new { message = $"Pokémon avec l'ID {id} introuvable" });
        }

        return NoContent();
    }
}
