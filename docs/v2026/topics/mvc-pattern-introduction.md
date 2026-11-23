# Introduction to MVC Pattern

**Estimated Reading Time**: 50 minutes

## Table of Contents
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [Core Concepts & Theory](#core-concepts--theory)
- [Installation Guide](#installation-guide)
- [Initial Setup & Configuration](#initial-setup--configuration)
- [Basic Usage](#basic-usage)
- [Testing & Validation](#testing--validation)
- [Practical Examples](#practical-examples)
- [Common Patterns & Best Practices](#common-patterns--best-practices)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)

## Overview

### What Is MVC?

**MVC (Model-View-Controller)** is a design pattern for building web applications that separates an application into three interconnected components: **Models** (data), **Views** (UI), and **Controllers** (logic). This separation makes applications easier to develop, test, and maintain.

**Real-World Analogy**: Think of a restaurant:
- **Model** (Kitchen): Where food is prepared and stored (your data/business logic)
- **View** (Dining Area): What customers see and experience (your UI/HTML)
- **Controller** (Waiter): Takes orders from customers and communicates with the kitchen (handles user requests)

### Why Use MVC?

**Without MVC** (mixing everything):

```html
<!-- BAD: HTML, C#, and data access all mixed together -->
<html>
<body>
    @{
        var products = db.Products.ToList();  // Data access in view!
        var total = products.Sum(p => p.Price);  // Business logic in view!
    }
    <h1>Products</h1>
    @foreach(var product in products)
    {
        <p>@product.Name - $@product.Price</p>
    }
    <strong>Total: $@total</strong>
</body>
</html>
```

**With MVC** (separated):

```csharp
// MODEL - Data structure
public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
}

// CONTROLLER - Business logic
public class ProductsController : Controller
{
    public IActionResult Index()
    {
        var products = _repository.GetAll();
        return View(products);  // Pass data to view
    }
}

// VIEW - Presentation (Razor)
<h1>Products</h1>
@foreach(var product in Model)
{
    <p>@product.Name - $@product.Price</p>
}
```

### Key Benefits

| Benefit | Description |
|---------|-------------|
| **Separation of Concerns** | Each component has a single responsibility |
| **Testability** | Can test controllers independently of views |
| **Maintainability** | Changes to UI don't affect business logic |
| **Team Collaboration** | Frontend and backend developers work independently |
| **Reusability** | Same model/controller can support multiple views |
| **Convention over Configuration** | ASP.NET Core MVC provides sensible defaults |

---

## Quick Start

Here's the simplest MVC application:

**1. Create a Model**:

```csharp
// Models/Product.cs
public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
}
```

**2. Create a Controller**:

```csharp
// Controllers/ProductsController.cs
public class ProductsController : Controller
{
    public IActionResult Index()
    {
        var products = new List<Product>
        {
            new Product { Id = 1, Name = "Widget", Price = 19.99m },
            new Product { Id = 2, Name = "Gadget", Price = 29.99m }
        };

        return View(products);  // Pass to view
    }
}
```

**3. Create a View**:

```cshtml
@* Views/Products/Index.cshtml *@
@model List<Product>

<h1>Products</h1>
<ul>
@foreach(var product in Model)
{
    <li>@product.Name - $@product.Price</li>
}
</ul>
```

**4. Configure MVC in Program.cs**:

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();  // Enable MVC

var app = builder.Build();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

**5. Run and browse to** `/Products`

---

## Prerequisites

### Required Knowledge

- **HTML/CSS**: Views use HTML
- **C# Basics**: Controllers use C#
- **HTTP**: Understanding of requests/responses
- **Basic Web Concepts**: URLs, forms, navigation

### Required Tools

| Tool | Version | Purpose |
|------|---------|---------|
| .NET SDK | 8.0+ | ASP.NET Core MVC |
| Visual Studio / VS Code | Latest | Development environment |

---

## Core Concepts & Theory

### 1. The MVC Triangle

```
        ┌──────────┐
        │  USER    │
        └──────────┘
              │
              │ 1. HTTP Request
              ↓
        ┌──────────┐
        │Controller│←────────┐
        └──────────┘         │
              │              │
              │ 2. Get Data  │ 4. Return View
              ↓              │
        ┌──────────┐         │
        │  Model   │         │
        └──────────┘         │
              │              │
              │ 3. Pass Data │
              ↓              │
        ┌──────────┐         │
        │   View   │─────────┘
        └──────────┘
              │
              │ 5. HTML Response
              ↓
        ┌──────────┐
        │  USER    │
        └──────────┘
```

**Flow**:
1. User requests `/Products`
2. Controller receives request, gets data from Model
3. Controller passes data to View
4. View generates HTML
5. HTML returned to user

### 2. Model

**Models** represent data and business logic:

```csharp
// Data model
public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }

    // Business logic
    public decimal CalculateTax()
    {
        return Price * 0.1m;
    }
}

// View model (data specifically for a view)
public class ProductIndexViewModel
{
    public List<Product> Products { get; set; }
    public int TotalCount { get; set; }
    public decimal TotalValue { get; set; }
}
```

**Types of models**:
- **Domain Models**: Represent business entities (Product, Order, Customer)
- **View Models**: Data tailored for specific views
- **DTOs**: Data transfer between layers

### 3. View

**Views** are templates that generate HTML:

```cshtml
@* Razor syntax *@
@model ProductIndexViewModel

<h1>Products (@Model.TotalCount)</h1>

@foreach(var product in Model.Products)
{
    <div class="product">
        <h2>@product.Name</h2>
        <p>Price: $@product.Price</p>
        <p>Tax: $@product.CalculateTax()</p>
    </div>
}

<strong>Total Value: $@Model.TotalValue</strong>
```

**Razor features**:
- `@` transitions from HTML to C#
- `@model` specifies the type passed from controller
- `@Model` accesses the data
- Control flow: `@if`, `@foreach`, `@for`

### 4. Controller

**Controllers** handle requests and orchestrate Model/View:

```csharp
public class ProductsController : Controller
{
    private readonly IProductService _service;

    public ProductsController(IProductService service)
    {
        _service = service;
    }

    // GET: /Products
    public IActionResult Index()
    {
        var products = _service.GetAll();

        var viewModel = new ProductIndexViewModel
        {
            Products = products,
            TotalCount = products.Count,
            TotalValue = products.Sum(p => p.Price)
        };

        return View(viewModel);
    }

    // GET: /Products/Details/5
    public IActionResult Details(int id)
    {
        var product = _service.GetById(id);

        if (product == null)
            return NotFound();

        return View(product);
    }

    // POST: /Products/Create
    [HttpPost]
    public IActionResult Create(Product product)
    {
        if (!ModelState.IsValid)
            return View(product);

        _service.Create(product);
        return RedirectToAction(nameof(Index));
    }
}
```

### 5. Routing

**Convention-based routing**:

```csharp
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

// Examples:
// /Products         → ProductsController.Index()
// /Products/Details/5 → ProductsController.Details(5)
// /Home             → HomeController.Index()
// /                 → HomeController.Index() (default)
```

**Attribute routing**:

```csharp
[Route("products")]
public class ProductsController : Controller
{
    [Route("")]  // /products
    public IActionResult Index() { }

    [Route("{id}")]  // /products/5
    public IActionResult Details(int id) { }

    [Route("category/{category}")]  // /products/category/electronics
    public IActionResult Category(string category) { }
}
```

### 6. MVC vs Web API

| Aspect | MVC | Web API |
|--------|-----|---------|
| **Returns** | HTML (Views) | JSON/XML (Data) |
| **Base Class** | `Controller` | `ControllerBase` or `Controller` |
| **Attribute** | None required | `[ApiController]` |
| **Used For** | Server-rendered pages | RESTful APIs, SPAs |
| **Views** | Yes | No |
| **Content Negotiation** | No | Yes |

**Example MVC**:

```csharp
public class ProductsController : Controller  // Inherits Controller
{
    public IActionResult Index()
    {
        return View();  // Returns HTML
    }
}
```

**Example Web API**:

```csharp
[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase  // Inherits ControllerBase
{
    [HttpGet]
    public ActionResult<List<Product>> GetAll()
    {
        return Ok(products);  // Returns JSON
    }
}
```

### 7. Separation of Concerns

**Each component has ONE responsibility**:

| Component | Responsibility | Should NOT Do |
|-----------|----------------|---------------|
| **Model** | Data + business rules | Access database directly, HTML generation |
| **View** | Presentation | Business logic, data access |
| **Controller** | Request handling | HTML generation, complex business logic |

**Example of good separation**:

```csharp
// MODEL - Just data and business rules
public class Order
{
    public decimal Total { get; set; }

    public bool IsDiscountEligible()
    {
        return Total > 100;
    }
}

// CONTROLLER - Orchestration only
public class OrdersController : Controller
{
    public IActionResult Index()
    {
        var orders = _service.GetOrders();  // Service handles data access
        return View(orders);
    }
}

// VIEW - Presentation only
@foreach(var order in Model)
{
    <p>Total: $@order.Total</p>
    @if(order.IsDiscountEligible())
    {
        <span>Discount available!</span>
    }
}
```

---

## Installation Guide

**ASP.NET Core MVC is included in the .NET SDK** - no additional packages needed!

**Create new MVC project**:

```bash
# Using CLI
dotnet new mvc -n MyMvcApp
cd MyMvcApp
dotnet run

# Or use Visual Studio: File → New → Project → ASP.NET Core Web App (Model-View-Controller)
```

---

## Initial Setup & Configuration

### Project Structure

```
MyMvcApp/
├── Controllers/
│   ├── HomeController.cs
│   └── ProductsController.cs
├── Models/
│   └── Product.cs
├── Views/
│   ├── Home/
│   │   ├── Index.cshtml
│   │   └── Privacy.cshtml
│   ├── Products/
│   │   ├── Index.cshtml
│   │   └── Details.cshtml
│   ├── Shared/
│   │   ├── _Layout.cshtml
│   │   └── _ViewStart.cshtml
│   └── _ViewImports.cshtml
├── wwwroot/              # Static files (CSS, JS, images)
│   ├── css/
│   ├── js/
│   └── lib/
└── Program.cs
```

### Configuring MVC in Program.cs

```csharp
var builder = WebApplication.CreateBuilder(args);

// Add MVC services
builder.Services.AddControllersWithViews();

var app = builder.Build();

// Configure middleware
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();  // Serve CSS, JS, images from wwwroot
app.UseRouting();
app.UseAuthorization();

// Configure routing
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

---

## Basic Usage

### Example: Complete MVC Flow

**1. Create Model**:

```csharp
// Models/Product.cs
public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
    public string Category { get; set; }
}
```

**2. Create Controller**:

```csharp
// Controllers/ProductsController.cs
public class ProductsController : Controller
{
    // In-memory data (would normally come from database)
    private static List<Product> _products = new List<Product>
    {
        new Product { Id = 1, Name = "Laptop", Price = 999.99m, Category = "Electronics" },
        new Product { Id = 2, Name = "Mouse", Price = 29.99m, Category = "Electronics" },
        new Product { Id = 3, Name = "Keyboard", Price = 79.99m, Category = "Electronics" }
    };

    // GET: /Products
    public IActionResult Index()
    {
        return View(_products);
    }

    // GET: /Products/Details/1
    public IActionResult Details(int id)
    {
        var product = _products.FirstOrDefault(p => p.Id == id);

        if (product == null)
            return NotFound();

        return View(product);
    }

    // GET: /Products/Create
    public IActionResult Create()
    {
        return View();
    }

    // POST: /Products/Create
    [HttpPost]
    public IActionResult Create(Product product)
    {
        if (!ModelState.IsValid)
            return View(product);

        product.Id = _products.Max(p => p.Id) + 1;
        _products.Add(product);

        return RedirectToAction(nameof(Index));
    }
}
```

**3. Create Views**:

**Index.cshtml**:

```cshtml
@* Views/Products/Index.cshtml *@
@model List<Product>

<h1>Products</h1>

<a asp-action="Create" class="btn btn-primary">Create New</a>

<table class="table">
    <thead>
        <tr>
            <th>Name</th>
            <th>Price</th>
            <th>Category</th>
            <th></th>
        </tr>
    </thead>
    <tbody>
        @foreach(var product in Model)
        {
            <tr>
                <td>@product.Name</td>
                <td>$@product.Price</td>
                <td>@product.Category</td>
                <td>
                    <a asp-action="Details" asp-route-id="@product.Id">Details</a>
                </td>
            </tr>
        }
    </tbody>
</table>
```

**Details.cshtml**:

```cshtml
@* Views/Products/Details.cshtml *@
@model Product

<h1>Product Details</h1>

<dl class="row">
    <dt class="col-sm-3">Name</dt>
    <dd class="col-sm-9">@Model.Name</dd>

    <dt class="col-sm-3">Price</dt>
    <dd class="col-sm-9">$@Model.Price</dd>

    <dt class="col-sm-3">Category</dt>
    <dd class="col-sm-9">@Model.Category</dd>
</dl>

<a asp-action="Index">Back to List</a>
```

**Create.cshtml**:

```cshtml
@* Views/Products/Create.cshtml *@
@model Product

<h1>Create Product</h1>

<form asp-action="Create" method="post">
    <div class="form-group">
        <label asp-for="Name"></label>
        <input asp-for="Name" class="form-control" />
        <span asp-validation-for="Name" class="text-danger"></span>
    </div>

    <div class="form-group">
        <label asp-for="Price"></label>
        <input asp-for="Price" class="form-control" />
        <span asp-validation-for="Price" class="text-danger"></span>
    </div>

    <div class="form-group">
        <label asp-for="Category"></label>
        <input asp-for="Category" class="form-control" />
        <span asp-validation-for="Category" class="text-danger"></span>
    </div>

    <button type="submit" class="btn btn-primary">Create</button>
    <a asp-action="Index" class="btn btn-secondary">Cancel</a>
</form>

@section Scripts {
    @{await Html.RenderPartialAsync("_ValidationScriptsPartial");}
}
```

---

## Testing & Validation

### Testing Controllers

```csharp
using Xunit;

public class ProductsControllerTests
{
    [Fact]
    public void Index_ReturnsViewWithProducts()
    {
        // Arrange
        var controller = new ProductsController();

        // Act
        var result = controller.Index() as ViewResult;

        // Assert
        Assert.NotNull(result);
        var model = Assert.IsAssignableFrom<List<Product>>(result.Model);
        Assert.True(model.Count > 0);
    }

    [Fact]
    public void Details_WithValidId_ReturnsProduct()
    {
        // Arrange
        var controller = new ProductsController();

        // Act
        var result = controller.Details(1) as ViewResult;

        // Assert
        Assert.NotNull(result);
        var model = Assert.IsType<Product>(result.Model);
        Assert.Equal(1, model.Id);
    }

    [Fact]
    public void Details_WithInvalidId_ReturnsNotFound()
    {
        // Arrange
        var controller = new ProductsController();

        // Act
        var result = controller.Details(999);

        // Assert
        Assert.IsType<NotFoundResult>(result);
    }
}
```

---

## Practical Examples

### Example: View Models for Complex Views

```csharp
// View Model
public class ProductDashboardViewModel
{
    public List<Product> Products { get; set; }
    public List<string> Categories { get; set; }
    public int TotalProducts { get; set; }
    public decimal TotalValue { get; set; }
    public Product FeaturedProduct { get; set; }
}

// Controller
public IActionResult Dashboard()
{
    var products = _service.GetAll();

    var viewModel = new ProductDashboardViewModel
    {
        Products = products,
        Categories = products.Select(p => p.Category).Distinct().ToList(),
        TotalProducts = products.Count,
        TotalValue = products.Sum(p => p.Price),
        FeaturedProduct = products.OrderByDescending(p => p.Price).FirstOrDefault()
    };

    return View(viewModel);
}

// View
@model ProductDashboardViewModel

<h1>Dashboard</h1>

<div class="row">
    <div class="col-md-3">
        <div class="card">
            <div class="card-body">
                <h5>Total Products</h5>
                <p>@Model.TotalProducts</p>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card">
            <div class="card-body">
                <h5>Total Value</h5>
                <p>$@Model.TotalValue</p>
            </div>
        </div>
    </div>
</div>

<h2>Featured Product</h2>
<p>@Model.FeaturedProduct?.Name - $@Model.FeaturedProduct?.Price</p>
```

---

## Common Patterns & Best Practices

### 1. Use View Models

**Good**:
```csharp
public class ProductEditViewModel
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
    public List<SelectListItem> Categories { get; set; }  // For dropdown
}
```

### 2. Keep Controllers Thin

```csharp
// GOOD - Thin controller
public IActionResult Index()
{
    var products = _service.GetAll();  // Service handles logic
    return View(products);
}

// BAD - Fat controller
public IActionResult Index()
{
    // Don't put all this in controller!
    using var context = new AppDbContext();
    var products = context.Products
        .Include(p => p.Category)
        .Where(p => !p.IsDeleted)
        .OrderBy(p => p.Name)
        .ToList();

    // Complex business logic...
    foreach(var product in products)
    {
        product.Price = product.Price * 1.1m;
    }

    return View(products);
}
```

### 3. Use Strongly-Typed Views

```cshtml
@* GOOD *@
@model Product
<h1>@Model.Name</h1>

@* BAD *@
@* @{var product = ViewBag.Product;} *@
@* <h1>@product.Name</h1> *@
```

---

## Troubleshooting

### Issue 1: View Not Found

**Symptom**: "The view 'Index' was not found"

**Cause**: View file missing or in wrong location.

**Solution**: Ensure view is at `Views/{Controller}/{Action}.cshtml`:

```
Views/
└── Products/
    └── Index.cshtml  ← Must match controller and action names
```

### Issue 2: Model is Null in View

**Symptom**: `NullReferenceException` when accessing `@Model`

**Cause**: Controller didn't pass data to view.

**Solution**:

```csharp
// Pass data to view
return View(products);  // Not just View()
```

---

## Additional Resources

- [ASP.NET Core MVC Overview](https://learn.microsoft.com/en-us/aspnet/core/mvc/overview) - Official documentation
- [MVC Tutorial](https://learn.microsoft.com/en-us/aspnet/core/tutorials/first-mvc-app/start-mvc) - Step-by-step guide

---

## Self-Assessment Checklist

- [ ] Understand Model, View, Controller roles
- [ ] Create controllers that inherit from `Controller`
- [ ] Create models for data
- [ ] Create Razor views
- [ ] Use `@model` and `@Model` in views
- [ ] Configure routing
- [ ] Pass data from controller to view
- [ ] Understand MVC vs Web API differences

---

## Summary

**MVC** separates applications into Model (data), View (UI), and Controller (logic) for better organization, testability, and maintainability. Use MVC for server-rendered web applications, and Web API for RESTful services.

**Next Steps**:
- Build a simple MVC application
- Explore Razor syntax
- Learn about layouts and partial views
- Study model binding and validation

Happy coding with MVC!
