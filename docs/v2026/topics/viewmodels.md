# ViewModels in ASP.NET Core MVC

---
**Technology Version**: .NET 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-23
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What are ViewModels?

A ViewModel is a class specifically designed to hold data for a view. It acts as a bridge between your domain models (entities from the database) and your views. ViewModels contain only the data needed for a specific view, shaped in the exact format the view requires.

Think of a ViewModel as a custom shipping container. Your database entities are like items in a warehouse - they have all the properties and relationships needed for storage. But when you ship to a customer (the view), you don't send the entire warehouse. You pack exactly what they ordered in a custom container (ViewModel) that's optimized for that delivery.

### Why Use ViewModels?

ViewModels are essential in professional MVC applications because they:

- **Separate concerns** - Keep your domain models clean and focused on business logic
- **Shape data for views** - Include only what the view needs, nothing more
- **Combine multiple models** - Aggregate data from several entities into one view-friendly object
- **Add view-specific properties** - Include display-only fields that don't belong in domain models
- **Improve security** - Prevent over-posting attacks by controlling exactly what data can be sent
- **Enable validation** - Add validation rules specific to the view without polluting domain models
- **Simplify views** - Make Razor code cleaner by pre-processing data in controllers

### When to Use ViewModels

**Use ViewModels when:**
- Displaying data that comes from multiple entities (e.g., Pokemon with Trainer info)
- A view needs different data than what your entity provides
- You need view-specific validation rules
- Creating or editing forms that shouldn't directly bind to entities
- You want to protect against over-posting (mass assignment vulnerabilities)
- Displaying computed or formatted data

**You might skip ViewModels when:**
- Simple display-only views that match entity structure exactly
- Prototyping or learning (but add them before production!)
- Very simple CRUD operations in internal admin tools

---

## 2. Quick Start

**TL;DR - Create and use a ViewModel in 3 minutes:**

**Step 1: Create a ViewModel**

```csharp
// ViewModels/PokemonDetailsViewModel.cs
namespace PokemonMvcApp.ViewModels
{
    public class PokemonDetailsViewModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public int Level { get; set; }

        // View-specific property not in entity
        public string DisplayName => $"{Name} (Level {Level})";
    }
}
```

**Step 2: Map entity to ViewModel in controller**

```csharp
public IActionResult Details(int id)
{
    var pokemon = _pokemonService.GetById(id); // Get entity

    var viewModel = new PokemonDetailsViewModel
    {
        Id = pokemon.Id,
        Name = pokemon.Name,
        Type = pokemon.Type,
        Level = pokemon.Level
    };

    return View(viewModel);
}
```

**Step 3: Use in view**

```cshtml
@model PokemonDetailsViewModel

<h1>@Model.DisplayName</h1>
<p>Type: @Model.Type</p>
```

For detailed explanations, continue reading below.

---

## 3. Prerequisites

### Required Knowledge

- **C# basics** - Classes, properties, object creation
- **MVC pattern** - Understanding of Models, Views, Controllers
- **Entity models** - What domain/entity models are
- **Razor views** - How to use @model and display data

### Required Software/Tools

- **.NET SDK** - Version 8.0 or higher
- **Code Editor** - Visual Studio, VS Code, or Rider
- **Existing MVC Project** - You should have an MVC project set up

---

## 4. Core Concepts & Theory

### Key Concepts

#### Concept 1: Entity vs ViewModel vs DTO

Understanding the difference between these three concepts is crucial:

**Entity (Domain Model)**
- Represents data as stored in the database
- Contains business logic and validation
- Has database relationships (navigation properties)
- Used by Entity Framework Core

```csharp
// Models/Pokemon.cs - Entity
public class Pokemon
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }
    public int Level { get; set; }
    public int HP { get; set; }
    public int Attack { get; set; }
    public int Defense { get; set; }
    public DateTime CreatedDate { get; set; }
    public DateTime? ModifiedDate { get; set; }

    // Navigation properties
    public int TrainerId { get; set; }
    public Trainer Trainer { get; set; }
    public ICollection<PokemonMove> Moves { get; set; }
}
```

**ViewModel**
- Designed specifically for a view
- Contains only data needed for display/input
- May combine data from multiple entities
- Includes view-specific properties and validation

```csharp
// ViewModels/PokemonDetailsViewModel.cs
public class PokemonDetailsViewModel
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }
    public int Level { get; set; }

    // Data from related entity
    public string TrainerName { get; set; }

    // View-specific computed property
    public string DisplayInfo => $"{Name} (Lv. {Level}) - {Type} type";

    // View-specific data
    public bool CanEvolve { get; set; }
}
```

