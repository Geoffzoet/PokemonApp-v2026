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
}