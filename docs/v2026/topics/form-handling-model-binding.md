# Form Handling and Model Binding

---
**Technology Version**: .NET 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-23
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What is Form Handling and Model Binding?

Form handling is the process of accepting user input through HTML forms and processing it in your ASP.NET Core MVC application. Model binding is the automatic process that maps HTTP request data (form fields, query strings, route data) to action method parameters or model properties.

Think of model binding as an intelligent delivery service. When a user fills out a form (like entering Pokemon details), model binding automatically unpacks that data and hands it to your controller in exactly the format you need - whether it's simple values like strings and numbers, or complex objects like a complete Pokemon model.

### Why Learn Form Handling and Model Binding?

Forms and model binding are essential because:

- **Enable user input** - Forms are how users interact with your application (create, edit, search)
- **Automatic data mapping** - Model binding eliminates manual parsing of form data
- **Type safety** - Automatic conversion from strings to proper types (int, DateTime, etc.)
- **Validation integration** - Built-in support for validating user input
- **Security** - Proper form handling prevents common vulnerabilities
- **Clean code** - No need to manually extract values from Request.Form

### When to Use Forms and Model Binding

**Use forms when:**
- Creating new records (Add Pokemon)
- Editing existing records (Update Pokemon stats)
- Searching or filtering data
- User authentication (login/register)
- Any user input scenario

**Model binding handles:**
- Form submissions (POST data)
- Query string parameters (?name=Pikachu&level=25)
- Route parameters (/Pokemon/Edit/5)
- Request headers
- JSON/XML request bodies (for APIs)

---

## 2. Quick Start

**TL;DR - Create a form with model binding in 5 minutes:**

**Step 1: Create a model**
```csharp
public class Pokemon
{
    public string Name { get; set; }
    public string Type { get; set; }
    public int Level { get; set; }
}
```

**Step 2: GET action (display form)**
```csharp
public IActionResult Create()
{
    return View();
}
```

**Step 3: Create form view**
```cshtml
@model Pokemon

<form asp-action="Create" method="post">
    <input asp-for="Name" />
    <input asp-for="Type" />
    <input asp-for="Level" type="number" />
    <button type="submit">Create</button>
</form>
```

**Step 4: POST action (handle submission)**
```csharp
[HttpPost]
public IActionResult Create(Pokemon pokemon)
{
    // pokemon.Name, pokemon.Type, pokemon.Level
    // are automatically populated!
    SavePokemon(pokemon);
    return RedirectToAction("Index");
}
```

That's it! Model binding automatically maps form fields to the Pokemon object.

---

## 3. Prerequisites

### Required Knowledge

- **HTML basics** - Understanding of forms, inputs, and attributes
- **C# basics** - Classes, properties, types
- **MVC Controllers** - How controllers handle requests
- **Razor Views** - Creating views with @model directive
- **HTTP methods** - GET vs POST

### Required Software/Tools

- **.NET SDK** - Version 8.0 or higher
- **Code Editor** - Visual Studio, VS Code, or Rider
- **Browser** - For testing forms
- **Existing MVC Project**

---

## 4. Core Concepts & Theory

### Key Concepts

#### Concept 1: HTTP Methods - GET vs POST

**GET requests:**
- Used for retrieving data
- Data appears in URL (?name=value)
- Can be bookmarked
- Cached by browsers
- Use for: displaying forms, search, navigation

```csharp
// GET: /Pokemon/Create
[HttpGet]  // Optional - GET is default
public IActionResult Create()
{
    return View();  // Show empty form
}
```

**POST requests:**
- Used for submitting data
- Data in request body (not URL)
- Cannot be bookmarked
- Not cached
- Use for: creating, updating, deleting

```csharp
// POST: /Pokemon/Create
[HttpPost]
public IActionResult Create(Pokemon pokemon)
{
    SavePokemon(pokemon);
    return RedirectToAction("Index");
}
```

**Why separate GET and POST actions?**
```csharp
public class PokemonController : Controller
{
    // GET: Show form
    public IActionResult Create()
    {
        return View();
    }

    // POST: Process form
    [HttpPost]
    public IActionResult Create(Pokemon pokemon)
    {
        // Same action name, different HTTP method
        return RedirectToAction("Index");
    }
}
```

#### Concept 2: Model Binding Basics

Model binding automatically maps request data to action parameters.

