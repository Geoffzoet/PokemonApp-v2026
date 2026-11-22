# Async/Await Programming in ASP.NET Core

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

### What Is Asynchronous Programming?

**Asynchronous programming** allows your application to perform operations without blocking (waiting). While an operation is running (like reading from a database or calling an external API), your application can do other work instead of sitting idle.

**Real-World Analogy**: Imagine you're cooking dinner:
- **Synchronous**: You put water on to boil, stand there watching it until it boils, then move to the next task. Very inefficient!
- **Asynchronous**: You put water on to boil, start chopping vegetables while waiting, check emails, then come back when the water is ready. Much more efficient!

That's how `async/await` works - your code doesn't block waiting for slow operations.

### Why Use Async/Await?

**Without async** (synchronous):

```csharp
[HttpGet]
public IActionResult GetProducts()
{
    var products = _context.Products.ToList();  // Blocks thread for ~100ms
    return Ok(products);
}
```

**Problem**: While waiting for the database, the thread is **blocked** and can't handle other requests. With 1000 concurrent requests, you need 1000 threads (expensive!).

**With async**:

```csharp
[HttpGet]
public async Task<IActionResult> GetProducts()
{
    var products = await _context.Products.ToListAsync();  // Doesn't block!
    return Ok(products);
}
```

**Benefit**: While waiting for the database, the thread is **freed** to handle other requests. 1000 concurrent requests might only need 10-20 threads!

### Key Benefits

| Benefit | Description |
|---------|-------------|
| **Scalability** | Handle more requests with fewer threads |
| **Responsiveness** | UI doesn't freeze (not applicable to APIs) |
| **Resource Efficiency** | Fewer threads = less memory, better CPU usage |
| **Better Under Load** | Gracefully handle traffic spikes |

### When to Use Async

**Use async for**:
- Database operations (EF Core queries)
- HTTP calls to external APIs
- File I/O operations
- Any operation that waits for I/O

**Don't use async for**:
- CPU-bound operations (calculations, parsing)
- Operations that return immediately (in-memory lists)
- Simple property access

---

## Quick Start

Here's the fastest way to use async/await:

```csharp
// Synchronous (BAD for I/O operations)
[HttpGet]
public IActionResult Get()
{
    var products = _context.Products.ToList();  // Blocks
    return Ok(products);
}

// Asynchronous (GOOD)
[HttpGet]
public async Task<IActionResult> Get()
{
    var products = await _context.Products.ToListAsync();  // Doesn't block
    return Ok(products);
}
```

**Three changes**:
1. Add `async` keyword to method signature
2. Change return type to `Task<T>` (wraps the original type)
3. Use `await` before async operations and add `Async` suffix to method names

**Result**: Your API can handle more concurrent requests efficiently.

---

## Prerequisites

### Required Knowledge

Before working with async/await, you should understand:
- **C# Methods**: Parameters, return types
- **HTTP**: Basic request/response concepts
- **ASP.NET Core Controllers**: Basic API development

### Helpful (but not required)

- **Threads**: Understanding of concurrency helps
- **I/O Operations**: Database, file, network operations

### Required Tools

| Tool | Version | Purpose |
|------|---------|---------|
| .NET SDK | 8.0+ | Built-in async support |
| ASP.NET Core | 8.0+ | Async controller actions |

**Good news**: Async/await is built into C# and .NET - no additional packages needed!

---

## Core Concepts & Theory

### 1. Synchronous vs Asynchronous

**Synchronous execution**:
```
Request arrives
  ↓
Get data from database (thread BLOCKS for 100ms)
  ↓
Process data
  ↓
Return response

Thread is busy the entire time, can't handle other requests
```

**Asynchronous execution**:
```
Request arrives
  ↓
Start database query (thread is FREED)
  ↓ (meanwhile, thread handles other requests)
Database query completes
  ↓
Continue processing on any available thread
  ↓
Return response

Thread is only busy when actually doing work
```

