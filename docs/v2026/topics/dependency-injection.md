# Dependency Injection in ASP.NET Core

**Estimated Reading Time**: 65 minutes

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

### What Is Dependency Injection?

**Dependency Injection (DI)** is a design pattern where objects receive their dependencies from an external source rather than creating them internally. It's a way to achieve **Inversion of Control (IoC)**, where the framework manages object creation and lifetime instead of you doing it manually.

**Real-World Analogy**: Imagine you're a chef in a restaurant. Instead of going to the market to buy ingredients every time you cook (creating dependencies), the restaurant provides you with pre-prepared ingredients (injects dependencies). You focus on cooking, not shopping. That's dependency injection.

### Why Use Dependency Injection?

**Without DI**:

```csharp
public class ProductsController : ControllerBase
{
    private readonly ProductService _service;

    public ProductsController()
    {
        // PROBLEM: Controller creates its own dependency
        var connectionString = "Server=...";
        var context = new AppDbContext(connectionString);
        _service = new ProductService(context);  // Tightly coupled!
    }
}
```

**Problems**:
- **Tight coupling**: Controller depends directly on `ProductService` and `AppDbContext`
- **Hard to test**: Can't replace `ProductService` with a mock for testing
- **Configuration scattered**: Connection string hardcoded
- **Resource management**: Who closes the database connection?

**With DI**:

```csharp
public class ProductsController : ControllerBase
{
    private readonly IProductService _service;

    // Dependencies injected by ASP.NET Core
    public ProductsController(IProductService service)
    {
        _service = service;
    }
}
```

**Benefits**:
- **Loose coupling**: Controller depends on interface, not concrete class
- **Testability**: Can inject mock implementations for testing
- **Centralized configuration**: All services registered in one place
- **Automatic resource management**: Framework handles lifecycle

### Key Benefits

| Benefit | Description |
|---------|-------------|
| **Testability** | Easy to replace dependencies with mocks/stubs |
| **Loose Coupling** | Classes depend on abstractions (interfaces) not implementations |
| **Maintainability** | Changes to dependencies don't affect consumers |
| **Reusability** | Services can be shared across the application |
| **Lifetime Management** | Framework handles creation and disposal |
| **Configuration** | Centralized service registration |

### When to Use DI

**Use DI for**:
- Database contexts (EF Core)
- Business logic services
- Repositories
- External API clients
- Logging services
- Configuration access
- Any object that has dependencies

**Don't use DI for**:
- DTOs (simple data containers)
- Entity models
- Value objects
- Static utilities (use static methods instead)

---

## Quick Start

Here's the fastest way to get started with DI:

```csharp
// 1. Create an interface
public interface IProductService
{
    List<Product> GetAll();
}

// 2. Create implementation
public class ProductService : IProductService
{
    private readonly AppDbContext _context;

    public ProductService(AppDbContext context)
    {
        _context = context;
    }

    public List<Product> GetAll()
    {
        return _context.Products.ToList();
    }
}

// 3. Register service in Program.cs
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite("Data Source=app.db"));

builder.Services.AddScoped<IProductService, ProductService>();

var app = builder.Build();
app.Run();

// 4. Inject into controller
[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    private readonly IProductService _service;

    public ProductsController(IProductService service)
    {
        _service = service;
    }

    [HttpGet]
    public ActionResult<List<Product>> GetAll()
    {
        return _service.GetAll();
    }
}
```

**Result**: Your controller receives a fully configured `ProductService` automatically.

---

## Prerequisites

### Required Knowledge

Before working with Dependency Injection, you should understand:
- **C# Interfaces**: DI uses interfaces for abstraction
- **Object-Oriented Programming**: Classes, inheritance, polymorphism
- **Constructor Parameters**: How constructors accept parameters
- **Basic ASP.NET Core**: Controllers and routing

### Required Tools

| Tool | Version | Purpose |
|------|---------|---------|
| .NET SDK | 8.0+ | Built-in DI container |
| ASP.NET Core | 8.0+ | Web framework with DI |

**Good news**: ASP.NET Core has built-in DI - no additional packages needed!

---

## Core Concepts & Theory

### 1. Inversion of Control (IoC)

**Traditional Control Flow**:
```csharp
public class A
{
    private B _b;

    public A()
    {
        _b = new B();  // A controls creation of B
    }
}
```

**Inverted Control Flow**:
```csharp
public class A
{
    private IB _b;

    public A(IB b)  // Something else creates B and gives it to A
    {
        _b = b;
    }
}
```

