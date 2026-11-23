# Areas in MVC (Quick Reference)

---
**Technology Version**: .NET 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-23
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What are Areas in MVC?

Areas are a feature in ASP.NET Core MVC that allow you to organize a large application into smaller, logical groups or "modules". Each Area is essentially a mini-MVC structure within your application, with its own Controllers, Views, and Models folders. Think of Areas as separate sections of your website that are organized independently but still part of the same application.

For example, in a Pokemon application, you might have:
- **Public Area** - Main site for regular users (Pokemon browsing, trainer profiles)
- **Admin Area** - Administrative functionality (managing Pokemon, users, system settings)
- **API Area** - RESTful API endpoints
- **Shop Area** - E-commerce functionality (buying Pokeballs, potions, items)

Each Area maintains the MVC pattern but operates independently, making your codebase more organized and maintainable.

### Why Use Areas?

Areas help you manage complexity in large applications by:

- **Logical separation** - Group related functionality together (Admin vs Public vs API)
- **Team collaboration** - Different teams can work on different Areas without conflicts
- **Code organization** - Prevents Controllers and Views folders from becoming too large
- **Clear boundaries** - Each Area has its own scope and responsibility
- **Easier maintenance** - Changes to one Area don't affect others
- **Reusability** - Areas can be developed as modular components

### When to Use Areas

**Use Areas when:**
- Your application has distinct sections (Admin panel, User portal, API)
- Multiple teams are working on different parts of the application
- You have more than 10-15 controllers
- You need to separate concerns clearly (administrative vs public functionality)
- Your application will grow significantly over time
- You want to modularize functionality for potential reuse

**Don't use Areas when:**
- Your application is small (less than 10 controllers)
- All functionality is similar and doesn't need logical separation
- You're just starting a project (wait until complexity justifies it)
- Simpler folder organization would suffice

### Areas vs Regular MVC Structure

**Without Areas (Small Application):**
```
Controllers/
├── HomeController.cs
├── PokemonController.cs
├── TrainerController.cs
├── AdminPokemonController.cs      ← Mixed with public controllers
├── AdminUsersController.cs        ← Hard to distinguish
└── AdminReportsController.cs

Views/
├── Home/
├── Pokemon/
├── Trainer/
├── AdminPokemon/                  ← Mixed organization
├── AdminUsers/
└── AdminReports/
```

**With Areas (Large Application):**
```
Areas/
├── Admin/
│   ├── Controllers/
│   │   ├── PokemonController.cs
│   │   ├── UsersController.cs
│   │   └── ReportsController.cs
│   └── Views/
│       ├── Pokemon/
│       ├── Users/
│       └── Reports/
└── Shop/
    ├── Controllers/
    │   ├── ProductsController.cs
    │   └── OrdersController.cs
    └── Views/
        ├── Products/
        └── Orders/

Controllers/                        ← Public controllers
├── HomeController.cs
├── PokemonController.cs
└── TrainerController.cs

Views/                              ← Public views
├── Home/
├── Pokemon/
└── Trainer/
```

---

## 2. Basic Usage

### Creating an Area

**Step 1: Add Area folder structure**

Create the following structure manually or using scaffolding:

```
Areas/
└── Admin/
    ├── Controllers/
    ├── Views/
    │   └── _ViewStart.cshtml
    └── Data/  (optional - for Area-specific models)
```

**Step 2: Create a Controller in the Area**

**Areas/Admin/Controllers/DashboardController.cs:**

```csharp
using Microsoft.AspNetCore.Mvc;

namespace PokemonApp.Areas.Admin.Controllers
{
    [Area("Admin")]  // ← Important: Specify the Area
    public class DashboardController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Stats()
        {
            return View();
        }
    }
}
```

**Key points:**
- Controller must have `[Area("Admin")]` attribute
- Namespace should include `.Areas.Admin.Controllers`
- Controller class name ends with `Controller`

**Step 3: Create Views for the Area**

**Areas/Admin/Views/Dashboard/Index.cshtml:**

