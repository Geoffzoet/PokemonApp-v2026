# MVC Controllers

---
**Technology Version**: .NET 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-23
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What is an MVC Controller?

An MVC Controller is a C# class that handles incoming HTTP requests in an ASP.NET Core MVC application. It's the "C" in MVC - the coordinator that receives requests, processes data, and decides what to show to the user. Controllers contain action methods that respond to specific URLs and return views, redirect to other actions, or send data back to the client.

Think of a controller as a restaurant server. When a customer (browser) makes a request (clicks a link), the server (controller) takes the order, coordinates with the kitchen (services/models), and brings back what the customer needs (view with data). The server decides what happens based on what was requested.

### Why Use Controllers?

Controllers are essential in MVC applications because they:

- **Handle incoming requests** - Every URL request goes through a controller action
- **Coordinate application flow** - Controllers decide what happens next (show view, redirect, return error)
- **Process user input** - Form submissions and query parameters are received by controllers
- **Pass data to views** - Controllers prepare and send data to views for display
- **Keep views clean** - Business logic stays in controllers/services, not in views
- **Provide organization** - Group related actions together (all Pokemon actions in PokemonController)

### When to Use Controllers

**Use MVC Controllers when:**
- Building traditional web applications with server-rendered pages
- You need to return HTML views to browsers
- Creating user-facing websites (blogs, e-commerce, dashboards)
- Building forms that submit data and return new pages
- You want to integrate views and backend logic tightly

**Use API Controllers instead when:**
- Building RESTful APIs that return JSON/XML
- Creating backend services for mobile apps or SPAs
- You only need to send data, not HTML pages
- Building microservices

---

## 2. Quick Start

**TL;DR - Create your first controller in 2 minutes:**

**Step 1: Create a controller class**

```csharp
// Controllers/PokemonController.cs
using Microsoft.AspNetCore.Mvc;

namespace PokemonMvcApp.Controllers
{
    public class PokemonController : Controller
    {
        // Action method - handles GET /Pokemon/Index
        public IActionResult Index()
        {
            return View();
        }

        // Action method - handles GET /Pokemon/Details/5
        public IActionResult Details(int id)
        {
            ViewData["PokemonId"] = id;
            return View();
        }
    }
}
```

**Step 2: Create corresponding views**

Create `Views/Pokemon/Index.cshtml`:
```cshtml
<h1>Pokemon List</h1>
<p>Welcome to the Pokemon page!</p>
```

**Step 3: Run and test**

Navigate to `https://localhost:5001/Pokemon/Index` and see your page!

For detailed explanations, continue reading the sections below.

---

## 3. Prerequisites

### Required Knowledge

- **C# basics** - Classes, methods, access modifiers. You should understand object-oriented programming fundamentals.
- **MVC pattern understanding** - What Model, View, Controller mean and how they interact.
- **HTTP basics** - GET vs POST, what URLs are, how browsers make requests.
- **MVC project structure** - Understanding of the project layout (Controllers/, Views/ folders).

### Required Software/Tools

- **.NET SDK** - Version 8.0 or higher
- **Code Editor** - Visual Studio, VS Code, or Rider
- **Existing MVC Project** - You should have created an MVC project (see "Creating an MVC Project" guide)

### System Requirements

- **Operating System**: Windows 10+, macOS 11+, or modern Linux
- **RAM**: 4GB minimum (8GB recommended)
- **Disk Space**: 500MB free for project files

---

## 4. Core Concepts & Theory

### Key Concepts

#### Concept 1: Controller Class Structure

A controller is a C# class that inherits from `Controller` base class and contains action methods.

**Basic structure:**
```csharp
using Microsoft.AspNetCore.Mvc;

namespace YourApp.Controllers
{
    // Class name must end with "Controller"
    public class HomeController : Controller
    {
        // Action methods go here
        public IActionResult Index()
        {
            return View();
        }
    }
}
```

**Key points:**
- Class name MUST end with "Controller" (HomeController, PokemonController)
- Must inherit from `Controller` class
- Located in the `Controllers/` folder
- Public methods are action methods (unless marked with `[NonAction]`)

#### Concept 2: Controller vs ControllerBase

There are two base classes you can inherit from:

| Feature | Controller | ControllerBase |
|---------|------------|----------------|
| **Purpose** | MVC views | Web APIs |
| **Returns** | Views (HTML) | Data (JSON/XML) |
| **Has View() method** | ✅ Yes | ❌ No |
| **Has helper methods** | ViewData, ViewBag, View() | Json(), Ok(), NotFound() |
| **Use for** | Traditional web apps | RESTful APIs |

**MVC Controller (returns views):**
```csharp
public class PokemonController : Controller  // Note: Controller
{
    public IActionResult Index()
    {
        return View();  // Returns HTML view
    }
}
```

**API Controller (returns data):**
```csharp
[ApiController]
[Route("api/[controller]")]
public class PokemonApiController : ControllerBase  // Note: ControllerBase
{
    [HttpGet]
    public IActionResult GetAll()
    {
        return Ok(pokemonList);  // Returns JSON
    }
}
```

**When to use each:**
- Inherit from `Controller` for MVC (this guide)
- Inherit from `ControllerBase` for Web APIs

#### Concept 3: Action Methods

Action methods are public methods in a controller that handle HTTP requests and return results.

**Basic action method:**
```csharp
public IActionResult Index()
{
    return View();
}
```

**What makes a method an action:**
- ✅ Public visibility
- ✅ Returns `IActionResult` or derived type
- ✅ Not marked with `[NonAction]` attribute
- ✅ Not an override, operator, or property

**Action method with parameters:**
```csharp
// Handles: /Pokemon/Details/25
public IActionResult Details(int id)
{
    // id comes from URL route parameter
    return View();
}

// Handles: /Pokemon/Search?name=pikachu
public IActionResult Search(string name)
{
    // name comes from query string
    return View();
}
```

**Method that's NOT an action:**
```csharp
[NonAction]
public string HelperMethod()
{
    // This is just a helper, not accessible via URL
    return "Helper data";
}

private IActionResult PrivateMethod()
{
    // Not an action - private methods aren't actions
    return View();
}
```

#### Concept 4: Action Results

Action methods return types derived from `IActionResult` or `ActionResult<T>`.

**Common return types:**

| Type | Description | Example Usage |
|------|-------------|---------------|
| `ViewResult` | Returns a view | `return View();` |
| `RedirectResult` | Redirects to URL | `return Redirect("/Home/Index");` |
| `RedirectToActionResult` | Redirects to action | `return RedirectToAction("Index");` |
| `JsonResult` | Returns JSON | `return Json(data);` |
| `ContentResult` | Returns plain text | `return Content("Hello");` |
| `StatusCodeResult` | Returns HTTP status | `return NotFound();` |
| `PartialViewResult` | Returns partial view | `return PartialView();` |

**Using IActionResult (most flexible):**
```csharp
public IActionResult Details(int id)
{
    var pokemon = GetPokemon(id);

    if (pokemon == null)
    {
        return NotFound();  // Returns 404
    }

    return View(pokemon);  // Returns view with model
}
```

**Using specific result type:**
```csharp
public ViewResult Index()
{
    return View();  // Can only return views
}
```

**Recommendation:** Use `IActionResult` for flexibility unless you're certain you'll only return one type.