**Inversion**: Instead of class A creating its dependencies, the dependencies are created externally and "injected" into A.

### 2. Dependency Injection Container

The **DI Container** (also called IoC Container) is responsible for:
1. **Registering** services (types and their implementations)
2. **Resolving** services (creating instances when requested)
3. **Managing lifetimes** (when to create and dispose instances)

**ASP.NET Core's built-in container**: `IServiceCollection` and `IServiceProvider`

```
┌─────────────────────────────────────────┐
│         DI Container                    │
│                                         │
│  Registrations:                         │
│  IProductService → ProductService       │
│  IEmailService   → EmailService         │
│  AppDbContext    → AppDbContext         │
│                                         │
│  When ProductsController is requested:  │
│  1. Create AppDbContext                 │
│  2. Create ProductService(context)      │
│  3. Create ProductsController(service)  │
│  4. Return controller                   │
└─────────────────────────────────────────┘
```

### 3. Service Lifetimes

ASP.NET Core supports three service lifetimes:

#### Transient

**Definition**: A new instance is created every time it's requested.

```csharp
builder.Services.AddTransient<IMyService, MyService>();
```

**Diagram**:
```
Request 1:
  Controller A → MyService Instance #1
  Controller B → MyService Instance #2

Request 2:
  Controller A → MyService Instance #3
  Controller B → MyService Instance #4
```

**Use when**:
- Service is lightweight
- Service has no state
- Service is used briefly

**Example**: GUID generator, timestamp provider

#### Scoped

**Definition**: One instance per HTTP request (or scope).

```csharp
builder.Services.AddScoped<IMyService, MyService>();
```

**Diagram**:
```
Request 1:
  Controller A → MyService Instance #1
  Controller B → MyService Instance #1  (same instance!)

Request 2:
  Controller A → MyService Instance #2  (new request = new instance)
  Controller B → MyService Instance #2
```

**Use when**:
- Service maintains state within a request
- Service represents a unit of work

**Example**: `DbContext`, repositories, services that use DbContext

#### Singleton

**Definition**: One instance for the entire application lifetime.

```csharp
builder.Services.AddSingleton<IMyService, MyService>();
```

**Diagram**:
```
Request 1:
  Controller A → MyService Instance #1
  Controller B → MyService Instance #1

Request 2:
  Controller A → MyService Instance #1  (same instance!)
  Controller B → MyService Instance #1
```

**Use when**:
- Service is expensive to create
- Service is thread-safe
- Service has no state or immutable state

**Example**: Configuration, caching services, logging

### 4. Service Lifetime Comparison

| Lifetime | Instances per Request | Instances per App | Thread-Safe Required | Example Use Case |
|----------|----------------------|-------------------|---------------------|------------------|
| **Transient** | Multiple | Many | No | Utilities, helpers |
| **Scoped** | One | One per request | No | DbContext, repositories |
| **Singleton** | One | One | **Yes** | Configuration, cache |

### 5. Constructor Injection

The most common injection method:

```csharp
public class ProductsController : ControllerBase
{
    private readonly IProductService _service;
    private readonly ILogger<ProductsController> _logger;

    // Dependencies injected via constructor
    public ProductsController(
        IProductService service,
        ILogger<ProductsController> logger)
    {
        _service = service;
        _logger = logger;
    }
}
```

**How it works**:
1. ASP.NET Core sees controller needs `IProductService` and `ILogger<T>`
2. Checks DI container for registrations
3. Creates instances (respecting lifetimes)
4. Calls constructor with created instances
5. Returns controller ready to use

### 6. Interface-Based Dependencies

**Best practice**: Depend on interfaces, not concrete classes.

**Good**:
```csharp
public class ProductsController
{
    private readonly IProductService _service;  // Interface

    public ProductsController(IProductService service) { }
}
```

**Bad**:
```csharp
public class ProductsController
{
    private readonly ProductService _service;  // Concrete class

    public ProductsController(ProductService service) { }
}
```

**Why interfaces?**
- **Testability**: Can inject mock implementations
- **Flexibility**: Can swap implementations without changing consumers
- **Loose coupling**: Depend on contract, not implementation

### 7. Dependency Chain

Services can depend on other services:

```csharp
// Service layer
public class ProductService : IProductService
{
    private readonly IProductRepository _repository;  // Depends on repository

    public ProductService(IProductRepository repository)
    {
        _repository = repository;
    }
}

// Repository layer
public class ProductRepository : IProductRepository
{
    private readonly AppDbContext _context;  // Depends on DbContext

    public ProductRepository(AppDbContext context)
    {
        _context = context;
    }
}

// Controller
public class ProductsController : ControllerBase
{
    private readonly IProductService _service;  // Depends on service

    public ProductsController(IProductService service)
    {
        _service = service;
    }
}
```

**Dependency Chain**:
```
ProductsController
  ↓ depends on
IProductService (ProductService)
  ↓ depends on
IProductRepository (ProductRepository)
  ↓ depends on
AppDbContext
```

The DI container resolves the entire chain automatically!

### 8. Service Locator Anti-Pattern

**Anti-pattern** (avoid):

```csharp
public class ProductsController : ControllerBase
{
    private readonly IServiceProvider _serviceProvider;

    public ProductsController(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
    }

    public IActionResult Get()
    {
        // BAD: Manually resolving from container
        var service = _serviceProvider.GetService<IProductService>();
        return Ok(service.GetAll());
    }
}
```

**Why it's bad**:
- Hides dependencies (not visible in constructor)
- Runtime errors instead of compile-time
- Hard to test

**Use constructor injection instead**.

---

## Installation Guide

**Good news**: Dependency Injection is built into ASP.NET Core - no additional packages needed!

The DI container is part of:
```xml
<PackageReference Include="Microsoft.Extensions.DependencyInjection" Version="8.0.0" />
```

This is already included when you create an ASP.NET Core project.

### Optional: Advanced DI Containers

For advanced scenarios, you can replace the built-in container:

- **Autofac**: More features, convention-based registration
- **Ninject**: Simple and extensible
- **Castle Windsor**: Enterprise-grade features

**For most applications, the built-in container is sufficient**.

---

## Initial Setup & Configuration

### Project Structure with DI

Recommended folder structure:

```
MyProject/
├── Data/
│   ├── AppDbContext.cs
│   └── Entities/
│       └── Product.cs
├── Repositories/           # Data access layer
│   ├── IProductRepository.cs
│   └── ProductRepository.cs
├── Services/              # Business logic layer
│   ├── IProductService.cs
│   └── ProductService.cs
├── Controllers/
│   └── ProductsController.cs
└── Program.cs            # Service registration here
```

### Registering Services in Program.cs

**All service registrations happen in `Program.cs`**:

```csharp
var builder = WebApplication.CreateBuilder(args);

// ===== Framework Services =====
builder.Services.AddControllers();

// ===== Database =====
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("DefaultConnection")));

// ===== Application Services =====
// Scoped (one per request)
builder.Services.AddScoped<IProductRepository, ProductRepository>();
builder.Services.AddScoped<IProductService, ProductService>();

// Transient (new each time)
builder.Services.AddTransient<IEmailService, EmailService>();

// Singleton (one for app lifetime)
builder.Services.AddSingleton<ICacheService, MemoryCacheService>();

var app = builder.Build();

app.MapControllers();
app.Run();
```

### Organizing Service Registration

For large applications, create extension methods:

```csharp
// Extensions/ServiceCollectionExtensions.cs
public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddApplicationServices(this IServiceCollection services)
    {
        // Repositories
        services.AddScoped<IProductRepository, ProductRepository>();
        services.AddScoped<ICategoryRepository, CategoryRepository>();

        // Services
        services.AddScoped<IProductService, ProductService>();
        services.AddScoped<ICategoryService, CategoryService>();
        services.AddTransient<IEmailService, EmailService>();

        // Utilities
        services.AddSingleton<ICacheService, MemoryCacheService>();

        return services;
    }
}

// Program.cs
builder.Services.AddApplicationServices();
```

---

## Basic Usage

### Example 1: Simple Service Injection

**Step 1**: Create interface and implementation

```csharp
// Services/IGreetingService.cs
public interface IGreetingService
{
    string GetGreeting(string name);
}

// Services/GreetingService.cs
public class GreetingService : IGreetingService
{
    public string GetGreeting(string name)
    {
        return $"Hello, {name}!";
    }
}
```

**Step 2**: Register service

```csharp
// Program.cs
builder.Services.AddTransient<IGreetingService, GreetingService>();
```

**Step 3**: Inject into controller

