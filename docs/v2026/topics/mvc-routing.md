# MVC Routing

---
**Technology Version**: .NET 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-23
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What is MVC Routing?

MVC Routing is the system in ASP.NET Core that maps incoming URL requests to specific controller actions in your application. It acts as a translator between user-friendly URLs (like `/Pokemon/Details/5`) and the C# methods that handle those requests (like the `Details` method in `PokemonController`).

Think of routing as a postal service for your web application. Just like how the postal service uses addresses to deliver mail to the right house, routing uses URL patterns to deliver HTTP requests to the right controller action. When someone types a URL or clicks a link, the routing system figures out which controller and action method should handle that request.

In MVC applications, routing is essential because it creates the connection between what users see in their browser's address bar and what happens in your code. It makes your URLs clean, predictable, and easy to remember.

### Why Use MVC Routing?

Routing is fundamental to MVC applications because it:

- **Creates clean, meaningful URLs** - Instead of `/app.aspx?page=5&type=pokemon`, you can have `/Pokemon/Details/5`
- **Maps URLs to actions** - Automatically connects URLs to the right controller methods
- **Supports RESTful design** - Makes it easy to create URLs that follow REST principles
- **Enables URL generation** - You can generate URLs in your views without hardcoding them
- **Provides flexibility** - You can customize how URLs map to your code
- **Improves SEO** - Clean, descriptive URLs are better for search engines
- **Makes maintenance easier** - Change URL patterns without rewriting all your links

### When to Use It

**Use conventional routing when:**
- Building traditional MVC web applications with standard URL patterns
- You want all controllers to follow the same routing pattern
- Creating an application where most pages follow `/Controller/Action/Id` format
- You prefer centralized route configuration in one place (Program.cs)

**Use attribute routing when:**
- You need custom URL patterns for specific actions
- Building RESTful APIs within your MVC app
- Different controllers need different URL structures
- You want route configuration close to the action methods
- Creating complex routes with multiple parameters

**Use both together when:**
- Building larger applications with varied requirements
- Some controllers follow standard patterns while others need custom routes
- You want flexibility to choose the best approach for each scenario

---

## 2. Quick Start

**TL;DR - Set up MVC routing in 5 minutes:**

**Step 1: Configure routing in Program.cs**

The default MVC template includes routing setup. In your `Program.cs`:

```csharp
var builder = WebApplication.CreateBuilder(args);

// Add MVC services
builder.Services.AddControllersWithViews();

var app = builder.Build();

// Configure routing
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

**Step 2: Create a controller**

```csharp
// Controllers/PokemonController.cs
using Microsoft.AspNetCore.Mvc;

namespace PokemonMvcApp.Controllers
{
    public class PokemonController : Controller
    {
        // Matches: /Pokemon/Index
        public IActionResult Index()
        {
            return View();
        }

        // Matches: /Pokemon/Details/5
        public IActionResult Details(int id)
        {
            ViewData["PokemonId"] = id;
            return View();
        }
    }
}
```

**Step 3: Test your routes**

Run your application and navigate to:
- `https://localhost:5001/Pokemon/Index` - Calls `PokemonController.Index()`
- `https://localhost:5001/Pokemon/Details/5` - Calls `PokemonController.Details(5)`
- `https://localhost:5001/` - Calls `HomeController.Index()` (default route)

**What's happening:**
- The route pattern `{controller=Home}/{action=Index}/{id?}` matches URLs
- `{controller}` maps to the controller name (without "Controller" suffix)
- `{action}` maps to the action method name
- `{id?}` is an optional parameter (the `?` makes it optional)
- Default values are used when parts are missing (`Home` and `Index`)

For detailed explanations, continue reading the sections below.

---

## 3. Prerequisites

### Required Knowledge

- **C# Basics** - Understanding of classes, methods, and namespaces. You should be comfortable reading C# code.
- **MVC Pattern** - Understanding of the Model-View-Controller pattern and how it separates concerns in web applications.
- **MVC Controllers** - You should understand what controllers are and how action methods work (see "MVC Controllers" documentation).
- **HTTP Basics** - Basic understanding of HTTP requests, URLs, and how web browsers communicate with servers.
- **ASP.NET Core project structure** - Familiarity with Controllers/, Views/ folders and Program.cs.

### Required Software/Tools

- **.NET SDK** - Version 8.0 or higher
  - Verify: Run `dotnet --version` in your terminal
- **Code Editor** - Visual Studio, VS Code, or JetBrains Rider
- **Existing MVC Project** - You should have an ASP.NET Core MVC project created (see "Creating an MVC Project" guide)

### System Requirements

- **Operating System**: Windows 10+, macOS 11+, or modern Linux distribution
- **RAM**: 4GB minimum (8GB recommended for better IDE performance)
- **Disk Space**: 500MB free for project files and dependencies

---

## 4. Core Concepts & Theory

### Key Concepts

#### Concept 1: Conventional Routing

Conventional routing (also called endpoint routing) is when you define route patterns centrally in `Program.cs`. All controllers in your application follow these patterns. It's called "conventional" because you establish a convention that all routes follow.

**How it works:**
1. You define one or more route patterns in Program.cs
2. When a request comes in, ASP.NET Core matches the URL against these patterns
3. The routing system extracts values from the URL (controller name, action name, parameters)
4. It finds the matching controller and action method
5. The action method is invoked with the extracted parameters

**Example:**
```csharp
// In Program.cs
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");
```

This single pattern handles URLs like:
- `/Home/Index` → `HomeController.Index()`
- `/Pokemon/Details/25` → `PokemonController.Details(25)`
- `/Product/Edit/100` → `ProductController.Edit(100)`

**Advantages:**
- Centralized configuration - all routes in one place
- Consistent URL structure across the application
- Easy to understand and maintain for simple applications
- Less code in controllers

**Disadvantages:**
- Less flexible for custom URL patterns
- All controllers must follow the same pattern
- Harder to create RESTful URLs for specific cases

#### Concept 2: Route Template Syntax

Route templates define URL patterns using placeholders (called route parameters) enclosed in curly braces `{}`. These placeholders are matched against incoming URLs and their values are passed to controller actions.