**Sources of data (in order of precedence):**
1. Form values (POST data)
2. Route values (/Pokemon/Details/5)
3. Query string (?id=5)
4. Request headers

**Simple type binding:**
```csharp
// URL: /Pokemon/Details?id=25
public IActionResult Details(int id)
{
    // Model binder automatically converts "25" string to int 25
    return View();
}

// URL: /Pokemon/Search?name=Pikachu&level=10
public IActionResult Search(string name, int level)
{
    // name = "Pikachu", level = 10
    return View();
}
```

**Complex type binding (objects):**
```csharp
public class Pokemon
{
    public string Name { get; set; }
    public int Level { get; set; }
}

[HttpPost]
public IActionResult Create(Pokemon pokemon)
{
    // Model binder creates Pokemon object
    // and sets properties from form fields
    return View();
}
```

**Form that binds to above:**
```html
<form method="post">
    <input name="Name" value="Pikachu" />
    <input name="Level" value="25" />
    <button type="submit">Submit</button>
</form>
```

Model binder matches `name` attributes to property names!

#### Concept 3: Tag Helpers for Forms

Tag helpers generate proper HTML with model binding:

**Without tag helpers (manual):**
```html
<form action="/Pokemon/Create" method="post">
    <input name="Name" type="text" />
    <input name="Level" type="number" />
</form>
```

**With tag helpers (recommended):**
```cshtml
@model Pokemon

<form asp-action="Create" method="post">
    <input asp-for="Name" />
    <input asp-for="Level" />
</form>
```

**Generated HTML:**
```html
<form action="/Pokemon/Create" method="post">
    <input type="text" id="Name" name="Name" value="" />
    <input type="number" id="Level" name="Level" value="0" />
</form>
```

**Tag helper benefits:**
- Automatic `name` attribute (matches property name)
- Automatic `id` attribute
- Automatic `type` attribute based on property type
- Pre-fills `value` from model
- Validation attributes added automatically

#### Concept 4: Binding Complex Types

**Object with properties:**
```csharp
public class Pokemon
{
    public string Name { get; set; }
    public string Type { get; set; }
    public int Level { get; set; }
}

[HttpPost]
public IActionResult Create(Pokemon pokemon)
{
    // All properties automatically bound
}
```

**Form:**
```cshtml
<form asp-action="Create" method="post">
    <input asp-for="Name" />     @* Binds to pokemon.Name *@
    <input asp-for="Type" />     @* Binds to pokemon.Type *@
    <input asp-for="Level" />    @* Binds to pokemon.Level *@
    <button type="submit">Create</button>
</form>
```

**Object with nested objects:**
```csharp
public class Pokemon
{
    public string Name { get; set; }
    public Stats Statistics { get; set; }
}

public class Stats
{
    public int HP { get; set; }
    public int Attack { get; set; }
}
```

**Form with nested binding:**
```cshtml
<input asp-for="Name" />
<input asp-for="Statistics.HP" />        @* Binds to pokemon.Statistics.HP *@
<input asp-for="Statistics.Attack" />    @* Binds to pokemon.Statistics.Attack *@
```

**Generated HTML:**
```html
<input name="Name" />
<input name="Statistics.HP" />
<input name="Statistics.Attack" />
```

#### Concept 5: Model Binding Collections

**List/Array binding:**
```csharp
[HttpPost]
public IActionResult CreateMultiple(List<Pokemon> pokemon)
{
    // Binds to a list of Pokemon
}
```

**Form:**
```html
<input name="pokemon[0].Name" value="Pikachu" />
<input name="pokemon[0].Level" value="25" />

<input name="pokemon[1].Name" value="Charizard" />
<input name="pokemon[1].Level" value="36" />
```

**Dictionary binding:**
```csharp
public IActionResult UpdateStats(Dictionary<string, int> stats)
{
    // stats["HP"] = 100
    // stats["Attack"] = 55
}
```

**Form:**
```html
<input name="stats[HP]" value="100" />
<input name="stats[Attack]" value="55" />
```

#### Concept 6: ModelState and Validation

**ModelState** tracks:
- Whether model binding succeeded
- Validation errors
- Original values submitted

**Checking ModelState:**
```csharp
[HttpPost]
public IActionResult Create(Pokemon pokemon)
{
    if (!ModelState.IsValid)
    {
        // Validation failed
        return View(pokemon);  // Return form with errors
    }

    // Validation passed
    SavePokemon(pokemon);
    return RedirectToAction("Index");
}
```

