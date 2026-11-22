# Controllers and Routing in ASP.NET Core

---
**Technology Version**: ASP.NET Core 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-22
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What are Controllers and Routing?

Controllers and Routing are fundamental concepts in ASP.NET Core that work together to handle incoming HTTP requests and direct them to the appropriate code in your application.

**Controllers** are C# classes that contain action methods. Each action method handles a specific HTTP request and returns an appropriate response. Think of controllers as the "traffic controllers" of your application - they receive requests, process them, and send back responses.

**Routing** is the system that matches incoming HTTP requests to specific controller actions. It's like a GPS that maps URLs to the correct destination in your code.

Together, they form the foundation of how your ASP.NET Core API communicates with the outside world.

### Why Use Controllers and Routing?

You should use Controllers and Routing when:
- **Building Web APIs** - Controllers handle API endpoints and return data (usually JSON)
- **Organizing Request Logic** - Controllers keep your request-handling code organized and maintainable
- **Creating RESTful Services** - Routing helps you create clean, meaningful URLs that follow REST principles
- **Handling Different HTTP Methods** - Controllers allow you to respond differently to GET, POST, PUT, DELETE requests
- **Validating and Processing Input** - Controllers are the entry point where you can validate incoming data

### When to Use It

**Good use cases:**
- Building RESTful APIs for mobile apps or SPAs (Single Page Applications)
- Creating backend services that handle CRUD operations (Create, Read, Update, Delete)
- Organizing endpoint logic in a scalable way
- Implementing APIs that follow industry-standard practices

**Not recommended for:**
- Simple static file serving (use static file middleware instead)
- Real-time bidirectional communication (consider SignalR for websockets)
- Background processing tasks (use hosted services or background workers)

---

## 2. Quick Start

**TL;DR - Get started in 5 minutes:**

```bash
# Navigate to your project directory
cd MyApiProject

# Create a new controller
dotnet new apicontroller -n ProductsController -o Controllers
```

**Minimal Controller Example:**

```csharp
using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll()
    {
        return Ok(new[] { "Product1", "Product2", "Product3" });
    }

    [HttpGet("{id}")]
    public IActionResult GetById(int id)
    {
        return Ok($"Product {id}");
    }
}
```

**Test it:**
```bash
# Start your application
dotnet run

# In another terminal or browser, access:
# GET https://localhost:5001/api/products
# GET https://localhost:5001/api/products/1
```

**Expected output:**
```json
// GET /api/products
["Product1", "Product2", "Product3"]

// GET /api/products/1
"Product 1"
```

For detailed explanations, continue reading the sections below.

---

## 3. Prerequisites

### Required Knowledge
- **C# Basics** - Understanding of classes, methods, and attributes
- **HTTP Fundamentals** - Knowledge of HTTP methods (GET, POST, PUT, DELETE) and status codes
- **REST API Principles** - Basic understanding of RESTful design
- **ASP.NET Core Basics** - You should have created at least one Web API project

### Required Software/Tools
- **.NET SDK** - Version 8.0 or higher
  - Installation: https://dotnet.microsoft.com/download
- **Code Editor** - Visual Studio, VS Code, or JetBrains Rider
- **API Testing Tool** - Postman, Insomnia, or curl (optional but recommended)

### System Requirements
- **Operating System**: Windows 10+, macOS 11+, or Linux
- **RAM**: 4GB minimum (8GB recommended)
- **Disk Space**: 2GB for .NET SDK and tools

---

## 4. Core Concepts & Theory

### Key Concepts

#### Concept 1: What is a Controller?

A **Controller** is a C# class that inherits from `ControllerBase` (for APIs) or `Controller` (for MVC).  It groups related HTTP request handlers (action methods) together.

**Simple analogy**: Imagine a restaurant. The Controller is like a waiter who:
- Takes orders (receives HTTP requests)
- Communicates with the kitchen (calls services/repositories)
- Brings food back (returns HTTP responses)

**Key characteristics:**
- Controllers are classes with the `[ApiController]` attribute (for Web APIs)
- They contain action methods that respond to HTTP requests
- Each action method typically handles one specific endpoint
- Controllers use dependency injection to access services

#### Concept 2: ControllerBase vs Controller

ASP.NET Core provides two base classes for controllers:

| Feature | ControllerBase | Controller |
|---------|---------------|------------|
| **Purpose** | Web APIs (JSON responses) | MVC Views (HTML responses) |
| **View Support** | ❌ No | ✅ Yes |
| **Size** | Lightweight | Heavier (includes view features) |
| **Use When** | Building REST APIs | Building server-rendered web pages |

**For Web APIs, always use `ControllerBase`** - it's lighter and doesn't include unnecessary view-related functionality.

```csharp
// API Controller - use ControllerBase
public class ProductsController : ControllerBase
{
    // Returns JSON
}

// MVC Controller - use Controller
public class HomeController : Controller
{
    // Returns HTML views
}
```

#### Concept 3: What is Routing?

**Routing** is the process of matching an incoming HTTP request URL to a specific controller action.