### 2. Task and Task<T>

**`Task`** represents an asynchronous operation:

```csharp
// Task - operation with no return value
public async Task SaveChangesAsync()
{
    await _context.SaveChangesAsync();
    // No return value
}

// Task<T> - operation that returns a value of type T
public async Task<Product> GetProductAsync(int id)
{
    return await _context.Products.FindAsync(id);
    // Returns Product
}
```

**Key points**:
- `Task` = `void` for async methods
- `Task<T>` = `T` for async methods
- Don't confuse `Task<T>` with `T` - the `Task` wrapper is required

### 3. The `async` Keyword

**`async`** keyword tells the compiler:
- This method contains asynchronous operations
- Enables use of `await` keyword
- Automatically wraps return value in `Task<T>`

```csharp
// Without async (can't use await)
public Task<Product> GetProduct(int id)
{
    // Can't use await here!
    return _context.Products.FindAsync(id);
}

// With async (can use await)
public async Task<Product> GetProduct(int id)
{
    return await _context.Products.FindAsync(id);  // await is allowed
}
```

### 4. The `await` Keyword

**`await`** tells the compiler:
- Wait for this async operation to complete
- **Don't block** the thread while waiting
- When operation completes, continue executing here

```csharp
public async Task<IActionResult> GetProducts()
{
    Console.WriteLine("Before await");

    var products = await _context.Products.ToListAsync();
    // ^ Thread is freed here until database responds

    Console.WriteLine("After await");  // Resumes when database responds

    return Ok(products);
}
```

### 5. Threads and I/O Operations

**I/O-bound operations** (database, file, network):
```
Thread 1 starts database query
  ↓
Database is processing (thread is freed)
  ↓
Database responds
  ↓
Any available thread continues execution
```

**CPU-bound operations** (calculations):
```
Thread 1 starts calculation
  ↓
Thread 1 is busy calculating (can't be freed)
  ↓
Calculation completes on Thread 1
```

**Key insight**: `async/await` helps with I/O, not CPU calculations.

### 6. Async Method Naming Convention

**Convention**: Async methods should end with `Async` suffix.

```csharp
// Good
public async Task<Product> GetProductAsync(int id) { }
public async Task SaveChangesAsync() { }
public async Task<bool> ExistsAsync(string name) { }

// Bad (missing Async suffix)
public async Task<Product> GetProduct(int id) { }
public async Task SaveChanges() { }
```

### 7. Return Types for Async Methods

| Return Type | Scenario | Example |
|-------------|----------|---------|
| `Task<T>` | Async operation returning value | `Task<Product>` |
| `Task` | Async operation with no return | `Task` |
| `ValueTask<T>` | Performance-optimized `Task<T>` | `ValueTask<int>` |
| `IAsyncEnumerable<T>` | Async streaming | `IAsyncEnumerable<Product>` |

**Most common**: `Task` and `Task<T>`.

### 8. How Async Actually Works

**Behind the scenes**, the compiler transforms your async method into a state machine:

```csharp
// What you write
public async Task<string> GetDataAsync()
{
    var data = await _client.GetStringAsync("https://api.example.com");
    return data.ToUpper();
}

// What the compiler generates (simplified)
public Task<string> GetDataAsync()
{
    var stateMachine = new StateMachine();
    stateMachine.Start();
    return stateMachine.Task;
}
```

**You don't need to understand the state machine** - just use `async/await`!

---

## Installation Guide

**Good news**: Async/await is built into C# and .NET Core!

No packages to install. It just works.

**Entity Framework Core** provides async methods:

```bash
# Already installed if you're using EF Core
dotnet add package Microsoft.EntityFrameworkCore
```

**HttpClient** for external API calls:

```csharp
// Built into .NET
using System.Net.Http;
```

---

## Initial Setup & Configuration

### No Special Configuration Needed

Async/await works out of the box in ASP.NET Core.

### Configuring Async in EF Core

**Register DbContext as usual**:

```csharp
// Program.cs
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite("Data Source=app.db"));
```

**All async methods are available** on `DbSet<T>`:
- `ToListAsync()`
- `FirstOrDefaultAsync()`
- `FindAsync()`
- `AnyAsync()`
- `CountAsync()`
- `SaveChangesAsync()`

### Configuring HttpClient for Async API Calls

```csharp
// Program.cs
builder.Services.AddHttpClient();

// Controller
public class ExternalApiController : ControllerBase
{
    private readonly HttpClient _httpClient;

    public ExternalApiController(IHttpClientFactory httpClientFactory)
    {
        _httpClient = httpClientFactory.CreateClient();
    }

    [HttpGet]
    public async Task<IActionResult> GetExternalData()
    {
        var response = await _httpClient.GetStringAsync("https://api.example.com/data");
        return Ok(response);
    }
}
```

---

## Basic Usage

### Example 1: Async Controller Action

**Synchronous version (BAD)**:

```csharp
[HttpGet]
public IActionResult GetAll()
{
    var products = _context.Products.ToList();  // Blocks thread
    return Ok(products);
}
```

**Asynchronous version (GOOD)**:

```csharp
[HttpGet]
public async Task<IActionResult> GetAll()
{
    var products = await _context.Products.ToListAsync();  // Doesn't block
    return Ok(products);
}
```

### Example 2: Async Action with Parameters

```csharp
[HttpGet("{id}")]
public async Task<ActionResult<ProductDto>> GetById(int id)
{
    var product = await _context.Products.FindAsync(id);

    if (product == null)
        return NotFound();

    var dto = new ProductDto
    {
        Id = product.Id,
        Name = product.Name,
        Price = product.Price
    };

    return dto;
}
```

### Example 3: Async Create Action

```csharp
[HttpPost]
public async Task<ActionResult<ProductDto>> Create(ProductCreateDto createDto)
{
    var product = new Product
    {
        Name = createDto.Name,
        Price = createDto.Price
    };

    _context.Products.Add(product);
    await _context.SaveChangesAsync();  // Async save

    var dto = new ProductDto
    {
        Id = product.Id,
        Name = product.Name,
        Price = product.Price
    };

    return CreatedAtAction(nameof(GetById), new { id = product.Id }, dto);
}
```

### Example 4: Multiple Async Operations

**Sequential** (one after another):

```csharp
public async Task<IActionResult> GetOrderDetails(int orderId)
{
    var order = await _context.Orders.FindAsync(orderId);
    var customer = await _context.Customers.FindAsync(order.CustomerId);
    var items = await _context.OrderItems.Where(i => i.OrderId == orderId).ToListAsync();

    return Ok(new { order, customer, items });
}
```

**Parallel** (at the same time):

```csharp
public async Task<IActionResult> GetDashboardData()
{
    // Start all three operations at once
    var productsTask = _context.Products.CountAsync();
    var ordersTask = _context.Orders.CountAsync();
    var customersTask = _context.Customers.CountAsync();

    // Wait for all to complete
    await Task.WhenAll(productsTask, ordersTask, customersTask);

    return Ok(new
    {
        ProductCount = productsTask.Result,
        OrderCount = ordersTask.Result,
        CustomerCount = customersTask.Result
    });
}
```

### Example 5: Async Service Layer

```csharp
public interface IProductService
{
    Task<List<ProductDto>> GetAllAsync();
    Task<ProductDto> GetByIdAsync(int id);
    Task<ProductDto> CreateAsync(ProductCreateDto dto);
}

public class ProductService : IProductService
{
    private readonly AppDbContext _context;

    public ProductService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<List<ProductDto>> GetAllAsync()
    {
        var products = await _context.Products.ToListAsync();

        return products.Select(p => new ProductDto
        {
            Id = p.Id,
            Name = p.Name,
            Price = p.Price
        }).ToList();
    }

    public async Task<ProductDto> GetByIdAsync(int id)
    {
        var product = await _context.Products.FindAsync(id);

        if (product == null)
            return null;

        return new ProductDto
        {
            Id = product.Id,
            Name = product.Name,
            Price = product.Price
        };
    }

    public async Task<ProductDto> CreateAsync(ProductCreateDto dto)
    {
        var product = new Product
        {
            Name = dto.Name,
            Price = dto.Price
        };

        _context.Products.Add(product);
        await _context.SaveChangesAsync();

        return new ProductDto
        {
            Id = product.Id,
            Name = product.Name,
            Price = product.Price
        };
    }
}
```