**Adding validation attributes:**
```csharp
using System.ComponentModel.DataAnnotations;

public class Pokemon
{
    [Required(ErrorMessage = "Name is required")]
    [StringLength(50, MinimumLength = 2)]
    public string Name { get; set; }

    [Required]
    [Range(1, 100, ErrorMessage = "Level must be between 1 and 100")]
    public int Level { get; set; }
}
```

**Displaying validation errors:**
```cshtml
<form asp-action="Create" method="post">
    <div class="form-group">
        <label asp-for="Name"></label>
        <input asp-for="Name" class="form-control" />
        <span asp-validation-for="Name" class="text-danger"></span>
    </div>

    <div class="form-group">
        <label asp-for="Level"></label>
        <input asp-for="Level" class="form-control" />
        <span asp-validation-for="Level" class="text-danger"></span>
    </div>

    <button type="submit">Create</button>
</form>
```

#### Concept 7: Post-Redirect-Get (PRG) Pattern

**Problem without PRG:**
```csharp
[HttpPost]
public IActionResult Create(Pokemon pokemon)
{
    SavePokemon(pokemon);
    return View("Success");  // ❌ Bad: If user refreshes, form resubmits!
}
```

**Solution with PRG:**
```csharp
[HttpPost]
public IActionResult Create(Pokemon pokemon)
{
    SavePokemon(pokemon);
    TempData["Message"] = "Pokemon created successfully!";
    return RedirectToAction("Details", new { id = pokemon.Id });  // ✅ Good
}
```

**Why PRG is important:**
- Prevents duplicate submissions on page refresh
- Better user experience (back button works correctly)
- Proper browser history
- Prevents accidental duplicate orders/payments

#### Concept 8: Anti-Forgery Tokens (CSRF Protection)

**CSRF** (Cross-Site Request Forgery) attack:
- Malicious site tricks user's browser into submitting form to your site
- User is logged in, so request appears legitimate

**Protection:**
```cshtml
<form asp-action="Create" method="post">
    @* Tag helper automatically adds anti-forgery token *@
    <input asp-for="Name" />
    <button type="submit">Create</button>
</form>
```

**Generated HTML:**
```html
<form action="/Pokemon/Create" method="post">
    <input name="__RequestVerificationToken" type="hidden" value="random-token" />
    <input name="Name" />
    <button type="submit">Create</button>
</form>
```

**Controller validation:**
```csharp
[HttpPost]
[ValidateAntiForgeryToken]  // Validates token
public IActionResult Create(Pokemon pokemon)
{
    // If token is invalid/missing, request is rejected
}
```

### Important Terminology

| Term | Definition |
|------|------------|
| **Model Binding** | Automatic mapping of request data to action parameters |
| **GET** | HTTP method for retrieving data (shows form) |
| **POST** | HTTP method for submitting data (processes form) |
| **ModelState** | Object tracking model binding success and validation errors |
| **Tag Helper** | Server-side code that generates HTML (asp-* attributes) |
| **PRG Pattern** | Post-Redirect-Get - redirect after POST to prevent resubmission |
| **CSRF** | Cross-Site Request Forgery - type of security attack |
| **Anti-Forgery Token** | Hidden field that prevents CSRF attacks |
| **Validation** | Checking if submitted data meets requirements |
| **TempData** | Dictionary for passing data across one redirect |

---

## 5. Installation Guide

### No Installation Required

Form handling and model binding are built into ASP.NET Core MVC. No additional packages needed.

### Verify Form Handling Works

**Create test form:**

**Controllers/TestController.cs:**
```csharp
public class TestController : Controller
{
    public IActionResult Form()
    {
        return View();
    }

    [HttpPost]
    public IActionResult Form(string name, int age)
    {
        return Content($"Received: Name={name}, Age={age}");
    }
}
```

**Views/Test/Form.cshtml:**
```cshtml
<form method="post">
    <input name="name" placeholder="Name" />
    <input name="age" type="number" placeholder="Age" />
    <button type="submit">Submit</button>
</form>
```

**Test:** Navigate to `/Test/Form`, fill out, submit - should see values displayed.

---

## 6. Initial Setup & Configuration

### Enable Anti-Forgery Tokens Globally

**In Program.cs:**
```csharp
builder.Services.AddControllersWithViews(options =>
{
    // Automatically validate anti-forgery tokens on all POST requests
    options.Filters.Add(new AutoValidateAntiforgeryTokenAttribute());
});
```

