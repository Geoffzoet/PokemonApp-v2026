# Razor Views and Syntax

---
**Technology Version**: .NET 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-23
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What is Razor?

Razor is a templating syntax for mixing C# code with HTML markup to create dynamic web pages. It's the view engine used in ASP.NET Core MVC to generate HTML responses. Razor files have the `.cshtml` extension (C# + HTML) and allow you to embed server-side code directly in your HTML using the `@` symbol.

Think of Razor as a bridge between your C# backend and HTML frontend. It's like having a smart HTML file that can execute code, make decisions, loop through data, and dynamically generate content based on what your controller sends it.

### Why Use Razor?

Razor views are essential in ASP.NET Core MVC because they:

- **Generate dynamic HTML** - Create pages that change based on data (user info, database results, etc.)
- **Keep code and markup together** - Write C# logic right where you need it in HTML
- **Provide type safety** - Strongly-typed views give you IntelliSense and compile-time checking
- **Enable code reuse** - Use layouts, partial views, and view components to avoid duplication
- **Integrate seamlessly** - Works perfectly with ASP.NET Core MVC controllers and models
- **Support tag helpers** - Clean, HTML-like syntax for common tasks

### When to Use Razor

**Use Razor views when:**
- Building traditional server-rendered web applications
- You need to generate complete HTML pages on the server
- Creating websites where SEO is important (search engines see complete HTML)
- Building admin dashboards, content management systems, or internal tools
- You want tight integration between backend and frontend

**Consider alternatives when:**
- Building Single Page Applications (SPAs) - Use Web API + React/Angular/Vue
- Creating mobile app backends - Use Web API for JSON responses
- Need highly interactive UIs with minimal page loads - Consider Blazor or SPAs

---

## 2. Quick Start

**TL;DR - Create your first Razor view in 2 minutes:**

**Step 1: Create a simple view**

Create `Views/Home/Hello.cshtml`:
```cshtml
@{
    ViewData["Title"] = "Hello";
}

<h1>Hello, Razor!</h1>
<p>The current time is: @DateTime.Now.ToString("HH:mm:ss")</p>

@{
    var name = "Trainer";
    var pokemonCount = 151;
}

<div class="alert alert-info">
    <strong>@name</strong>, there are <strong>@pokemonCount</strong> Pokemon to catch!
</div>
```

**Step 2: Add controller action**

```csharp
public IActionResult Hello()
{
    return View();
}
```

**Step 3: Run and view**

Navigate to `/Home/Hello` and see your dynamic content!

**Key Razor syntax used:**
- `@{ }` - Code block for multi-line C# code
- `@variable` - Output a C# variable
- `@DateTime.Now` - Execute C# expressions inline

For detailed explanations, continue reading the sections below.

---

## 3. Prerequisites

### Required Knowledge

- **HTML fundamentals** - Tags, attributes, structure. You should be comfortable reading and writing HTML.
- **C# basics** - Variables, loops, conditionals, string interpolation.
- **MVC pattern understanding** - What controllers and views are, how they interact.
- **MVC Controllers** - How to create controllers and action methods (see POK-22 guide).

### Required Software/Tools

- **.NET SDK** - Version 8.0 or higher
- **Code Editor** - Visual Studio, VS Code, or Rider with Razor syntax highlighting
- **Existing MVC Project** - You should have an MVC project created

### System Requirements

- **Operating System**: Windows 10+, macOS 11+, or modern Linux
- **RAM**: 4GB minimum (8GB recommended)
- **Disk Space**: 500MB free for project files

---

## 4. Core Concepts & Theory

### Key Concepts

#### Concept 1: The @ Symbol - Switching from HTML to C#

The `@` symbol is the magic character in Razor that switches from HTML to C# code.

**Output a variable:**
```cshtml
@{
    var name = "Pikachu";
}

<p>Pokemon name: @name</p>
```

**Output:** `Pokemon name: Pikachu`

**Execute an expression:**
```cshtml
<p>Current time: @DateTime.Now.ToString("HH:mm")</p>
<p>Random number: @new Random().Next(1, 100)</p>
```

**Call methods:**
```cshtml
<p>Uppercase: @name.ToUpper()</p>
<p>Length: @name.Length</p>
```

#### Concept 2: Code Blocks with @{ }

Use `@{ }` for multi-line C# code blocks.

**Single statement:**
```cshtml
@{ var name = "Pikachu"; }
```

**Multiple statements:**
```cshtml
@{
    var name = "Pikachu";
    var type = "Electric";
    var level = 25;
    var greeting = $"Hello, {name}!";
}
```

**Code blocks with logic:**
```cshtml
@{
    var now = DateTime.Now;
    string greeting;

    if (now.Hour < 12)
        greeting = "Good morning";
    else if (now.Hour < 18)
        greeting = "Good afternoon";
    else
        greeting = "Good evening";
}

<h1>@greeting, Trainer!</h1>
```

#### Concept 3: Implicit Razor Expressions

Razor automatically switches back to HTML when it sees HTML tags.

**Simple example:**
```cshtml
@if (pokemon != null)
{
    <p>Found Pokemon: @pokemon.Name</p>
}
```

Notice: No `@` before `<p>` - Razor knows it's HTML!

**More complex:**
```cshtml
@foreach (var pokemon in Model)
{
    <div class="card">
        <h3>@pokemon.Name</h3>
        <p>Type: @pokemon.Type</p>
    </div>
}
```

The HTML tags automatically switch to HTML mode; `@pokemon.Name` switches back to C#.

#### Concept 4: Explicit Razor Expressions with @( )

Use `@( )` when Razor can't figure out where your expression ends.

**When expression is ambiguous:**
```cshtml
@* Wrong - Razor confused ❌ *@
<p>Email: name@domain.com</p>  @* Thinks @domain is code! *@

@* Right - Use @@ to escape ✅ *@
<p>Email: name@@domain.com</p>

@* Or use parentheses ✅ *@
<p>Total: @(pokemon.Level * 2)</p>
```

**Complex expressions:**
```cshtml
<p>Status: @(pokemon.HP > 50 ? "Healthy" : "Weak")</p>
<p>Power: @(pokemon.Level * pokemon.HP / 10)</p>
```

#### Concept 5: Razor Comments

Razor has its own comment syntax.

**Razor comments (not sent to browser):**
```cshtml
@* This is a Razor comment *@
@*
   Multi-line
   Razor comment
*@
```

**HTML comments (sent to browser):**
```cshtml
<!-- This is an HTML comment -->
<!-- Users can see this in View Source -->
```

**C# comments (inside code blocks):**
```cshtml
@{
    // This is a C# single-line comment
    var name = "Pikachu";

    /* This is a C#
       multi-line comment */
    var type = "Electric";
}
```

#### Concept 6: Strongly-Typed Views with @model

The `@model` directive specifies the type of data passed from the controller.

