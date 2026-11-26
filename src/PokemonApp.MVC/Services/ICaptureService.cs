using PokemonApp.MVC.Models;

namespace PokemonApp.MVC.Services;

public interface ICaptureService
{
    bool TryCapture(Pokemon pokemon, BallType ballType);
}
