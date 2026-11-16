# PokemonApp - Project Context

**Last Updated**: 2026-11-13
**Version**: v2026

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Technology Stack](#technology-stack)
4. [Development Guidelines](#development-guidelines)
5. [Common Patterns](#common-patterns)
6. [Architectural Decisions](#architectural-decisions)
7. [Known Issues](#known-issues)

---

## Project Overview

### Purpose
Educational project for learning .NET Core API and MVC development through building a Pokemon management application.

### Goals
- Learn ASP.NET Core Web API development
- Learn ASP.NET Core MVC patterns
- Practice Entity Framework Core
- Understand RESTful API design
- Learn dependency injection in .NET

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
**Status**: To be determined as project evolves

Typical .NET API/MVC structure will likely include:
- API Controllers
- MVC Controllers
- Models/Domain Entities
- Data Access Layer (EF Core)
- Services/Business Logic
- DTOs for API responses

---

## Technology Stack

### Current Stack
- **Language**: C#
- **Framework**: .NET Core (version TBD)
- **Web Frameworks**:
  - ASP.NET Core Web API
  - ASP.NET Core MVC
- **ORM**: Entity Framework Core (planned)
- **Database**: TBD (likely SQL Server or PostgreSQL)

### Tools
- **Version Control**: Git + GitHub
- **Project Management**: Clonear (markdown-based tickets)
- **Development**: Claude Code for implementation (supports multiple parallel agents)

---

## Development Guidelines

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
- Use async/await for all I/O operations
- Suffix async methods with 'Async'
- Always use ConfigureAwait(false) in library code

```csharp
public async Task<Pokemon> GetPokemonAsync(int id)
{
    return await _repository.GetByIdAsync(id).ConfigureAwait(false);
}
```

### Error Handling
- Use try-catch for expected errors
- Let unexpected exceptions bubble up
- Return appropriate HTTP status codes in controllers
- Log errors appropriately

### Dependency Injection
- Use constructor injection
- Register services in Program.cs (or Startup.cs)
- Prefer interfaces over concrete classes

---

## Common Patterns

### Repository Pattern
*To be documented when implemented*

### Service Layer Pattern
*To be documented when implemented*

### DTO Pattern
*To be documented when implemented*

---

## Architectural Decisions

### ADR Format
When making significant architectural decisions, document them here using this format:

**Decision ID**: ADR-001
**Date**: YYYY-MM-DD
**Status**: Proposed | Accepted | Deprecated
**Context**: What is the issue we're facing?
**Decision**: What did we decide?
**Consequences**: What are the trade-offs?

---

### ADR-001: Use Clonear for Ticket Management
**Date**: 2026-11-13
**Status**: Accepted

**Context**: Need a simple, git-friendly ticket tracking system for the project.

**Decision**: Use Clonear (markdown-based tickets in folders) instead of external tools like Jira or GitHub Issues.

**Consequences**:
- ✅ Tickets are version controlled
- ✅ Works offline
- ✅ Simple and lightweight
- ✅ Easy for AI agents to read/write
- ❌ No web UI
- ❌ Limited reporting capabilities

---

### ADR-002: Use Claude Code for Implementation
**Date**: 2026-11-13
**Status**: Accepted

**Context**: Need development assistance for implementing .NET features.

**Decision**: Use Claude Code as primary development agent, working from tickets.

**Consequences**:
- ✅ Consistent code quality
- ✅ Good documentation
- ✅ Learning opportunity
- ⚠️ Requires clear tickets with acceptance criteria

---

### ADR-003: Support Multiple Parallel Agents
**Date**: 2026-11-13
**Status**: Accepted

**Context**: To increase development velocity, multiple Claude Code agents should be able to work on different tickets simultaneously.

**Decision**: Allow multiple tickets in `in-progress/` status at the same time, with each agent responsible for one ticket.

**Consequences**:
- ✅ Faster development (parallel work)
- ✅ Better for independent features
- ⚠️ Requires coordination to avoid merge conflicts
- ⚠️ Agents should check for potential conflicts before starting work

---

## Known Issues

*None yet*

---

## Notes for Claude Code Agents

### When Starting Work
1. Read this document completely
2. Check for recent updates to Architectural Decisions
3. Follow all patterns documented in "Common Patterns"
4. Update this document if you make new architectural decisions

### When to Update This Document
- After implementing a new pattern (add to Common Patterns)
- After making architectural decisions (add ADR)
- When discovering issues (add to Known Issues)
- When stack changes (update Technology Stack)

### Document Maintenance
Keep this document current. If you implement something significant:
1. Document the pattern here
2. Update the Last Updated date at the top
3. Commit changes with descriptive message
