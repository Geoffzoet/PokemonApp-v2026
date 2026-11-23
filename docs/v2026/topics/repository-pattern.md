# Repository Pattern

## 1. Overview & Introduction

### What is the Repository Pattern?

The **Repository Pattern** is a design pattern that creates an abstraction layer between your application's business logic and the data access layer. Think of a repository as a "librarian" for your data: instead of going directly to the database shelves (DbContext), you ask the librarian (Repository) to fetch, store, or organize books (data) for you.

In ASP.NET Core applications, repositories act as intermediaries between your controllers/services and Entity Framework Core's DbContext, providing a clean, consistent API for data operations.

**Simple Analogy:**
```
Without Repository:        With Repository:
Controller → DbContext    Controller → Repository → DbContext
   (tightly coupled)         (loosely coupled)
```

### Why Use the Repository Pattern?

1. **Abstraction**: Hide complex data access logic behind simple methods
2. **Testability**: Easily mock repositories in unit tests without hitting the database
3. **Consistency**: Centralize data access logic in one place
4. **Flexibility**: Swap data sources (SQL, NoSQL, APIs) without changing business logic
5. **Maintainability**: Changes to data access affect only the repository, not the entire codebase

**Example Scenario:**
Instead of writing complex LINQ queries in every controller:
```csharp
// Without Repository - Complex LINQ everywhere
var activePokemon = _context.Pokemon
    .Include(p => p.Trainer)
    .Include(p => p.Type)
    .Where(p => p.IsActive)
    .OrderBy(p => p.Name)
    .ToList();
```

You call a simple, descriptive method:
```csharp
// With Repository - Clean and readable
var activePokemon = _pokemonRepository.GetAllActive();
```

### When to Use This Pattern

**Use Repository Pattern When:**
- Building medium to large applications with complex data access
- You need comprehensive unit testing without database dependencies
- Multiple parts of your application access the same data
- You want to centralize query logic
- You're working in a team and need consistent data access patterns

**Consider DbContext Directly When:**
- Building simple CRUD applications
- Prototyping or creating proof-of-concepts
- The overhead of repositories outweighs the benefits
- Your team prefers direct Entity Framework usage

### What You'll Learn

By the end of this guide, you'll understand:
- How to create repository interfaces and implementations
- The difference between specific and generic repositories
- How to integrate repositories with dependency injection
- Best practices for repository design
- When to use repositories vs. direct DbContext access
- How the Unit of Work pattern complements repositories

---

## 2. Quick Start

### Minimal Repository Example

Here's a simple repository to get you started:

**Step 1: Define the interface**
```csharp
public interface IPokemonRepository
{
    Task<List<Pokemon>> GetAllAsync();
    Task<Pokemon?> GetByIdAsync(int id);
    Task AddAsync(Pokemon pokemon);
    Task SaveChangesAsync();
}
```

**Step 2: Implement the repository**
```csharp
public class PokemonRepository : IPokemonRepository
{
    private readonly ApplicationDbContext _context;

    public PokemonRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<List<Pokemon>> GetAllAsync()
    {
        return await _context.Pokemon.ToListAsync();
    }

    public async Task<Pokemon?> GetByIdAsync(int id)
    {
        return await _context.Pokemon.FindAsync(id);
    }

    public async Task AddAsync(Pokemon pokemon)
    {
        await _context.Pokemon.AddAsync(pokemon);
    }

    public async Task SaveChangesAsync()
    {
        await _context.SaveChangesAsync();
    }
}
```

**Step 3: Register in dependency injection**
```csharp
// Program.cs
builder.Services.AddScoped<IPokemonRepository, PokemonRepository>();
```

**Step 4: Use in a controller**
```csharp
public class PokemonController : Controller
{
    private readonly IPokemonRepository _repository;

    public PokemonController(IPokemonRepository repository)
    {
        _repository = repository;
    }

    public async Task<IActionResult> Index()
    {
        var pokemon = await _repository.GetAllAsync();
        return View(pokemon);
    }
}
```

**What Just Happened?**
1. Created an interface defining data operations
2. Implemented the interface using Entity Framework
3. Registered it for dependency injection
4. Injected and used it in a controller

This separates your controller from direct database access, making it easier to test and maintain.

---

## 3. Prerequisites

### Required Knowledge

Before diving into repositories, you should be comfortable with:

1. **Entity Framework Core** (POK-13)
   - DbContext and DbSet
   - Basic CRUD operations
   - Async/await patterns
   - LINQ queries

2. **Dependency Injection** (POK-16)
   - Service lifetimes (Scoped, Transient, Singleton)
   - Constructor injection
   - Registering services in Program.cs

3. **C# Fundamentals**
   - Interfaces and implementation
   - Generic types
   - Async programming
   - LINQ queries

4. **MVC Controllers** (POK-22)
   - Controller structure
   - Action methods
   - Dependency injection in controllers

### Required Tools

- **.NET 8.0 SDK** or later
- **Visual Studio 2022**, **VS Code**, or **Rider**
- **SQL Server** or **SQLite** for database
- **Entity Framework Core** packages

### Project Setup Checklist

Ensure your project has these packages:
```bash
dotnet add package Microsoft.EntityFrameworkCore
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Tools
```

You should have:
- A configured DbContext
- At least one entity model
- Database connection string in appsettings.json
- Dependency injection configured in Program.cs

---

## 4. Core Concepts & Theory

### Understanding Data Access Abstraction

**The Problem:**
In traditional applications, controllers directly access the database through DbContext:

```csharp
public class PokemonController : Controller
{
    private readonly ApplicationDbContext _context;

    public async Task<IActionResult> Index()
    {
        // Direct database access - tightly coupled
        var pokemon = await _context.Pokemon
            .Include(p => p.Trainer)
            .Include(p => p.Type)
            .Where(p => p.IsActive)
            .OrderBy(p => p.Name)
            .ToListAsync();

        return View(pokemon);
    }
}
```

**Problems with this approach:**
1. **Duplication**: Same queries repeated across multiple controllers
2. **Testing Difficulty**: Hard to unit test without a real database
3. **Tight Coupling**: Controllers depend directly on Entity Framework
4. **Business Logic Leakage**: Data access logic mixed with controller logic
5. **Change Impact**: Database changes require modifications in many places

**The Solution: Repository Pattern**

A repository encapsulates data access logic:

```csharp
public class PokemonRepository : IPokemonRepository
{
    private readonly ApplicationDbContext _context;

    public async Task<List<Pokemon>> GetAllActiveAsync()
    {
        // Encapsulated, reusable query logic
        return await _context.Pokemon
            .Include(p => p.Trainer)
            .Include(p => p.Type)
            .Where(p => p.IsActive)
            .OrderBy(p => p.Name)
            .ToListAsync();
    }
}

// Controller is now simple and testable
public class PokemonController : Controller
{
    private readonly IPokemonRepository _repository;

    public async Task<IActionResult> Index()
    {
        var pokemon = await _repository.GetAllActiveAsync();
        return View(pokemon);
    }
}
```

### Repository Responsibilities

A repository should:

1. **Encapsulate Data Access**
   - Hide DbContext and EF Core complexity
   - Provide domain-specific methods
   - Handle includes, filters, and ordering

2. **Provide a Clear API**
   - Method names reflect business intent
   - Return domain objects, not IQueryable
   - Use async/await for all database operations

3. **Manage Entity Lifecycle**
   - Add, update, delete operations
   - Track changes appropriately
   - Coordinate SaveChanges calls

**What a Repository Should NOT Do:**
- Contain business logic (use services for that)
- Return IQueryable (exposes EF Core internals)
- Handle transactions across multiple repositories (use Unit of Work)
- Perform complex calculations (domain models or services)

### Types of Repositories

#### 1. Specific Repository
Tailored to a single entity with custom methods:

```csharp
public interface IPokemonRepository
{
    Task<List<Pokemon>> GetAllAsync();
    Task<Pokemon?> GetByIdAsync(int id);
    Task<List<Pokemon>> GetByTrainerIdAsync(int trainerId);
    Task<List<Pokemon>> GetByTypeAsync(string type);
    Task<List<Pokemon>> SearchByNameAsync(string searchTerm);
    Task AddAsync(Pokemon pokemon);
    Task UpdateAsync(Pokemon pokemon);
    Task DeleteAsync(int id);
}
```

**Advantages:**
- Highly specific to domain needs
- Clear, intention-revealing method names
- Easy to understand and use

**Disadvantages:**
- More code to write and maintain
- Duplication across repositories

#### 2. Generic Repository
Works with any entity type:

```csharp
public interface IRepository<T> where T : class
{
    Task<List<T>> GetAllAsync();
    Task<T?> GetByIdAsync(int id);
    Task<T?> GetByIdAsync(params object[] keyValues);
    Task AddAsync(T entity);
    Task UpdateAsync(T entity);
    Task DeleteAsync(int id);
}
```

**Advantages:**
- Less code (DRY principle)
- Consistent API across all entities
- Faster to implement

**Disadvantages:**
- Less discoverable
- May need additional specific repositories for complex queries
- Can become too generic

#### 3. Hybrid Approach (Recommended)
Generic base with specific extensions:

```csharp
// Generic base repository
public interface IRepository<T> where T : class
{
    Task<List<T>> GetAllAsync();
    Task<T?> GetByIdAsync(int id);
    Task AddAsync(T entity);
    Task UpdateAsync(T entity);
    Task DeleteAsync(int id);
}

// Specific repository extending the generic one
public interface IPokemonRepository : IRepository<Pokemon>
{
    Task<List<Pokemon>> GetByTrainerIdAsync(int trainerId);
    Task<List<Pokemon>> GetLegendaryPokemonAsync();
    Task<Pokemon?> GetByNameAsync(string name);
}
```

**Advantages:**
- Best of both worlds
- Common operations inherited
- Domain-specific methods when needed
- Clean and maintainable

### Repository vs. DbContext Directly

| Aspect | Repository Pattern | Direct DbContext |
|--------|-------------------|------------------|
| **Learning Curve** | Steeper (additional abstraction) | Easier for beginners |
| **Code Volume** | More code (interfaces + implementations) | Less code |
| **Testability** | Excellent (easy mocking) | Harder (need InMemory DB) |
| **Flexibility** | High (easy to swap implementations) | Lower (tied to EF Core) |
| **Query Complexity** | Hides complexity | Exposes full LINQ power |
| **Maintenance** | Easier (centralized logic) | Harder (scattered queries) |
| **Team Consistency** | Enforces consistent patterns | Varies by developer |
| **Best For** | Medium-large applications | Small apps, prototypes |