**Example:**
```
HTTP Request: GET https://api.example.com/api/products/5

Routing breaks this down:
- Scheme: https
- Host: api.example.com
- Path: /api/products/5
         ↓
Routes to: ProductsController.GetById(5)
```

#### Concept 4: Types of Routing

ASP.NET Core supports two routing approaches:

**1. Conventional Routing** (Mostly used in MVC, not APIs)
```csharp
// In Program.cs
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");
```

**2. Attribute Routing** (Recommended for APIs ✅)
```csharp
[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    [HttpGet]              // Matches: GET /api/products
    [HttpGet("{id}")]      // Matches: GET /api/products/5
    [HttpPost]             // Matches: POST /api/products
}
```

**For Web APIs, always use attribute routing** - it's more explicit, flexible, and follows REST conventions better.

#### Concept 5: Action Methods

An **Action Method** is a public method in a controller that handles an HTTP request.

```csharp
// This is an action method
[HttpGet("{id}")]
public IActionResult GetProductById(int id)
{
    // 1. Receives request for /api/products/5
    // 2. id parameter automatically populated with 5
    // 3. Processes the request
    // 4. Returns a response
    return Ok(new { Id = id, Name = "Product" });
}
```

**Key points:**
- Must be `public`
- Returns `IActionResult` or a specific result type
- Can have parameters (from route, query string, body)
- Decorated with HTTP verb attributes (`[HttpGet]`, `[HttpPost]`, etc.)

#### Concept 6: HTTP Verb Attributes

HTTP verb attributes tell the routing system which HTTP method an action responds to:

| Attribute | HTTP Method | Purpose | Example URL |
|-----------|------------|---------|-------------|
| `[HttpGet]` | GET | Retrieve data | GET /api/products |
| `[HttpPost]` | POST | Create new data | POST /api/products |
| `[HttpPut]` | PUT | Update existing data (full) | PUT /api/products/5 |
| `[HttpPatch]` | PATCH | Update existing data (partial) | PATCH /api/products/5 |
| `[HttpDelete]` | DELETE | Delete data | DELETE /api/products/5 |

```csharp
[HttpGet]        // Responds to GET requests only
public IActionResult GetAll() { ... }

[HttpPost]       // Responds to POST requests only
public IActionResult Create() { ... }

[HttpPut("{id}")] // Responds to PUT requests only
public IActionResult Update(int id) { ... }
```

#### Concept 7: Route Templates

A **Route Template** defines the URL pattern that maps to a controller action.

**Route template syntax:**
```
[Route("api/products/{id}")]
         │      │       │
         │      │       └─ Route parameter (variable)
         │      └───────── Literal segment
         └──────────────── Literal segment
```

**Examples:**
```csharp
[Route("api/products")]           // Matches: /api/products
[Route("api/products/{id}")]      // Matches: /api/products/5
[Route("api/products/{id}/reviews")] // Matches: /api/products/5/reviews
```

#### Concept 8: Route Parameters

Route parameters capture values from the URL and pass them to action methods.

**Types of route parameters:**

**1. Required Parameters:**
```csharp
[HttpGet("{id}")]               // {id} is required
public IActionResult Get(int id) // Must provide: /api/products/5
```

**2. Optional Parameters:**
```csharp
[HttpGet("{id?}")]              // {id} is optional
public IActionResult Get(int? id) // Can use: /api/products or /api/products/5
```

**3. Default Values:**
```csharp
[HttpGet("{page=1}")]           // {page} defaults to 1
public IActionResult Get(int page) // /api/products uses page=1
```

**4. Multiple Parameters:**
```csharp
[HttpGet("{category}/{id}")]
public IActionResult Get(string category, int id)
// Matches: /api/products/electronics/5
```

#### Concept 9: Route Constraints

Route constraints restrict what values a route parameter can accept.

**Common constraints:**

```csharp
[HttpGet("{id:int}")]         // id must be an integer
[HttpGet("{id:min(1)}")]      // id must be at least 1
[HttpGet("{id:range(1,100)}")] // id must be between 1 and 100
[HttpGet("{code:alpha}")]     // code must contain only letters
[HttpGet("{code:length(5)}")]  // code must be exactly 5 characters
[HttpGet("{name:minlength(3)}")] // name must be at least 3 characters
```

**Example:**
```csharp
[HttpGet("{id:int:min(1)}")]  // Multiple constraints
public IActionResult Get(int id)
{
    // This action only matches if id is a positive integer
    // /api/products/5 ✅ matches
    // /api/products/0 ❌ doesn't match
    // /api/products/abc ❌ doesn't match
}
```

---

## 5. Installation Guide

Controllers and Routing are built into ASP.NET Core - no additional installation needed! They're included when you create a new Web API project.

### Verify Your Setup

```bash
# Check .NET SDK version
dotnet --version
# Should show 8.0.0 or higher

# Create a new Web API project (if you haven't already)
dotnet new webapi -n MyApiProject
cd MyApiProject

# The project already includes Controllers and Routing configured!
```

### Project Structure

When you create a new Web API project, you'll see:

```
MyApiProject/
├── Controllers/           ← Controllers go here
│   └── WeatherForecastController.cs  (example)
├── Program.cs            ← Routing configured here
├── appsettings.json
└── MyApiProject.csproj
```