---

## Testing & Validation

### Unit Testing Async Methods

```csharp
using Xunit;

public class ProductServiceTests
{
    [Fact]
    public async Task GetAllAsync_ReturnsAllProducts()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "TestDb")
            .Options;

        await using var context = new AppDbContext(options);
        context.Products.Add(new Product { Name = "Product 1", Price = 10 });
        context.Products.Add(new Product { Name = "Product 2", Price = 20 });
        await context.SaveChangesAsync();

        var service = new ProductService(context);

        // Act
        var products = await service.GetAllAsync();

        // Assert
        Assert.Equal(2, products.Count);
    }

    [Fact]
    public async Task CreateAsync_CreatesProduct()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(databaseName: "TestDb2")
            .Options;

        await using var context = new AppDbContext(options);
        var service = new ProductService(context);

        var dto = new ProductCreateDto { Name = "New Product", Price = 30 };

        // Act
        var result = await service.CreateAsync(dto);

        // Assert
        Assert.NotNull(result);
        Assert.Equal("New Product", result.Name);
        Assert.True(result.Id > 0);
    }
}
```

### Integration Testing Async Endpoints

```csharp
using Microsoft.AspNetCore.Mvc.Testing;
using System.Net.Http.Json;
using Xunit;

public class ProductsApiTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public ProductsApiTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task GetProducts_ReturnsProducts()
    {
        // Act
        var response = await _client.GetAsync("/api/products");

        // Assert
        response.EnsureSuccessStatusCode();

        var products = await response.Content.ReadFromJsonAsync<List<ProductDto>>();
        Assert.NotNull(products);
    }

    [Fact]
    public async Task CreateProduct_ReturnsCreatedProduct()
    {
        // Arrange
        var dto = new ProductCreateDto { Name = "Test", Price = 10 };

        // Act
        var response = await _client.PostAsJsonAsync("/api/products", dto);

        // Assert
        response.EnsureSuccessStatusCode();

        var product = await response.Content.ReadFromJsonAsync<ProductDto>();
        Assert.NotNull(product);
        Assert.Equal("Test", product.Name);
    }
}
```

---

## Practical Examples

### Example 1: Async Repository Pattern

```csharp
public interface IProductRepository
{
    Task<List<Product>> GetAllAsync();
    Task<Product> GetByIdAsync(int id);
    Task<Product> AddAsync(Product product);
    Task UpdateAsync(Product product);
    Task DeleteAsync(int id);
}

public class ProductRepository : IProductRepository
{
    private readonly AppDbContext _context;

    public ProductRepository(AppDbContext context)
    {
        _context = context;
    }

    public async Task<List<Product>> GetAllAsync()
    {
        return await _context.Products
            .Include(p => p.Category)
            .ToListAsync();
    }

    public async Task<Product> GetByIdAsync(int id)
    {
        return await _context.Products
            .Include(p => p.Category)
            .FirstOrDefaultAsync(p => p.Id == id);
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
```

### Example 2: Calling External APIs