**DTO (Data Transfer Object)**
- Used for transferring data between layers or services
- Typically used in APIs
- No behavior, just data
- Optimized for serialization

```csharp
// DTOs/PokemonDto.cs - For API
public class PokemonDto
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }
    public int Level { get; set; }
}
```

**When to use each:**

| Scenario | Use |
|----------|-----|
| Saving to database | Entity |
| Displaying in MVC view | ViewModel |
| Form submission in MVC | ViewModel |
| API response | DTO |
| Service layer communication | DTO or Entity |

#### Concept 2: Why Not Use Entities Directly in Views?

**Problems with using entities directly:**

1. **Over-posting vulnerability**
```csharp
// BAD - Entity used directly ❌
[HttpPost]
public IActionResult Edit(Pokemon pokemon)
{
    // User could modify properties you don't want changed!
    // e.g., CreatedDate, TrainerId, sensitive fields
    _pokemonService.Update(pokemon);
}
```

2. **Exposing sensitive data**
```csharp
public class User  // Entity
{
    public string PasswordHash { get; set; }  // Don't send to view!
    public string SecurityStamp { get; set; }   // Don't send to view!
}
```

3. **Wrong data shape**
```csharp
// View needs: Pokemon name + Trainer name
// But entity has: Pokemon with Trainer navigation property
// Better: Create ViewModel with both flattened
```

4. **View-specific validation**
```csharp
// ViewModel can have different validation than entity
public class CreatePokemonViewModel
{
    [Required(ErrorMessage = "Name is required")]
    [StringLength(50)]
    public string Name { get; set; }

    // Entity might have different rules
}
```

#### Concept 3: ViewModel Naming Conventions

**Standard naming patterns:**

```
[Controller][Action]ViewModel
```

**Examples:**
- `PokemonDetailsViewModel` - For Pokemon/Details action
- `PokemonCreateViewModel` - For Pokemon/Create action
- `PokemonEditViewModel` - For Pokemon/Edit action
- `HomeIndexViewModel` - For Home/Index action

**Organization:**
```
ViewModels/
├── Pokemon/
│   ├── PokemonDetailsViewModel.cs
│   ├── PokemonCreateViewModel.cs
│   ├── PokemonEditViewModel.cs
│   └── PokemonListViewModel.cs
├── Trainer/
│   └── TrainerProfileViewModel.cs
└── Home/
    └── DashboardViewModel.cs
```

#### Concept 4: Mapping Strategies

**Manual mapping (simple, explicit):**
```csharp
var viewModel = new PokemonDetailsViewModel
{
    Id = pokemon.Id,
    Name = pokemon.Name,
    Type = pokemon.Type,
    Level = pokemon.Level,
    TrainerName = pokemon.Trainer.Name
};
```

**Mapping helper method:**
```csharp
public static class PokemonMappings
{
    public static PokemonDetailsViewModel ToDetailsViewModel(this Pokemon pokemon)
    {
        return new PokemonDetailsViewModel
        {
            Id = pokemon.Id,
            Name = pokemon.Name,
            Type = pokemon.Type,
            Level = pokemon.Level,
            TrainerName = pokemon.Trainer?.Name
        };
    }
}

// Usage
var viewModel = pokemon.ToDetailsViewModel();
```

**AutoMapper (popular library):**
```csharp
// Configuration
cfg.CreateMap<Pokemon, PokemonDetailsViewModel>()
   .ForMember(dest => dest.TrainerName, opt => opt.MapFrom(src => src.Trainer.Name));

// Usage
var viewModel = _mapper.Map<PokemonDetailsViewModel>(pokemon);
```

#### Concept 5: ViewModels with Multiple Entities

Sometimes a view needs data from multiple sources:

```csharp
public class PokemonBattleViewModel
{
    // Data from Pokemon 1
    public int AttackerId { get; set; }
    public string AttackerName { get; set; }
    public int AttackerHP { get; set; }

    // Data from Pokemon 2
    public int DefenderId { get; set; }
    public string DefenderName { get; set; }
    public int DefenderHP { get; set; }

    // Battle-specific data
    public string BattleResult { get; set; }
    public DateTime BattleDate { get; set; }
}
```