---

## 6. Initial Setup & Configuration

### Step 1: Configure Routing in Program.cs

ASP.NET Core 6+ uses a minimal hosting model. Here's how routing is configured:

```csharp
// Program.cs
var builder = WebApplication.CreateBuilder(args);

// Add controllers to the dependency injection container
builder.Services.AddControllers();

var app = builder.Build();

// Configure the HTTP request pipeline
app.UseHttpsRedirection();
app.UseAuthorization();

// Map controller routes
app.MapControllers();  // ← This enables attribute routing

app.Run();
```

**What does `app.MapControllers()` do?**
- Scans your project for controllers
- Registers all action methods with their routes
- Enables the routing middleware to match requests to actions

### Step 2: Create the Controllers Folder

If it doesn't exist, create a `Controllers` folder in your project root:

```bash
mkdir Controllers
```

### Step 3: Understand the [ApiController] Attribute

The `[ApiController]` attribute provides automatic features:

```csharp
[ApiController]  // ← Add this attribute to API controllers
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    // Automatic features enabled:
    // ✅ Automatic 400 response for validation errors
    // ✅ Automatic binding source inference
    // ✅ Automatic problem details for errors
}
```

**Benefits:**
- Automatic model validation (returns 400 Bad Request if validation fails)
- Infers binding sources (from route, query, body) automatically
- Better error responses with problem details
- Makes your API more consistent

---

## 7. Basic Usage

### Example 1: Simple GET Endpoint

Create a basic controller that returns a list of products:

```csharp
using Microsoft.AspNetCore.Mvc;

namespace MyApiProject.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll()
    {
        var products = new[]
        {
            new { Id = 1, Name = "Laptop", Price = 999.99 },
            new { Id = 2, Name = "Mouse", Price = 29.99 },
            new { Id = 3, Name = "Keyboard", Price = 79.99 }
        };

        return Ok(products);
    }
}
```

**Test it:**
```bash
# Start the app
dotnet run

# In another terminal or browser:
curl https://localhost:5001/api/products
```

**Response:**
```json
[
  {"id":1,"name":"Laptop","price":999.99},
  {"id":2,"name":"Mouse","price":29.99},
  {"id":3,"name":"Keyboard","price":79.99}
]
```

### Example 2: GET with Route Parameter

Get a single product by ID:

```csharp
[HttpGet("{id}")]
public IActionResult GetById(int id)
{
    // Simulate finding a product
    var product = new { Id = id, Name = $"Product {id}", Price = 99.99 };

    return Ok(product);
}
```

**Test it:**
```bash
curl https://localhost:5001/api/products/5
```

**Response:**
```json
{"id":5,"name":"Product 5","price":99.99}
```

**URL breakdown:**
```
https://localhost:5001/api/products/5
                      └───┬───┘ └─┬─┘
                     Controller  Route
                     "products"  param
                                 id=5
```

### Example 3: POST to Create Data

Create a new product:

```csharp
[HttpPost]
public IActionResult Create([FromBody] Product product)
{
    // Validate (automatic with [ApiController])
    if (!ModelState.IsValid)
    {
        return BadRequest(ModelState);
    }

    // Simulate saving
    product.Id = 123; // Assigned by database

    // Return 201 Created with location header
    return CreatedAtAction(
        nameof(GetById),     // Action name
        new { id = product.Id }, // Route values
        product              // Body
    );
}

// Product class
public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
}
```

**Test it:**
```bash
curl -X POST https://localhost:5001/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"New Product","price":149.99}'
```

**Response:**
```
HTTP/1.1 201 Created
Location: https://localhost:5001/api/products/123
Content-Type: application/json

{"id":123,"name":"New Product","price":149.99}
```

### Example 4: PUT to Update Data

Update an existing product:

```csharp
[HttpPut("{id}")]
public IActionResult Update(int id, [FromBody] Product product)
{
    if (id != product.Id)
    {
        return BadRequest("ID mismatch");
    }

    // Simulate updating
    // In real app: _repository.Update(product);

    return NoContent(); // 204 No Content
}
```

**Test it:**
```bash
curl -X PUT https://localhost:5001/api/products/5 \
  -H "Content-Type: application/json" \
  -d '{"id":5,"name":"Updated Product","price":199.99}'
```

**Response:**
```
HTTP/1.1 204 No Content
```

### Example 5: DELETE

Delete a product:

```csharp
[HttpDelete("{id}")]
public IActionResult Delete(int id)
{
    // Simulate deleting
    // In real app: _repository.Delete(id);

    return NoContent(); // 204 No Content
}
```

**Test it:**
```bash
curl -X DELETE https://localhost:5001/api/products/5
```

**Response:**
```
HTTP/1.1 204 No Content
```

---

## 8. Testing & Validation

### Exercise 1: Create a Basic Controller (Beginner)

**Objective:** Create a simple Books API controller.

**Requirements:**
1. Create a `BooksController` in the Controllers folder
2. Add a GET endpoint that returns a list of book titles
3. Use the route `/api/books`

<details>
<summary>💡 Hint</summary>