### Configure Model Binding Options

```csharp
builder.Services.AddControllersWithViews(options =>
{
    // Customize model binding behavior
    options.MaxModelBindingCollectionSize = 1024;
    options.MaxModelValidationErrors = 50;
});
```

### Client-Side Validation Setup

**Add validation scripts to _Layout.cshtml:**
```cshtml
<script src="~/lib/jquery/dist/jquery.min.js"></script>
<script src="~/lib/jquery-validation/dist/jquery.validate.min.js"></script>
<script src="~/lib/jquery-validation-unobtrusive/jquery.validate.unobtrusive.min.js"></script>
```

**Or add to specific views:**
```cshtml
@section Scripts {
    <partial name="_ValidationScriptsPartial" />
}
```

---

## 7. Basic Usage

### Creating a Simple Form

**Step 1: Create model**
```csharp
// Models/Pokemon.cs
public class Pokemon
{
    public string Name { get; set; }
    public string Type { get; set; }
    public int Level { get; set; }
}
```

**Step 2: GET action**
```csharp
// GET: /Pokemon/Create
public IActionResult Create()
{
    return View();
}
```

**Step 3: Create form view**
```cshtml
@model Pokemon

<h2>Create Pokemon</h2>

<form asp-action="Create" method="post">
    <div class="form-group">
        <label asp-for="Name"></label>
        <input asp-for="Name" class="form-control" />
    </div>

    <div class="form-group">
        <label asp-for="Type"></label>
        <input asp-for="Type" class="form-control" />
    </div>

    <div class="form-group">
        <label asp-for="Level"></label>
        <input asp-for="Level" type="number" class="form-control" />
    </div>

    <button type="submit" class="btn btn-primary">Create</button>
</form>
```

**Step 4: POST action**
```csharp
[HttpPost]
public IActionResult Create(Pokemon pokemon)
{
    // pokemon object automatically populated!
    // pokemon.Name = what user entered
    // pokemon.Type = what user entered
    // pokemon.Level = what user entered

    _pokemonService.Add(pokemon);

    return RedirectToAction("Index");
}
```

### Form with Validation

**Model with validation:**
```csharp
using System.ComponentModel.DataAnnotations;

public class Pokemon
{
    [Required(ErrorMessage = "Pokemon name is required")]
    [StringLength(50, MinimumLength = 2)]
    public string Name { get; set; }

    [Required]
    public string Type { get; set; }

    [Range(1, 100)]
    public int Level { get; set; }
}
```

**Controller with validation check:**
```csharp
[HttpPost]
public IActionResult Create(Pokemon pokemon)
{
    if (!ModelState.IsValid)
    {
        // Validation failed - return form with errors
        return View(pokemon);
    }

    // Validation passed
    _pokemonService.Add(pokemon);
    return RedirectToAction("Index");
}
```

**View with validation messages:**
```cshtml
@model Pokemon

<form asp-action="Create" method="post">
    <div class="form-group">
        <label asp-for="Name"></label>
        <input asp-for="Name" class="form-control" />
        <span asp-validation-for="Name" class="text-danger"></span>
    </div>

    <div class="form-group">
        <label asp-for="Type"></label>
        <input asp-for="Type" class="form-control" />
        <span asp-validation-for="Type" class="text-danger"></span>
    </div>

    <div class="form-group">
        <label asp-for="Level"></label>
        <input asp-for="Level" class="form-control" />
        <span asp-validation-for="Level" class="text-danger"></span>
    </div>

    <button type="submit" class="btn btn-primary">Create</button>
</form>

@section Scripts {
    @{await Html.RenderPartialAsync("_ValidationScriptsPartial");}
}
```

### Edit Form (Populating with Existing Data)

**GET action:**
```csharp
public IActionResult Edit(int id)
{
    var pokemon = _pokemonService.GetById(id);

    if (pokemon == null)
        return NotFound();

    return View(pokemon);  // Pass existing data to view
}
```

**View:**
```cshtml
@model Pokemon

<h2>Edit Pokemon</h2>

<form asp-action="Edit" method="post">
    <input type="hidden" asp-for="Id" />  @* Include ID *@

    <div class="form-group">
        <label asp-for="Name"></label>
        <input asp-for="Name" class="form-control" />
        @* Value automatically populated from model *@
    </div>

    <div class="form-group">
        <label asp-for="Level"></label>
        <input asp-for="Level" class="form-control" />
    </div>

    <button type="submit" class="btn btn-primary">Save Changes</button>
</form>
```

