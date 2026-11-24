using System.ComponentModel.DataAnnotations;

namespace PokemonApp.API.DTOs;

public class CreatePokemonDto
{
    [Required(ErrorMessage = "Le nom est obligatoire")]
    [StringLength(50, MinimumLength = 1, ErrorMessage = "Le nom doit contenir entre 1 et 50 caractères")]
    public string Name { get; set; } = string.Empty;

    [Required(ErrorMessage = "Le type est obligatoire")]
    [RegularExpression("NORMAL|FIRE|WATER|GRASS|ELECTRIC|ICE|FIGHTING|POISON|GROUND|FLYING|PSYCHIC|BUG|ROCK|GHOST|DRAGON|DARK|STEEL|FAIRY",
        ErrorMessage = "Le type doit être l'un des suivants: NORMAL, FIRE, WATER, GRASS, ELECTRIC, ICE, FIGHTING, POISON, GROUND, FLYING, PSYCHIC, BUG, ROCK, GHOST, DRAGON, DARK, STEEL, FAIRY")]
    public string Type { get; set; } = string.Empty;

    [Required(ErrorMessage = "Au moins une attaque est requise")]
    [MinLength(1, ErrorMessage = "Au moins une attaque est requise")]
    public List<AttackDto> Attacks { get; set; } = new();

    [Range(0, 100, ErrorMessage = "Les points de défense doivent être entre 0 et 100")]
    public int DefensePoints { get; set; }

    [Range(0, 100, ErrorMessage = "Les points de vie doivent être entre 0 et 100")]
    public int HealthPoints { get; set; }

    [Range(0, 100, ErrorMessage = "Le pourcentage de rareté doit être entre 0 et 100")]
    public double RarityPercentage { get; set; }

    [Url(ErrorMessage = "L'URL de l'image n'est pas valide")]
    public string? ImageURL { get; set; }
}
