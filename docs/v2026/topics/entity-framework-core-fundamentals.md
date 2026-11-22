# Entity Framework Core Fundamentals

---
**Technology Version**: Entity Framework Core 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-22
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What is Entity Framework Core?

Entity Framework Core (EF Core) is Microsoft's modern object-relational mapping (ORM) framework. It allows you to work with databases using C# objects instead of writing SQL queries directly.

**Simple analogy**: Imagine you're translating between two languages. Your C# code speaks one language (objects and classes), and your database speaks another (tables and rows). EF Core is the translator that converts between these two languages automatically.

**What EF Core does:**
```csharp
// Instead of writing SQL:
// SELECT * FROM Products WHERE Id = 5

// You write C#:
var product = context.Products.Find(5);
```

EF Core is:
- **Cross-platform**: Works on Windows, macOS, and Linux
- **Lightweight**: Modular design with only needed features
- **Modern**: Built from scratch for .NET Core
- **Flexible**: Supports multiple database providers
- **Open-source**: Free and community-driven

### Why Use Entity Framework Core?

**You should use EF Core when:**

**Productivity**
- Spend less time writing SQL, more time on business logic
- Automatic CRUD operations (Create, Read, Update, Delete)
- Type-safe database queries using LINQ
- IntelliSense support for database operations

**Maintainability**
- Database schema changes tracked via migrations
- Strongly-typed code prevents runtime errors
- Clear relationship definitions between entities
- Easier to refactor and test

**Modern Development**
- Works seamlessly with ASP.NET Core
- Supports async/await for better performance
- Built-in dependency injection support
- Cross-platform development

### When to Use It

**Good use cases:**
- Building web APIs with database backends
- Applications with complex object models
- Projects requiring database portability (switch between SQL Server, PostgreSQL, SQLite)
- Rapid application development
- Applications needing strong typing and compile-time safety

**Not recommended for:**
- Extremely high-performance scenarios requiring hand-tuned SQL
- Simple applications with 1-2 database tables
- Reporting applications with complex SQL queries (consider raw SQL or stored procedures)
- Legacy databases with unconventional schemas

---

## 2. Quick Start

**TL;DR - Get started in 5 minutes:**

```bash
# 1. Install EF Core packages
dotnet add package Microsoft.EntityFrameworkCore.Sqlite
dotnet add package Microsoft.EntityFrameworkCore.Design

# 2. Create a model class
# (See ProductsDbContext.cs below)

# 3. Create initial migration
dotnet ef migrations add InitialCreate

# 4. Create the database
dotnet ef database update

# 5. Use in your code
using (var context = new ProductsDbContext())
{
    var product = new Product { Name = "Laptop", Price = 999.99m };
    context.Products.Add(product);
    context.SaveChanges();
}
```

**Minimal example:**

```csharp
// Product.cs - Entity class
public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
}

// ProductsDbContext.cs - Database context
using Microsoft.EntityFrameworkCore;

public class ProductsDbContext : DbContext
{
    public DbSet<Product> Products { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder options)
        => options.UseSqlite("Data Source=products.db");
}
```

For detailed explanations, continue reading below.

---

## 3. Prerequisites

### Required Knowledge
- **C# Classes and Properties** - Understanding of POCOs (Plain Old CLR Objects)
- **Basic SQL** - SELECT, INSERT, UPDATE, DELETE concepts
- **LINQ Basics** - Query syntax and lambda expressions
- **ASP.NET Core Basics** - Dependency injection concepts

### Required Software/Tools
- **.NET SDK 8.0** or higher
- **EF Core Tools** (installed via dotnet tool install)
- **Database** - SQL Server, SQLite, PostgreSQL, or MySQL
- **Code Editor** - VS Code, Visual Studio, or Rider

### Database Options

| Database | Use Case | Installation Complexity |
|----------|----------|------------------------|
| **SQLite** | Development, testing, small apps | Easy (file-based) |
| **SQL Server** | Production, enterprise apps | Medium (server required) |
| **PostgreSQL** | Production, open-source preference | Medium (server required) |
| **MySQL** | Production, web applications | Medium (server required) |

