# Option B: Standard Setup - Detailed Specification

## Overview
Implement a standard context and ticketing system setup for the PokemonApp project to ensure all Claude Code agents have consistent context, follow proper workflows, and maintain high-quality standards.

## Objectives
- Provide automatic context to any Claude Code agent working on this project
- Enforce consistent ticketing workflow using the existing Clonear system
- Document project standards and conventions
- Create helper commands for common ticket operations

---

## Deliverables

### 1. Claude Code Custom Instructions (`.claude/instructions.md`)

**Purpose**: Automatically loaded by every Claude Code session, provides persistent context and rules.

**Content Structure**:

```markdown
# PokemonApp - Claude Code Instructions

## Project Overview
- **Name**: PokemonApp
- **Type**: .NET API/MVC Training Project (v2026)
- **Repository**: https://github.com/Geoffzoet/PokemonApp-v2026
- **Purpose**: Educational project for learning .NET Core API and MVC development

## Technology Stack
- .NET Core (version TBD)
- ASP.NET Core Web API
- ASP.NET Core MVC
- Entity Framework Core
- C#

## Required Reading on Session Start
1. Always read `docs/PROJECT_CONTEXT.md` for architectural decisions and guidelines
2. Check `tickets/` for current work items
3. Review any open tickets in `tickets/todo/` and `tickets/in-progress/`

## Ticketing System Rules

### Workflow
We use **Clonear**, a markdown-based ticket tracking system.

**Ticket Lifecycle**: todo → in-progress → in-qa → done

**Critical Rules**:
1. **ONE ticket at a time**: Only ONE ticket should be in `tickets/in-progress/` at any time
2. **Always move tickets**: When starting work, move ticket from `todo/` to `in-progress/`
3. **Always commit ticket moves**: Use git to commit when moving tickets between folders
4. **Read ticket thoroughly**: Understand all acceptance criteria before starting

### Ticket Structure
Location: `tickets/<status>/<ID>.md`

Required fields (YAML frontmatter):
- `title`: Clear, concise description (required)
- `priority`: urgent | high | medium | low
- `size`: S | M | L (time estimate)
- `labels`: Array of tags (e.g., [feature, bug, refactor])
- `created`: YYYY-MM-DD

Body: Markdown description with:
- Context/background
- What needs to be done
- **Acceptance Criteria** (bullet points)

### Agent Workflow for Tickets

**Before Starting**:
1. Read the ticket file completely
2. Read `docs/PROJECT_CONTEXT.md`
3. Move ticket to `in-progress/`
4. Commit the move: `git add . && git commit -m "Start POK-X: [title]" && git push`
5. Use TodoWrite tool to break down the work into sub-tasks

**During Work**:
1. Follow all standards in PROJECT_CONTEXT.md
2. Update TodoWrite sub-tasks as you progress
3. Write clean, well-documented code
4. Add appropriate error handling
5. Follow .NET naming conventions

**Before Completing**:
1. Verify ALL acceptance criteria are met
2. Run any tests (if they exist)
3. Review your changes
4. Move ticket to `in-qa/` or `done/` (depending on if QA needed)
5. Commit: `git add . && git commit -m "Complete POK-X: [title]" && git push`

## Code Standards

### .NET Conventions
- Use PascalCase for public members, classes, methods
- Use camelCase for private fields (prefix with underscore: `_privateField`)
- Use meaningful variable names (no single letters except loop counters)
- Keep methods focused and small (single responsibility)
- Add XML documentation comments for public APIs

### Git Commit Standards
- Use conventional commit format: `type(scope): description`
- Types: feat, fix, refactor, docs, test, chore
- Always include the co-author footer from Claude Code
- Reference ticket ID in commits: `feat(api): Add Pokemon endpoint (POK-3)`

### File Organization
- Keep related files together
- Follow .NET project structure conventions
- Update PROJECT_CONTEXT.md when making architectural decisions

## Common Tasks

### Starting a New Ticket
1. Read ticket from `tickets/todo/POK-X.md`
2. Move to `tickets/in-progress/POK-X.md`
3. Git commit the move
4. Create TodoWrite task list
5. Begin implementation

### Completing a Ticket
1. Verify acceptance criteria
2. Move ticket to appropriate status folder
3. Git add, commit with descriptive message, push
4. Update PROJECT_CONTEXT.md if new patterns/decisions were made

### Creating New Tickets
- Use the template format defined in `tickets/clonear.md`
- Assign next available POK-X number
- Include clear acceptance criteria
- Set appropriate priority and size

## Questions or Ambiguity
- If ticket requirements are unclear, use AskUserQuestion tool
- If multiple approaches are valid, propose options and ask user preference
- Document decisions in PROJECT_CONTEXT.md

## Helpful Resources
- Project documentation: `docs/`
- Previous year materials: `docs/previousyears/ppt/`
- Analysis documentation: `docs/v2026/analysis/`
```

