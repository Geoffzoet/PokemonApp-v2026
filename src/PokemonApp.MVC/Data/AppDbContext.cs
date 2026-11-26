using Microsoft.EntityFrameworkCore;
using PokemonApp.MVC.Models;

namespace PokemonApp.MVC.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }

    public DbSet<Pokemon> Pokemons { get; set; }
    public DbSet<Attack> Attacks { get; set; }
    public DbSet<Trainer> Trainers { get; set; }
    public DbSet<CaughtPokemon> CaughtPokemons { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Configuration Pokemon
        modelBuilder.Entity<Pokemon>(entity =>
        {
            entity.HasKey(p => p.Id);
            entity.Property(p => p.Name).IsRequired().HasMaxLength(50);
            entity.Property(p => p.Type).IsRequired();
            entity.Property(p => p.ImageURL).HasMaxLength(500);

            entity.HasMany(p => p.Attacks)
                .WithOne(a => a.Pokemon)
                .HasForeignKey(a => a.PokemonId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // Configuration Attack
        modelBuilder.Entity<Attack>(entity =>
        {
            entity.HasKey(a => a.Id);
            entity.Property(a => a.Name).IsRequired().HasMaxLength(100);
        });

        // Configuration Trainer
        modelBuilder.Entity<Trainer>(entity =>
        {
            entity.HasKey(t => t.Id);
            entity.Property(t => t.Name).IsRequired().HasMaxLength(100);
            entity.Property(t => t.Town).IsRequired().HasMaxLength(100);
        });

        // Configuration CaughtPokemon
        modelBuilder.Entity<CaughtPokemon>(entity =>
        {
            entity.HasKey(cp => cp.Id);

            entity.HasOne(cp => cp.Trainer)
                .WithMany(t => t.Team)
                .HasForeignKey(cp => cp.TrainerId)
                .OnDelete(DeleteBehavior.Cascade);

            entity.HasOne(cp => cp.Pokemon)
                .WithMany()
                .HasForeignKey(cp => cp.PokemonId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.Property(cp => cp.Nickname).HasMaxLength(50);
            entity.Property(cp => cp.CaughtAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
        });

        // Seed Data
        SeedData(modelBuilder);
    }

    private void SeedData(ModelBuilder modelBuilder)
    {
        // Seed Pokemons
        modelBuilder.Entity<Pokemon>().HasData(
            new Pokemon { Id = 1, Name = "Pikachu", Type = PokemonType.ELECTRIK, DefensePoints = 30, HealthPoints = 60, RarityPercentage = 0.6, ImageURL = "/img/pikachu.svg" },
            new Pokemon { Id = 2, Name = "Salamèche", Type = PokemonType.FIRE, DefensePoints = 50, HealthPoints = 70, RarityPercentage = 0.3, ImageURL = "/img/salameche.svg" },
            new Pokemon { Id = 3, Name = "Bulbizarre", Type = PokemonType.GRASS, DefensePoints = 50, HealthPoints = 80, RarityPercentage = 0.3, ImageURL = "/img/bulbizarre.svg" },
            new Pokemon { Id = 4, Name = "Carapuce", Type = PokemonType.WATER, DefensePoints = 60, HealthPoints = 70, RarityPercentage = 0.3, ImageURL = "/img/carapuce.svg" },
            new Pokemon { Id = 5, Name = "Roucool", Type = PokemonType.FLYING, DefensePoints = 30, HealthPoints = 50, RarityPercentage = 0.7, ImageURL = "/img/roucool.svg" },
            new Pokemon { Id = 6, Name = "Rattata", Type = PokemonType.GRASS, DefensePoints = 20, HealthPoints = 40, RarityPercentage = 0.9, ImageURL = "/img/rattata.svg" }
        );

        // Seed Attacks
        modelBuilder.Entity<Attack>().HasData(
            // Pikachu attacks
            new Attack { Id = 1, Name = "Éclair", Points = 40, PokemonId = 1 },
            new Attack { Id = 2, Name = "Tonnerre", Points = 60, PokemonId = 1 },
            new Attack { Id = 3, Name = "Charge", Points = 20, PokemonId = 1 },
            // Salamèche attacks
            new Attack { Id = 4, Name = "Flammèche", Points = 40, PokemonId = 2 },
            new Attack { Id = 5, Name = "Lance-Flammes", Points = 70, PokemonId = 2 },
            new Attack { Id = 6, Name = "Griffe", Points = 30, PokemonId = 2 },
            // Bulbizarre attacks
            new Attack { Id = 7, Name = "Fouet Lianes", Points = 45, PokemonId = 3 },
            new Attack { Id = 8, Name = "Tranch'Herbe", Points = 55, PokemonId = 3 },
            new Attack { Id = 9, Name = "Poudre Toxik", Points = 25, PokemonId = 3 },
            // Carapuce attacks
            new Attack { Id = 10, Name = "Pistolet à O", Points = 40, PokemonId = 4 },
            new Attack { Id = 11, Name = "Hydrocanon", Points = 70, PokemonId = 4 },
            new Attack { Id = 12, Name = "Morsure", Points = 35, PokemonId = 4 },
            // Roucool attacks
            new Attack { Id = 13, Name = "Cru-Aile", Points = 35, PokemonId = 5 },
            new Attack { Id = 14, Name = "Tornade", Points = 40, PokemonId = 5 },
            // Rattata attacks
            new Attack { Id = 15, Name = "Vive-Attaque", Points = 30, PokemonId = 6 },
            new Attack { Id = 16, Name = "Croc de Mort", Points = 45, PokemonId = 6 }
        );

        // Seed Trainers
        modelBuilder.Entity<Trainer>().HasData(
            new Trainer { Id = 1, Name = "Sacha", Town = "Bourg Palette", BadgeCount = 3 },
            new Trainer { Id = 2, Name = "Pierre", Town = "Argenta", BadgeCount = 1 }
        );
    }
}