#### Concept 5: Passing Data to Views

There are three main ways to pass data from controller to view:

**Method 1: ViewData (Dictionary)**
```csharp
public IActionResult Index()
{
    ViewData["Title"] = "Pokemon List";
    ViewData["Count"] = 151;
    return View();
}
```

```cshtml
@* In view *@
<h1>@ViewData["Title"]</h1>
<p>Total: @ViewData["Count"]</p>
```

**Pros:** Simple, flexible
**Cons:** No type safety, keys are strings, easy to make typos

**Method 2: ViewBag (Dynamic)**
```csharp
public IActionResult Index()
{
    ViewBag.Title = "Pokemon List";
    ViewBag.Count = 151;
    return View();
}
```

```cshtml
@* In view *@
<h1>@ViewBag.Title</h1>
<p>Total: @ViewBag.Count</p>
```

**Pros:** Cleaner syntax than ViewData
**Cons:** No type safety, no IntelliSense, runtime errors if property doesn't exist

**Method 3: Strongly-Typed Model (Recommended)**
```csharp
public IActionResult Index()
{
    var pokemon = new Pokemon
    {
        Id = 25,
        Name = "Pikachu",
        Type = "Electric"
    };

    return View(pokemon);  // Pass model to view
}
```

```cshtml
@model Pokemon

<h1>@Model.Name</h1>
<p>Type: @Model.Type</p>
```

**Pros:** Type safety, IntelliSense, compile-time checking, best practice
**Cons:** Requires creating model classes

**When to use each:**
- **ViewData/ViewBag**: Simple data like page title, breadcrumbs, small flags
- **Strongly-typed models**: Any real data, always preferred when possible

#### Concept 6: URL Routing to Actions

ASP.NET Core maps URLs to controller actions using routing patterns.

**Default route pattern:**
```
{controller=Home}/{action=Index}/{id?}
```

**How URLs map to actions:**

| URL | Controller | Action | id |
|-----|------------|--------|-----|
| `/` | Home | Index | - |
| `/Home/Index` | Home | Index | - |
| `/Pokemon/List` | Pokemon | List | - |
| `/Pokemon/Details/25` | Pokemon | Details | 25 |
| `/Account/Login` | Account | Login | - |

**Example controller:**
```csharp
public class PokemonController : Controller
{
    // Handles: /Pokemon/Index and /Pokemon
    public IActionResult Index()
    {
        return View();
    }

    // Handles: /Pokemon/Details/25
    public IActionResult Details(int id)
    {
        // id = 25
        return View();
    }

    // Handles: /Pokemon/Search?name=pikachu&type=electric
    public IActionResult Search(string name, string type)
    {
        // name = "pikachu", type = "electric"
        return View();
    }
}
```

**Route parameter binding:**
- **Route parameters**: `/Pokemon/Details/25` → `id = 25`
- **Query string**: `/Pokemon/Search?name=pikachu` → `name = "pikachu"`
- **Form data**: Posted form values bind to parameters

#### Concept 7: RedirectToAction

`RedirectToAction` redirects the user to another action method.

**Basic redirect:**
```csharp
public IActionResult Create(Pokemon pokemon)
{
    // Save pokemon to database
    SavePokemon(pokemon);

    // Redirect to Index action in same controller
    return RedirectToAction("Index");
}
```

**Redirect to different controller:**
```csharp
public IActionResult Cancel()
{
    // Redirect to Index action in Home controller
    return RedirectToAction("Index", "Home");
}
```

**Redirect with route parameters:**
```csharp
public IActionResult Create(Pokemon pokemon)
{
    SavePokemon(pokemon);

    // Redirect to Details action with id parameter
    return RedirectToAction("Details", new { id = pokemon.Id });
    // Results in: /Pokemon/Details/25
}
```

**Why redirect after POST:**
```csharp
[HttpPost]
public IActionResult Create(Pokemon pokemon)
{
    if (ModelState.IsValid)
    {
        SavePokemon(pokemon);

        // Redirect to avoid double-submit if user refreshes
        return RedirectToAction("Details", new { id = pokemon.Id });
    }

    // If validation fails, return same form
    return View(pokemon);
}
```

This is the **Post-Redirect-Get (PRG)** pattern - prevents duplicate form submissions.

### Important Terminology

| Term | Definition |
|------|------------|
| **Controller** | Class that handles HTTP requests and coordinates responses |
| **Action Method** | Public method in controller that handles requests |
| **Action Result** | Return type from action method (ViewResult, RedirectResult, etc.) |
| **ViewData** | Dictionary for passing data from controller to view |
| **ViewBag** | Dynamic wrapper around ViewData |
| **Model** | Strongly-typed object passed to view |
| **Route Parameter** | Value from URL path (e.g., `/Pokemon/Details/25` → id=25) |
| **Query String** | Parameters after ? in URL (e.g., `?name=pikachu`) |
| **PRG Pattern** | Post-Redirect-Get - redirect after successful POST |
| **Model Binding** | Automatic mapping of request data to action parameters |
| **Action Filter** | Attribute that runs code before/after actions |

### Architecture Overview

**How a request flows through a controller:**

```
┌─────────────┐
│   Browser   │
│             │
└──────┬──────┘
       │
       │ 1. HTTP GET /Pokemon/Details/25
       │
       ▼
┌──────────────────────┐
│   Routing System     │
│  Matches URL pattern │
└──────┬───────────────┘
       │
       │ 2. Routes to PokemonController.Details(25)
       │
       ▼
┌──────────────────────┐
│  PokemonController   │
│                      │
│  public IActionResult│
│  Details(int id)     │
│  {                   │
│    // 3. Get data    │
│    var pokemon =     │
│      GetById(id);    │
│                      │
│    // 4. Return view │
│    return View(      │
│      pokemon);       │
│  }                   │
└──────┬───────────────┘
       │
       │ 5. Passes pokemon model to view engine
       │
       ▼
┌──────────────────────┐
│   View Engine        │
│  Renders view with   │
│  model data          │
└──────┬───────────────┘
       │
       │ 6. HTML response
       │
       ▼
┌──────────────────────┐
│     Browser          │
│  Displays HTML page  │
└──────────────────────┘
```

---

## 5. Installation Guide

### No Installation Required

Controllers are built into ASP.NET Core MVC. When you create an MVC project, controllers are ready to use.

### Creating Your First Controller

**Method 1: Using Visual Studio**

1. Right-click on `Controllers/` folder
2. Select "Add" → "Controller"
3. Choose "MVC Controller - Empty"
4. Name it `PokemonController`
5. Click "Add"

**Method 2: Using Command Line**

```bash
# Navigate to project directory
cd YourMvcProject

# Create Controllers directory if it doesn't exist
mkdir -p Controllers

# Create the controller file
touch Controllers/PokemonController.cs
```

**Method 3: Manual Creation**

Simply create a new C# file in the Controllers folder:

```csharp
// Controllers/PokemonController.cs
using Microsoft.AspNetCore.Mvc;

namespace PokemonMvcApp.Controllers
{
    public class PokemonController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
```

### Verify Controller Works

**Step 1: Create the controller**

Add `Controllers/TestController.cs`:
```csharp
using Microsoft.AspNetCore.Mvc;

namespace PokemonMvcApp.Controllers
{
    public class TestController : Controller
    {
        public IActionResult Index()
        {
            return Content("Controller is working!");
        }
    }
}
```