**Controller:**
```csharp
public IActionResult Battle(int attackerId, int defenderId)
{
    var attacker = _pokemonService.GetById(attackerId);
    var defender = _pokemonService.GetById(defenderId);

    var viewModel = new PokemonBattleViewModel
    {
        AttackerId = attacker.Id,
        AttackerName = attacker.Name,
        AttackerHP = attacker.HP,
        DefenderId = defender.Id,
        DefenderName = defender.Name,
        DefenderHP = defender.HP,
        BattleResult = "In Progress",
        BattleDate = DateTime.Now
    };

    return View(viewModel);
}
```

#### Concept 6: ViewModels with Collections

**List ViewModel:**
```csharp
public class PokemonListViewModel
{
    public List<PokemonItemViewModel> Pokemon { get; set; }
    public int TotalCount { get; set; }
    public int CurrentPage { get; set; }
    public int PageSize { get; set; }
    public int TotalPages => (int)Math.Ceiling((double)TotalCount / PageSize);

    // Filters
    public string SearchTerm { get; set; }
    public string TypeFilter { get; set; }
}

public class PokemonItemViewModel
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }
    public int Level { get; set; }
}
```

#### Concept 7: Form ViewModels

**Separate ViewModels for create vs edit:**

```csharp
// For creating new Pokemon
public class CreatePokemonViewModel
{
    [Required]
    [StringLength(50)]
    public string Name { get; set; }

    [Required]
    public string Type { get; set; }

    [Range(1, 100)]
    public int Level { get; set; } = 1;

    // Dropdown data
    public List<SelectListItem> AvailableTypes { get; set; }
}

// For editing existing Pokemon
public class EditPokemonViewModel
{
    public int Id { get; set; }  // Need ID for edit

    [Required]
    [StringLength(50)]
    public string Name { get; set; }

    [Required]
    public string Type { get; set; }

    [Range(1, 100)]
    public int Level { get; set; }

    // Dropdown data
    public List<SelectListItem> AvailableTypes { get; set; }
}
```

### Important Terminology

| Term | Definition |
|------|------------|
| **Entity** | Domain model representing database table |
| **ViewModel** | Model designed specifically for a view |
| **DTO** | Data Transfer Object for service/API communication |
| **Mapping** | Converting one object type to another |
| **Over-posting** | Security vulnerability where user modifies unintended properties |
| **Mass Assignment** | Binding request data directly to entity properties |
| **Projection** | Selecting specific fields from an entity into a new shape |
| **Flattening** | Converting nested objects into flat structure |
| **AutoMapper** | Library for automatic object-to-object mapping |

---

## 5. Installation Guide

### No Special Installation Required

ViewModels are just C# classes. No additional packages are needed for basic ViewModel functionality.

### Optional: Install AutoMapper (Recommended for Large Projects)

**If you want automatic mapping:**

```bash
dotnet add package AutoMapper.Extensions.Microsoft.DependencyInjection
```

**Configure in Program.cs:**
```csharp
builder.Services.AddAutoMapper(typeof(Program));
```

**Create mapping profile:**
```csharp
// MappingProfiles/PokemonProfile.cs
using AutoMapper;

public class PokemonProfile : Profile
{
    public PokemonProfile()
    {
        CreateMap<Pokemon, PokemonDetailsViewModel>();
        CreateMap<CreatePokemonViewModel, Pokemon>();
    }
}
```

---

## 6. Initial Setup & Configuration

### Creating ViewModels Folder Structure

**Step 1: Create ViewModels folder**

```
YourProject/
├── Controllers/
├── Models/        # Domain entities
├── ViewModels/    # Create this
│   ├── Pokemon/
│   ├── Trainer/
│   └── Home/
├── Views/
└── wwwroot/
```

**Step 2: Organize by feature**

```
ViewModels/
├── Pokemon/
│   ├── PokemonDetailsViewModel.cs
│   ├── PokemonCreateViewModel.cs
│   ├── PokemonEditViewModel.cs
│   └── PokemonListViewModel.cs
├── Trainer/
│   ├── TrainerProfileViewModel.cs
│   └── TrainerStatsViewModel.cs
└── Shared/
    └── PagedListViewModel.cs  # Reusable base class
```

### Setting Up Namespace

**Add to _ViewImports.cshtml:**
```cshtml
@using YourProject.ViewModels
@using YourProject.ViewModels.Pokemon
@using YourProject.ViewModels.Trainer
```

Now you can use ViewModels in views without full namespace:
```cshtml
@model PokemonDetailsViewModel
```

---

## 7. Basic Usage

### Creating Your First ViewModel

**Step 1: Create the ViewModel class**