For this tutorial, we'll use **SQLite** because it requires no setup.

---

## 4. Core Concepts & Theory

### Concept 1: What is an ORM?

**ORM** stands for Object-Relational Mapping. It's a technique that lets you interact with databases using objects instead of SQL.

**Without ORM (Raw SQL):**
```csharp
// ❌ Manual SQL - error-prone, not type-safe
string sql = "SELECT * FROM Products WHERE Id = @id";
SqlCommand cmd = new SqlCommand(sql, connection);
cmd.Parameters.AddWithValue("@id", 5);
SqlDataReader reader = cmd.ExecuteReader();
// ... manually map data to objects
```

**With ORM (EF Core):**
```csharp
// ✅ Type-safe, clean, maintainable
var product = context.Products.Find(5);
```

**Benefits:**
- **Type safety**: Compiler catches errors
- **Productivity**: Less boilerplate code
- **Maintainability**: Changes propagate automatically
- **Database independence**: Switch databases easily

### Concept 2: DbContext

The `DbContext` is the central class in EF Core. It represents a session with the database.

**What DbContext does:**
1. **Manages connections**: Opens/closes database connections
2. **Tracks changes**: Knows what entities changed
3. **Executes queries**: Translates LINQ to SQL
4. **Saves changes**: Persists modifications to the database

```csharp
public class AppDbContext : DbContext
{
    // DbSet represents a table
    public DbSet<Product> Products { get; set; }
    public DbSet<Order> Orders { get; set; }

    // Configuration
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Configure entities here
    }
}
```

**DbContext lifecycle:**
- **Short-lived**: Create per request (web apps)
- **Scoped**: One instance per HTTP request in ASP.NET Core
- **Not thread-safe**: Don't share across threads

### Concept 3: Entities

**Entities** are C# classes that map to database tables.

```csharp
// This class maps to a "Products" table
public class Product
{
    public int Id { get; set; }        // Primary key
    public string Name { get; set; }   // Column
    public decimal Price { get; set; } // Column
    public DateTime Created { get; set; }
}
```

**Entity conventions:**
- Class name → Table name (e.g., `Product` → `Products` table)
- Property `Id` or `{ClassName}Id` → Primary key
- Properties → Columns
- Reference navigation properties → Foreign keys

### Concept 4: DbSet<T>

`DbSet<T>` represents a collection of entities (a table).

```csharp
public DbSet<Product> Products { get; set; }
```

**What you can do with DbSet:**
```csharp
// Query
var products = context.Products.ToList();
var product = context.Products.Find(5);
var expensive = context.Products.Where(p => p.Price > 1000).ToList();

// Add
context.Products.Add(new Product { ... });

// Remove
context.Products.Remove(product);

// Attach (for updates)
context.Products.Update(product);
```

### Concept 5: Change Tracking

EF Core automatically tracks changes to entities.

```csharp
using (var context = new AppDbContext())
{
    var product = context.Products.Find(1);

    product.Price = 899.99m;  // EF Core tracks this change

    context.SaveChanges();    // Generates UPDATE SQL automatically
}
```

**Entity states:**
- **Unchanged**: Entity exists, no changes
- **Added**: New entity, will INSERT
- **Modified**: Existing entity with changes, will UPDATE
- **Deleted**: Marked for deletion, will DELETE
- **Detached**: Not tracked by context

### Concept 6: Code-First vs Database-First

**Code-First** (Recommended ✅):
- Write C# classes first
- Generate database from code
- Use migrations to evolve schema

```csharp
// 1. Write class
public class Product { ... }

// 2. Create migration
dotnet ef migrations add AddProducts

// 3. Update database
dotnet ef database update
```

**Database-First**:
- Database already exists
- Generate C# classes from database
- Use scaffolding

```bash
dotnet ef dbcontext scaffold "connection-string" Provider
```

**Recommendation**: Use Code-First for new projects. It gives you more control and works better with version control.

### Concept 7: Database Providers