**POST action:**
```csharp
[HttpPost]
public IActionResult Edit(int id, Pokemon pokemon)
{
    if (id != pokemon.Id)
        return BadRequest();

    if (!ModelState.IsValid)
        return View(pokemon);

    _pokemonService.Update(pokemon);

    return RedirectToAction("Details", new { id = pokemon.Id });
}
```

### Dropdown Lists (Select Elements)

**Model:**
```csharp
public class Pokemon
{
    public string Name { get; set; }

    [Required]
    public string Type { get; set; }

    // For dropdown options (not bound from form)
    public List<SelectListItem> AvailableTypes { get; set; }
}
```

**Controller:**
```csharp
public IActionResult Create()
{
    var model = new Pokemon
    {
        AvailableTypes = new List<SelectListItem>
        {
            new SelectListItem { Value = "Fire", Text = "Fire" },
            new SelectListItem { Value = "Water", Text = "Water" },
            new SelectListItem { Value = "Grass", Text = "Grass" },
            new SelectListItem { Value = "Electric", Text = "Electric" }
        }
    };

    return View(model);
}
```

**View:**
```cshtml
<div class="form-group">
    <label asp-for="Type"></label>
    <select asp-for="Type" asp-items="Model.AvailableTypes" class="form-control">
        <option value="">-- Select Type --</option>
    </select>
    <span asp-validation-for="Type" class="text-danger"></span>
</div>
```

---

## 8. Testing & Validation

### Testing Form Submission

**Manual testing:**
1. Run application
2. Navigate to form
3. Fill out fields
4. Submit
5. Verify data saved correctly
6. Check redirect worked

**Testing validation:**
1. Leave required fields empty
2. Submit form
3. Verify error messages appear
4. Enter invalid data (e.g., Level = 999)
5. Verify validation messages

### Browser DevTools Testing

**Check form data being sent:**
1. Open DevTools (F12)
2. Go to Network tab
3. Submit form
4. Click the POST request
5. View "Payload" or "Form Data" tab
6. Verify correct data is being sent

### Hands-On Exercises

#### Exercise 1: Create a Search Form (Beginner)

**Objective:** Create a GET form for searching Pokemon

**Task:**
Create a search form that:
1. Has fields for: Name (text), Type (dropdown), MinLevel (number)
2. Submits via GET (not POST)
3. Controller receives parameters
4. Display search parameters on results page

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Models/PokemonSearchModel.cs:**
```csharp
public class PokemonSearchModel
{
    public string Name { get; set; }
    public string Type { get; set; }
    public int? MinLevel { get; set; }
}
```

**Controllers/PokemonController.cs:**
```csharp
// GET: /Pokemon/Search
public IActionResult Search(string name, string type, int? minLevel)
{
    // These parameters are automatically bound from query string

    var results = _pokemonService.Search(name, type, minLevel);

    ViewData["SearchName"] = name;
    ViewData["SearchType"] = type;
    ViewData["SearchMinLevel"] = minLevel;

    return View(results);
}
```

**Views/Pokemon/Search.cshtml:**
```cshtml
@model List<Pokemon>

<h2>Search Pokemon</h2>

<form method="get" asp-action="Search">
    <div class="row">
        <div class="col-md-4">
            <input name="name" class="form-control" placeholder="Name" value="@ViewData["SearchName"]" />
        </div>
        <div class="col-md-3">
            <select name="type" class="form-control">
                <option value="">All Types</option>
                <option value="Fire">Fire</option>
                <option value="Water">Water</option>
                <option value="Grass">Grass</option>
            </select>
        </div>
        <div class="col-md-3">
            <input name="minLevel" type="number" class="form-control" placeholder="Min Level" value="@ViewData["SearchMinLevel"]" />
        </div>
        <div class="col-md-2">
            <button type="submit" class="btn btn-primary">Search</button>
        </div>
    </div>
</form>

<hr>

@if (Model != null && Model.Any())
{
    <h3>Results (@Model.Count found)</h3>
    <ul>
        @foreach (var pokemon in Model)
        {
            <li>@pokemon.Name - @pokemon.Type (Level @pokemon.Level)</li>
        }
    </ul>
}
else
{
    <p>No Pokemon found matching your search criteria.</p>
}
```