**Basic syntax:**
```
{parameter}         - Required parameter
{parameter?}        - Optional parameter (? makes it optional)
{parameter=value}   - Parameter with default value
```

**Common patterns:**

| Pattern | Example URL | Matches |
|---------|-------------|---------|
| `{controller}/{action}` | `/Pokemon/Index` | controller="Pokemon", action="Index" |
| `{controller}/{action}/{id}` | `/Pokemon/Details/5` | controller="Pokemon", action="Details", id="5" |
| `{controller}/{action}/{id?}` | `/Pokemon/Index` | controller="Pokemon", action="Index", id=null |
| `{controller=Home}/{action=Index}` | `/` | controller="Home", action="Index" |

**How route parameters work:**

1. **Route parameter names must match action method parameter names:**
```csharp
// Route: {controller}/{action}/{id}
public IActionResult Details(int id)  // ✅ 'id' matches route parameter
{
    return View();
}
```

2. **Parameter types are automatically converted:**
```csharp
// URL: /Pokemon/Details/25
// The string "25" from URL is converted to int 25
public IActionResult Details(int id)  // id receives 25 as an integer
{
    return View();
}
```

3. **Optional parameters can be omitted:**
```csharp
// Route: {controller}/{action}/{id?}
// Both these URLs work:
// /Pokemon/Index        → id is null
// /Pokemon/Details/5    → id is 5

public IActionResult Details(int? id)  // Use nullable int for optional parameter
{
    if (id == null)
        return BadRequest("ID is required");

    return View();
}
```

#### Concept 3: Route Parameters

Route parameters are placeholders in route templates that capture values from URLs. They map to action method parameters.

**Parameter types:**

**1. Required parameters:**
```csharp
// Route: products/{id}
// URL: /products/42
public IActionResult GetProduct(int id)  // id = 42
{
    return View();
}
```

**2. Optional parameters (marked with `?`):**
```csharp
// Route: products/{category?}
// URL: /products        → category = null
// URL: /products/toys   → category = "toys"
public IActionResult List(string? category)
{
    return View();
}
```

**3. Parameters with default values:**
```csharp
// Route: products/{page=1}
// URL: /products        → page = 1 (default)
// URL: /products/5      → page = 5
public IActionResult List(int page)
{
    return View();
}
```

**Multiple parameters:**
```csharp
// Route: {controller}/{action}/{category}/{page?}
// URL: /Pokemon/Search/fire/2
public IActionResult Search(string category, int? page)
{
    // category = "fire", page = 2
    return View();
}
```

#### Concept 4: Attribute Routing in MVC

Attribute routing lets you define routes directly on controller classes and action methods using attributes. This gives you fine-grained control over individual routes.

**Basic syntax:**
```csharp
public class PokemonController : Controller
{
    // Route: /pokemon/all
    [Route("pokemon/all")]
    public IActionResult Index()
    {
        return View();
    }

    // Route: /pokemon/5
    [Route("pokemon/{id}")]
    public IActionResult Details(int id)
    {
        return View();
    }
}
```

**Using [Route] on the controller:**
```csharp
[Route("pokemon")]  // Base route for all actions
public class PokemonController : Controller
{
    [Route("list")]           // Combined: /pokemon/list
    public IActionResult Index()
    {
        return View();
    }

    [Route("details/{id}")]   // Combined: /pokemon/details/5
    public IActionResult Details(int id)
    {
        return View();
    }
}
```

**Route tokens (shortcuts):**

ASP.NET Core provides special tokens to avoid repeating controller and action names:

| Token | Replacement |
|-------|-------------|
| `[controller]` | Replaced with controller name (without "Controller" suffix) |
| `[action]` | Replaced with action method name |

**Example:**
```csharp
[Route("[controller]")]  // Becomes: /Pokemon
public class PokemonController : Controller
{
    [Route("[action]")]          // Becomes: /Pokemon/Index
    public IActionResult Index()
    {
        return View();
    }

    [Route("[action]/{id}")]     // Becomes: /Pokemon/Details/5
    public IActionResult Details(int id)
    {
        return View();
    }
}
```

**Attribute routing advantages:**
- Complete control over each route
- Routes are defined close to the action code
- Perfect for RESTful APIs
- Can create custom URL patterns per action

**Attribute routing disadvantages:**
- More verbose (more attributes to write)
- Routes scattered across multiple files
- Can become inconsistent if not managed carefully

#### Concept 5: Combining Conventional and Attribute Routing

You can use both routing approaches in the same application! This gives you maximum flexibility.

**How it works:**
- Conventional routes are evaluated first
- Attribute routes override conventional routes for specific actions
- Actions without attributes fall back to conventional routes

**Example:**
```csharp
// In Program.cs - conventional route
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

// In controller - attribute routes override
public class PokemonController : Controller
{
    // Uses conventional routing: /Pokemon/Index
    public IActionResult Index()
    {
        return View();
    }

    // Uses attribute routing: /api/pokemon/5 (custom URL)
    [Route("api/pokemon/{id}")]
    public IActionResult ApiDetails(int id)
    {
        return Json(new { id, name = "Pikachu" });
    }

    // Uses conventional routing: /Pokemon/Edit/5
    public IActionResult Edit(int id)
    {
        return View();
    }
}
```

### Important Terminology

| Term | Definition |
|------|------------|
| **Route** | A pattern that maps URLs to controller actions |
| **Route Template** | The pattern string like `{controller}/{action}/{id?}` |
| **Route Parameter** | A placeholder in the route template like `{id}` |
| **Conventional Routing** | Routes defined centrally in Program.cs |
| **Attribute Routing** | Routes defined on controllers/actions using attributes |
| **Route Constraint** | Rules that restrict what values a route parameter can accept |
| **Default Route** | The route used when no specific route matches (usually the first defined) |
| **Route Token** | Special placeholders like `[controller]` and `[action]` |
| **Endpoint** | The combination of a URL pattern and the action method it maps to |

### How Routing Works (The Big Picture)

