# Pokemon API - Implementation Task List

**Created**: 2026-11-23
**Contract**: [PokemonApp_openapi_contract.yml](./PokemonApp_openapi_contract.yml)
**Documentation**: [DOCUMENTATION_PLAN.md](./DOCUMENTATION_PLAN.md)

---

## Overview

This document lists all implementation tasks required to build the Pokemon API according to the OpenAPI contract. Tasks are organized following the learning path structure from the documentation plan, allowing for progressive development.

**API Endpoints to Implement**:
- `GET /api/pokemon` - Retrieve all Pokemon
- `GET /api/pokemon/{id}` - Retrieve a single Pokemon by ID
- `POST /api/pokemon` - Create a new Pokemon (Admin only, requires JWT)
- `PUT /api/pokemon/{id}` - Update a Pokemon (Admin only, requires JWT)
- `DELETE /api/pokemon/{id}` - Delete a Pokemon (Admin only, requires JWT)

---

## Table of Contents

1. [Module 1: Foundations](#module-1-foundations)
2. [Module 2: ASP.NET Core Web API](#module-2-aspnet-core-web-api)
3. [Module 3: ASP.NET Core MVC (Optional)](#module-3-aspnet-core-mvc-optional)
4. [Module 4: Advanced Concepts](#module-4-advanced-concepts)

---

## Module 1: Foundations

### 1.1 HTTP Protocol Fundamentals ✅ (Theory - No Implementation)

**Concept Tasks**:
- ✅ Understand HTTP methods (GET, POST, PUT, DELETE)
- ✅ Understand HTTP status codes (200, 201, 204, 400, 401, 403, 404, 500)
- ✅ Understand HTTP headers (Content-Type, Authorization, Location)
- ✅ Understand request/response structure

**Reference**: [docs/v2026/topics/http-protocol-fundamentals.md](./topics/http-protocol-fundamentals.md)

---

### 1.2 REST API Principles ✅ (Theory - No Implementation)

**Concept Tasks**:
- ✅ Understand REST architectural constraints
- ✅ Understand resource-based URL design
- ✅ Understand stateless communication
- ✅ Learn RESTful naming conventions
  - Collections: `/api/pokemon` (plural)
  - Single resource: `/api/pokemon/{id}`
  - Verbs via HTTP methods, not URLs

**Reference**: [docs/v2026/topics/rest-api-principles.md](./topics/rest-api-principles.md)

---

### 1.3 JSON Data Format ✅ (Theory - No Implementation)

**Concept Tasks**:
- ✅ Understand JSON syntax
- ✅ Understand JSON serialization/deserialization in C#
- ✅ Learn camelCase naming convention for JSON (required by contract)

**Reference**: [docs/v2026/topics/json-data-format.md](./topics/json-data-format.md)

---

## Module 2: ASP.NET Core Web API

This module contains the core implementation tasks for building the Pokemon API.

---

### 2.1 Introduction to ASP.NET Core

**Setup Tasks**:
- [ ] Verify .NET 8 SDK is installed (`dotnet --version`)
- [ ] Understand ASP.NET Core architecture
- [ ] Understand Kestrel web server
- [ ] Understand middleware pipeline concept

**Reference**: [docs/v2026/topics/aspnet-core-introduction.md](./topics/aspnet-core-introduction.md)

---

### 2.2 Creating Your First Web API Project

**Implementation Tasks**:
- [ ] Create new Web API project
  ```bash
  dotnet new webapi -n PokemonApp.API
  cd PokemonApp.API
  ```
- [ ] Explore project structure
  - `Program.cs` - Application entry point and configuration
  - `Controllers/` - API controllers
  - `appsettings.json` - Configuration settings
  - `Properties/launchSettings.json` - Development server settings
- [ ] Configure HTTPS ports (should match contract: 7000)
  - Update `launchSettings.json` to use port 7000
- [ ] Run the application and verify it starts
  ```bash
  dotnet run
  ```
- [ ] Test default WeatherForecast endpoint
- [ ] Remove WeatherForecast controller and model (clean slate)

**Reference**: [docs/v2026/topics/creating-first-web-api.md](./topics/creating-first-web-api.md)

---

### 2.3 Controllers and Routing

**Implementation Tasks**:
- [ ] Create `PokemonController.cs` in Controllers folder
- [ ] Add `[ApiController]` attribute
- [ ] Add `[Route("api/[controller]")]` attribute (creates `/api/pokemon` route)
- [ ] Inherit from `ControllerBase`
- [ ] Create placeholder GET action method
  ```csharp
  [HttpGet]
  public IActionResult GetAll()
  {
      // Placeholder - will implement later
      return Ok(new { message = "Pokemon endpoint working" });
  }
  ```
- [ ] Test the endpoint: `GET https://localhost:7000/api/pokemon`
- [ ] Understand route parameters for `GET /api/pokemon/{id}`
- [ ] Add placeholder GET by ID action
  ```csharp
  [HttpGet("{id}")]
  public IActionResult GetById(int id)
  {
      return Ok(new { message = $"Getting Pokemon {id}" });
  }
  ```

**Reference**: [docs/v2026/topics/controllers-and-routing.md](./topics/controllers-and-routing.md)

---

### 2.4 Action Results and HTTP Responses

**Implementation Tasks**:
- [ ] Learn different ActionResult types
  - `Ok()` - 200 OK
  - `CreatedAtAction()` - 201 Created with Location header
  - `NoContent()` - 204 No Content
  - `BadRequest()` - 400 Bad Request
  - `Unauthorized()` - 401 Unauthorized
  - `Forbid()` - 403 Forbidden
  - `NotFound()` - 404 Not Found
  - `StatusCode(500)` - 500 Internal Server Error
- [ ] Update placeholder methods to return appropriate status codes
- [ ] Understand `CreatedAtAction()` for POST responses
  - Must return 201 with Location header pointing to new resource
  - Example: `Location: /api/pokemon/1`

**Reference**: [docs/v2026/topics/action-results-http-responses.md](./topics/action-results-http-responses.md)

---

### 2.5 Entity Framework Core Fundamentals

**Implementation Tasks**:
- [ ] Install EF Core NuGet packages
  ```bash
  dotnet add package Microsoft.EntityFrameworkCore
  dotnet add package Microsoft.EntityFrameworkCore.SqlServer
  # OR for SQLite (simpler for learning):
  dotnet add package Microsoft.EntityFrameworkCore.Sqlite
  dotnet add package Microsoft.EntityFrameworkCore.Design
  ```
- [ ] Create `Models/` folder
- [ ] Create `PokemonType` enum
  ```csharp
  public enum PokemonType
  {
      GRASS,
      FIRE,
      FLYING,
      WATER,
      ELECTRIK
  }
  ```
- [ ] Create `Attack` entity class
  ```csharp
  public class Attack
  {
      public int Id { get; set; }
      public string Name { get; set; } // Max 100 chars, required
      public int Points { get; set; }  // 0-100 range

      // Foreign key
      public int PokemonId { get; set; }
      public Pokemon Pokemon { get; set; }
  }
  ```
- [ ] Create `Pokemon` entity class
  ```csharp
  public class Pokemon
  {
      public int Id { get; set; }
      public string Name { get; set; }  // Max 50 chars, required
      public PokemonType Type { get; set; }
      public int DefensePoints { get; set; }  // 0-100
      public int HealthPoints { get; set; }   // 0-100
      public double RarityPercentage { get; set; }  // 0-100
      public string? ImageURL { get; set; }

      // Navigation property
      public ICollection<Attack> Attacks { get; set; } = new List<Attack>();
  }
  ```
- [ ] Create `Data/` folder
- [ ] Create `ApplicationDbContext` class
  ```csharp
  public class ApplicationDbContext : DbContext
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
  ```
- [ ] Configure connection string in `appsettings.json`
  ```json
  {
    "ConnectionStrings": {
      "DefaultConnection": "Data Source=pokemon.db"
    }
  }
  ```
- [ ] Register DbContext in `Program.cs`
  ```csharp
  builder.Services.AddDbContext<ApplicationDbContext>(options =>
      options.UseSqlite(builder.Configuration.GetConnectionString("DefaultConnection")));
  ```

**Reference**: [docs/v2026/topics/entity-framework-core-fundamentals.md](./topics/entity-framework-core-fundamentals.md)

---

### 2.6 EF Core Migrations

**Implementation Tasks**:
- [ ] Install EF Core tools globally (if not installed)
  ```bash
  dotnet tool install --global dotnet-ef
  ```
- [ ] Create initial migration
  ```bash
  dotnet ef migrations add InitialCreate
  ```
- [ ] Review generated migration code in `Migrations/` folder
- [ ] Apply migration to create database
  ```bash
  dotnet ef database update
  ```
- [ ] Verify `pokemon.db` file was created
- [ ] (Optional) Create seed data migration
  ```csharp
  protected override void Up(MigrationBuilder migrationBuilder)
  {
      migrationBuilder.InsertData(
          table: "Pokemon",
          columns: new[] { "Name", "Type", "DefensePoints", "HealthPoints", "RarityPercentage" },
          values: new object[] { "Pikachu", 4, 40, 35, 15.5 }  // 4 = ELECTRIK
      );

      migrationBuilder.InsertData(
          table: "Attacks",
          columns: new[] { "Name", "Points", "PokemonId" },
          values: new object[,]
          {
              { "Éclair", 55, 1 },
              { "Tonnerre", 90, 1 }
          }
      );
  }
  ```

**Reference**: [docs/v2026/topics/ef-core-migrations.md](./topics/ef-core-migrations.md)

---

### 2.7 Data Transfer Objects (DTOs)

**Implementation Tasks**:
- [ ] Create `DTOs/` folder
- [ ] Create `AttackDto` class
  ```csharp
  public class AttackDto
  {
      public string Name { get; set; }
      public int Points { get; set; }
  }
  ```
- [ ] Create `PokemonDto` class (for responses)
  ```csharp
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
  ```
- [ ] Create `CreatePokemonDto` class (for POST requests)
  ```csharp
  public class CreatePokemonDto
  {
      public string Name { get; set; }
      public string Type { get; set; }
      public List<AttackDto> Attacks { get; set; }
      public int DefensePoints { get; set; }
      public int HealthPoints { get; set; }
      public double RarityPercentage { get; set; }
      public string? ImageURL { get; set; }
  }
  ```
- [ ] Create `UpdatePokemonDto` class (for PUT requests)
  ```csharp
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
  ```
- [ ] Create `ErrorResponseDto` class
  ```csharp
  public class ErrorResponseDto
  {
      public string Message { get; set; }
      public int StatusCode { get; set; }
  }
  ```
- [ ] Create mapping extension methods or use AutoMapper
  ```csharp
  public static class PokemonMappingExtensions
  {
      public static PokemonDto ToDto(this Pokemon pokemon)
      {
          return new PokemonDto
          {
              Id = pokemon.Id,
              Name = pokemon.Name,
              Type = pokemon.Type.ToString(),
              Attacks = pokemon.Attacks.Select(a => new AttackDto
              {
                  Name = a.Name,
                  Points = a.Points
              }).ToList(),
              DefensePoints = pokemon.DefensePoints,
              HealthPoints = pokemon.HealthPoints,
              RarityPercentage = pokemon.RarityPercentage,
              ImageURL = pokemon.ImageURL
          };
      }
  }
  ```

**Reference**: [docs/v2026/topics/data-transfer-objects.md](./topics/data-transfer-objects.md)

---

### 2.8 Model Validation

**Implementation Tasks**:
- [ ] Add validation attributes to `CreatePokemonDto`
  ```csharp
  using System.ComponentModel.DataAnnotations;

  public class CreatePokemonDto
  {
      [Required(ErrorMessage = "Le nom est obligatoire")]
      [StringLength(50, MinimumLength = 1, ErrorMessage = "Le nom doit contenir entre 1 et 50 caractères")]
      public string Name { get; set; }

      [Required(ErrorMessage = "Le type est obligatoire")]
      [RegularExpression("GRASS|FIRE|FLYING|WATER|ELECTRIK",
          ErrorMessage = "Le type doit être l'un des suivants: GRASS, FIRE, FLYING, WATER, ELECTRIK")]
      public string Type { get; set; }

      [Required(ErrorMessage = "Au moins une attaque est requise")]
      [MinLength(1, ErrorMessage = "Au moins une attaque est requise")]
      public List<AttackDto> Attacks { get; set; }

      [Range(0, 100, ErrorMessage = "Les points de défense doivent être entre 0 et 100")]
      public int DefensePoints { get; set; }

      [Range(0, 100, ErrorMessage = "Les points de vie doivent être entre 0 et 100")]
      public int HealthPoints { get; set; }

      [Range(0, 100, ErrorMessage = "Le pourcentage de rareté doit être entre 0 et 100")]
      public double RarityPercentage { get; set; }

      [Url(ErrorMessage = "L'URL de l'image n'est pas valide")]
      public string? ImageURL { get; set; }
  }
  ```
- [ ] Add validation attributes to `AttackDto`
  ```csharp
  public class AttackDto
  {
      [Required(ErrorMessage = "Le nom de l'attaque est obligatoire")]
      [StringLength(100, MinimumLength = 1)]
      public string Name { get; set; }

      [Range(0, 100, ErrorMessage = "Les points d'attaque doivent être entre 0 et 100")]
      public int Points { get; set; }
  }
  ```
- [ ] Add same validation to `UpdatePokemonDto`
- [ ] Configure automatic model validation in `Program.cs` (enabled by default)
- [ ] Handle validation errors in controller actions
  ```csharp
  [HttpPost]
  public IActionResult Create([FromBody] CreatePokemonDto dto)
  {
      if (!ModelState.IsValid)
      {
          return BadRequest(ModelState);  // Returns 400 with validation errors
      }

      // Process valid data
  }
  ```
- [ ] Verify validation error response format matches OpenAPI contract
  ```json
  {
    "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
    "title": "One or more validation errors occurred.",
    "status": 400,
    "errors": {
      "Name": ["Le nom est obligatoire"],
      "Attacks": ["Au moins une attaque est requise"]
    }
  }
  ```

**Reference**: [docs/v2026/topics/model-validation.md](./topics/model-validation.md)

---

### 2.9 Dependency Injection in ASP.NET Core

**Implementation Tasks**:
- [ ] Understand DI container and service lifetimes
  - Transient: Created each time requested
  - Scoped: Created once per request
  - Singleton: Created once for application lifetime
- [ ] Plan service architecture
  - Controllers → Services → Repositories → DbContext
- [ ] Create `Interfaces/` folder for abstractions
- [ ] Service registration will be done in sections 2.10 and 2.11

**Reference**: [docs/v2026/topics/dependency-injection.md](./topics/dependency-injection.md)

---

### 2.10 Repository Pattern

**Implementation Tasks**:
- [ ] Create `Interfaces/IRepository.cs` (generic repository interface)
  ```csharp
  public interface IRepository<T> where T : class
  {
      Task<IEnumerable<T>> GetAllAsync();
      Task<T?> GetByIdAsync(int id);
      Task<T> AddAsync(T entity);
      Task UpdateAsync(T entity);
      Task DeleteAsync(T entity);
      Task<bool> ExistsAsync(int id);
  }
  ```
- [ ] Create `Interfaces/IPokemonRepository.cs` (specific repository)
  ```csharp
  public interface IPokemonRepository : IRepository<Pokemon>
  {
      Task<Pokemon?> GetByIdWithAttacksAsync(int id);
      Task<IEnumerable<Pokemon>> GetAllWithAttacksAsync();
  }
  ```
- [ ] Create `Repositories/` folder
- [ ] Create `Repositories/PokemonRepository.cs`
  ```csharp
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

      public async Task<Pokemon?> GetByIdWithAttacksAsync(int id)
      {
          return await GetByIdAsync(id);
      }

      public async Task<IEnumerable<Pokemon>> GetAllWithAttacksAsync()
      {
          return await GetAllAsync();
      }
  }
  ```
- [ ] Register repository in `Program.cs`
  ```csharp
  builder.Services.AddScoped<IPokemonRepository, PokemonRepository>();
  ```

**Reference**: [docs/v2026/topics/repository-pattern.md](./topics/repository-pattern.md)

---

### 2.11 Service Layer Pattern

**Implementation Tasks**:
- [ ] Create `Interfaces/IPokemonService.cs`
  ```csharp
  public interface IPokemonService
  {
      Task<IEnumerable<PokemonDto>> GetAllAsync();
      Task<PokemonDto?> GetByIdAsync(int id);
      Task<PokemonDto> CreateAsync(CreatePokemonDto dto);
      Task<PokemonDto?> UpdateAsync(int id, UpdatePokemonDto dto);
      Task<bool> DeleteAsync(int id);
  }
  ```
- [ ] Create `Services/` folder
- [ ] Create `Services/PokemonService.cs`
  ```csharp
  public class PokemonService : IPokemonService
  {
      private readonly IPokemonRepository _repository;
      private readonly ILogger<PokemonService> _logger;

      public PokemonService(IPokemonRepository repository, ILogger<PokemonService> logger)
      {
          _repository = repository;
          _logger = logger;
      }

      public async Task<IEnumerable<PokemonDto>> GetAllAsync()
      {
          _logger.LogInformation("Fetching all Pokemon");
          var pokemon = await _repository.GetAllAsync();
          return pokemon.Select(p => p.ToDto());
      }

      public async Task<PokemonDto?> GetByIdAsync(int id)
      {
          _logger.LogInformation("Fetching Pokemon with ID {Id}", id);
          var pokemon = await _repository.GetByIdAsync(id);
          return pokemon?.ToDto();
      }

      public async Task<PokemonDto> CreateAsync(CreatePokemonDto dto)
      {
          _logger.LogInformation("Creating new Pokemon: {Name}", dto.Name);

          // Parse type enum
          if (!Enum.TryParse<PokemonType>(dto.Type, out var pokemonType))
          {
              throw new ArgumentException("Invalid Pokemon type");
          }

          var pokemon = new Pokemon
          {
              Name = dto.Name,
              Type = pokemonType,
              DefensePoints = dto.DefensePoints,
              HealthPoints = dto.HealthPoints,
              RarityPercentage = dto.RarityPercentage,
              ImageURL = dto.ImageURL,
              Attacks = dto.Attacks.Select(a => new Attack
              {
                  Name = a.Name,
                  Points = a.Points
              }).ToList()
          };

          var created = await _repository.AddAsync(pokemon);
          return created.ToDto();
      }

      public async Task<PokemonDto?> UpdateAsync(int id, UpdatePokemonDto dto)
      {
          _logger.LogInformation("Updating Pokemon with ID {Id}", id);

          var pokemon = await _repository.GetByIdAsync(id);
          if (pokemon == null)
          {
              return null;
          }

          // Parse type enum
          if (!Enum.TryParse<PokemonType>(dto.Type, out var pokemonType))
          {
              throw new ArgumentException("Invalid Pokemon type");
          }

          // Update properties
          pokemon.Name = dto.Name;
          pokemon.Type = pokemonType;
          pokemon.DefensePoints = dto.DefensePoints;
          pokemon.HealthPoints = dto.HealthPoints;
          pokemon.RarityPercentage = dto.RarityPercentage;
          pokemon.ImageURL = dto.ImageURL;

          // Replace attacks
          pokemon.Attacks.Clear();
          foreach (var attackDto in dto.Attacks)
          {
              pokemon.Attacks.Add(new Attack
              {
                  Name = attackDto.Name,
                  Points = attackDto.Points,
                  PokemonId = pokemon.Id
              });
          }

          await _repository.UpdateAsync(pokemon);
          return pokemon.ToDto();
      }

      public async Task<bool> DeleteAsync(int id)
      {
          _logger.LogInformation("Deleting Pokemon with ID {Id}", id);

          var pokemon = await _repository.GetByIdAsync(id);
          if (pokemon == null)
          {
              return false;
          }

          await _repository.DeleteAsync(pokemon);
          return true;
      }
  }
  ```
- [ ] Register service in `Program.cs`
  ```csharp
  builder.Services.AddScoped<IPokemonService, PokemonService>();
  ```

**Reference**: [docs/v2026/topics/service-layer-pattern.md](./topics/service-layer-pattern.md)

---

### 2.12 Implement Complete PokemonController

**Implementation Tasks**:
- [ ] Update `PokemonController` to use `IPokemonService`
  ```csharp
  using Microsoft.AspNetCore.Mvc;
  using Microsoft.AspNetCore.Authorization;

  namespace PokemonApp.API.Controllers;

  [ApiController]
  [Route("api/[controller]")]
  public class PokemonController : ControllerBase
  {
      private readonly IPokemonService _pokemonService;
      private readonly ILogger<PokemonController> _logger;

      public PokemonController(IPokemonService pokemonService, ILogger<PokemonController> logger)
      {
          _pokemonService = pokemonService;
          _logger = logger;
      }

      /// <summary>
      /// Retrieves all Pokemon
      /// </summary>
      [HttpGet]
      [ProducesResponseType(typeof(IEnumerable<PokemonDto>), StatusCodes.Status200OK)]
      [ProducesResponseType(StatusCodes.Status500InternalServerError)]
      public async Task<IActionResult> GetAll()
      {
          try
          {
              var pokemon = await _pokemonService.GetAllAsync();
              return Ok(pokemon);
          }
          catch (Exception ex)
          {
              _logger.LogError(ex, "Error fetching all Pokemon");
              return StatusCode(500, new ErrorResponseDto
              {
                  Message = "An error occurred while fetching Pokemon",
                  StatusCode = 500
              });
          }
      }

      /// <summary>
      /// Retrieves a specific Pokemon by ID
      /// </summary>
      [HttpGet("{id}")]
      [ProducesResponseType(typeof(PokemonDto), StatusCodes.Status200OK)]
      [ProducesResponseType(StatusCodes.Status404NotFound)]
      public async Task<IActionResult> GetById(int id)
      {
          var pokemon = await _pokemonService.GetByIdAsync(id);

          if (pokemon == null)
          {
              return NotFound(new ErrorResponseDto
              {
                  Message = $"Pokémon avec l'ID {id} introuvable",
                  StatusCode = 404
              });
          }

          return Ok(pokemon);
      }

      /// <summary>
      /// Creates a new Pokemon (Admin only)
      /// </summary>
      [HttpPost]
      [Authorize(Roles = "Admin")]  // Will implement authentication later
      [ProducesResponseType(typeof(PokemonDto), StatusCodes.Status201Created)]
      [ProducesResponseType(StatusCodes.Status400BadRequest)]
      [ProducesResponseType(StatusCodes.Status401Unauthorized)]
      [ProducesResponseType(StatusCodes.Status403Forbidden)]
      public async Task<IActionResult> Create([FromBody] CreatePokemonDto dto)
      {
          if (!ModelState.IsValid)
          {
              return BadRequest(ModelState);
          }

          try
          {
              var created = await _pokemonService.CreateAsync(dto);
              return CreatedAtAction(
                  nameof(GetById),
                  new { id = created.Id },
                  created
              );
          }
          catch (ArgumentException ex)
          {
              return BadRequest(new ErrorResponseDto
              {
                  Message = ex.Message,
                  StatusCode = 400
              });
          }
          catch (Exception ex)
          {
              _logger.LogError(ex, "Error creating Pokemon");
              return StatusCode(500, new ErrorResponseDto
              {
                  Message = "An error occurred while creating Pokemon",
                  StatusCode = 500
              });
          }
      }

      /// <summary>
      /// Updates an existing Pokemon (Admin only)
      /// </summary>
      [HttpPut("{id}")]
      [Authorize(Roles = "Admin")]
      [ProducesResponseType(typeof(PokemonDto), StatusCodes.Status200OK)]
      [ProducesResponseType(StatusCodes.Status400BadRequest)]
      [ProducesResponseType(StatusCodes.Status401Unauthorized)]
      [ProducesResponseType(StatusCodes.Status403Forbidden)]
      [ProducesResponseType(StatusCodes.Status404NotFound)]
      public async Task<IActionResult> Update(int id, [FromBody] UpdatePokemonDto dto)
      {
          if (!ModelState.IsValid)
          {
              return BadRequest(ModelState);
          }

          try
          {
              var updated = await _pokemonService.UpdateAsync(id, dto);

              if (updated == null)
              {
                  return NotFound(new ErrorResponseDto
                  {
                      Message = $"Pokémon avec l'ID {id} introuvable",
                      StatusCode = 404
                  });
              }

              return Ok(updated);
          }
          catch (ArgumentException ex)
          {
              return BadRequest(new ErrorResponseDto
              {
                  Message = ex.Message,
                  StatusCode = 400
              });
          }
          catch (Exception ex)
          {
              _logger.LogError(ex, "Error updating Pokemon with ID {Id}", id);
              return StatusCode(500, new ErrorResponseDto
              {
                  Message = "An error occurred while updating Pokemon",
                  StatusCode = 500
              });
          }
      }

      /// <summary>
      /// Deletes a Pokemon (Admin only)
      /// </summary>
      [HttpDelete("{id}")]
      [Authorize(Roles = "Admin")]
      [ProducesResponseType(StatusCodes.Status204NoContent)]
      [ProducesResponseType(StatusCodes.Status401Unauthorized)]
      [ProducesResponseType(StatusCodes.Status403Forbidden)]
      [ProducesResponseType(StatusCodes.Status404NotFound)]
      public async Task<IActionResult> Delete(int id)
      {
          var deleted = await _pokemonService.DeleteAsync(id);

          if (!deleted)
          {
              return NotFound(new ErrorResponseDto
              {
                  Message = $"Pokémon avec l'ID {id} introuvable",
                  StatusCode = 404
              });
          }

          return NoContent();
      }
  }
  ```
- [ ] Test all endpoints without authentication first
  - Comment out `[Authorize]` attributes temporarily
  - Test GET, POST, PUT, DELETE operations
  - Verify status codes match OpenAPI contract
  - Verify Location header in POST response

---

### 2.13 API Documentation with Swagger/OpenAPI

**Implementation Tasks**:
- [ ] Install Swashbuckle NuGet package
  ```bash
  dotnet add package Swashbuckle.AspNetCore
  ```
- [ ] Configure Swagger in `Program.cs`
  ```csharp
  builder.Services.AddEndpointsApiExplorer();
  builder.Services.AddSwaggerGen(options =>
  {
      options.SwaggerDoc("v1", new OpenApiInfo
      {
          Title = "Pokemon API",
          Version = "2.0.0",
          Description = "API REST pour gérer une collection de Pokémon",
          Contact = new OpenApiContact
          {
              Name = "Pokemon App Support",
              Email = "support@pokemonapp.com"
          },
          License = new OpenApiLicense
          {
              Name = "MIT",
              Url = new Uri("https://opensource.org/licenses/MIT")
          }
      });

      // Add JWT authentication to Swagger
      options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
      {
          Description = "JWT Bearer token. Format: Bearer {token}",
          Name = "Authorization",
          In = ParameterLocation.Header,
          Type = SecuritySchemeType.Http,
          Scheme = "bearer",
          BearerFormat = "JWT"
      });

      options.AddSecurityRequirement(new OpenApiSecurityRequirement
      {
          {
              new OpenApiSecurityScheme
              {
                  Reference = new OpenApiReference
                  {
                      Type = ReferenceType.SecurityScheme,
                      Id = "Bearer"
                  }
              },
              Array.Empty<string>()
          }
      });
  });

  var app = builder.Build();

  // Enable Swagger in all environments (or only in Development)
  app.UseSwagger();
  app.UseSwaggerUI(options =>
  {
      options.SwaggerEndpoint("/swagger/v1/swagger.json", "Pokemon API v2.0.0");
      options.RoutePrefix = string.Empty;  // Swagger UI at root
  });
  ```
- [ ] Add XML comments for better documentation (optional but recommended)
  - Enable XML documentation in `.csproj`
    ```xml
    <PropertyGroup>
      <GenerateDocumentationFile>true</GenerateDocumentationFile>
      <NoWarn>$(NoWarn);1591</NoWarn>
    </PropertyGroup>
    ```
  - Add XML comments to controller actions (already in code above with `/// <summary>`)
- [ ] Test Swagger UI
  - Navigate to `https://localhost:7000/`
  - Verify all endpoints are documented
  - Test endpoints through Swagger UI
- [ ] Compare generated OpenAPI spec with `PokemonApp_openapi_contract.yml`
  - Download spec from `/swagger/v1/swagger.json`
  - Verify schemas match (PokemonDto, CreatePokemonDto, etc.)

**Reference**: [docs/v2026/topics/swagger-openapi.md](./topics/swagger-openapi.md)

---

### 2.14 CORS (Cross-Origin Resource Sharing)

**Implementation Tasks**:
- [ ] Configure CORS in `Program.cs`
  ```csharp
  builder.Services.AddCors(options =>
  {
      if (builder.Environment.IsDevelopment())
      {
          // Development: Allow localhost origins
          options.AddDefaultPolicy(policy =>
          {
              policy.WithOrigins(
                      "http://localhost:3000",
                      "http://localhost:4200",
                      "http://localhost:5173"
                  )
                  .AllowAnyMethod()
                  .AllowAnyHeader()
                  .AllowCredentials();
          });
      }
      else
      {
          // Production: Specific origins only
          options.AddDefaultPolicy(policy =>
          {
              policy.WithOrigins("https://pokemonapp.com")
                  .AllowAnyMethod()
                  .AllowAnyHeader()
                  .AllowCredentials();
          });
      }
  });

  var app = builder.Build();

  // IMPORTANT: UseCors must be after UseRouting and before UseAuthentication
  app.UseRouting();
  app.UseCors();
  app.UseAuthentication();
  app.UseAuthorization();
  ```
- [ ] Test CORS from a frontend application
  - Create simple HTML page with fetch requests
  - Verify CORS headers in browser DevTools
  - Test preflight OPTIONS requests

**Reference**: [docs/v2026/topics/cors.md](./topics/cors.md)

---

### 2.15 Async/Await in ASP.NET Core

**Implementation Tasks**:
- [ ] Verify all repository methods are async
  - Methods return `Task<T>` or `Task`
  - Use `async/await` keywords
  - Suffix methods with `Async`
- [ ] Verify all service methods are async
- [ ] Verify all controller actions are async
- [ ] Use async database operations
  - `ToListAsync()`, `FirstOrDefaultAsync()`, `SaveChangesAsync()`
- [ ] Understand async best practices
  - Don't block on async code (avoid `.Result` or `.Wait()`)
  - Use `ConfigureAwait(false)` in library code (not needed in ASP.NET Core)
  - Always await async methods

**Reference**: [docs/v2026/topics/async-await-programming.md](./topics/async-await-programming.md)

---

## Module 3: ASP.NET Core MVC (Optional)

This module is optional for the API implementation. Only proceed if you want to build a web UI for the Pokemon API.

**Note**: The OpenAPI contract focuses on the API. MVC would be a separate frontend consuming this API.

### 3.1 Introduction to MVC Pattern

**Concept Tasks**:
- ✅ Understand Model-View-Controller pattern
- ✅ Understand separation of concerns
- ✅ Understand when to use MVC vs API

**Reference**: [docs/v2026/topics/mvc-pattern-introduction.md](./topics/mvc-pattern-introduction.md)

---

### 3.2 Creating an MVC Project

**Implementation Tasks** (if building web UI):
- [ ] Create separate MVC project
  ```bash
  dotnet new mvc -n PokemonApp.Web
  ```
- [ ] Configure to consume the Pokemon API
- [ ] Implement views for listing, creating, editing Pokemon
- [ ] Use HttpClient to call API endpoints
- [ ] Handle authentication tokens

**Reference**: [docs/v2026/topics/creating-mvc-project.md](./topics/creating-mvc-project.md)

**Note**: Full MVC implementation is beyond the scope of the API contract. This would be a Phase 2 project.

---

## Module 4: Advanced Concepts

### 4.1 Authentication and Authorization Basics

**Implementation Tasks**:
- [ ] Install authentication packages
  ```bash
  dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer
  dotnet add package Microsoft.AspNetCore.Identity.EntityFrameworkCore
  dotnet add package System.IdentityModel.Tokens.Jwt
  ```
- [ ] Update `ApplicationDbContext` to use Identity
  ```csharp
  public class ApplicationDbContext : IdentityDbContext<IdentityUser>
  {
      // ... existing code
  }
  ```
- [ ] Add Identity tables migration
  ```bash
  dotnet ef migrations add AddIdentity
  dotnet ef database update
  ```
- [ ] Configure JWT authentication in `Program.cs`
  ```csharp
  using Microsoft.AspNetCore.Authentication.JwtBearer;
  using Microsoft.IdentityModel.Tokens;
  using System.Text;

  builder.Services.AddAuthentication(options =>
  {
      options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
      options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
  })
  .AddJwtBearer(options =>
  {
      options.TokenValidationParameters = new TokenValidationParameters
      {
          ValidateIssuer = true,
          ValidateAudience = true,
          ValidateLifetime = true,
          ValidateIssuerSigningKey = true,
          ValidIssuer = builder.Configuration["Jwt:Issuer"],
          ValidAudience = builder.Configuration["Jwt:Audience"],
          IssuerSigningKey = new SymmetricSecurityKey(
              Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]))
      };
  });

  builder.Services.AddAuthorization();
  ```
- [ ] Add JWT settings to `appsettings.json`
  ```json
  {
    "Jwt": {
      "Key": "your-secret-key-at-least-32-characters-long",
      "Issuer": "PokemonApp.API",
      "Audience": "PokemonApp.Clients"
    }
  }
  ```
- [ ] Enable authentication middleware in `Program.cs`
  ```csharp
  app.UseAuthentication();
  app.UseAuthorization();
  ```
- [ ] Create `AuthController` with Register, Login, and Logout endpoints
  ```csharp
  [ApiController]
  [Route("api/[controller]")]
  public class AuthController : ControllerBase
  {
      private readonly UserManager<IdentityUser> _userManager;
      private readonly SignInManager<IdentityUser> _signInManager;
      private readonly IConfiguration _configuration;

      public AuthController(
          UserManager<IdentityUser> userManager,
          SignInManager<IdentityUser> signInManager,
          IConfiguration configuration)
      {
          _userManager = userManager;
          _signInManager = signInManager;
          _configuration = configuration;
      }

      [HttpPost("register")]
      public async Task<IActionResult> Register([FromBody] RegisterDto dto)
      {
          var user = new IdentityUser
          {
              UserName = dto.Email,
              Email = dto.Email
          };

          var result = await _userManager.CreateAsync(user, dto.Password);

          if (!result.Succeeded)
          {
              return BadRequest(result.Errors);
          }

          // Assign default role
          await _userManager.AddToRoleAsync(user, "User");

          return Ok(new { message = "User registered successfully" });
      }

      [HttpPost("login")]
      public async Task<IActionResult> Login([FromBody] LoginDto dto)
      {
          var user = await _userManager.FindByEmailAsync(dto.Email);

          if (user == null)
          {
              return Unauthorized(new { message = "Invalid credentials" });
          }

          var result = await _signInManager.CheckPasswordSignInAsync(user, dto.Password, false);

          if (!result.Succeeded)
          {
              return Unauthorized(new { message = "Invalid credentials" });
          }

          var token = await GenerateJwtToken(user);

          return Ok(new { token });
      }

      private async Task<string> GenerateJwtToken(IdentityUser user)
      {
          var claims = new List<Claim>
          {
              new Claim(JwtRegisteredClaimNames.Sub, user.Id),
              new Claim(JwtRegisteredClaimNames.Email, user.Email),
              new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
          };

          // Add roles to claims
          var roles = await _userManager.GetRolesAsync(user);
          foreach (var role in roles)
          {
              claims.Add(new Claim(ClaimTypes.Role, role));
          }

          var key = new SymmetricSecurityKey(
              Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
          var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

          var token = new JwtSecurityToken(
              issuer: _configuration["Jwt:Issuer"],
              audience: _configuration["Jwt:Audience"],
              claims: claims,
              expires: DateTime.UtcNow.AddHours(2),
              signingCredentials: credentials
          );

          return new JwtSecurityTokenHandler().WriteToken(token);
      }
  }
  ```
- [ ] Create DTOs for authentication
  ```csharp
  public class RegisterDto
  {
      [Required]
      [EmailAddress]
      public string Email { get; set; }

      [Required]
      [MinLength(6)]
      public string Password { get; set; }
  }

  public class LoginDto
  {
      [Required]
      [EmailAddress]
      public string Email { get; set; }

      [Required]
      public string Password { get; set; }
  }
  ```
- [ ] Create Admin user seed data
  ```csharp
  // In ApplicationDbContext or separate seeder
  public static async Task SeedAdminUser(UserManager<IdentityUser> userManager, RoleManager<IdentityRole> roleManager)
  {
      // Create roles
      if (!await roleManager.RoleExistsAsync("Admin"))
      {
          await roleManager.CreateAsync(new IdentityRole("Admin"));
      }

      if (!await roleManager.RoleExistsAsync("User"))
      {
          await roleManager.CreateAsync(new IdentityRole("User"));
      }

      // Create admin user
      var adminEmail = "admin@pokemonapp.com";
      if (await userManager.FindByEmailAsync(adminEmail) == null)
      {
          var admin = new IdentityUser
          {
              UserName = adminEmail,
              Email = adminEmail,
              EmailConfirmed = true
          };

          await userManager.CreateAsync(admin, "Admin123!");
          await userManager.AddToRoleAsync(admin, "Admin");
      }
  }
  ```
- [ ] Call seed method in `Program.cs`
  ```csharp
  // After app.Build()
  using (var scope = app.Services.CreateScope())
  {
      var userManager = scope.ServiceProvider.GetRequiredService<UserManager<IdentityUser>>();
      var roleManager = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole>>();
      await ApplicationDbSeeder.SeedAdminUser(userManager, roleManager);
  }
  ```
- [ ] Uncomment `[Authorize(Roles = "Admin")]` attributes in `PokemonController`
- [ ] Test authentication flow
  1. POST /api/auth/register (create regular user)
  2. POST /api/auth/login (get JWT token)
  3. Use token in Authorization header: `Bearer {token}`
  4. Test protected endpoints (POST, PUT, DELETE)
  5. Verify 401 Unauthorized without token
  6. Verify 403 Forbidden with User role (not Admin)
  7. Login as admin, verify POST/PUT/DELETE work

**Reference**:
- [docs/v2026/topics/authentication-authorization-basics.md](./topics/authentication-authorization-basics.md)
- [docs/v2026/topics/jwt-tokens.md](./topics/jwt-tokens.md)

---

### 4.2 Error Handling and Logging

**Implementation Tasks**:
- [ ] Configure global exception handling middleware in `Program.cs`
  ```csharp
  if (app.Environment.IsDevelopment())
  {
      app.UseDeveloperExceptionPage();
  }
  else
  {
      app.UseExceptionHandler("/error");
      app.UseHsts();
  }
  ```
- [ ] Create error handling endpoint
  ```csharp
  [ApiController]
  [ApiExplorerSettings(IgnoreApi = true)]
  public class ErrorController : ControllerBase
  {
      [Route("/error")]
      public IActionResult HandleError()
      {
          return Problem(
              statusCode: 500,
              title: "An error occurred while processing your request"
          );
      }
  }
  ```
- [ ] Configure logging in `appsettings.json`
  ```json
  {
    "Logging": {
      "LogLevel": {
        "Default": "Information",
        "Microsoft.AspNetCore": "Warning",
        "PokemonApp": "Debug"
      }
    }
  }
  ```
- [ ] Use ILogger throughout application (already in service and controller code)
- [ ] Add structured logging
  - Use message templates: `_logger.LogInformation("Creating Pokemon {Name}", pokemon.Name)`
  - Log at appropriate levels: Trace, Debug, Information, Warning, Error, Critical
- [ ] (Optional) Add Serilog for better logging
  ```bash
  dotnet add package Serilog.AspNetCore
  dotnet add package Serilog.Sinks.File
  dotnet add package Serilog.Sinks.Console
  ```
- [ ] Test error scenarios
  - Invalid Pokemon ID (404)
  - Invalid data (400 with validation errors)
  - Missing authentication (401)
  - Insufficient permissions (403)
  - Database errors (500)

**Reference**: [docs/v2026/topics/error-handling-logging.md](./topics/error-handling-logging.md)

---

### 4.3 Configuration and Settings

**Implementation Tasks**:
- [ ] Review `appsettings.json` structure
  ```json
  {
    "Logging": { },
    "ConnectionStrings": {
      "DefaultConnection": "Data Source=pokemon.db"
    },
    "Jwt": {
      "Key": "...",
      "Issuer": "...",
      "Audience": "..."
    },
    "AllowedHosts": "*"
  }
  ```
- [ ] Create environment-specific settings
  - `appsettings.Development.json`
  - `appsettings.Production.json`
- [ ] Use Options pattern for strongly-typed configuration
  ```csharp
  public class JwtOptions
  {
      public const string SectionName = "Jwt";

      public string Key { get; set; }
      public string Issuer { get; set; }
      public string Audience { get; set; }
  }

  // Register
  builder.Services.Configure<JwtOptions>(
      builder.Configuration.GetSection(JwtOptions.SectionName));

  // Use
  public class AuthController : ControllerBase
  {
      private readonly JwtOptions _jwtOptions;

      public AuthController(IOptions<JwtOptions> jwtOptions)
      {
          _jwtOptions = jwtOptions.Value;
      }
  }
  ```
- [ ] Use User Secrets for development (sensitive data)
  ```bash
  dotnet user-secrets init
  dotnet user-secrets set "Jwt:Key" "your-secret-key"
  ```
- [ ] Use environment variables in production
  ```bash
  export Jwt__Key="production-secret-key"
  export ConnectionStrings__DefaultConnection="Server=..."
  ```
- [ ] Never commit secrets to source control
  - Add `appsettings.Development.json` to `.gitignore` if it contains secrets
  - Use User Secrets for development
  - Use environment variables or Azure Key Vault for production

**Reference**: [docs/v2026/topics/configuration-settings.md](./topics/configuration-settings.md)

---

### 4.4 Filters (Optional Advanced Feature)

**Implementation Tasks** (if needed):
- [ ] Create custom action filter for logging
- [ ] Create exception filter for custom error handling
- [ ] Apply filters globally or to specific controllers

**Reference**: [docs/v2026/topics/filters.md](./topics/filters.md)

---

## Testing & Deployment

### Testing Tasks

- [ ] Manual testing with Swagger UI
  - Test all endpoints
  - Test with and without authentication
  - Test validation errors
  - Test edge cases (non-existent IDs, etc.)
- [ ] Manual testing with Postman or REST Client
  - Import OpenAPI spec into Postman
  - Create test collection
  - Test authentication flow
  - Save example requests
- [ ] (Optional) Unit testing
  - Test services
  - Test repositories
  - Test mapping logic
- [ ] (Optional) Integration testing
  - Test API endpoints
  - Test database operations
  - Use in-memory database for testing

---

### Deployment Preparation

- [ ] Review `appsettings.Production.json`
- [ ] Set production connection string
- [ ] Configure production CORS origins
- [ ] Set secure JWT key (long random string)
- [ ] Enable HTTPS
- [ ] Configure proper logging
- [ ] Review security best practices
  - HTTPS only
  - Strong JWT keys
  - Secure password policies
  - Rate limiting (optional)
  - SQL injection protection (EF Core parameterized queries)
  - XSS protection (automatic in ASP.NET Core)

---

## Summary Checklist

### Core API Implementation (Minimum Viable Product)

- [ ] Project created and running
- [ ] Database with EF Core configured
- [ ] Pokemon and Attack entities created
- [ ] Migrations applied
- [ ] Repository pattern implemented
- [ ] Service layer implemented
- [ ] All 5 endpoints implemented (GET all, GET by ID, POST, PUT, DELETE)
- [ ] DTOs created with validation
- [ ] Error handling implemented
- [ ] Swagger documentation working

### Authentication & Security

- [ ] JWT authentication configured
- [ ] Admin role created
- [ ] Protected endpoints with [Authorize]
- [ ] Auth endpoints (register, login)
- [ ] CORS configured

### Production Readiness

- [ ] Proper error handling
- [ ] Logging configured
- [ ] Configuration management (appsettings, secrets)
- [ ] OpenAPI spec matches contract
- [ ] All endpoints tested
- [ ] Security reviewed

---

## Estimated Timeline

**Phase 1: Core API** (8-12 hours)
- Project setup
- Database and entities
- Repository and service layers
- Basic CRUD endpoints

**Phase 2: Validation & Documentation** (2-4 hours)
- DTOs with validation
- Swagger configuration
- Error handling

**Phase 3: Authentication** (4-6 hours)
- JWT configuration
- Identity setup
- Auth endpoints
- Protect endpoints

**Phase 4: Polish & Testing** (2-4 hours)
- CORS configuration
- Comprehensive testing
- Bug fixes
- Production preparation

**Total: 16-26 hours** (spread over multiple days with breaks for learning)

---

## Learning Resources

As you work through these tasks, refer to the documentation:
- [Complete Documentation Plan](./DOCUMENTATION_PLAN.md)
- [All Topic Guides](./topics/)
- [Technology Topic Template](./templates/technology-topic-template.md)

---

## Notes

- This task list follows the **progressive learning path** from the documentation plan
- Each section builds on previous sections
- Authentication is implemented last because it requires understanding of all prior concepts
- MVC module (Module 3) is optional for API-only implementation
- Adjust complexity based on your learning pace
- Use Swagger UI extensively for testing during development
- Commit code frequently to Git
- Ask questions when concepts are unclear

**Good luck building your Pokemon API!** 🚀
