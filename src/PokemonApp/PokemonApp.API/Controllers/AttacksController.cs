using Microsoft.AspNetCore.Mvc;
using PokemonApp.API.DTOs;

namespace PokemonApp.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AttacksController : ControllerBase
{
    /// <summary>
    /// Retrieves all available attacks
    /// </summary>
    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<AttackDto>), StatusCodes.Status200OK)]
    public IActionResult GetAll()
    {
        // Hardcoded list of available attacks for Pokemon
        var attacks = new List<AttackDto>
        {
            new AttackDto { Name = "Charge", Points = 40 },
            new AttackDto { Name = "Éclair", Points = 55 },
            new AttackDto { Name = "Vive-Attaque", Points = 40 },
            new AttackDto { Name = "Tonnerre", Points = 90 },
            new AttackDto { Name = "Fatal-Foudre", Points = 110 },
            new AttackDto { Name = "Lance-Flammes", Points = 90 },
            new AttackDto { Name = "Flammèche", Points = 40 },
            new AttackDto { Name = "Déflagration", Points = 110 },
            new AttackDto { Name = "Hydrocanon", Points = 110 },
            new AttackDto { Name = "Pistolet à O", Points = 40 },
            new AttackDto { Name = "Surf", Points = 90 },
            new AttackDto { Name = "Tranch'Herbe", Points = 55 },
            new AttackDto { Name = "Fouet Lianes", Points = 45 },
            new AttackDto { Name = "Lance-Soleil", Points = 120 },
            new AttackDto { Name = "Cru-Aile", Points = 60 },
            new AttackDto { Name = "Tornade", Points = 40 },
            new AttackDto { Name = "Piqué", Points = 90 },
            new AttackDto { Name = "Plaquage", Points = 85 },
            new AttackDto { Name = "Griffe", Points = 40 },
            new AttackDto { Name = "Morsure", Points = 60 }
        };

        return Ok(attacks);
    }
}