```
1. HTTP Request arrives: GET /Pokemon/Details/25
         ↓
2. Routing Middleware intercepts the request
         ↓
3. Matches URL against route patterns:
   - Tries: {controller=Home}/{action=Index}/{id?}
   - Extracts: controller="Pokemon", action="Details", id="25"
         ↓
4. Finds PokemonController class
         ↓
5. Finds Details(int id) method
         ↓
6. Converts "25" (string) to 25 (int)
         ↓
7. Invokes: PokemonController.Details(25)
         ↓
8. Action executes and returns result (View, Redirect, etc.)
         ↓
9. Response sent back to browser
```

**Key insight:** Routing is just pattern matching! The routing system tries to match the incoming URL to a pattern, extracts values, and calls the corresponding method.

---

## 5. Installation Guide

**Not Applicable** - Routing is a built-in feature of ASP.NET Core MVC. No separate installation is required.

If you have ASP.NET Core MVC installed (via the .NET SDK), routing is already available in your project. When you create an MVC project using `dotnet new mvc`, routing is automatically configured for you.

**Verify MVC is available:**
```bash
dotnet --version  # Should show 8.0 or higher
```

If you need to add MVC to an existing ASP.NET Core project:
```bash
# Add MVC services in Program.cs
builder.Services.AddControllersWithViews();

# Configure routing middleware
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");
```

That's it! You're ready to use routing.

---

## 6. Initial Setup & Configuration

### Setting Up Routing in Program.cs

Routing is configured in the `Program.cs` file, which is the entry point of your ASP.NET Core application. Here's how to set it up step by step.

#### Step 1: Add MVC Services

First, register MVC services with the dependency injection container:

```csharp
var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllersWithViews();  // Registers MVC controllers and view support

var app = builder.Build();
```

**What this does:**
- `AddControllersWithViews()` registers all the services needed for MVC (controllers, model binding, view rendering, etc.)
- This must be called before building the app

#### Step 2: Configure the Request Pipeline

After building the app, configure middleware in the correct order:

```csharp
var app = builder.Build();

// Configure the HTTP request pipeline
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();  // Redirect HTTP to HTTPS
app.UseStaticFiles();       // Serve static files (CSS, JS, images)

app.UseRouting();           // Enable routing middleware

app.UseAuthorization();     // Enable authorization (must come after UseRouting)

// Map routes here (next step)

app.Run();
```

**Important:** Middleware order matters! Routing must come before authorization, and both must come before mapping routes.

#### Step 3: Define Routes

Add route mappings after `UseAuthorization()`:

**Single default route (most common):**
```csharp
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");
```

**Complete Program.cs example:**
```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthorization();

// Define routes
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

### Defining Multiple Routes

You can define multiple routes to handle different URL patterns. Routes are evaluated in the order they're defined.

```csharp
// Specific route for Pokemon with custom pattern (checked first)
app.MapControllerRoute(
    name: "pokemon",
    pattern: "pokemon/{action=Index}/{id?}",
    defaults: new { controller = "Pokemon" });

// Blog route with year/month/day pattern
app.MapControllerRoute(
    name: "blog",
    pattern: "blog/{year}/{month}/{day}/{slug}",
    defaults: new { controller = "Blog", action = "Article" });

// Default catch-all route (checked last)
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");
```

**How it works:**
1. When a request comes in, routes are evaluated top-to-bottom
2. The first matching route wins
3. More specific routes should come before general routes
4. The default route usually comes last as a fallback

### Route Parameters Explained

**name:** A unique identifier for the route (used for URL generation)
```csharp
name: "default"  // You can reference this in views: Url.RouteUrl("default", ...)
```

**pattern:** The URL pattern template
```csharp
pattern: "{controller=Home}/{action=Index}/{id?}"
```
- `{controller=Home}` - controller name with default "Home"
- `{action=Index}` - action name with default "Index"
- `{id?}` - optional id parameter

**defaults:** Explicit default values (alternative to inline defaults)
```csharp
app.MapControllerRoute(
    name: "pokemon",
    pattern: "pokemon/{action}/{id?}",
    defaults: new { controller = "Pokemon", action = "List" });

// Same as:
pattern: "pokemon/{action=List}/{id?}"
// with controller always being "Pokemon"
```

### Configuration Options

#### MapControllers vs MapControllerRoute

```csharp
// MapControllerRoute - for conventional routing
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

// MapControllers - for attribute routing only
app.MapControllers();  // No pattern needed; uses [Route] attributes
```

**Use MapControllerRoute when:**
- You want conventional routing
- You have a standard URL pattern for all controllers

**Use MapControllers when:**
- You only use attribute routing
- Every controller defines its own routes with [Route] attributes

**Use both when:**
- You want to support both conventional and attribute routing
```csharp
// Support conventional routing
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

// Also support attribute routing
app.MapControllers();
```

### Minimal Program.cs Template

Here's a minimal working setup for MVC routing:

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();

var app = builder.Build();

app.UseStaticFiles();
app.UseRouting();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

This is all you need for basic MVC routing! Everything else (exception handling, HTTPS, etc.) is optional.

---

## 7. Basic Usage

This section shows practical examples of using routing with controllers and actions.

### Example 1: Basic Conventional Routing

**Setup in Program.cs:**
```csharp
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");
```

**Create a controller:**
```csharp
// Controllers/PokemonController.cs
using Microsoft.AspNetCore.Mvc;

namespace PokemonMvcApp.Controllers
{
    public class PokemonController : Controller
    {
        // GET: /Pokemon/Index or /Pokemon
        public IActionResult Index()
        {
            return View();
        }

        // GET: /Pokemon/Details/5
        public IActionResult Details(int id)
        {
            ViewData["Message"] = $"Showing details for Pokemon #{id}";
            return View();
        }

        // GET: /Pokemon/Search?name=pikachu
        public IActionResult Search(string name)
        {
            ViewData["SearchTerm"] = name;
            return View();
        }
    }
}
```

**How URLs map to actions:**

| URL | Controller | Action | Parameter |
|-----|------------|--------|-----------|
| `/Pokemon` | Pokemon | Index | - |
| `/Pokemon/Index` | Pokemon | Index | - |
| `/Pokemon/Details/5` | Pokemon | Details | id=5 |
| `/Pokemon/Search?name=pikachu` | Pokemon | Search | name="pikachu" |

**What's happening:**
- The route pattern `{controller}/{action}/{id?}` matches the URL structure
- `/Pokemon` uses the default action "Index"
- `/Pokemon/Details/5` captures `5` as the `id` parameter
- Query strings (`?name=pikachu`) work alongside route parameters

### Example 2: Using Attribute Routing

**Controller with attribute routes:**
```csharp
using Microsoft.AspNetCore.Mvc;