```csharp
// ViewModels/Pokemon/PokemonDetailsViewModel.cs
namespace PokemonMvcApp.ViewModels.Pokemon
{
    public class PokemonDetailsViewModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public int Level { get; set; }
        public int HP { get; set; }

        // Data from related entity
        public string TrainerName { get; set; }
        public string TrainerBadge { get; set; }

        // Computed properties
        public string PowerLevel => $"Level {Level} - {HP} HP";
        public bool IsStrongPokemon => Level > 50;
    }
}
```

**Step 2: Map in controller**

```csharp
public IActionResult Details(int id)
{
    // Get entity from service/repository
    var pokemon = _pokemonService.GetById(id);

    if (pokemon == null)
        return NotFound();

    // Map to ViewModel
    var viewModel = new PokemonDetailsViewModel
    {
        Id = pokemon.Id,
        Name = pokemon.Name,
        Type = pokemon.Type,
        Level = pokemon.Level,
        HP = pokemon.HP,
        TrainerName = pokemon.Trainer?.Name,
        TrainerBadge = pokemon.Trainer?.Badge
    };

    return View(viewModel);
}
```

**Step 3: Use in view**

```cshtml
@model PokemonDetailsViewModel

<div class="card">
    <div class="card-header">
        <h2>@Model.Name</h2>
    </div>
    <div class="card-body">
        <dl class="row">
            <dt class="col-sm-3">Type</dt>
            <dd class="col-sm-9">@Model.Type</dd>

            <dt class="col-sm-3">Power</dt>
            <dd class="col-sm-9">@Model.PowerLevel</dd>

            <dt class="col-sm-3">Trainer</dt>
            <dd class="col-sm-9">@Model.TrainerName (@Model.TrainerBadge)</dd>
        </dl>

        @if (Model.IsStrongPokemon)
        {
            <div class="alert alert-success">
                This is a strong Pokemon!
            </div>
        }
    </div>
</div>
```

### Form Submission with ViewModel

**GET action - display form:**
```csharp
public IActionResult Create()
{
    var viewModel = new CreatePokemonViewModel
    {
        // Set defaults
        Level = 1,

        // Populate dropdown
        AvailableTypes = new List<SelectListItem>
        {
            new SelectListItem { Value = "Fire", Text = "Fire" },
            new SelectListItem { Value = "Water", Text = "Water" },
            new SelectListItem { Value = "Grass", Text = "Grass" },
            new SelectListItem { Value = "Electric", Text = "Electric" }
        }
    };

    return View(viewModel);
}
```

**POST action - process form:**
```csharp
[HttpPost]
[ValidateAntiForgeryToken]
public IActionResult Create(CreatePokemonViewModel viewModel)
{
    if (!ModelState.IsValid)
    {
        // Repopulate dropdown on error
        viewModel.AvailableTypes = GetPokemonTypes();
        return View(viewModel);
    }

    // Map ViewModel to Entity
    var pokemon = new Pokemon
    {
        Name = viewModel.Name,
        Type = viewModel.Type,
        Level = viewModel.Level,
        HP = 100, // Set default
        CreatedDate = DateTime.Now
    };

    _pokemonService.Add(pokemon);

    return RedirectToAction(nameof(Details), new { id = pokemon.Id });
}
```

### Combining Multiple Entities

```csharp
public class PokemonTrainerViewModel
{
    // Pokemon data
    public PokemonDetailsViewModel Pokemon { get; set; }

    // Trainer data
    public TrainerSummaryViewModel Trainer { get; set; }

    // Combined/computed data
    public int DaysTogether { get; set; }
    public string BondLevel { get; set; }
}
```

**Controller:**
```csharp
public IActionResult PokemonAndTrainer(int pokemonId)
{
    var pokemon = _pokemonService.GetById(pokemonId);
    var trainer = _trainerService.GetById(pokemon.TrainerId);

    var viewModel = new PokemonTrainerViewModel
    {
        Pokemon = new PokemonDetailsViewModel
        {
            Id = pokemon.Id,
            Name = pokemon.Name,
            Type = pokemon.Type,
            Level = pokemon.Level
        },
        Trainer = new TrainerSummaryViewModel
        {
            Id = trainer.Id,
            Name = trainer.Name,
            Badge = trainer.Badge
        },
        DaysTogether = (DateTime.Now - pokemon.CreatedDate).Days,
        BondLevel = pokemon.Level > 50 ? "Strong" : "Growing"
    };

    return View(viewModel);
}
```

---

## 8. Testing & Validation

### Validating ViewModels

