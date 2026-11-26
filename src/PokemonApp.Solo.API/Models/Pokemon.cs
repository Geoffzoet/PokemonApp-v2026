using Helpers;

namespace Models;

public class Pokemon
{
    public int Id {get;set;} 

    public string Name {get;set;} = string.Empty;

    public PokemonType Type {get;set;}

    public ICollection<Attack> Attacks {get;set;}

    public int DefensePoint {get;set;}

    public int HealthPoint {get;set;}

    public double RarityPercentage {get;set;}

    public string? ImageURL {get;set;}
}
