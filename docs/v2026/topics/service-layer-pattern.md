# Service Layer Pattern

## 1. Overview & Introduction

### What is the Service Layer?

The **Service Layer Pattern** is an architectural pattern that acts as a bridge between your controllers (presentation layer) and your data access layer (repositories). Think of services as the "business managers" of your application: they coordinate operations, enforce business rules, and orchestrate complex workflows that involve multiple repositories or external systems.

**Simple Analogy:**
```
Restaurant Example:
- Waiter (Controller): Takes orders, serves food
- Chef (Service): Prepares meals, coordinates cooking
- Pantry (Repository): Stores and retrieves ingredients
- Storage (Database): Raw ingredient storage

The chef doesn't just grab ingredients - they follow recipes,
coordinate timing, ensure quality, and handle special requests.
```

In ASP.NET Core applications, the service layer sits between controllers and repositories, containing your application's business logic.

### Why Use a Service Layer?

1. **Separation of Concerns**: Keep controllers thin and focused on HTTP concerns
2. **Reusability**: Share business logic across multiple controllers or endpoints
3. **Testability**: Test business logic independently of web infrastructure
4. **Maintainability**: Change business rules in one place
5. **Coordination**: Orchestrate operations across multiple repositories
6. **Transaction Management**: Group related operations together

**Without Service Layer:**
```csharp
// Controller with business logic (poor design)
public class PokemonController : Controller
{
    private readonly IPokemonRepository _pokemonRepo;
    private readonly ITrainerRepository _trainerRepo;

    [HttpPost]
    public async Task<IActionResult> CatchPokemon(int pokemonId, int trainerId)
    {
        // Business logic mixed with controller code
        var pokemon = await _pokemonRepo.GetByIdAsync(pokemonId);
        var trainer = await _trainerRepo.GetByIdAsync(trainerId);

        if (trainer.PokemonCount >= 6)
            return BadRequest("Team is full");

        if (pokemon.IsLegendary && !trainer.HasLegendaryLicense)
            return BadRequest("No legendary license");

        pokemon.TrainerId = trainerId;
        pokemon.CaughtDate = DateTime.UtcNow;
        trainer.PokemonCount++;

        await _pokemonRepo.UpdateAsync(pokemon);
        await _trainerRepo.UpdateAsync(trainer);
        await _context.SaveChangesAsync();

        return Ok();
    }
}
```

**With Service Layer (better design):**
```csharp
// Controller delegates to service
public class PokemonController : Controller
{
    private readonly IPokemonService _pokemonService;

    [HttpPost]
    public async Task<IActionResult> CatchPokemon(int pokemonId, int trainerId)
    {
        var result = await _pokemonService.CatchPokemonAsync(pokemonId, trainerId);

        if (!result.Success)
            return BadRequest(result.ErrorMessage);

        return Ok(result.Data);
    }
}

// Service contains business logic
public class PokemonService : IPokemonService
{
    private readonly IPokemonRepository _pokemonRepo;
    private readonly ITrainerRepository _trainerRepo;
    private readonly IUnitOfWork _unitOfWork;

    public async Task<ServiceResult<Pokemon>> CatchPokemonAsync(int pokemonId, int trainerId)
    {
        var pokemon = await _pokemonRepo.GetByIdAsync(pokemonId);
        var trainer = await _trainerRepo.GetByIdAsync(trainerId);

        // Business logic in service
        if (trainer.PokemonCount >= 6)
            return ServiceResult<Pokemon>.Failure("Team is full");

        if (pokemon.IsLegendary && !trainer.HasLegendaryLicense)
            return ServiceResult<Pokemon>.Failure("No legendary license");

        pokemon.TrainerId = trainerId;
        pokemon.CaughtDate = DateTime.UtcNow;
        trainer.PokemonCount++;

        await _pokemonRepo.UpdateAsync(pokemon);
        await _trainerRepo.UpdateAsync(trainer);
        await _unitOfWork.SaveChangesAsync();

        return ServiceResult<Pokemon>.Success(pokemon);
    }
}
```

### Layered Architecture Overview

The service layer fits into a typical layered architecture:

```
┌─────────────────────────────────────────┐
│   Presentation Layer (Controllers)       │
│   - Handle HTTP requests/responses       │
│   - Routing and model binding            │
│   - Return views or JSON                 │
└──────────────┬──────────────────────────┘
               │ Calls
               ▼
┌─────────────────────────────────────────┐
│   Service Layer (Business Logic)         │
│   - Business rules and validation        │
│   - Coordinate multiple repositories     │
│   - Transaction management               │
│   - Domain logic orchestration           │
└──────────────┬──────────────────────────┘
               │ Calls
               ▼
┌─────────────────────────────────────────┐
│   Data Access Layer (Repositories)       │
│   - CRUD operations                      │
│   - Query construction                   │
│   - Data mapping                         │
└──────────────┬──────────────────────────┘
               │ Uses
               ▼
┌─────────────────────────────────────────┐
│   Database (EF Core + SQL Server)        │
│   - Data persistence                     │
│   - Relationships                        │
│   - Constraints                          │
└─────────────────────────────────────────┘
```

**Flow Example:**
1. User submits form → **Controller** receives request
2. Controller calls **Service** method
3. Service enforces **business rules**
4. Service calls **Repository** methods
5. Repository queries **Database**
6. Data flows back up the layers
7. Controller returns **View** or **JSON**

### When to Use a Service Layer

**Use Service Layer When:**
- Building applications with complex business logic
- Multiple controllers need the same business operations
- Operations span multiple repositories
- You need comprehensive unit testing of business logic
- Building an API that will be consumed by multiple clients
- Working in a team requiring clear separation of concerns

**Consider Skipping When:**
- Building simple CRUD applications
- Business logic is trivial or non-existent
- Rapid prototyping with minimal complexity
- The overhead doesn't justify the benefits

### What You'll Learn

By the end of this guide, you'll understand:
- How to design and implement service classes
- The difference between thin and fat services
- How to structure the Controller → Service → Repository flow
- Best practices for service layer architecture
- How to handle transactions and error handling in services
- Strategies for testing services effectively

---

## 2. Quick Start

### Minimal Service Example

Here's a simple service to get you started:

**Step 1: Define the service interface**
```csharp
public interface IPokemonService
{
    Task<List<Pokemon>> GetAllPokemonAsync();
    Task<Pokemon?> GetPokemonByIdAsync(int id);
    Task<Pokemon> CreatePokemonAsync(Pokemon pokemon);
    Task<bool> DeletePokemonAsync(int id);
}
```

**Step 2: Implement the service**
```csharp
public class PokemonService : IPokemonService
{
    private readonly IPokemonRepository _repository;
    private readonly IUnitOfWork _unitOfWork;

    public PokemonService(
        IPokemonRepository repository,
        IUnitOfWork unitOfWork)
    {
        _repository = repository;
        _unitOfWork = unitOfWork;
    }

    public async Task<List<Pokemon>> GetAllPokemonAsync()
    {
        return await _repository.GetAllAsync();
    }

    public async Task<Pokemon?> GetPokemonByIdAsync(int id)
    {
        return await _repository.GetByIdAsync(id);
    }

    public async Task<Pokemon> CreatePokemonAsync(Pokemon pokemon)
    {
        // Business logic here
        pokemon.CaughtDate = DateTime.UtcNow;

        await _repository.AddAsync(pokemon);
        await _unitOfWork.SaveChangesAsync();

        return pokemon;
    }

    public async Task<bool> DeletePokemonAsync(int id)
    {
        var exists = await _repository.ExistsAsync(id);
        if (!exists)
            return false;

        await _repository.DeleteAsync(id);
        await _unitOfWork.SaveChangesAsync();

        return true;
    }
}
```

**Step 3: Register in dependency injection**
```csharp
// Program.cs
builder.Services.AddScoped<IPokemonService, PokemonService>();
```

**Step 4: Use in a controller**
```csharp
public class PokemonController : Controller
{
    private readonly IPokemonService _pokemonService;

    public PokemonController(IPokemonService pokemonService)
    {
        _pokemonService = pokemonService;
    }

    public async Task<IActionResult> Index()
    {
        var pokemon = await _pokemonService.GetAllPokemonAsync();
        return View(pokemon);
    }

    [HttpPost]
    public async Task<IActionResult> Create(Pokemon pokemon)
    {
        if (!ModelState.IsValid)
            return View(pokemon);

        await _pokemonService.CreatePokemonAsync(pokemon);
        return RedirectToAction(nameof(Index));
    }
}
```

**What Just Happened?**
1. Created a service interface defining business operations
2. Implemented the service using repositories
3. Registered it for dependency injection
4. Injected and used it in a controller

This separates business logic from controller logic, making both easier to test and maintain.

---

## 3. Prerequisites

### Required Knowledge

Before diving into service layers, you should be comfortable with:

1. **Repository Pattern** (POK-26)
   - Repository interfaces and implementations
   - Unit of Work pattern
   - Data access abstraction

2. **Dependency Injection** (POK-16)
   - Service lifetimes (Scoped, Transient, Singleton)
   - Constructor injection
   - Service registration

3. **Entity Framework Core** (POK-13)
   - DbContext and entities
   - SaveChanges and transactions
   - Async operations

4. **MVC Controllers** (POK-22)
   - Controller structure
   - Action methods
   - Model validation

5. **C# Fundamentals**
   - Interfaces and implementation
   - Async/await patterns
   - LINQ queries
   - Exception handling

### Required Tools

- **.NET 8.0 SDK** or later
- **Visual Studio 2022**, **VS Code**, or **Rider**
- **Entity Framework Core** packages
- **Repository layer** already implemented

### Project Setup Checklist

Ensure your project has:
- Configured DbContext
- Repository interfaces and implementations
- Unit of Work (recommended)
- Dependency injection configured
- Entity models defined

---

## 4. Core Concepts & Theory

### Understanding the Service Layer

**The Problem:**
In applications without a service layer, controllers become bloated with business logic:

```csharp
// Fat Controller (poor design)
public class PokemonController : Controller
{
    private readonly IPokemonRepository _pokemonRepo;
    private readonly ITrainerRepository _trainerRepo;
    private readonly IBattleRepository _battleRepo;
    private readonly IEmailService _emailService;
    private readonly ILogger<PokemonController> _logger;

    [HttpPost]
    public async Task<IActionResult> TradePokmeon(TradeRequest request)
    {
        // 50+ lines of business logic here
        // Validation logic
        // Calling multiple repositories
        // Sending notifications
        // Logging
        // Error handling
        // Transaction management

        // This is hard to test and maintain!
        return Ok();
    }
}
```

**Problems:**
1. **Tight Coupling**: Controller depends on many repositories and services
2. **Low Reusability**: Logic can't be shared with other controllers or APIs
3. **Testing Difficulty**: Must mock HTTP context even for business logic tests
4. **Maintenance Burden**: Changes require modifying multiple controllers
5. **SRP Violation**: Controller handles HTTP AND business logic

**The Solution: Service Layer**

Extract business logic into dedicated service classes:

```csharp
// Thin Controller (good design)
public class PokemonController : Controller
{
    private readonly IPokemonService _pokemonService;

    public PokemonController(IPokemonService pokemonService)
    {
        _pokemonService = pokemonService;
    }

    [HttpPost]
    public async Task<IActionResult> TradePokemon(TradeRequest request)
    {
        var result = await _pokemonService.TradePokemonAsync(request);

        if (!result.Success)
            return BadRequest(result.ErrorMessage);

        return Ok(result.Data);
    }
}

// Service with business logic
public class PokemonService : IPokemonService
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IEmailService _emailService;
    private readonly ILogger<PokemonService> _logger;

    public async Task<ServiceResult<TradeResult>> TradePokemonAsync(TradeRequest request)
    {
        // All business logic here
        // Easy to test without HTTP context
        // Reusable from multiple controllers
        // Clear separation of concerns
    }
}
```

### Service Layer Responsibilities

A service should:

1. **Contain Business Logic**
   - Validation rules
   - Calculation logic
   - Domain rules enforcement
   - Business workflows

2. **Coordinate Operations**
   - Call multiple repositories
   - Orchestrate complex workflows
   - Manage transactions
   - Handle external service calls

3. **Transform Data**
   - Map entities to DTOs
   - Aggregate data from multiple sources
   - Prepare data for presentation

4. **Handle Exceptions**
   - Catch repository exceptions
   - Return meaningful error messages
   - Log business events

**What a Service Should NOT Do:**
- Handle HTTP concerns (status codes, routing, etc.) - that's the controller's job
- Directly access the database - use repositories
- Contain UI logic - that's the view's job
- Manage user sessions or authentication - use middleware

### Types of Services

#### 1. Domain Services
Focus on a specific domain entity:

```csharp
public interface IPokemonService
{
    Task<List<Pokemon>> GetAllAsync();
    Task<Pokemon?> GetByIdAsync(int id);
    Task<Pokemon> CreateAsync(Pokemon pokemon);
    Task<Pokemon> UpdateAsync(Pokemon pokemon);
    Task<bool> DeleteAsync(int id);
    Task<Pokemon> LevelUpAsync(int id);
    Task<bool> EvolveAsync(int id);
}
```

**Advantages:**
- Clear ownership
- Easy to understand
- Aligns with entities

**Use When:**
- Operations are entity-specific
- Logic doesn't cross multiple domains
- CRUD with business rules

#### 2. Application Services
Coordinate operations across multiple domains:

```csharp
public interface IBattleService
{
    Task<BattleResult> StartBattleAsync(int trainerId1, int trainerId2);
    Task<BattleResult> ExecuteMoveAsync(int battleId, int pokemonId, string move);
    Task<BattleResult> EndBattleAsync(int battleId);
}
```

**Advantages:**
- Handles complex workflows
- Coordinates multiple domain services
- Encapsulates use cases

**Use When:**
- Operations span multiple entities
- Complex business workflows
- Use case orchestration

#### 3. Infrastructure Services
Handle cross-cutting concerns:

```csharp
public interface IEmailService
{
    Task SendEmailAsync(string to, string subject, string body);
    Task SendWelcomeEmailAsync(Trainer trainer);
}

public interface ICacheService
{
    Task<T?> GetAsync<T>(string key);
    Task SetAsync<T>(string key, T value, TimeSpan expiration);
    Task RemoveAsync(string key);
}
```

**Advantages:**
- Reusable across domains
- Centralized infrastructure logic
- Easy to swap implementations

**Use When:**
- Logging, caching, email, etc.
- External service integration
- Cross-cutting concerns

### Service Result Pattern

Instead of throwing exceptions, services often return result objects:

```csharp
// Result class
public class ServiceResult<T>
{
    public bool Success { get; set; }
    public T? Data { get; set; }
    public string? ErrorMessage { get; set; }
    public List<string> Errors { get; set; } = new();

    public static ServiceResult<T> SuccessResult(T data)
    {
        return new ServiceResult<T>
        {
            Success = true,
            Data = data
        };
    }

    public static ServiceResult<T> FailureResult(string error)
    {
        return new ServiceResult<T>
        {
            Success = false,
            ErrorMessage = error
        };
    }
}

// Service using result pattern
public async Task<ServiceResult<Pokemon>> CreatePokemonAsync(Pokemon pokemon)
{
    if (string.IsNullOrWhiteSpace(pokemon.Name))
        return ServiceResult<Pokemon>.FailureResult("Name is required");

    if (await _repository.NameExistsAsync(pokemon.Name))
        return ServiceResult<Pokemon>.FailureResult("Name already exists");

    await _repository.AddAsync(pokemon);
    await _unitOfWork.SaveChangesAsync();

    return ServiceResult<Pokemon>.SuccessResult(pokemon);
}

// Controller handling result
[HttpPost]
public async Task<IActionResult> Create(Pokemon pokemon)
{
    var result = await _pokemonService.CreatePokemonAsync(pokemon);

    if (!result.Success)
        return BadRequest(result.ErrorMessage);

    return CreatedAtAction(nameof(Details), new { id = result.Data.Id }, result.Data);
}
```

**Benefits:**
- Explicit success/failure handling
- Avoids exceptions for business rule violations
- Easier to test
- More predictable control flow

### Transaction Management in Services

Services often coordinate multiple operations that need transactional consistency:

```csharp
public async Task<ServiceResult<TradeResult>> TradePokemonAsync(
    int pokemon1Id,
    int trainer1Id,
    int pokemon2Id,
    int trainer2Id)
{
    await _unitOfWork.BeginTransactionAsync();

    try
    {
        // Get entities
        var pokemon1 = await _unitOfWork.Pokemon.GetByIdAsync(pokemon1Id);
        var pokemon2 = await _unitOfWork.Pokemon.GetByIdAsync(pokemon2Id);
        var trainer1 = await _unitOfWork.Trainers.GetByIdAsync(trainer1Id);
        var trainer2 = await _unitOfWork.Trainers.GetByIdAsync(trainer2Id);

        // Validate
        if (pokemon1.TrainerId != trainer1Id)
            return ServiceResult<TradeResult>.FailureResult("Pokemon 1 doesn't belong to Trainer 1");

        if (pokemon2.TrainerId != trainer2Id)
            return ServiceResult<TradeResult>.FailureResult("Pokemon 2 doesn't belong to Trainer 2");

        // Execute trade
        pokemon1.TrainerId = trainer2Id;
        pokemon2.TrainerId = trainer1Id;

        _unitOfWork.Pokemon.Update(pokemon1);
        _unitOfWork.Pokemon.Update(pokemon2);

        await _unitOfWork.SaveChangesAsync();
        await _unitOfWork.CommitTransactionAsync();

        return ServiceResult<TradeResult>.SuccessResult(new TradeResult
        {
            Pokemon1 = pokemon1,
            Pokemon2 = pokemon2
        });
    }
    catch (Exception ex)
    {
        await _unitOfWork.RollbackTransactionAsync();
        _logger.LogError(ex, "Error during Pokemon trade");
        return ServiceResult<TradeResult>.FailureResult("Trade failed");
    }
}
```

---

## 5. Installation & Configuration

### Step 1: Create Project Structure

Organize your project with proper folder structure:

```
PokemonApp/
├── Controllers/
├── Models/
│   ├── Entities/
│   ├── ViewModels/
│   └── DTOs/            # Data Transfer Objects
├── Data/
│   ├── ApplicationDbContext.cs
│   └── Repositories/
├── Services/            # Service layer
│   ├── Interfaces/
│   │   ├── IPokemonService.cs
│   │   ├── ITrainerService.cs
│   │   └── IBattleService.cs
│   ├── PokemonService.cs
│   ├── TrainerService.cs
│   └── BattleService.cs
├── Common/              # Shared classes
│   └── ServiceResult.cs
├── Views/
├── appsettings.json
└── Program.cs
```

### Step 2: Create Service Result Class

Create `Common/ServiceResult.cs`:

```csharp
namespace PokemonApp.Common;

public class ServiceResult<T>
{
    public bool Success { get; init; }
    public T? Data { get; init; }
    public string? ErrorMessage { get; init; }
    public List<string> Errors { get; init; } = new();

    // Success factory method
    public static ServiceResult<T> SuccessResult(T data)
    {
        return new ServiceResult<T>
        {
            Success = true,
            Data = data
        };
    }

    // Failure factory methods
    public static ServiceResult<T> FailureResult(string errorMessage)
    {
        return new ServiceResult<T>
        {
            Success = false,
            ErrorMessage = errorMessage
        };
    }

    public static ServiceResult<T> FailureResult(List<string> errors)
    {
        return new ServiceResult<T>
        {
            Success = false,
            Errors = errors
        };
    }
}

// Non-generic version for operations without return data
public class ServiceResult
{
    public bool Success { get; init; }
    public string? ErrorMessage { get; init; }
    public List<string> Errors { get; init; } = new();

    public static ServiceResult SuccessResult()
    {
        return new ServiceResult { Success = true };
    }

    public static ServiceResult FailureResult(string errorMessage)
    {
        return new ServiceResult
        {
            Success = false,
            ErrorMessage = errorMessage
        };
    }
}
```