**ViewModel with validation attributes:**
```csharp
using System.ComponentModel.DataAnnotations;

public class CreatePokemonViewModel
{
    [Required(ErrorMessage = "Pokemon name is required")]
    [StringLength(50, MinimumLength = 2, ErrorMessage = "Name must be between 2 and 50 characters")]
    public string Name { get; set; }

    [Required(ErrorMessage = "Type is required")]
    public string Type { get; set; }

    [Range(1, 100, ErrorMessage = "Level must be between 1 and 100")]
    public int Level { get; set; }

    [Range(1, 200, ErrorMessage = "HP must be between 1 and 200")]
    public int HP { get; set; }
}
```

**Controller validation:**
```csharp
[HttpPost]
public IActionResult Create(CreatePokemonViewModel viewModel)
{
    if (!ModelState.IsValid)
    {
        return View(viewModel);  // Return with validation errors
    }

    // Process valid data
    var pokemon = MapToEntity(viewModel);
    _pokemonService.Add(pokemon);

    return RedirectToAction("Index");
}
```

**View with validation messages:**
```cshtml
@model CreatePokemonViewModel

<form asp-action="Create" method="post">
    <div class="form-group">
        <label asp-for="Name"></label>
        <input asp-for="Name" class="form-control" />
        <span asp-validation-for="Name" class="text-danger"></span>
    </div>

    <div class="form-group">
        <label asp-for="Level"></label>
        <input asp-for="Level" type="number" class="form-control" />
        <span asp-validation-for="Level" class="text-danger"></span>
    </div>

    <button type="submit" class="btn btn-primary">Create</button>
</form>

@section Scripts {
    @{await Html.RenderPartialAsync("_ValidationScriptsPartial");}
}
```

### Hands-On Exercises

#### Exercise 1: Create a Basic ViewModel (Beginner)

**Objective:** Create and use a simple ViewModel

**Task:**
Create a ViewModel for displaying Pokemon statistics:
1. Create `PokemonStatsViewModel` with properties: Name, Type, Level, HP, Attack, Defense
2. Add a computed property `TotalStats` (sum of HP + Attack + Defense)
3. Add a property `Rank` based on TotalStats (S/A/B/C)
4. Create controller action that maps entity to ViewModel
5. Create view that displays all properties

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**ViewModels/Pokemon/PokemonStatsViewModel.cs:**
```csharp
namespace PokemonMvcApp.ViewModels.Pokemon
{
    public class PokemonStatsViewModel
    {
        public string Name { get; set; }
        public string Type { get; set; }
        public int Level { get; set; }
        public int HP { get; set; }
        public int Attack { get; set; }
        public int Defense { get; set; }

        // Computed properties
        public int TotalStats => HP + Attack + Defense;

        public string Rank
        {
            get
            {
                return TotalStats switch
                {
                    > 200 => "S",
                    > 150 => "A",
                    > 100 => "B",
                    _ => "C"
                };
            }
        }
    }
}
```

**Controllers/PokemonController.cs:**
```csharp
public IActionResult Stats(int id)
{
    var pokemon = _pokemonService.GetById(id);

    if (pokemon == null)
        return NotFound();

    var viewModel = new PokemonStatsViewModel
    {
        Name = pokemon.Name,
        Type = pokemon.Type,
        Level = pokemon.Level,
        HP = pokemon.HP,
        Attack = pokemon.Attack,
        Defense = pokemon.Defense
    };

    return View(viewModel);
}
```

**Views/Pokemon/Stats.cshtml:**
```cshtml
@model PokemonStatsViewModel

<div class="container">
    <h1>@Model.Name Statistics</h1>

    <div class="card">
        <div class="card-body">
            <dl class="row">
                <dt class="col-sm-3">Type</dt>
                <dd class="col-sm-9">
                    <span class="badge bg-primary">@Model.Type</span>
                </dd>

                <dt class="col-sm-3">Level</dt>
                <dd class="col-sm-9">@Model.Level</dd>

                <dt class="col-sm-3">HP</dt>
                <dd class="col-sm-9">
                    <div class="progress">
                        <div class="progress-bar bg-danger" style="width: @Model.HP%">@Model.HP</div>
                    </div>
                </dd>

                <dt class="col-sm-3">Attack</dt>
                <dd class="col-sm-9">
                    <div class="progress">
                        <div class="progress-bar bg-warning" style="width: @Model.Attack%">@Model.Attack</div>
                    </div>
                </dd>

                <dt class="col-sm-3">Defense</dt>
                <dd class="col-sm-9">
                    <div class="progress">
                        <div class="progress-bar bg-info" style="width: @Model.Defense%">@Model.Defense</div>
                    </div>
                </dd>
            </dl>

            <hr>

            <div class="text-center">
                <h3>Total Stats: @Model.TotalStats</h3>
                <h2>Rank: <span class="badge bg-success">@Model.Rank</span></h2>
            </div>
        </div>
    </div>
</div>
```