**Define the model type:**
```cshtml
@model Pokemon

@* Now you can use Model with IntelliSense *@
<h1>@Model.Name</h1>
<p>Type: @Model.Type</p>
<p>Level: @Model.Level</p>
```

**For collections:**
```cshtml
@model List<Pokemon>

<ul>
@foreach (var pokemon in Model)
{
    <li>@pokemon.Name - @pokemon.Type</li>
}
</ul>
```

**Benefits:**
- IntelliSense/autocomplete in IDE
- Compile-time type checking
- Cleaner code (no casting needed)
- Self-documenting (you know what data the view expects)

#### Concept 7: Control Structures

Razor supports all C# control structures.

**If statements:**
```cshtml
@if (Model.HP > 50)
{
    <span class="badge bg-success">Healthy</span>
}
else if (Model.HP > 20)
{
    <span class="badge bg-warning">Wounded</span>
}
else
{
    <span class="badge bg-danger">Critical</span>
}
```

**For loops:**
```cshtml
<ul>
@for (int i = 0; i < 5; i++)
{
    <li>Pokemon #@(i + 1)</li>
}
</ul>
```

**Foreach loops:**
```cshtml
@foreach (var pokemon in Model)
{
    <div class="card">
        <h3>@pokemon.Name</h3>
        <p>@pokemon.Type</p>
    </div>
}
```

**While loops:**
```cshtml
@{
    int level = 1;
}
@while (level <= 10)
{
    <p>Level @level</p>
    level++;
}
```

**Switch statements:**
```cshtml
@switch (pokemon.Type)
{
    case "Fire":
        <span class="badge bg-danger">🔥 Fire</span>
        break;
    case "Water":
        <span class="badge bg-primary">💧 Water</span>
        break;
    case "Grass":
        <span class="badge bg-success">🌿 Grass</span>
        break;
    default:
        <span class="badge bg-secondary">@pokemon.Type</span>
        break;
}
```

#### Concept 8: Layout Pages

Layout pages provide consistent structure across multiple views.

**_Layout.cshtml (master template):**
```cshtml
<!DOCTYPE html>
<html>
<head>
    <title>@ViewData["Title"] - Pokemon App</title>
    <link rel="stylesheet" href="~/css/site.css" />
</head>
<body>
    <header>
        <nav><!-- Navigation menu --></nav>
    </header>

    <main>
        @RenderBody()  @* Content from individual views goes here *@
    </main>

    <footer>
        <p>&copy; 2026 Pokemon App</p>
    </footer>

    @await RenderSectionAsync("Scripts", required: false)
</body>
</html>
```

**Individual view using layout:**
```cshtml
@{
    ViewData["Title"] = "Home";
    Layout = "_Layout";  // Use this layout
}

<h1>Welcome to Pokemon App!</h1>
<p>This content goes into RenderBody()</p>

@section Scripts {
    <script src="~/js/home.js"></script>
}
```

**Result:** The view content is inserted into `@RenderBody()` location in the layout.

#### Concept 9: _ViewStart.cshtml

`_ViewStart.cshtml` runs before each view to set default values.

**Views/_ViewStart.cshtml:**
```cshtml
@{
    Layout = "_Layout";  // All views use this layout by default
}
```

Now you don't need to specify layout in every view!

**Override in specific view:**
```cshtml
@{
    Layout = "_AlternativeLayout";  // Use different layout
}
```

**Or no layout:**
```cshtml
@{
    Layout = null;  // No layout for this view
}
```

#### Concept 10: _ViewImports.cshtml

`_ViewImports.cshtml` imports namespaces and tag helpers for all views.

**Views/_ViewImports.cshtml:**
```cshtml
@using PokemonMvcApp
@using PokemonMvcApp.Models
@using PokemonMvcApp.ViewModels
@addTagHelper *, Microsoft.AspNetCore.Mvc.TagHelpers
```

Now you can use these namespaces without fully qualifying types:

```cshtml
@* Without _ViewImports ❌ *@
@model PokemonMvcApp.Models.Pokemon

@* With _ViewImports ✅ *@
@model Pokemon
```

#### Concept 11: Partial Views

Partial views are reusable view components.

**Create partial: Views/Shared/_PokemonCard.cshtml:**
```cshtml
@model Pokemon

<div class="card">
    <div class="card-body">
        <h5 class="card-title">@Model.Name</h5>
        <p class="card-text">
            Type: @Model.Type<br>
            Level: @Model.Level
        </p>
    </div>
</div>
```

**Use in main view:**
```cshtml
@model List<Pokemon>

<div class="row">
@foreach (var pokemon in Model)
{
    <div class="col-md-4">
        <partial name="_PokemonCard" model="pokemon" />
    </div>
}
</div>
```

**Or using tag helper:**
```cshtml
<partial name="_PokemonCard" model="pokemon" />
```

**Or using HTML helper:**
```cshtml
@await Html.PartialAsync("_PokemonCard", pokemon)
```

### Important Terminology

| Term | Definition |
|------|------------|
| **Razor** | Templating syntax for mixing C# with HTML |
| **@** | Symbol that switches from HTML to C# code |
| **@{ }** | Code block for multi-line C# statements |
| **@model** | Directive specifying the view's model type |
| **Model** | Property containing data passed from controller |
| **ViewData** | Dictionary for passing data to views |
| **ViewBag** | Dynamic wrapper around ViewData |
| **Layout** | Master page template used by multiple views |
| **_Layout.cshtml** | Default layout file name |
| **@RenderBody()** | Where view content is inserted in layout |
| **@RenderSection()** | Named section placeholder in layout |
| **_ViewStart.cshtml** | Runs before each view to set defaults |
| **_ViewImports.cshtml** | Imports namespaces for all views |
| **Partial View** | Reusable view component |
| **Tag Helper** | Server-side code that generates HTML |
| **Implicit Expression** | Razor automatically detecting HTML vs C# |
| **Explicit Expression** | Using @( ) to clarify expression boundaries |

### Architecture Overview

**How Razor processes a view:**

```
┌─────────────────┐
│   Controller    │
│                 │
│  return View(   │
│    model);      │
└────────┬────────┘
         │
         │ 1. Passes model to view
         │
         ▼
┌─────────────────────┐
│  Razor Engine       │
│  Processes .cshtml  │
└────────┬────────────┘
         │
         │ 2. Reads view file
         │
         ▼
┌─────────────────────┐
│  _ViewStart.cshtml  │
│  Sets defaults      │
└────────┬────────────┘
         │
         │ 3. Applies view start
         │
         ▼
┌─────────────────────┐
│  _Layout.cshtml     │
│  Master template    │
└────────┬────────────┘
         │
         │ 4. Processes layout
         │
         ▼
┌─────────────────────┐
│  View.cshtml        │
│  - Execute C# code  │
│  - Replace @ with   │
│    values           │
│  - Insert into      │
│    layout           │
└────────┬────────────┘
         │
         │ 5. Generated HTML
         │
         ▼
┌─────────────────────┐
│   Browser           │
│   Displays HTML     │
└─────────────────────┘
```