namespace PokemonMvcApp.Controllers
{
    [Route("pokedex")]  // Base route for all actions
    public class PokedexController : Controller
    {
        // GET: /pokedex
        [Route("")]
        [Route("index")]
        public IActionResult Index()
        {
            return View();
        }

        // GET: /pokedex/entry/25
        [Route("entry/{id}")]
        public IActionResult Entry(int id)
        {
            ViewData["PokedexNumber"] = id;
            return View();
        }

        // GET: /pokedex/type/fire
        [Route("type/{typeName}")]
        public IActionResult ByType(string typeName)
        {
            ViewData["Type"] = typeName;
            return View();
        }

        // GET: /pokedex/generation/1
        [Route("generation/{gen:int}")]
        public IActionResult ByGeneration(int gen)
        {
            ViewData["Generation"] = gen;
            return View();
        }
    }
}
```

**Program.cs setup for attribute routing:**
```csharp
app.MapControllers();  // Enable attribute routing
```

**URL mapping:**

| URL | Action | Parameter |
|-----|--------|-----------|
| `/pokedex` | Index | - |
| `/pokedex/index` | Index | - |
| `/pokedex/entry/25` | Entry | id=25 |
| `/pokedex/type/fire` | ByType | typeName="fire" |
| `/pokedex/generation/1` | ByGeneration | gen=1 |

### Example 3: Using Route Tokens

Route tokens help reduce repetition by using `[controller]` and `[action]` placeholders:

```csharp
using Microsoft.AspNetCore.Mvc;

[Route("[controller]")]  // Becomes: /Pokemon
public class PokemonController : Controller
{
    // GET: /Pokemon/List
    [Route("[action]")]
    public IActionResult List()
    {
        return View();
    }

    // GET: /Pokemon/View/25
    [Route("[action]/{id}")]
    public IActionResult View(int id)
    {
        return View();
    }

    // GET: /Pokemon/Edit/25
    [Route("[action]/{id:int}")]
    public IActionResult Edit(int id)
    {
        return View();
    }
}
```

**Benefits of tokens:**
- Less typing, less chance of typos
- If you rename the controller, routes update automatically
- Keeps routes consistent with controller/action names

### Example 4: Multiple Parameters

**Conventional routing with multiple parameters:**
```csharp
// Program.cs - custom route
app.MapControllerRoute(
    name: "pokemonSearch",
    pattern: "pokemon/search/{type}/{region?}",
    defaults: new { controller = "Pokemon", action = "AdvancedSearch" });

// Controller
public class PokemonController : Controller
{
    // GET: /pokemon/search/fire/kanto
    // GET: /pokemon/search/water
    public IActionResult AdvancedSearch(string type, string? region)
    {
        ViewData["Type"] = type;
        ViewData["Region"] = region ?? "All Regions";
        return View();
    }
}
```

**Attribute routing with multiple parameters:**
```csharp
[Route("pokemon")]
public class PokemonController : Controller
{
    // GET: /pokemon/filter/fire/kanto/5
    [Route("filter/{type}/{region}/{minLevel}")]
    public IActionResult FilterPokemon(string type, string region, int minLevel)
    {
        ViewData["Filters"] = $"Type: {type}, Region: {region}, Min Level: {minLevel}";
        return View();
    }
}
```

### Example 5: Combining Conventional and Attribute Routing

You can use both approaches in the same application:

```csharp
// Program.cs
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.MapControllers();  // Also enable attribute routing
```

**Controller using both:**
```csharp
public class PokemonController : Controller
{
    // Uses conventional routing: /Pokemon/Index
    public IActionResult Index()
    {
        return View();
    }

    // Uses conventional routing: /Pokemon/Details/5
    public IActionResult Details(int id)
    {
        return View();
    }

    // Uses attribute routing: /api/pokemon/5 (custom URL)
    [Route("api/pokemon/{id}")]
    public IActionResult GetPokemonJson(int id)
    {
        return Json(new { id, name = "Pikachu", type = "Electric" });
    }

    // Uses attribute routing: /pokemon-data/all
    [Route("pokemon-data/all")]
    public IActionResult GetAllJson()
    {
        return Json(new[] {
            new { id = 1, name = "Bulbasaur" },
            new { id = 25, name = "Pikachu" }
        });
    }
}
```

**When to use each:**
- Use conventional routing for standard CRUD pages (`/Pokemon/Index`, `/Pokemon/Edit/5`)
- Use attribute routing for custom URLs or API endpoints (`/api/pokemon/5`, `/pokemon-data/all`)

### Common URL Patterns

Here are common routing patterns you'll use:

| Pattern | Example | Use Case |
|---------|---------|----------|
| `{controller}/{action}` | `/Pokemon/List` | Standard pages |
| `{controller}/{action}/{id}` | `/Pokemon/Edit/5` | Edit/Details pages |
| `{controller}/{id}` | `/Pokemon/25` | Resource-focused URLs |
| `{controller}/{action}/{id?}` | `/Pokemon/List` or `/Pokemon/List/1` | Optional page parameter |
| `api/{controller}/{id?}` | `/api/pokemon/5` | API endpoints |
| Custom literal paths | `/pokedex/entry/25` | Branded URLs |

---

## 8. Testing & Validation

### How to Test Your Routes

#### Method 1: Browser Testing

The simplest way to test routes is using your web browser:

**Step 1: Run your application**
```bash
dotnet run
```

**Step 2: Navigate to URLs manually**
- Open `https://localhost:5001/Pokemon/Index`
- Try `https://localhost:5001/Pokemon/Details/5`
- Test with different parameters: `https://localhost:5001/Pokemon/Details/999`

**Expected behavior:**
- If the route matches, the action method executes and returns a view
- If no matching route, you'll see a 404 error
- If parameter types don't match (e.g., `/Pokemon/Details/abc` for an int parameter), you'll see an error

#### Method 2: Testing with Developer Tools