</details>

---

#### Exercise 2: Form ViewModel with Validation (Intermediate)

**Objective:** Create a form ViewModel with validation

**Task:**
Create a ViewModel for editing Pokemon:
1. Create `EditPokemonViewModel` with validation
2. Add dropdown for Type selection
3. Implement GET action to load form
4. Implement POST action to process form
5. Handle validation errors

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**ViewModels/Pokemon/EditPokemonViewModel.cs:**
```csharp
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace PokemonMvcApp.ViewModels.Pokemon
{
    public class EditPokemonViewModel
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "Name is required")]
        [StringLength(50, MinimumLength = 2)]
        [Display(Name = "Pokemon Name")]
        public string Name { get; set; }

        [Required(ErrorMessage = "Type is required")]
        public string Type { get; set; }

        [Range(1, 100, ErrorMessage = "Level must be between 1 and 100")]
        public int Level { get; set; }

        [Range(1, 200, ErrorMessage = "HP must be between 1 and 200")]
        public int HP { get; set; }

        // Dropdown data (not validated)
        public List<SelectListItem> AvailableTypes { get; set; }
    }
}
```

**Controllers/PokemonController.cs:**
```csharp
// GET: Pokemon/Edit/5
public IActionResult Edit(int id)
{
    var pokemon = _pokemonService.GetById(id);

    if (pokemon == null)
        return NotFound();

    var viewModel = new EditPokemonViewModel
    {
        Id = pokemon.Id,
        Name = pokemon.Name,
        Type = pokemon.Type,
        Level = pokemon.Level,
        HP = pokemon.HP,
        AvailableTypes = GetPokemonTypes()
    };

    return View(viewModel);
}

// POST: Pokemon/Edit/5
[HttpPost]
[ValidateAntiForgeryToken]
public IActionResult Edit(int id, EditPokemonViewModel viewModel)
{
    if (id != viewModel.Id)
        return BadRequest();

    if (!ModelState.IsValid)
    {
        // Repopulate dropdown on validation error
        viewModel.AvailableTypes = GetPokemonTypes();
        return View(viewModel);
    }

    // Get existing entity
    var pokemon = _pokemonService.GetById(id);
    if (pokemon == null)
        return NotFound();

    // Update entity from ViewModel
    pokemon.Name = viewModel.Name;
    pokemon.Type = viewModel.Type;
    pokemon.Level = viewModel.Level;
    pokemon.HP = viewModel.HP;
    pokemon.ModifiedDate = DateTime.Now;

    _pokemonService.Update(pokemon);

    TempData["SuccessMessage"] = "Pokemon updated successfully!";
    return RedirectToAction(nameof(Details), new { id = pokemon.Id });
}

private List<SelectListItem> GetPokemonTypes()
{
    return new List<SelectListItem>
    {
        new SelectListItem { Value = "Fire", Text = "Fire" },
        new SelectListItem { Value = "Water", Text = "Water" },
        new SelectListItem { Value = "Grass", Text = "Grass" },
        new SelectListItem { Value = "Electric", Text = "Electric" },
        new SelectListItem { Value = "Psychic", Text = "Psychic" },
        new SelectListItem { Value = "Normal", Text = "Normal" }
    };
}
```

**Views/Pokemon/Edit.cshtml:**
```cshtml
@model EditPokemonViewModel

<div class="container">
    <h1>Edit Pokemon</h1>

    <div class="row">
        <div class="col-md-6">
            <form asp-action="Edit" method="post">
                <input type="hidden" asp-for="Id" />

                <div class="form-group mb-3">
                    <label asp-for="Name" class="form-label"></label>
                    <input asp-for="Name" class="form-control" />
                    <span asp-validation-for="Name" class="text-danger"></span>
                </div>

                <div class="form-group mb-3">
                    <label asp-for="Type" class="form-label"></label>
                    <select asp-for="Type" asp-items="Model.AvailableTypes" class="form-control">
                        <option value="">-- Select Type --</option>
                    </select>
                    <span asp-validation-for="Type" class="text-danger"></span>
                </div>

                <div class="form-group mb-3">
                    <label asp-for="Level" class="form-label"></label>
                    <input asp-for="Level" type="number" class="form-control" />
                    <span asp-validation-for="Level" class="text-danger"></span>
                </div>

                <div class="form-group mb-3">
                    <label asp-for="HP" class="form-label"></label>
                    <input asp-for="HP" type="number" class="form-control" />
                    <span asp-validation-for="HP" class="text-danger"></span>
                </div>

                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                    <a asp-action="Index" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>

@section Scripts {
    @{await Html.RenderPartialAsync("_ValidationScriptsPartial");}
}
```