### Step 3: Create Service Interface

Create `Services/Interfaces/IPokemonService.cs`:

```csharp
using PokemonApp.Common;
using PokemonApp.Models.Entities;

namespace PokemonApp.Services.Interfaces;

public interface IPokemonService
{
    // Read operations
    Task<ServiceResult<List<Pokemon>>> GetAllPokemonAsync();
    Task<ServiceResult<Pokemon>> GetPokemonByIdAsync(int id);
    Task<ServiceResult<List<Pokemon>>> SearchPokemonAsync(string searchTerm);

    // Write operations
    Task<ServiceResult<Pokemon>> CreatePokemonAsync(Pokemon pokemon);
    Task<ServiceResult<Pokemon>> UpdatePokemonAsync(Pokemon pokemon);
    Task<ServiceResult> DeletePokemonAsync(int id);

    // Business operations
    Task<ServiceResult<Pokemon>> LevelUpPokemonAsync(int id);
    Task<ServiceResult<Pokemon>> EvolvePokemonAsync(int id);
    Task<ServiceResult<Pokemon>> HealPokemonAsync(int id);

    // Validation
    Task<ServiceResult> ValidatePokemonNameAsync(string name, int? excludeId = null);
}
```

### Step 4: Implement Service

Create `Services/PokemonService.cs`:

```csharp
using Microsoft.Extensions.Logging;
using PokemonApp.Common;
using PokemonApp.Data;
using PokemonApp.Data.Repositories.Interfaces;
using PokemonApp.Models.Entities;
using PokemonApp.Services.Interfaces;

namespace PokemonApp.Services;

public class PokemonService : IPokemonService
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly ILogger<PokemonService> _logger;

    public PokemonService(
        IUnitOfWork unitOfWork,
        ILogger<PokemonService> logger)
    {
        _unitOfWork = unitOfWork;
        _logger = logger;
    }

    public async Task<ServiceResult<List<Pokemon>>> GetAllPokemonAsync()
    {
        try
        {
            var pokemon = await _unitOfWork.Pokemon.GetAllAsync();
            return ServiceResult<List<Pokemon>>.SuccessResult(pokemon);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving all Pokemon");
            return ServiceResult<List<Pokemon>>.FailureResult("Failed to retrieve Pokemon");
        }
    }

    public async Task<ServiceResult<Pokemon>> GetPokemonByIdAsync(int id)
    {
        try
        {
            var pokemon = await _unitOfWork.Pokemon.GetByIdAsync(id);

            if (pokemon == null)
                return ServiceResult<Pokemon>.FailureResult("Pokemon not found");

            return ServiceResult<Pokemon>.SuccessResult(pokemon);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving Pokemon {Id}", id);
            return ServiceResult<Pokemon>.FailureResult("Failed to retrieve Pokemon");
        }
    }

    public async Task<ServiceResult<Pokemon>> CreatePokemonAsync(Pokemon pokemon)
    {
        try
        {
            // Validation
            if (string.IsNullOrWhiteSpace(pokemon.Name))
                return ServiceResult<Pokemon>.FailureResult("Pokemon name is required");

            if (await _unitOfWork.Pokemon.NameExistsAsync(pokemon.Name))
                return ServiceResult<Pokemon>.FailureResult($"Pokemon named '{pokemon.Name}' already exists");

            // Business logic
            pokemon.CaughtDate = DateTime.UtcNow;
            pokemon.HP = pokemon.HP > 0 ? pokemon.HP : 100;

            // Save
            await _unitOfWork.Pokemon.AddAsync(pokemon);
            await _unitOfWork.SaveChangesAsync();

            _logger.LogInformation("Created Pokemon: {Name} (ID: {Id})", pokemon.Name, pokemon.Id);

            return ServiceResult<Pokemon>.SuccessResult(pokemon);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating Pokemon");
            return ServiceResult<Pokemon>.FailureResult("Failed to create Pokemon");
        }
    }

    public async Task<ServiceResult<Pokemon>> UpdatePokemonAsync(Pokemon pokemon)
    {
        try
        {
            var existing = await _unitOfWork.Pokemon.GetByIdAsync(pokemon.Id);
            if (existing == null)
                return ServiceResult<Pokemon>.FailureResult("Pokemon not found");

            // Validation
            if (string.IsNullOrWhiteSpace(pokemon.Name))
                return ServiceResult<Pokemon>.FailureResult("Pokemon name is required");

            // Check name uniqueness (excluding current pokemon)
            var nameExists = await _unitOfWork.Pokemon
                .GetByNameAsync(pokemon.Name);

            if (nameExists != null && nameExists.Id != pokemon.Id)
                return ServiceResult<Pokemon>.FailureResult($"Pokemon named '{pokemon.Name}' already exists");

            // Update
            existing.Name = pokemon.Name;
            existing.Type = pokemon.Type;
            existing.Level = pokemon.Level;
            existing.HP = pokemon.HP;
            existing.Attack = pokemon.Attack;
            existing.Defense = pokemon.Defense;

            _unitOfWork.Pokemon.Update(existing);
            await _unitOfWork.SaveChangesAsync();

            _logger.LogInformation("Updated Pokemon: {Name} (ID: {Id})", existing.Name, existing.Id);

            return ServiceResult<Pokemon>.SuccessResult(existing);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating Pokemon {Id}", pokemon.Id);
            return ServiceResult<Pokemon>.FailureResult("Failed to update Pokemon");
        }
    }

    public async Task<ServiceResult> DeletePokemonAsync(int id)
    {
        try
        {
            var pokemon = await _unitOfWork.Pokemon.GetByIdAsync(id);
            if (pokemon == null)
                return ServiceResult.FailureResult("Pokemon not found");

            await _unitOfWork.Pokemon.DeleteAsync(id);
            await _unitOfWork.SaveChangesAsync();

            _logger.LogInformation("Deleted Pokemon: {Name} (ID: {Id})", pokemon.Name, id);

            return ServiceResult.SuccessResult();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deleting Pokemon {Id}", id);
            return ServiceResult.FailureResult("Failed to delete Pokemon");
        }
    }

    public async Task<ServiceResult<Pokemon>> LevelUpPokemonAsync(int id)
    {
        try
        {
            var pokemon = await _unitOfWork.Pokemon.GetByIdAsync(id);
            if (pokemon == null)
                return ServiceResult<Pokemon>.FailureResult("Pokemon not found");

            // Business logic for leveling up
            pokemon.Level++;
            pokemon.HP += 5;
            pokemon.Attack += 2;
            pokemon.Defense += 2;

            // Check for evolution at level 16
            if (pokemon.Level == 16 && pokemon.CanEvolve)
            {
                pokemon.Name = GetEvolutionName(pokemon.Name);
                pokemon.HP += 20;
                pokemon.Attack += 10;
                pokemon.Defense += 10;
            }

            _unitOfWork.Pokemon.Update(pokemon);
            await _unitOfWork.SaveChangesAsync();

            _logger.LogInformation("Leveled up Pokemon: {Name} to Level {Level}", pokemon.Name, pokemon.Level);

            return ServiceResult<Pokemon>.SuccessResult(pokemon);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error leveling up Pokemon {Id}", id);
            return ServiceResult<Pokemon>.FailureResult("Failed to level up Pokemon");
        }
    }

    public async Task<ServiceResult<Pokemon>> HealPokemonAsync(int id)
    {
        try
        {
            var pokemon = await _unitOfWork.Pokemon.GetByIdAsync(id);
            if (pokemon == null)
                return ServiceResult<Pokemon>.FailureResult("Pokemon not found");

            // Business logic for healing
            var maxHP = CalculateMaxHP(pokemon.Level);
            pokemon.HP = maxHP;

            _unitOfWork.Pokemon.Update(pokemon);
            await _unitOfWork.SaveChangesAsync();

            _logger.LogInformation("Healed Pokemon: {Name} to {HP} HP", pokemon.Name, pokemon.HP);

            return ServiceResult<Pokemon>.SuccessResult(pokemon);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error healing Pokemon {Id}", id);
            return ServiceResult<Pokemon>.FailureResult("Failed to heal Pokemon");
        }
    }

    // Private helper methods for business logic
    private int CalculateMaxHP(int level)
    {
        return 100 + (level * 5);
    }

    private string GetEvolutionName(string currentName)
    {
        // Simplified evolution logic
        return currentName switch
        {
            "Charmander" => "Charmeleon",
            "Squirtle" => "Wartortle",
            "Bulbasaur" => "Ivysaur",
            _ => currentName
        };
    }
}
```

### Step 5: Register Services

Update `Program.cs`:

```csharp
using PokemonApp.Data;
using PokemonApp.Data.Repositories;
using PokemonApp.Data.Repositories.Interfaces;
using PokemonApp.Services;
using PokemonApp.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add DbContext
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Register Unit of Work
builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();

// Register Repositories
builder.Services.AddScoped<IPokemonRepository, PokemonRepository>();
builder.Services.AddScoped<ITrainerRepository, TrainerRepository>();

// Register Services
builder.Services.AddScoped<IPokemonService, PokemonService>();
builder.Services.AddScoped<ITrainerService, TrainerService>();

builder.Services.AddControllersWithViews();

var app = builder.Build();

// Configure middleware...
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

**Important Notes:**
- Use **Scoped** lifetime for services (matches DbContext and repositories)
- Register services after repositories
- Services can depend on other services

### Step 6: Update Controller to Use Service

```csharp
public class PokemonController : Controller
{
    private readonly IPokemonService _pokemonService;

    public PokemonController(IPokemonService pokemonService)
    {
        _pokemonService = pokemonService;
    }