### The Unit of Work Pattern

Repositories often work alongside the **Unit of Work** pattern, which coordinates changes across multiple repositories:

```csharp
public interface IUnitOfWork
{
    IPokemonRepository Pokemon { get; }
    ITrainerRepository Trainers { get; }
    IBattleRepository Battles { get; }

    Task<int> SaveChangesAsync();
    Task BeginTransactionAsync();
    Task CommitTransactionAsync();
    Task RollbackTransactionAsync();
}
```

**Benefits:**
- Single SaveChanges call for multiple operations
- Transaction management
- Coordinates changes across repositories

**Example Usage:**
```csharp
// Add a trainer and their starting Pokemon in one transaction
await _unitOfWork.BeginTransactionAsync();
try
{
    await _unitOfWork.Trainers.AddAsync(trainer);
    await _unitOfWork.Pokemon.AddAsync(startingPokemon);
    await _unitOfWork.SaveChangesAsync();
    await _unitOfWork.CommitTransactionAsync();
}
catch
{
    await _unitOfWork.RollbackTransactionAsync();
    throw;
}
```

We'll explore Unit of Work in more detail in the Patterns & Best Practices section.

---

## 5. Installation & Configuration

### Step 1: Create Project Structure

Organize your project with proper folder structure:

```
PokemonApp/
├── Controllers/
├── Models/
│   ├── Entities/          # Domain models
│   │   ├── Pokemon.cs
│   │   └── Trainer.cs
│   └── ViewModels/
├── Data/
│   ├── ApplicationDbContext.cs
│   └── Repositories/      # Repository implementations
│       ├── Interfaces/
│       │   ├── IRepository.cs
│       │   └── IPokemonRepository.cs
│       ├── Repository.cs
│       └── PokemonRepository.cs
├── Views/
├── appsettings.json
└── Program.cs
```

### Step 2: Create Generic Repository Interface

Create `Data/Repositories/Interfaces/IRepository.cs`:

```csharp
namespace PokemonApp.Data.Repositories.Interfaces;

public interface IRepository<T> where T : class
{
    // Read operations
    Task<List<T>> GetAllAsync();
    Task<T?> GetByIdAsync(int id);
    Task<T?> GetByIdAsync(params object[] keyValues);

    // Write operations
    Task AddAsync(T entity);
    Task AddRangeAsync(IEnumerable<T> entities);
    void Update(T entity);
    void UpdateRange(IEnumerable<T> entities);
    void Delete(T entity);
    void DeleteRange(IEnumerable<T> entities);

    // Query helpers
    Task<bool> ExistsAsync(int id);
    Task<int> CountAsync();
}
```

### Step 3: Implement Generic Repository

Create `Data/Repositories/Repository.cs`:

```csharp
using Microsoft.EntityFrameworkCore;
using PokemonApp.Data.Repositories.Interfaces;

namespace PokemonApp.Data.Repositories;

public class Repository<T> : IRepository<T> where T : class
{
    protected readonly ApplicationDbContext _context;
    protected readonly DbSet<T> _dbSet;

    public Repository(ApplicationDbContext context)
    {
        _context = context;
        _dbSet = context.Set<T>();
    }

    public virtual async Task<List<T>> GetAllAsync()
    {
        return await _dbSet.ToListAsync();
    }

    public virtual async Task<T?> GetByIdAsync(int id)
    {
        return await _dbSet.FindAsync(id);
    }

    public virtual async Task<T?> GetByIdAsync(params object[] keyValues)
    {
        return await _dbSet.FindAsync(keyValues);
    }

    public virtual async Task AddAsync(T entity)
    {
        await _dbSet.AddAsync(entity);
    }

    public virtual async Task AddRangeAsync(IEnumerable<T> entities)
    {
        await _dbSet.AddRangeAsync(entities);
    }

    public virtual void Update(T entity)
    {
        _dbSet.Update(entity);
    }

    public virtual void UpdateRange(IEnumerable<T> entities)
    {
        _dbSet.UpdateRange(entities);
    }

    public virtual void Delete(T entity)
    {
        _dbSet.Remove(entity);
    }

    public virtual void DeleteRange(IEnumerable<T> entities)
    {
        _dbSet.RemoveRange(entities);
    }

    public virtual async Task<bool> ExistsAsync(int id)
    {
        var entity = await GetByIdAsync(id);
        return entity != null;
    }

    public virtual async Task<int> CountAsync()
    {
        return await _dbSet.CountAsync();
    }
}
```

**Key Points:**
- `protected` members allow derived repositories to access them
- `virtual` methods allow overriding in specific repositories
- Methods don't call SaveChanges (caller's responsibility)

### Step 4: Create Specific Repository Interface

Create `Data/Repositories/Interfaces/IPokemonRepository.cs`:

```csharp
using PokemonApp.Models.Entities;

namespace PokemonApp.Data.Repositories.Interfaces;

public interface IPokemonRepository : IRepository<Pokemon>
{
    // Domain-specific queries
    Task<List<Pokemon>> GetByTrainerIdAsync(int trainerId);
    Task<List<Pokemon>> GetByTypeAsync(string type);
    Task<Pokemon?> GetByNameAsync(string name);
    Task<List<Pokemon>> SearchAsync(string searchTerm);
    Task<List<Pokemon>> GetTopLevelPokemonAsync(int count);

    // Business queries with relationships
    Task<Pokemon?> GetWithTrainerAsync(int id);
    Task<List<Pokemon>> GetAllWithTrainersAsync();

    // Statistics
    Task<int> GetCountByTrainerAsync(int trainerId);
    Task<double> GetAverageLevelAsync();
}
```

### Step 5: Implement Specific Repository

Create `Data/Repositories/PokemonRepository.cs`:

```csharp
using Microsoft.EntityFrameworkCore;
using PokemonApp.Data.Repositories.Interfaces;
using PokemonApp.Models.Entities;

namespace PokemonApp.Data.Repositories;

public class PokemonRepository : Repository<Pokemon>, IPokemonRepository
{
    public PokemonRepository(ApplicationDbContext context) : base(context)
    {
    }

    public async Task<List<Pokemon>> GetByTrainerIdAsync(int trainerId)
    {
        return await _dbSet
            .Where(p => p.TrainerId == trainerId)
            .OrderBy(p => p.Name)
            .ToListAsync();
    }

    public async Task<List<Pokemon>> GetByTypeAsync(string type)
    {
        return await _dbSet
            .Where(p => p.Type == type)
            .OrderBy(p => p.Name)
            .ToListAsync();
    }

    public async Task<Pokemon?> GetByNameAsync(string name)
    {
        return await _dbSet
            .FirstOrDefaultAsync(p => p.Name.ToLower() == name.ToLower());
    }

    public async Task<List<Pokemon>> SearchAsync(string searchTerm)
    {
        return await _dbSet
            .Where(p => p.Name.Contains(searchTerm) ||
                       p.Type.Contains(searchTerm))
            .OrderBy(p => p.Name)
            .ToListAsync();
    }

    public async Task<List<Pokemon>> GetTopLevelPokemonAsync(int count)
    {
        return await _dbSet
            .OrderByDescending(p => p.Level)
            .Take(count)
            .ToListAsync();
    }

    public async Task<Pokemon?> GetWithTrainerAsync(int id)
    {
        return await _dbSet
            .Include(p => p.Trainer)
            .FirstOrDefaultAsync(p => p.Id == id);
    }

    public async Task<List<Pokemon>> GetAllWithTrainersAsync()
    {
        return await _dbSet
            .Include(p => p.Trainer)
            .OrderBy(p => p.Name)
            .ToListAsync();
    }

    public async Task<int> GetCountByTrainerAsync(int trainerId)
    {
        return await _dbSet
            .CountAsync(p => p.TrainerId == trainerId);
    }

    public async Task<double> GetAverageLevelAsync()
    {
        if (!await _dbSet.AnyAsync())
            return 0;

        return await _dbSet.AverageAsync(p => p.Level);
    }
}
```

### Step 6: Register Repositories

Update `Program.cs` to register repositories:

```csharp
using PokemonApp.Data;
using PokemonApp.Data.Repositories;
using PokemonApp.Data.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add DbContext
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Register repositories
// Option 1: Register specific repositories
builder.Services.AddScoped<IPokemonRepository, PokemonRepository>();
builder.Services.AddScoped<ITrainerRepository, TrainerRepository>();

// Option 2: Register generic repository (if needed)
builder.Services.AddScoped(typeof(IRepository<>), typeof(Repository<>));

builder.Services.AddControllersWithViews();

var app = builder.Build();

// Configure middleware...
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

**Important Notes:**
- Use **Scoped** lifetime for repositories (matches DbContext lifetime)
- Register specific repositories for entities with custom queries
- Generic repository registration useful for simple entities
- Repositories share the same DbContext instance per request

### Step 7: Verify Installation

Create a simple controller to test your repository:

```csharp
public class PokemonController : Controller
{
    private readonly IPokemonRepository _repository;
    private readonly ApplicationDbContext _context;

    public PokemonController(
        IPokemonRepository repository,
        ApplicationDbContext context)
    {
        _repository = repository;
        _context = context;
    }

    public async Task<IActionResult> Index()
    {
        var pokemon = await _repository.GetAllAsync();
        return View(pokemon);
    }

    [HttpPost]
    public async Task<IActionResult> Create(Pokemon pokemon)
    {
        if (ModelState.IsValid)
        {
            await _repository.AddAsync(pokemon);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }
        return View(pokemon);
    }
}
```

Run your application and verify the repository works correctly.

---

## 6. Configuration & Setup

### Configuring SaveChanges Strategy

One important decision is **where to call SaveChanges**. There are three common approaches:

#### Approach 1: Repository Calls SaveChanges

Each repository method saves immediately:

```csharp
public class PokemonRepository : IPokemonRepository
{
    private readonly ApplicationDbContext _context;

    public async Task AddAsync(Pokemon pokemon)
    {
        await _context.Pokemon.AddAsync(pokemon);
        await _context.SaveChangesAsync(); // Save immediately
    }

    public async Task UpdateAsync(Pokemon pokemon)
    {
        _context.Pokemon.Update(pokemon);
        await _context.SaveChangesAsync(); // Save immediately
    }
}
```

**Pros:**
- Simple to use
- Each operation is immediately persisted
- No risk of forgetting to save

**Cons:**
- Can't batch multiple operations
- Performance impact (multiple database roundtrips)
- Difficult to implement transactions

#### Approach 2: Caller Decides When to Save

Repository doesn't save; caller controls when:

```csharp
public class PokemonRepository : IPokemonRepository
{
    private readonly ApplicationDbContext _context;

