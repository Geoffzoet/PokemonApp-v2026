using System.ComponentModel.DataAnnotations;

namespace PokemonApp.MVC.Models;

public class Trainer
{
    public int Id { get; set; }

    [Required]
    [MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    [Required]
    [MaxLength(100)]
    public string Town { get; set; } = string.Empty;

    [Range(0, 8)]
    public int BadgeCount { get; set; }

    public ICollection<CaughtPokemon> Team { get; set; } = new List<CaughtPokemon>();
}