```csharp
public class WeatherService
{
    private readonly HttpClient _httpClient;

    public WeatherService(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }

    public async Task<WeatherData> GetWeatherAsync(string city)
    {
        var url = $"https://api.openweathermap.org/data/2.5/weather?q={city}&appid=YOUR_API_KEY";

        var response = await _httpClient.GetAsync(url);
        response.EnsureSuccessStatusCode();

        var weather = await response.Content.ReadFromJsonAsync<WeatherData>();
        return weather;
    }

    public async Task<List<WeatherData>> GetMultipleCitiesAsync(List<string> cities)
    {
        // Start all requests in parallel
        var tasks = cities.Select(city => GetWeatherAsync(city)).ToList();

        // Wait for all to complete
        var results = await Task.WhenAll(tasks);

        return results.ToList();
    }
}
```

### Example 3: Async File Operations

```csharp
public class FileService
{
    public async Task<string> ReadFileAsync(string filePath)
    {
        using var reader = new StreamReader(filePath);
        return await reader.ReadToEndAsync();
    }

    public async Task WriteFileAsync(string filePath, string content)
    {
        using var writer = new StreamWriter(filePath);
        await writer.WriteAsync(content);
    }

    public async Task<byte[]> ReadBinaryFileAsync(string filePath)
    {
        return await File.ReadAllBytesAsync(filePath);
    }

    public async Task WriteBinaryFileAsync(string filePath, byte[] content)
    {
        await File.WriteAllBytesAsync(filePath, content);
    }
}
```

### Example 4: Async with Transactions

```csharp
public class OrderService
{
    private readonly AppDbContext _context;

    public OrderService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<Order> CreateOrderAsync(OrderCreateDto dto)
    {
        using var transaction = await _context.Database.BeginTransactionAsync();

        try
        {
            // Create order
            var order = new Order
            {
                CustomerId = dto.CustomerId,
                OrderDate = DateTime.UtcNow
            };

            _context.Orders.Add(order);
            await _context.SaveChangesAsync();

            // Add order items
            foreach (var item in dto.Items)
            {
                var orderItem = new OrderItem
                {
                    OrderId = order.Id,
                    ProductId = item.ProductId,
                    Quantity = item.Quantity,
                    UnitPrice = item.UnitPrice
                };

                _context.OrderItems.Add(orderItem);
            }

            await _context.SaveChangesAsync();

            // Update product stock
            foreach (var item in dto.Items)
            {
                var product = await _context.Products.FindAsync(item.ProductId);
                product.Stock -= item.Quantity;
            }

            await _context.SaveChangesAsync();

            await transaction.CommitAsync();

            return order;
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }
    }
}
```

---

## Common Patterns & Best Practices

### 1. Always Use Async for I/O Operations

**Good**:
```csharp
public async Task<Product> GetProductAsync(int id)
{
    return await _context.Products.FindAsync(id);  // Async
}
```

**Bad**:
```csharp
public Product GetProduct(int id)
{
    return _context.Products.Find(id);  // Synchronous I/O
}
```

### 2. Don't Block on Async Code

**NEVER do this** (causes deadlocks):

```csharp
public IActionResult Get()
{
    var products = GetProductsAsync().Result;  // BAD! Blocks thread
    return Ok(products);
}

public IActionResult Get2()
{
    GetProductsAsync().Wait();  // BAD! Blocks thread
    return Ok();
}
```

**Always do this**:

```csharp
public async Task<IActionResult> Get()
{
    var products = await GetProductsAsync();  // GOOD! Doesn't block
    return Ok(products);
}
```

### 3. Use Async All the Way

**Once you use async, propagate it up the call stack**:

```csharp
// Repository (async)
public async Task<Product> GetProductAsync(int id)
{
    return await _context.Products.FindAsync(id);
}

// Service (async)
public async Task<ProductDto> GetProductAsync(int id)
{
    var product = await _repository.GetProductAsync(id);  // Await
    return MapToDto(product);
}

// Controller (async)
public async Task<IActionResult> GetProduct(int id)
{
    var dto = await _service.GetProductAsync(id);  // Await
    return Ok(dto);
}
```

### 4. Use Async Naming Convention