```csharp
[ApiController]
[Route("api/[controller]")]
public class GreetingsController : ControllerBase
{
    private readonly IGreetingService _greetingService;

    public GreetingsController(IGreetingService greetingService)
    {
        _greetingService = greetingService;
    }

    [HttpGet("{name}")]
    public IActionResult Greet(string name)
    {
        var greeting = _greetingService.GetGreeting(name);
        return Ok(new { message = greeting });
    }
}
```

### Example 2: Service with Dependencies

**Service depends on DbContext**:

```csharp
public interface IProductService
{
    List<Product> GetAll();
    Product GetById(int id);
}

public class ProductService : IProductService
{
    private readonly AppDbContext _context;

    // DbContext injected here
    public ProductService(AppDbContext context)
    {
        _context = context;
    }

    public List<Product> GetAll()
    {
        return _context.Products.ToList();
    }

    public Product GetById(int id)
    {
        return _context.Products.Find(id);
    }
}
```

**Registration**:

```csharp
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite("Data Source=app.db"));

builder.Services.AddScoped<IProductService, ProductService>();
```

**Usage in controller**:

```csharp
public class ProductsController : ControllerBase
{
    private readonly IProductService _service;

    public ProductsController(IProductService service)
    {
        _service = service;
    }

    [HttpGet]
    public ActionResult<List<Product>> GetAll()
    {
        return _service.GetAll();
    }
}
```

### Example 3: Multiple Dependencies

**Controller with multiple services**:

```csharp
[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    private readonly IProductService _productService;
    private readonly ILogger<ProductsController> _logger;
    private readonly IMapper _mapper;

    public ProductsController(
        IProductService productService,
        ILogger<ProductsController> logger,
        IMapper mapper)
    {
        _productService = productService;
        _logger = logger;
        _mapper = mapper;
    }

    [HttpGet]
    public ActionResult<List<ProductDto>> GetAll()
    {
        _logger.LogInformation("Getting all products");

        var products = _productService.GetAll();
        var dtos = _mapper.Map<List<ProductDto>>(products);

        return dtos;
    }
}
```

### Example 4: Injecting Configuration

**Inject `IConfiguration` to access appsettings.json**:

```csharp
public class EmailService : IEmailService
{
    private readonly string _smtpServer;
    private readonly int _smtpPort;

    public EmailService(IConfiguration configuration)
    {
        _smtpServer = configuration["Email:SmtpServer"];
        _smtpPort = int.Parse(configuration["Email:SmtpPort"]);
    }

    public void SendEmail(string to, string subject, string body)
    {
        // Use _smtpServer and _smtpPort
    }
}
```

**appsettings.json**:

```json
{
  "Email": {
    "SmtpServer": "smtp.gmail.com",
    "SmtpPort": 587
  }
}
```

### Example 5: Lifetime Demonstration

```csharp
public interface ICounterService
{
    int Increment();
    int GetCount();
}

public class CounterService : ICounterService
{
    private int _count = 0;

    public int Increment() => ++_count;
    public int GetCount() => _count;
}

// Register with different lifetimes to see behavior
builder.Services.AddTransient<ICounterService, CounterService>();  // Try this
// builder.Services.AddScoped<ICounterService, CounterService>();  // Then this
// builder.Services.AddSingleton<ICounterService, CounterService>(); // Then this

// Controller
public class CounterController : ControllerBase
{
    private readonly ICounterService _counter1;
    private readonly ICounterService _counter2;

    public CounterController(ICounterService counter1, ICounterService counter2)
    {
        _counter1 = counter1;
        _counter2 = counter2;
    }

    [HttpGet]
    public IActionResult Get()
    {
        _counter1.Increment();
        _counter2.Increment();

        return Ok(new
        {
            counter1 = _counter1.GetCount(),
            counter2 = _counter2.GetCount(),
            areSame = object.ReferenceEquals(_counter1, _counter2)
        });
    }
}
```

**Results**:
- **Transient**: `counter1 = 1, counter2 = 1, areSame = false` (different instances)
- **Scoped**: `counter1 = 2, counter2 = 2, areSame = true` (same instance per request)
- **Singleton**: Counts keep increasing across requests, same instance

---

## Testing & Validation

### Unit Testing with DI

DI makes testing easy - inject mocks instead of real implementations:

```csharp
using Moq;
using Xunit;

public class ProductsControllerTests
{
    [Fact]
    public void GetAll_ReturnsAllProducts()
    {
        // Arrange
        var mockService = new Mock<IProductService>();
        mockService.Setup(s => s.GetAll())
            .Returns(new List<Product>
            {
                new Product { Id = 1, Name = "Product 1" },
                new Product { Id = 2, Name = "Product 2" }
            });

        var controller = new ProductsController(mockService.Object);

        // Act
        var result = controller.GetAll();

        // Assert
        var okResult = Assert.IsType<ActionResult<List<Product>>>(result);
        var products = okResult.Value;
        Assert.Equal(2, products.Count);
    }
}
```

### Integration Testing with TestServer

```csharp
using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;

public class ProductsApiTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public ProductsApiTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task GetProducts_ReturnsSuccessStatusCode()
    {
        // Act
        var response = await _client.GetAsync("/api/products");

        // Assert
        response.EnsureSuccessStatusCode();
    }
}
```

### Testing Service Resolution

```csharp
[Fact]
public void ServiceProvider_ResolvesProductService()
{
    // Arrange
    var services = new ServiceCollection();
    services.AddScoped<IProductService, ProductService>();
    services.AddDbContext<AppDbContext>(options =>
        options.UseInMemoryDatabase("TestDb"));

    var provider = services.BuildServiceProvider();

    // Act
    var service = provider.GetService<IProductService>();

    // Assert
    Assert.NotNull(service);
    Assert.IsType<ProductService>(service);
}
```

---

## Practical Examples

### Example 1: Repository Pattern with DI

**Complete layered architecture**:

```csharp
// 1. Repository Interface
public interface IProductRepository
{
    List<Product> GetAll();
    Product GetById(int id);
    void Add(Product product);
    void Update(Product product);
    void Delete(int id);
}

// 2. Repository Implementation
public class ProductRepository : IProductRepository
{
    private readonly AppDbContext _context;

    public ProductRepository(AppDbContext context)
    {
        _context = context;
    }

    public List<Product> GetAll() => _context.Products.ToList();

    public Product GetById(int id) => _context.Products.Find(id);

    public void Add(Product product)
    {
        _context.Products.Add(product);
        _context.SaveChanges();
    }

    public void Update(Product product)
    {
        _context.Products.Update(product);
        _context.SaveChanges();
    }

    public void Delete(int id)
    {
        var product = _context.Products.Find(id);
        if (product != null)
        {
            _context.Products.Remove(product);
            _context.SaveChanges();
        }
    }
}

// 3. Service Interface
public interface IProductService
{
    List<ProductDto> GetAll();
    ProductDto GetById(int id);
    ProductDto Create(ProductCreateDto dto);
}

// 4. Service Implementation
public class ProductService : IProductService
{
    private readonly IProductRepository _repository;
    private readonly IMapper _mapper;

    public ProductService(IProductRepository repository, IMapper mapper)
    {
        _repository = repository;
        _mapper = mapper;
    }

    public List<ProductDto> GetAll()
    {
        var products = _repository.GetAll();
        return _mapper.Map<List<ProductDto>>(products);
    }

    public ProductDto GetById(int id)
    {
        var product = _repository.GetById(id);
        return _mapper.Map<ProductDto>(product);
    }

    public ProductDto Create(ProductCreateDto dto)
    {
        var product = _mapper.Map<Product>(dto);
        _repository.Add(product);
        return _mapper.Map<ProductDto>(product);
    }
}

// 5. Register all services
builder.Services.AddScoped<IProductRepository, ProductRepository>();
builder.Services.AddScoped<IProductService, ProductService>();

// 6. Controller
public class ProductsController : ControllerBase
{
    private readonly IProductService _service;

    public ProductsController(IProductService service)
    {
        _service = service;
    }

    [HttpGet]
    public ActionResult<List<ProductDto>> GetAll() => _service.GetAll();

    [HttpPost]
    public ActionResult<ProductDto> Create(ProductCreateDto dto)
    {
        var product = _service.Create(dto);
        return CreatedAtAction(nameof(GetById), new { id = product.Id }, product);
    }
}
```

### Example 2: Service with Options Pattern

**Strongly-typed configuration**:

```csharp
// 1. Options class
public class EmailSettings
{
    public string SmtpServer { get; set; }
    public int SmtpPort { get; set; }
    public string FromEmail { get; set; }
    public string FromName { get; set; }
}

// 2. Service using options
public class EmailService : IEmailService
{
    private readonly EmailSettings _settings;

    public EmailService(IOptions<EmailSettings> options)
    {
        _settings = options.Value;
    }

    public void SendEmail(string to, string subject, string body)
    {
        // Use _settings.SmtpServer, _settings.SmtpPort, etc.
        Console.WriteLine($"Sending email via {_settings.SmtpServer}:{_settings.SmtpPort}");
    }
}

// 3. Register with configuration
builder.Services.Configure<EmailSettings>(
    builder.Configuration.GetSection("EmailSettings"));

builder.Services.AddTransient<IEmailService, EmailService>();

// appsettings.json
{
  "EmailSettings": {
    "SmtpServer": "smtp.gmail.com",
    "SmtpPort": 587,
    "FromEmail": "noreply@example.com",
    "FromName": "My App"
  }
}
```

### Example 3: Multiple Implementations

**Scenario**: Different implementations based on environment.

```csharp
// Interface
public interface INotificationService
{
    void Notify(string message);
}

// Implementation 1: Real email sender
public class EmailNotificationService : INotificationService
{
    public void Notify(string message)
    {
        // Send real email
        Console.WriteLine($"Email sent: {message}");
    }
}

// Implementation 2: Logging (for development)
public class LogNotificationService : INotificationService
{
    private readonly ILogger<LogNotificationService> _logger;

    public LogNotificationService(ILogger<LogNotificationService> logger)
    {
        _logger = logger;
    }

    public void Notify(string message)
    {
        _logger.LogInformation($"Notification: {message}");
    }
}

// Register based on environment
if (builder.Environment.IsDevelopment())
{
    builder.Services.AddSingleton<INotificationService, LogNotificationService>();
}
else
{
    builder.Services.AddSingleton<INotificationService, EmailNotificationService>();
}
```

### Example 4: Named Services with Factory Pattern

**When you need multiple implementations**:

```csharp
public interface IPaymentProcessor
{
    void ProcessPayment(decimal amount);
}

public class CreditCardProcessor : IPaymentProcessor
{
    public void ProcessPayment(decimal amount)
    {
        Console.WriteLine($"Processing ${amount} via credit card");
    }
}

public class PayPalProcessor : IPaymentProcessor
{
    public void ProcessPayment(decimal amount)
    {
        Console.WriteLine($"Processing ${amount} via PayPal");
    }
}

// Factory
public class PaymentProcessorFactory
{
    private readonly IServiceProvider _serviceProvider;

    public PaymentProcessorFactory(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
    }

    public IPaymentProcessor GetProcessor(string type)
    {
        return type switch
        {
            "CreditCard" => _serviceProvider.GetService<CreditCardProcessor>(),
            "PayPal" => _serviceProvider.GetService<PayPalProcessor>(),
            _ => throw new ArgumentException($"Unknown payment type: {type}")
        };
    }
}

// Registration
builder.Services.AddTransient<CreditCardProcessor>();
builder.Services.AddTransient<PayPalProcessor>();
builder.Services.AddSingleton<PaymentProcessorFactory>();

// Usage
public class OrdersController : ControllerBase
{
    private readonly PaymentProcessorFactory _factory;

    public OrdersController(PaymentProcessorFactory factory)
    {
        _factory = factory;
    }

    [HttpPost("pay")]
    public IActionResult Pay(string paymentType, decimal amount)
    {
        var processor = _factory.GetProcessor(paymentType);
        processor.ProcessPayment(amount);
        return Ok();
    }
}
```

---

## Common Patterns & Best Practices

### 1. Prefer Constructor Injection

**Good**:
```csharp
public class ProductsController
{
    private readonly IProductService _service;

    public ProductsController(IProductService service)
    {
        _service = service;
    }
}
```

**Avoid**: Property injection, method injection, service locator

### 2. Depend on Interfaces, Not Implementations

**Good**:
```csharp
private readonly IProductService _service;
```

**Bad**:
```csharp
private readonly ProductService _service;  // Concrete class
```

### 3. Use Appropriate Lifetimes

| Service Type | Recommended Lifetime | Reason |
|-------------|---------------------|---------|
| `DbContext` | Scoped | One per request, not thread-safe |
| Repositories | Scoped | Usually depend on DbContext |
| Services | Scoped | Usually depend on repositories |
| Utilities (stateless) | Transient | Lightweight, no state |
| Configuration | Singleton | Immutable, expensive to create |
| Cache | Singleton | Shared state across requests |
| Logging | Singleton | Thread-safe, shared resource |

### 4. Avoid Captive Dependencies

**Problem**: Long-lived service depends on short-lived service.