- Inherit from `ControllerBase`
- Add `[ApiController]` and `[Route("api/[controller]")]`
- Create an action method with `[HttpGet]`
- Return `Ok()` with an array of book titles

</details>

<details>
<summary>✅ Solution</summary>

```csharp
using Microsoft.AspNetCore.Mvc;

namespace MyApiProject.Controllers;

[ApiController]
[Route("api/[controller]")]
public class BooksController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll()
    {
        var books = new[]
        {
            "The Great Gatsby",
            "1984",
            "To Kill a Mockingbird"
        };

        return Ok(books);
    }
}
```

**Test it:**
```bash
curl https://localhost:5001/api/books
```

**Why this solution works:**
- `[ApiController]` enables automatic API features
- `[Route("api/[controller]")]` creates the route `/api/books`
- `[HttpGet]` makes this respond to GET requests
- `Ok()` returns HTTP 200 with the array serialized as JSON

</details>

### Exercise 2: Add Route Parameters (Intermediate)

**Objective:** Add an endpoint to get a single book by ID.

**Requirements:**
1. Add a new action method to `BooksController`
2. Use route parameter `{id}`
3. Return book details for the given ID
4. Route should be: `/api/books/{id}`

<details>
<summary>💡 Hint</summary>

- Use `[HttpGet("{id}")]`
- Add an `int id` parameter to the method
- Return `Ok()` with book details
- Consider: what should happen if ID is invalid?

</details>

<details>
<summary>✅ Solution</summary>

```csharp
[HttpGet("{id}")]
public IActionResult GetById(int id)
{
    // Simulate a book database
    var books = new Dictionary<int, object>
    {
        { 1, new { Id = 1, Title = "The Great Gatsby", Author = "F. Scott Fitzgerald" } },
        { 2, new { Id = 2, Title = "1984", Author = "George Orwell" } },
        { 3, new { Id = 3, Title = "To Kill a Mockingbird", Author = "Harper Lee" } }
    };

    if (!books.ContainsKey(id))
    {
        return NotFound($"Book with ID {id} not found");
    }

    return Ok(books[id]);
}
```

**Test it:**
```bash
# Valid ID
curl https://localhost:5001/api/books/1

# Invalid ID
curl https://localhost:5001/api/books/999
```

**Why this solution works:**
- `{id}` captures the ID from the URL
- The method parameter `int id` automatically receives the value
- `NotFound()` returns HTTP 404 when book doesn't exist
- `Ok()` returns HTTP 200 with the book data

</details>

### Exercise 3: Add Route Constraints (Challenge)

**Objective:** Create an endpoint with route constraints and multiple parameters.

**Requirements:**
1. Create endpoint: `/api/books/{category}/{year}`
2. `category` must be alphabetic (alpha constraint)
3. `year` must be an integer between 1900-2100
4. Return books filtered by category and year

<details>
<summary>💡 Hint</summary>

- Use `[HttpGet("{category:alpha}/{year:int:range(1900,2100)}")]`
- Both parameters should be in the method signature
- Return filtered results based on both parameters

</details>

<details>
<summary>✅ Solution</summary>

```csharp
[HttpGet("{category:alpha}/{year:int:range(1900,2100)}")]
public IActionResult GetByCategoryAndYear(string category, int year)
{
    // Simulate filtered books
    var books = new[]
    {
        new { Id = 1, Title = "1984", Category = "Fiction", Year = 1949 },
        new { Id = 2, Title = "Sapiens", Category = "History", Year = 2011 },
        new { Id = 3, Title = "Clean Code", Category = "Technology", Year = 2008 }
    };

    var filtered = books.Where(b =>
        b.Category.Equals(category, StringComparison.OrdinalIgnoreCase) &&
        b.Year == year
    ).ToArray();

    if (filtered.Length == 0)
    {
        return NotFound($"No books found for category '{category}' in year {year}");
    }

    return Ok(filtered);
}
```

**Test it:**
```bash
# Valid request
curl https://localhost:5001/api/books/fiction/1949

# Invalid year (out of range) - 404 Not Found from routing
curl https://localhost:5001/api/books/fiction/1800

# Invalid category (numbers) - 404 Not Found from routing
curl https://localhost:5001/api/books/123/2000
```

**Why this solution works:**
- `:alpha` ensures category contains only letters
- `:int:range(1900,2100)` ensures year is a valid integer in range
- Invalid constraints result in 404 from routing (before action is called)
- LINQ filters the results based on category and year
- Case-insensitive comparison for category

</details>

### Self-Assessment Checklist

After completing the exercises, verify you can:

- [ ] Create a controller that inherits from `ControllerBase`
- [ ] Add `[ApiController]` and `[Route]` attributes
- [ ] Create GET endpoints that return data
- [ ] Use route parameters like `{id}`
- [ ] Apply route constraints
- [ ] Return appropriate HTTP status codes (`Ok`, `NotFound`, `BadRequest`)
- [ ] Handle multiple parameters in a route
- [ ] Test endpoints using curl or Postman

---

## 9. Practical Examples

### Example 1: RESTful CRUD API

Here's a complete CRUD controller for a Todo API:

```csharp
using Microsoft.AspNetCore.Mvc;

namespace MyApiProject.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TodosController : ControllerBase
{
    // In-memory storage (use a real database in production!)
    private static List<Todo> _todos = new()
    {
        new Todo { Id = 1, Title = "Learn ASP.NET Core", IsComplete = false },
        new Todo { Id = 2, Title = "Build an API", IsComplete = false }
    };
    private static int _nextId = 3;

    // GET: api/todos
    [HttpGet]
    public IActionResult GetAll()
    {
        return Ok(_todos);
    }

    // GET: api/todos/5
    [HttpGet("{id:int}")]
    public IActionResult GetById(int id)
    {
        var todo = _todos.FirstOrDefault(t => t.Id == id);
        if (todo == null)
        {
            return NotFound(new { Message = $"Todo with ID {id} not found" });
        }
        return Ok(todo);
    }

    // POST: api/todos
    [HttpPost]
    public IActionResult Create([FromBody] TodoCreateDto dto)
    {
        var todo = new Todo
        {
            Id = _nextId++,
            Title = dto.Title,
            IsComplete = false
        };

        _todos.Add(todo);

        return CreatedAtAction(nameof(GetById), new { id = todo.Id }, todo);
    }

    // PUT: api/todos/5
    [HttpPut("{id:int}")]
    public IActionResult Update(int id, [FromBody] TodoUpdateDto dto)
    {
        var todo = _todos.FirstOrDefault(t => t.Id == id);
        if (todo == null)
        {
            return NotFound(new { Message = $"Todo with ID {id} not found" });
        }

        todo.Title = dto.Title;
        todo.IsComplete = dto.IsComplete;

        return NoContent();
    }

    // DELETE: api/todos/5
    [HttpDelete("{id:int}")]
    public IActionResult Delete(int id)
    {
        var todo = _todos.FirstOrDefault(t => t.Id == id);
        if (todo == null)
        {
            return NotFound(new { Message = $"Todo with ID {id} not found" });
        }

        _todos.Remove(todo);
        return NoContent();
    }
}

// Models
public class Todo
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public bool IsComplete { get; set; }
}

public class TodoCreateDto
{
    public string Title { get; set; } = string.Empty;
}

public class TodoUpdateDto
{
    public string Title { get; set; } = string.Empty;
    public bool IsComplete { get; set; }
}
```

**Usage:**
```bash
# Get all todos
curl https://localhost:5001/api/todos

# Get specific todo
curl https://localhost:5001/api/todos/1

# Create new todo
curl -X POST https://localhost:5001/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"New Task"}'

# Update todo
curl -X PUT https://localhost:5001/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated Task","isComplete":true}'

# Delete todo
curl -X DELETE https://localhost:5001/api/todos/1
```

### Example 2: Query String Parameters

Handle filtering and pagination with query strings:

```csharp
[HttpGet]
public IActionResult GetAll(
    [FromQuery] string? search = null,
    [FromQuery] int page = 1,
    [FromQuery] int pageSize = 10)
{
    var query = _todos.AsQueryable();

    // Filter by search term
    if (!string.IsNullOrEmpty(search))
    {
        query = query.Where(t => t.Title.Contains(search, StringComparison.OrdinalIgnoreCase));
    }

    // Pagination
    var totalItems = query.Count();
    var items = query
        .Skip((page - 1) * pageSize)
        .Take(pageSize)
        .ToList();

    var result = new
    {
        TotalItems = totalItems,
        Page = page,
        PageSize = pageSize,
        Items = items
    };

    return Ok(result);
}
```

**Usage:**
```bash
# Get all todos
curl https://localhost:5001/api/todos

# Search for todos
curl https://localhost:5001/api/todos?search=learn

# Pagination
curl https://localhost:5001/api/todos?page=2&pageSize=5

# Combined
curl https://localhost:5001/api/todos?search=api&page=1&pageSize=10
```

### Example 3: Nested Routes

Create related resource endpoints:

```csharp
// ProductsController.cs
[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    // GET: api/products/5/reviews
    [HttpGet("{productId:int}/reviews")]
    public IActionResult GetReviews(int productId)
    {
        var reviews = new[]
        {
            new { Id = 1, ProductId = productId, Rating = 5, Comment = "Great!" },
            new { Id = 2, ProductId = productId, Rating = 4, Comment = "Good" }
        };

        return Ok(reviews);
    }

    // POST: api/products/5/reviews
    [HttpPost("{productId:int}/reviews")]
    public IActionResult AddReview(int productId, [FromBody] ReviewDto review)
    {
        var newReview = new
        {
            Id = 123,
            ProductId = productId,
            Rating = review.Rating,
            Comment = review.Comment
        };

        return CreatedAtAction(nameof(GetReviewById),
            new { productId, reviewId = newReview.Id },
            newReview);
    }

    // GET: api/products/5/reviews/10
    [HttpGet("{productId:int}/reviews/{reviewId:int}")]
    public IActionResult GetReviewById(int productId, int reviewId)
    {
        var review = new
        {
            Id = reviewId,
            ProductId = productId,
            Rating = 5,
            Comment = "Great product!"
        };

        return Ok(review);
    }
}

public class ReviewDto
{
    public int Rating { get; set; }
    public string Comment { get; set; } = string.Empty;
}
```

