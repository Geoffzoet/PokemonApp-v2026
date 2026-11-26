using System.ComponentModel.DataAnnotations;

namespace PokemonApp.MVC.Models;

public class CaughtPokemon
{
    public int Id { get; set; }

    public int TrainerId { get; set; }
    public Trainer Trainer { get; set; } = null!;

    public int PokemonId { get; set; }
    public Pokemon Pokemon { get; set; } = null!;

    [MaxLength(50)]
    public string? Nickname { get; set; }

    public DateTime CaughtAt { get; set; } = DateTime.Now;

    public BallType BallUsed { get; set; }
}
