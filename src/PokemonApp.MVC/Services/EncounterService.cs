using Microsoft.EntityFrameworkCore;
using PokemonApp.MVC.Data;
using PokemonApp.MVC.Models;

namespace PokemonApp.MVC.Services;

public class EncounterService : IEncounterService
{
    private readonly AppDbContext _context;
    private readonly Random _random;

    public EncounterService(AppDbContext context)
    {
        _context = context;
        _random = new Random();
    }

    public async Task<Pokemon?> GetRandomWildPokemonAsync()
    {
        var allPokemons = await _context.Pokemons
            .Include(p => p.Attacks)
            .ToListAsync();

        if (!allPokemons.Any())
            return null;

        // Weighted random selection based on rarity percentage
        var totalWeight = allPokemons.Sum(p => p.RarityPercentage);
        var randomValue = _random.NextDouble() * totalWeight;

        double cumulativeWeight = 0;
        foreach (var pokemon in allPokemons)
        {
            cumulativeWeight += pokemon.RarityPercentage;
            if (randomValue <= cumulativeWeight)
            {
                return pokemon;
            }
        }

        // Fallback to last pokemon if something goes wrong
        return allPokemons.Last();
    }
}