**Usage:**
```bash
# Get all reviews for product 5
curl https://localhost:5001/api/products/5/reviews

# Add review to product 5
curl -X POST https://localhost:5001/api/products/5/reviews \
  -H "Content-Type: application/json" \
  -d '{"rating":5,"comment":"Excellent!"}'

# Get specific review
curl https://localhost:5001/api/products/5/reviews/10
```

### Example 4: Custom Route Names

Use custom routes instead of [controller] token:

```csharp
[ApiController]
[Route("api/v1/catalog/items")] // Custom route
public class ProductsController : ControllerBase
{
    // GET: api/v1/catalog/items
    [HttpGet]
    public IActionResult GetAll()
    {
        return Ok(new[] { "Product1", "Product2" });
    }

    // GET: api/v1/catalog/items/5
    [HttpGet("{id:int}")]
    public IActionResult GetById(int id)
    {
        return Ok(new { Id = id, Name = $"Product {id}" });
    }

    // GET: api/v1/catalog/items/search
    [HttpGet("search")] // Additional literal segment
    public IActionResult Search([FromQuery] string term)
    {
        return Ok(new[] { $"Search results for: {term}" });
    }
}
```

**Usage:**
```bash
# Custom route
curl https://localhost:5001/api/v1/catalog/items

# With ID
curl https://localhost:5001/api/v1/catalog/items/5

# Search endpoint
curl https://localhost:5001/api/v1/catalog/items/search?term=laptop
```

---

## 10. Common Patterns & Best Practices

### Pattern 1: RESTful URL Design

Follow REST conventions for clean, predictable APIs:

```csharp
// ✅ GOOD - RESTful routes
[Route("api/products")]
[HttpGet]                     // GET /api/products
[HttpGet("{id}")]             // GET /api/products/5
[HttpPost]                    // POST /api/products
[HttpPut("{id}")]             // PUT /api/products/5
[HttpDelete("{id}")]          // DELETE /api/products/5

// ❌ BAD - Non-RESTful routes
[HttpGet("get-all-products")] // GET /api/products/get-all-products
[HttpPost("add-product")]     // POST /api/products/add-product
[HttpGet("delete-product/{id}")] // GET /api/products/delete-product/5 (should be DELETE!)
```

**Key principles:**
- Use nouns, not verbs in URLs (`/products`, not `/getProducts`)
- Use HTTP verbs to indicate actions (GET, POST, PUT, DELETE)
- Use plural nouns for collections (`/products`, not `/product`)
- Use hierarchies for related resources (`/products/5/reviews`)

### Pattern 2: Consistent Response Formats

Return consistent response structures:

```csharp
// ✅ GOOD - Consistent responses
[HttpGet("{id}")]
public IActionResult GetById(int id)
{
    var product = _repository.GetById(id);

    if (product == null)
    {
        return NotFound(new { Message = $"Product {id} not found" });
    }

    return Ok(product);
}

[HttpPost]
public IActionResult Create([FromBody] ProductDto dto)
{
    if (!ModelState.IsValid)
    {
        return BadRequest(ModelState);
    }

    var product = _repository.Create(dto);
    return CreatedAtAction(nameof(GetById), new { id = product.Id }, product);
}
```

### Pattern 3: Use ActionResult<T> for Type Safety

ASP.NET Core 2.1+ supports `ActionResult<T>` for better IntelliSense and documentation:

```csharp
// ✅ BETTER - Strongly-typed ActionResult
[HttpGet("{id}")]
public ActionResult<Product> GetById(int id)
{
    var product = _repository.GetById(id);

    if (product == null)
    {
        return NotFound(); // Still returns IActionResult
    }

    return product; // Implicit conversion to ActionResult<Product>
}

// Benefits:
// - Swagger automatically knows return type is Product
// - Better IntelliSense
// - Type safety
```

### Pattern 4: Use Route Constraints

Always use route constraints to prevent ambiguous routes:

```csharp
// ✅ GOOD - Constraints prevent ambiguity
[HttpGet("{id:int}")]           // Only matches integers
public IActionResult GetById(int id) { }

[HttpGet("{code:alpha}")]       // Only matches letters
public IActionResult GetByCode(string code) { }

// ❌ BAD - Ambiguous routes
[HttpGet("{id}")]
public IActionResult GetById(string id) { }

[HttpGet("{code}")]
public IActionResult GetByCode(string code) { }
// Which action should handle /api/products/abc?
```

### Pattern 5: Naming Conventions

Follow consistent naming patterns:

```csharp
// ✅ GOOD - Clear, conventional names
public class ProductsController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll() { }           // List all

    [HttpGet("{id}")]
    public IActionResult GetById(int id) { }    // Get one

    [HttpPost]
    public IActionResult Create([FromBody] ProductDto dto) { }

    [HttpPut("{id}")]
    public IActionResult Update(int id, [FromBody] ProductDto dto) { }

    [HttpDelete("{id}")]
    public IActionResult Delete(int id) { }
}
```