    public async Task AddAsync(Pokemon pokemon)
    {
        await _context.Pokemon.AddAsync(pokemon);
        // No SaveChanges here
    }
}

// Controller
public class PokemonController : Controller
{
    private readonly IPokemonRepository _repository;
    private readonly ApplicationDbContext _context;

    public async Task<IActionResult> Create(Pokemon pokemon)
    {
        await _repository.AddAsync(pokemon);
        await _context.SaveChangesAsync(); // Controller saves
        return RedirectToAction(nameof(Index));
    }
}
```

**Pros:**
- Flexible (batch multiple operations)
- Better performance
- Easier transaction management

**Cons:**
- Must remember to call SaveChanges
- Repository + DbContext injection required

#### Approach 3: Unit of Work Pattern (Recommended)

Coordinate saves through a Unit of Work:

```csharp
public interface IUnitOfWork
{
    IPokemonRepository Pokemon { get; }
    ITrainerRepository Trainers { get; }
    Task<int> SaveChangesAsync();
}

public class UnitOfWork : IUnitOfWork
{
    private readonly ApplicationDbContext _context;

    public UnitOfWork(ApplicationDbContext context)
    {
        _context = context;
        Pokemon = new PokemonRepository(context);
        Trainers = new TrainerRepository(context);
    }

    public IPokemonRepository Pokemon { get; }
    public ITrainerRepository Trainers { get; }

    public async Task<int> SaveChangesAsync()
    {
        return await _context.SaveChangesAsync();
    }
}

// Controller
public class PokemonController : Controller
{
    private readonly IUnitOfWork _unitOfWork;

    public async Task<IActionResult> Create(Pokemon pokemon)
    {
        await _unitOfWork.Pokemon.AddAsync(pokemon);
        await _unitOfWork.SaveChangesAsync(); // UnitOfWork coordinates
        return RedirectToAction(nameof(Index));
    }
}
```

**Pros:**
- Best of both worlds
- Clean separation of concerns
- Easy transaction management
- Multiple repositories share one DbContext

**Cons:**
- More code to set up initially
- Additional abstraction layer

**Recommendation:** Use **Approach 2** for simple applications and **Approach 3** (Unit of Work) for complex applications with multiple repositories.

### Configuring Change Tracking

Control how Entity Framework tracks changes in repositories:

```csharp
public class PokemonRepository : Repository<Pokemon>, IPokemonRepository
{
    // Read-only query without change tracking
    public async Task<List<Pokemon>> GetAllForDisplayAsync()
    {
        return await _dbSet
            .AsNoTracking() // Better performance for read-only
            .ToListAsync();
    }

    // Query with tracking for updates
    public async Task<Pokemon?> GetForEditAsync(int id)
    {
        return await _dbSet
            // No AsNoTracking - we want to update this
            .FirstOrDefaultAsync(p => p.Id == id);
    }
}
```

**Use AsNoTracking when:**
- Displaying data only (Index, Details views)
- Generating reports
- Exporting data
- Performance is critical

**Don't use AsNoTracking when:**
- You'll update the entity
- You need change tracking
- You're working with navigation properties

### Configuring Soft Deletes

Implement soft delete pattern in repositories:

```csharp
// Add to your entity
public class Pokemon
{
    public int Id { get; set; }
    public string Name { get; set; }
    public bool IsDeleted { get; set; } // Soft delete flag
    public DateTime? DeletedAt { get; set; }
}

// Repository implementation
public class PokemonRepository : Repository<Pokemon>, IPokemonRepository
{
    // Override GetAll to exclude deleted
    public override async Task<List<Pokemon>> GetAllAsync()
    {
        return await _dbSet
            .Where(p => !p.IsDeleted)
            .ToListAsync();
    }

    // Soft delete method
    public async Task SoftDeleteAsync(int id)
    {
        var pokemon = await GetByIdAsync(id);
        if (pokemon != null)
        {
            pokemon.IsDeleted = true;
            pokemon.DeletedAt = DateTime.UtcNow;
            Update(pokemon);
        }
    }

    // Get deleted items (for admin restore)
    public async Task<List<Pokemon>> GetDeletedAsync()
    {
        return await _dbSet
            .Where(p => p.IsDeleted)
            .ToListAsync();
    }

    // Restore deleted item
    public async Task RestoreAsync(int id)
    {
        var pokemon = await _dbSet
            .FirstOrDefaultAsync(p => p.Id == id && p.IsDeleted);

        if (pokemon != null)
        {
            pokemon.IsDeleted = false;
            pokemon.DeletedAt = null;
            Update(pokemon);
        }
    }
}
```

### Configuring Query Filters Globally

Apply filters at DbContext level instead of every query:

```csharp
public class ApplicationDbContext : DbContext
{
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Global query filter
        modelBuilder.Entity<Pokemon>()
            .HasQueryFilter(p => !p.IsDeleted);

        base.OnModelCreating(modelBuilder);
    }
}

// Now all queries automatically filter out deleted items
public async Task<List<Pokemon>> GetAllAsync()
{
    // IsDeleted filter applied automatically
    return await _dbSet.ToListAsync();
}

// Explicitly include deleted if needed
public async Task<List<Pokemon>> GetAllIncludingDeletedAsync()
{
    return await _dbSet
        .IgnoreQueryFilters()
        .ToListAsync();
}
```

---

## 7. Basic Usage

### Creating a Basic CRUD Repository

Let's build a complete CRUD repository from scratch.

**Step 1: Create the Entity**

```csharp
namespace PokemonApp.Models.Entities;

public class Pokemon
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Type { get; set; } = string.Empty;
    public int Level { get; set; }
    public int HP { get; set; }
    public int Attack { get; set; }
    public int Defense { get; set; }

    // Navigation property
    public int TrainerId { get; set; }
    public Trainer? Trainer { get; set; }
}
```

**Step 2: Create the Repository Interface**

```csharp
namespace PokemonApp.Data.Repositories.Interfaces;

public interface IPokemonRepository
{
    // Create
    Task<Pokemon> CreateAsync(Pokemon pokemon);

    // Read
    Task<List<Pokemon>> GetAllAsync();
    Task<Pokemon?> GetByIdAsync(int id);
    Task<Pokemon?> GetByNameAsync(string name);
    Task<List<Pokemon>> GetByTrainerAsync(int trainerId);

    // Update
    Task<Pokemon?> UpdateAsync(Pokemon pokemon);

    // Delete
    Task<bool> DeleteAsync(int id);

    // Query helpers
    Task<bool> ExistsAsync(int id);
    Task<bool> NameExistsAsync(string name);
}
```

**Step 3: Implement the Repository**

```csharp
namespace PokemonApp.Data.Repositories;

public class PokemonRepository : IPokemonRepository
{
    private readonly ApplicationDbContext _context;

    public PokemonRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    // CREATE
    public async Task<Pokemon> CreateAsync(Pokemon pokemon)
    {
        await _context.Pokemon.AddAsync(pokemon);
        // Note: Caller must call SaveChangesAsync
        return pokemon;
    }

    // READ - All
    public async Task<List<Pokemon>> GetAllAsync()
    {
        return await _context.Pokemon
            .Include(p => p.Trainer)
            .OrderBy(p => p.Name)
            .AsNoTracking()
            .ToListAsync();
    }

    // READ - By ID
    public async Task<Pokemon?> GetByIdAsync(int id)
    {
        return await _context.Pokemon
            .Include(p => p.Trainer)
            .FirstOrDefaultAsync(p => p.Id == id);
    }

    // READ - By Name
    public async Task<Pokemon?> GetByNameAsync(string name)
    {
        return await _context.Pokemon
            .FirstOrDefaultAsync(p => p.Name.ToLower() == name.ToLower());
    }

    // READ - By Trainer
    public async Task<List<Pokemon>> GetByTrainerAsync(int trainerId)
    {
        return await _context.Pokemon
            .Where(p => p.TrainerId == trainerId)
            .OrderBy(p => p.Name)
            .AsNoTracking()
            .ToListAsync();
    }

    // UPDATE
    public async Task<Pokemon?> UpdateAsync(Pokemon pokemon)
    {
        var existing = await _context.Pokemon.FindAsync(pokemon.Id);
        if (existing == null)
            return null;

        // Update properties
        existing.Name = pokemon.Name;
        existing.Type = pokemon.Type;
        existing.Level = pokemon.Level;
        existing.HP = pokemon.HP;
        existing.Attack = pokemon.Attack;
        existing.Defense = pokemon.Defense;
        existing.TrainerId = pokemon.TrainerId;

        return existing;
    }

    // DELETE
    public async Task<bool> DeleteAsync(int id)
    {
        var pokemon = await _context.Pokemon.FindAsync(id);
        if (pokemon == null)
            return false;

        _context.Pokemon.Remove(pokemon);
        return true;
    }

    // HELPERS
    public async Task<bool> ExistsAsync(int id)
    {
        return await _context.Pokemon.AnyAsync(p => p.Id == id);
    }

    public async Task<bool> NameExistsAsync(string name)
    {
        return await _context.Pokemon
            .AnyAsync(p => p.Name.ToLower() == name.ToLower());
    }
}
```

**Step 4: Register the Repository**

```csharp
// Program.cs
builder.Services.AddScoped<IPokemonRepository, PokemonRepository>();
```

**Step 5: Use in a Controller**

```csharp
public class PokemonController : Controller
{
    private readonly IPokemonRepository _repository;
    private readonly ApplicationDbContext _context;

    public PokemonController(
        IPokemonRepository repository,
        ApplicationDbContext context)
    {
        _repository = repository;
        _context = context;
    }

    // LIST all Pokemon
    public async Task<IActionResult> Index()
    {
        var pokemon = await _repository.GetAllAsync();
        return View(pokemon);
    }

    // DETAILS of a Pokemon
    public async Task<IActionResult> Details(int id)
    {
        var pokemon = await _repository.GetByIdAsync(id);
        if (pokemon == null)
            return NotFound();

        return View(pokemon);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Pokemon pokemon)
    {
        if (!ModelState.IsValid)
            return View(pokemon);

        // Check if name already exists
        if (await _repository.NameExistsAsync(pokemon.Name))
        {
            ModelState.AddModelError("Name", "A Pokemon with this name already exists.");
            return View(pokemon);
        }

        await _repository.CreateAsync(pokemon);
        await _context.SaveChangesAsync();

        TempData["Success"] = $"{pokemon.Name} has been added!";
        return RedirectToAction(nameof(Index));
    }