EF Core works with multiple databases through providers:

```csharp
// SQL Server
optionsBuilder.UseSqlServer("connection-string");

// SQLite
optionsBuilder.UseSqlite("Data Source=app.db");

// PostgreSQL
optionsBuilder.UseNpgsql("connection-string");

// MySQL
optionsBuilder.UseMySql("connection-string", version);

// In-Memory (testing)
optionsBuilder.UseInMemoryDatabase("TestDb");
```

---

## 5. Installation Guide

### Step 1: Install EF Core Packages

For a **Web API project** using **SQLite**:

```bash
# Navigate to your project
cd MyWebApi

# Install EF Core SQLite provider
dotnet add package Microsoft.EntityFrameworkCore.Sqlite

# Install EF Core tools (for migrations)
dotnet add package Microsoft.EntityFrameworkCore.Design
```

**For other databases:**

**SQL Server:**
```bash
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
```

**PostgreSQL:**
```bash
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL
```

**MySQL:**
```bash
dotnet add package Pomelo.EntityFrameworkCore.MySql
```

### Step 2: Install EF Core CLI Tools

```bash
# Install globally (one-time)
dotnet tool install --global dotnet-ef

# Verify installation
dotnet ef --version
# Should show: Entity Framework Core .NET Command-line Tools 8.0.x
```

### Step 3: Verify Installation

```bash
# Check installed packages
dotnet list package

# You should see:
# Microsoft.EntityFrameworkCore.Sqlite    8.0.x
# Microsoft.EntityFrameworkCore.Design    8.0.x
```

---

## 6. Initial Setup & Configuration

### Step 1: Create Entity Classes

Create a `Models` folder and add entity classes:

```csharp
// Models/Product.cs
namespace MyWebApi.Models;

public class Product
{
    public int Id { get; set; }                    // Primary key
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public decimal Price { get; set; }
    public int Stock { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
```

### Step 2: Create DbContext

Create a `Data` folder and add your DbContext:

```csharp
// Data/AppDbContext.cs
using Microsoft.EntityFrameworkCore;
using MyWebApi.Models;

namespace MyWebApi.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<Product> Products { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Configure entities
        modelBuilder.Entity<Product>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Name).IsRequired().HasMaxLength(100);
            entity.Property(e => e.Price).HasPrecision(18, 2);
        });

        // Seed data
        modelBuilder.Entity<Product>().HasData(
            new Product { Id = 1, Name = "Laptop", Description = "15-inch laptop", Price = 999.99m, Stock = 10 },
            new Product { Id = 2, Name = "Mouse", Description = "Wireless mouse", Price = 29.99m, Stock = 50 }
        );
    }
}
```

### Step 3: Configure Connection String

Add to `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Data Source=app.db"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.EntityFrameworkCore": "Warning"
    }
  }
}
```

**Connection strings for different databases:**

**SQL Server:**
```json
"Server=localhost;Database=MyDb;Trusted_Connection=True;TrustServerCertificate=True"
```

**PostgreSQL:**
```json
"Host=localhost;Database=mydb;Username=postgres;Password=password"
```

**MySQL:**
```json
"Server=localhost;Database=mydb;User=root;Password=password;"
```

### Step 4: Register DbContext in Program.cs

```csharp
using Microsoft.EntityFrameworkCore;
using MyWebApi.Data;

var builder = WebApplication.CreateBuilder(args);

// Add DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddControllers();

var app = builder.Build();

app.MapControllers();
app.Run();
```

---

## 7. Basic Usage

### Example 1: Querying Data

```csharp
[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    private readonly AppDbContext _context;

    public ProductsController(AppDbContext context)
    {
        _context = context;
    }

    // GET: api/products
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var products = await _context.Products.ToListAsync();
        return Ok(products);
    }

    // GET: api/products/5
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        var product = await _context.Products.FindAsync(id);

        if (product == null)
            return NotFound();

        return Ok(product);
    }

    // GET: api/products/search?term=laptop
    [HttpGet("search")]
    public async Task<IActionResult> Search([FromQuery] string term)
    {
        var products = await _context.Products
            .Where(p => p.Name.Contains(term) || p.Description.Contains(term))
            .ToListAsync();

        return Ok(products);
    }
}
```