### Pattern 6: Use [FromBody], [FromQuery], [FromRoute] Explicitly (Optional)

While `[ApiController]` infers binding sources, explicit attributes improve readability:

```csharp
// Explicit binding (more readable, but optional with [ApiController])
[HttpPut("{id}")]
public IActionResult Update(
    [FromRoute] int id,              // From URL
    [FromBody] ProductDto dto,       // From request body
    [FromQuery] bool notify = false) // From query string
{
    // Update product and optionally send notification
}

// Usage:
// PUT /api/products/5?notify=true
// Body: {"name":"Updated Product","price":99.99}
```

### Pattern 7: Return Appropriate Status Codes

Use the right status code for each scenario:

```csharp
public class ProductsController : ControllerBase
{
    [HttpGet("{id}")]
    public IActionResult GetById(int id)
    {
        var product = _repository.GetById(id);

        if (product == null)
            return NotFound();  // 404 Not Found

        return Ok(product);     // 200 OK
    }

    [HttpPost]
    public IActionResult Create([FromBody] ProductDto dto)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState); // 400 Bad Request

        var product = _repository.Create(dto);
        return CreatedAtAction(nameof(GetById), new { id = product.Id }, product); // 201 Created
    }

    [HttpPut("{id}")]
    public IActionResult Update(int id, [FromBody] ProductDto dto)
    {
        var product = _repository.GetById(id);

        if (product == null)
            return NotFound(); // 404 Not Found

        _repository.Update(product);
        return NoContent(); // 204 No Content
    }

    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        var product = _repository.GetById(id);

        if (product == null)
            return NotFound(); // 404 Not Found

        _repository.Delete(id);
        return NoContent(); // 204 No Content
    }
}
```

### Pattern 8: API Versioning

Plan for API versioning from the start:

```csharp
// Option 1: URL versioning
[ApiController]
[Route("api/v1/[controller]")]
public class ProductsController : ControllerBase { }

[ApiController]
[Route("api/v2/[controller]")]
public class ProductsV2Controller : ControllerBase { }

// Option 2: Use Microsoft.AspNetCore.Mvc.Versioning package
// (More advanced, not covered in beginner guide)
```

---

## 11. Troubleshooting & Common Issues

### Issue 1: 404 Not Found - Route Not Matching

**Symptom:**
```
GET /api/products/5
→ 404 Not Found
```

**Common causes:**

**Cause 1: Missing app.MapControllers()**
```csharp
// ❌ WRONG - Missing MapControllers
var app = builder.Build();
app.UseHttpsRedirection();
app.UseAuthorization();
// app.MapControllers(); ← MISSING!
app.Run();

// ✅ FIX - Add MapControllers
app.MapControllers();
app.Run();
```

**Cause 2: Route template mismatch**
```csharp
// ❌ WRONG
[Route("api/product")]  // Singular
public class ProductsController { }  // Plural controller name

// ✅ FIX - Match the [controller] token or use explicit name
[Route("api/[controller]")]  // Will use "products"
public class ProductsController { }
```

**Cause 3: Missing HTTP verb attribute**
```csharp
// ❌ WRONG - No HTTP verb
public IActionResult GetById(int id) { }

// ✅ FIX - Add HTTP verb attribute
[HttpGet("{id}")]
public IActionResult GetById(int id) { }
```

### Issue 2: Ambiguous Route Error

**Symptom:**
```
AmbiguousMatchException: The request matched multiple endpoints
```

**Cause: Multiple actions match the same route**
```csharp
// ❌ WRONG - Both match /api/products/something
[HttpGet("{id}")]
public IActionResult GetById(string id) { }

[HttpGet("{code}")]
public IActionResult GetByCode(string code) { }

// ✅ FIX 1 - Use constraints
[HttpGet("{id:int}")]
public IActionResult GetById(int id) { }

[HttpGet("{code:alpha}")]
public IActionResult GetByCode(string code) { }

// ✅ FIX 2 - Use different route patterns
[HttpGet("{id:int}")]
public IActionResult GetById(int id) { }

[HttpGet("by-code/{code}")]
public IActionResult GetByCode(string code) { }
```

### Issue 3: Route Parameters Not Binding

**Symptom:**
```csharp
[HttpGet("{id}")]
public IActionResult GetById(int id)
{
    // id is always 0
}
```

**Cause: Parameter name mismatch**
```csharp
// ❌ WRONG - Name mismatch
[HttpGet("{id}")]
public IActionResult GetById(int productId) { }  // Parameter name must match!

// ✅ FIX 1 - Match parameter names
[HttpGet("{id}")]
public IActionResult GetById(int id) { }

// ✅ FIX 2 - Use [FromRoute] with explicit name
[HttpGet("{id}")]
public IActionResult GetById([FromRoute(Name = "id")] int productId) { }
```

### Issue 4: POST/PUT Not Receiving Body Data

**Symptom:**
```csharp
[HttpPost]
public IActionResult Create([FromBody] ProductDto dto)
{
    // dto is null
}
```

**Common causes:**

