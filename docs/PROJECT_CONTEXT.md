# PokemonApp - Project Context

**Last Updated**: 2026-11-22
**Version**: v2026

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Technology Stack](#technology-stack)
4. [Development Guidelines](#development-guidelines)
5. [Common Patterns](#common-patterns)
6. [Project Management](#project-management)
7. [Known Issues](#known-issues)
8. [Contributing](#contributing)

---

## Project Overview

### Purpose
This is a **beginner-friendly educational project** for learning .NET Core API and MVC development. We'll build a Pokemon management application step-by-step, introducing core .NET concepts in a practical way.

### Learning Goals
By working through this project, you will:
- Build your first ASP.NET Core Web API
- Create web pages using ASP.NET Core MVC
- Work with databases using Entity Framework Core
- Understand RESTful API principles
- Learn how dependency injection works in .NET

**Target Audience**: Developers new to .NET who have basic programming knowledge in any language.

### Repository
- **GitHub**: https://github.com/Geoffzoet/PokemonApp-v2026
- **Owner**: geoffzoet@hotmail.com

---

## Architecture

### High-Level Structure

```
PokemonApp/
├── docs/                    # Documentation
│   ├── previousyears/       # Historical training materials
│   └── v2026/              # Current year documentation
├── tickets/                 # Clonear ticket system
│   ├── todo/
│   ├── in-progress/
│   ├── in-qa/
│   └── done/
└── src/                     # Source code (TBD)
```

### Planned Architecture
As we build the application, we'll organize it into these main parts:

- **Controllers**: Handle HTTP requests and responses
  - API Controllers for JSON data
  - MVC Controllers for web pages
- **Models**: Represent our Pokemon data
- **Services**: Business logic (what the app can do)
- **Data Access**: How we save/load from the database (Entity Framework Core)

This keeps our code organized and easy to understand!

---

## Technology Stack

### What We'll Use

**Core Technologies:**
- **Language**: C# (Microsoft's object-oriented programming language)
- **Framework**: .NET Core (cross-platform framework for building modern applications)
- **Web Frameworks**:
  - ASP.NET Core Web API - for building RESTful APIs
  - ASP.NET Core MVC - for building web pages
- **Database**: Entity Framework Core (makes working with databases easier)

**Development Tools:**
- **Git + GitHub**: Version control to track changes
- **IDE**: Visual Studio, Visual Studio Code, or JetBrains Rider

---

## Development Guidelines

These are the coding conventions we'll follow throughout the project. Don't worry about memorizing these - you'll get familiar with them as you code!

### Code Style

#### Naming Conventions
- **Classes, Methods, Properties**: PascalCase
  ```csharp
  public class PokemonService
  public async Task<Pokemon> GetPokemonAsync(int id)
  ```
- **Private fields**: camelCase with underscore prefix
  ```csharp
  private readonly IPokemonRepository _pokemonRepository;
  ```
- **Local variables, parameters**: camelCase
  ```csharp
  var pokemonList = await GetAllAsync();
  ```
- **Interfaces**: Prefix with 'I'
  ```csharp
  public interface IPokemonService
  ```

#### File Organization
- One class per file
- File name matches class name
- Organize using folders by feature or layer

### Async/Await Pattern
- Use async/await for I/O operations (database, file access, API calls)
- Suffix async methods with 'Async'
- Makes your app more responsive by not blocking threads

```csharp
public async Task<Pokemon> GetPokemonAsync(int id)
{
    return await _repository.GetByIdAsync(id);
}
```

### Error Handling
- Use try-catch blocks to handle errors gracefully
- Return appropriate HTTP status codes (404 for not found, 400 for bad input, 500 for server errors)
- Display helpful error messages to users

```csharp
try
{
    var pokemon = await _service.GetPokemonAsync(id);
    return Ok(pokemon);
}
catch (NotFoundException)
{
    return NotFound($"Pokemon with ID {id} not found");
}
```

### Dependency Injection
Dependency Injection (DI) is how .NET provides classes with the services they need.

- Register your services in Program.cs
- Request them through constructor parameters
- .NET automatically creates and injects them

```csharp
// In Program.cs - Register the service
builder.Services.AddScoped<IPokemonService, PokemonService>();

// In your controller - Request it via constructor
public class PokemonController : ControllerBase
{
    private readonly IPokemonService _pokemonService;

    public PokemonController(IPokemonService pokemonService)
    {
        _pokemonService = pokemonService;
    }
}
```

---

## Common Patterns

### Repository Pattern
*To be documented when implemented*

### Service Layer Pattern
*To be documented when implemented*

### DTO Pattern
*To be documented when implemented*

---

## Project Management

This project uses markdown-based tickets stored in the `tickets/` folder:
- `todo/` - Upcoming work
- `in-progress/` - Currently being worked on
- `done/` - Completed tickets

Each ticket is a simple markdown file with the task description and acceptance criteria.

---

## Known Issues

*None yet*

---

## Contributing

### Before Starting Work
1. Read this document to understand the project structure
2. Check the `tickets/` folder for available tasks
3. Follow the coding conventions documented above

### Keeping Documentation Updated
If you implement something new:
1. Document the pattern in "Common Patterns"
2. Add any issues to "Known Issues"
3. Update the "Last Updated" date at the top
