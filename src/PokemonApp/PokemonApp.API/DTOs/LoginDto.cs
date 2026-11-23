using System.ComponentModel.DataAnnotations;

namespace PokemonApp.API.DTOs;

public class LoginDto
{
    [Required(ErrorMessage = "L'email est obligatoire")]
    [EmailAddress(ErrorMessage = "L'email n'est pas valide")]
    public string Email { get; set; } = string.Empty;

    [Required(ErrorMessage = "Le mot de passe est obligatoire")]
    public string Password { get; set; } = string.Empty;
}