**BAD**:
```csharp
// Singleton depends on Scoped - WRONG!
builder.Services.AddSingleton<ICacheService, CacheService>();  // Lives forever
builder.Services.AddScoped<IProductRepository, ProductRepository>();  // Per request

public class CacheService : ICacheService
{
    private readonly IProductRepository _repository;  // PROBLEM!

    public CacheService(IProductRepository repository)
    {
        // Repository is kept alive for entire app lifetime
        // But it should only live for one request!
        _repository = repository;
    }
}
```

**GOOD**:
```csharp
// Use IServiceProvider to resolve per-request dependencies
public class CacheService : ICacheService
{
    private readonly IServiceProvider _serviceProvider;

    public CacheService(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
    }

    public void RefreshCache()
    {
        using var scope = _serviceProvider.CreateScope();
        var repository = scope.ServiceProvider.GetRequiredService<IProductRepository>();
        // Use repository...
    }
}
```

### 5. Register Services in Logical Order

```csharp
// 1. Framework services
builder.Services.AddControllers();

// 2. Database
builder.Services.AddDbContext<AppDbContext>(...);

// 3. Infrastructure services
builder.Services.AddScoped<IEmailService, EmailService>();

// 4. Repositories
builder.Services.AddScoped<IProductRepository, ProductRepository>();

// 5. Business services
builder.Services.AddScoped<IProductService, ProductService>();

// 6. Configuration
builder.Services.Configure<AppSettings>(configuration.GetSection("AppSettings"));
```

### 6. Use Extension Methods for Organization

```csharp
public static class DependencyInjectionExtensions
{
    public static IServiceCollection AddRepositories(this IServiceCollection services)
    {
        services.AddScoped<IProductRepository, ProductRepository>();
        services.AddScoped<ICategoryRepository, CategoryRepository>();
        return services;
    }

    public static IServiceCollection AddBusinessServices(this IServiceCollection services)
    {
        services.AddScoped<IProductService, ProductService>();
        services.AddScoped<ICategoryService, CategoryService>();
        return services;
    }
}

// Program.cs
builder.Services.AddRepositories();
builder.Services.AddBusinessServices();
```

### 7. Validate Service Registration

```csharp
// Development: validate on startup
if (builder.Environment.IsDevelopment())
{
    builder.Services.AddOptions<EmailSettings>()
        .Bind(builder.Configuration.GetSection("EmailSettings"))
        .ValidateDataAnnotations()
        .ValidateOnStart();
}
```

### 8. Document Service Dependencies

```csharp
/// <summary>
/// Service for managing products.
/// Dependencies: IProductRepository, IMapper
/// Lifetime: Scoped
/// </summary>
public class ProductService : IProductService
{
    private readonly IProductRepository _repository;
    private readonly IMapper _mapper;

    public ProductService(IProductRepository repository, IMapper mapper)
    {
        _repository = repository;
        _mapper = mapper;
    }
}
```

---

## Troubleshooting

### Issue 1: "Unable to resolve service"

**Symptom**:
```
InvalidOperationException: Unable to resolve service for type 'IProductService' while attempting to activate 'ProductsController'.
```

**Cause**: Service not registered in DI container.

**Solution**:

```csharp
// Add registration in Program.cs
builder.Services.AddScoped<IProductService, ProductService>();
```

### Issue 2: Circular Dependency

**Symptom**:
```
InvalidOperationException: A circular dependency was detected.
```

**Cause**: Service A depends on Service B, which depends on Service A.

**Example**:
```csharp
public class ServiceA
{
    public ServiceA(ServiceB b) { }
}

public class ServiceB
{
    public ServiceB(ServiceA a) { }  // Circular!
}
```

**Solution**: Refactor to remove circular dependency. Extract shared logic to a third service.

### Issue 3: Captive Dependency

**Symptom**: Unexpected behavior, stale data, `ObjectDisposedException`.

**Cause**: Singleton or longer-lived service depends on shorter-lived service.

**Solution**: Use `IServiceProvider` to create scopes:

```csharp
public class SingletonService
{
    private readonly IServiceProvider _serviceProvider;

    public SingletonService(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
    }

    public void DoWork()
    {
        using var scope = _serviceProvider.CreateScope();
        var scopedService = scope.ServiceProvider.GetRequiredService<IScopedService>();
        // Use scopedService...
    }
}
```

### Issue 4: DbContext Already Disposed

**Symptom**:
```
ObjectDisposedException: Cannot access a disposed context instance.
```

**Cause**: DbContext injected as Singleton or used outside its lifetime.