```cshtml
@{
    ViewData["Title"] = "Admin Dashboard";
}

<div class="container mt-4">
    <h1>Admin Dashboard</h1>
    <p>Welcome to the Pokemon App Admin Panel</p>

    <div class="row mt-4">
        <div class="col-md-3">
            <div class="card text-center">
                <div class="card-body">
                    <h3>150</h3>
                    <p>Total Pokemon</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center">
                <div class="card-body">
                    <h3>1,234</h3>
                    <p>Total Trainers</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center">
                <div class="card-body">
                    <h3>5,678</h3>
                    <p>Battles Today</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center">
                <div class="card-body">
                    <h3>99.8%</h3>
                    <p>Uptime</p>
                </div>
            </div>
        </div>
    </div>
</div>
```

**Step 4: Create Area-specific _ViewStart.cshtml**

**Areas/Admin/Views/_ViewStart.cshtml:**

```cshtml
@{
    Layout = "_AdminLayout";  // Use admin-specific layout
}
```

This ensures all views in the Admin Area use the admin layout by default.

**Step 5: Create Area-specific _ViewImports.cshtml (Optional)**

**Areas/Admin/Views/_ViewImports.cshtml:**

```cshtml
@using PokemonApp.Areas.Admin
@using PokemonApp.Areas.Admin.Models
@addTagHelper *, Microsoft.AspNetCore.Mvc.TagHelpers
```

### Configuring Area Routing

**Program.cs:**

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

// Area route - must come before default route
app.MapControllerRoute(
    name: "areas",
    pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}");

// Default route for non-area controllers
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

**Key points:**
- Area route must be registered **before** default route
- `{area:exists}` constraint ensures route only matches when Area exists
- Each Area can have its own default controller and action

### Accessing Area Routes

**URL patterns:**

```
/Admin/Dashboard/Index          → Admin Area, Dashboard controller, Index action
/Admin/Pokemon/List             → Admin Area, Pokemon controller, List action
/Shop/Products/Browse           → Shop Area, Products controller, Browse action
/Pokemon/List                   → Default (no area), Pokemon controller, List action
```

### Linking to Area Actions

**From non-area view to area:**

```cshtml
<!-- Link to Admin Area -->
<a asp-area="Admin" asp-controller="Dashboard" asp-action="Index">
    Admin Dashboard
</a>

<a asp-area="Admin" asp-controller="Pokemon" asp-action="List">
    Manage Pokemon
</a>

<a asp-area="Shop" asp-controller="Products" asp-action="Browse">
    Browse Shop
</a>
```

**From area view to non-area:**

```cshtml
<!-- Link back to main site (no area) -->
<a asp-area="" asp-controller="Home" asp-action="Index">
    Back to Home
</a>

<a asp-area="" asp-controller="Pokemon" asp-action="List">
    View Public Pokemon List
</a>
```

**Within the same area:**

```cshtml
<!-- asp-area can be omitted if staying in same area -->
<a asp-controller="Dashboard" asp-action="Stats">
    View Stats
</a>
```

### Creating an Area Layout

**Areas/Admin/Views/Shared/_AdminLayout.cshtml:**

```cshtml
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>@ViewData["Title"] - Admin Panel</title>
    <link rel="stylesheet" href="~/lib/bootstrap/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="~/css/admin.css" asp-append-version="true" />
</head>
<body>
    <header>
        <nav class="navbar navbar-expand-sm navbar-dark bg-dark">
            <div class="container-fluid">
                <a class="navbar-brand" asp-area="Admin" asp-controller="Dashboard" asp-action="Index">
                    Admin Panel
                </a>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" asp-area="Admin" asp-controller="Dashboard" asp-action="Index">
                            Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" asp-area="Admin" asp-controller="Pokemon" asp-action="List">
                            Pokemon
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" asp-area="Admin" asp-controller="Users" asp-action="List">
                            Users
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" asp-area="" asp-controller="Home" asp-action="Index">
                            Back to Site
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
    </header>

    <div class="container-fluid">
        <main role="main" class="pb-3">
            @RenderBody()
        </main>
    </div>

    <footer class="border-top footer text-muted mt-5">
        <div class="container">
            &copy; 2026 - Pokemon App Admin Panel
        </div>
    </footer>

    <script src="~/lib/jquery/dist/jquery.min.js"></script>
    <script src="~/lib/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    @await RenderSectionAsync("Scripts", required: false)
</body>
</html>
```

---

