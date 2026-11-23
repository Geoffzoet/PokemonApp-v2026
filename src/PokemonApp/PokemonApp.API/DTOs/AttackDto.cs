using System.ComponentModel.DataAnnotations;

namespace PokemonApp.API.DTOs;

public class AttackDto
{
    [Required(ErrorMessage = "Le nom de l'attaque est obligatoire")]
    [StringLength(100, MinimumLength = 1)]
    public string Name { get; set; } = string.Empty;

    [Range(0, 100, ErrorMessage = "Les points d'attaque doivent être entre 0 et 100")]
    public int Points { get; set; }
}
