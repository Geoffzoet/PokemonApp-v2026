using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PokemonApp.MVC.Data;
using PokemonApp.MVC.Models;

namespace PokemonApp.MVC.Controllers;

public class TrainerController : Controller
{
    private readonly AppDbContext _context;

    public TrainerController(AppDbContext context)
    {
        _context = context;
    }

    // GET: Trainer
    public async Task<IActionResult> Index()
    {
        var trainers = await _context.Trainers
            .Include(t => t.Team)
            .ToListAsync();

        return View(trainers);
    }

    // GET: Trainer/Details/5
    public async Task<IActionResult> Details(int? id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var trainer = await _context.Trainers
            .Include(t => t.Team)
                .ThenInclude(cp => cp.Pokemon)
                    .ThenInclude(p => p.Attacks)
            .FirstOrDefaultAsync(t => t.Id == id);

        if (trainer == null)
        {
            return NotFound();
        }

        return View(trainer);
    }

    // GET: Trainer/Create
    public IActionResult Create()
    {
        return View();
    }

    // POST: Trainer/Create
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create([Bind("Name,Town,BadgeCount")] Trainer trainer)
    {
        if (ModelState.IsValid)
        {
            _context.Add(trainer);
            await _context.SaveChangesAsync();
            TempData["SuccessMessage"] = $"Le dresseur {trainer.Name} a été créé avec succès !";
            return RedirectToAction(nameof(Index));
        }
        return View(trainer);
    }

    // GET: Trainer/Edit/5
    public async Task<IActionResult> Edit(int? id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var trainer = await _context.Trainers.FindAsync(id);
        if (trainer == null)
        {
            return NotFound();
        }
        return View(trainer);
    }

    // POST: Trainer/Edit/5
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, [Bind("Id,Name,Town,BadgeCount")] Trainer trainer)
    {
        if (id != trainer.Id)
        {
            return NotFound();
        }

        if (ModelState.IsValid)
        {
            try
            {
                _context.Update(trainer);
                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = $"Le dresseur {trainer.Name} a été modifié avec succès !";
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TrainerExists(trainer.Id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            return RedirectToAction(nameof(Index));
        }
        return View(trainer);
    }

    // GET: Trainer/Delete/5
    public async Task<IActionResult> Delete(int? id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var trainer = await _context.Trainers
            .Include(t => t.Team)
            .FirstOrDefaultAsync(t => t.Id == id);

        if (trainer == null)
        {
            return NotFound();
        }

        return View(trainer);
    }

    // POST: Trainer/Delete/5
    [HttpPost, ActionName("Delete")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> DeleteConfirmed(int id)
    {
        var trainer = await _context.Trainers.FindAsync(id);
        if (trainer != null)
        {
            _context.Trainers.Remove(trainer);
            await _context.SaveChangesAsync();
            TempData["SuccessMessage"] = $"Le dresseur {trainer.Name} a été supprimé avec succès !";
        }

        return RedirectToAction(nameof(Index));
    }

    private bool TrainerExists(int id)
    {
        return _context.Trainers.Any(e => e.Id == id);
    }
}