## 3. Practical Examples

### Example 1: Complete Admin Area Setup

**Scenario:** Create a complete Admin area for managing Pokemon.

**Step 1: Create folder structure**

```
Areas/
└── Admin/
    ├── Controllers/
    │   ├── DashboardController.cs
    │   └── PokemonController.cs
    ├── Views/
    │   ├── Dashboard/
    │   │   └── Index.cshtml
    │   ├── Pokemon/
    │   │   ├── List.cshtml
    │   │   ├── Create.cshtml
    │   │   └── Edit.cshtml
    │   ├── Shared/
    │   │   └── _AdminLayout.cshtml
    │   ├── _ViewStart.cshtml
    │   └── _ViewImports.cshtml
    └── Models/  (optional)
        └── PokemonManagementViewModel.cs
```

**Step 2: Create Pokemon controller in Admin area**

**Areas/Admin/Controllers/PokemonController.cs:**

```csharp
using Microsoft.AspNetCore.Mvc;
using PokemonApp.Models;
using PokemonApp.Services;

namespace PokemonApp.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class PokemonController : Controller
    {
        private readonly IPokemonService _pokemonService;

        public PokemonController(IPokemonService pokemonService)
        {
            _pokemonService = pokemonService;
        }

        // GET: Admin/Pokemon/List
        public async Task<IActionResult> List()
        {
            var pokemon = await _pokemonService.GetAllAsync();
            return View(pokemon);
        }

        // GET: Admin/Pokemon/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Admin/Pokemon/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Pokemon pokemon)
        {
            if (ModelState.IsValid)
            {
                await _pokemonService.CreateAsync(pokemon);
                TempData["SuccessMessage"] = $"{pokemon.Name} created successfully!";
                return RedirectToAction(nameof(List));
            }
            return View(pokemon);
        }

        // GET: Admin/Pokemon/Edit/5
        public async Task<IActionResult> Edit(int id)
        {
            var pokemon = await _pokemonService.GetByIdAsync(id);
            if (pokemon == null)
            {
                return NotFound();
            }
            return View(pokemon);
        }

        // POST: Admin/Pokemon/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Pokemon pokemon)
        {
            if (id != pokemon.Id)
            {
                return BadRequest();
            }

            if (ModelState.IsValid)
            {
                await _pokemonService.UpdateAsync(pokemon);
                TempData["SuccessMessage"] = $"{pokemon.Name} updated successfully!";
                return RedirectToAction(nameof(List));
            }
            return View(pokemon);
        }

        // POST: Admin/Pokemon/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            await _pokemonService.DeleteAsync(id);
            TempData["SuccessMessage"] = "Pokemon deleted successfully!";
            return RedirectToAction(nameof(List));
        }
    }
}
```

**Step 3: Create List view**

**Areas/Admin/Views/Pokemon/List.cshtml:**

```cshtml
@model List<Pokemon>

@{
    ViewData["Title"] = "Manage Pokemon";
}

<div class="container-fluid">
    <div class="row mb-3">
        <div class="col-md-6">
            <h2>Manage Pokemon</h2>
        </div>
        <div class="col-md-6 text-end">
            <a asp-action="Create" class="btn btn-success">
                <i class="bi bi-plus-circle"></i> Add New Pokemon
            </a>
        </div>
    </div>

    @if (TempData["SuccessMessage"] != null)
    {
        <div class="alert alert-success alert-dismissible fade show">
            @TempData["SuccessMessage"]
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    }

    <div class="card">
        <div class="card-body">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Type</th>
                        <th>Level</th>
                        <th>HP</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach (var pokemon in Model)
                    {
                        <tr>
                            <td>@pokemon.Id</td>
                            <td>@pokemon.Name</td>
                            <td><span class="badge bg-primary">@pokemon.Type</span></td>
                            <td>@pokemon.Level</td>
                            <td>@pokemon.HP</td>
                            <td>
                                <a asp-action="Edit" asp-route-id="@pokemon.Id" class="btn btn-sm btn-warning">
                                    Edit
                                </a>
                                <form asp-action="Delete" asp-route-id="@pokemon.Id" method="post" class="d-inline">
                                    <button type="submit" class="btn btn-sm btn-danger"
                                            onclick="return confirm('Are you sure you want to delete @pokemon.Name?')">
                                        Delete
                                    </button>
                                </form>
                            </td>
                        </tr>
                    }
                </tbody>
            </table>
        </div>
    </div>
</div>
```

