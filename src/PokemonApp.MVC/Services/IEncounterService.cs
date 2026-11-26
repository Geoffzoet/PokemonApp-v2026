using PokemonApp.MVC.Models;

namespace PokemonApp.MVC.Services;

public interface IEncounterService
{
    Task<Pokemon?> GetRandomWildPokemonAsync();
}