---

### 2. Enhanced Ticket Template (Update `tickets/clonear.md`)

**Purpose**: Provide better guidance on ticket creation and management.

**Changes to make**:
- Add "Acceptance Criteria" section to template
- Add examples of good vs. bad tickets
- Add workflow diagram
- Add validation checklist

**Updated Content** (append to existing content):

```markdown
## Best Practices

### Writing Good Tickets

**Good Example**:
```markdown
---
title: Add GET endpoint for Pokemon by ID
assignee: claude
priority: high
size: M
labels: [feature, api]
created: 2026-11-13
---

## Context
We need a REST API endpoint to retrieve a single Pokemon by its ID.

## Requirements
- Create GET endpoint at `/api/pokemon/{id}`
- Return 404 if Pokemon not found
- Return 200 with Pokemon JSON if found
- Use async/await pattern

## Acceptance Criteria
- [ ] Endpoint responds to GET /api/pokemon/{id}
- [ ] Returns Pokemon object as JSON when ID exists
- [ ] Returns 404 NotFound when ID doesn't exist
- [ ] Uses async controller action
- [ ] Follows RESTful conventions
- [ ] No compiler warnings
```

**Bad Example**:
```markdown
---
title: Pokemon stuff
---

Add some Pokemon things
```

### Ticket Sizing Guide
- **S** (Small): 1-2 hours, single file, clear implementation
  - Example: Add a simple property, fix a typo, update configuration
- **M** (Medium): Half day, 2-5 files, some decisions needed
  - Example: Add new endpoint, create new model, add validation
- **L** (Large): Full day+, multiple files, architectural decisions
  - Example: Add authentication, create new module, major refactor

### Priority Levels
- **urgent**: Blocking work, must be done immediately
- **high**: Important feature or bug, should be next
- **medium**: Normal priority, planned work
- **low**: Nice to have, can be deferred

## Workflow Diagram

```
┌─────────┐
│  todo/  │  New tickets, not yet started
└────┬────┘
     │ (Start work: move ticket, git commit)
     ▼
┌──────────────┐
│ in-progress/ │  Currently being worked on (MAX 1 ticket)
└──────┬───────┘
       │ (Implementation complete)
       ▼
    ┌──────┐
    │ QA?  │
    └──┬───┘
      │
  ┌───┴────┐
  │        │
  ▼        ▼
┌──────┐  ┌───────┐
│in-qa/│  │ done/ │  Verified and complete
└──┬───┘  └───────┘
   │
   │ (QA passed)
   ▼
┌───────┐
│ done/ │
└───────┘
```

## Validation Checklist

Before moving a ticket to **done/**:
- [ ] All acceptance criteria are met
- [ ] Code compiles without warnings
- [ ] Code follows project standards (see PROJECT_CONTEXT.md)
- [ ] Git commit created with descriptive message
- [ ] Changes pushed to GitHub
- [ ] PROJECT_CONTEXT.md updated if architectural decisions made
```

---

### 3. Project Context Document (`docs/PROJECT_CONTEXT.md`)

**Purpose**: Central documentation for architecture, decisions, patterns, and guidelines.

**Content Structure**:

```markdown
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
- **Development**: Claude Code for implementation

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
```

---

### 4. Slash Commands

Create 3 slash commands in `.claude/commands/` directory:

#### 4a. `.claude/commands/ticket-start.md`
```markdown
---
description: Start working on a ticket by moving it to in-progress
---

Start working on ticket {{arg1}}:

1. Read the ticket file at `tickets/todo/{{arg1}}.md`
2. Show me a summary of the ticket (title, priority, size, acceptance criteria)
3. Ask if I want to proceed
4. If yes:
   - Move `tickets/todo/{{arg1}}.md` to `tickets/in-progress/{{arg1}}.md`
   - Read `docs/PROJECT_CONTEXT.md` to understand current standards
   - Create a git commit: `git add . && git commit -m "Start {{arg1}}: [ticket title]" && git push`
   - Use TodoWrite to create a task breakdown based on acceptance criteria
   - Begin implementation
```

#### 4b. `.claude/commands/ticket-done.md`
```markdown
---
description: Complete a ticket by moving it to done and committing
---

Complete ticket {{arg1}}:

1. Verify all acceptance criteria from `tickets/in-progress/{{arg1}}.md` are met
2. Show me what was accomplished
3. Ask if I want to mark it as done
4. If yes:
   - Move `tickets/in-progress/{{arg1}}.md` to `tickets/done/{{arg1}}.md`
   - Create a git commit: `git add . && git commit -m "Complete {{arg1}}: [ticket title]" && git push`
   - Clear the TodoWrite task list
   - Ask if I want to start another ticket
```

#### 4c. `.claude/commands/new-ticket.md`
```markdown
---
description: Create a new ticket with proper template
---

Create a new ticket:

1. Find the highest POK-X number in tickets/ directories
2. Ask me for:
   - Title
   - Priority (urgent/high/medium/low)
   - Size (S/M/L)
   - Description
   - Acceptance criteria (bullet points)
3. Create the ticket file as `tickets/todo/POK-[next-number].md` using the Clonear template
4. Git commit: `git add . && git commit -m "Add ticket POK-X: [title]" && git push`
5. Ask if I want to start working on it immediately
```

---

## Acceptance Criteria

### Must Have (Required for completion)
- [ ] `.claude/instructions.md` created with all sections as specified
- [ ] `tickets/clonear.md` updated with Best Practices, examples, workflow diagram, and checklist
- [ ] `docs/PROJECT_CONTEXT.md` created with all sections as specified
- [ ] `.claude/commands/ticket-start.md` created and functional
- [ ] `.claude/commands/ticket-done.md` created and functional
- [ ] `.claude/commands/new-ticket.md` created and functional
- [ ] All new files committed to git with proper commit message
- [ ] All new files pushed to GitHub
- [ ] README.md created in `.claude/` explaining the custom instructions

### Should Have (Important but not blocking)
- [ ] Test each slash command works correctly
- [ ] Verify instructions.md is automatically loaded in new Claude Code session

### Nice to Have (Optional improvements)
- [ ] Add more examples to PROJECT_CONTEXT.md
- [ ] Create a quick reference guide

---

## Implementation Notes

### File Creation Order
1. Create `.claude/instructions.md` first (most important)
2. Create `docs/PROJECT_CONTEXT.md` second
3. Update `tickets/clonear.md` third
4. Create slash commands last

### Testing
After implementation, test by:
1. Starting a new Claude Code session (should auto-load instructions)
2. Running `/new-ticket` to create a test ticket
3. Running `/ticket-start POK-X` on the test ticket
4. Running `/ticket-done POK-X` to complete it

### Git Commits
Create logical commits:
- Commit 1: Add .claude/instructions.md
- Commit 2: Add docs/PROJECT_CONTEXT.md
- Commit 3: Update tickets/clonear.md
- Commit 4: Add slash commands
- Commit 5: Add .claude/README.md

---

## Expected Outcome

After implementing Option B, any Claude Code agent will:
1. Automatically understand the project context
2. Follow consistent ticketing workflow
3. Have access to project standards and patterns
4. Use convenient commands for common ticket operations
5. Maintain documentation as the project evolves

The system should be self-documenting and easy for future contributors (human or AI) to understand and follow.