---

### Example 2: API Area for RESTful Endpoints

**Scenario:** Organize API controllers in a separate Area.

**Areas/Api/Controllers/PokemonApiController.cs:**

```csharp
using Microsoft.AspNetCore.Mvc;
using PokemonApp.Services;

namespace PokemonApp.Areas.Api.Controllers
{
    [Area("Api")]
    [Route("api/[controller]")]
    [ApiController]
    public class PokemonController : ControllerBase
    {
        private readonly IPokemonService _pokemonService;

        public PokemonController(IPokemonService pokemonService)
        {
            _pokemonService = pokemonService;
        }

        // GET: api/pokemon
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var pokemon = await _pokemonService.GetAllAsync();
            return Ok(pokemon);
        }

        // GET: api/pokemon/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var pokemon = await _pokemonService.GetByIdAsync(id);
            if (pokemon == null)
            {
                return NotFound();
            }
            return Ok(pokemon);
        }

        // POST: api/pokemon
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] Pokemon pokemon)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await _pokemonService.CreateAsync(pokemon);
            return CreatedAtAction(nameof(GetById), new { id = pokemon.Id }, pokemon);
        }
    }
}
```

**Program.cs with API area routing:**

```csharp
// API-specific route
app.MapControllerRoute(
    name: "api",
    pattern: "api/{controller}/{action}/{id?}",
    defaults: new { area = "Api" });

// General area route
app.MapControllerRoute(
    name: "areas",
    pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}");

// Default route
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");
```

---

### Example 3: Shop Area with Product Management

**Scenario:** Create a Shop area for e-commerce functionality.

**Areas/Shop/Controllers/ProductsController.cs:**

```csharp
using Microsoft.AspNetCore.Mvc;

namespace PokemonApp.Areas.Shop.Controllers
{
    [Area("Shop")]
    public class ProductsController : Controller
    {
        public IActionResult Browse()
        {
            return View();
        }

        public IActionResult Details(int id)
        {
            return View();
        }

        [HttpPost]
        public IActionResult AddToCart(int productId, int quantity)
        {
            // Add to cart logic
            TempData["SuccessMessage"] = "Item added to cart!";
            return RedirectToAction(nameof(Browse));
        }
    }
}
```

**Areas/Shop/Views/Products/Browse.cshtml:**

```cshtml
@{
    ViewData["Title"] = "Shop - Browse Products";
}

<div class="container">
    <h1>Pokemon Shop</h1>
    <p>Browse our selection of Pokeballs, Potions, and more!</p>

    <div class="row">
        <div class="col-md-4">
            <div class="card">
                <div class="card-body">
                    <h5>Pokeball</h5>
                    <p>Standard Pokeball for catching Pokemon</p>
                    <p class="text-success fw-bold">$200</p>
                    <form asp-action="AddToCart" method="post">
                        <input type="hidden" name="productId" value="1" />
                        <input type="number" name="quantity" value="1" min="1" class="form-control mb-2" />
                        <button type="submit" class="btn btn-primary w-100">Add to Cart</button>
                    </form>
                </div>
            </div>
        </div>
        <!-- More products... -->
    </div>
</div>
```

---

## 4. Common Patterns & Best Practices

### Area Naming Conventions

**Do:**
- Use PascalCase for Area names: `Admin`, `Shop`, `Api`
- Use descriptive, singular names
- Keep names short and clear
- Match folder name to Area attribute: `[Area("Admin")]` → `Areas/Admin/`

**Don't:**
- Use special characters or spaces
- Use lowercase: ~~`admin`~~ (use `Admin`)
- Use vague names: ~~`Area1`~~, ~~`Section`~~

### Folder Structure Best Practices

**Recommended structure:**

