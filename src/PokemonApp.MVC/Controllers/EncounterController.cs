using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using PokemonApp.MVC.Data;
using PokemonApp.MVC.Models;
using PokemonApp.MVC.Services;

namespace PokemonApp.MVC.Controllers;

public class EncounterController : Controller
{
    private readonly AppDbContext _context;
    private readonly IEncounterService _encounterService;
    private readonly ICaptureService _captureService;

    public EncounterController(
        AppDbContext context,
        IEncounterService encounterService,
        ICaptureService captureService)
    {
        _context = context;
        _encounterService = encounterService;
        _captureService = captureService;
    }

    // GET: Encounter/Wild
    public async Task<IActionResult> Wild()
    {
        var wildPokemon = await _encounterService.GetRandomWildPokemonAsync();

        if (wildPokemon == null)
        {
            TempData["ErrorMessage"] = "Aucun Pokémon sauvage trouvé dans la base de données.";
            return RedirectToAction("Index", "Trainer");
        }

        // Get list of trainers for dropdown
        ViewBag.Trainers = new SelectList(
            await _context.Trainers.ToListAsync(),
            "Id",
            "Name"
        );

        return View(wildPokemon);
    }

    // POST: Encounter/Capture
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Capture(int trainerId, int pokemonId, BallType ballType, string? nickname)
    {
        var trainer = await _context.Trainers.FindAsync(trainerId);
        var pokemon = await _context.Pokemons.FindAsync(pokemonId);

        if (trainer == null || pokemon == null)
        {
            TempData["ErrorMessage"] = "Dresseur ou Pokémon introuvable.";
            return RedirectToAction(nameof(Wild));
        }

        // Attempt capture
        bool captureSuccess = _captureService.TryCapture(pokemon, ballType);

        if (captureSuccess)
        {
            // Create CaughtPokemon
            var caughtPokemon = new CaughtPokemon
            {
                TrainerId = trainerId,
                PokemonId = pokemonId,
                Nickname = nickname,
                BallUsed = ballType,
                CaughtAt = DateTime.Now
            };

            _context.CaughtPokemons.Add(caughtPokemon);
            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = $"Bravo ! {pokemon.Name} a été capturé avec succès avec {ballType} !";
            return RedirectToAction("Details", "Trainer", new { id = trainerId });
        }
        else
        {
            TempData["ErrorMessage"] = $"Oh non ! {pokemon.Name} s'est échappé de la {ballType}...";
            return RedirectToAction(nameof(Wild));
        }
    }
}