**Step 2: Run the application**
```bash
dotnet run
```

**Step 3: Test in browser**

Navigate to `https://localhost:5001/Test/Index`

You should see "Controller is working!" displayed.

---

## 6. Initial Setup & Configuration

### Setting Up a Controller with Dependencies

Controllers often need services injected via dependency injection.

**Step 1: Register services in Program.cs**

```csharp
var builder = WebApplication.CreateBuilder(args);

// Register services
builder.Services.AddControllersWithViews();
builder.Services.AddScoped<IPokemonService, PokemonService>();

var app = builder.Build();
```

**Step 2: Inject services into controller**

```csharp
public class PokemonController : Controller
{
    private readonly IPokemonService _pokemonService;
    private readonly ILogger<PokemonController> _logger;

    // Constructor injection
    public PokemonController(
        IPokemonService pokemonService,
        ILogger<PokemonController> logger)
    {
        _pokemonService = pokemonService;
        _logger = logger;
    }

    public IActionResult Index()
    {
        _logger.LogInformation("Index action called");
        var pokemon = _pokemonService.GetAll();
        return View(pokemon);
    }
}
```

### Configuring Controller Behavior

**Add filters globally (Program.cs):**

```csharp
builder.Services.AddControllersWithViews(options =>
{
    // Add global filters
    options.Filters.Add(new AutoValidateAntiforgeryTokenAttribute());
});
```

**Add filters to specific controllers:**

```csharp
[Authorize]  // Requires authentication for all actions
public class PokemonController : Controller
{
    [AllowAnonymous]  // Allow this action without auth
    public IActionResult Index()
    {
        return View();
    }

    public IActionResult Create()
    {
        // This requires authentication
        return View();
    }
}
```

### Common Controller Configuration Patterns

**Base controller for shared functionality:**

```csharp
// Controllers/BaseController.cs
public class BaseController : Controller
{
    protected string CurrentUsername => User.Identity?.Name ?? "Guest";

    protected IActionResult RedirectToHome()
    {
        return RedirectToAction("Index", "Home");
    }
}

// Use it
public class PokemonController : BaseController
{
    public IActionResult Index()
    {
        // Can use CurrentUsername property
        ViewBag.Username = CurrentUsername;
        return View();
    }
}
```

---

## 7. Basic Usage

### Creating a Simple Controller

**Step 1: Create the controller**

```csharp
// Controllers/PokemonController.cs
using Microsoft.AspNetCore.Mvc;

namespace PokemonMvcApp.Controllers
{
    public class PokemonController : Controller
    {
        // GET: /Pokemon
        public IActionResult Index()
        {
            return View();
        }

        // GET: /Pokemon/About
        public IActionResult About()
        {
            ViewData["Message"] = "Learn about Pokemon!";
            return View();
        }

        // GET: /Pokemon/Details/5
        public IActionResult Details(int id)
        {
            ViewData["PokemonId"] = id;
            return View();
        }
    }
}
```

**Step 2: Create corresponding views**

Create `Views/Pokemon/Index.cshtml`:
```cshtml
<h1>Pokemon List</h1>
<p>Welcome to the Pokemon section!</p>
```

Create `Views/Pokemon/About.cshtml`:
```cshtml
<h1>About Pokemon</h1>
<p>@ViewData["Message"]</p>
```

Create `Views/Pokemon/Details.cshtml`:
```cshtml
<h1>Pokemon Details</h1>
<p>Viewing Pokemon #@ViewData["PokemonId"]</p>
```

**Step 3: Test the actions**

- `/Pokemon` → Shows Index view
- `/Pokemon/About` → Shows About view with message
- `/Pokemon/Details/25` → Shows Details view with ID 25

### Returning Different Result Types

**Return a view:**
```csharp
public IActionResult Index()
{
    return View();
}
```

**Return a view with a model:**
```csharp
public IActionResult Details(int id)
{
    var pokemon = new Pokemon { Id = id, Name = "Pikachu" };
    return View(pokemon);
}
```

**Return specific view by name:**
```csharp
public IActionResult SpecialCase()
{
    // Returns Views/Pokemon/CustomView.cshtml
    return View("CustomView");
}
```

**Return a redirect:**
```csharp
public IActionResult GoToIndex()
{
    return RedirectToAction("Index");
}
```

**Return plain text:**
```csharp
public IActionResult GetText()
{
    return Content("This is plain text");
}
```

**Return JSON:**
```csharp
public IActionResult GetData()
{
    var data = new { Name = "Pikachu", Type = "Electric" };
    return Json(data);
}
```

**Return HTTP status codes:**
```csharp
public IActionResult CheckPokemon(int id)
{
    if (id > 151)
    {
        return NotFound();  // 404
    }

    if (id < 1)
    {
        return BadRequest();  // 400
    }

    return Ok();  // 200
}
```

### Handling Form Submissions

**GET action - display form:**
```csharp
// GET: /Pokemon/Create
public IActionResult Create()
{
    return View();
}
```

**POST action - process form:**
```csharp
// POST: /Pokemon/Create
[HttpPost]
public IActionResult Create(string name, string type, int level)
{
    // Process the data
    var pokemon = new Pokemon
    {
        Name = name,
        Type = type,
        Level = level
    };

    SavePokemon(pokemon);

    // Redirect after successful POST
    return RedirectToAction("Index");
}
```

**Using model binding:**
```csharp
[HttpPost]
public IActionResult Create(Pokemon pokemon)
{
    if (ModelState.IsValid)
    {
        SavePokemon(pokemon);
        return RedirectToAction("Details", new { id = pokemon.Id });
    }

    // If validation fails, return form with errors
    return View(pokemon);
}
```

### Working with Route Parameters

**Single parameter from URL:**
```csharp
// URL: /Pokemon/Details/25
public IActionResult Details(int id)
{
    // id = 25
    return View();
}
```

**Multiple parameters:**
```csharp
// URL: /Pokemon/Battle/25/94
public IActionResult Battle(int attackerId, int defenderId)
{
    // attackerId = 25, defenderId = 94
    return View();
}
```

**Optional parameters:**
```csharp
// URL: /Pokemon/Search or /Pokemon/Search/5
public IActionResult Search(int? page)
{
    // page is nullable, could be null
    int currentPage = page ?? 1;  // Default to 1 if null
    return View();
}
```

**Query string parameters:**
```csharp
// URL: /Pokemon/Filter?type=fire&level=10
public IActionResult Filter(string type, int level)
{
    // type = "fire", level = 10
    return View();
}
```

---

## 8. Testing & Validation

### How to Test Controller Actions

#### Method 1: Browser Testing

**Test simple actions:**

1. Run your application: `dotnet run`
2. Navigate to the action URL in browser
3. Verify expected result appears

**Test with parameters:**

```csharp
public IActionResult Details(int id)
{
    ViewData["Id"] = id;
    return Content($"Pokemon ID: {id}");
}
```

Test URLs:
- `https://localhost:5001/Pokemon/Details/1` → Shows "Pokemon ID: 1"
- `https://localhost:5001/Pokemon/Details/25` → Shows "Pokemon ID: 25"

#### Method 2: Unit Testing Controllers