Use browser developer tools to verify routing:

**Step 1: Open Developer Tools (F12)**

**Step 2: Navigate to Network tab**

**Step 3: Visit a URL and check:**
- Status code (200 = success, 404 = not found, 500 = server error)
- Request URL
- Response headers

#### Method 3: Route Debugging with Logging

Enable detailed route logging to see how URLs are matched:

```csharp
// Program.cs
var builder = WebApplication.CreateBuilder(args);

// Add logging for routing
builder.Logging.AddFilter("Microsoft.AspNetCore.Routing", LogLevel.Debug);

builder.Services.AddControllersWithViews();

var app = builder.Build();
```

Run your app and watch the console output - you'll see detailed routing information!

### Common Validation Checks

**Check 1: Verify route is defined**
```csharp
// In Program.cs, add this before app.Run()
var routes = app.Services.GetService<EndpointDataSource>();
foreach (var endpoint in routes!.Endpoints)
{
    Console.WriteLine(endpoint.DisplayName);
}
```

**Check 2: Test default values**
```bash
# If default is {controller=Home}/{action=Index}
# Navigate to: https://localhost:5001/
# Should land on HomeController.Index()
```

**Check 3: Test optional parameters**
```bash
# Route: {controller}/{action}/{id?}
# Both should work:
https://localhost:5001/Pokemon/Index      # id is null
https://localhost:5001/Pokemon/Details/5  # id is 5
```

### Hands-On Exercises

#### Exercise 1: Basic Conventional Routing (Beginner)

**Objective:** Create a basic MVC application with conventional routing

**Task:**
Create a Pokemon management application with these routes:
- `/Pokemon/Index` - List all Pokemon
- `/Pokemon/Details/5` - Show details for Pokemon #5
- `/Pokemon/Create` - Show form to create new Pokemon

**Requirements:**
1. Set up conventional routing in Program.cs
2. Create a `PokemonController` with three action methods
3. Test all three URLs in your browser
4. Add a default route that navigates to `/Home/Index`

**Hints:**
- Use the pattern `{controller=Home}/{action=Index}/{id?}`
- Remember to inherit from `Controller` base class
- Use `return View();` in each action for now

<details>
<summary>Click to reveal solution</summary>

**Program.cs:**
```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();

var app = builder.Build();

app.UseStaticFiles();
app.UseRouting();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

**Controllers/PokemonController.cs:**
```csharp
using Microsoft.AspNetCore.Mvc;

namespace PokemonMvcApp.Controllers
{
    public class PokemonController : Controller
    {
        // GET: /Pokemon/Index
        public IActionResult Index()
        {
            ViewData["Message"] = "List of all Pokemon";
            return View();
        }

        // GET: /Pokemon/Details/5
        public IActionResult Details(int id)
        {
            ViewData["Message"] = $"Details for Pokemon #{id}";
            return View();
        }

        // GET: /Pokemon/Create
        public IActionResult Create()
        {
            ViewData["Message"] = "Create a new Pokemon";
            return View();
        }
    }
}
```

**Explanation:**
- The default route handles all three URLs
- `{controller=Home}` means `/` goes to HomeController
- `{action=Index}` means `/Pokemon` goes to Pokemon/Index
- `{id?}` makes the id parameter optional
- `/Pokemon/Details/5` captures `5` as the id parameter
</details>

---

#### Exercise 2: Attribute Routing (Intermediate)

**Objective:** Practice attribute routing with custom URL patterns

**Task:**
Create a Pokedex controller with these custom URLs:
- `/pokedex` - Show Pokedex home
- `/pokedex/entry/25` - Show Pokedex entry for Pokemon #25
- `/pokedex/search/fire` - Search Pokemon by type
- `/pokedex/region/kanto` - Show all Pokemon from a region

**Requirements:**
1. Use attribute routing (not conventional routing)
2. Use `[Route]` attributes on the controller and actions
3. Use route tokens where appropriate
4. Enable attribute routing with `MapControllers()` in Program.cs

**Hints:**
- Put `[Route("pokedex")]` on the controller
- Use `[Route("entry/{id}")]` for parameterized routes
- Remember to call `app.MapControllers();` in Program.cs

<details>
<summary>Click to reveal solution</summary>

**Program.cs:**
```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();

var app = builder.Build();

app.UseStaticFiles();
app.UseRouting();

app.MapControllers();  // Enable attribute routing

app.Run();
```

**Controllers/PokedexController.cs:**
```csharp
using Microsoft.AspNetCore.Mvc;

namespace PokemonMvcApp.Controllers
{
    [Route("pokedex")]
    public class PokedexController : Controller
    {
        // GET: /pokedex
        [Route("")]
        [Route("index")]
        public IActionResult Index()
        {
            ViewData["Message"] = "Welcome to the Pokedex!";
            return View();
        }

        // GET: /pokedex/entry/25
        [Route("entry/{id:int}")]
        public IActionResult Entry(int id)
        {
            ViewData["Message"] = $"Pokedex Entry #{id}";
            return View();
        }

        // GET: /pokedex/search/fire
        [Route("search/{type}")]
        public IActionResult SearchByType(string type)
        {
            ViewData["Message"] = $"Searching for {type} type Pokemon";
            return View();
        }

        // GET: /pokedex/region/kanto
        [Route("region/{regionName}")]
        public IActionResult Region(string regionName)
        {
            ViewData["Message"] = $"Pokemon from {regionName} region";
            return View();
        }
    }
}
```

**Explanation:**
- `[Route("pokedex")]` on the controller sets the base path
- `[Route("")]` matches just `/pokedex`
- `[Route("entry/{id:int}")]` combines to `/pokedex/entry/{id}`
- The `:int` is a route constraint ensuring id must be an integer
- Each action has its own custom route independent of the action name
</details>

---

#### Exercise 3: Mixed Routing (Challenge)

**Objective:** Combine conventional and attribute routing in one application

**Task:**
Create an application that uses:
- Conventional routing for standard CRUD operations
- Attribute routing for custom API-style endpoints

Create these routes:
- `/Pokemon/Index` - List (conventional)
- `/Pokemon/Edit/5` - Edit (conventional)
- `/api/pokemon/5` - Get Pokemon as JSON (attribute)
- `/api/pokemon/search?name=pikachu` - Search API (attribute)

**Requirements:**
1. Set up both `MapControllerRoute` and `MapControllers` in Program.cs
2. Use conventional routing for Index and Edit actions
3. Use attribute routing for API-style actions
4. API actions should return JSON using `Json()`
5. Regular actions return views using `View()`

**Bonus Challenges:**
- Add route constraints to ensure id is always an integer
- Make the API endpoints return actual data objects
- Add a route for `/Pokemon/Details/{id}` with both a view and JSON option

<details>
<summary>Click to reveal solution</summary>

**Program.cs:**
```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();

