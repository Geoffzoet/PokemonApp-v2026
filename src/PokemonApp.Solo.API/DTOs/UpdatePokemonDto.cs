namespace DTOs;

public class UpdatePokemonDto
{
    public string Name { get; set; }
    public string Type { get; set; }
    public List<AttackDto> Attacks { get; set; }
    public int DefensePoints { get; set; }
    public int HealthPoints { get; set; }
    public double RarityPercentage { get; set; }
    public string? ImageURL { get; set; }
}