---

## 5. Installation Guide

### No Installation Required

Razor is built into ASP.NET Core MVC. When you create an MVC project, Razor support is automatic.

### Verify Razor Support

**Check 1: Create a test view**

Create `Views/Test/Razor.cshtml`:
```cshtml
<h1>Razor is working!</h1>
<p>Current time: @DateTime.Now</p>
```

**Check 2: Create controller action**
```csharp
public class TestController : Controller
{
    public IActionResult Razor()
    {
        return View();
    }
}
```

**Check 3: Run and test**
Navigate to `/Test/Razor` - you should see the time displayed.

### IDE Support for Razor

**Visual Studio:**
- Full IntelliSense for Razor syntax
- Syntax highlighting
- Auto-completion for tag helpers
- Built-in - no setup needed

**Visual Studio Code:**
1. Install "C# Dev Kit" extension
2. Install "ASP.NET Core Razor" extension (optional but recommended)
3. Restart VS Code
4. Open .cshtml file - should have syntax highlighting

**JetBrains Rider:**
- Full Razor support built-in
- Excellent IntelliSense and refactoring
- No additional setup needed

---

## 6. Initial Setup & Configuration

### Setting Up Views Folder Structure

Standard MVC project structure:

```
Views/
├── Home/                 # Views for HomeController
│   ├── Index.cshtml
│   ├── About.cshtml
│   └── Contact.cshtml
├── Pokemon/              # Views for PokemonController
│   ├── Index.cshtml
│   ├── Details.cshtml
│   └── Create.cshtml
├── Shared/               # Shared views and layouts
│   ├── _Layout.cshtml
│   ├── _LoginPartial.cshtml
│   └── Error.cshtml
├── _ViewStart.cshtml     # Runs before each view
└── _ViewImports.cshtml   # Imports for all views
```

### Configuring _ViewStart.cshtml

**Create Views/_ViewStart.cshtml:**
```cshtml
@{
    Layout = "_Layout";
}
```

This sets the default layout for all views.

**You can also set different layouts based on conditions:**
```cshtml
@{
    var area = ViewContext.RouteData.Values["area"]?.ToString();

    if (area == "Admin")
    {
        Layout = "_AdminLayout";
    }
    else
    {
        Layout = "_Layout";
    }
}
```

### Configuring _ViewImports.cshtml

**Create Views/_ViewImports.cshtml:**
```cshtml
@using PokemonMvcApp
@using PokemonMvcApp.Models
@using PokemonMvcApp.ViewModels
@using Microsoft.AspNetCore.Identity
@addTagHelper *, Microsoft.AspNetCore.Mvc.TagHelpers
```

**What each line does:**
- `@using` - Imports namespaces so you don't need full type names
- `@addTagHelper` - Enables tag helpers (asp-* attributes)

### Creating a Basic Layout

**Create Views/Shared/_Layout.cshtml:**
```cshtml
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>@ViewData["Title"] - Pokemon App</title>
    <link rel="stylesheet" href="~/lib/bootstrap/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="~/css/site.css" asp-append-version="true" />
</head>
<body>
    <header>
        <nav class="navbar navbar-expand-sm navbar-light bg-white border-bottom">
            <div class="container">
                <a class="navbar-brand" asp-controller="Home" asp-action="Index">Pokemon App</a>
                <ul class="navbar-nav flex-grow-1">
                    <li class="nav-item">
                        <a class="nav-link" asp-controller="Home" asp-action="Index">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" asp-controller="Pokemon" asp-action="Index">Pokemon</a>
                    </li>
                </ul>
            </div>
        </nav>
    </header>

    <div class="container">
        <main role="main" class="pb-3">
            @RenderBody()
        </main>
    </div>

    <footer class="border-top footer text-muted">
        <div class="container">
            &copy; 2026 - Pokemon App - <a asp-controller="Home" asp-action="Privacy">Privacy</a>
        </div>
    </footer>

    <script src="~/lib/jquery/dist/jquery.min.js"></script>
    <script src="~/lib/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="~/js/site.js" asp-append-version="true"></script>
    @await RenderSectionAsync("Scripts", required: false)
</body>
</html>
```

**Key parts:**
- `@ViewData["Title"]` - Page title from individual views
- `@RenderBody()` - Where view content goes
- `@await RenderSectionAsync("Scripts", required: false)` - Optional scripts section

---

## 7. Basic Usage

### Creating Your First View

**Step 1: Create controller action**

```csharp
// Controllers/PokemonController.cs
public class PokemonController : Controller
{
    public IActionResult Welcome()
    {
        return View();
    }
}
```

**Step 2: Create view file**

Create `Views/Pokemon/Welcome.cshtml`:
```cshtml
@{
    ViewData["Title"] = "Welcome";
}

<div class="text-center">
    <h1>Welcome to Pokemon World!</h1>
    <p>Start your journey to become a Pokemon Master!</p>
</div>
```

**Step 3: Run and test**

Navigate to `/Pokemon/Welcome`

### Using Variables in Razor

**Simple variables:**
```cshtml
@{
    var trainerName = "Ash";
    var pokemonCount = 6;
    var isChampion = true;
}

<h1>Trainer: @trainerName</h1>
<p>Pokemon: @pokemonCount</p>
<p>Champion: @(isChampion ? "Yes" : "No")</p>
```

**String interpolation:**
```cshtml
@{
    var name = "Pikachu";
    var level = 25;
}

<p>@($"{name} is level {level}")</p>
```

### Passing Data from Controller

**Method 1: ViewData**

**Controller:**
```csharp
public IActionResult Index()
{
    ViewData["Title"] = "Pokemon List";
    ViewData["Count"] = 151;
    return View();
}
```

**View:**
```cshtml
<h1>@ViewData["Title"]</h1>
<p>Total Pokemon: @ViewData["Count"]</p>
```

**Method 2: ViewBag**

**Controller:**
```csharp
public IActionResult Index()
{
    ViewBag.Title = "Pokemon List";
    ViewBag.Count = 151;
    return View();
}
```

**View:**
```cshtml
<h1>@ViewBag.Title</h1>
<p>Total Pokemon: @ViewBag.Count</p>
```

**Method 3: Strongly-Typed Model (Recommended)**

**Controller:**
```csharp
public IActionResult Details(int id)
{
    var pokemon = new Pokemon
    {
        Id = id,
        Name = "Pikachu",
        Type = "Electric",
        Level = 25
    };

    return View(pokemon);
}
```

**View:**
```cshtml
@model Pokemon

<h1>@Model.Name</h1>
<p>Type: @Model.Type</p>
<p>Level: @Model.Level</p>
```

### Loops in Razor