var app = builder.Build();

app.UseStaticFiles();
app.UseRouting();

// Support both routing types
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.MapControllers();  // Also enable attribute routing

app.Run();
```

**Controllers/PokemonController.cs:**
```csharp
using Microsoft.AspNetCore.Mvc;

namespace PokemonMvcApp.Controllers
{
    public class PokemonController : Controller
    {
        // Conventional routing: /Pokemon/Index
        public IActionResult Index()
        {
            ViewData["Message"] = "Pokemon List Page";
            return View();
        }

        // Conventional routing: /Pokemon/Edit/5
        public IActionResult Edit(int id)
        {
            ViewData["Message"] = $"Edit Pokemon #{id}";
            return View();
        }

        // Attribute routing: /api/pokemon/5
        [Route("api/pokemon/{id:int}")]
        public IActionResult GetPokemonApi(int id)
        {
            var pokemon = new
            {
                id = id,
                name = "Pikachu",
                type = "Electric",
                level = 25
            };
            return Json(pokemon);
        }

        // Attribute routing: /api/pokemon/search?name=pikachu
        [Route("api/pokemon/search")]
        public IActionResult SearchApi(string name)
        {
            var results = new[]
            {
                new { id = 25, name = "Pikachu", type = "Electric" },
                new { id = 26, name = "Raichu", type = "Electric" }
            };

            var filtered = results.Where(p =>
                p.name.Contains(name, StringComparison.OrdinalIgnoreCase));

            return Json(filtered);
        }

        // Bonus: Conventional routing with format support
        // /Pokemon/Details/5
        public IActionResult Details(int id, string? format)
        {
            var pokemon = new
            {
                id = id,
                name = "Pikachu",
                type = "Electric"
            };

            if (format == "json")
                return Json(pokemon);

            ViewData["Pokemon"] = pokemon;
            return View();
        }
    }
}
```

**Explanation:**
- `Index` and `Edit` use the default conventional route
- API methods have `[Route]` attributes for custom URLs
- The `:int` constraint ensures `id` must be numeric
- `Json()` returns JSON responses for API endpoints
- `View()` returns HTML pages for regular actions
- Both routing approaches coexist in the same controller
</details>

---

### Comprehension Questions

**Question 1:** What's the difference between conventional routing and attribute routing?

<details>
<summary>Answer</summary>

**Conventional routing:**
- Defined centrally in Program.cs
- One or more patterns apply to all controllers
- Example: `{controller}/{action}/{id?}`
- Less code, consistent URLs
- Less flexible for custom patterns

**Attribute routing:**
- Defined with `[Route]` attributes on controllers/actions
- Each action can have a unique URL pattern
- Routes are defined close to the code
- More flexible, more verbose
- Perfect for custom or API-style URLs

You can use both in the same application!
</details>

**Question 2:** In the route pattern `{controller=Home}/{action=Index}/{id?}`, what does each part mean?

<details>
<summary>Answer</summary>

- `{controller=Home}` - Route parameter named "controller" with default value "Home"
- `{action=Index}` - Route parameter named "action" with default value "Index"
- `{id?}` - Optional route parameter named "id" (the `?` makes it optional)

**Examples:**
- `/` → controller="Home", action="Index", id=null (uses defaults)
- `/Pokemon` → controller="Pokemon", action="Index", id=null
- `/Pokemon/Details/5` → controller="Pokemon", action="Details", id="5"
</details>

**Question 3:** What happens if two routes could match the same URL?

<details>
<summary>Answer</summary>

Routes are evaluated in the order they're defined in Program.cs. The **first matching route wins**.

**Example:**
```csharp
// Specific route (checked first)
app.MapControllerRoute(
    name: "pokemon-special",
    pattern: "pokemon/all",
    defaults: new { controller = "Pokemon", action = "ListAll" });

// General route (checked second)
app.MapControllerRoute(
    name: "default",
    pattern: "{controller}/{action}");