    // GET: Pokemon
    public async Task<IActionResult> Index()
    {
        var result = await _pokemonService.GetAllPokemonAsync();

        if (!result.Success)
        {
            TempData["Error"] = result.ErrorMessage;
            return View(new List<Pokemon>());
        }

        return View(result.Data);
    }

    // GET: Pokemon/Details/5
    public async Task<IActionResult> Details(int id)
    {
        var result = await _pokemonService.GetPokemonByIdAsync(id);

        if (!result.Success)
            return NotFound();

        return View(result.Data);
    }

    // GET: Pokemon/Create
    public IActionResult Create()
    {
        return View();
    }

    // POST: Pokemon/Create
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Pokemon pokemon)
    {
        if (!ModelState.IsValid)
            return View(pokemon);

        var result = await _pokemonService.CreatePokemonAsync(pokemon);

        if (!result.Success)
        {
            ModelState.AddModelError("", result.ErrorMessage);
            return View(pokemon);
        }

        TempData["Success"] = $"{result.Data.Name} has been created!";
        return RedirectToAction(nameof(Index));
    }

    // POST: Pokemon/LevelUp/5
    [HttpPost]
    public async Task<IActionResult> LevelUp(int id)
    {
        var result = await _pokemonService.LevelUpPokemonAsync(id);

        if (!result.Success)
        {
            TempData["Error"] = result.ErrorMessage;
            return RedirectToAction(nameof(Index));
        }

        TempData["Success"] = $"{result.Data.Name} leveled up to {result.Data.Level}!";
        return RedirectToAction(nameof(Details), new { id });
    }
}
```

---

## 6. Configuration & Setup

### Configuring Service Lifetimes

Understanding when to use different service lifetimes:

```csharp
// CORRECT: Scoped (default for most services)
builder.Services.AddScoped<IPokemonService, PokemonService>();

// Use Scoped when:
// - Service depends on DbContext or repositories
// - Service maintains state per request
// - Working with per-request data

// RARE: Transient (new instance every injection)
builder.Services.AddTransient<IEmailService, EmailService>();

// Use Transient when:
// - Service is stateless and lightweight
// - Service should not be shared
// - Each operation needs fresh instance

// RARE: Singleton (single instance for application lifetime)
builder.Services.AddSingleton<ICacheService, MemoryCacheService>();

// Use Singleton when:
// - Service is completely stateless
// - Service is thread-safe
// - Service is expensive to create
// - Should be shared across all requests
```

### Configuring Error Handling

Centralize error handling in services:

```csharp
public class PokemonService : IPokemonService
{
    private async Task<ServiceResult<T>> ExecuteAsync<T>(
        Func<Task<T>> operation,
        string errorMessage)
    {
        try
        {
            var result = await operation();
            return ServiceResult<T>.SuccessResult(result);
        }
        catch (DbUpdateException ex)
        {
            _logger.LogError(ex, "Database error: {Message}", errorMessage);
            return ServiceResult<T>.FailureResult("Database operation failed");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Unexpected error: {Message}", errorMessage);
            return ServiceResult<T>.FailureResult(errorMessage);
        }
    }

    public async Task<ServiceResult<Pokemon>> GetPokemonByIdAsync(int id)
    {
        return await ExecuteAsync(
            async () =>
            {
                var pokemon = await _unitOfWork.Pokemon.GetByIdAsync(id);
                if (pokemon == null)
                    throw new KeyNotFoundException($"Pokemon {id} not found");

                return pokemon;
            },
            "Failed to retrieve Pokemon");
    }
}
```

### Configuring Validation

Separate validation logic into dedicated methods:

```csharp
public class PokemonService : IPokemonService
{
    public async Task<ServiceResult<Pokemon>> CreatePokemonAsync(Pokemon pokemon)
    {
        // Validate first
        var validationResult = await ValidateCreateAsync(pokemon);
        if (!validationResult.Success)
            return validationResult;

        // Business logic
        pokemon.CaughtDate = DateTime.UtcNow;

        // Save
        await _unitOfWork.Pokemon.AddAsync(pokemon);
        await _unitOfWork.SaveChangesAsync();

        return ServiceResult<Pokemon>.SuccessResult(pokemon);
    }

    private async Task<ServiceResult<Pokemon>> ValidateCreateAsync(Pokemon pokemon)
    {
        var errors = new List<string>();

        if (string.IsNullOrWhiteSpace(pokemon.Name))
            errors.Add("Name is required");

        if (pokemon.Level < 1 || pokemon.Level > 100)
            errors.Add("Level must be between 1 and 100");

        if (await _unitOfWork.Pokemon.NameExistsAsync(pokemon.Name))
            errors.Add($"Pokemon named '{pokemon.Name}' already exists");

        if (errors.Any())
            return ServiceResult<Pokemon>.FailureResult(errors);

        return ServiceResult<Pokemon>.SuccessResult(pokemon);
    }
}
```

### Configuring Mapping Between Layers

Use DTOs to decouple layers:

```csharp
// DTO
public class PokemonDto
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }
    public int Level { get; set; }
    public string TrainerName { get; set; }
}

// Service
public interface IPokemonService
{
    Task<ServiceResult<List<PokemonDto>>> GetAllPokemonAsync();
    Task<ServiceResult<PokemonDto>> GetPokemonByIdAsync(int id);
}

public class PokemonService : IPokemonService
{
    public async Task<ServiceResult<List<PokemonDto>>> GetAllPokemonAsync()
    {
        var pokemon = await _unitOfWork.Pokemon.GetAllWithTrainersAsync();

        var dtos = pokemon.Select(p => new PokemonDto
        {
            Id = p.Id,
            Name = p.Name,
            Type = p.Type,
            Level = p.Level,
            TrainerName = p.Trainer?.Name ?? "Wild"
        }).ToList();

        return ServiceResult<List<PokemonDto>>.SuccessResult(dtos);
    }
}
```

---

## 7. Basic Usage

### Creating a Complete CRUD Service

Let's build a complete service from scratch.

**Step 1: Define comprehensive interface**

```csharp
public interface ITrainerService
{
    // CRUD operations
    Task<ServiceResult<List<Trainer>>> GetAllTrainersAsync();
    Task<ServiceResult<Trainer>> GetTrainerByIdAsync(int id);
    Task<ServiceResult<Trainer>> CreateTrainerAsync(Trainer trainer);
    Task<ServiceResult<Trainer>> UpdateTrainerAsync(Trainer trainer);
    Task<ServiceResult> DeleteTrainerAsync(int id);

    // Business operations
    Task<ServiceResult<Trainer>> AddPokemonToTrainerAsync(int trainerId, int pokemonId);
    Task<ServiceResult<Trainer>> RemovePokemonFromTrainerAsync(int trainerId, int pokemonId);
    Task<ServiceResult<List<Pokemon>>> GetTrainerPokemonAsync(int trainerId);