**Test:**
- Navigate to `/Pokemon/Search`
- Try different search combinations
- Notice URL changes: `/Pokemon/Search?name=Pika&type=Electric&minLevel=20`
- Search results persist if you bookmark URL

</details>

---

#### Exercise 2: Form with Validation (Intermediate)

**Objective:** Create a validated form for adding Pokemon

**Task:**
1. Create Pokemon model with validation attributes
2. Create GET action to show form
3. Create POST action to process form
4. Handle validation errors
5. Display success message after save

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Models/Pokemon.cs:**
```csharp
using System.ComponentModel.DataAnnotations;

public class Pokemon
{
    public int Id { get; set; }

    [Required(ErrorMessage = "Pokemon name is required")]
    [StringLength(50, MinimumLength = 2, ErrorMessage = "Name must be between 2 and 50 characters")]
    [Display(Name = "Pokemon Name")]
    public string Name { get; set; }

    [Required(ErrorMessage = "Type is required")]
    public string Type { get; set; }

    [Required]
    [Range(1, 100, ErrorMessage = "Level must be between 1 and 100")]
    public int Level { get; set; }

    [Range(1, 200, ErrorMessage = "HP must be between 1 and 200")]
    public int HP { get; set; }
}
```

**Controllers/PokemonController.cs:**
```csharp
// GET: /Pokemon/Add
public IActionResult Add()
{
    return View();
}

// POST: /Pokemon/Add
[HttpPost]
[ValidateAntiForgeryToken]
public IActionResult Add(Pokemon pokemon)
{
    // Check if model is valid
    if (!ModelState.IsValid)
    {
        // Return form with validation errors
        return View(pokemon);
    }

    // Save Pokemon
    _pokemonService.Add(pokemon);

    // Set success message
    TempData["SuccessMessage"] = $"{pokemon.Name} has been added successfully!";

    // Redirect to list (PRG pattern)
    return RedirectToAction("Index");
}
```

**Views/Pokemon/Add.cshtml:**
```cshtml
@model Pokemon

<div class="container">
    <h2>Add New Pokemon</h2>

    @* Display validation summary for all errors *@
    <div asp-validation-summary="All" class="text-danger"></div>

    <div class="row">
        <div class="col-md-6">
            <form asp-action="Add" method="post">
                <div class="form-group mb-3">
                    <label asp-for="Name" class="form-label"></label>
                    <input asp-for="Name" class="form-control" />
                    <span asp-validation-for="Name" class="text-danger"></span>
                </div>

                <div class="form-group mb-3">
                    <label asp-for="Type" class="form-label"></label>
                    <select asp-for="Type" class="form-control">
                        <option value="">-- Select Type --</option>
                        <option value="Fire">Fire</option>
                        <option value="Water">Water</option>
                        <option value="Grass">Grass</option>
                        <option value="Electric">Electric</option>
                    </select>
                    <span asp-validation-for="Type" class="text-danger"></span>
                </div>

                <div class="form-group mb-3">
                    <label asp-for="Level" class="form-label"></label>
                    <input asp-for="Level" type="number" class="form-control" value="1" />
                    <span asp-validation-for="Level" class="text-danger"></span>
                </div>

                <div class="form-group mb-3">
                    <label asp-for="HP" class="form-label"></label>
                    <input asp-for="HP" type="number" class="form-control" value="100" />
                    <span asp-validation-for="HP" class="text-danger"></span>
                </div>

                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Add Pokemon</button>
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

**Views/Pokemon/Index.cshtml (show success message):**
```cshtml
@if (TempData["SuccessMessage"] != null)
{
    <div class="alert alert-success alert-dismissible fade show">
        @TempData["SuccessMessage"]
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
}
```

**Test:**
- Try submitting empty form - see validation errors
- Enter name with 1 character - see length validation
- Enter Level = 150 - see range validation
- Fill correctly - see success message after redirect

</details>

---

#### Exercise 3: Multi-Step Form (Challenge)

**Objective:** Create a wizard-style multi-step form

**Task:**
1. Step 1: Basic info (Name, Type)
2. Step 2: Stats (Level, HP, Attack)
3. Step 3: Confirm and submit
4. Use TempData to pass between steps

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Models/CreatePokemonWizard.cs:**
```csharp
public class CreatePokemonStep1
{
    [Required]
    public string Name { get; set; }

