using System.ComponentModel.DataAnnotations;

namespace DTOs;

public class CreatePokemonDto
{
    [Required(ErrorMessage ="The name is required.")]
    [StringLength(50, MinimumLength = 1, ErrorMessage = "Le nom doit contenir entre 1 et 50 caractères")]
    public string Name { get; set; }

    [Required(ErrorMessage ="The type is required.")]
    [RegularExpression("GRASS|FIRE|FLYING|WATER|ELECTRIK",
        ErrorMessage = "Le type doit être l'un des suivants: GRASS, FIRE, FLYING, WATER, ELECTRIK")]
    public string Type { get; set; }


    [Required(ErrorMessage = "The pokemon must have at least one attack.")]
    [MinLength(1, ErrorMessage = "The pokemon must have at least one attack.")]
    public List<AttackDto> Attacks { get; set; }

    [Range(0,100,ErrorMessage ="Defense points must be between 0 and 100")]
    public int DefensePoints { get; set; }

    [Range(0,100,ErrorMessage ="Health points must be between 0 and 100")]
    public int HealthPoints { get; set; }

    [Range(0,100,ErrorMessage ="Rarity percentage must be between 0 and 100")]
    public double RarityPercentage { get; set; }
    
    [Url(ErrorMessage = "L'URL de l'image n'est pas valide")]
    public string? ImageURL { get; set; }
}