**Foreach loop:**
```cshtml
@model List<Pokemon>

<ul>
@foreach (var pokemon in Model)
{
    <li>@pokemon.Name - @pokemon.Type</li>
}
</ul>
```

**For loop:**
```cshtml
<ol>
@for (int i = 0; i < Model.Count; i++)
{
    <li>Pokemon @(i + 1): @Model[i].Name</li>
}
</ol>
```

**With index in foreach:**
```cshtml
@{
    int index = 1;
}
@foreach (var pokemon in Model)
{
    <p>@(index++). @pokemon.Name</p>
}
```

### Conditionals in Razor

**If-else:**
```cshtml
@if (Model.Level > 50)
{
    <span class="badge bg-success">Strong Pokemon!</span>
}
else if (Model.Level > 20)
{
    <span class="badge bg-warning">Average Pokemon</span>
}
else
{
    <span class="badge bg-secondary">Beginner Pokemon</span>
}
```

**Ternary operator:**
```cshtml
<p>Status: @(Model.HP > 0 ? "Alive" : "Fainted")</p>
```

**Null checking:**
```cshtml
@if (Model != null)
{
    <h1>@Model.Name</h1>
}
else
{
    <p>No Pokemon found.</p>
}

@* Or use null-conditional operator *@
<h1>@Model?.Name</h1>
```

### Working with Sections

**Define section in layout:**
```cshtml
@* In _Layout.cshtml *@
<head>
    @await RenderSectionAsync("Styles", required: false)
</head>
<body>
    @RenderBody()

    @await RenderSectionAsync("Scripts", required: false)
</body>
```

**Use section in view:**
```cshtml
@section Styles {
    <link rel="stylesheet" href="~/css/pokemon.css" />
}

<h1>Pokemon Content</h1>

@section Scripts {
    <script src="~/js/pokemon.js"></script>
}
```

---

## 8. Testing & Validation

### How to Test Razor Views

#### Method 1: Browser Testing

**Test rendering:**
1. Run application: `dotnet run`
2. Navigate to view in browser
3. Check if content displays correctly
4. Right-click → View Page Source to see generated HTML

**Test with different data:**
```csharp
// Controller
public IActionResult Test(int level)
{
    var pokemon = new Pokemon { Level = level };
    return View(pokemon);
}
```

Test URLs:
- `/Pokemon/Test?level=5` - See output for level 5
- `/Pokemon/Test?level=50` - See output for level 50

#### Method 2: Check Generated HTML

**View source in browser:**
1. Right-click on page
2. Select "View Page Source"
3. Verify HTML structure is correct
4. Check if Razor code was properly converted to HTML

**Use browser DevTools:**
1. Press F12
2. Inspect elements
3. Verify classes and attributes
4. Check if data appears correctly

#### Method 3: Razor Compilation Check

**Build the project:**
```bash
dotnet build
```

Razor views are compiled. Any syntax errors will show up during build.

**Common errors to check:**
- Missing `@model` directive
- Unclosed braces `}`
- Missing semicolons in code blocks
- Type mismatches

### Hands-On Exercises

#### Exercise 1: Create a Dynamic Greeting (Beginner)

**Objective:** Use Razor to display dynamic content based on time of day

**Task:**
Create a view that displays different greetings based on the current hour:
- Morning (before 12): "Good Morning, Trainer!"
- Afternoon (12-18): "Good Afternoon, Trainer!"
- Evening (after 18): "Good Evening, Trainer!"

**Requirements:**
- Use `DateTime.Now.Hour` to get current hour
- Use `@if` statements for conditional rendering
- Display greeting in an `<h1>` tag
- Add a paragraph showing the current time

**Hints:**
- Get hour: `DateTime.Now.Hour`
- Format time: `DateTime.Now.ToString("HH:mm:ss")`
- Use `@if`, `else if`, `else`

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Create controller action**
```csharp
// Controllers/HomeController.cs
public IActionResult Greeting()
{
    return View();
}
```

**Step 2: Create Views/Home/Greeting.cshtml**
```cshtml
@{
    ViewData["Title"] = "Greeting";
    var currentHour = DateTime.Now.Hour;
    string greeting;

    if (currentHour < 12)
    {
        greeting = "Good Morning, Trainer!";
    }
    else if (currentHour < 18)
    {
        greeting = "Good Afternoon, Trainer!";
    }
    else
    {
        greeting = "Good Evening, Trainer!";
    }
}

<div class="text-center">
    <h1>@greeting</h1>
    <p class="lead">Current time: @DateTime.Now.ToString("HH:mm:ss")</p>

    @if (currentHour >= 22 || currentHour < 6)
    {
        <div class="alert alert-info">
            It's late! Pokemon are sleeping. Come back tomorrow!
        </div>
    }
    else
    {
        <div class="alert alert-success">
            Perfect time for Pokemon training!
        </div>
    }
</div>
```

**Step 3: Test**
- Navigate to `/Home/Greeting`
- Greeting should change based on time
- Reload page to see updated time
- Test at different times of day

</details>

---

#### Exercise 2: Display Pokemon List with Foreach (Intermediate)

**Objective:** Use foreach loop to display a list of Pokemon

**Task:**
Create a view that displays a list of Pokemon with the following:
- Pokemon name
- Type with colored badge
- Level with progress bar

**Requirements:**
- Create a `List<Pokemon>` in controller
- Pass list to view using strongly-typed model
- Use `@foreach` to loop through Pokemon
- Display each Pokemon in a Bootstrap card
- Use `@switch` or `@if` to color badges by type

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Ensure Pokemon model exists**
```csharp
// Models/Pokemon.cs
namespace PokemonMvcApp.Models
{
    public class Pokemon
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public int Level { get; set; }
        public int HP { get; set; }
    }
}
```

**Step 2: Create controller action**
```csharp
// Controllers/PokemonController.cs
using PokemonMvcApp.Models;

public class PokemonController : Controller
{
    public IActionResult Team()
    {
        var pokemonTeam = new List<Pokemon>
        {
            new Pokemon { Id = 1, Name = "Bulbasaur", Type = "Grass", Level = 15, HP = 45 },
            new Pokemon { Id = 25, Name = "Pikachu", Type = "Electric", Level = 25, HP = 35 },
            new Pokemon { Id = 6, Name = "Charizard", Type = "Fire", Level = 36, HP = 78 },
            new Pokemon { Id = 9, Name = "Blastoise", Type = "Water", Level = 36, HP = 79 },
            new Pokemon { Id = 94, Name = "Gengar", Type = "Ghost", Level = 45, HP = 60 },
            new Pokemon { Id = 149, Name = "Dragonite", Type = "Dragon", Level = 55, HP = 91 }
        };

        return View(pokemonTeam);
    }
}
```