```csharp
// Good - Async suffix
public async Task<Product> GetProductAsync(int id) { }
public async Task SaveChangesAsync() { }

// Bad - Missing Async suffix
public async Task<Product> GetProduct(int id) { }
public async Task SaveChanges() { }
```

### 5. Don't Use Async for CPU-Bound Operations

**Async doesn't help with CPU work**:

```csharp
// BAD - Async doesn't help here
public async Task<int> CalculateSumAsync(int[] numbers)
{
    return await Task.Run(() => numbers.Sum());  // Waste of Task
}

// GOOD - Synchronous for CPU work
public int CalculateSum(int[] numbers)
{
    return numbers.Sum();
}
```

### 6. Prefer `Task.WhenAll` for Parallel Operations

```csharp
// Sequential (slow)
var products = await _context.Products.ToListAsync();
var categories = await _context.Categories.ToListAsync();
var orders = await _context.Orders.ToListAsync();

// Parallel (fast)
var productsTask = _context.Products.ToListAsync();
var categoriesTask = _context.Categories.ToListAsync();
var ordersTask = _context.Orders.ToListAsync();

await Task.WhenAll(productsTask, categoriesTask, ordersTask);

var products = productsTask.Result;
var categories = categoriesTask.Result;
var orders = ordersTask.Result;
```

### 7. Handle Exceptions in Async Methods

```csharp
public async Task<IActionResult> GetProduct(int id)
{
    try
    {
        var product = await _service.GetProductAsync(id);
        return Ok(product);
    }
    catch (NotFoundException ex)
    {
        return NotFound(ex.Message);
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Error getting product");
        return StatusCode(500, "Internal server error");
    }
}
```

### 8. Use CancellationToken for Long Operations

```csharp
[HttpGet]
public async Task<IActionResult> GetLargeReport(CancellationToken cancellationToken)
{
    var data = await _context.Orders
        .Where(o => o.Year == 2024)
        .ToListAsync(cancellationToken);  // Can be cancelled

    return Ok(data);
}
```

---

## Troubleshooting

### Issue 1: Deadlocks

**Symptom**: Application hangs, never completes.

**Cause**: Blocking on async code with `.Result` or `.Wait()`.

```csharp
// CAUSES DEADLOCK
public IActionResult Get()
{
    var result = GetDataAsync().Result;  // Deadlock!
    return Ok(result);
}
```

**Solution**: Use `await` instead:

```csharp
public async Task<IActionResult> Get()
{
    var result = await GetDataAsync();  // No deadlock
    return Ok(result);
}
```

### Issue 2: Async void

**Symptom**: Exceptions disappear, can't be caught.

**Problem**:

```csharp
// BAD - Async void (only for event handlers)
public async void DoSomething()
{
    await Task.Delay(1000);
    throw new Exception("Error");  // Can't be caught!
}
```

**Solution**: Always return `Task`:

```csharp
// GOOD
public async Task DoSomething()
{
    await Task.Delay(1000);
    throw new Exception("Error");  // Can be caught
}
```

### Issue 3: Forgetting to Await

**Symptom**: Method returns immediately, operation doesn't complete.

```csharp
// BAD - Forgot await
public async Task<IActionResult> Create(ProductDto dto)
{
    _context.Products.Add(new Product());
    _context.SaveChangesAsync();  // Missing await!
    return Ok();  // Returns before save completes
}
```

**Solution**: Always `await`:

```csharp
public async Task<IActionResult> Create(ProductDto dto)
{
    _context.Products.Add(new Product());
    await _context.SaveChangesAsync();  // Await
    return Ok();
}
```

### Issue 4: Over-Using Async

**Symptom**: Slower performance, more allocations.

**Problem**: Using async for synchronous operations:

```csharp
// BAD - In-memory list doesn't need async
public async Task<List<Product>> GetCachedProducts()
{
    return await Task.FromResult(_cache.GetProducts());  // Unnecessary
}
```

**Solution**: Only use async for I/O:

```csharp
// GOOD - Synchronous for in-memory
public List<Product> GetCachedProducts()
{
    return _cache.GetProducts();
}
```