    // Validation
    Task<bool> CanAddMorePokemonAsync(int trainerId);
    Task<bool> IsTrainerNameAvailableAsync(string name, int? excludeId = null);
}
```

**Step 2: Implement the service**

```csharp
public class TrainerService : ITrainerService
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly ILogger<TrainerService> _logger;
    private const int MAX_POKEMON_PER_TRAINER = 6;

    public TrainerService(
        IUnitOfWork unitOfWork,
        ILogger<TrainerService> logger)
    {
        _unitOfWork = unitOfWork;
        _logger = logger;
    }

    // CRUD - Read All
    public async Task<ServiceResult<List<Trainer>>> GetAllTrainersAsync()
    {
        try
        {
            var trainers = await _unitOfWork.Trainers.GetAllAsync();
            return ServiceResult<List<Trainer>>.SuccessResult(trainers);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving trainers");
            return ServiceResult<List<Trainer>>.FailureResult("Failed to retrieve trainers");
        }
    }

    // CRUD - Read One
    public async Task<ServiceResult<Trainer>> GetTrainerByIdAsync(int id)
    {
        try
        {
            var trainer = await _unitOfWork.Trainers.GetByIdAsync(id);

            if (trainer == null)
                return ServiceResult<Trainer>.FailureResult("Trainer not found");

            return ServiceResult<Trainer>.SuccessResult(trainer);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving trainer {Id}", id);
            return ServiceResult<Trainer>.FailureResult("Failed to retrieve trainer");
        }
    }

    // CRUD - Create
    public async Task<ServiceResult<Trainer>> CreateTrainerAsync(Trainer trainer)
    {
        try
        {
            // Validation
            var errors = new List<string>();

            if (string.IsNullOrWhiteSpace(trainer.Name))
                errors.Add("Trainer name is required");

            if (trainer.Age < 10 || trainer.Age > 100)
                errors.Add("Trainer age must be between 10 and 100");

            if (!await IsTrainerNameAvailableAsync(trainer.Name))
                errors.Add($"Trainer name '{trainer.Name}' is already taken");

            if (errors.Any())
                return ServiceResult<Trainer>.FailureResult(errors);

            // Business logic
            trainer.RegistrationDate = DateTime.UtcNow;
            trainer.PokemonCount = 0;

            // Save
            await _unitOfWork.Trainers.AddAsync(trainer);
            await _unitOfWork.SaveChangesAsync();

            _logger.LogInformation("Created trainer: {Name} (ID: {Id})", trainer.Name, trainer.Id);

            return ServiceResult<Trainer>.SuccessResult(trainer);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating trainer");
            return ServiceResult<Trainer>.FailureResult("Failed to create trainer");
        }
    }

    // CRUD - Update
    public async Task<ServiceResult<Trainer>> UpdateTrainerAsync(Trainer trainer)
    {
        try
        {
            var existing = await _unitOfWork.Trainers.GetByIdAsync(trainer.Id);
            if (existing == null)
                return ServiceResult<Trainer>.FailureResult("Trainer not found");

            // Validation
            var errors = new List<string>();

            if (string.IsNullOrWhiteSpace(trainer.Name))
                errors.Add("Trainer name is required");

            if (!await IsTrainerNameAvailableAsync(trainer.Name, trainer.Id))
                errors.Add($"Trainer name '{trainer.Name}' is already taken");

            if (errors.Any())
                return ServiceResult<Trainer>.FailureResult(errors);

            // Update
            existing.Name = trainer.Name;
            existing.Age = trainer.Age;

            _unitOfWork.Trainers.Update(existing);
            await _unitOfWork.SaveChangesAsync();

            _logger.LogInformation("Updated trainer: {Name} (ID: {Id})", existing.Name, existing.Id);

            return ServiceResult<Trainer>.SuccessResult(existing);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating trainer {Id}", trainer.Id);
            return ServiceResult<Trainer>.FailureResult("Failed to update trainer");
        }
    }

    // CRUD - Delete
    public async Task<ServiceResult> DeleteTrainerAsync(int id)
    {
        try
        {
            var trainer = await _unitOfWork.Trainers.GetByIdAsync(id);
            if (trainer == null)
                return ServiceResult.FailureResult("Trainer not found");

            // Business rule: Can't delete trainer with Pokemon
            var pokemonCount = await _unitOfWork.Pokemon.GetCountByTrainerAsync(id);
            if (pokemonCount > 0)
                return ServiceResult.FailureResult("Cannot delete trainer with Pokemon. Release Pokemon first.");

            await _unitOfWork.Trainers.DeleteAsync(id);
            await _unitOfWork.SaveChangesAsync();

            _logger.LogInformation("Deleted trainer: {Name} (ID: {Id})", trainer.Name, id);

            return ServiceResult.SuccessResult();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deleting trainer {Id}", id);
            return ServiceResult.FailureResult("Failed to delete trainer");
        }
    }

    // Business operation
    public async Task<ServiceResult<Trainer>> AddPokemonToTrainerAsync(int trainerId, int pokemonId)
    {
        await _unitOfWork.BeginTransactionAsync();

        try
        {
            var trainer = await _unitOfWork.Trainers.GetByIdAsync(trainerId);
            var pokemon = await _unitOfWork.Pokemon.GetByIdAsync(pokemonId);

            if (trainer == null)
                return ServiceResult<Trainer>.FailureResult("Trainer not found");

            if (pokemon == null)
                return ServiceResult<Trainer>.FailureResult("Pokemon not found");

            // Business rules
            if (!await CanAddMorePokemonAsync(trainerId))
                return ServiceResult<Trainer>.FailureResult($"Trainer already has {MAX_POKEMON_PER_TRAINER} Pokemon");

            if (pokemon.TrainerId != null)
                return ServiceResult<Trainer>.FailureResult("Pokemon already has a trainer");

            // Execute business logic
            pokemon.TrainerId = trainerId;
            pokemon.CaughtDate = DateTime.UtcNow;
            trainer.PokemonCount++;

            _unitOfWork.Pokemon.Update(pokemon);
            _unitOfWork.Trainers.Update(trainer);

            await _unitOfWork.SaveChangesAsync();
            await _unitOfWork.CommitTransactionAsync();

            _logger.LogInformation("Added Pokemon {PokemonName} to Trainer {TrainerName}", pokemon.Name, trainer.Name);

            return ServiceResult<Trainer>.SuccessResult(trainer);
        }
        catch (Exception ex)
        {
            await _unitOfWork.RollbackTransactionAsync();
            _logger.LogError(ex, "Error adding Pokemon to trainer");
            return ServiceResult<Trainer>.FailureResult("Failed to add Pokemon to trainer");
        }
    }

    // Helper methods
    public async Task<bool> CanAddMorePokemonAsync(int trainerId)
    {
        var pokemonCount = await _unitOfWork.Pokemon.GetCountByTrainerAsync(trainerId);
        return pokemonCount < MAX_POKEMON_PER_TRAINER;
    }

    public async Task<bool> IsTrainerNameAvailableAsync(string name, int? excludeId = null)
    {
        var existing = await _unitOfWork.Trainers.GetByNameAsync(name);

        if (existing == null)
            return true;

        if (excludeId.HasValue && existing.Id == excludeId.Value)
            return true;

        return false;
    }
}
```

---

## 8. Testing & Validation

### Exercise 1: Create a Basic Service (Beginner)

**Objective:** Create a simple service for managing Pokemon types.

**Requirements:**
1. Create a `TypeService` that manages Pokemon types
2. Implement methods: GetAllTypes, GetTypeByName, GetPokemonByType
3. Add validation to ensure type names are not empty
4. Use the service in a controller
5. Handle errors gracefully with ServiceResult

**Hints:**
- Follow the Pokemon service pattern
- Types could be stored as a simple list or enum
- Remember async/await

<details>
<summary>Solution</summary>

**1. Interface:**
```csharp
public interface ITypeService
{
    Task<ServiceResult<List<string>>> GetAllTypesAsync();
    Task<ServiceResult<List<Pokemon>>> GetPokemonByTypeAsync(string type);
    ServiceResult ValidateType(string type);
}
```

**2. Implementation:**
```csharp
public class TypeService : ITypeService
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly ILogger<TypeService> _logger;

    private static readonly List<string> ValidTypes = new()
    {
        "Fire", "Water", "Grass", "Electric", "Psychic",
        "Ice", "Dragon", "Dark", "Fairy", "Normal"
    };

    public TypeService(
        IUnitOfWork unitOfWork,
        ILogger<TypeService> logger)
    {
        _unitOfWork = unitOfWork;
        _logger = logger;
    }

    public Task<ServiceResult<List<string>>> GetAllTypesAsync()
    {
        return Task.FromResult(ServiceResult<List<string>>.SuccessResult(ValidTypes));
    }

    public async Task<ServiceResult<List<Pokemon>>> GetPokemonByTypeAsync(string type)
    {
        try
        {
            var validation = ValidateType(type);
            if (!validation.Success)
                return ServiceResult<List<Pokemon>>.FailureResult(validation.ErrorMessage);

            var pokemon = await _unitOfWork.Pokemon.GetByTypeAsync(type);
            return ServiceResult<List<Pokemon>>.SuccessResult(pokemon);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting Pokemon by type {Type}", type);
            return ServiceResult<List<Pokemon>>.FailureResult("Failed to retrieve Pokemon");
        }
    }

    public ServiceResult ValidateType(string type)
    {
        if (string.IsNullOrWhiteSpace(type))
            return ServiceResult.FailureResult("Type cannot be empty");

        if (!ValidTypes.Contains(type, StringComparer.OrdinalIgnoreCase))
            return ServiceResult.FailureResult($"Invalid type: {type}");

        return ServiceResult.SuccessResult();
    }
}
```

**3. Controller:**
```csharp
public class TypeController : Controller
{
    private readonly ITypeService _typeService;

    public TypeController(ITypeService typeService)
    {
        _typeService = typeService;
    }

    public async Task<IActionResult> Index()
    {
        var result = await _typeService.GetAllTypesAsync();
        return View(result.Data);
    }

    public async Task<IActionResult> Pokemon(string type)
    {
        var result = await _typeService.GetPokemonByTypeAsync(type);

        if (!result.Success)
        {
            TempData["Error"] = result.ErrorMessage;
            return RedirectToAction(nameof(Index));
        }

        ViewBag.Type = type;
        return View(result.Data);
    }
}
```

**4. Registration:**
```csharp
builder.Services.AddScoped<ITypeService, TypeService>();
```

</details>

---

### Exercise 2: Implement Complex Business Logic (Intermediate)

**Objective:** Create a battle service that orchestrates battles between Pokemon.

**Requirements:**
1. Create `IBattleService` interface with methods for starting, executing, and ending battles
2. Implement battle logic:
   - Each Pokemon takes turns attacking
   - Damage calculation based on Attack/Defense stats
   - Battle ends when one Pokemon's HP reaches 0
   - Winner gains experience points
3. Use transactions to ensure data consistency
4. Add comprehensive validation
5. Return detailed battle results

**Hints:**
- Coordinate multiple repositories (Pokemon, Battle, BattleLog)
- Use Unit of Work for transactions
- Create a BattleResult DTO to return battle details

<details>
<summary>Solution</summary>

**1. Battle DTOs:**
```csharp
public class BattleResult
{
    public int BattleId { get; set; }
    public Pokemon Winner { get; set; }
    public Pokemon Loser { get; set; }
    public List<BattleRound> Rounds { get; set; } = new();
    public int TotalRounds { get; set; }
}