**Step 3: Create Views/Pokemon/Team.cshtml**
```cshtml
@model List<Pokemon>

@{
    ViewData["Title"] = "My Pokemon Team";
}

<div class="container">
    <h1>My Pokemon Team</h1>
    <p class="lead">@Model.Count Pokemon in your team</p>

    <div class="row">
        @foreach (var pokemon in Model)
        {
            <div class="col-md-4 mb-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">@pokemon.Name</h5>

                        @* Type badge with color *@
                        @switch (pokemon.Type)
                        {
                            case "Fire":
                                <span class="badge bg-danger">🔥 Fire</span>
                                break;
                            case "Water":
                                <span class="badge bg-primary">💧 Water</span>
                                break;
                            case "Grass":
                                <span class="badge bg-success">🌿 Grass</span>
                                break;
                            case "Electric":
                                <span class="badge bg-warning">⚡ Electric</span>
                                break;
                            case "Ghost":
                                <span class="badge bg-dark">👻 Ghost</span>
                                break;
                            case "Dragon":
                                <span class="badge bg-info">🐉 Dragon</span>
                                break;
                            default:
                                <span class="badge bg-secondary">@pokemon.Type</span>
                                break;
                        }

                        <div class="mt-3">
                            <small class="text-muted">Level @pokemon.Level</small>
                            <div class="progress mt-1">
                                <div class="progress-bar"
                                     role="progressbar"
                                     style="width: @pokemon.Level%"
                                     aria-valuenow="@pokemon.Level"
                                     aria-valuemin="0"
                                     aria-valuemax="100">
                                    @pokemon.Level
                                </div>
                            </div>
                        </div>

                        <div class="mt-2">
                            <small class="text-muted">HP: @pokemon.HP</small>
                            <div class="progress mt-1">
                                <div class="progress-bar bg-danger"
                                     role="progressbar"
                                     style="width: @((pokemon.HP * 100 / 100))%">
                                    @pokemon.HP
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        }
    </div>
</div>
```

**Step 4: Test**
- Navigate to `/Pokemon/Team`
- Should see 6 Pokemon cards
- Each with colored type badge
- Level and HP progress bars
- Responsive layout (try resizing browser)

</details>

---

#### Exercise 3: Create Reusable Partial View (Challenge)

**Objective:** Create a reusable partial view for Pokemon cards

**Task:**
Refactor Exercise 2 to use a partial view:
1. Create `_PokemonCard.cshtml` partial view
2. Move card HTML into partial
3. Use partial in main view with `<partial>` tag
4. Create another page that also uses the same partial

**Requirements:**
- Partial should accept Pokemon model
- Partial should be in Shared folder
- Use partial from multiple views
- Demonstrate code reuse

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Create Views/Shared/_PokemonCard.cshtml**
```cshtml
@model Pokemon

<div class="card h-100">
    <div class="card-body">
        <h5 class="card-title">@Model.Name</h5>

        @* Type badge with color *@
        @{
            var badgeClass = Model.Type switch
            {
                "Fire" => "bg-danger",
                "Water" => "bg-primary",
                "Grass" => "bg-success",
                "Electric" => "bg-warning",
                "Ghost" => "bg-dark",
                "Dragon" => "bg-info",
                _ => "bg-secondary"
            };

            var emoji = Model.Type switch
            {
                "Fire" => "🔥",
                "Water" => "💧",
                "Grass" => "🌿",
                "Electric" => "⚡",
                "Ghost" => "👻",
                "Dragon" => "🐉",
                _ => ""
            };
        }

        <span class="badge @badgeClass">@emoji @Model.Type</span>

        <div class="mt-3">
            <small class="text-muted">Level @Model.Level</small>
            <div class="progress mt-1">
                <div class="progress-bar"
                     role="progressbar"
                     style="width: @Model.Level%">
                    @Model.Level
                </div>
            </div>
        </div>

        <div class="mt-2">
            <small class="text-muted">HP: @Model.HP</small>
            <div class="progress mt-1">
                <div class="progress-bar bg-danger"
                     role="progressbar"
                     style="width: @((Model.HP * 100 / 100))%">
                    @Model.HP
                </div>
            </div>
        </div>
    </div>
    <div class="card-footer">
        <a asp-controller="Pokemon" asp-action="Details" asp-route-id="@Model.Id"
           class="btn btn-sm btn-primary">
            View Details
        </a>
    </div>
</div>
```

**Step 2: Update Views/Pokemon/Team.cshtml to use partial**
```cshtml
@model List<Pokemon>

@{
    ViewData["Title"] = "My Pokemon Team";
}

<div class="container">
    <h1>My Pokemon Team</h1>
    <p class="lead">@Model.Count Pokemon in your team</p>

    <div class="row">
        @foreach (var pokemon in Model)
        {
            <div class="col-md-4 mb-4">
                <partial name="_PokemonCard" model="pokemon" />
            </div>
        }
    </div>
</div>
```

**Step 3: Create another view using the same partial - Views/Pokemon/Favorites.cshtml**
```cshtml
@model List<Pokemon>

@{
    ViewData["Title"] = "Favorite Pokemon";
}

<div class="container">
    <h1>⭐ Favorite Pokemon</h1>
    <p>Your top favorites!</p>

    <div class="row">
        @* Use same partial view *@
        @foreach (var pokemon in Model)
        {
            <div class="col-md-3 mb-3">
                <partial name="_PokemonCard" model="pokemon" />
            </div>
        }
    </div>
</div>
```

**Step 4: Add controller action**
```csharp
public IActionResult Favorites()
{
    var favorites = new List<Pokemon>
    {
        new Pokemon { Id = 25, Name = "Pikachu", Type = "Electric", Level = 50, HP = 35 },
        new Pokemon { Id = 6, Name = "Charizard", Type = "Fire", Level = 60, HP = 78 },
        new Pokemon { Id = 149, Name = "Dragonite", Type = "Dragon", Level = 55, HP = 91 },
        new Pokemon { Id = 150, Name = "Mewtwo", Type = "Psychic", Level = 70, HP = 106 }
    };

    return View(favorites);
}
```

**Step 5: Test**
- Navigate to `/Pokemon/Team` - See team with cards
- Navigate to `/Pokemon/Favorites` - See favorites with same cards
- Both pages use the same `_PokemonCard` partial
- If you update the partial, both pages update automatically!