### Example 2: Adding Data

```csharp
// POST: api/products
[HttpPost]
public async Task<IActionResult> Create([FromBody] Product product)
{
    _context.Products.Add(product);
    await _context.SaveChangesAsync();

    return CreatedAtAction(nameof(GetById), new { id = product.Id }, product);
}
```

### Example 3: Updating Data

```csharp
// PUT: api/products/5
[HttpPut("{id}")]
public async Task<IActionResult> Update(int id, [FromBody] Product product)
{
    if (id != product.Id)
        return BadRequest();

    var existing = await _context.Products.FindAsync(id);
    if (existing == null)
        return NotFound();

    existing.Name = product.Name;
    existing.Description = product.Description;
    existing.Price = product.Price;
    existing.Stock = product.Stock;

    await _context.SaveChangesAsync();

    return NoContent();
}
```

### Example 4: Deleting Data

```csharp
// DELETE: api/products/5
[HttpDelete("{id}")]
public async Task<IActionResult> Delete(int id)
{
    var product = await _context.Products.FindAsync(id);
    if (product == null)
        return NotFound();

    _context.Products.Remove(product);
    await _context.SaveChangesAsync();

    return NoContent();
}
```

### Example 5: Complex Queries with LINQ

```csharp
// Get expensive products in stock
var products = await _context.Products
    .Where(p => p.Price > 500 && p.Stock > 0)
    .OrderByDescending(p => p.Price)
    .Take(10)
    .ToListAsync();

// Get products with specific names
var specificProducts = await _context.Products
    .Where(p => new[] { "Laptop", "Mouse", "Keyboard" }.Contains(p.Name))
    .ToListAsync();

// Count products
var count = await _context.Products.CountAsync();

// Check if any exist
var hasExpensiveProducts = await _context.Products.AnyAsync(p => p.Price > 1000);
```

---

## 8. Testing & Validation

### Exercise 1: Create Your First DbContext (Beginner)

**Objective:** Create a simple book database with EF Core.

**Requirements:**
1. Create a `Book` entity with Id, Title, Author, Year
2. Create a `BooksDbContext` with a DbSet for Books
3. Use SQLite as the database

<details>
<summary>✅ Solution</summary>

```csharp
// Models/Book.cs
public class Book
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Author { get; set; } = string.Empty;
    public int Year { get; set; }
}

// Data/BooksDbContext.cs
using Microsoft.EntityFrameworkCore;

public class BooksDbContext : DbContext
{
    public DbSet<Book> Books { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder options)
        => options.UseSqlite("Data Source=books.db");
}

// Program.cs
builder.Services.AddDbContext<BooksDbContext>();
```

</details>

### Exercise 2: Implement CRUD Operations (Intermediate)

**Objective:** Create a complete CRUD API for books.

**Requirements:**
1. Create GET all books endpoint
2. Create GET book by id endpoint
3. Create POST endpoint to add book
4. Create PUT endpoint to update book
5. Create DELETE endpoint

<details>
<summary>✅ Solution</summary>

```csharp
[ApiController]
[Route("api/[controller]")]
public class BooksController : ControllerBase
{
    private readonly BooksDbContext _context;

    public BooksController(BooksDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var books = await _context.Books.ToListAsync();
        return Ok(books);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        var book = await _context.Books.FindAsync(id);
        return book == null ? NotFound() : Ok(book);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] Book book)
    {
        _context.Books.Add(book);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetById), new { id = book.Id }, book);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, [FromBody] Book book)
    {
        if (id != book.Id) return BadRequest();

        var existing = await _context.Books.FindAsync(id);
        if (existing == null) return NotFound();

        existing.Title = book.Title;
        existing.Author = book.Author;
        existing.Year = book.Year;

        await _context.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var book = await _context.Books.FindAsync(id);
        if (book == null) return NotFound();

        _context.Books.Remove(book);
        await _context.SaveChangesAsync();
        return NoContent();
    }
}
```

