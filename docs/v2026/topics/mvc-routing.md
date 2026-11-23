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

[Content to be added]

---

## 9. Practical Examples

[Content to be added]

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
