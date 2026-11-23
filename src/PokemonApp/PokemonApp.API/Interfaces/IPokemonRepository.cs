using PokemonApp.API.Models;

namespace PokemonApp.API.Interfaces;

public interface IPokemonRepository
{
    Task<IEnumerable<Pokemon>> GetAllAsync();
    Task<Pokemon?> GetByIdAsync(int id);
    Task<Pokemon> AddAsync(Pokemon pokemon);
    Task UpdateAsync(Pokemon pokemon);
    Task DeleteAsync(Pokemon pokemon);
    Task<bool> ExistsAsync(int id);
}