**Create test project:**
```bash
dotnet new xunit -n PokemonMvcApp.Tests
cd PokemonMvcApp.Tests
dotnet add reference ../PokemonMvcApp/PokemonMvcApp.csproj
dotnet add package Moq
```

**Test controller action:**
```csharp
using Xunit;
using Microsoft.AspNetCore.Mvc;
using PokemonMvcApp.Controllers;

public class PokemonControllerTests
{
    [Fact]
    public void Index_ReturnsViewResult()
    {
        // Arrange
        var controller = new PokemonController();

        // Act
        var result = controller.Index();

        // Assert
        Assert.IsType<ViewResult>(result);
    }

    [Fact]
    public void Details_WithValidId_ReturnsViewResult()
    {
        // Arrange
        var controller = new PokemonController();

        // Act
        var result = controller.Details(25);

        // Assert
        var viewResult = Assert.IsType<ViewResult>(result);
        Assert.NotNull(viewResult.Model);
    }
}
```

### Common Validation Checks

**Check 1: Action returns correct result type**
```csharp
var result = controller.Index();
Assert.IsType<ViewResult>(result);
```

**Check 2: Redirect goes to correct action**
```csharp
var result = controller.Create(pokemon) as RedirectToActionResult;
Assert.Equal("Index", result.ActionName);
```

**Check 3: Model is passed to view**
```csharp
var viewResult = controller.Details(1) as ViewResult;
var model = Assert.IsType<Pokemon>(viewResult.Model);
Assert.Equal("Bulbasaur", model.Name);
```

**Check 4: ViewData contains expected values**
```csharp
controller.Index();
Assert.Equal("Pokemon List", controller.ViewData["Title"]);
```

### Hands-On Exercises

#### Exercise 1: Create a Basic Controller (Beginner)

**Objective:** Create a controller with multiple actions

**Task:**
Create a `TrainerController` with three actions:
1. `Index()` - Shows list of trainers
2. `Profile(int id)` - Shows trainer profile with ID
3. `Stats()` - Shows trainer statistics

**Requirements:**
- Each action should return a view
- Profile action should pass the ID to the view using ViewData
- Stats action should pass fake statistics using ViewBag

**Hints:**
- Controller class name must end with "Controller"
- Create corresponding views in Views/Trainer/ folder
- Use `ViewData["Key"] = value` and `ViewBag.Property = value`

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Create Controllers/TrainerController.cs:**
```csharp
using Microsoft.AspNetCore.Mvc;

namespace PokemonMvcApp.Controllers
{
    public class TrainerController : Controller
    {
        // GET: /Trainer
        public IActionResult Index()
        {
            return View();
        }

        // GET: /Trainer/Profile/5
        public IActionResult Profile(int id)
        {
            ViewData["TrainerId"] = id;
            ViewData["TrainerName"] = $"Trainer #{id}";
            return View();
        }

        // GET: /Trainer/Stats
        public IActionResult Stats()
        {
            ViewBag.TotalTrainers = 42;
            ViewBag.ActiveTrainers = 38;
            ViewBag.TotalBadges = 156;
            return View();
        }
    }
}
```

**Step 2: Create Views/Trainer/Index.cshtml:**
```cshtml
@{
    ViewData["Title"] = "Trainers";
}

<div class="container">
    <h1>Pokemon Trainers</h1>
    <p>Welcome to the trainers section!</p>

    <div class="mt-3">
        <a asp-action="Profile" asp-route-id="1" class="btn btn-primary">View Trainer #1</a>
        <a asp-action="Profile" asp-route-id="2" class="btn btn-primary">View Trainer #2</a>
        <a asp-action="Stats" class="btn btn-info">View Stats</a>
    </div>
</div>
```

**Step 3: Create Views/Trainer/Profile.cshtml:**
```cshtml
@{
    ViewData["Title"] = "Trainer Profile";
}

<div class="container">
    <h1>@ViewData["TrainerName"]</h1>

    <div class="card mt-3">
        <div class="card-body">
            <p><strong>Trainer ID:</strong> @ViewData["TrainerId"]</p>
            <p><strong>Badges:</strong> 5</p>
            <p><strong>Pokemon Caught:</strong> 73</p>
        </div>
    </div>

    <div class="mt-3">
        <a asp-action="Index" class="btn btn-secondary">Back to List</a>
    </div>
</div>
```

**Step 4: Create Views/Trainer/Stats.cshtml:**
```cshtml
@{
    ViewData["Title"] = "Trainer Statistics";
}

<div class="container">
    <h1>Trainer Statistics</h1>

    <div class="row mt-4">
        <div class="col-md-4">
            <div class="card text-center">
                <div class="card-body">
                    <h2 class="display-4">@ViewBag.TotalTrainers</h2>
                    <p>Total Trainers</p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card text-center">
                <div class="card-body">
                    <h2 class="display-4">@ViewBag.ActiveTrainers</h2>
                    <p>Active Trainers</p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card text-center">
                <div class="card-body">
                    <h2 class="display-4">@ViewBag.TotalBadges</h2>
                    <p>Total Badges Earned</p>
                </div>
            </div>
        </div>
    </div>

    <div class="mt-3">
        <a asp-action="Index" class="btn btn-secondary">Back to List</a>
    </div>
</div>
```

**Step 5: Test:**
- Navigate to `/Trainer` - See list
- Click "View Trainer #1" - See profile with ID 1
- Navigate to `/Trainer/Stats` - See statistics

</details>

---

#### Exercise 2: Strongly-Typed Models (Intermediate)

**Objective:** Use strongly-typed models instead of ViewData/ViewBag

**Task:**
Enhance the Pokemon controller to use a Pokemon model class:
1. Create a `Pokemon` model class
2. Update `Details` action to pass Pokemon model to view
3. Update view to use `@model` directive

**Requirements:**
- Pokemon model should have: Id, Name, Type, Level, HP
- Controller should create a Pokemon object and pass to view
- View should display all Pokemon properties using Model

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Create Models/Pokemon.cs:**
```csharp
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

**Step 2: Update Controllers/PokemonController.cs:**
```csharp
using Microsoft.AspNetCore.Mvc;
using PokemonMvcApp.Models;

namespace PokemonMvcApp.Controllers
{
    public class PokemonController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        // Updated to use strongly-typed model
        public IActionResult Details(int id)
        {
            // Create Pokemon object based on ID
            var pokemon = GetPokemonById(id);

            if (pokemon == null)
            {
                return NotFound();
            }

            return View(pokemon);  // Pass model to view
        }

        // Helper method (would normally query database)
        private Pokemon GetPokemonById(int id)
        {
            // Fake data - in real app, query database
            var allPokemon = new[]
            {
                new Pokemon { Id = 1, Name = "Bulbasaur", Type = "Grass", Level = 5, HP = 45 },
                new Pokemon { Id = 25, Name = "Pikachu", Type = "Electric", Level = 10, HP = 35 },
                new Pokemon { Id = 94, Name = "Gengar", Type = "Ghost", Level = 25, HP = 60 }
            };

            return allPokemon.FirstOrDefault(p => p.Id == id);
        }
    }
}
```

**Step 3: Update Views/Pokemon/Details.cshtml:**
```cshtml
@model PokemonMvcApp.Models.Pokemon