```
Areas/
└── Admin/
    ├── Controllers/
    │   ├── DashboardController.cs
    │   ├── PokemonController.cs
    │   └── UsersController.cs
    ├── Views/
    │   ├── Dashboard/
    │   │   └── Index.cshtml
    │   ├── Pokemon/
    │   │   ├── List.cshtml
    │   │   ├── Create.cshtml
    │   │   └── Edit.cshtml
    │   ├── Shared/
    │   │   ├── _AdminLayout.cshtml
    │   │   └── _AdminNav.cshtml
    │   ├── _ViewStart.cshtml
    │   └── _ViewImports.cshtml
    ├── Models/  (Optional - Area-specific ViewModels)
    │   └── DashboardViewModel.cs
    └── Data/  (Optional - Area-specific data classes)
```

### Sharing Code Between Areas

**Problem:** You need to use the same layout or partial across multiple Areas.

**Solution 1: Shared folder in root**

```
Views/
└── Shared/
    └── _CommonPartial.cshtml  ← Available to all areas
```

**Solution 2: Explicit path in Area views**

```cshtml
@* In Area view *@
<partial name="~/Views/Shared/_CommonPartial.cshtml" />
```

### Authorization in Areas

**Scenario:** Restrict Admin area to authorized users only.

**Apply to entire Area:**

**Areas/Admin/Controllers/BaseAdminController.cs:**

```csharp
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace PokemonApp.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]  // All inheriting controllers require Admin role
    public class BaseAdminController : Controller
    {
    }
}
```

**Admin controllers inherit from base:**

```csharp
namespace PokemonApp.Areas.Admin.Controllers
{
    public class PokemonController : BaseAdminController
    {
        // Automatically requires Admin role
        public IActionResult List()
        {
            return View();
        }
    }
}
```

### Area-Specific Middleware or Services

**Register services specific to an Area:**

**Program.cs:**

```csharp
// Admin-specific services
builder.Services.AddScoped<IAdminReportService, AdminReportService>();
builder.Services.AddScoped<IAdminAuditService, AdminAuditService>();

// Shop-specific services
builder.Services.AddScoped<IShoppingCartService, ShoppingCartService>();
builder.Services.AddScoped<IPaymentService, PaymentService>();
```

### Testing Area Controllers

**Unit test example:**

```csharp
[Fact]
public async Task Admin_Pokemon_List_ReturnsView()
{
    // Arrange
    var mockService = new Mock<IPokemonService>();
    mockService.Setup(s => s.GetAllAsync()).ReturnsAsync(GetTestPokemon());
    var controller = new Admin.Controllers.PokemonController(mockService.Object);

    // Act
    var result = await controller.List();

    // Assert
    var viewResult = Assert.IsType<ViewResult>(result);
    var model = Assert.IsAssignableFrom<List<Pokemon>>(viewResult.Model);
    Assert.Equal(3, model.Count);
}
```

---

## Summary

**Key Takeaways:**

1. **Areas organize large applications** into logical, self-contained modules
2. Each Area has its own **Controllers**, **Views**, and optionally **Models** folders
3. Controllers must have **`[Area("AreaName")]`** attribute
4. Area routing must be configured **before** default routing in Program.cs
5. Use **asp-area** attribute in tag helpers to navigate between areas
6. Areas are ideal for **Admin panels**, **API sections**, and **distinct modules**
7. Each Area can have its own **layout and _ViewStart**

**When to Use Areas:**
- Application has multiple distinct sections (Admin, Shop, Blog, etc.)
- Need to separate public vs administrative functionality
- Application is growing and controllers folder is getting crowded
- Multiple teams working on different modules
- Want better code organization for large projects

**Common Use Cases:**
- **Admin Area** - Administrative dashboard and management
- **API Area** - RESTful API controllers
- **Blog Area** - Blog posts, comments, categories
- **Shop Area** - E-commerce products, cart, checkout
- **Account Area** - User registration, login, profile

**Quick Setup Checklist:**
1. Create `Areas/[AreaName]` folder structure
2. Add `[Area("[AreaName]")]` attribute to controllers
3. Create Area-specific views with _ViewStart
4. Configure area routing in Program.cs
5. Test navigation with asp-area tag helpers

---

**Estimated Reading Time**: 25-30 minutes

**Prerequisites**: MVC basics (POK-21), Controllers and Routing

**Related Topics**: MVC Controllers (POK-22), Razor Views (POK-23), Authorization and Authentication

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-11-23 | Initial quick reference guide for Areas in MVC |