    // EDIT - GET
    public async Task<IActionResult> Edit(int id)
    {
        var pokemon = await _repository.GetByIdAsync(id);
        if (pokemon == null)
            return NotFound();

        return View(pokemon);
    }

    // EDIT - POST
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, Pokemon pokemon)
    {
        if (id != pokemon.Id)
            return BadRequest();

        if (!ModelState.IsValid)
            return View(pokemon);

        var updated = await _repository.UpdateAsync(pokemon);
        if (updated == null)
            return NotFound();

        await _context.SaveChangesAsync();

        TempData["Success"] = $"{pokemon.Name} has been updated!";
        return RedirectToAction(nameof(Index));
    }

    // DELETE - GET
    public async Task<IActionResult> Delete(int id)
    {
        var pokemon = await _repository.GetByIdAsync(id);
        if (pokemon == null)
            return NotFound();

        return View(pokemon);
    }

    // DELETE - POST
    [HttpPost, ActionName("Delete")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> DeleteConfirmed(int id)
    {
        var success = await _repository.DeleteAsync(id);
        if (!success)
            return NotFound();

        await _context.SaveChangesAsync();

        TempData["Success"] = "Pokemon has been deleted.";
        return RedirectToAction(nameof(Index));
    }
}
```

### Common Repository Patterns

#### Pagination

```csharp
public async Task<(List<Pokemon> Items, int TotalCount)> GetPagedAsync(
    int pageNumber, int pageSize)
{
    var query = _context.Pokemon.AsQueryable();

    var totalCount = await query.CountAsync();

    var items = await query
        .OrderBy(p => p.Name)
        .Skip((pageNumber - 1) * pageSize)
        .Take(pageSize)
        .ToListAsync();

    return (items, totalCount);
}
```

#### Filtering

```csharp
public async Task<List<Pokemon>> GetFilteredAsync(
    string? type = null,
    int? minLevel = null,
    int? maxLevel = null)
{
    var query = _context.Pokemon.AsQueryable();

    if (!string.IsNullOrWhiteSpace(type))
        query = query.Where(p => p.Type == type);

    if (minLevel.HasValue)
        query = query.Where(p => p.Level >= minLevel.Value);

    if (maxLevel.HasValue)
        query = query.Where(p => p.Level <= maxLevel.Value);

    return await query.ToListAsync();
}
```

#### Sorting

```csharp
public async Task<List<Pokemon>> GetSortedAsync(string sortBy, bool descending = false)
{
    var query = _context.Pokemon.AsQueryable();

    query = sortBy.ToLower() switch
    {
        "name" => descending ? query.OrderByDescending(p => p.Name) : query.OrderBy(p => p.Name),
        "level" => descending ? query.OrderByDescending(p => p.Level) : query.OrderBy(p => p.Level),
        "type" => descending ? query.OrderByDescending(p => p.Type) : query.OrderBy(p => p.Type),
        _ => query.OrderBy(p => p.Id)
    };

    return await query.ToListAsync();
}
```

---

## 8. Testing & Validation

### Exercise 1: Create a Simple Repository (Beginner)

**Objective:** Create a basic repository for the `Trainer` entity.

**Requirements:**
1. Create a `Trainer` entity with Id, Name, and Age properties
2. Create an `ITrainerRepository` interface with GetAll and GetById methods
3. Implement the `TrainerRepository` class
4. Register the repository in Program.cs
5. Use it in a controller to display all trainers

**Hints:**
- Follow the same pattern as the Pokemon repository
- Don't forget async/await
- Register as Scoped lifetime

<details>
<summary>Solution</summary>

**1. Entity:**
```csharp
namespace PokemonApp.Models.Entities;

public class Trainer
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public int Age { get; set; }
    public List<Pokemon> Pokemon { get; set; } = new();
}
```

**2. Interface:**
```csharp
namespace PokemonApp.Data.Repositories.Interfaces;

public interface ITrainerRepository
{
    Task<List<Trainer>> GetAllAsync();
    Task<Trainer?> GetByIdAsync(int id);
    Task AddAsync(Trainer trainer);
    Task<bool> DeleteAsync(int id);
}
```

**3. Implementation:**
```csharp
namespace PokemonApp.Data.Repositories;

public class TrainerRepository : ITrainerRepository
{
    private readonly ApplicationDbContext _context;

    public TrainerRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<List<Trainer>> GetAllAsync()
    {
        return await _context.Trainers
            .Include(t => t.Pokemon)
            .OrderBy(t => t.Name)
            .AsNoTracking()
            .ToListAsync();
    }

    public async Task<Trainer?> GetByIdAsync(int id)
    {
        return await _context.Trainers
            .Include(t => t.Pokemon)
            .FirstOrDefaultAsync(t => t.Id == id);
    }

    public async Task AddAsync(Trainer trainer)
    {
        await _context.Trainers.AddAsync(trainer);
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var trainer = await _context.Trainers.FindAsync(id);
        if (trainer == null)
            return false;

        _context.Trainers.Remove(trainer);
        return true;
    }
}
```

**4. Registration:**
```csharp
// Program.cs
builder.Services.AddScoped<ITrainerRepository, TrainerRepository>();
```

**5. Controller:**
```csharp
public class TrainerController : Controller
{
    private readonly ITrainerRepository _repository;
    private readonly ApplicationDbContext _context;

    public TrainerController(
        ITrainerRepository repository,
        ApplicationDbContext context)
    {
        _repository = repository;
        _context = context;
    }

    public async Task<IActionResult> Index()
    {
        var trainers = await _repository.GetAllAsync();
        return View(trainers);
    }

    public async Task<IActionResult> Details(int id)
    {
        var trainer = await _repository.GetByIdAsync(id);
        if (trainer == null)
            return NotFound();

        return View(trainer);
    }

    [HttpPost]
    public async Task<IActionResult> Create(Trainer trainer)
    {
        if (ModelState.IsValid)
        {
            await _repository.AddAsync(trainer);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }
        return View(trainer);
    }
}
```

</details>

---

### Exercise 2: Implement Generic Repository with Unit of Work (Intermediate)

**Objective:** Create a generic repository and Unit of Work pattern.

**Requirements:**
1. Create a generic `IRepository<T>` interface with basic CRUD methods
2. Implement a generic `Repository<T>` base class
3. Create an `IUnitOfWork` interface that exposes Pokemon and Trainer repositories
4. Implement the `UnitOfWork` class
5. Update a controller to use the Unit of Work instead of individual repositories
6. Demonstrate saving multiple operations in one transaction

**Hints:**
- Use `where T : class` constraint
- UnitOfWork should own the DbContext
- UnitOfWork coordinates SaveChanges across repositories

<details>
<summary>Solution</summary>

**1. Generic Repository Interface:**
```csharp
namespace PokemonApp.Data.Repositories.Interfaces;

public interface IRepository<T> where T : class
{
    Task<List<T>> GetAllAsync();
    Task<T?> GetByIdAsync(int id);
    Task AddAsync(T entity);
    void Update(T entity);
    void Delete(T entity);
    Task<bool> ExistsAsync(int id);
}
```

**2. Generic Repository Implementation:**
```csharp
namespace PokemonApp.Data.Repositories;

public class Repository<T> : IRepository<T> where T : class
{
    protected readonly ApplicationDbContext _context;
    protected readonly DbSet<T> _dbSet;

    public Repository(ApplicationDbContext context)
    {
        _context = context;
        _dbSet = context.Set<T>();
    }

    public virtual async Task<List<T>> GetAllAsync()
    {
        return await _dbSet.ToListAsync();
    }

    public virtual async Task<T?> GetByIdAsync(int id)
    {
        return await _dbSet.FindAsync(id);
    }

    public virtual async Task AddAsync(T entity)
    {
        await _dbSet.AddAsync(entity);
    }

    public virtual void Update(T entity)
    {
        _dbSet.Update(entity);
    }

    public virtual void Delete(T entity)
    {
        _dbSet.Remove(entity);
    }

    public virtual async Task<bool> ExistsAsync(int id)
    {
        var entity = await GetByIdAsync(id);
        return entity != null;
    }
}
```

**3. Unit of Work Interface:**
```csharp
namespace PokemonApp.Data;

public interface IUnitOfWork : IDisposable
{
    IPokemonRepository Pokemon { get; }
    ITrainerRepository Trainers { get; }

    Task<int> SaveChangesAsync();
    Task BeginTransactionAsync();
    Task CommitTransactionAsync();
    Task RollbackTransactionAsync();
}
```

**4. Unit of Work Implementation:**
```csharp
using Microsoft.EntityFrameworkCore.Storage;

namespace PokemonApp.Data;

public class UnitOfWork : IUnitOfWork
{
    private readonly ApplicationDbContext _context;
    private IDbContextTransaction? _transaction;

    public UnitOfWork(ApplicationDbContext context)
    {
        _context = context;
        Pokemon = new PokemonRepository(context);
        Trainers = new TrainerRepository(context);
    }

    public IPokemonRepository Pokemon { get; }
    public ITrainerRepository Trainers { get; }

    public async Task<int> SaveChangesAsync()
    {
        return await _context.SaveChangesAsync();
    }

    public async Task BeginTransactionAsync()
    {
        _transaction = await _context.Database.BeginTransactionAsync();
    }

    public async Task CommitTransactionAsync()
    {
        if (_transaction != null)
        {
            await _transaction.CommitAsync();
            await _transaction.DisposeAsync();
            _transaction = null;
        }
    }

    public async Task RollbackTransactionAsync()
    {
        if (_transaction != null)
        {
            await _transaction.RollbackAsync();
            await _transaction.DisposeAsync();
            _transaction = null;
        }
    }

    public void Dispose()
    {
        _transaction?.Dispose();
        _context.Dispose();
    }
}
```

**5. Registration:**
```csharp
// Program.cs
builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();
```

**6. Controller Using Unit of Work:**
```csharp
public class TrainerController : Controller
{
    private readonly IUnitOfWork _unitOfWork;