@{
    ViewData["Title"] = Model.Name;
}

<div class="container">
    <h1>@Model.Name</h1>

    <div class="card mt-3">
        <div class="card-header bg-primary text-white">
            <h3>Pokemon Details</h3>
        </div>
        <div class="card-body">
            <dl class="row">
                <dt class="col-sm-3">ID</dt>
                <dd class="col-sm-9">@Model.Id</dd>

                <dt class="col-sm-3">Name</dt>
                <dd class="col-sm-9">@Model.Name</dd>

                <dt class="col-sm-3">Type</dt>
                <dd class="col-sm-9">
                    <span class="badge bg-info">@Model.Type</span>
                </dd>

                <dt class="col-sm-3">Level</dt>
                <dd class="col-sm-9">@Model.Level</dd>

                <dt class="col-sm-3">HP</dt>
                <dd class="col-sm-9">
                    <div class="progress">
                        <div class="progress-bar bg-danger" style="width: @((Model.HP * 100 / 100))%">
                            @Model.HP
                        </div>
                    </div>
                </dd>
            </dl>
        </div>
    </div>

    <div class="mt-3">
        <a asp-action="Index" class="btn btn-secondary">Back to List</a>
    </div>
</div>
```

**Step 4: Test:**
- Navigate to `/Pokemon/Details/1` - See Bulbasaur
- Navigate to `/Pokemon/Details/25` - See Pikachu
- Navigate to `/Pokemon/Details/94` - See Gengar
- Navigate to `/Pokemon/Details/999` - See 404 Not Found

</details>

---

#### Exercise 3: Form Handling with POST (Challenge)

**Objective:** Handle form submission with GET and POST actions

**Task:**
Create a form to add new Pokemon:
1. GET action displays empty form
2. POST action receives form data
3. After successful save, redirect to Index
4. Display new Pokemon in list

**Requirements:**
- Use `[HttpPost]` attribute for POST action
- Use model binding to receive form data
- Implement Post-Redirect-Get pattern
- Store Pokemon in a static list (fake database)

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Update Controllers/PokemonController.cs:**
```csharp
using Microsoft.AspNetCore.Mvc;
using PokemonMvcApp.Models;

namespace PokemonMvcApp.Controllers
{
    public class PokemonController : Controller
    {
        // Static list to simulate database
        private static List<Pokemon> _pokemonList = new List<Pokemon>
        {
            new Pokemon { Id = 1, Name = "Bulbasaur", Type = "Grass", Level = 5, HP = 45 },
            new Pokemon { Id = 25, Name = "Pikachu", Type = "Electric", Level = 10, HP = 35 },
            new Pokemon { Id = 94, Name = "Gengar", Type = "Ghost", Level = 25, HP = 60 }
        };

        // GET: /Pokemon
        public IActionResult Index()
        {
            return View(_pokemonList);
        }

        // GET: /Pokemon/Details/5
        public IActionResult Details(int id)
        {
            var pokemon = _pokemonList.FirstOrDefault(p => p.Id == id);

            if (pokemon == null)
            {
                return NotFound();
            }

            return View(pokemon);
        }

        // GET: /Pokemon/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: /Pokemon/Create
        [HttpPost]
        public IActionResult Create(Pokemon pokemon)
        {
            if (ModelState.IsValid)
            {
                // Generate new ID
                pokemon.Id = _pokemonList.Any() ? _pokemonList.Max(p => p.Id) + 1 : 1;

                // Add to list
                _pokemonList.Add(pokemon);

                // Redirect to Index (Post-Redirect-Get pattern)
                return RedirectToAction(nameof(Index));
            }

            // If validation fails, return form with errors
            return View(pokemon);
        }
    }
}
```

**Step 2: Update Views/Pokemon/Index.cshtml:**
```cshtml
@model List<PokemonMvcApp.Models.Pokemon>

@{
    ViewData["Title"] = "Pokemon List";
}

<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Pokemon List</h1>
        <a asp-action="Create" class="btn btn-success">Add New Pokemon</a>
    </div>

    <div class="row">
        @foreach (var pokemon in Model)
        {
            <div class="col-md-4 mb-3">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">@pokemon.Name</h5>
                        <p class="card-text">
                            <span class="badge bg-info">@pokemon.Type</span><br>
                            <strong>Level:</strong> @pokemon.Level<br>
                            <strong>HP:</strong> @pokemon.HP
                        </p>
                        <a asp-action="Details" asp-route-id="@pokemon.Id" class="btn btn-primary btn-sm">
                            View Details
                        </a>
                    </div>
                </div>
            </div>
        }
    </div>
</div>
```

**Step 3: Create Views/Pokemon/Create.cshtml:**
```cshtml
@model PokemonMvcApp.Models.Pokemon

@{
    ViewData["Title"] = "Create Pokemon";
}

<div class="container">
    <h1>Create New Pokemon</h1>

    <div class="row">
        <div class="col-md-6">
            <form asp-action="Create" method="post">
                <div class="form-group mb-3">
                    <label asp-for="Name" class="form-label"></label>
                    <input asp-for="Name" class="form-control" placeholder="Enter Pokemon name" />
                    <span asp-validation-for="Name" class="text-danger"></span>
                </div>

                <div class="form-group mb-3">
                    <label asp-for="Type" class="form-label"></label>
                    <select asp-for="Type" class="form-control">
                        <option value="">Select Type</option>
                        <option value="Grass">Grass</option>
                        <option value="Fire">Fire</option>
                        <option value="Water">Water</option>
                        <option value="Electric">Electric</option>
                        <option value="Psychic">Psychic</option>
                        <option value="Normal">Normal</option>
                        <option value="Ghost">Ghost</option>
                        <option value="Dragon">Dragon</option>
                    </select>
                    <span asp-validation-for="Type" class="text-danger"></span>
                </div>

                <div class="form-group mb-3">
                    <label asp-for="Level" class="form-label"></label>
                    <input asp-for="Level" type="number" class="form-control" min="1" max="100" />
                    <span asp-validation-for="Level" class="text-danger"></span>
                </div>

                <div class="form-group mb-3">
                    <label asp-for="HP" class="form-label"></label>
                    <input asp-for="HP" type="number" class="form-control" min="1" max="200" />
                    <span asp-validation-for="HP" class="text-danger"></span>
                </div>

                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Create Pokemon</button>
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

**Step 4: Test the complete flow:**
1. Navigate to `/Pokemon` - See list of 3 Pokemon
2. Click "Add New Pokemon"
3. Fill out form:
   - Name: Mewtwo
   - Type: Psychic
   - Level: 70
   - HP: 106
4. Click "Create Pokemon"
5. Should redirect to Index showing 4 Pokemon including Mewtwo
6. Click "View Details" on Mewtwo to verify data saved correctly

**What you learned:**
- GET action displays form
- POST action receives form data
- Model binding automatically maps form fields to object properties
- Post-Redirect-Get pattern prevents duplicate submissions
- RedirectToAction redirects after successful save

</details>

---

### Self-Assessment Checklist

After completing this guide, you should be able to:

- [ ] Create a controller class that inherits from Controller
- [ ] Understand the difference between Controller and ControllerBase
- [ ] Write action methods that respond to HTTP requests
- [ ] Return different types of results (ViewResult, RedirectToActionResult)
- [ ] Pass data to views using ViewData, ViewBag, and strongly-typed models
- [ ] Handle route parameters from URLs
- [ ] Handle query string parameters
- [ ] Create GET and POST action pairs for forms
- [ ] Use RedirectToAction to implement Post-Redirect-Get pattern
- [ ] Use [HttpPost] and [HttpGet] attributes
- [ ] Inject dependencies into controllers via constructor
- [ ] Test controller actions in browser
- [ ] Understand URL routing to controller actions

---

## 9. Practical Examples

### Example 1: Simple CRUD Controller (Complete)

**Scenario:** Build a complete CRUD controller for managing Pokemon

**Code:**

```csharp
using Microsoft.AspNetCore.Mvc;
using PokemonMvcApp.Models;

namespace PokemonMvcApp.Controllers
{
    public class PokemonController : Controller
    {
        // Fake database - in real app, use EF Core
        private static List<Pokemon> _pokemon = new List<Pokemon>
        {
            new Pokemon { Id = 1, Name = "Bulbasaur", Type = "Grass", Level = 5, HP = 45 },
            new Pokemon { Id = 25, Name = "Pikachu", Type = "Electric", Level = 10, HP = 35 }
        };

        // LIST: GET /Pokemon
        public IActionResult Index()
        {
            return View(_pokemon);
        }

        // DETAILS: GET /Pokemon/Details/5
        public IActionResult Details(int id)
        {
            var pokemon = _pokemon.FirstOrDefault(p => p.Id == id);
            if (pokemon == null)
                return NotFound();

            return View(pokemon);
        }

        // CREATE: GET /Pokemon/Create
        public IActionResult Create()
        {
            return View();
        }

        // CREATE: POST /Pokemon/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create(Pokemon pokemon)
        {
            if (ModelState.IsValid)
            {
                pokemon.Id = _pokemon.Max(p => p.Id) + 1;
                _pokemon.Add(pokemon);
                return RedirectToAction(nameof(Index));
            }
            return View(pokemon);
        }

        // EDIT: GET /Pokemon/Edit/5
        public IActionResult Edit(int id)
        {
            var pokemon = _pokemon.FirstOrDefault(p => p.Id == id);
            if (pokemon == null)
                return NotFound();

            return View(pokemon);
        }

        // EDIT: POST /Pokemon/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(int id, Pokemon pokemon)
        {
            if (id != pokemon.Id)
                return BadRequest();

            if (ModelState.IsValid)
            {
                var existing = _pokemon.FirstOrDefault(p => p.Id == id);
                if (existing == null)
                    return NotFound();

                existing.Name = pokemon.Name;
                existing.Type = pokemon.Type;
                existing.Level = pokemon.Level;
                existing.HP = pokemon.HP;

                return RedirectToAction(nameof(Index));
            }
            return View(pokemon);
        }

        // DELETE: GET /Pokemon/Delete/5
        public IActionResult Delete(int id)
        {
            var pokemon = _pokemon.FirstOrDefault(p => p.Id == id);
            if (pokemon == null)
                return NotFound();

            return View(pokemon);
        }

        // DELETE: POST /Pokemon/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public IActionResult DeleteConfirmed(int id)
        {
            var pokemon = _pokemon.FirstOrDefault(p => p.Id == id);
            if (pokemon != null)
            {
                _pokemon.Remove(pokemon);
            }
            return RedirectToAction(nameof(Index));
        }
    }
}
```

This shows the standard CRUD pattern used in MVC applications.

---

### Example 2: Controller with Service Layer

**Scenario:** Separate business logic into a service class

**PokemonService.cs:**
```csharp
public interface IPokemonService
{
    List<Pokemon> GetAll();
    Pokemon GetById(int id);
    void Add(Pokemon pokemon);
    void Update(Pokemon pokemon);
    void Delete(int id);
}

public class PokemonService : IPokemonService
{
    private static List<Pokemon> _pokemon = new List<Pokemon>
    {
        new Pokemon { Id = 1, Name = "Bulbasaur", Type = "Grass", Level = 5, HP = 45 }
    };

    public List<Pokemon> GetAll() => _pokemon;

    public Pokemon GetById(int id) => _pokemon.FirstOrDefault(p => p.Id == id);

    public void Add(Pokemon pokemon)
    {
        pokemon.Id = _pokemon.Any() ? _pokemon.Max(p => p.Id) + 1 : 1;
        _pokemon.Add(pokemon);
    }

    public void Update(Pokemon pokemon)
    {
        var existing = _pokemon.FirstOrDefault(p => p.Id == pokemon.Id);
        if (existing != null)
        {
            existing.Name = pokemon.Name;
            existing.Type = pokemon.Type;
            existing.Level = pokemon.Level;
            existing.HP = pokemon.HP;
        }
    }

    public void Delete(int id)
    {
        var pokemon = _pokemon.FirstOrDefault(p => p.Id == id);
        if (pokemon != null)
            _pokemon.Remove(pokemon);
    }
}
```

**Register service in Program.cs:**
```csharp
builder.Services.AddScoped<IPokemonService, PokemonService>();
```

**Controller using service:**
```csharp
public class PokemonController : Controller
{
    private readonly IPokemonService _pokemonService;

    public PokemonController(IPokemonService pokemonService)
    {
        _pokemonService = pokemonService;
    }

    public IActionResult Index()
    {
        var pokemon = _pokemonService.GetAll();
        return View(pokemon);
    }

    public IActionResult Details(int id)
    {
        var pokemon = _pokemonService.GetById(id);
        if (pokemon == null)
            return NotFound();

        return View(pokemon);
    }

    [HttpPost]
    public IActionResult Create(Pokemon pokemon)
    {
        if (ModelState.IsValid)
        {
            _pokemonService.Add(pokemon);
            return RedirectToAction(nameof(Index));
        }
        return View(pokemon);
    }
}
```

**Benefits:**
- Controller stays thin and focused
- Business logic is testable independently
- Easy to swap implementations
- Follows Single Responsibility Principle

---

### Example 3: Error Handling in Controllers

**Scenario:** Handle errors gracefully with try-catch and custom error pages

**Controller with error handling:**
```csharp
public class PokemonController : Controller
{
    private readonly IPokemonService _pokemonService;
    private readonly ILogger<PokemonController> _logger;

    public PokemonController(
        IPokemonService pokemonService,
        ILogger<PokemonController> logger)
    {
        _pokemonService = pokemonService;
        _logger = logger;
    }

    public IActionResult Details(int id)
    {
        try
        {
            var pokemon = _pokemonService.GetById(id);

            if (pokemon == null)
            {
                _logger.LogWarning("Pokemon with ID {Id} not found", id);
                return NotFound();
            }

            return View(pokemon);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving Pokemon {Id}", id);
            return RedirectToAction("Error", "Home");
        }
    }

    [HttpPost]
    public IActionResult Create(Pokemon pokemon)
    {
        try
        {
            if (!ModelState.IsValid)
            {
                return View(pokemon);
            }

            _pokemonService.Add(pokemon);

            TempData["SuccessMessage"] = $"{pokemon.Name} created successfully!";
            return RedirectToAction(nameof(Index));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating Pokemon");
            ModelState.AddModelError("", "An error occurred while creating the Pokemon. Please try again.");
            return View(pokemon);
        }
    }
}
```

