using PokemonApp.MVC.Models;

namespace PokemonApp.MVC.Services;

public class CaptureService : ICaptureService
{
    private readonly Random _random;

    public CaptureService()
    {
        _random = new Random();
    }

    public bool TryCapture(Pokemon pokemon, BallType ballType)
    {
        // Ball type multipliers
        double ballMultiplier = ballType switch
        {
            BallType.PokeBall => 1.0,
            BallType.SuperBall => 1.5,
            BallType.MasterBall => 10.0,
            _ => 1.0
        };

        // Calculate success rate: rarity × ball multiplier
        double successRate = pokemon.RarityPercentage * ballMultiplier;

        // Cap at 100% (1.0)
        successRate = Math.Min(successRate, 1.0);

        // Random roll
        double roll = _random.NextDouble();

        return roll <= successRate;
    }
}