public class BattleRound
{
    public int RoundNumber { get; set; }
    public string Attacker { get; set; }
    public string Defender { get; set; }
    public int Damage { get; set; }
    public int RemainingHP { get; set; }
}
```

**2. Interface:**
```csharp
public interface IBattleService
{
    Task<ServiceResult<BattleResult>> StartBattleAsync(int pokemon1Id, int pokemon2Id);
    Task<ServiceResult<List<Battle>>> GetTrainerBattlesAsync(int trainerId);
    Task<ServiceResult<BattleResult>> GetBattleResultAsync(int battleId);
}
```

**3. Implementation:**
```csharp
public class BattleService : IBattleService
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly ILogger<BattleService> _logger;

    public BattleService(
        IUnitOfWork unitOfWork,
        ILogger<BattleService> logger)
    {
        _unitOfWork = unitOfWork;
        _logger = logger;
    }

    public async Task<ServiceResult<BattleResult>> StartBattleAsync(
        int pokemon1Id,
        int pokemon2Id)
    {
        await _unitOfWork.BeginTransactionAsync();

        try
        {
            // Get Pokemon
            var pokemon1 = await _unitOfWork.Pokemon.GetByIdAsync(pokemon1Id);
            var pokemon2 = await _unitOfWork.Pokemon.GetByIdAsync(pokemon2Id);

            // Validation
            var validation = ValidateBattle(pokemon1, pokemon2);
            if (!validation.Success)
                return ServiceResult<BattleResult>.FailureResult(validation.ErrorMessage);

            // Create battle record
            var battle = new Battle
            {
                Pokemon1Id = pokemon1Id,
                Pokemon2Id = pokemon2Id,
                BattleDate = DateTime.UtcNow
            };

            await _unitOfWork.Battles.AddAsync(battle);
            await _unitOfWork.SaveChangesAsync();

            // Execute battle
            var battleResult = ExecuteBattle(pokemon1, pokemon2, battle.Id);

            // Update Pokemon
            battle.WinnerId = battleResult.Winner.Id;
            battleResult.Winner.Experience += 100;
            battleResult.Winner.Wins++;
            battleResult.Loser.Losses++;

            _unitOfWork.Battles.Update(battle);
            _unitOfWork.Pokemon.Update(battleResult.Winner);
            _unitOfWork.Pokemon.Update(battleResult.Loser);

            await _unitOfWork.SaveChangesAsync();
            await _unitOfWork.CommitTransactionAsync();

            _logger.LogInformation(
                "Battle completed: {Winner} defeated {Loser} in {Rounds} rounds",
                battleResult.Winner.Name,
                battleResult.Loser.Name,
                battleResult.TotalRounds);

            return ServiceResult<BattleResult>.SuccessResult(battleResult);
        }
        catch (Exception ex)
        {
            await _unitOfWork.RollbackTransactionAsync();
            _logger.LogError(ex, "Error during battle");
            return ServiceResult<BattleResult>.FailureResult("Battle failed");
        }
    }

    private ServiceResult ValidateBattle(Pokemon? pokemon1, Pokemon? pokemon2)
    {
        if (pokemon1 == null || pokemon2 == null)
            return ServiceResult.FailureResult("One or both Pokemon not found");

        if (pokemon1.Id == pokemon2.Id)
            return ServiceResult.FailureResult("Pokemon cannot battle itself");

        if (pokemon1.HP <= 0 || pokemon2.HP <= 0)
            return ServiceResult.FailureResult("Both Pokemon must have HP > 0");

        if (pokemon1.TrainerId == pokemon2.TrainerId)
            return ServiceResult.FailureResult("Pokemon from same trainer cannot battle");

        return ServiceResult.SuccessResult();
    }

    private BattleResult ExecuteBattle(Pokemon pokemon1, Pokemon pokemon2, int battleId)
    {
        var rounds = new List<BattleRound>();
        int roundNumber = 1;

        // Clone Pokemon to avoid modifying originals during battle simulation
        int hp1 = pokemon1.HP;
        int hp2 = pokemon2.HP;

        bool pokemon1Turn = true;

        while (hp1 > 0 && hp2 > 0)
        {
            if (pokemon1Turn)
            {
                int damage = CalculateDamage(pokemon1.Attack, pokemon2.Defense);
                hp2 -= damage;

                rounds.Add(new BattleRound
                {
                    RoundNumber = roundNumber,
                    Attacker = pokemon1.Name,
                    Defender = pokemon2.Name,
                    Damage = damage,
                    RemainingHP = Math.Max(hp2, 0)
                });
            }
            else
            {
                int damage = CalculateDamage(pokemon2.Attack, pokemon1.Defense);
                hp1 -= damage;

                rounds.Add(new BattleRound
                {
                    RoundNumber = roundNumber,
                    Attacker = pokemon2.Name,
                    Defender = pokemon1.Name,
                    Damage = damage,
                    RemainingHP = Math.Max(hp1, 0)
                });
            }

            pokemon1Turn = !pokemon1Turn;
            roundNumber++;
        }

        return new BattleResult
        {
            BattleId = battleId,
            Winner = hp1 > 0 ? pokemon1 : pokemon2,
            Loser = hp1 > 0 ? pokemon2 : pokemon1,
            Rounds = rounds,
            TotalRounds = rounds.Count
        };
    }

    private int CalculateDamage(int attack, int defense)
    {
        int baseDamage = attack - (defense / 2);
        return Math.Max(baseDamage, 1); // Minimum 1 damage
    }

    public async Task<ServiceResult<List<Battle>>> GetTrainerBattlesAsync(int trainerId)
    {
        try
        {
            var battles = await _unitOfWork.Battles.GetByTrainerAsync(trainerId);
            return ServiceResult<List<Battle>>.SuccessResult(battles);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting battles for trainer {TrainerId}", trainerId);
            return ServiceResult<List<Battle>>.FailureResult("Failed to retrieve battles");
        }
    }
}
```

**4. Controller:**
```csharp
public class BattleController : Controller
{
    private readonly IBattleService _battleService;
    private readonly IPokemonService _pokemonService;

    public BattleController(
        IBattleService battleService,
        IPokemonService pokemonService)
    {
        _battleService = battleService;
        _pokemonService = pokemonService;
    }

    // GET: Battle/Start
    public async Task<IActionResult> Start()
    {
        var pokemonResult = await _pokemonService.GetAllPokemonAsync();
        return View(pokemonResult.Data);
    }

    // POST: Battle/Start
    [HttpPost]
    public async Task<IActionResult> Start(int pokemon1Id, int pokemon2Id)
    {
        var result = await _battleService.StartBattleAsync(pokemon1Id, pokemon2Id);

        if (!result.Success)
        {
            TempData["Error"] = result.ErrorMessage;
            return RedirectToAction(nameof(Start));
        }

        return RedirectToAction(nameof(Result), new { id = result.Data.BattleId });
    }

    // GET: Battle/Result/5
    public async Task<IActionResult> Result(int id)
    {
        var result = await _battleService.GetBattleResultAsync(id);

        if (!result.Success)
            return NotFound();

        return View(result.Data);
    }
}
```

</details>

---

### Exercise 3: Build Layered Architecture (Challenge)

**Objective:** Refactor an existing controller to use proper layered architecture with services.

**Scenario:** You have a controller with mixed concerns. Refactor it into:
- Controller (presentation layer)
- Service (business logic)
- Repository (data access)

**Requirements:**
1. Identify business logic in the controller
2. Create appropriate service interface
3. Move business logic to service
4. Use ServiceResult for error handling
5. Add comprehensive validation
6. Implement transaction management where needed
7. Add logging
8. Write unit tests for the service

**Starting Code:**
```csharp
// Before: Fat controller with everything
public class TradeController : Controller
{
    private readonly ApplicationDbContext _context;

    [HttpPost]
    public async Task<IActionResult> TradePokemon(int pokemon1Id, int pokemon2Id)
    {
        // Everything is in the controller - bad!
        var pokemon1 = await _context.Pokemon
            .Include(p => p.Trainer)
            .FirstOrDefaultAsync(p => p.Id == pokemon1Id);

        var pokemon2 = await _context.Pokemon
            .Include(p => p.Trainer)
            .FirstOrDefaultAsync(p => p.Id == pokemon2Id);

        if (pokemon1 == null || pokemon2 == null)
            return NotFound();

        if (pokemon1.TrainerId == pokemon2.TrainerId)
            return BadRequest("Cannot trade with yourself");

        var trainer1 = pokemon1.Trainer;
        var trainer2 = pokemon2.Trainer;

        pokemon1.TrainerId = trainer2.Id;
        pokemon2.TrainerId = trainer1.Id;
        pokemon1.TradeDate = DateTime.UtcNow;
        pokemon2.TradeDate = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return Ok();
    }
}
```

<details>
<summary>Solution</summary>

**1. Create Service Interface:**
```csharp
public interface ITradeService
{
    Task<ServiceResult<TradeResult>> TradePokemonAsync(int pokemon1Id, int pokemon2Id);
    Task<ServiceResult<List<Trade>>> GetTradeHistoryAsync(int trainerId);
    Task<ServiceResult<Trade>> GetTradeDetailsAsync(int tradeId);
}