</details>

---

#### Exercise 3: Complex ViewModel with Multiple Entities (Challenge)

**Objective:** Combine data from multiple entities into one ViewModel

**Task:**
Create a dashboard ViewModel that shows:
1. Trainer information
2. List of their Pokemon
3. Statistics (total Pokemon, average level, strongest Pokemon)
4. Recent activity

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**ViewModels/Trainer/TrainerDashboardViewModel.cs:**
```csharp
namespace PokemonMvcApp.ViewModels.Trainer
{
    public class TrainerDashboardViewModel
    {
        // Trainer info
        public int TrainerId { get; set; }
        public string TrainerName { get; set; }
        public string Badge { get; set; }

        // Pokemon list
        public List<PokemonSummaryViewModel> Pokemon { get; set; }

        // Statistics
        public int TotalPokemon => Pokemon?.Count ?? 0;
        public double AverageLevel => Pokemon?.Average(p => p.Level) ?? 0;
        public PokemonSummaryViewModel StrongestPokemon =>
            Pokemon?.OrderByDescending(p => p.Level).FirstOrDefault();

        // Activity
        public List<string> RecentActivities { get; set; }
    }

    public class PokemonSummaryViewModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public int Level { get; set; }
        public int HP { get; set; }
    }
}
```

**Controllers/TrainerController.cs:**
```csharp
public IActionResult Dashboard(int id)
{
    var trainer = _trainerService.GetById(id);
    if (trainer == null)
        return NotFound();

    var pokemonList = _pokemonService.GetByTrainerId(id);

    var viewModel = new TrainerDashboardViewModel
    {
        TrainerId = trainer.Id,
        TrainerName = trainer.Name,
        Badge = trainer.Badge,

        Pokemon = pokemonList.Select(p => new PokemonSummaryViewModel
        {
            Id = p.Id,
            Name = p.Name,
            Type = p.Type,
            Level = p.Level,
            HP = p.HP
        }).ToList(),

        RecentActivities = new List<string>
        {
            $"Caught {pokemonList.OrderByDescending(p => p.CreatedDate).FirstOrDefault()?.Name}",
            $"Leveled up {pokemonList.OrderByDescending(p => p.ModifiedDate).FirstOrDefault()?.Name}",
            "Visited Pokemon Center"
        }
    };

    return View(viewModel);
}
```

**Views/Trainer/Dashboard.cshtml:**
```cshtml
@model TrainerDashboardViewModel

<div class="container">
    <div class="row mb-4">
        <div class="col-md-12">
            <h1>@Model.TrainerName's Dashboard</h1>
            <p class="lead">Badge: <span class="badge bg-warning">@Model.Badge</span></p>
        </div>
    </div>

    <!-- Statistics -->
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card text-center">
                <div class="card-body">
                    <h2 class="display-4">@Model.TotalPokemon</h2>
                    <p class="text-muted">Total Pokemon</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-center">
                <div class="card-body">
                    <h2 class="display-4">@Model.AverageLevel.ToString("F1")</h2>
                    <p class="text-muted">Average Level</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-center">
                <div class="card-body">
                    <h2 class="display-4">@Model.StrongestPokemon?.Level</h2>
                    <p class="text-muted">Highest Level</p>
                    <small>@Model.StrongestPokemon?.Name</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Pokemon List -->
    <div class="row mb-4">
        <div class="col-md-12">
            <h3>Your Pokemon</h3>
            <div class="row">
                @foreach (var pokemon in Model.Pokemon)
                {
                    <div class="col-md-3 mb-3">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">@pokemon.Name</h5>
                                <p class="card-text">
                                    <span class="badge bg-primary">@pokemon.Type</span><br>
                                    Level: @pokemon.Level<br>
                                    HP: @pokemon.HP
                                </p>
                                <a asp-controller="Pokemon" asp-action="Details"
                                   asp-route-id="@pokemon.Id" class="btn btn-sm btn-primary">
                                    View
                                </a>
                            </div>
                        </div>
                    </div>
                }
            </div>
        </div>
    </div>

    <!-- Recent Activity -->
    <div class="row">
        <div class="col-md-6">
            <h3>Recent Activity</h3>
            <ul class="list-group">
                @foreach (var activity in Model.RecentActivities)
                {
                    <li class="list-group-item">@activity</li>
                }
            </ul>
        </div>
    </div>
</div>
```