**Display success message in view:**
```cshtml
@if (TempData["SuccessMessage"] != null)
{
    <div class="alert alert-success alert-dismissible fade show">
        @TempData["SuccessMessage"]
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
}
```

---

## 10. Common Patterns & Best Practices

### Recommended Patterns

#### Pattern 1: Post-Redirect-Get (PRG)

**Description:** After successfully processing a POST request, redirect to a GET action to prevent duplicate submissions.

**Without PRG (bad):**
```csharp
[HttpPost]
public IActionResult Create(Pokemon pokemon)
{
    SavePokemon(pokemon);
    return View("Success");  // ❌ If user refreshes, form resubmits!
}
```

**With PRG (good):**
```csharp
[HttpPost]
public IActionResult Create(Pokemon pokemon)
{
    SavePokemon(pokemon);
    return RedirectToAction("Details", new { id = pokemon.Id });  // ✅ Safe to refresh
}
```

#### Pattern 2: Repository Pattern

**Description:** Abstract data access into repository classes, keeping controllers focused on coordination.

**Good structure:**
```
Controllers/
  └── PokemonController.cs    (thin, delegates to service)
Services/
  └── PokemonService.cs       (business logic)
Repositories/
  └── PokemonRepository.cs    (data access)
Models/
  └── Pokemon.cs              (data model)
```

#### Pattern 3: Use ActionFilters for Cross-Cutting Concerns

**Description:** Use filters for logging, authentication, caching, etc.

```csharp
// Custom filter
public class LogActionFilter : IActionFilter
{
    private readonly ILogger<LogActionFilter> _logger;

    public LogActionFilter(ILogger<LogActionFilter> logger)
    {
        _logger = logger;
    }

    public void OnActionExecuting(ActionExecutingContext context)
    {
        _logger.LogInformation("Executing action: {ActionName}", context.ActionDescriptor.DisplayName);
    }

    public void OnActionExecuted(ActionExecutedContext context)
    {
        _logger.LogInformation("Executed action: {ActionName}", context.ActionDescriptor.DisplayName);
    }
}

// Apply to controller
[ServiceFilter(typeof(LogActionFilter))]
public class PokemonController : Controller
{
    // All actions will be logged
}
```

### Do's and Don'ts

#### Do's

- ✅ **Keep controllers thin - delegate to services**
  ```csharp
  // Good
  public IActionResult Index()
  {
      var pokemon = _pokemonService.GetAll();
      return View(pokemon);
  }

  // Bad - too much logic in controller
  public IActionResult Index()
  {
      using var connection = new SqlConnection(connectionString);
      var command = new SqlCommand("SELECT * FROM Pokemon", connection);
      // ... 50 lines of data access code
  }
  ```

- ✅ **Use strongly-typed models for views**
  ```csharp
  // Good
  return View(pokemon);

  // Bad
  ViewData["Pokemon"] = pokemon;
  ```

- ✅ **Return appropriate HTTP status codes**
  ```csharp
  if (pokemon == null)
      return NotFound();  // 404

  if (!ModelState.IsValid)
      return BadRequest(ModelState);  // 400
  ```

- ✅ **Use async/await for I/O operations**
  ```csharp
  public async Task<IActionResult> Index()
  {
      var pokemon = await _pokemonService.GetAllAsync();
      return View(pokemon);
  }
  ```

- ✅ **Validate input using model validation**
  ```csharp
  [HttpPost]
  public IActionResult Create(Pokemon pokemon)
  {
      if (!ModelState.IsValid)
      {
          return View(pokemon);
      }
      // Process valid data
  }
  ```

#### Don'ts

- ❌ **Don't put business logic in controllers**
  - **Instead:** Move to service classes

- ❌ **Don't access database directly in controllers**
  - **Instead:** Use repository or service layer

- ❌ **Don't return View() after POST without validation check**
  ```csharp
  // Bad
  [HttpPost]
  public IActionResult Create(Pokemon pokemon)
  {
      SavePokemon(pokemon);  // What if data is invalid?
      return RedirectToAction("Index");
  }

  // Good
  [HttpPost]
  public IActionResult Create(Pokemon pokemon)
  {
      if (ModelState.IsValid)
      {
          SavePokemon(pokemon);
          return RedirectToAction("Index");
      }
      return View(pokemon);  // Return form with errors
  }
  ```

- ❌ **Don't use magic strings for action/controller names**
  ```csharp
  // Bad
  return RedirectToAction("Index", "Home");

  // Good
  return RedirectToAction(nameof(Index), nameof(HomeController).Replace("Controller", ""));
  // Or even better
  return RedirectToAction(nameof(HomeController.Index), "Home");
  ```

- ❌ **Don't forget [ValidateAntiForgeryToken] on POST actions**
  ```csharp
  // Good
  [HttpPost]
  [ValidateAntiForgeryToken]
  public IActionResult Create(Pokemon pokemon)
  {
      // Protected against CSRF attacks
  }
  ```

### Controller Organization Best Practices

**Recommended order of members:**
```csharp
public class PokemonController : Controller
{
    // 1. Fields and properties
    private readonly IPokemonService _pokemonService;
    private readonly ILogger<PokemonController> _logger;

    // 2. Constructor
    public PokemonController(
        IPokemonService pokemonService,
        ILogger<PokemonController> logger)
    {
        _pokemonService = pokemonService;
        _logger = logger;
    }

    // 3. GET actions (read operations)
    public IActionResult Index() { }
    public IActionResult Details(int id) { }
    public IActionResult Create() { }
    public IActionResult Edit(int id) { }

    // 4. POST actions (write operations)
    [HttpPost]
    public IActionResult Create(Pokemon pokemon) { }

    [HttpPost]
    public IActionResult Edit(int id, Pokemon pokemon) { }

    // 5. Helper methods (private)
    [NonAction]
    private void LogPokemonAction(string action, int id) { }
}
```

---

## 11. Troubleshooting & Common Issues

### Frequently Encountered Problems

#### Problem 1: "No action matched the request"

**Symptoms:**
- 404 error
- Message: "No action method was found..."
- URL seems correct but doesn't work

**Cause:**
- Action method name doesn't match URL
- Action is private or marked with [NonAction]
- Route constraint doesn't match (e.g., expecting int but got string)

**Solution:**

**Check 1: Verify action is public**
```csharp
// Wrong ❌
private IActionResult Details(int id)

// Correct ✅
public IActionResult Details(int id)
```

**Check 2: Verify action name matches URL**
```csharp
// URL: /Pokemon/Details/5
// Action must be named "Details"
public IActionResult Details(int id)  // ✅ Matches
```

**Check 3: Check for [NonAction] attribute**
```csharp
[NonAction]  // ❌ This action won't be accessible via URL
public IActionResult Details(int id)
```

**Check 4: Verify parameter types match route**
```csharp
// URL: /Pokemon/Details/abc
public IActionResult Details(int id)  // ❌ "abc" can't convert to int

// Fix: Make parameter string or use route constraint
public IActionResult Details(string id)  // ✅ Works
```

---

#### Problem 2: "The view was not found"

**Symptoms:**
- 404 error
- Message: "The view 'Index' was not found"
- Action executes but can't find view

**Cause:**
- View file doesn't exist
- View is in wrong folder
- View name doesn't match action name

