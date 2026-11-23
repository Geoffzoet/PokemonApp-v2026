using PokemonApp.API.DTOs;
using PokemonApp.API.Extensions;
using PokemonApp.API.Interfaces;
using PokemonApp.API.Models;

namespace PokemonApp.API.Services;

public class PokemonService : IPokemonService
{
    private readonly IPokemonRepository _repository;
    private readonly ILogger<PokemonService> _logger;

    public PokemonService(IPokemonRepository repository, ILogger<PokemonService> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    public async Task<IEnumerable<PokemonDto>> GetAllAsync()
    {
        _logger.LogInformation("Fetching all Pokemon");
        var pokemon = await _repository.GetAllAsync();
        return pokemon.Select(p => p.ToDto());
    }

    public async Task<PokemonDto?> GetByIdAsync(int id)
    {
        _logger.LogInformation("Fetching Pokemon with ID {Id}", id);
        var pokemon = await _repository.GetByIdAsync(id);
        return pokemon?.ToDto();
    }

    public async Task<PokemonDto> CreateAsync(CreatePokemonDto dto)
    {
        _logger.LogInformation("Creating new Pokemon: {Name}", dto.Name);

        // Convert DTO to entity
        var pokemon = dto.ToEntity();

        var created = await _repository.AddAsync(pokemon);
        return created.ToDto();
    }

    public async Task<PokemonDto?> UpdateAsync(int id, UpdatePokemonDto dto)
    {
        _logger.LogInformation("Updating Pokemon with ID {Id}", id);

        var pokemon = await _repository.GetByIdAsync(id);
        if (pokemon == null)
        {
            return null;
        }

        // Update properties
        pokemon.Name = dto.Name;
        pokemon.Type = Enum.Parse<PokemonType>(dto.Type);
        pokemon.DefensePoints = dto.DefensePoints;
        pokemon.HealthPoints = dto.HealthPoints;
        pokemon.RarityPercentage = dto.RarityPercentage;
        pokemon.ImageURL = dto.ImageURL;

        // Replace attacks
        pokemon.Attacks.Clear();
        foreach (var attackDto in dto.Attacks)
        {
            pokemon.Attacks.Add(new Attack
            {
                Name = attackDto.Name,
                Points = attackDto.Points,
                PokemonId = pokemon.Id
            });
        }

        await _repository.UpdateAsync(pokemon);
        return pokemon.ToDto();
    }

    public async Task<bool> DeleteAsync(int id)
    {
        _logger.LogInformation("Deleting Pokemon with ID {Id}", id);

        var pokemon = await _repository.GetByIdAsync(id);
        if (pokemon == null)
        {
            return false;
        }

        await _repository.DeleteAsync(pokemon);
        return true;
    }
}