public class TradeResult
{
    public int TradeId { get; set; }
    public Pokemon Pokemon1 { get; set; }
    public Pokemon Pokemon2 { get; set; }
    public Trainer Trainer1 { get; set; }
    public Trainer Trainer2 { get; set; }
    public DateTime TradeDate { get; set; }
}
```

**2. Implement Service:**
```csharp
public class TradeService : ITradeService
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly ILogger<TradeService> _logger;

    public TradeService(
        IUnitOfWork unitOfWork,
        ILogger<TradeService> logger)
    {
        _unitOfWork = unitOfWork;
        _logger = logger;
    }

    public async Task<ServiceResult<TradeResult>> TradePokemonAsync(
        int pokemon1Id,
        int pokemon2Id)
    {
        await _unitOfWork.BeginTransactionAsync();

        try
        {
            // Get Pokemon with their trainers
            var pokemon1 = await _unitOfWork.Pokemon.GetWithTrainerAsync(pokemon1Id);
            var pokemon2 = await _unitOfWork.Pokemon.GetWithTrainerAsync(pokemon2Id);

            // Validation
            var validation = ValidateTrade(pokemon1, pokemon2);
            if (!validation.Success)
                return ServiceResult<TradeResult>.FailureResult(validation.ErrorMessage);

            var trainer1 = pokemon1.Trainer;
            var trainer2 = pokemon2.Trainer;

            // Create trade record
            var trade = new Trade
            {
                Pokemon1Id = pokemon1Id,
                Pokemon2Id = pokemon2Id,
                Trainer1Id = trainer1.Id,
                Trainer2Id = trainer2.Id,
                TradeDate = DateTime.UtcNow
            };

            await _unitOfWork.Trades.AddAsync(trade);
            await _unitOfWork.SaveChangesAsync();

            // Execute trade
            pokemon1.TrainerId = trainer2.Id;
            pokemon2.TrainerId = trainer1.Id;
            pokemon1.TradeDate = trade.TradeDate;
            pokemon2.TradeDate = trade.TradeDate;

            _unitOfWork.Pokemon.Update(pokemon1);
            _unitOfWork.Pokemon.Update(pokemon2);

            await _unitOfWork.SaveChangesAsync();
            await _unitOfWork.CommitTransactionAsync();

            _logger.LogInformation(
                "Trade completed: {Trainer1} traded {Pokemon1} for {Pokemon2} from {Trainer2}",
                trainer1.Name, pokemon1.Name, pokemon2.Name, trainer2.Name);

            var result = new TradeResult
            {
                TradeId = trade.Id,
                Pokemon1 = pokemon1,
                Pokemon2 = pokemon2,
                Trainer1 = trainer1,
                Trainer2 = trainer2,
                TradeDate = trade.TradeDate
            };

            return ServiceResult<TradeResult>.SuccessResult(result);
        }
        catch (Exception ex)
        {
            await _unitOfWork.RollbackTransactionAsync();
            _logger.LogError(ex, "Error during Pokemon trade");
            return ServiceResult<TradeResult>.FailureResult("Trade failed");
        }
    }

    private ServiceResult ValidateTrade(Pokemon? pokemon1, Pokemon? pokemon2)
    {
        if (pokemon1 == null || pokemon2 == null)
            return ServiceResult.FailureResult("One or both Pokemon not found");

        if (pokemon1.Trainer == null || pokemon2.Trainer == null)
            return ServiceResult.FailureResult("One or both Pokemon have no trainer");

        if (pokemon1.TrainerId == pokemon2.TrainerId)
            return ServiceResult.FailureResult("Cannot trade Pokemon from the same trainer");

        if (pokemon1.IsLegendary || pokemon2.IsLegendary)
            return ServiceResult.FailureResult("Legendary Pokemon cannot be traded");

        return ServiceResult.SuccessResult();
    }

    public async Task<ServiceResult<List<Trade>>> GetTradeHistoryAsync(int trainerId)
    {
        try
        {
            var trades = await _unitOfWork.Trades.GetByTrainerAsync(trainerId);
            return ServiceResult<List<Trade>>.SuccessResult(trades);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting trade history for trainer {TrainerId}", trainerId);
            return ServiceResult<List<Trade>>.FailureResult("Failed to retrieve trade history");
        }
    }

    public async Task<ServiceResult<Trade>> GetTradeDetailsAsync(int tradeId)
    {
        try
        {
            var trade = await _unitOfWork.Trades.GetByIdAsync(tradeId);

            if (trade == null)
                return ServiceResult<Trade>.FailureResult("Trade not found");

            return ServiceResult<Trade>.SuccessResult(trade);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting trade details {TradeId}", tradeId);
            return ServiceResult<Trade>.FailureResult("Failed to retrieve trade details");
        }
    }
}
```

**3. Refactored Controller:**
```csharp
// After: Thin controller using service
public class TradeController : Controller
{
    private readonly ITradeService _tradeService;

    public TradeController(ITradeService tradeService)
    {
        _tradeService = tradeService;
    }

    [HttpPost]
    public async Task<IActionResult> TradePokemon(int pokemon1Id, int pokemon2Id)
    {
        var result = await _tradeService.TradePokemonAsync(pokemon1Id, pokemon2Id);

        if (!result.Success)
            return BadRequest(new { error = result.ErrorMessage });

        return Ok(result.Data);
    }

    public async Task<IActionResult> History(int trainerId)
    {
        var result = await _tradeService.GetTradeHistoryAsync(trainerId);

        if (!result.Success)
        {
            TempData["Error"] = result.ErrorMessage;
            return View(new List<Trade>());
        }

        return View(result.Data);
    }
}
```

**4. Unit Tests:**
```csharp
public class TradeServiceTests
{
    private readonly Mock<IUnitOfWork> _mockUnitOfWork;
    private readonly Mock<ILogger<TradeService>> _mockLogger;
    private readonly TradeService _service;

    public TradeServiceTests()
    {
        _mockUnitOfWork = new Mock<IUnitOfWork>();
        _mockLogger = new Mock<ILogger<TradeService>>();
        _service = new TradeService(_mockUnitOfWork.Object, _mockLogger.Object);
    }

    [Fact]
    public async Task TradePokemonAsync_ValidTrade_ReturnsSuccess()
    {
        // Arrange
        var pokemon1 = new Pokemon
        {
            Id = 1,
            Name = "Pikachu",
            TrainerId = 1,
            Trainer = new Trainer { Id = 1, Name = "Ash" }
        };

        var pokemon2 = new Pokemon
        {
            Id = 2,
            Name = "Charmander",
            TrainerId = 2,
            Trainer = new Trainer { Id = 2, Name = "Gary" }
        };

        _mockUnitOfWork.Setup(u => u.Pokemon.GetWithTrainerAsync(1))
            .ReturnsAsync(pokemon1);
        _mockUnitOfWork.Setup(u => u.Pokemon.GetWithTrainerAsync(2))
            .ReturnsAsync(pokemon2);

        // Act
        var result = await _service.TradePokemonAsync(1, 2);

        // Assert
        Assert.True(result.Success);
        Assert.NotNull(result.Data);
        Assert.Equal(2, result.Data.Pokemon1.TrainerId); // Pokemon1 now belongs to Trainer2
        Assert.Equal(1, result.Data.Pokemon2.TrainerId); // Pokemon2 now belongs to Trainer1
    }