```

URL `/pokemon/all` will match the first route and call `PokemonController.ListAll()`, not `AllController.Pokemon()`.

**Best practice:** Put more specific routes before general routes.
</details>

**Question 4:** How do you generate URLs in views without hardcoding them?

<details>
<summary>Answer</summary>

Use the `Url` helper or `Html` helper methods:

**Using Url.Action:**
```cshtml
<a href="@Url.Action("Details", "Pokemon", new { id = 5 })">View Details</a>
<!-- Generates: /Pokemon/Details/5 -->
```

**Using Html.ActionLink:**
```cshtml
@Html.ActionLink("View Details", "Details", "Pokemon", new { id = 5 })
<!-- Generates: <a href="/Pokemon/Details/5">View Details</a> -->
```

**Benefits:**
- URLs update automatically if routing changes
- No hardcoded paths
- Less error-prone
- Easier to maintain
</details>

**Question 5:** When should you use attribute routing instead of conventional routing?

<details>
<summary>Answer</summary>

**Use attribute routing when:**
- You need custom URL patterns for specific actions
- Building API endpoints with specific URL requirements
- Different controllers need different URL structures
- You want RESTful URLs like `/api/users/5/orders`
- You need multiple routes for the same action

**Use conventional routing when:**
- You have a consistent URL pattern across all controllers
- Building traditional MVC web applications
- You prefer centralized route configuration
- Most pages follow `/Controller/Action/Id` format

**Use both when:**
- You have varied requirements (mix of standard pages and API endpoints)
- You want flexibility to choose the best approach per controller
</details>

### Self-Assessment Checklist

After completing this section, you should be able to:

- [ ] Explain what routing is and why it's important in MVC
- [ ] Set up conventional routing in Program.cs
- [ ] Define multiple routes with different patterns
- [ ] Use attribute routing with [Route] attributes
- [ ] Understand route parameters and optional parameters
- [ ] Use default values in routes
- [ ] Combine conventional and attribute routing
- [ ] Test routes using a browser
- [ ] Debug routing issues
- [ ] Generate URLs dynamically in views using Url.Action
- [ ] Choose between conventional and attribute routing for a given scenario
- [ ] Understand route evaluation order

**If you can't check all these boxes:**
- Review the Core Concepts section (Section 4)
- Try the hands-on exercises again
- Experiment with different route patterns in your own project
- Read the official ASP.NET Core routing documentation

---

## 9. Practical Examples

###  Example 1: Route Constraints

Route constraints restrict what values a route parameter can accept. They're essential for creating precise routes and improving security.

#### Basic Route Constraints

**Common constraint types:**

| Constraint | Description | Example |
|------------|-------------|---------|
| `:int` | Must be an integer | `{id:int}` |
| `:bool` | Must be true or false | `{active:bool}` |
| `:datetime` | Must be a date | `{date:datetime}` |
| `:decimal` | Must be a decimal number | `{price:decimal}` |
| `:double` | Must be a double | `{latitude:double}` |
| `:float` | Must be a float | `{ratio:float}` |
| `:guid` | Must be a GUID | `{userId:guid}` |
| `:long` | Must be a long integer | `{population:long}` |
| `:min(value)` | Must be >= value | `{age:min(18)}` |
| `:max(value)` | Must be <= value | `{quantity:max(100)}` |
| `:range(min,max)` | Must be in range | `{rating:range(1,5)}` |
| `:minlength(value)` | String min length | `{name:minlength(3)}` |
| `:maxlength(value)` | String max length | `{code:maxlength(10)}` |
| `:length(value)` | Exact string length | `{zip:length(5)}` |
| `:alpha` | Only letters | `{name:alpha}` |
| `:regex(pattern)` | Matches regex | `{ssn:regex(^\\d{{3}}-\\d{{2}}-\\d{{4}}$)}` |

#### Practical Constraint Examples

**Example 1: Integer ID constraint**
```csharp
[Route("pokemon/{id:int}")]
public IActionResult Details(int id)
{
    return View();
}
```
- **Matches:** `/pokemon/5`, `/pokemon/999`
- **Doesn't match:** `/pokemon/abc`, `/pokemon/`

**Example 2: Range constraint for ratings**
```csharp
[Route("pokemon/{id:int}/rate/{rating:range(1,5)}")]
public IActionResult RatePokemon(int id, int rating)
{
    ViewData["Message"] = $"You rated Pokemon #{id} with {rating} stars";
    return View();
}
```
- **Matches:** `/pokemon/25/rate/5`, `/pokemon/1/rate/3`
- **Doesn't match:** `/pokemon/25/rate/0`, `/pokemon/25/rate/6`

**Example 3: Multiple constraints**
```csharp
[Route("pokedex/{generation:int:min(1):max(9)}/{id:int:range(1,151)}")]
public IActionResult PokemonByGeneration(int generation, int id)
{
    ViewData["Message"] = $"Generation {generation}, Pokemon #{id}";
    return View();
}
```
- Generation must be an integer between 1-9
- ID must be an integer between 1-151

**Example 4: Regex constraint for specific patterns**
```csharp
// Match URLs like: /trainer/ASH2024 (letters + 4 digits)
[Route("trainer/{trainerId:regex(^[A-Z]{{3}}\\d{{4}}$)}")]
public IActionResult TrainerProfile(string trainerId)
{
    ViewData["TrainerId"] = trainerId;
    return View();
}
```
- **Matches:** `/trainer/ASH2024`, `/trainer/RED1996`
- **Doesn't match:** `/trainer/ash2024`, `/trainer/ASH24`

**Example 5: Optional parameter with constraints**
```csharp
[Route("pokemon/list/{page:int:min(1)?}")]
public IActionResult List(int page = 1)
{
    ViewData["Page"] = page;
    return View();
}
```
- **Matches:** `/pokemon/list` (page=1), `/pokemon/list/5`
- **Doesn't match:** `/pokemon/list/0`, `/pokemon/list/-1`

#### Conventional Routing with Constraints

You can also apply constraints in Program.cs:

```csharp
app.MapControllerRoute(
    name: "pokemon-details",
    pattern: "pokemon/{id:int:min(1):max(999)}",
    defaults: new { controller = "Pokemon", action = "Details" });
```

### Example 2: URL Generation in Views

Instead of hardcoding URLs, use helper methods to generate them dynamically.

#### Using Url.Action

**Basic usage:**
```cshtml
<!-- Generate URL for action -->
<a href="@Url.Action("Details", "Pokemon", new { id = 25 })">View Pikachu</a>
<!-- Output: <a href="/Pokemon/Details/25">View Pikachu</a> -->
```

**With multiple parameters:**
```cshtml
<a href="@Url.Action("Search", "Pokemon", new { type = "fire", region = "kanto" })">
    Search Fire Pokemon
</a>
<!-- Output: /Pokemon/Search?type=fire&region=kanto -->
```

**Store URL in variable:**
```cshtml
@{
    var editUrl = Url.Action("Edit", "Pokemon", new { id = 5 });
}
<a href="@editUrl">Edit</a>
<a href="@editUrl" class="btn btn-primary">Edit Button</a>
```

#### Using Html.ActionLink

**Basic link:**
```cshtml
@Html.ActionLink("View Details", "Details", "Pokemon", new { id = 25 }, null)
<!-- Output: <a href="/Pokemon/Details/25">View Details</a> -->
```

**With CSS class:**
```cshtml
@Html.ActionLink("Edit", "Edit", "Pokemon",
    new { id = 25 },
    new { @class = "btn btn-primary", id = "edit-btn" })
<!-- Output: <a href="/Pokemon/Details/25" class="btn btn-primary" id="edit-btn">Edit</a> -->
```

#### Using Tag Helpers

**asp-action and asp-controller:**
```cshtml
<a asp-controller="Pokemon" asp-action="Details" asp-route-id="25">View Details</a>
<!-- Output: <a href="/Pokemon/Details/25">View Details</a> -->
```

**Multiple route parameters:**
```cshtml
<a asp-controller="Pokemon"
   asp-action="Filter"
   asp-route-type="fire"
   asp-route-region="kanto">
    Fire Pokemon in Kanto
