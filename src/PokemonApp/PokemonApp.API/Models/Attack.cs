namespace PokemonApp.API.Models;

public class Attack
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public int Points { get; set; }

    // Foreign key
    public int PokemonId { get; set; }
    public Pokemon Pokemon { get; set; } = null!;
}