**Cause 1: Missing Content-Type header**
```bash
# ❌ WRONG
curl -X POST https://localhost:5001/api/products \
  -d '{"name":"Product"}'

# ✅ FIX - Add Content-Type: application/json
curl -X POST https://localhost:5001/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Product"}'
```

**Cause 2: Property name mismatch (case-sensitive by default)**
```json
// Request body
{"Name": "Product"}  // Capital N

// C# class
public class ProductDto
{
    public string name { get; set; }  // lowercase n
}

// ✅ FIX - Match casing or configure JSON options
public class ProductDto
{
    public string Name { get; set; }  // Capital N
}
```

### Issue 5: 415 Unsupported Media Type

**Symptom:**
```
POST /api/products
→ 415 Unsupported Media Type
```

**Cause: Missing or incorrect Content-Type**
```bash
# ❌ WRONG - No Content-Type or wrong Content-Type
curl -X POST https://localhost:5001/api/products \
  -H "Content-Type: text/plain" \
  -d '{"name":"Product"}'

# ✅ FIX - Use application/json
curl -X POST https://localhost:5001/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Product"}'
```

### Issue 6: Routes Not Working After Adding New Controller

**Symptom:** New controller's routes return 404

**Solution: Restart the application**
```bash
# Stop the app (Ctrl+C)
# Start again
dotnet run
```

ASP.NET Core discovers controllers at startup. Adding a new controller requires a restart.

### Debugging Tips

**1. Enable detailed routing logging**
```csharp
// Program.cs
builder.Logging.AddFilter("Microsoft.AspNetCore.Routing", LogLevel.Debug);
```

**2. Use endpoint routing diagnostics**
```csharp
// Program.cs - in Development only
if (app.Environment.IsDevelopment())
{
    app.UseEndpoints(endpoints =>
    {
        endpoints.MapControllers();

        // Show all registered endpoints
        var endpointDataSource = endpoints.DataSources.First();
        foreach (var endpoint in endpointDataSource.Endpoints)
        {
            Console.WriteLine($"Endpoint: {endpoint.DisplayName}");
        }
    });
}
```

**3. Test with Swagger/OpenAPI**

Add Swagger to visualize and test all routes:
```bash
dotnet add package Swashbuckle.AspNetCore
```

```csharp
// Program.cs
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Navigate to: https://localhost:5001/swagger
```

**4. Use curl with verbose mode**
```bash
curl -v https://localhost:5001/api/products/5
# Shows request and response headers
```

---

## 12. Additional Resources

### Official Documentation
- [ASP.NET Core Controllers](https://learn.microsoft.com/en-us/aspnet/core/web-api/controllers)
- [Routing in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/routing)
- [Create web APIs with ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/web-api/)
- [ApiController attribute](https://learn.microsoft.com/en-us/aspnet/core/web-api/api-controller-attribute)

### Recommended Tutorials
- [Microsoft Learn: Create a web API with ASP.NET Core](https://learn.microsoft.com/en-us/learn/modules/build-web-api-aspnet-core/)
- [REST API Tutorial](https://restfulapi.net/)
- [HTTP Status Codes Reference](https://httpstatuses.com/)

### Tools
- [Postman](https://www.postman.com/) - API testing tool
- [Swagger/OpenAPI](https://swagger.io/) - API documentation
- [curl](https://curl.se/) - Command-line HTTP client
- [REST Client for VS Code](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)

### Books
- "ASP.NET Core in Action" by Andrew Lock
- "Pro ASP.NET Core 6" by Adam Freeman
- "RESTful Web API Design with Node.js" (concepts apply to any platform)

### Community Resources
- [Stack Overflow - ASP.NET Core](https://stackoverflow.com/questions/tagged/asp.net-core)
- [ASP.NET Core GitHub](https://github.com/dotnet/aspnetcore)
- [r/dotnet subreddit](https://reddit.com/r/dotnet)

### Next Steps
After mastering Controllers and Routing, continue with:
1. **Action Results and HTTP Responses** - Learn about all response types
2. **Model Validation** - Validate incoming data properly
3. **Data Transfer Objects (DTOs)** - Separate your API contracts from domain models
4. **Dependency Injection** - Build testable, maintainable applications
5. **Entity Framework Core** - Connect your API to a database

---

## Summary

You've learned:
✅ What controllers and routing are and why they're important
✅ The difference between `ControllerBase` and `Controller`
✅ How to create controllers with action methods
✅ Attribute routing vs conventional routing
✅ Route templates and parameters (required, optional, constraints)
✅ HTTP verb attributes (`[HttpGet]`, `[HttpPost]`, etc.)
✅ RESTful API design patterns
✅ How to debug routing issues
✅ Best practices for building clean, maintainable APIs

**Key Takeaways:**
- Controllers organize request-handling logic
- Routing maps URLs to controller actions
- Use `ControllerBase` for APIs, `Controller` for MVC
- Attribute routing is recommended for APIs
- Route constraints prevent ambiguous routes
- Follow REST conventions for predictable APIs
- Return appropriate HTTP status codes

Continue practicing by building your own APIs. The more you use controllers and routing, the more natural they'll become!

---

**Estimated Reading Time:** 55 minutes ⏱️

**Document Complete** ✅
