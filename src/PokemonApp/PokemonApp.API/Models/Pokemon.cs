namespace PokemonApp.API.Models;

public class Pokemon
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public PokemonType Type { get; set; }
    public int DefensePoints { get; set; }
    public int HealthPoints { get; set; }
    public double RarityPercentage { get; set; }
    public string? ImageURL { get; set; }

    // Navigation property
    public ICollection<Attack> Attacks { get; set; } = new List<Attack>();
}