### Issue 5: Not Handling Task Exceptions

**Symptom**: Unobserved task exceptions.

```csharp
// BAD - Fire-and-forget
Task.Run(async () => await DoSomethingAsync());  // Exception not handled
```

**Solution**: Always await or handle:

```csharp
// GOOD
await Task.Run(async () => await DoSomethingAsync());

// OR handle explicitly
var task = DoSomethingAsync();
task.ContinueWith(t =>
{
    if (t.IsFaulted)
        _logger.LogError(t.Exception, "Task failed");
});
```

---

## Additional Resources

### Official Documentation

- [Async/Await in C#](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/async/) - Microsoft's comprehensive guide
- [Task-based Asynchronous Pattern (TAP)](https://learn.microsoft.com/en-us/dotnet/standard/asynchronous-programming-patterns/task-based-asynchronous-pattern-tap) - Design patterns
- [Async Best Practices](https://learn.microsoft.com/en-us/archive/msdn-magazine/2013/march/async-await-best-practices-in-asynchronous-programming) - Stephen Cleary's guide

### Books

- **"Concurrency in C# Cookbook"** by Stephen Cleary - Async/await patterns
- **"C# in Depth"** by Jon Skeet - Deep dive into async

### Articles

- [There Is No Thread](https://blog.stephencleary.com/2013/11/there-is-no-thread.html) - Understanding async
- [ConfigureAwait FAQ](https://devblogs.microsoft.com/dotnet/configureawait-faq/) - ConfigureAwait explained

### Video Tutorials

- [Async/Await in .NET](https://www.youtube.com/results?search_query=async+await+.net+core) - YouTube tutorials

### Community Resources

- [Stack Overflow - Async/Await Tag](https://stackoverflow.com/questions/tagged/async-await)
- [Stephen Cleary's Blog](https://blog.stephencleary.com/) - Async expert

### Related Topics

1. **Task Parallel Library (TPL)** - Advanced parallel programming
2. **Channels** - Async producer/consumer patterns
3. **IAsyncEnumerable** - Async streaming

---

## Self-Assessment Checklist

After completing this guide, you should be able to:

- [ ] Explain what asynchronous programming is and why it's beneficial
- [ ] Understand the difference between sync and async execution
- [ ] Use `async` and `await` keywords correctly
- [ ] Understand `Task` and `Task<T>` return types
- [ ] Write async controller actions
- [ ] Write async service and repository methods
- [ ] Use EF Core async methods (`ToListAsync`, `SaveChangesAsync`)
- [ ] Run operations in parallel with `Task.WhenAll`
- [ ] Avoid common pitfalls (deadlocks, async void, blocking)
- [ ] Know when to use async (I/O) and when not to (CPU)
- [ ] Test async methods with xUnit
- [ ] Handle exceptions in async code

---

## Summary

**Async/await** enables scalable, efficient ASP.NET Core applications by freeing threads during I/O operations. Key takeaways:

1. **Use async for I/O operations** - Database, HTTP, file operations
2. **Don't use async for CPU operations** - Calculations, in-memory operations
3. **Always propagate async** - Once async, stay async all the way up
4. **Never block on async** - Don't use `.Result` or `.Wait()`
5. **Use async naming convention** - Suffix methods with `Async`
6. **Return `Task` or `Task<T>`** - Never `async void` (except event handlers)
7. **Use `await`** - Don't forget to await async operations
8. **Parallelize when possible** - Use `Task.WhenAll` for independent operations

**Next Steps**:
- Convert your synchronous I/O operations to async
- Practice with EF Core async methods
- Experiment with parallel async operations
- Read Stephen Cleary's async best practices
- Explore advanced patterns (`IAsyncEnumerable`, `ValueTask`)

Remember: Async/await is about **scalability**, not speed. A single request isn't faster, but your application can handle many more concurrent requests efficiently.

Happy async programming!
