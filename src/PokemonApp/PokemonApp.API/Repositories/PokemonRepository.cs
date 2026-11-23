using Microsoft.EntityFrameworkCore;
using PokemonApp.API.Data;
using PokemonApp.API.Interfaces;
using PokemonApp.API.Models;

namespace PokemonApp.API.Repositories;

public class PokemonRepository : IPokemonRepository
{
    private readonly ApplicationDbContext _context;

    public PokemonRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<Pokemon>> GetAllAsync()
    {
        return await _context.Pokemon
            .Include(p => p.Attacks)
            .ToListAsync();
    }

    public async Task<Pokemon?> GetByIdAsync(int id)
    {
        return await _context.Pokemon
            .Include(p => p.Attacks)
            .FirstOrDefaultAsync(p => p.Id == id);
    }

    public async Task<Pokemon> AddAsync(Pokemon pokemon)
    {
        _context.Pokemon.Add(pokemon);
        await _context.SaveChangesAsync();
        return pokemon;
    }

    public async Task UpdateAsync(Pokemon pokemon)
    {
        _context.Pokemon.Update(pokemon);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(Pokemon pokemon)
    {
        _context.Pokemon.Remove(pokemon);
        await _context.SaveChangesAsync();
    }

    public async Task<bool> ExistsAsync(int id)
    {
        return await _context.Pokemon.AnyAsync(p => p.Id == id);
    }
}
