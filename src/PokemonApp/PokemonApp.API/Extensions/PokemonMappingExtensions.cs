using PokemonApp.API.DTOs;
using PokemonApp.API.Models;

namespace PokemonApp.API.Extensions;

public static class PokemonMappingExtensions
{
    public static PokemonDto ToDto(this Pokemon pokemon)
    {
        return new PokemonDto
        {
            Id = pokemon.Id,
            Name = pokemon.Name,
            Type = pokemon.Type.ToString(),
            Attacks = pokemon.Attacks.Select(a => new AttackDto
            {
                Name = a.Name,
                Points = a.Points
            }).ToList(),
            DefensePoints = pokemon.DefensePoints,
            HealthPoints = pokemon.HealthPoints,
            RarityPercentage = pokemon.RarityPercentage,
            ImageURL = pokemon.ImageURL
        };
    }

    public static Pokemon ToEntity(this CreatePokemonDto dto)
    {
        return new Pokemon
        {
            Name = dto.Name,
            Type = Enum.Parse<PokemonType>(dto.Type),
            DefensePoints = dto.DefensePoints,
            HealthPoints = dto.HealthPoints,
            RarityPercentage = dto.RarityPercentage,
            ImageURL = dto.ImageURL,
            Attacks = dto.Attacks.Select(a => new Attack
            {
                Name = a.Name,
                Points = a.Points
            }).ToList()
        };
    }
}
