using PokemonApp.API.DTOs;

namespace PokemonApp.API.Interfaces;

public interface IPokemonService
{
    Task<IEnumerable<PokemonDto>> GetAllAsync();
    Task<PokemonDto?> GetByIdAsync(int id);
    Task<PokemonDto> CreateAsync(CreatePokemonDto dto);
    Task<PokemonDto?> UpdateAsync(int id, UpdatePokemonDto dto);
    Task<bool> DeleteAsync(int id);
}