**What you learned:**
- Creating reusable partial views
- Passing models to partials
- Using partials from multiple pages
- DRY principle (Don't Repeat Yourself)

</details>

---

### Self-Assessment Checklist

After completing this guide, you should be able to:

- [ ] Understand what Razor is and when to use it
- [ ] Use @ symbol to switch from HTML to C#
- [ ] Write code blocks with @{ }
- [ ] Output variables and expressions with @variable
- [ ] Use @( ) for explicit expressions
- [ ] Write Razor comments with @* *@
- [ ] Create strongly-typed views with @model
- [ ] Access model data with @Model
- [ ] Use control structures (@if, @foreach, @for, @switch)
- [ ] Create and use layout pages
- [ ] Understand @RenderBody() and @RenderSection()
- [ ] Use _ViewStart.cshtml to set defaults
- [ ] Import namespaces with _ViewImports.cshtml
- [ ] Create and use partial views
- [ ] Pass data with ViewData, ViewBag, and strongly-typed models
- [ ] Debug Razor views and check generated HTML

---

## 9. Practical Examples

### Example 1: Master-Detail View Pattern

**Scenario:** Display a list of Pokemon with expandable details

**Views/Pokemon/MasterDetail.cshtml:**
```cshtml
@model List<Pokemon>

@{
    ViewData["Title"] = "Pokemon Master-Detail";
}

<div class="container">
    <h1>Pokemon Collection</h1>

    <div class="row">
        <div class="col-md-4">
            <div class="list-group">
                @foreach (var pokemon in Model)
                {
                    <a href="#pokemon-@pokemon.Id"
                       class="list-group-item list-group-item-action"
                       data-bs-toggle="collapse">
                        @pokemon.Name
                        <span class="badge bg-primary float-end">Level @pokemon.Level</span>
                    </a>
                    <div id="pokemon-@pokemon.Id" class="collapse">
                        <div class="card">
                            <div class="card-body">
                                <dl class="row mb-0">
                                    <dt class="col-sm-4">Type</dt>
                                    <dd class="col-sm-8">@pokemon.Type</dd>

                                    <dt class="col-sm-4">Level</dt>
                                    <dd class="col-sm-8">@pokemon.Level</dd>

                                    <dt class="col-sm-4">HP</dt>
                                    <dd class="col-sm-8">@pokemon.HP</dd>
                                </dl>
                                <a asp-action="Details" asp-route-id="@pokemon.Id" class="btn btn-sm btn-primary">
                                    Full Details
                                </a>
                            </div>
                        </div>
                    </div>
                }
            </div>
        </div>

        <div class="col-md-8">
            <div class="alert alert-info">
                <strong>Tip:</strong> Click on a Pokemon name to see quick details, or click "Full Details" for complete information.
            </div>
        </div>
    </div>
</div>
```

---

### Example 2: Conditional Layout Based on User Type

**Scenario:** Use different layouts for regular users vs admin users

**Views/_ViewStart.cshtml:**
```cshtml
@{
    var isAdmin = User.IsInRole("Admin");

    if (isAdmin)
    {
        Layout = "_AdminLayout";
    }
    else
    {
        Layout = "_Layout";
    }
}
```

**Or set per-view:**
```cshtml
@{
    ViewData["Title"] = "Admin Dashboard";
    Layout = User.IsInRole("Admin") ? "_AdminLayout" : "_Layout";
}

@if (User.IsInRole("Admin"))
{
    <h1>Admin Dashboard</h1>
    <p>You have full access to manage Pokemon.</p>
}
else
{
    <h1>User Dashboard</h1>
    <p>View your Pokemon collection.</p>
}
```

---

### Example 3: Dynamic Table with Sorting

**Scenario:** Display Pokemon table with sortable columns

**Controller:**
```csharp
public IActionResult Table(string sortBy = "Name", string sortOrder = "asc")
{
    var pokemon = GetAllPokemon(); // Your data source

    pokemon = sortBy switch
    {
        "Level" => sortOrder == "asc" ? pokemon.OrderBy(p => p.Level).ToList() : pokemon.OrderByDescending(p => p.Level).ToList(),
        "Type" => sortOrder == "asc" ? pokemon.OrderBy(p => p.Type).ToList() : pokemon.OrderByDescending(p => p.Type).ToList(),
        _ => sortOrder == "asc" ? pokemon.OrderBy(p => p.Name).ToList() : pokemon.OrderByDescending(p => p.Name).ToList()
    };

    ViewBag.SortBy = sortBy;
    ViewBag.SortOrder = sortOrder;
    ViewBag.NextOrder = sortOrder == "asc" ? "desc" : "asc";

    return View(pokemon);
}
```

**View:**
```cshtml
@model List<Pokemon>

@{
    var sortBy = ViewBag.SortBy;
    var sortOrder = ViewBag.SortOrder;
    var nextOrder = ViewBag.NextOrder;
}

<table class="table table-striped">
    <thead>
        <tr>
            <th>
                <a asp-action="Table" asp-route-sortBy="Name" asp-route-sortOrder="@nextOrder">
                    Name
                    @if (sortBy == "Name")
                    {
                        <span>@(sortOrder == "asc" ? "▲" : "▼")</span>
                    }
                </a>
            </th>
            <th>
                <a asp-action="Table" asp-route-sortBy="Type" asp-route-sortOrder="@nextOrder">
                    Type
                    @if (sortBy == "Type")
                    {
                        <span>@(sortOrder == "asc" ? "▲" : "▼")</span>
                    }
                </a>
            </th>
            <th>
                <a asp-action="Table" asp-route-sortBy="Level" asp-route-sortOrder="@nextOrder">
                    Level
                    @if (sortBy == "Level")
                    {
                        <span>@(sortOrder == "asc" ? "▲" : "▼")</span>
                    }
                </a>
            </th>
        </tr>
    </thead>
    <tbody>
        @foreach (var pokemon in Model)
        {
            <tr>
                <td>@pokemon.Name</td>
                <td>@pokemon.Type</td>
                <td>@pokemon.Level</td>
            </tr>
        }
    </tbody>
</table>
```

---

## 10. Common Patterns & Best Practices

### Recommended Patterns

#### Pattern 1: Strongly-Typed Views

**Always prefer strongly-typed models over ViewData/ViewBag:**

```cshtml
@* Bad ❌ *@
<h1>@ViewData["PokemonName"]</h1>
<p>@ViewBag.PokemonType</p>

@* Good ✅ *@
@model Pokemon
<h1>@Model.Name</h1>
<p>@Model.Type</p>
```

**Benefits:** Type safety, IntelliSense, refactoring support, compile-time errors

#### Pattern 2: Null-Conditional Operator

**Use ?. to safely access potentially null properties:**

```cshtml
@* Without null check - might crash ❌ *@
<h1>@Model.Name</h1>

@* With traditional null check ✅ *@
@if (Model != null)
{
    <h1>@Model.Name</h1>
}

@* With null-conditional operator (best) ✅ *@
<h1>@Model?.Name</h1>

@* With null-coalescing operator ✅ *@
<h1>@(Model?.Name ?? "Unknown Pokemon")</h1>
```

#### Pattern 3: Extract Complex Logic to Helper Methods

**Don't put complex logic in views:**

```cshtml
@* Bad - complex logic in view ❌ *@
@{
    var color = pokemon.Type == "Fire" ? "red" : pokemon.Type == "Water" ? "blue" : pokemon.Type == "Grass" ? "green" : "gray";
}

@* Good - use helper method ✅ *@
@functions {
    string GetTypeColor(string type)
    {
        return type switch
        {
            "Fire" => "red",
            "Water" => "blue",
            "Grass" => "green",
            _ => "gray"
        };
    }
}

<div style="color: @GetTypeColor(pokemon.Type)">
```

**Or better - move to view model or service!**

#### Pattern 4: Use Partial Views for Reusable Components

**Extract repeated markup into partials:**

```cshtml
@* Bad - repeated code ❌ *@
@foreach (var pokemon in Model)
{
    <div class="card">
        <div class="card-body">
            <h5>@pokemon.Name</h5>
            <p>@pokemon.Type</p>
        </div>
    </div>
}

@* Good - use partial ✅ *@
@foreach (var pokemon in Model)
{
    <partial name="_PokemonCard" model="pokemon" />
}
```

### Do's and Don'ts

#### Do's

- ✅ **Use strongly-typed models with @model directive**
  ```cshtml
  @model Pokemon
  <h1>@Model.Name</h1>
  ```

- ✅ **Keep views focused on presentation**
  ```cshtml
  @* Good - simple display logic *@
  @if (Model.Level > 50)
  {
      <span class="badge bg-success">Strong!</span>
  }
  ```

- ✅ **Use layout pages for consistent structure**
  ```cshtml
  @* In _Layout.cshtml *@
  @RenderBody()
  ```

- ✅ **Extract repeated markup to partials**
  ```cshtml
  <partial name="_StatusBadge" model="pokemon.Status" />
  ```

- ✅ **Use null-conditional operators**
  ```cshtml
  <p>@Model?.Name</p>
  ```

- ✅ **Keep Razor code readable with proper indentation**
  ```cshtml
  @if (condition)
  {
      <div>
          <p>Properly indented</p>
      </div>
  }
  ```

#### Don'ts

- ❌ **Don't put business logic in views**
  ```cshtml
  @* Bad - database access in view ❌ *@
  @{
      using var db = new PokemonContext();
      var pokemon = db.Pokemon.ToList();
  }

  @* Good - receive data from controller ✅ *@
  @model List<Pokemon>
  ```

- ❌ **Don't use ViewData/ViewBag for complex data**
  ```cshtml
  @* Bad ❌ *@
  @ViewBag.ComplexObject.Property.SubProperty

  @* Good ✅ *@
  @model ComplexViewModel
  @Model.Property.SubProperty
  ```

- ❌ **Don't forget to escape user input**
  ```cshtml
  @* Bad - XSS vulnerability ❌ *@
  @Html.Raw(Model.UserInput)

  @* Good - automatic escaping ✅ *@
  @Model.UserInput
  ```

- ❌ **Don't create large code blocks in views**
  ```cshtml
  @* Bad - too much logic ❌ *@
  @{
      // 50 lines of complex logic
  }

  @* Good - move to controller or service ✅ *@
  ```

- ❌ **Don't repeat layout code in every view**
  ```cshtml
  @* Bad ❌ *@
  <!DOCTYPE html><html>...

  @* Good - use _Layout.cshtml ✅ *@
  @{
      Layout = "_Layout";
  }
  ```

### View Organization Best Practices

**Recommended folder structure:**
```
Views/
├── Shared/
│   ├── _Layout.cshtml
│   ├── _PokemonCard.cshtml      # Reusable components
│   ├── _StatusBadge.cshtml
│   └── Error.cshtml
├── Pokemon/
│   ├── Index.cshtml
│   ├── Details.cshtml
│   ├── Create.cshtml
│   └── _PokemonForm.cshtml       # Partial used by Create/Edit
├── Home/
│   ├── Index.cshtml
│   └── About.cshtml
├── _ViewStart.cshtml
└── _ViewImports.cshtml
```

---

## 11. Troubleshooting & Common Issues

### Frequently Encountered Problems

#### Problem 1: "The model item passed is of type X but this view requires type Y"

**Symptoms:**
- Runtime error when view loads
- Error message about model type mismatch

**Cause:**
- Controller passes wrong model type
- View's @model directive doesn't match passed model

**Solution:**

**Check 1: Verify @model matches what controller sends**

```csharp
// Controller
public IActionResult Details()
{
    var pokemon = new Pokemon();  // Single Pokemon
    return View(pokemon);
}
```

```cshtml
@* View must match ✅ *@
@model Pokemon

@* Wrong ❌ *@
@model List<Pokemon>
```

**Check 2: For collections, ensure list type matches**

```csharp
// Controller
return View(pokemonList);  // List<Pokemon>
```

```cshtml
@* Correct ✅ *@
@model List<Pokemon>

@* Wrong ❌ *@
@model IEnumerable<Pokemon>  @* Unless controller sends IEnumerable *@
```

---

#### Problem 2: Syntax error in Razor view

**Symptoms:**
- Compilation error
- Yellow underlines in editor
- Build fails with CS error codes

**Cause:**
- Missing closing brace
- Incorrect @ usage
- C# syntax errors in code blocks

**Solution:**

**Check 1: Balance braces**
```cshtml
@* Wrong ❌ *@
@if (condition)
{
    <p>Missing closing brace
}  @* Missing this! *@

@* Correct ✅ *@
@if (condition)
{
    <p>Properly closed</p>
}
```

**Check 2: Escape @ symbol in email addresses**
```cshtml
@* Wrong ❌ *@
<p>Email: user@example.com</p>  @* Razor thinks @example is code *@

@* Correct ✅ *@
<p>Email: user@@example.com</p>
```

**Check 3: Use @( ) for complex expressions**
```cshtml
@* Might fail ❌ *@
<p>@pokemon.Level * 2</p>

@* Correct ✅ *@
<p>@(pokemon.Level * 2)</p>
```

---

#### Problem 3: Partial view not found

**Symptoms:**
- Error: "The partial view 'X' was not found"
- View won't load

**Cause:**
- Partial view file doesn't exist
- Partial in wrong folder
- Incorrect partial name

**Solution:**

**Check 1: Verify partial exists in correct location**

For `<partial name="_PokemonCard" />`

Must be in one of:
- `Views/Shared/_PokemonCard.cshtml` ✅ (most common)
- `Views/[CurrentController]/_PokemonCard.cshtml` ✅
- `Pages/Shared/_PokemonCard.cshtml` (Razor Pages)

**Check 2: Use correct path**
```cshtml
@* Relative to Views/Shared/ or current controller folder *@
<partial name="_PokemonCard" />  ✅

@* Full path from Views root *@
<partial name="~/Views/Shared/_PokemonCard.cshtml" />  ✅

@* Wrong ❌ *@
<partial name="PokemonCard" />  @* Missing underscore *@
```

---

#### Problem 4: Model is null in view

**Symptoms:**
- NullReferenceException
- @Model.Property throws error
- Can't access model properties

**Cause:**
- Controller doesn't pass model
- Model passed is null
- Trying to access property of null model

**Solution:**

**Check 1: Controller actually passes model**
```csharp
// Wrong ❌
public IActionResult Details()
{
    return View();  // No model passed!
}

// Correct ✅
public IActionResult Details()
{
    var pokemon = GetPokemon();
    return View(pokemon);  // Model passed
}
```

**Check 2: Use null-conditional operators**
```cshtml
@* Might crash ❌ *@
<h1>@Model.Name</h1>

@* Safe ✅ *@
<h1>@(Model?.Name ?? "Unknown")</h1>

@* Or check for null ✅ *@
@if (Model != null)
{
    <h1>@Model.Name</h1>
}
else
{
    <p>No data available</p>
}
```

---

#### Problem 5: Section not rendering

**Symptoms:**
- Content in @section Scripts { } doesn't appear
- Scripts section seems ignored

**Cause:**
- Layout doesn't have @RenderSection
- Section name doesn't match
- Section marked as required but not provided

**Solution:**

**Check 1: Layout has RenderSection**
```cshtml
@* In _Layout.cshtml *@
@await RenderSectionAsync("Scripts", required: false)
```

**Check 2: Section name matches exactly**
```cshtml
@* In _Layout.cshtml *@
@await RenderSectionAsync("Scripts", required: false)

@* In view - must match exactly *@
@section Scripts {  @* Case-sensitive! *@
    <script src="~/js/app.js"></script>
}
```

**Check 3: Handle required sections**
```cshtml
@* Layout marks as required *@
@await RenderSectionAsync("RequiredSection", required: true)

@* View MUST provide it *@
@section RequiredSection {
    <div>Required content</div>
}
```

---

### Error Messages Explained

| Error Message | Meaning | Solution |
|---------------|---------|----------|
| `The model item passed is of type X but this view requires Y` | Model type mismatch | Check @model directive matches controller model |
| `'@' character can be used to escape '@' symbol` | @ in email/text treated as code | Use @@ to escape: user@@example.com |
| `The partial view 'X' was not found` | Partial doesn't exist or wrong path | Create partial in Views/Shared/ folder |
| `Object reference not set to an instance` | Model or property is null | Check controller passes model, use ?. operator |
| `Unexpected '{' character` | Unbalanced braces | Count opening and closing braces |
| `The name 'Model' does not exist` | Missing @model directive | Add @model directive at top of view |

---

## 12. Additional Resources

### Official Documentation

- [Razor Syntax Reference](https://docs.microsoft.com/aspnet/core/mvc/views/razor)
- [Views in ASP.NET Core MVC](https://docs.microsoft.com/aspnet/core/mvc/views/overview)
- [Partial Views](https://docs.microsoft.com/aspnet/core/mvc/views/partial)
- [Layout in ASP.NET Core](https://docs.microsoft.com/aspnet/core/mvc/views/layout)

### Recommended Tutorials

- [Microsoft Learn: Create views in ASP.NET Core](https://docs.microsoft.com/learn/modules/create-razor-pages-aspnet-core/)
- [Razor Pages Tutorial](https://docs.microsoft.com/aspnet/core/tutorials/razor-pages/)

### Books

- **Pro ASP.NET Core 7** by Adam Freeman - Chapter on Razor Views
- **ASP.NET Core in Action** by Andrew Lock - Detailed Razor coverage

### Next Steps

After mastering Razor views, continue with:

1. **Tag Helpers** - Learn ASP.NET Core tag helpers (asp-* attributes)
2. **View Components** - Build complex reusable components
3. **Model Binding and Validation** - Handle form input properly
4. **Razor Pages** - Alternative to MVC for simpler scenarios
5. **Blazor** - Build interactive UIs with C# instead of JavaScript

---

## Appendix

### Glossary

**Razor**: Templating syntax for mixing C# with HTML using @ symbol

**@**: Symbol that switches from HTML to C# code

**@{ }**: Code block for multi-line C# statements

**@model**: Directive declaring view's model type

**Model**: Property containing data passed from controller

**Layout**: Master page template providing consistent structure

**@RenderBody()**: Placeholder where view content is inserted in layout

**@RenderSection()**: Placeholder for optional/required sections in layout

**_ViewStart.cshtml**: File that runs before every view to set defaults

**_ViewImports.cshtml**: File that imports namespaces for all views

**Partial View**: Reusable view component that can be included in other views

**Implicit Expression**: Razor code that automatically switches to HTML when it sees tags

**Explicit Expression**: Using @( ) to clearly define expression boundaries

**Tag Helper**: Server-side code that participates in HTML generation

**ViewData**: Dictionary for passing data from controller to view

**ViewBag**: Dynamic wrapper around ViewData

**TempData**: Dictionary for passing data across requests

**Section**: Named content block that can be rendered by layout

---

## Razor Syntax Quick Reference

```cshtml
@* Comments *@
@* Single-line Razor comment *@
<!-- HTML comment (sent to browser) -->

@* Output *@
@variable                           @* Output variable *@
@expression                         @* Output expression *@
@(complexExpression)                @* Explicit expression *@
@DateTime.Now                       @* Call methods *@

@* Code Blocks *@
@{ var x = 10; }                   @* Single statement *@
@{                                 @* Multiple statements *@
    var x = 10;
    var y = 20;
}

@* Control Structures *@
@if (condition) { }                @* If statement *@
@if (condition) { } else { }       @* If-else *@
@if (x) { } else if (y) { } else { }

@foreach (var item in items) { }   @* Foreach loop *@
@for (int i = 0; i < 10; i++) { }  @* For loop *@
@while (condition) { }             @* While loop *@
@switch (value) { case x: break; } @* Switch statement *@

@* Strongly-Typed Views *@
@model Pokemon                     @* Declare model type *@
@Model.Property                    @* Access model property *@

@* Null Handling *@
@Model?.Property                   @* Null-conditional *@
@(Model?.Property ?? "default")   @* Null-coalescing *@

@* Layout *@
@{ Layout = "_Layout"; }           @* Set layout *@
@RenderBody()                      @* In layout: render view content *@
@section Scripts { }               @* Define section in view *@
@await RenderSectionAsync("Scripts", required: false)  @* In layout: render section *@

@* Partials *@
<partial name="_PartialName" />    @* Render partial (tag helper) *@
<partial name="_PartialName" model="data" />
@await Html.PartialAsync("_PartialName", model)  @* HTML helper *@

@* Escaping *@
@@                                 @* Escape @ symbol *@
user@@example.com                  @* Email with @ *@

@* Functions *@
@functions {
    public string GetColor(string type) {
        return type == "Fire" ? "red" : "blue";
    }
}
```

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-11-23 | Initial version - Complete Razor Views and Syntax documentation |

---

**Estimated Reading Time**: 65-70 minutes

**Prerequisites**: HTML basics, C# basics, MVC Controllers knowledge

**What's Next**: After completing this guide, proceed to [Tag Helpers](tag-helpers.md), [View Components](view-components.md), and [Model Binding and Validation](model-binding-validation.md).