    [Fact]
    public async Task TradePokemonAsync_SameTrainer_ReturnsFailure()
    {
        // Arrange
        var trainer = new Trainer { Id = 1, Name = "Ash" };
        var pokemon1 = new Pokemon { Id = 1, TrainerId = 1, Trainer = trainer };
        var pokemon2 = new Pokemon { Id = 2, TrainerId = 1, Trainer = trainer };

        _mockUnitOfWork.Setup(u => u.Pokemon.GetWithTrainerAsync(1))
            .ReturnsAsync(pokemon1);
        _mockUnitOfWork.Setup(u => u.Pokemon.GetWithTrainerAsync(2))
            .ReturnsAsync(pokemon2);

        // Act
        var result = await _service.TradePokemonAsync(1, 2);

        // Assert
        Assert.False(result.Success);
        Assert.Contains("same trainer", result.ErrorMessage, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public async Task TradePokemonAsync_LegendaryPokemon_ReturnsFailure()
    {
        // Arrange
        var pokemon1 = new Pokemon
        {
            Id = 1,
            IsLegendary = true,
            TrainerId = 1,
            Trainer = new Trainer { Id = 1 }
        };

        var pokemon2 = new Pokemon
        {
            Id = 2,
            TrainerId = 2,
            Trainer = new Trainer { Id = 2 }
        };

        _mockUnitOfWork.Setup(u => u.Pokemon.GetWithTrainerAsync(1))
            .ReturnsAsync(pokemon1);
        _mockUnitOfWork.Setup(u => u.Pokemon.GetWithTrainerAsync(2))
            .ReturnsAsync(pokemon2);

        // Act
        var result = await _service.TradePokemonAsync(1, 2);

        // Assert
        Assert.False(result.Success);
        Assert.Contains("Legendary", result.ErrorMessage);
    }
}
```

</details>

---

## 9. Practical Examples

### Example 1: Service with External API Integration

Integrate an external weather API to determine Pokemon type advantages:

```csharp
public interface IWeatherService
{
    Task<string> GetCurrentWeatherAsync(string location);
}

public class WeatherService : IWeatherService
{
    private readonly HttpClient _httpClient;
    private readonly ILogger<WeatherService> _logger;
    private readonly string _apiKey;

    public WeatherService(
        HttpClient httpClient,
        IConfiguration configuration,
        ILogger<WeatherService> logger)
    {
        _httpClient = httpClient;
        _logger = logger;
        _apiKey = configuration["WeatherApi:ApiKey"];
    }

    public async Task<string> GetCurrentWeatherAsync(string location)
    {
        try
        {
            var response = await _httpClient.GetStringAsync(
                $"https://api.weather.com/current?location={location}&key={_apiKey}");

            // Parse and return weather condition
            return "Sunny"; // Simplified
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching weather for {Location}", location);
            return "Unknown";
        }
    }
}

// Battle service uses weather service
public class BattleService : IBattleService
{
    private readonly IWeatherService _weatherService;

    public async Task<ServiceResult<BattleResult>> StartBattleAsync(
        int pokemon1Id,
        int pokemon2Id,
        string location)
    {
        var weather = await _weatherService.GetCurrentWeatherAsync(location);

        // Apply weather bonuses
        int weather Modifier = weather switch
        {
            "Sunny" => pokemon1.Type == "Fire" ? 2 : 1,
            "Rainy" => pokemon1.Type == "Water" ? 2 : 1,
            _ => 1
        };

        // Use weather modifier in battle calculations
        // ...
    }
}

// Registration
builder.Services.AddHttpClient<IWeatherService, WeatherService>();
```

### Example 2: Service with Caching

Add caching to frequently accessed data:

```csharp
public class CachedPokemonService : IPokemonService
{
    private readonly PokemonService _innerService;
    private readonly IMemoryCache _cache;
    private readonly ILogger<CachedPokemonService> _logger;
    private const string CACHE_KEY_PREFIX = "pokemon_";
    private readonly TimeSpan _cacheExpiration = TimeSpan.FromMinutes(5);

    public CachedPokemonService(
        PokemonService innerService,
        IMemoryCache cache,
        ILogger<CachedPokemonService> logger)
    {
        _innerService = innerService;
        _cache = cache;
        _logger = logger;
    }

    public async Task<ServiceResult<List<Pokemon>>> GetAllPokemonAsync()
    {
        const string cacheKey = $"{CACHE_KEY_PREFIX}all";

        if (_cache.TryGetValue(cacheKey, out ServiceResult<List<Pokemon>> cachedResult))
        {
            _logger.LogInformation("Returning cached Pokemon list");
            return cachedResult;
        }

        var result = await _innerService.GetAllPokemonAsync();

        if (result.Success)
        {
            _cache.Set(cacheKey, result, _cacheExpiration);
            _logger.LogInformation("Cached Pokemon list");
        }

        return result;
    }

    public async Task<ServiceResult<Pokemon>> GetPokemonByIdAsync(int id)
    {
        var cacheKey = $"{CACHE_KEY_PREFIX}{id}";

        if (_cache.TryGetValue(cacheKey, out ServiceResult<Pokemon> cachedResult))
        {
            _logger.LogInformation("Returning cached Pokemon {Id}", id);
            return cachedResult;
        }

        var result = await _innerService.GetPokemonByIdAsync(id);

        if (result.Success)
        {
            _cache.Set(cacheKey, result, _cacheExpiration);
        }

        return result;
    }

    public async Task<ServiceResult<Pokemon>> CreatePokemonAsync(Pokemon pokemon)
    {
        var result = await _innerService.CreatePokemonAsync(pokemon);

        if (result.Success)
        {
            // Invalidate cache
            _cache.Remove($"{CACHE_KEY_PREFIX}all");
            _logger.LogInformation("Invalidated Pokemon cache after create");
        }

        return result;
    }

    // Similar pattern for Update and Delete
}

// Registration (decorator pattern)
builder.Services.AddScoped<PokemonService>();
builder.Services.AddScoped<IPokemonService, CachedPokemonService>();
builder.Services.AddMemoryCache();
```

### Example 3: Service with Background Job Processing

Queue long-running operations to background jobs:

```csharp
public interface IBackgroundJobService
{
    void QueueBackgroundWorkItem(Func<CancellationToken, Task> workItem);
}

public class PokemonService : IPokemonService
{
    private readonly IBackgroundJobService _backgroundJobs;
    private readonly IEmailService _emailService;

    public async Task<ServiceResult<Pokemon>> CreatePokemonAsync(Pokemon pokemon)
    {
        // Save Pokemon
        await _unitOfWork.Pokemon.AddAsync(pokemon);
        await _unitOfWork.SaveChangesAsync();

        // Queue welcome email to background
        _backgroundJobs.QueueBackgroundWorkItem(async token =>
        {
            await _emailService.SendWelcomeEmailAsync(pokemon);
        });

        return ServiceResult<Pokemon>.SuccessResult(pokemon);
    }
}
```

---

## 10. Common Patterns & Best Practices

### Pattern 1: Thin Controllers, Fat Services

Controllers should delegate to services:

```csharp
// GOOD: Thin controller
public class PokemonController : Controller
{
    private readonly IPokemonService _service;

    [HttpPost]
    public async Task<IActionResult> Create(Pokemon pokemon)
    {
        if (!ModelState.IsValid)
            return View(pokemon);

        var result = await _service.CreatePokemonAsync(pokemon);

        if (!result.Success)
        {
            ModelState.AddModelError("", result.ErrorMessage);
            return View(pokemon);
        }

        return RedirectToAction(nameof(Index));
    }
}

// BAD: Fat controller
public class PokemonController : Controller
{
    // 100+ lines of business logic in controller methods
}
```

### Pattern 2: Service Result for Error Handling

Always return ServiceResult instead of throwing exceptions:

```csharp
// GOOD: Return result
public async Task<ServiceResult<Pokemon>> CreateAsync(Pokemon pokemon)
{
    if (string.IsNullOrEmpty(pokemon.Name))
        return ServiceResult<Pokemon>.FailureResult("Name required");

    // ...
    return ServiceResult<Pokemon>.SuccessResult(pokemon);
}

// BAD: Throw exceptions for business rules
public async Task<Pokemon> CreateAsync(Pokemon pokemon)
{
    if (string.IsNullOrEmpty(pokemon.Name))
        throw new ArgumentException("Name required"); // Don't do this

    // ...
    return pokemon;
}
```

### Pattern 3: Dependency Injection

Inject dependencies through constructor:

```csharp
// GOOD: Constructor injection
public class PokemonService : IPokemonService
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly ILogger<PokemonService> _logger;

    public PokemonService(
        IUnitOfWork unitOfWork,
        ILogger<PokemonService> logger)
    {
        _unitOfWork = unitOfWork;
        _logger = logger;
    }
}

// BAD: Service locator pattern
public class PokemonService
{
    public async Task<Pokemon> GetAsync(int id)
    {
        var repository = ServiceLocator.Get<IPokemonRepository>(); // Anti-pattern
        return await repository.GetByIdAsync(id);
    }
}
```

### Pattern 4: Single Responsibility

Each service should have one clear responsibility:

```csharp
// GOOD: Focused services
public interface IPokemonService { /* Pokemon operations */ }
public interface ITrainerService { /* Trainer operations */ }
public interface IBattleService { /* Battle operations */ }

// BAD: God service
public interface IApplicationService
{
    // Everything in one service - too broad
    Task<Pokemon> GetPokemonAsync(int id);
    Task<Trainer> GetTrainerAsync(int id);
    Task<Battle> StartBattleAsync(int p1, int p2);
    Task<Email> SendEmailAsync(string to, string subject);
    // ... 50 more methods
}
```

### Pattern 5: Validation Separation

Separate validation from business logic:

```csharp
public class PokemonService
{
    public async Task<ServiceResult<Pokemon>> CreateAsync(Pokemon pokemon)
    {
        // Step 1: Validate
        var validation = await ValidateCreateAsync(pokemon);
        if (!validation.Success)
            return validation;

        // Step 2: Business logic
        pokemon.CaughtDate = DateTime.UtcNow;

        // Step 3: Persist
        await _unitOfWork.Pokemon.AddAsync(pokemon);
        await _unitOfWork.SaveChangesAsync();

        return ServiceResult<Pokemon>.SuccessResult(pokemon);
    }

    private async Task<ServiceResult<Pokemon>> ValidateCreateAsync(Pokemon pokemon)
    {
        // All validation logic here
        var errors = new List<string>();

        if (string.IsNullOrWhiteSpace(pokemon.Name))
            errors.Add("Name is required");

        if (await _unitOfWork.Pokemon.NameExistsAsync(pokemon.Name))
            errors.Add("Name already exists");

        return errors.Any()
            ? ServiceResult<Pokemon>.FailureResult(errors)
            : ServiceResult<Pokemon>.SuccessResult(pokemon);
    }
}
```

---

## 11. Troubleshooting & Common Issues

### Issue 1: Service Lifetime Mismatch

**Problem:**
```csharp
// Service is Scoped
builder.Services.AddScoped<IPokemonService, PokemonService>();

// But controller is registered as Singleton
builder.Services.AddSingleton<PokemonController>(); // Error!
```

**Cause:** Cannot inject scoped service into singleton.

**Solution:**
```csharp
// Match lifetimes
builder.Services.AddScoped<IPokemonService, PokemonService>();
builder.Services.AddScoped<PokemonController>(); // Or use default controller registration
```

### Issue 2: Circular Dependencies

**Problem:**
```csharp
public class PokemonService
{
    public PokemonService(ITrainerService trainerService) { }
}

public class TrainerService
{
    public TrainerService(IPokemonService pokemonService) { } // Circular!
}
```

**Solution:**
```csharp
// Extract shared logic to a third service
public interface IValidationService
{
    Task<bool> ValidatePokemon(Pokemon pokemon);
    Task<bool> ValidateTrainer(Trainer trainer);
}

public class PokemonService
{
    public PokemonService(IValidationService validation) { }
}

public class TrainerService
{
    public TrainerService(IValidationService validation) { }
}
```

### Issue 3: Transaction Not Rolling Back

**Problem:**
```csharp
public async Task<ServiceResult> TradeAsync(int p1, int p2)
{
    await _unitOfWork.BeginTransactionAsync();

    // ... operations ...

    // Forgot to handle exceptions!
    await _unitOfWork.SaveChangesAsync();
    await _unitOfWork.CommitTransactionAsync();
}
```

**Solution:**
```csharp
public async Task<ServiceResult> TradeAsync(int p1, int p2)
{
    await _unitOfWork.BeginTransactionAsync();

    try
    {
        // ... operations ...
        await _unitOfWork.SaveChangesAsync();
        await _unitOfWork.CommitTransactionAsync();
        return ServiceResult.SuccessResult();
    }
    catch
    {
        await _unitOfWork.RollbackTransactionAsync();
        throw; // Or return failure result
    }
}
```

---

## 12. Additional Resources

### Official Documentation

- **Microsoft - Service Layer**
  - [App Architecture](https://docs.microsoft.com/en-us/dotnet/architecture/)
  - [Clean Architecture](https://docs.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure/common-web-application-architectures)

- **Dependency Injection**
  - [DI in ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection)

### Design Patterns

- **Martin Fowler**
  - [Service Layer Pattern](https://martinfowler.com/eaaCatalog/serviceLayer.html)
  - [Domain Model](https://martinfowler.com/eaaCatalog/domainModel.html)

### Related PokemonApp Documentation

- **POK-26: Repository Pattern** - Data access layer
- **POK-16: Dependency Injection** - Service registration
- **POK-30: Unit Testing** - Testing services
- **POK-31: Integration Testing** - Testing full flow

### Books

- **"Clean Architecture" by Robert C. Martin**
- **"Domain-Driven Design" by Eric Evans**
- **"Patterns of Enterprise Application Architecture" by Martin Fowler**

---

## Summary

The **Service Layer Pattern** is essential for building maintainable, testable ASP.NET Core applications. Key takeaways:

**Core Benefits:**
- Separates business logic from presentation
- Makes code more reusable and testable
- Provides clear layered architecture
- Coordinates complex workflows

**Key Concepts:**
- Controllers delegate to services
- Services contain business logic
- Services coordinate repositories
- Use ServiceResult for error handling
- Apply transaction management

**Best Practices:**
- Keep controllers thin
- One responsibility per service
- Always use async/await
- Validate before executing
- Log important operations

**Next Steps:**
- Complete the three exercises
- Refactor existing controllers to use services
- Implement comprehensive error handling
- Add unit tests for services
- Explore CQRS for complex domains

You now have the knowledge to build properly layered ASP.NET Core applications with clean separation of concerns!