</a>
<!-- Output: /Pokemon/Filter?type=fire&region=kanto -->
```

**Form tag helper:**
```cshtml
<form asp-controller="Pokemon" asp-action="Create" method="post">
    <!-- Form fields here -->
    <button type="submit">Create Pokemon</button>
</form>
<!-- Output: <form action="/Pokemon/Create" method="post"> -->
```

### Example 3: Building a Complete CRUD Interface

This example shows routing for a full Create-Read-Update-Delete interface:

**Program.cs:**
```csharp
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");
```

**PokemonController.cs:**
```csharp
using Microsoft.AspNetCore.Mvc;

public class PokemonController : Controller
{
    // GET: /Pokemon - List all
    public IActionResult Index()
    {
        return View();
    }

    // GET: /Pokemon/Details/5 - View one
    public IActionResult Details(int id)
    {
        ViewData["PokemonId"] = id;
        return View();
    }

    // GET: /Pokemon/Create - Show create form
    public IActionResult Create()
    {
        return View();
    }

    // POST: /Pokemon/Create - Process create form
    [HttpPost]
    public IActionResult Create(PokemonCreateModel model)
    {
        // Save pokemon...
        return RedirectToAction(nameof(Index));
    }

    // GET: /Pokemon/Edit/5 - Show edit form
    public IActionResult Edit(int id)
    {
        ViewData["PokemonId"] = id;
        return View();
    }

    // POST: /Pokemon/Edit/5 - Process edit form
    [HttpPost]
    public IActionResult Edit(int id, PokemonEditModel model)
    {
        // Update pokemon...
        return RedirectToAction(nameof(Details), new { id });
    }

    // POST: /Pokemon/Delete/5 - Delete pokemon
    [HttpPost]
    public IActionResult Delete(int id)
    {
        // Delete pokemon...
        return RedirectToAction(nameof(Index));
    }
}
```

**Index view with generated URLs:**
```cshtml
@* Views/Pokemon/Index.cshtml *@
<h1>Pokemon List</h1>

<a asp-action="Create" class="btn btn-primary">Add New Pokemon</a>

<table>
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Actions</th>
    </tr>
    @for (int i = 1; i <= 5; i++)
    {
        <tr>
            <td>@i</td>
            <td>Pokemon @i</td>
            <td>
                <a asp-action="Details" asp-route-id="@i">Details</a> |
                <a asp-action="Edit" asp-route-id="@i">Edit</a> |
                <form asp-action="Delete" asp-route-id="@i" method="post" style="display:inline;">
                    <button type="submit">Delete</button>
                </form>
            </td>
        </tr>
    }
</table>
```

### Example 4: RESTful API-Style Routes

Create clean, RESTful URLs using attribute routing:

```csharp
[Route("api/pokedex")]
public class PokedexApiController : Controller
{
    // GET: /api/pokedex
    [HttpGet]
    public IActionResult GetAll()
    {
        return Json(new { message = "All Pokemon" });
    }

    // GET: /api/pokedex/25
    [HttpGet("{id:int}")]
    public IActionResult GetById(int id)
    {
        return Json(new { id, name = "Pikachu" });
    }

    // POST: /api/pokedex
    [HttpPost]
    public IActionResult Create([FromBody] PokemonDto pokemon)
    {
        return Json(new { message = "Pokemon created", pokemon });
    }

    // PUT: /api/pokedex/25
    [HttpPut("{id:int}")]
    public IActionResult Update(int id, [FromBody] PokemonDto pokemon)
    {
        return Json(new { message = $"Pokemon {id} updated", pokemon });
    }

    // DELETE: /api/pokedex/25
    [HttpDelete("{id:int}")]
    public IActionResult Delete(int id)
    {
        return Json(new { message = $"Pokemon {id} deleted" });
    }

    // GET: /api/pokedex/search?name=pikachu&type=electric
    [HttpGet("search")]
    public IActionResult Search(string? name, string? type)
    {
        return Json(new { name, type, results = new[] { "Pikachu", "Raichu" } });
    }
}
```

**URL patterns:**
- `GET /api/pokedex` - Get all
- `GET /api/pokedex/25` - Get one
- `POST /api/pokedex` - Create
- `PUT /api/pokedex/25` - Update
- `DELETE /api/pokedex/25` - Delete
- `GET /api/pokedex/search?name=pikachu` - Search

### Example 5: Custom Route with Multiple Segments

Create complex URLs for filtering:

```csharp
[Route("browse")]
public class BrowseController : Controller
{
    // GET: /browse/pokemon/fire/kanto
    [Route("pokemon/{type}/{region}")]
    public IActionResult PokemonByTypeAndRegion(string type, string region)
    {
        ViewData["Message"] = $"Browsing {type} type Pokemon from {region}";
        return View();
    }

    // GET: /browse/pokemon/fire/kanto/level/50
    [Route("pokemon/{type}/{region}/level/{minLevel:int}")]
    public IActionResult PokemonFiltered(string type, string region, int minLevel)
    {
        ViewData["Filters"] = $"{type} type, {region} region, min level {minLevel}";
        return View();
    }

    // GET: /browse/trainers/kanto/badge/8
    [Route("trainers/{region}/badge/{badgeCount:int:range(1,8)}")]
    public IActionResult TrainersByBadges(string region, int badgeCount)
    {
        ViewData["Message"] = $"Trainers from {region} with {badgeCount} badges";
        return View();
    }
}
```

**Key takeaways:**
- Routes can have multiple segments
- Combine literal segments with route parameters
- Use constraints to validate parameters
- Create hierarchical, meaningful URLs

---

## 10. Common Patterns & Best Practices

[Content to be added]

---

## 11. Troubleshooting & Common Issues

[Content to be added]

---

## 12. Additional Resources

[Content to be added]

---

## Appendix

### Glossary

[Content to be added]

### Cheat Sheet

[Content to be added]

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-11-23 | Initial version |