    public TrainerController(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    // Create a trainer with their starting Pokemon
    [HttpPost]
    public async Task<IActionResult> CreateWithPokemon(
        Trainer trainer,
        Pokemon startingPokemon)
    {
        if (!ModelState.IsValid)
            return View();

        await _unitOfWork.BeginTransactionAsync();
        try
        {
            // Add trainer
            await _unitOfWork.Trainers.AddAsync(trainer);
            await _unitOfWork.SaveChangesAsync();

            // Add their starting Pokemon
            startingPokemon.TrainerId = trainer.Id;
            await _unitOfWork.Pokemon.AddAsync(startingPokemon);
            await _unitOfWork.SaveChangesAsync();

            await _unitOfWork.CommitTransactionAsync();

            TempData["Success"] = $"Trainer {trainer.Name} created with {startingPokemon.Name}!";
            return RedirectToAction(nameof(Index));
        }
        catch
        {
            await _unitOfWork.RollbackTransactionAsync();
            ModelState.AddModelError("", "An error occurred while creating the trainer.");
            return View();
        }
    }

    // Simple operation without transaction
    public async Task<IActionResult> Index()
    {
        var trainers = await _unitOfWork.Trainers.GetAllAsync();
        return View(trainers);
    }
}
```

</details>

---

### Exercise 3: Add Advanced Repository Features (Challenge)

**Objective:** Extend your repository with pagination, filtering, sorting, and searching.

**Requirements:**
1. Add a `SearchAndFilterAsync` method that accepts:
   - Search term (search in name and type)
   - Type filter
   - Min/max level range
   - Sorting field (name, level, type)
   - Sort direction (ascending/descending)
   - Page number and page size
2. Return both the filtered results and total count
3. Create a ViewModel for the filter parameters
4. Build a controller action that uses all these parameters
5. Create a view with filter form and paginated results

**Hints:**
- Build query incrementally with conditionals
- Use `IQueryable` for deferred execution
- Return tuple for results + count
- Consider using expression trees for dynamic sorting

<details>
<summary>Solution</summary>

**1. Filter ViewModel:**
```csharp
namespace PokemonApp.Models.ViewModels;

public class PokemonFilterViewModel
{
    public string? SearchTerm { get; set; }
    public string? TypeFilter { get; set; }
    public int? MinLevel { get; set; }
    public int? MaxLevel { get; set; }
    public string SortBy { get; set; } = "name";
    public bool SortDescending { get; set; }
    public int PageNumber { get; set; } = 1;
    public int PageSize { get; set; } = 10;
}

public class PokemonPagedResultViewModel
{
    public List<Pokemon> Pokemon { get; set; } = new();
    public int TotalCount { get; set; }
    public int PageNumber { get; set; }
    public int PageSize { get; set; }
    public int TotalPages => (int)Math.Ceiling(TotalCount / (double)PageSize);
    public bool HasPreviousPage => PageNumber > 1;
    public bool HasNextPage => PageNumber < TotalPages;

    // Filter values to maintain in pagination links
    public PokemonFilterViewModel Filter { get; set; } = new();
}
```

**2. Enhanced Repository Interface:**
```csharp
public interface IPokemonRepository : IRepository<Pokemon>
{
    Task<(List<Pokemon> Items, int TotalCount)> SearchAndFilterAsync(
        PokemonFilterViewModel filter);

    Task<List<string>> GetAllTypesAsync();
}
```

**3. Enhanced Repository Implementation:**
```csharp
public class PokemonRepository : Repository<Pokemon>, IPokemonRepository
{
    public PokemonRepository(ApplicationDbContext context) : base(context)
    {
    }

    public async Task<(List<Pokemon> Items, int TotalCount)> SearchAndFilterAsync(
        PokemonFilterViewModel filter)
    {
        var query = _dbSet.Include(p => p.Trainer).AsQueryable();

        // Search
        if (!string.IsNullOrWhiteSpace(filter.SearchTerm))
        {
            var searchLower = filter.SearchTerm.ToLower();
            query = query.Where(p =>
                p.Name.ToLower().Contains(searchLower) ||
                p.Type.ToLower().Contains(searchLower));
        }

        // Filter by type
        if (!string.IsNullOrWhiteSpace(filter.TypeFilter))
        {
            query = query.Where(p => p.Type == filter.TypeFilter);
        }

        // Filter by level range
        if (filter.MinLevel.HasValue)
        {
            query = query.Where(p => p.Level >= filter.MinLevel.Value);
        }

        if (filter.MaxLevel.HasValue)
        {
            query = query.Where(p => p.Level <= filter.MaxLevel.Value);
        }

        // Get total count before pagination
        var totalCount = await query.CountAsync();

        // Sorting
        query = filter.SortBy.ToLower() switch
        {
            "name" => filter.SortDescending
                ? query.OrderByDescending(p => p.Name)
                : query.OrderBy(p => p.Name),
            "level" => filter.SortDescending
                ? query.OrderByDescending(p => p.Level)
                : query.OrderBy(p => p.Level),
            "type" => filter.SortDescending
                ? query.OrderByDescending(p => p.Type)
                : query.OrderBy(p => p.Type),
            _ => query.OrderBy(p => p.Id)
        };

        // Pagination
        var items = await query
            .Skip((filter.PageNumber - 1) * filter.PageSize)
            .Take(filter.PageSize)
            .AsNoTracking()
            .ToListAsync();

        return (items, totalCount);
    }

    public async Task<List<string>> GetAllTypesAsync()
    {
        return await _dbSet
            .Select(p => p.Type)
            .Distinct()
            .OrderBy(t => t)
            .ToListAsync();
    }
}
```

**4. Controller:**
```csharp
public class PokemonController : Controller
{
    private readonly IPokemonRepository _repository;
    private readonly ApplicationDbContext _context;

    public PokemonController(
        IPokemonRepository repository,
        ApplicationDbContext context)
    {
        _repository = repository;
        _context = context;
    }

    public async Task<IActionResult> Index(PokemonFilterViewModel filter)
    {
        // Get filtered and paginated results
        var (items, totalCount) = await _repository.SearchAndFilterAsync(filter);

        // Build view model
        var viewModel = new PokemonPagedResultViewModel
        {
            Pokemon = items,
            TotalCount = totalCount,
            PageNumber = filter.PageNumber,
            PageSize = filter.PageSize,
            Filter = filter
        };

        // Get all types for filter dropdown
        ViewBag.Types = await _repository.GetAllTypesAsync();

        return View(viewModel);
    }
}
```

**5. View (Index.cshtml):**
```cshtml
@model PokemonPagedResultViewModel

<h1>Pokemon List</h1>

<!-- Filter Form -->
<form method="get" asp-action="Index" class="mb-4">
    <div class="row g-3">
        <div class="col-md-3">
            <label>Search</label>
            <input type="text" name="SearchTerm" value="@Model.Filter.SearchTerm"
                   class="form-control" placeholder="Search name or type...">
        </div>

        <div class="col-md-2">
            <label>Type</label>
            <select name="TypeFilter" class="form-select">
                <option value="">All Types</option>
                @foreach (var type in ViewBag.Types)
                {
                    <option value="@type" selected="@(type == Model.Filter.TypeFilter)">
                        @type
                    </option>
                }
            </select>
        </div>

        <div class="col-md-2">
            <label>Min Level</label>
            <input type="number" name="MinLevel" value="@Model.Filter.MinLevel"
                   class="form-control">
        </div>

        <div class="col-md-2">
            <label>Max Level</label>
            <input type="number" name="MaxLevel" value="@Model.Filter.MaxLevel"
                   class="form-control">
        </div>

        <div class="col-md-2">
            <label>Sort By</label>
            <select name="SortBy" class="form-select">
                <option value="name" selected="@(Model.Filter.SortBy == "name")">Name</option>
                <option value="level" selected="@(Model.Filter.SortBy == "level")">Level</option>
                <option value="type" selected="@(Model.Filter.SortBy == "type")">Type</option>
            </select>
        </div>

        <div class="col-md-1">
            <label>Order</label>
            <select name="SortDescending" class="form-select">
                <option value="false" selected="@(!Model.Filter.SortDescending)">Asc</option>
                <option value="true" selected="@Model.Filter.SortDescending">Desc</option>
            </select>
        </div>
    </div>

    <div class="mt-3">
        <button type="submit" class="btn btn-primary">Apply Filters</button>
        <a asp-action="Index" class="btn btn-secondary">Clear</a>
    </div>
</form>

<!-- Results -->
<p>Showing @Model.Pokemon.Count of @Model.TotalCount results</p>

<table class="table">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Level</th>
            <th>Trainer</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        @foreach (var pokemon in Model.Pokemon)
        {
            <tr>
                <td>@pokemon.Name</td>
                <td>@pokemon.Type</td>
                <td>@pokemon.Level</td>
                <td>@pokemon.Trainer?.Name</td>
                <td>
                    <a asp-action="Details" asp-route-id="@pokemon.Id">Details</a>
                </td>
            </tr>
        }
    </tbody>
</table>

<!-- Pagination -->
@if (Model.TotalPages > 1)
{
    <nav>
        <ul class="pagination">
            @if (Model.HasPreviousPage)
            {
                <li class="page-item">
                    <a class="page-link"
                       asp-action="Index"
                       asp-route-PageNumber="@(Model.PageNumber - 1)"
                       asp-route-SearchTerm="@Model.Filter.SearchTerm"
                       asp-route-TypeFilter="@Model.Filter.TypeFilter"
                       asp-route-MinLevel="@Model.Filter.MinLevel"
                       asp-route-MaxLevel="@Model.Filter.MaxLevel"
                       asp-route-SortBy="@Model.Filter.SortBy"
                       asp-route-SortDescending="@Model.Filter.SortDescending">
                        Previous
                    </a>
                </li>
            }

            @for (int i = 1; i <= Model.TotalPages; i++)
            {
                <li class="page-item @(i == Model.PageNumber ? "active" : "")">
                    <a class="page-link"
                       asp-action="Index"
                       asp-route-PageNumber="@i"
                       asp-route-SearchTerm="@Model.Filter.SearchTerm"
                       asp-route-TypeFilter="@Model.Filter.TypeFilter"
                       asp-route-MinLevel="@Model.Filter.MinLevel"
                       asp-route-MaxLevel="@Model.Filter.MaxLevel"
                       asp-route-SortBy="@Model.Filter.SortBy"
                       asp-route-SortDescending="@Model.Filter.SortDescending">
                        @i
                    </a>
                </li>
            }

            @if (Model.HasNextPage)
            {
                <li class="page-item">
                    <a class="page-link"
                       asp-action="Index"
                       asp-route-PageNumber="@(Model.PageNumber + 1)"
                       asp-route-SearchTerm="@Model.Filter.SearchTerm"
                       asp-route-TypeFilter="@Model.Filter.TypeFilter"
                       asp-route-MinLevel="@Model.Filter.MinLevel"
                       asp-route-MaxLevel="@Model.Filter.MaxLevel"
                       asp-route-SortBy="@Model.Filter.SortBy"
                       asp-route-SortDescending="@Model.Filter.SortDescending">
                        Next
                    </a>
                </li>
            }
        </ul>
    </nav>
}
```

</details>

---

## 9. Practical Examples

### Example 1: Repository with Caching

Add caching to frequently accessed data:

```csharp
using Microsoft.Extensions.Caching.Memory;

public class CachedPokemonRepository : IPokemonRepository
{
    private readonly PokemonRepository _innerRepository;
    private readonly IMemoryCache _cache;
    private const string ALL_POKEMON_CACHE_KEY = "all_pokemon";
    private readonly TimeSpan _cacheExpiration = TimeSpan.FromMinutes(5);