</details>

### Exercise 3: Add Relationships (Challenge)

**Objective:** Add a one-to-many relationship between Authors and Books.

**Requirements:**
1. Create Author entity
2. Update Book to have AuthorId foreign key
3. Configure the relationship
4. Query books with their authors

<details>
<summary>✅ Solution</summary>

```csharp
// Models/Author.cs
public class Author
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Country { get; set; } = string.Empty;
    public List<Book> Books { get; set; } = new();
}

// Models/Book.cs
public class Book
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public int Year { get; set; }

    public int AuthorId { get; set; }
    public Author Author { get; set; } = null!;
}

// Data/BooksDbContext.cs
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder.Entity<Book>()
        .HasOne(b => b.Author)
        .WithMany(a => a.Books)
        .HasForeignKey(b => b.AuthorId);
}

// Query with authors
var books = await _context.Books
    .Include(b => b.Author)
    .ToListAsync();
```

</details>

---

## 9. Practical Examples

### Example: Repository Pattern

```csharp
// Interface
public interface IProductRepository
{
    Task<IEnumerable<Product>> GetAllAsync();
    Task<Product?> GetByIdAsync(int id);
    Task<Product> AddAsync(Product product);
    Task UpdateAsync(Product product);
    Task DeleteAsync(int id);
}

// Implementation
public class ProductRepository : IProductRepository
{
    private readonly AppDbContext _context;

    public ProductRepository(AppDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<Product>> GetAllAsync()
    {
        return await _context.Products.ToListAsync();
    }

    public async Task<Product?> GetByIdAsync(int id)
    {
        return await _context.Products.FindAsync(id);
    }

    public async Task<Product> AddAsync(Product product)
    {
        _context.Products.Add(product);
        await _context.SaveChangesAsync();
        return product;
    }

    public async Task UpdateAsync(Product product)
    {
        _context.Products.Update(product);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(int id)
    {
        var product = await _context.Products.FindAsync(id);
        if (product != null)
        {
            _context.Products.Remove(product);
            await _context.SaveChangesAsync();
        }
    }
}

// Register in Program.cs
builder.Services.AddScoped<IProductRepository, ProductRepository>();
```

---

## 10. Common Patterns & Best Practices

### Pattern 1: Use Async/Await
```csharp
// ✅ GOOD - Async for I/O operations
var products = await _context.Products.ToListAsync();
await _context.SaveChangesAsync();

// ❌ BAD - Blocking calls
var products = _context.Products.ToList();
_context.SaveChanges();
```

### Pattern 2: Dispose DbContext Properly
```csharp
// ✅ GOOD - ASP.NET Core handles this automatically
public ProductsController(AppDbContext context)
{
    _context = context;  // Scoped lifetime
}

// ❌ BAD - Creating DbContext manually
var context = new AppDbContext();  // No disposal
```

### Pattern 3: Use AsNoTracking for Read-Only Queries
```csharp
// ✅ GOOD - Faster for read-only
var products = await _context.Products
    .AsNoTracking()
    .ToListAsync();
```

---

## 11. Troubleshooting

### Issue 1: "No database provider configured"

**Solution:** Install provider package and configure in Program.cs:
```bash
dotnet add package Microsoft.EntityFrameworkCore.Sqlite
```

```csharp
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite(connectionString));
```

### Issue 2: "dotnet ef command not found"

**Solution:**
```bash
dotnet tool install --global dotnet-ef
```

---

## 12. Additional Resources

### Official Documentation
- [EF Core Documentation](https://learn.microsoft.com/en-us/ef/core/)
- [EF Core Tutorials](https://learn.microsoft.com/en-us/ef/core/get-started/overview/first-app)

### Books
- "Entity Framework Core in Action" by Jon P. Smith

### Next Steps
- POK-14: EF Core Migrations
- POK-15: Data Transfer Objects (DTOs)

---

**Estimated Reading Time:** 75 minutes ⏱️

**Document Complete** ✅
