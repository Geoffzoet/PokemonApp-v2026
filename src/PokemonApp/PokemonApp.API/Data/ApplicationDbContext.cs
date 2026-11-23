using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using PokemonApp.API.Models;

namespace PokemonApp.API.Data;

public class ApplicationDbContext : IdentityDbContext<IdentityUser>
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public DbSet<Pokemon> Pokemon { get; set; }
    public DbSet<Attack> Attacks { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Configure Pokemon entity
        modelBuilder.Entity<Pokemon>(entity =>
        {
            entity.HasKey(p => p.Id);
            entity.Property(p => p.Name).IsRequired().HasMaxLength(50);
            entity.Property(p => p.Type).IsRequired();
            entity.Property(p => p.ImageURL).HasMaxLength(500);

            // Relationship with Attacks
            entity.HasMany(p => p.Attacks)
                  .WithOne(a => a.Pokemon)
                  .HasForeignKey(a => a.PokemonId)
                  .OnDelete(DeleteBehavior.Cascade);
        });

        // Configure Attack entity
        modelBuilder.Entity<Attack>(entity =>
        {
            entity.HasKey(a => a.Id);
            entity.Property(a => a.Name).IsRequired().HasMaxLength(100);
        });
    }
}
