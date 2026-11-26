
namespace Models;

public class Attack
{
    public Attack()
    {}

    public int Id {get;set;}
    public string Name {get;set;}
    public int Points {get;set;}

    public int PokemonId {get;set;}
    public Pokemon Pokemon{get;set;}

}