    public CachedPokemonRepository(
        ApplicationDbContext context,
        IMemoryCache cache)
    {
        _innerRepository = new PokemonRepository(context);
        _cache = cache;
    }

    public async Task<List<Pokemon>> GetAllAsync()
    {
        // Try to get from cache
        if (_cache.TryGetValue(ALL_POKEMON_CACHE_KEY, out List<Pokemon>? cachedPokemon))
        {
            return cachedPokemon!;
        }

        // Not in cache, get from database
        var pokemon = await _innerRepository.GetAllAsync();

        // Store in cache
        _cache.Set(ALL_POKEMON_CACHE_KEY, pokemon, _cacheExpiration);

        return pokemon;
    }

    public async Task<Pokemon?> GetByIdAsync(int id)
    {
        var cacheKey = $"pokemon_{id}";

        if (_cache.TryGetValue(cacheKey, out Pokemon? cachedPokemon))
        {
            return cachedPokemon;
        }

        var pokemon = await _innerRepository.GetByIdAsync(id);

        if (pokemon != null)
        {
            _cache.Set(cacheKey, pokemon, _cacheExpiration);
        }

        return pokemon;
    }

    public async Task AddAsync(Pokemon pokemon)
    {
        await _innerRepository.AddAsync(pokemon);

        // Invalidate cache when adding
        _cache.Remove(ALL_POKEMON_CACHE_KEY);
    }

    public async Task UpdateAsync(Pokemon pokemon)
    {
        await _innerRepository.UpdateAsync(pokemon);

        // Invalidate specific cache
        _cache.Remove($"pokemon_{pokemon.Id}");
        _cache.Remove(ALL_POKEMON_CACHE_KEY);
    }

    // ... other methods follow same pattern
}
```

**Registration:**
```csharp
builder.Services.AddMemoryCache();
builder.Services.AddScoped<IPokemonRepository, CachedPokemonRepository>();
```

### Example 2: Repository with Logging

Add comprehensive logging to track repository operations:

```csharp
using Microsoft.Extensions.Logging;

public class LoggingPokemonRepository : IPokemonRepository
{
    private readonly PokemonRepository _innerRepository;
    private readonly ILogger<LoggingPokemonRepository> _logger;

    public LoggingPokemonRepository(
        ApplicationDbContext context,
        ILogger<LoggingPokemonRepository> logger)
    {
        _innerRepository = new PokemonRepository(context);
        _logger = logger;
    }

    public async Task<List<Pokemon>> GetAllAsync()
    {
        _logger.LogInformation("Fetching all Pokemon");
        var stopwatch = System.Diagnostics.Stopwatch.StartNew();

        try
        {
            var pokemon = await _innerRepository.GetAllAsync();
            stopwatch.Stop();

            _logger.LogInformation(
                "Successfully fetched {Count} Pokemon in {ElapsedMs}ms",
                pokemon.Count,
                stopwatch.ElapsedMilliseconds);

            return pokemon;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching all Pokemon");
            throw;
        }
    }

    public async Task<Pokemon?> GetByIdAsync(int id)
    {
        _logger.LogInformation("Fetching Pokemon with ID {PokemonId}", id);

        try
        {
            var pokemon = await _innerRepository.GetByIdAsync(id);

            if (pokemon == null)
            {
                _logger.LogWarning("Pokemon with ID {PokemonId} not found", id);
            }
            else
            {
                _logger.LogInformation(
                    "Successfully fetched Pokemon {PokemonName} (ID: {PokemonId})",
                    pokemon.Name,
                    id);
            }

            return pokemon;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching Pokemon with ID {PokemonId}", id);
            throw;
        }
    }

    public async Task AddAsync(Pokemon pokemon)
    {
        _logger.LogInformation("Adding new Pokemon: {PokemonName}", pokemon.Name);

        try
        {
            await _innerRepository.AddAsync(pokemon);
            _logger.LogInformation("Successfully added Pokemon: {PokemonName}", pokemon.Name);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error adding Pokemon: {PokemonName}", pokemon.Name);
            throw;
        }
    }

    // ... other methods follow same pattern
}
```

### Example 3: Repository with Specifications Pattern

Use the Specification pattern for complex query logic:

```csharp
// Base specification
public interface ISpecification<T>
{
    Expression<Func<T, bool>> Criteria { get; }
    List<Expression<Func<T, object>>> Includes { get; }
    Expression<Func<T, object>>? OrderBy { get; }
    Expression<Func<T, object>>? OrderByDescending { get; }
}

public abstract class Specification<T> : ISpecification<T>
{
    public Expression<Func<T, bool>> Criteria { get; protected set; } = null!;
    public List<Expression<Func<T, object>>> Includes { get; } = new();
    public Expression<Func<T, object>>? OrderBy { get; protected set; }
    public Expression<Func<T, object>>? OrderByDescending { get; protected set; }

    protected void AddInclude(Expression<Func<T, object>> includeExpression)
    {
        Includes.Add(includeExpression);
    }
}

// Concrete specifications
public class PokemonByTypeSpecification : Specification<Pokemon>
{
    public PokemonByTypeSpecification(string type)
    {
        Criteria = p => p.Type == type;
        AddInclude(p => p.Trainer);
        OrderBy = p => p.Name;
    }
}

public class PokemonByLevelRangeSpecification : Specification<Pokemon>
{
    public PokemonByLevelRangeSpecification(int minLevel, int maxLevel)
    {
        Criteria = p => p.Level >= minLevel && p.Level <= maxLevel;
        OrderByDescending = p => p.Level;
    }
}

public class HighLevelPokemonSpecification : Specification<Pokemon>
{
    public HighLevelPokemonSpecification()
    {
        Criteria = p => p.Level >= 50;
        AddInclude(p => p.Trainer);
        OrderByDescending = p => p.Level;
    }
}

// Repository with specification support
public interface IPokemonRepository
{
    Task<List<Pokemon>> GetAsync(ISpecification<Pokemon> spec);
    Task<Pokemon?> GetSingleAsync(ISpecification<Pokemon> spec);
    Task<int> CountAsync(ISpecification<Pokemon> spec);
}

public class PokemonRepository : IPokemonRepository
{
    private readonly ApplicationDbContext _context;

    public PokemonRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<List<Pokemon>> GetAsync(ISpecification<Pokemon> spec)
    {
        return await ApplySpecification(spec).ToListAsync();
    }

    public async Task<Pokemon?> GetSingleAsync(ISpecification<Pokemon> spec)
    {
        return await ApplySpecification(spec).FirstOrDefaultAsync();
    }

    public async Task<int> CountAsync(ISpecification<Pokemon> spec)
    {
        return await ApplySpecification(spec).CountAsync();
    }

    private IQueryable<Pokemon> ApplySpecification(ISpecification<Pokemon> spec)
    {
        var query = _context.Pokemon.AsQueryable();

        // Apply criteria
        if (spec.Criteria != null)
        {
            query = query.Where(spec.Criteria);
        }

        // Apply includes
        query = spec.Includes
            .Aggregate(query, (current, include) => current.Include(include));

        // Apply ordering
        if (spec.OrderBy != null)
        {
            query = query.OrderBy(spec.OrderBy);
        }
        else if (spec.OrderByDescending != null)
        {
            query = query.OrderByDescending(spec.OrderByDescending);
        }

        return query;
    }
}

// Usage in controller
public class PokemonController : Controller
{
    private readonly IPokemonRepository _repository;

    public async Task<IActionResult> FireType()
    {
        var spec = new PokemonByTypeSpecification("Fire");
        var pokemon = await _repository.GetAsync(spec);
        return View(pokemon);
    }

    public async Task<IActionResult> HighLevel()
    {
        var spec = new HighLevelPokemonSpecification();
        var pokemon = await _repository.GetAsync(spec);
        return View(pokemon);
    }

    public async Task<IActionResult> LevelRange(int min, int max)
    {
        var spec = new PokemonByLevelRangeSpecification(min, max);
        var pokemon = await _repository.GetAsync(spec);
        return View(pokemon);
    }
}
```

### Example 4: Repository with Soft Delete and Audit

Implement soft deletes with audit trail:

```csharp
// Base entity with audit fields
public abstract class AuditableEntity
{
    public int Id { get; set; }
    public DateTime CreatedAt { get; set; }
    public string CreatedBy { get; set; } = string.Empty;
    public DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
    public bool IsDeleted { get; set; }
    public DateTime? DeletedAt { get; set; }
    public string? DeletedBy { get; set; }
}

public class Pokemon : AuditableEntity
{
    public string Name { get; set; } = string.Empty;
    public string Type { get; set; } = string.Empty;
    public int Level { get; set; }
    // ... other properties
}

// Repository with audit tracking
public class AuditablePokemonRepository : Repository<Pokemon>, IPokemonRepository
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public AuditablePokemonRepository(
        ApplicationDbContext context,
        IHttpContextAccessor httpContextAccessor) : base(context)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    private string GetCurrentUser()
    {
        return _httpContextAccessor.HttpContext?.User?.Identity?.Name ?? "System";
    }

    public override async Task AddAsync(Pokemon pokemon)
    {
        pokemon.CreatedAt = DateTime.UtcNow;
        pokemon.CreatedBy = GetCurrentUser();
        pokemon.IsDeleted = false;

        await base.AddAsync(pokemon);
    }

    public override void Update(Pokemon pokemon)
    {
        pokemon.UpdatedAt = DateTime.UtcNow;
        pokemon.UpdatedBy = GetCurrentUser();

        base.Update(pokemon);
    }

    public async Task SoftDeleteAsync(int id)
    {
        var pokemon = await GetByIdAsync(id);
        if (pokemon != null && !pokemon.IsDeleted)
        {
            pokemon.IsDeleted = true;
            pokemon.DeletedAt = DateTime.UtcNow;
            pokemon.DeletedBy = GetCurrentUser();

            Update(pokemon);
        }
    }

    // Override GetAll to exclude deleted
    public override async Task<List<Pokemon>> GetAllAsync()
    {
        return await _dbSet
            .Where(p => !p.IsDeleted)
            .ToListAsync();
    }

    // Admin method to get deleted items
    public async Task<List<Pokemon>> GetDeletedAsync()
    {
        return await _dbSet
            .Where(p => p.IsDeleted)
            .ToListAsync();
    }