**Solution**: Always register DbContext as Scoped:

```csharp
builder.Services.AddDbContext<AppDbContext>(options => ..., ServiceLifetime.Scoped);
```

### Issue 5: Multiple Implementations Registered

**Symptom**: Wrong implementation is injected.

**Cause**: Multiple registrations for same interface.

```csharp
builder.Services.AddScoped<IProductService, ProductService>();
builder.Services.AddScoped<IProductService, CachedProductService>();  // This one wins!
```

**Solution**: Last registration wins. Remove duplicate or use named services/factory pattern.

### Issue 6: Null Reference in Constructor

**Symptom**: Constructor parameter is null.

**Cause**: Service registered but dependency chain is broken.

**Solution**: Ensure all dependencies in the chain are registered:

```csharp
// If ProductService depends on IProductRepository, both must be registered
builder.Services.AddScoped<IProductRepository, ProductRepository>();
builder.Services.AddScoped<IProductService, ProductService>();
```

---

## Additional Resources

### Official Documentation

- [Dependency Injection in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection) - Microsoft's comprehensive guide
- [Service Lifetimes](https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection#service-lifetimes) - Detailed lifetime explanation
- [Dependency Injection Guidelines](https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection-guidelines) - Best practices

### Books

- **"Dependency Injection Principles, Practices, and Patterns"** by Steven van Deursen and Mark Seemann - The definitive DI book

### Articles

- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID) - Foundational OOP principles
- [Inversion of Control](https://martinfowler.com/bliki/InversionOfControl.html) - Martin Fowler's explanation
- [Service Locator Anti-Pattern](https://blog.ploeh.dk/2010/02/03/ServiceLocatorisanAnti-Pattern/) - Why to avoid it

### Video Tutorials

- [Dependency Injection in .NET](https://www.youtube.com/results?search_query=dependency+injection+.net+core) - YouTube tutorials
- [.NET Conf Sessions](https://www.youtube.com/playlist?list=PLdo4fOcmZ0oVlqu_V8EAyDMN-OiJY8d1X) - Official presentations

### Community Resources

- [Stack Overflow - Dependency Injection Tag](https://stackoverflow.com/questions/tagged/dependency-injection)
- [r/dotnet Subreddit](https://www.reddit.com/r/dotnet/)

### Related Topics

1. **[Controllers and Routing](controllers-and-routing.md)** - Where services are injected
2. **Unit Testing** - DI makes testing easier
3. **Repository Pattern** - Common pattern using DI
4. **Options Pattern** - Injecting configuration

---

## Self-Assessment Checklist

After completing this guide, you should be able to:

- [ ] Explain what Dependency Injection is and why it's beneficial
- [ ] Understand Inversion of Control (IoC) principle
- [ ] Differentiate between Transient, Scoped, and Singleton lifetimes
- [ ] Register services in the DI container
- [ ] Inject services into controllers via constructor
- [ ] Create interfaces for services
- [ ] Build layered architecture with DI (Repository → Service → Controller)
- [ ] Choose appropriate service lifetimes
- [ ] Avoid captive dependencies
- [ ] Use Options pattern for configuration
- [ ] Test classes that use DI
- [ ] Troubleshoot common DI issues

---

## Summary

**Dependency Injection** is a fundamental pattern in ASP.NET Core that enables loose coupling, testability, and maintainability. Key takeaways:

1. **DI inverts control** - Framework creates and manages objects, not you
2. **Three service lifetimes** - Transient (new each time), Scoped (per request), Singleton (one instance)
3. **Register services in Program.cs** - Use `AddTransient`, `AddScoped`, `AddSingleton`
4. **Constructor injection** - Dependencies injected via constructor parameters
5. **Depend on interfaces** - Use `IService` not `Service` for flexibility
6. **Choose lifetime carefully** - DbContext = Scoped, Cache = Singleton, Utilities = Transient
7. **Avoid captive dependencies** - Don't inject short-lived services into long-lived ones
8. **Use DI for testability** - Easy to inject mocks in unit tests

**Next Steps**:
- Practice creating services with DI
- Build layered architecture (Repository → Service → Controller)
- Experiment with different service lifetimes
- Write unit tests using mock services
- Learn about advanced patterns (Factory, Strategy with DI)

Remember: DI is not just a technique - it's a mindset. Design your classes to receive dependencies rather than create them, and your code will be more flexible, testable, and maintainable.

Happy injecting!