</details>

---

## 9. Practical Examples

### Example 1: Search/Filter ViewModel

```csharp
public class PokemonSearchViewModel
{
    // Search filters
    [Display(Name = "Search by name")]
    public string SearchTerm { get; set; }

    [Display(Name = "Filter by type")]
    public string TypeFilter { get; set; }

    [Display(Name = "Minimum level")]
    [Range(1, 100)]
    public int? MinLevel { get; set; }

    [Display(Name = "Maximum level")]
    [Range(1, 100)]
    public int? MaxLevel { get; set; }

    // Results
    public List<PokemonItemViewModel> Results { get; set; }
    public int TotalResults { get; set; }

    // Pagination
    public int CurrentPage { get; set; } = 1;
    public int PageSize { get; set; } = 10;
    public int TotalPages => (int)Math.Ceiling((double)TotalResults / PageSize);

    // Dropdown data
    public List<SelectListItem> AvailableTypes { get; set; }
}
```

### Example 2: Wizard/Multi-Step Form

```csharp
// Step 1 ViewModel
public class CreatePokemonStep1ViewModel
{
    [Required]
    public string Name { get; set; }

    [Required]
    public string Type { get; set; }
}

// Step 2 ViewModel
public class CreatePokemonStep2ViewModel
{
    public string Name { get; set; }  // From step 1
    public string Type { get; set; }   // From step 1

    [Range(1, 100)]
    public int Level { get; set; }

    [Range(1, 200)]
    public int HP { get; set; }
}

// Final ViewModel combines all steps
public class CreatePokemonFinalViewModel
{
    public string Name { get; set; }
    public string Type { get; set; }
    public int Level { get; set; }
    public int HP { get; set; }
    public List<string> Moves { get; set; }
}
```

---

## 10. Common Patterns & Best Practices

### Do's

✅ **Always use ViewModels for forms**
```csharp
// Good
[HttpPost]
public IActionResult Create(CreatePokemonViewModel viewModel)

// Bad - security risk
[HttpPost]
public IActionResult Create(Pokemon pokemon)
```

✅ **Use meaningful names**
```csharp
// Good
PokemonDetailsViewModel
PokemonEditViewModel

// Bad
PokemonVM
PokemonView
```

✅ **Keep ViewModels focused**
```csharp
// Good - specific to one view
public class PokemonDetailsViewModel { }

// Bad - trying to be everything
public class PokemonAllPurposeViewModel { }
```

✅ **Use data annotations for validation**
```csharp
[Required]
[StringLength(50)]
public string Name { get; set; }
```

### Don'ts

❌ **Don't expose entities directly in views**
❌ **Don't put business logic in ViewModels**
❌ **Don't reuse ViewModels across unrelated views**
❌ **Don't forget to populate dropdown lists on validation errors**

---

## 11. Troubleshooting & Common Issues

### Problem: "The model item passed is of type Entity but requires ViewModel"

**Solution:** Make sure controller passes ViewModel, not Entity

```csharp
// Wrong
return View(pokemon);  // pokemon is entity

// Correct
var viewModel = new PokemonDetailsViewModel { /* map properties */ };
return View(viewModel);
```

### Problem: Dropdown list is empty after validation error

**Solution:** Repopulate dropdown data

```csharp
if (!ModelState.IsValid)
{
    viewModel.AvailableTypes = GetPokemonTypes();  // Repopulate!
    return View(viewModel);
}
```

---

## 12. Additional Resources

### Official Documentation
- [Model Binding in ASP.NET Core](https://docs.microsoft.com/aspnet/core/mvc/models/model-binding)
- [Model Validation](https://docs.microsoft.com/aspnet/core/mvc/models/validation)

### Recommended Libraries
- **AutoMapper** - Automatic object mapping
- **FluentValidation** - Alternative validation library

### Next Steps
1. **Data Annotations and Validation** - Deep dive into validation
2. **AutoMapper** - Learn automatic mapping
3. **Repository Pattern** - Organize data access
4. **Unit Testing ViewModels** - Test your ViewModels

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-11-23 | Initial version |

---

**Estimated Reading Time**: 35-40 minutes

**What's Next**: [Model Binding and Validation](model-binding-validation.md), [Entity Framework Core](entity-framework-core.md)