    // Restore deleted item
    public async Task RestoreAsync(int id)
    {
        var pokemon = await _dbSet
            .FirstOrDefaultAsync(p => p.Id == id && p.IsDeleted);

        if (pokemon != null)
        {
            pokemon.IsDeleted = false;
            pokemon.DeletedAt = null;
            pokemon.DeletedBy = null;

            Update(pokemon);
        }
    }

    // Get audit history
    public async Task<List<AuditEntry>> GetAuditHistoryAsync(int id)
    {
        var pokemon = await _dbSet.FindAsync(id);
        if (pokemon == null)
            return new List<AuditEntry>();

        var history = new List<AuditEntry>
        {
            new AuditEntry
            {
                Action = "Created",
                Timestamp = pokemon.CreatedAt,
                User = pokemon.CreatedBy
            }
        };

        if (pokemon.UpdatedAt.HasValue)
        {
            history.Add(new AuditEntry
            {
                Action = "Updated",
                Timestamp = pokemon.UpdatedAt.Value,
                User = pokemon.UpdatedBy ?? "Unknown"
            });
        }

        if (pokemon.IsDeleted && pokemon.DeletedAt.HasValue)
        {
            history.Add(new AuditEntry
            {
                Action = "Deleted",
                Timestamp = pokemon.DeletedAt.Value,
                User = pokemon.DeletedBy ?? "Unknown"
            });
        }

        return history.OrderBy(h => h.Timestamp).ToList();
    }
}

public class AuditEntry
{
    public string Action { get; set; } = string.Empty;
    public DateTime Timestamp { get; set; }
    public string User { get; set; } = string.Empty;
}
```

---

## 10. Common Patterns & Best Practices

### Pattern 1: Repository Naming Conventions

Follow consistent naming patterns:

```csharp
// Interface names
public interface IPokemonRepository { }
public interface ITrainerRepository { }
public interface IRepository<T> { }

// Implementation names
public class PokemonRepository : IPokemonRepository { }
public class TrainerRepository : ITrainerRepository { }
public class Repository<T> : IRepository<T> { }

// Method names should be intention-revealing
Task<List<Pokemon>> GetAllAsync();              // Good: Clear intent
Task<List<Pokemon>> GetAsync();                 // Bad: Ambiguous
Task<Pokemon?> GetByIdAsync(int id);           // Good: Specific parameter
Task<Pokemon?> GetAsync(int id);               // Bad: Ambiguous
Task<List<Pokemon>> GetActiveAsync();           // Good: Describes filter
Task<List<Pokemon>> GetSomeAsync();            // Bad: Vague
```

### Pattern 2: Async/Await Best Practices

Always use async for database operations:

```csharp
// GOOD: Async all the way
public async Task<List<Pokemon>> GetAllAsync()
{
    return await _context.Pokemon.ToListAsync();
}

// BAD: Blocking call
public List<Pokemon> GetAll()
{
    return _context.Pokemon.ToList(); // Blocks thread
}

// BAD: Async wrapper around sync
public async Task<List<Pokemon>> GetAllAsync()
{
    return await Task.Run(() => _context.Pokemon.ToList()); // Don't do this
}

// GOOD: Configure await when needed
public async Task<Pokemon?> GetByIdAsync(int id)
{
    return await _context.Pokemon
        .FindAsync(id)
        .ConfigureAwait(false); // In library code
}
```

### Pattern 3: Return Types

Choose appropriate return types:

```csharp
// GOOD: Return concrete types
Task<List<Pokemon>> GetAllAsync();
Task<Pokemon?> GetByIdAsync(int id);

// BAD: Return IQueryable (leaks EF Core details)
IQueryable<Pokemon> GetAll(); // Don't expose IQueryable

// GOOD: Return null for not found
Task<Pokemon?> GetByIdAsync(int id); // Returns null if not found

// ALTERNATIVE: Return result object
Task<Result<Pokemon>> GetByIdAsync(int id); // Returns success/failure

// GOOD: Pagination returns tuple or object
Task<(List<Pokemon> Items, int TotalCount)> GetPagedAsync(int page, int size);
// OR
Task<PagedResult<Pokemon>> GetPagedAsync(int page, int size);
```

### Pattern 4: Error Handling

Handle errors appropriately:

```csharp
public class PokemonRepository : IPokemonRepository
{
    private readonly ILogger<PokemonRepository> _logger;

    // Let data access exceptions bubble up - controller handles them
    public async Task<Pokemon?> GetByIdAsync(int id)
    {
        try
        {
            return await _dbSet.FindAsync(id);
        }
        catch (DbUpdateException ex)
        {
            _logger.LogError(ex, "Database error retrieving Pokemon {Id}", id);
            throw; // Re-throw after logging
        }
    }

    // Return null for "not found" scenarios
    public async Task<Pokemon?> GetByNameAsync(string name)
    {
        return await _dbSet
            .FirstOrDefaultAsync(p => p.Name == name); // Returns null if not found
    }

    // Return boolean for success/failure
    public async Task<bool> ExistsAsync(int id)
    {
        return await _dbSet.AnyAsync(p => p.Id == id);
    }

    // Don't catch exceptions just to log - use filters or middleware
    // BAD:
    public async Task<Pokemon?> BadExample(int id)
    {
        try
        {
            return await _dbSet.FindAsync(id);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error");
            return null; // Swallows exception - bad!
        }
    }
}
```

### Pattern 5: Dependency Injection Lifetimes

Use correct service lifetimes:

```csharp
// CORRECT: Scoped (matches DbContext)
builder.Services.AddScoped<IPokemonRepository, PokemonRepository>();

// WRONG: Singleton (DbContext is scoped, would cause issues)
// Don't do this:
builder.Services.AddSingleton<IPokemonRepository, PokemonRepository>();

// WRONG: Transient (unnecessary overhead)
// Avoid this:
builder.Services.AddTransient<IPokemonRepository, PokemonRepository>();

// Unit of Work also scoped
builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();
```

### Pattern 6: Repository Responsibilities

Keep repositories focused:

```csharp
// GOOD: Repository handles data access only
public class PokemonRepository : IPokemonRepository
{
    public async Task<List<Pokemon>> GetByTrainerIdAsync(int trainerId)
    {
        return await _dbSet
            .Where(p => p.TrainerId == trainerId)
            .ToListAsync();
    }
}

// BAD: Repository contains business logic
public class PokemonRepository : IPokemonRepository
{
    public async Task<Pokemon> LevelUpAsync(int id)
    {
        var pokemon = await GetByIdAsync(id);

        // Business logic doesn't belong here!
        pokemon.Level++;
        if (pokemon.Level % 10 == 0)
        {
            pokemon.HP += 20;
        }

        Update(pokemon);
        return pokemon;
    }
}

// GOOD: Business logic in a service
public class PokemonService
{
    private readonly IPokemonRepository _repository;

    public async Task<Pokemon> LevelUpAsync(int id)
    {
        var pokemon = await _repository.GetByIdAsync(id);

        // Business logic in service layer
        pokemon.Level++;
        if (pokemon.Level % 10 == 0)
        {
            pokemon.HP += 20;
        }

        _repository.Update(pokemon);
        return pokemon;
    }
}
```

### Pattern 7: Testing with Repositories

Repositories make testing easier:

```csharp
// Mock repository for unit testing
public class PokemonControllerTests
{
    [Fact]
    public async Task Index_ReturnsViewWithPokemon()
    {
        // Arrange
        var mockRepo = new Mock<IPokemonRepository>();
        mockRepo.Setup(r => r.GetAllAsync())
            .ReturnsAsync(new List<Pokemon>
            {
                new Pokemon { Id = 1, Name = "Pikachu" },
                new Pokemon { Id = 2, Name = "Charmander" }
            });

        var controller = new PokemonController(mockRepo.Object, null);

        // Act
        var result = await controller.Index();

        // Assert
        var viewResult = Assert.IsType<ViewResult>(result);
        var model = Assert.IsAssignableFrom<List<Pokemon>>(viewResult.Model);
        Assert.Equal(2, model.Count);
    }
}

// In-memory fake repository for integration testing
public class FakePokemonRepository : IPokemonRepository
{
    private readonly List<Pokemon> _pokemon = new();
    private int _nextId = 1;

    public Task<List<Pokemon>> GetAllAsync()
    {
        return Task.FromResult(_pokemon.ToList());
    }

    public Task<Pokemon?> GetByIdAsync(int id)
    {
        return Task.FromResult(_pokemon.FirstOrDefault(p => p.Id == id));
    }

    public Task AddAsync(Pokemon pokemon)
    {
        pokemon.Id = _nextId++;
        _pokemon.Add(pokemon);
        return Task.CompletedTask;
    }

    // ... other methods
}
```

### Pattern 8: Generic Repository Limitations

Know when NOT to use generic repositories:

```csharp
// Generic repository can't express domain-specific queries
public interface IRepository<T>
{
    Task<List<T>> GetAllAsync();
    Task<T?> GetByIdAsync(int id);
}

// How do you express this in generic repository?
// You can't - need specific repository
Task<List<Pokemon>> GetLegendaryPokemonAsync();
Task<List<Pokemon>> GetByTrainerAsync(int trainerId);
Task<Pokemon?> GetStrongestPokemonAsync();

// SOLUTION: Hybrid approach
public interface IPokemonRepository : IRepository<Pokemon>
{
    // Inherit generic CRUD operations
    // Add domain-specific methods
    Task<List<Pokemon>> GetLegendaryPokemonAsync();
    Task<List<Pokemon>> GetByTrainerAsync(int trainerId);
    Task<Pokemon?> GetStrongestPokemonAsync();
}
```

---

## 11. Troubleshooting & Common Issues

### Issue 1: "Object reference not set to an instance" with Includes

**Problem:**
```csharp
var pokemon = await _repository.GetByIdAsync(1);
Console.WriteLine(pokemon.Trainer.Name); // NullReferenceException
```

**Cause:** Navigation properties not loaded.

**Solution:**
```csharp
// Repository must include related entities
public async Task<Pokemon?> GetByIdAsync(int id)
{
    return await _dbSet
        .Include(p => p.Trainer) // Load related data
        .FirstOrDefaultAsync(p => p.Id == id);
}

// Or create specific method
public async Task<Pokemon?> GetWithTrainerAsync(int id)
{
    return await _dbSet
        .Include(p => p.Trainer)
        .FirstOrDefaultAsync(p => p.Id == id);
}
```

### Issue 2: Changes Not Persisting to Database

**Problem:**
```csharp
await _repository.AddAsync(pokemon);
// Pokemon not in database!
```

**Cause:** Forgot to call `SaveChangesAsync`.

**Solution:**
```csharp
// Option 1: Call SaveChanges after repository operation
await _repository.AddAsync(pokemon);
await _context.SaveChangesAsync();

