namespace DTOs;

public class PokemonDto
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }  // Enum as string in JSON
    public List<AttackDto> Attacks { get; set; }
    public int DefensePoints { get; set; }
    public int HealthPoints { get; set; }
    public double RarityPercentage { get; set; }
    public string? ImageURL { get; set; }
}