    [Required]
    public string Type { get; set; }
}

public class CreatePokemonStep2
{
    [Range(1, 100)]
    public int Level { get; set; }

    [Range(1, 200)]
    public int HP { get; set; }

    [Range(1, 200)]
    public int Attack { get; set; }
}
```

**Controllers/PokemonWizardController.cs:**
```csharp
using System.Text.Json;

public class PokemonWizardController : Controller
{
    // Step 1: GET
    public IActionResult Step1()
    {
        return View();
    }

    // Step 1: POST
    [HttpPost]
    public IActionResult Step1(CreatePokemonStep1 model)
    {
        if (!ModelState.IsValid)
            return View(model);

        // Store in TempData
        TempData["Step1Data"] = JsonSerializer.Serialize(model);

        return RedirectToAction("Step2");
    }

    // Step 2: GET
    public IActionResult Step2()
    {
        if (TempData["Step1Data"] == null)
            return RedirectToAction("Step1");

        return View();
    }

    // Step 2: POST
    [HttpPost]
    public IActionResult Step2(CreatePokemonStep2 model)
    {
        if (!ModelState.IsValid)
            return View(model);

        // Keep Step1Data
        TempData.Keep("Step1Data");

        // Store Step2Data
        TempData["Step2Data"] = JsonSerializer.Serialize(model);

        return RedirectToAction("Confirm");
    }

    // Step 3: Confirm
    public IActionResult Confirm()
    {
        if (TempData["Step1Data"] == null || TempData["Step2Data"] == null)
            return RedirectToAction("Step1");

        var step1 = JsonSerializer.Deserialize<CreatePokemonStep1>((string)TempData["Step1Data"]);
        var step2 = JsonSerializer.Deserialize<CreatePokemonStep2>((string)TempData["Step2Data"]);

        // Keep data for POST
        TempData.Keep("Step1Data");
        TempData.Keep("Step2Data");

        var viewModel = new
        {
            Name = step1.Name,
            Type = step1.Type,
            Level = step2.Level,
            HP = step2.HP,
            Attack = step2.Attack
        };

        return View(viewModel);
    }

    // Final Submit
    [HttpPost]
    public IActionResult Complete()
    {
        var step1 = JsonSerializer.Deserialize<CreatePokemonStep1>((string)TempData["Step1Data"]);
        var step2 = JsonSerializer.Deserialize<CreatePokemonStep2>((string)TempData["Step2Data"]);

        // Create Pokemon
        var pokemon = new Pokemon
        {
            Name = step1.Name,
            Type = step1.Type,
            Level = step2.Level,
            HP = step2.HP,
            Attack = step2.Attack
        };

        _pokemonService.Add(pokemon);

        TempData["SuccessMessage"] = "Pokemon created successfully via wizard!";

        return RedirectToAction("Index", "Pokemon");
    }
}
```

**Views - Create Step1.cshtml, Step2.cshtml, Confirm.cshtml with appropriate forms**

</details>

---

## 9. Practical Examples

See exercises above for complete practical examples.

---

## 10. Common Patterns & Best Practices

### Do's

✅ **Use PRG pattern after POST**
✅ **Validate on both client and server**
✅ **Use tag helpers for forms**
✅ **Include anti-forgery tokens**
✅ **Use strongly-typed models**

### Don'ts

❌ **Don't return View() after successful POST**
❌ **Don't trust client-side validation alone**
❌ **Don't bind directly to entities (use ViewModels)**
❌ **Don't forget [HttpPost] attribute**

---

## 11. Troubleshooting & Common Issues

### Problem: Model properties are null after POST

**Check:**
- Input `name` attributes match property names (case-sensitive!)
- Form uses `method="post"`
- Properties have public setters

### Problem: Validation not working

**Check:**
- Added validation attributes to model
- Included validation scripts
- Checking ModelState.IsValid in controller

---

## 12. Additional Resources

- [Model Binding in ASP.NET Core](https://docs.microsoft.com/aspnet/core/mvc/models/model-binding)
- [Model Validation](https://docs.microsoft.com/aspnet/core/mvc/models/validation)
- [Tag Helpers](https://docs.microsoft.com/aspnet/core/mvc/views/tag-helpers/intro)

---

**Estimated Reading Time**: 50-55 minutes

**What's Next**: [Data Annotations and Validation](data-annotations-validation.md), [Entity Framework Core](entity-framework-core.md)