// Option 2: Use Unit of Work
await _unitOfWork.Pokemon.AddAsync(pokemon);
await _unitOfWork.SaveChangesAsync();

// Option 3: Repository saves internally (less flexible)
public async Task AddAsync(Pokemon pokemon)
{
    await _dbSet.AddAsync(pokemon);
    await _context.SaveChangesAsync(); // Repository handles it
}
```

### Issue 3: "A second operation started on this context"

**Problem:**
```csharp
var pokemon = await _repository.GetAllAsync();
foreach (var p in pokemon)
{
    await _repository.UpdateAsync(p); // Error!
}
```

**Cause:** Multiple concurrent operations on same DbContext.

**Solution:**
```csharp
// Solution 1: Wait for each operation
foreach (var p in pokemon)
{
    await _repository.UpdateAsync(p);
    await _context.SaveChangesAsync(); // Complete before next
}

// Solution 2: Batch operations
_repository.UpdateRange(pokemon);
await _context.SaveChangesAsync(); // Single save

// Solution 3: Use AsNoTracking for read-only
public async Task<List<Pokemon>> GetAllAsync()
{
    return await _dbSet
        .AsNoTracking() // Don't track changes
        .ToListAsync();
}
```

### Issue 4: Testing Fails with "Cannot access disposed object"

**Problem:**
```csharp
[Fact]
public async Task TestRepository()
{
    var context = new ApplicationDbContext(options);
    var repo = new PokemonRepository(context);
    context.Dispose();

    var result = await repo.GetAllAsync(); // ObjectDisposedException
}
```

**Cause:** DbContext disposed before repository operation completes.

**Solution:**
```csharp
// Solution 1: Use 'using' statement
[Fact]
public async Task TestRepository()
{
    using var context = new ApplicationDbContext(options);
    var repo = new PokemonRepository(context);
    var result = await repo.GetAllAsync();
    Assert.NotNull(result);
}

// Solution 2: Mock repository instead
[Fact]
public async Task TestController()
{
    var mockRepo = new Mock<IPokemonRepository>();
    mockRepo.Setup(r => r.GetAllAsync())
        .ReturnsAsync(new List<Pokemon> { /* ... */ });

    var controller = new PokemonController(mockRepo.Object);
    var result = await controller.Index();
}
```

### Issue 5: Generic Repository Can't Use Include

**Problem:**
```csharp
public class Repository<T> : IRepository<T> where T : class
{
    public async Task<T?> GetByIdAsync(int id)
    {
        // How do I include related entities generically?
        return await _dbSet.FindAsync(id);
    }
}
```

**Solution:**
```csharp
// Solution 1: Add includes parameter
public async Task<T?> GetByIdAsync(
    int id,
    params Expression<Func<T, object>>[] includes)
{
    var query = _dbSet.AsQueryable();

    foreach (var include in includes)
    {
        query = query.Include(include);
    }

    return await query.FirstOrDefaultAsync(/* find by id */);
}

// Usage
var pokemon = await _repository.GetByIdAsync(1,
    p => p.Trainer,
    p => p.Type);

// Solution 2: Override in specific repository
public class PokemonRepository : Repository<Pokemon>
{
    public override async Task<Pokemon?> GetByIdAsync(int id)
    {
        return await _dbSet
            .Include(p => p.Trainer)
            .FirstOrDefaultAsync(p => p.Id == id);
    }
}
```

### Issue 6: Repository Lifetime Issues

**Problem:**
```csharp
// Registered as Singleton
builder.Services.AddSingleton<IPokemonRepository, PokemonRepository>();

// Runtime error: Cannot consume scoped service from singleton
```

**Cause:** Repository lifetime doesn't match DbContext lifetime.

**Solution:**
```csharp
// CORRECT: Match DbContext lifetime (Scoped)
builder.Services.AddDbContext<ApplicationDbContext>(); // Scoped by default
builder.Services.AddScoped<IPokemonRepository, PokemonRepository>();

// Unit of Work also scoped
builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();
```

### Issue 7: Lazy Loading Not Working

**Problem:**
```csharp
var pokemon = await _repository.GetByIdAsync(1);
var trainerName = pokemon.Trainer.Name; // Trainer is null
```

**Cause:** Lazy loading not configured or disabled.

**Solution:**
```csharp
// Solution 1: Explicitly load with Include (recommended)
public async Task<Pokemon?> GetByIdAsync(int id)
{
    return await _dbSet
        .Include(p => p.Trainer)
        .FirstOrDefaultAsync(p => p.Id == id);
}

// Solution 2: Enable lazy loading (requires Microsoft.EntityFrameworkCore.Proxies)
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options
        .UseSqlServer(connectionString)
        .UseLazyLoadingProxies());

// Make navigation properties virtual
public class Pokemon
{
    public int Id { get; set; }
    public string Name { get; set; }
    public virtual Trainer Trainer { get; set; } // virtual enables lazy loading
}
```

### Issue 8: AsNoTracking Prevents Updates

**Problem:**
```csharp
var pokemon = await _repository.GetByIdAsync(1); // Uses AsNoTracking
pokemon.Level = 50;
_repository.Update(pokemon); // Changes not saved!
```

**Cause:** `AsNoTracking` prevents change tracking.

**Solution:**
```csharp
// Solution 1: Separate methods for display vs edit
public async Task<Pokemon?> GetForDisplayAsync(int id)
{
    return await _dbSet
        .AsNoTracking() // For display only
        .FirstOrDefaultAsync(p => p.Id == id);
}

public async Task<Pokemon?> GetForEditAsync(int id)
{
    return await _dbSet
        // No AsNoTracking - changes tracked
        .FirstOrDefaultAsync(p => p.Id == id);
}

// Solution 2: Attach entity if needed
public void Update(Pokemon pokemon)
{
    _context.Attach(pokemon); // Attach untracked entity
    _context.Entry(pokemon).State = EntityState.Modified;
}
```

---

## 12. Additional Resources

### Official Documentation

- **Entity Framework Core**
  - [EF Core Documentation](https://docs.microsoft.com/en-us/ef/core/)
  - [Querying Data](https://docs.microsoft.com/en-us/ef/core/querying/)
  - [Change Tracking](https://docs.microsoft.com/en-us/ef/core/change-tracking/)

- **ASP.NET Core**
  - [Dependency Injection](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection)
  - [Data Access Best Practices](https://docs.microsoft.com/en-us/aspnet/core/data/)

### Design Patterns

- **Repository Pattern**
  - [Martin Fowler: Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)
  - [Microsoft: Repository Pattern with EF](https://docs.microsoft.com/en-us/aspnet/mvc/overview/older-versions/getting-started-with-ef-5-using-mvc-4/implementing-the-repository-and-unit-of-work-patterns-in-an-asp-net-mvc-application)

- **Unit of Work Pattern**
  - [Martin Fowler: Unit of Work](https://martinfowler.com/eaaCatalog/unitOfWork.html)
  - [Implementing Unit of Work in .NET](https://www.c-sharpcorner.com/article/unit-of-work-in-repository-pattern/)

### Community Resources

- **GitHub Examples**
  - [.NET Architecture Guides](https://github.com/dotnet-architecture)
  - [Clean Architecture Template](https://github.com/jasontaylordev/CleanArchitecture)

- **Blogs and Articles**
  - [Jimmy Bogard: CQRS and EF](https://jimmybogard.com/)
  - [Steve Smith: Ardalis Blog](https://ardalis.com/blog)

### Related PokemonApp Documentation

Review these related topics:

- **POK-13: Entity Framework Core** - Understanding DbContext and entities
- **POK-16: Dependency Injection** - Service registration and lifetimes
- **POK-22: MVC Controllers** - Using repositories in controllers
- **POK-27: Service Layer** - Building services on top of repositories
- **POK-30: Unit Testing** - Testing repositories and controllers

### Books

- **"Entity Framework Core in Action" by Jon P. Smith**
  - Comprehensive EF Core guide
  - Repository pattern implementation
  - Performance optimization

- **"ASP.NET Core in Action" by Andrew Lock**
  - ASP.NET Core architecture
  - Dependency injection
  - Data access patterns

- **"Patterns of Enterprise Application Architecture" by Martin Fowler**
  - Original repository pattern definition
  - Unit of Work pattern
  - Domain-driven design patterns

### Video Courses

- **Pluralsight**
  - "Entity Framework Core: Getting Started"
  - "ASP.NET Core: Advanced"
  - "Design Patterns in C#"

- **YouTube Channels**
  - Nick Chapsas - .NET performance and patterns
  - IAmTimCorey - Practical C# tutorials
  - Milan Jovanović - Software architecture

### Practice Projects

Build these projects to practice repository pattern:

1. **Blog Application**
   - Posts, Comments, Users repositories
   - Complex queries with relationships
   - Implement Unit of Work

2. **E-commerce System**
   - Products, Orders, Customers repositories
   - Transaction handling
   - Performance optimization with caching

3. **Task Management System**
   - Tasks, Projects, Users repositories
   - Specifications pattern
   - Advanced filtering and searching

---

## Summary

The **Repository Pattern** provides a clean abstraction layer between your business logic and data access code. Key takeaways:

**Core Benefits:**
- Separates concerns and improves testability
- Centralizes data access logic
- Makes switching data sources easier
- Provides a consistent API across the application

**Key Concepts:**
- Repository interfaces define contracts
- Implementations handle EF Core complexity
- Generic repositories for common operations
- Specific repositories for domain queries
- Unit of Work coordinates multiple repositories

**Best Practices:**
- Use Scoped lifetime (matches DbContext)
- Return concrete types, not IQueryable
- Always use async/await
- Keep business logic in services, not repositories
- Consider caching for frequently accessed data

**When to Use:**
- Medium to large applications
- Complex data access patterns
- Strong testing requirements
- Team projects needing consistency

**When to Skip:**
- Simple CRUD applications
- Rapid prototyping
- Direct EF Core access is sufficient

You now have a solid foundation for implementing the Repository Pattern in your ASP.NET Core applications. Practice with the exercises, explore the examples, and gradually incorporate these patterns into your projects.

**Next Steps:**
- Complete the three exercises
- Implement repositories in your PokemonApp
- Explore the Unit of Work pattern
- Learn about CQRS for more advanced scenarios
- Study the Specification pattern for complex queries

Happy coding!
