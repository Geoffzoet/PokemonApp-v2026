namespace PokemonApp.API.DTOs;

public class UpdatePokemonDto
{
    public string Name { get; set; } = string.Empty;
    public string Type { get; set; } = string.Empty;
    public List<AttackDto> Attacks { get; set; } = new();
    public int DefensePoints { get; set; }
    public int HealthPoints { get; set; }
    public double RarityPercentage { get; set; }
    public string? ImageURL { get; set; }
}