**Solution:**

**Check 1: Verify view file exists**

For action `Details` in `PokemonController`:
- Must be at: `Views/Pokemon/Details.cshtml`
- NOT: `Views/PokemonController/Details.cshtml`
- NOT: `Views/Pokemon/details.cshtml` (case matters on Linux)

**Check 2: Check view name in return statement**
```csharp
// If action is Details but you want different view
public IActionResult Details(int id)
{
    return View("CustomViewName");  // Looks for CustomViewName.cshtml
}
```

**Check 3: Verify folder structure**
```
Views/
  Pokemon/              ✅ Folder name matches controller (without "Controller")
    Index.cshtml
    Details.cshtml
```

---

#### Problem 3: Model is null in POST action

**Symptoms:**
- Form submits but model properties are null in controller
- ModelState.IsValid is false
- No data binding occurs

**Cause:**
- Form field names don't match model properties
- Missing `name` attributes in form inputs
- Model binding configuration issue

**Solution:**

**Check 1: Use tag helpers (recommended)**
```cshtml
@* Good - automatic name attributes ✅ *@
<input asp-for="Name" class="form-control" />

@* Bad - manual names might not match ❌ *@
<input name="pokemon_name" class="form-control" />
```

**Check 2: Verify form method is POST**
```cshtml
@* Correct ✅ *@
<form asp-action="Create" method="post">

@* Wrong ❌ *@
<form asp-action="Create" method="get">
```

**Check 3: Check parameter name matches model**
```csharp
// If model is Pokemon class
[HttpPost]
public IActionResult Create(Pokemon pokemon)  // ✅ Parameter name matches

// Form fields like <input asp-for="Name" /> will bind to pokemon.Name
```

**Check 4: Inspect form submission**
1. Open browser DevTools (F12)
2. Go to Network tab
3. Submit form
4. Click on the POST request
5. Check "Payload" or "Form Data" tab
6. Verify data is being sent

---

#### Problem 4: RedirectToAction doesn't work

**Symptoms:**
- After redirect, still on same page
- Redirect goes to wrong action
- 404 after redirect

**Cause:**
- Action/controller name is wrong
- Route parameters missing or incorrect
- Using View() instead of redirect

**Solution:**

**Check 1: Verify action name is correct**
```csharp
// Wrong ❌
return RedirectToAction("index");  // Case-sensitive on some servers

// Correct ✅
return RedirectToAction("Index");
// Or better
return RedirectToAction(nameof(Index));
```

**Check 2: Specify controller if redirecting to different controller**
```csharp
// Same controller ✅
return RedirectToAction("Index");

// Different controller ✅
return RedirectToAction("Index", "Home");
```

**Check 3: Pass route parameters correctly**
```csharp
// Wrong ❌
return RedirectToAction("Details", pokemon.Id);

// Correct ✅
return RedirectToAction("Details", new { id = pokemon.Id });
```

---

#### Problem 5: TempData is null after redirect

**Symptoms:**
- Set TempData in controller
- After redirect, TempData value is null
- Success message doesn't display

**Cause:**
- TempData not configured properly
- Trying to access TempData multiple times
- Session not configured

**Solution:**

**Check 1: Configure TempData in Program.cs**
```csharp
builder.Services.AddControllersWithViews();
builder.Services.AddSession();  // Required for TempData

var app = builder.Build();
app.UseSession();  // Required middleware
```

**Check 2: Use TempData correctly**
```csharp
// Set in controller
TempData["Message"] = "Pokemon created successfully!";
return RedirectToAction("Index");

// Access once in view
@if (TempData["Message"] != null)
{
    <div class="alert alert-success">@TempData["Message"]</div>
}
```

**Check 3: Use Peek or Keep for multiple accesses**
```csharp
// If you need to access multiple times
var message = TempData.Peek("Message");  // Doesn't remove
// Or
var message = TempData["Message"];
TempData.Keep("Message");  // Keep for next request
```

---

### Error Messages Explained

| Error Message | Meaning | Solution |
|---------------|---------|----------|
| `No action matched the request` | Action not found or inaccessible | Check action is public, name matches URL |
| `The view 'X' was not found` | View file missing or in wrong location | Create view in Views/[Controller]/ folder |
| `A public action method 'X' was not found` | Action doesn't exist or is private | Make action public, check spelling |
| `The model item passed is of type X but requires Y` | Wrong model type passed to view | Check view @model matches controller model |
| `Object reference not set to instance` | Null model or property | Check model is not null before passing to view |
| `Antiforgery token validation failed` | Missing or invalid CSRF token | Add `@Html.AntiForgeryToken()` in form |

---

## 12. Additional Resources

### Official Documentation

- [ASP.NET Core MVC Controllers](https://docs.microsoft.com/aspnet/core/mvc/controllers/actions)
- [Controller Action Return Types](https://docs.microsoft.com/aspnet/core/web-api/action-return-types)
- [Model Binding in ASP.NET Core](https://docs.microsoft.com/aspnet/core/mvc/models/model-binding)
- [Routing in ASP.NET Core](https://docs.microsoft.com/aspnet/core/fundamentals/routing)

### Recommended Tutorials

- [Microsoft Learn: Handle data in MVC apps](https://docs.microsoft.com/learn/modules/handle-data-in-mvc/)
- [Create web apps with ASP.NET Core for beginners](https://docs.microsoft.com/learn/paths/create-web-apps-with-aspnet-core/)

### Books

- **Pro ASP.NET Core 7** by Adam Freeman - Chapter on Controllers and Actions
- **ASP.NET Core in Action** by Andrew Lock - Detailed controller patterns

### Next Steps

After mastering controllers, continue with:

1. **Models and Validation** - Learn to create robust data models with validation
2. **Views and Razor** - Deep dive into view creation and Razor syntax
3. **Entity Framework Core** - Connect controllers to real databases
4. **Authentication and Authorization** - Secure your controller actions
5. **API Controllers** - Build RESTful APIs using ControllerBase

---

## Appendix

### Glossary

**Action Method**: Public method in a controller that handles HTTP requests

**Controller**: Class that coordinates between model and view, handles requests

**ControllerBase**: Base class for API controllers (no view support)

**Controller**: Base class for MVC controllers (with view support)

**Model Binding**: Automatic mapping of request data to action parameters

**ViewData**: Dictionary for passing data from controller to view

**ViewBag**: Dynamic wrapper around ViewData

**TempData**: Dictionary for passing data across requests (survives one redirect)

**ActionResult**: Base class for all action results (ViewResult, RedirectResult, etc.)

**IActionResult**: Interface for action results, most flexible return type

**Route Parameter**: Value from URL path segment ({id} in route)

**Query String**: Parameters after ? in URL (?name=value&type=electric)

**PRG Pattern**: Post-Redirect-Get - redirect after POST to prevent resubmission

**CSRF**: Cross-Site Request Forgery - attack prevented by anti-forgery tokens

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-11-23 | Initial version - Complete MVC Controllers documentation |

---

**Estimated Reading Time**: 50-55 minutes

**Prerequisites**: Creating an MVC Project, C# basics, HTTP fundamentals

**What's Next**: After completing this guide, proceed to [MVC Views and Razor Syntax](mvc-views-razor.md) and [Working with Models](working-with-models.md).
