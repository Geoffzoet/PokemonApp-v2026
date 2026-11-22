# Data Transfer Objects (DTOs)

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

### What Are DTOs?

A **Data Transfer Object (DTO)** is a simple object used to transfer data between different layers of an application, particularly between your API and clients. DTOs are "dumb" objects - they carry data but contain no business logic.

**Real-World Analogy**: Think of DTOs like forms at a government office. The office has complex internal records (entities) with sensitive information, but when you interact with them, they give you simplified forms (DTOs) that only show what you need to see and only accept the data you're allowed to provide.

### Why Use DTOs?

**Without DTOs**, you might return entities directly from your API:

```csharp
// DANGEROUS: Exposing entity directly
[HttpGet("{id}")]
public User GetUser(int id)
{
    return _context.Users.Find(id);  // Returns User entity with password!
}
```

**Problems**:
- Exposes sensitive data (passwords, internal IDs)
- Tight coupling between database schema and API
- Over-fetching data (sending unnecessary fields)
- Circular reference issues with navigation properties

**With DTOs**:

```csharp
[HttpGet("{id}")]
public UserDto GetUser(int id)
{
    var user = _context.Users.Find(id);
    return new UserDto
    {
        Id = user.Id,
        Name = user.Name,
        Email = user.Email
        // Password is NOT included!
    };
}
```

### Key Benefits

| Benefit | Description |
|---------|-------------|
| **Security** | Control exactly what data is exposed |
| **API Stability** | Change database schema without breaking API |
| **Performance** | Send only necessary data over the network |
| **Separation of Concerns** | API contract independent from data model |
| **Version Control** | Support multiple API versions with different DTOs |
| **Validation** | Apply different validation rules for create/update operations |

### When to Use DTOs

**Use DTOs when**:
- Building public APIs
- Need to hide sensitive entity properties
- API shape differs from database schema
- Want to decouple API from data model
- Need different representations for create/update/read operations

**Consider skipping DTOs when**:
- Building quick prototypes or POCs
- Internal services where entities are acceptable
- Simple CRUD with no sensitive data
- Very small projects with tight deadlines

---

## Quick Start

Here's the fastest way to use DTOs:

```csharp
// 1. Define your entity
public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
    public decimal Cost { get; set; }  // SENSITIVE - don't expose
    public int InternalSupplierId { get; set; }  // INTERNAL - don't expose
}

// 2. Create a DTO
public class ProductDto
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
    // Cost and InternalSupplierId are NOT included
}

// 3. Map entity to DTO in controller
[HttpGet("{id}")]
public ActionResult<ProductDto> GetProduct(int id)
{
    var product = _context.Products.Find(id);
    if (product == null) return NotFound();

    // Manual mapping
    var dto = new ProductDto
    {
        Id = product.Id,
        Name = product.Name,
        Price = product.Price
    };

    return dto;
}
```

**Result**: Your API exposes only public data, keeping sensitive fields hidden.

---

## Prerequisites

### Required Knowledge

Before working with DTOs, you should understand:
- **C# Classes and Properties**: DTOs are simple POCO classes
- **ASP.NET Core Controllers**: Where DTOs are used (see [Controllers and Routing](controllers-and-routing.md))
- **Entity Framework Core**: Understanding entities (see [EF Core Fundamentals](entity-framework-core-fundamentals.md))
- **HTTP APIs**: REST principles and HTTP methods

### Required Tools

| Tool | Version | Purpose |
|------|---------|---------|
| .NET SDK | 8.0+ | Core framework |
| Entity Framework Core | 8.0+ | Data access |
| AutoMapper (optional) | 12.0+ | Automatic mapping |

---

## Core Concepts & Theory

### 1. Entity vs DTO

Understanding the difference is crucial:

| Aspect | Entity | DTO |
|--------|--------|-----|
| **Purpose** | Represents database table | Represents API data contract |
| **Location** | Data layer | API/presentation layer |
| **Logic** | May contain business logic | Contains NO logic |
| **Navigation** | Has navigation properties | Usually flattened |
| **Attributes** | Has EF annotations | Has validation annotations |
| **Lifetime** | Tracked by EF Core | Temporary, request-scoped |
| **Example** | `User`, `Order`, `Product` | `UserDto`, `OrderDto`, `ProductDto` |

**Example comparison**:

```csharp
// ENTITY - Database representation
public class User
{
    public int Id { get; set; }
    public string Username { get; set; }
    public string PasswordHash { get; set; }  // Sensitive
    public string Email { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? LastLogin { get; set; }
    public bool IsDeleted { get; set; }  // Soft delete flag

    // Navigation properties
    public List<Order> Orders { get; set; }  // Can cause circular refs
}

// DTO - API representation
public class UserDto
{
    public int Id { get; set; }
    public string Username { get; set; }
    public string Email { get; set; }
    // No password, no internal flags, no navigation properties
}
```

### 2. DTO Types

Different operations need different DTOs:

#### Read DTO (GET)

Shows data to users:

```csharp
public class ProductDto  // or ProductReadDto
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
    public string CategoryName { get; set; }  // Flattened from Category.Name
}
```

#### Create DTO (POST)

Accepts data for creating new records:

```csharp
public class ProductCreateDto
{
    [Required]
    [StringLength(100)]
    public string Name { get; set; }

    [Required]
    [Range(0.01, 10000)]
    public decimal Price { get; set; }

    [Required]
    public int CategoryId { get; set; }  // ID, not full category

    // No Id - database generates it
}
```

#### Update DTO (PUT/PATCH)

Accepts data for updating existing records:

```csharp
public class ProductUpdateDto
{
    // Id is usually in the route, not the DTO
    [Required]
    [StringLength(100)]
    public string Name { get; set; }

    [Required]
    [Range(0.01, 10000)]
    public decimal Price { get; set; }

    public int CategoryId { get; set; }
}
```

### 3. Mapping Strategies

#### Manual Mapping

**Explicit property assignment**:

```csharp
var dto = new ProductDto
{
    Id = product.Id,
    Name = product.Name,
    Price = product.Price
};
```

**Pros**: Simple, no dependencies, full control
**Cons**: Repetitive, error-prone for complex objects

#### Mapping Methods

**Extract mapping to methods**:

```csharp
public static class ProductMappings
{
    public static ProductDto ToDto(this Product product)
    {
        return new ProductDto
        {
            Id = product.Id,
            Name = product.Name,
            Price = product.Price,
            CategoryName = product.Category?.Name
        };
    }

    public static Product ToEntity(this ProductCreateDto dto)
    {
        return new Product
        {
            Name = dto.Name,
            Price = dto.Price,
            CategoryId = dto.CategoryId
        };
    }
}

// Usage in controller
var dto = product.ToDto();
```

**Pros**: Reusable, cleaner controllers
**Cons**: Still manual, needs updates when properties change

#### Automatic Mapping (AutoMapper)

**Configuration-based mapping**:

```csharp
// Configure once
public class MappingProfile : Profile
{
    public MappingProfile()
    {
        CreateMap<Product, ProductDto>()
            .ForMember(dest => dest.CategoryName,
                      opt => opt.MapFrom(src => src.Category.Name));

        CreateMap<ProductCreateDto, Product>();
    }
}

// Use anywhere
var dto = _mapper.Map<ProductDto>(product);
var product = _mapper.Map<Product>(createDto);
```

**Pros**: Less code, convention-based, powerful
**Cons**: "Magic" behavior, learning curve, slight performance overhead

### 4. Flattening

**Flattening** means converting complex nested objects into flat structures:

```csharp
// Entity with navigation property
public class Order
{
    public int Id { get; set; }
    public DateTime OrderDate { get; set; }
    public Customer Customer { get; set; }  // Nested object
}

public class Customer
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Email { get; set; }
}

// Flattened DTO
public class OrderDto
{
    public int Id { get; set; }
    public DateTime OrderDate { get; set; }
    public int CustomerId { get; set; }  // Just the ID
    public string CustomerName { get; set; }  // Flattened from Customer.Name
    public string CustomerEmail { get; set; }  // Flattened from Customer.Email
}
```

**Benefits**:
- Avoids circular references
- Reduces JSON payload size
- Prevents lazy loading issues
- Simplifies client-side code

### 5. Projection

**Projection** means selecting DTO data directly in queries (more efficient):

```csharp
// BAD: Load full entities then map
var products = _context.Products.Include(p => p.Category).ToList();
var dtos = products.Select(p => new ProductDto { ... }).ToList();

// GOOD: Project to DTO in query
var dtos = _context.Products
    .Select(p => new ProductDto
    {
        Id = p.Id,
        Name = p.Name,
        Price = p.Price,
        CategoryName = p.Category.Name
    })
    .ToList();
```

The second approach generates SQL that selects only the needed columns.

### 6. DTO Naming Conventions

| Convention | Example | Usage |
|------------|---------|-------|
| Suffix | `ProductDto` | General purpose read DTO |
| Operation suffix | `ProductCreateDto`, `ProductUpdateDto` | Specific operations |
| Read suffix | `ProductReadDto` | Explicit read DTO |
| Response/Request | `ProductResponse`, `CreateProductRequest` | RESTful style |

**Choose one convention and stick with it** across your project.

---

## Installation Guide

### Core Packages (Already Installed)

If you followed previous guides, you already have:

```xml
<ItemGroup>
  <PackageReference Include="Microsoft.AspNetCore.Mvc.Core" Version="2.2.5" />
  <PackageReference Include="Microsoft.EntityFrameworkCore" Version="8.0.11" />
</ItemGroup>
```

### Optional: AutoMapper

For automatic mapping, install AutoMapper:

```bash
dotnet add package AutoMapper.Extensions.Microsoft.DependencyInjection
```

**Package reference**:

```xml
<ItemGroup>
  <PackageReference Include="AutoMapper.Extensions.Microsoft.DependencyInjection" Version="12.0.1" />
</ItemGroup>
```

---

## Initial Setup & Configuration

### Project Structure

Recommended folder structure:

```
MyProject/
├── Data/
│   ├── Entities/
│   │   ├── Product.cs
│   │   ├── Category.cs
│   │   └── User.cs
│   └── AppDbContext.cs
├── DTOs/
│   ├── ProductDto.cs
│   ├── ProductCreateDto.cs
│   ├── ProductUpdateDto.cs
│   ├── CategoryDto.cs
│   └── UserDto.cs
├── Mappings/              # Optional: for manual mapping extensions
│   └── ProductMappings.cs
├── Profiles/              # For AutoMapper
│   └── MappingProfile.cs
└── Controllers/
    └── ProductsController.cs
```

### Manual Mapping Setup

Create extension methods for mapping:

```csharp
// Mappings/ProductMappings.cs
namespace MyProject.Mappings
{
    public static class ProductMappings
    {
        public static ProductDto ToDto(this Product product)
        {
            if (product == null) return null;

            return new ProductDto
            {
                Id = product.Id,
                Name = product.Name,
                Price = product.Price,
                CategoryName = product.Category?.Name
            };
        }

        public static Product ToEntity(this ProductCreateDto dto)
        {
            return new Product
            {
                Name = dto.Name,
                Price = dto.Price,
                CategoryId = dto.CategoryId
            };
        }

        public static void UpdateEntity(this ProductUpdateDto dto, Product product)
        {
            product.Name = dto.Name;
            product.Price = dto.Price;
            product.CategoryId = dto.CategoryId;
        }
    }
}
```

### AutoMapper Setup

**Step 1**: Create mapping profile

```csharp
// Profiles/MappingProfile.cs
using AutoMapper;

public class MappingProfile : Profile
{
    public MappingProfile()
    {
        // Product mappings
        CreateMap<Product, ProductDto>()
            .ForMember(dest => dest.CategoryName,
                      opt => opt.MapFrom(src => src.Category.Name));

        CreateMap<ProductCreateDto, Product>();

        CreateMap<ProductUpdateDto, Product>();

        // Category mappings
        CreateMap<Category, CategoryDto>();
        CreateMap<CategoryCreateDto, Category>();
    }
}
```

**Step 2**: Register AutoMapper in `Program.cs`

```csharp
var builder = WebApplication.CreateBuilder(args);

// Add AutoMapper
builder.Services.AddAutoMapper(typeof(Program));

// Or specify assemblies explicitly
// builder.Services.AddAutoMapper(typeof(MappingProfile).Assembly);

var app = builder.Build();
app.Run();
```

**Step 3**: Inject `IMapper` in controllers

```csharp
[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly IMapper _mapper;

    public ProductsController(AppDbContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    // Use _mapper in actions...
}
```

---

## Basic Usage

### Example 1: Simple DTO Without Navigation Properties

**Entity**:

```csharp
public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
    public string Description { get; set; }
    public decimal Cost { get; set; }  // Don't expose
    public DateTime CreatedAt { get; set; }
    public bool IsDeleted { get; set; }  // Soft delete
}
```

**DTO**:

```csharp
public class ProductDto
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
    public string Description { get; set; }
    // Cost, CreatedAt, IsDeleted NOT included
}
```

**Controller**:

```csharp
[HttpGet]
public ActionResult<List<ProductDto>> GetAll()
{
    var products = _context.Products
        .Where(p => !p.IsDeleted)  // Filter soft-deleted
        .Select(p => new ProductDto
        {
            Id = p.Id,
            Name = p.Name,
            Price = p.Price,
            Description = p.Description
        })
        .ToList();

    return products;
}

[HttpGet("{id}")]
public ActionResult<ProductDto> GetById(int id)
{
    var product = _context.Products.Find(id);

    if (product == null || product.IsDeleted)
        return NotFound();

    var dto = new ProductDto
    {
        Id = product.Id,
        Name = product.Name,
        Price = product.Price,
        Description = product.Description
    };

    return dto;
}
```

### Example 2: Create DTO (POST)

**DTO**:

```csharp
public class ProductCreateDto
{
    [Required(ErrorMessage = "Product name is required")]
    [StringLength(100, MinimumLength = 3)]
    public string Name { get; set; }

    [Required]
    [Range(0.01, 1000000, ErrorMessage = "Price must be between 0.01 and 1,000,000")]
    public decimal Price { get; set; }

    [StringLength(500)]
    public string Description { get; set; }

    [Required]
    public int CategoryId { get; set; }
}
```

**Controller**:

```csharp
[HttpPost]
public ActionResult<ProductDto> Create(ProductCreateDto createDto)
{
    // Validation happens automatically via model binding

    // Map DTO to entity
    var product = new Product
    {
        Name = createDto.Name,
        Price = createDto.Price,
        Description = createDto.Description,
        CategoryId = createDto.CategoryId,
        CreatedAt = DateTime.UtcNow,
        IsDeleted = false
    };

    _context.Products.Add(product);
    _context.SaveChanges();

    // Map entity back to DTO
    var dto = new ProductDto
    {
        Id = product.Id,
        Name = product.Name,
        Price = product.Price,
        Description = product.Description
    };

    return CreatedAtAction(nameof(GetById), new { id = product.Id }, dto);
}
```

### Example 3: Update DTO (PUT)

**DTO**:

```csharp
public class ProductUpdateDto
{
    [Required]
    [StringLength(100, MinimumLength = 3)]
    public string Name { get; set; }

    [Required]
    [Range(0.01, 1000000)]
    public decimal Price { get; set; }

    [StringLength(500)]
    public string Description { get; set; }

    public int CategoryId { get; set; }
}
```

**Controller**:

```csharp
[HttpPut("{id}")]
public IActionResult Update(int id, ProductUpdateDto updateDto)
{
    var product = _context.Products.Find(id);

    if (product == null || product.IsDeleted)
        return NotFound();

    // Update entity properties
    product.Name = updateDto.Name;
    product.Price = updateDto.Price;
    product.Description = updateDto.Description;
    product.CategoryId = updateDto.CategoryId;

    _context.SaveChanges();

    return NoContent();
}
```

### Example 4: Using AutoMapper

**Same operations with AutoMapper**:

```csharp
[HttpGet]
public ActionResult<List<ProductDto>> GetAll()
{
    var products = _context.Products
        .Where(p => !p.IsDeleted)
        .ToList();

    return _mapper.Map<List<ProductDto>>(products);
}

[HttpPost]
public ActionResult<ProductDto> Create(ProductCreateDto createDto)
{
    var product = _mapper.Map<Product>(createDto);
    product.CreatedAt = DateTime.UtcNow;

    _context.Products.Add(product);
    _context.SaveChanges();

    var dto = _mapper.Map<ProductDto>(product);
    return CreatedAtAction(nameof(GetById), new { id = product.Id }, dto);
}

[HttpPut("{id}")]
public IActionResult Update(int id, ProductUpdateDto updateDto)
{
    var product = _context.Products.Find(id);
    if (product == null) return NotFound();

    _mapper.Map(updateDto, product);  // Maps properties onto existing entity
    _context.SaveChanges();

    return NoContent();
}
```

### Example 5: Nested DTOs

**Entities**:

```csharp
public class Order
{
    public int Id { get; set; }
    public DateTime OrderDate { get; set; }
    public int CustomerId { get; set; }
    public Customer Customer { get; set; }
    public List<OrderItem> Items { get; set; }
}

public class OrderItem
{
    public int Id { get; set; }
    public int ProductId { get; set; }
    public Product Product { get; set; }
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
}
```

**DTOs**:

```csharp
public class OrderDto
{
    public int Id { get; set; }
    public DateTime OrderDate { get; set; }
    public string CustomerName { get; set; }  // Flattened
    public List<OrderItemDto> Items { get; set; }
    public decimal TotalAmount { get; set; }  // Calculated
}

public class OrderItemDto
{
    public int ProductId { get; set; }
    public string ProductName { get; set; }  // Flattened
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal LineTotal { get; set; }  // Calculated
}
```

**Controller**:

```csharp
[HttpGet("{id}")]
public ActionResult<OrderDto> GetOrder(int id)
{
    var order = _context.Orders
        .Include(o => o.Customer)
        .Include(o => o.Items)
            .ThenInclude(i => i.Product)
        .FirstOrDefault(o => o.Id == id);

    if (order == null) return NotFound();

    var dto = new OrderDto
    {
        Id = order.Id,
        OrderDate = order.OrderDate,
        CustomerName = order.Customer.Name,
        Items = order.Items.Select(i => new OrderItemDto
        {
            ProductId = i.ProductId,
            ProductName = i.Product.Name,
            Quantity = i.Quantity,
            UnitPrice = i.UnitPrice,
            LineTotal = i.Quantity * i.UnitPrice
        }).ToList()
    };

    dto.TotalAmount = dto.Items.Sum(i => i.LineTotal);

    return dto;
}
```

---

## Testing & Validation

### Unit Testing DTOs

DTOs themselves don't need much testing, but mapping logic does:

```csharp
using Xunit;

public class ProductMappingTests
{
    [Fact]
    public void ToDto_MapsAllProperties()
    {
        // Arrange
        var product = new Product
        {
            Id = 1,
            Name = "Test Product",
            Price = 19.99m,
            Description = "Test description"
        };

        // Act
        var dto = product.ToDto();

        // Assert
        Assert.Equal(product.Id, dto.Id);
        Assert.Equal(product.Name, dto.Name);
        Assert.Equal(product.Price, dto.Price);
        Assert.Equal(product.Description, dto.Description);
    }

    [Fact]
    public void ToDto_DoesNotIncludeSensitiveData()
    {
        // Arrange
        var product = new Product
        {
            Id = 1,
            Name = "Test",
            Cost = 10m  // Sensitive
        };

        // Act
        var dto = product.ToDto();

        // Assert
        // Verify DTO type doesn't have Cost property
        var costProperty = typeof(ProductDto).GetProperty("Cost");
        Assert.Null(costProperty);
    }
}
```

### Testing AutoMapper Configuration

```csharp
using AutoMapper;
using Xunit;

public class MappingProfileTests
{
    [Fact]
    public void MappingProfile_IsValid()
    {
        // Arrange
        var configuration = new MapperConfiguration(cfg =>
            cfg.AddProfile<MappingProfile>());

        // Act & Assert
        configuration.AssertConfigurationIsValid();
    }

    [Fact]
    public void ProductToProductDto_MapsCorrectly()
    {
        // Arrange
        var config = new MapperConfiguration(cfg => cfg.AddProfile<MappingProfile>());
        var mapper = config.CreateMapper();

        var product = new Product
        {
            Id = 1,
            Name = "Test",
            Price = 10m,
            Category = new Category { Name = "Electronics" }
        };

        // Act
        var dto = mapper.Map<ProductDto>(product);

        // Assert
        Assert.Equal(product.Id, dto.Id);
        Assert.Equal(product.Name, dto.Name);
        Assert.Equal("Electronics", dto.CategoryName);
    }
}
```

### Integration Testing with DTOs

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
    public async Task CreateProduct_ReturnsProductDto()
    {
        // Arrange
        var createDto = new ProductCreateDto
        {
            Name = "New Product",
            Price = 29.99m,
            CategoryId = 1
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/products", createDto);

        // Assert
        response.EnsureSuccessStatusCode();

        var productDto = await response.Content.ReadFromJsonAsync<ProductDto>();
        Assert.NotNull(productDto);
        Assert.Equal(createDto.Name, productDto.Name);
        Assert.Equal(createDto.Price, productDto.Price);
    }

    [Fact]
    public async Task GetProduct_DoesNotExposeSensitiveData()
    {
        // Act
        var response = await _client.GetAsync("/api/products/1");
        var json = await response.Content.ReadAsStringAsync();

        // Assert
        Assert.DoesNotContain("\"cost\"", json.ToLower());
        Assert.DoesNotContain("\"passwordhash\"", json.ToLower());
    }
}
```

---

## Practical Examples

### Example 1: User Profile with Security

**Entity**:

```csharp
public class User
{
    public int Id { get; set; }
    public string Username { get; set; }
    public string Email { get; set; }
    public string PasswordHash { get; set; }  // NEVER expose
    public string Salt { get; set; }  // NEVER expose
    public DateTime CreatedAt { get; set; }
    public DateTime? LastLogin { get; set; }
    public bool IsActive { get; set; }
    public string Role { get; set; }  // "Admin", "User"
}
```

**DTOs**:

```csharp
// Public profile (what others see)
public class UserPublicDto
{
    public int Id { get; set; }
    public string Username { get; set; }
    public DateTime MemberSince { get; set; }  // Mapped from CreatedAt
}

// Private profile (what user sees about themselves)
public class UserPrivateDto
{
    public int Id { get; set; }
    public string Username { get; set; }
    public string Email { get; set; }
    public DateTime MemberSince { get; set; }
    public DateTime? LastLogin { get; set; }
    public bool IsActive { get; set; }
    // Still no password!
}

// Registration
public class UserRegisterDto
{
    [Required]
    [StringLength(50, MinimumLength = 3)]
    public string Username { get; set; }

    [Required]
    [EmailAddress]
    public string Email { get; set; }

    [Required]
    [StringLength(100, MinimumLength = 8)]
    public string Password { get; set; }  // Plain text in DTO, hashed before saving
}
```

**Controller**:

```csharp
[HttpGet("profile/{id}")]
public ActionResult<UserPublicDto> GetPublicProfile(int id)
{
    var user = _context.Users.Find(id);
    if (user == null) return NotFound();

    return new UserPublicDto
    {
        Id = user.Id,
        Username = user.Username,
        MemberSince = user.CreatedAt
    };
}

[HttpGet("me")]
[Authorize]  // Requires authentication
public ActionResult<UserPrivateDto> GetMyProfile()
{
    var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value);
    var user = _context.Users.Find(userId);

    return new UserPrivateDto
    {
        Id = user.Id,
        Username = user.Username,
        Email = user.Email,
        MemberSince = user.CreatedAt,
        LastLogin = user.LastLogin,
        IsActive = user.IsActive
    };
}

[HttpPost("register")]
public ActionResult<UserPrivateDto> Register(UserRegisterDto registerDto)
{
    // Hash password before saving
    var (hash, salt) = HashPassword(registerDto.Password);

    var user = new User
    {
        Username = registerDto.Username,
        Email = registerDto.Email,
        PasswordHash = hash,
        Salt = salt,
        CreatedAt = DateTime.UtcNow,
        IsActive = true,
        Role = "User"
    };

    _context.Users.Add(user);
    _context.SaveChanges();

    return new UserPrivateDto
    {
        Id = user.Id,
        Username = user.Username,
        Email = user.Email,
        MemberSince = user.CreatedAt
    };
}
```

### Example 2: Computed Properties in DTOs

**Scenario**: Calculate totals and format dates in DTOs.

```csharp
// Entity
public class Invoice
{
    public int Id { get; set; }
    public string InvoiceNumber { get; set; }
    public DateTime IssuedDate { get; set; }
    public DateTime DueDate { get; set; }
    public List<InvoiceItem> Items { get; set; }
    public decimal TaxRate { get; set; }
}

// DTO with computed properties
public class InvoiceDto
{
    public int Id { get; set; }
    public string InvoiceNumber { get; set; }
    public string IssuedDate { get; set; }  // Formatted as string
    public string DueDate { get; set; }
    public List<InvoiceItemDto> Items { get; set; }

    // Computed properties
    public decimal Subtotal { get; set; }
    public decimal TaxAmount { get; set; }
    public decimal Total { get; set; }
    public bool IsOverdue { get; set; }
}

// Controller
[HttpGet("{id}")]
public ActionResult<InvoiceDto> GetInvoice(int id)
{
    var invoice = _context.Invoices
        .Include(i => i.Items)
        .FirstOrDefault(i => i.Id == id);

    if (invoice == null) return NotFound();

    var subtotal = invoice.Items.Sum(i => i.Quantity * i.UnitPrice);
    var taxAmount = subtotal * invoice.TaxRate;
    var total = subtotal + taxAmount;

    return new InvoiceDto
    {
        Id = invoice.Id,
        InvoiceNumber = invoice.InvoiceNumber,
        IssuedDate = invoice.IssuedDate.ToString("yyyy-MM-dd"),
        DueDate = invoice.DueDate.ToString("yyyy-MM-dd"),
        Items = invoice.Items.Select(i => new InvoiceItemDto { ... }).ToList(),
        Subtotal = subtotal,
        TaxAmount = taxAmount,
        Total = total,
        IsOverdue = invoice.DueDate < DateTime.UtcNow
    };
}
```

### Example 3: Partial Updates with PATCH DTOs

**Scenario**: Allow updating only specific fields.

```csharp
// Partial update DTO (all properties nullable/optional)
public class ProductPatchDto
{
    public string Name { get; set; }  // null = don't update
    public decimal? Price { get; set; }  // null = don't update
    public string Description { get; set; }  // null = don't update
}

// Controller
[HttpPatch("{id}")]
public IActionResult PartialUpdate(int id, ProductPatchDto patchDto)
{
    var product = _context.Products.Find(id);
    if (product == null) return NotFound();

    // Only update non-null properties
    if (patchDto.Name != null)
        product.Name = patchDto.Name;

    if (patchDto.Price.HasValue)
        product.Price = patchDto.Price.Value;

    if (patchDto.Description != null)
        product.Description = patchDto.Description;

    _context.SaveChanges();

    return NoContent();
}
```

---

## Common Patterns & Best Practices

### 1. DTO Naming Conventions

**Choose one and be consistent**:

```csharp
// Option 1: Suffix with operation
public class ProductDto { }           // Read
public class ProductCreateDto { }     // Create
public class ProductUpdateDto { }     // Update

// Option 2: Request/Response style
public class ProductResponse { }
public class CreateProductRequest { }
public class UpdateProductRequest { }

// Option 3: Explicit Read suffix
public class ProductReadDto { }
public class ProductCreateDto { }
public class ProductUpdateDto { }
```

### 2. Keep DTOs in Separate Folder

```
MyProject/
├── DTOs/
│   ├── Products/
│   │   ├── ProductDto.cs
│   │   ├── ProductCreateDto.cs
│   │   └── ProductUpdateDto.cs
│   └── Categories/
│       ├── CategoryDto.cs
│       └── CategoryCreateDto.cs
```

### 3. Use Validation Attributes on DTOs

```csharp
public class ProductCreateDto
{
    [Required(ErrorMessage = "Name is required")]
    [StringLength(100, MinimumLength = 3, ErrorMessage = "Name must be 3-100 characters")]
    public string Name { get; set; }

    [Required]
    [Range(0.01, double.MaxValue, ErrorMessage = "Price must be greater than 0")]
    public decimal Price { get; set; }

    [Url(ErrorMessage = "Invalid URL format")]
    public string ImageUrl { get; set; }
}
```

### 4. Don't Reuse DTOs Across Operations

**BAD**:

```csharp
// Same DTO for create and update
public class ProductDto
{
    public int? Id { get; set; }  // Nullable for create, required for update?
    public string Name { get; set; }
    // Validation is unclear
}
```

**GOOD**:

```csharp
// Separate DTOs
public class ProductCreateDto
{
    // No Id - will be generated
    [Required]
    public string Name { get; set; }
}

public class ProductUpdateDto
{
    // Id in route parameter, not DTO
    [Required]
    public string Name { get; set; }
}
```

### 5. Consider AutoMapper for Large Projects

**When to use AutoMapper**:
- 10+ entities with DTOs
- Complex nested mappings
- Many similar mapping patterns

**When to use manual mapping**:
- Small projects (< 5 entities)
- Performance-critical applications
- Simple 1:1 mappings

### 6. Project to DTOs in Queries (Performance)

**BAD** (loads unnecessary data):

```csharp
var products = _context.Products.Include(p => p.Category).ToList();
var dtos = products.Select(p => new ProductDto { ... }).ToList();
```

**GOOD** (only selects needed columns):

```csharp
var dtos = _context.Products
    .Select(p => new ProductDto
    {
        Id = p.Id,
        Name = p.Name,
        CategoryName = p.Category.Name
    })
    .ToList();
```

### 7. Handle Circular References

**Problem**:

```csharp
public class Order
{
    public Customer Customer { get; set; }
}

public class Customer
{
    public List<Order> Orders { get; set; }  // Circular!
}

// If you return Order entity, JSON serializer will loop infinitely
```

**Solution**: Flatten in DTOs:

```csharp
public class OrderDto
{
    public int CustomerId { get; set; }
    public string CustomerName { get; set; }
    // No Customer object, no Orders list
}
```

### 8. Use DTOs for Input Validation

```csharp
public class ProductCreateDto
{
    [Required]
    [StringLength(100)]
    public string Name { get; set; }

    [Required]
    [Range(0.01, 10000)]
    public decimal Price { get; set; }

    [Required]
    public int CategoryId { get; set; }
}

[HttpPost]
public IActionResult Create(ProductCreateDto dto)
{
    if (!ModelState.IsValid)
        return BadRequest(ModelState);  // Automatic validation

    // Map to entity...
}
```

---

## Troubleshooting

### Issue 1: Circular Reference Exception

**Symptom**:
```
System.Text.Json.JsonException: A possible object cycle was detected
```

**Cause**: Returning entities with navigation properties directly.

**Solution**: Use DTOs to flatten the structure:

```csharp
// BAD
return _context.Products.Include(p => p.Category).ToList();  // Category has Products!

// GOOD
return _context.Products
    .Select(p => new ProductDto
    {
        Id = p.Id,
        Name = p.Name,
        CategoryName = p.Category.Name  // Just the name, not full object
    })
    .ToList();
```

### Issue 2: AutoMapper Missing Type Map

**Symptom**:
```
AutoMapper.AutoMapperMappingException: Missing type map configuration or unsupported mapping
```

**Cause**: No mapping configured for the types.

**Solution**:

```csharp
// Add mapping in MappingProfile
public class MappingProfile : Profile
{
    public MappingProfile()
    {
        CreateMap<Product, ProductDto>();  // Add this mapping
    }
}
```

### Issue 3: Null Reference When Mapping Navigation Properties

**Symptom**: `NullReferenceException` when accessing `product.Category.Name`.

**Cause**: Navigation property not loaded (no `.Include()`).

**Solution**:

```csharp
// Option 1: Include navigation property
var product = _context.Products
    .Include(p => p.Category)
    .FirstOrDefault(p => p.Id == id);

var dto = new ProductDto
{
    CategoryName = product.Category?.Name  // Use null-conditional operator
};

// Option 2: Project directly (better performance)
var dto = _context.Products
    .Where(p => p.Id == id)
    .Select(p => new ProductDto
    {
        CategoryName = p.Category.Name  // EF Core handles the join
    })
    .FirstOrDefault();
```

### Issue 4: Over-Posting Attack

**Symptom**: User sends extra properties in JSON that modify sensitive fields.

**Problem**:

```csharp
// DANGEROUS: Binding directly to entity
[HttpPost]
public IActionResult Create(Product product)  // User can set IsAdmin = true!
{
    _context.Products.Add(product);
    _context.SaveChanges();
}
```

**Solution**: Use DTOs with only allowed properties:

```csharp
[HttpPost]
public IActionResult Create(ProductCreateDto dto)
{
    var product = new Product
    {
        Name = dto.Name,
        Price = dto.Price
        // IsAdmin not in DTO, so it can't be set by user
    };

    _context.Products.Add(product);
    _context.SaveChanges();
}
```

### Issue 5: Performance Issues with Large Collections

**Symptom**: Slow API response when returning large lists.

**Cause**: Loading full entities then mapping.

**Solution**: Project to DTOs in query + pagination:

```csharp
// BAD
var products = _context.Products.ToList();
var dtos = products.Select(p => new ProductDto { ... }).ToList();

// GOOD
var dtos = await _context.Products
    .Skip((page - 1) * pageSize)
    .Take(pageSize)
    .Select(p => new ProductDto
    {
        Id = p.Id,
        Name = p.Name,
        Price = p.Price
    })
    .ToListAsync();
```

### Issue 6: AutoMapper Flattening Not Working

**Symptom**: `CategoryName` is null even though `Category.Name` has a value.

**Cause**: AutoMapper convention not matching.

**Solution**: Explicit configuration:

```csharp
CreateMap<Product, ProductDto>()
    .ForMember(dest => dest.CategoryName,
              opt => opt.MapFrom(src => src.Category.Name));
```

---

## Additional Resources

### Official Documentation

- [DTO Pattern - Martin Fowler](https://martinfowler.com/eaaCatalog/dataTransferObject.html) - Original pattern definition
- [ASP.NET Core Model Binding](https://learn.microsoft.com/en-us/aspnet/core/mvc/models/model-binding) - How DTOs work with controllers
- [AutoMapper Documentation](https://docs.automapper.org/en/stable/) - Complete AutoMapper guide

### Best Practices Articles

- [DTO vs Entity](https://enterprisecraftsmanship.com/posts/dto-vs-value-object-vs-poco/) - Understanding the differences
- [AutoMapper Best Practices](https://jimmybogard.com/automapper-usage-guidelines/) - From the AutoMapper creator
- [API Security Best Practices](https://owasp.org/www-project-api-security/) - OWASP API security guide

### Video Tutorials

- [DTOs in ASP.NET Core](https://www.youtube.com/results?search_query=dto+asp.net+core) - YouTube tutorials
- [AutoMapper Tutorial](https://www.youtube.com/results?search_query=automapper+.net) - Video guides

### Community Resources

- [Stack Overflow - DTO Tag](https://stackoverflow.com/questions/tagged/dto) - Community Q&A
- [r/dotnet Subreddit](https://www.reddit.com/r/dotnet/) - Discussion forum

### Related Topics

1. **[Controllers and Routing](controllers-and-routing.md)** - Where DTOs are used
2. **[Entity Framework Core](entity-framework-core-fundamentals.md)** - Working with entities
3. **Model Validation** - Validating DTOs
4. **API Versioning** - Using different DTOs for different API versions

### Tools

- [AutoMapper](https://www.nuget.org/packages/AutoMapper) - Automatic mapping library
- [Mapster](https://www.nuget.org/packages/Mapster) - Alternative to AutoMapper (faster)
- [FluentValidation](https://www.nuget.org/packages/FluentValidation.AspNetCore) - Advanced DTO validation

---

## Self-Assessment Checklist

After completing this guide, you should be able to:

- [ ] Explain what DTOs are and why they're important
- [ ] Identify security risks of returning entities directly
- [ ] Create separate DTOs for create/read/update operations
- [ ] Apply validation attributes to DTOs
- [ ] Manually map between entities and DTOs
- [ ] Set up and use AutoMapper
- [ ] Flatten nested objects in DTOs
- [ ] Project to DTOs directly in EF Core queries
- [ ] Handle circular references
- [ ] Prevent over-posting attacks
- [ ] Choose between manual mapping and AutoMapper
- [ ] Organize DTOs in your project structure
- [ ] Test DTO mappings

---

## Summary

**Data Transfer Objects (DTOs)** are a critical pattern for building secure, maintainable APIs. Key takeaways:

1. **DTOs control what data is exposed** - Never return entities directly from APIs
2. **Use different DTOs for different operations** - Create, Update, and Read DTOs have different requirements
3. **DTOs provide security** - Hide sensitive fields like passwords and internal flags
4. **DTOs decouple your API from your database** - Change entity structure without breaking clients
5. **Choose mapping strategy based on project size** - Manual for small projects, AutoMapper for large ones
6. **Flatten nested objects** - Avoid circular references and simplify client code
7. **Project to DTOs in queries** - Better performance by selecting only needed data
8. **Use validation attributes on DTOs** - Validate input at the boundary

**Next Steps**:
- Practice creating DTOs for your entities
- Experiment with both manual mapping and AutoMapper
- Learn about advanced validation with FluentValidation
- Explore API versioning with multiple DTO versions

Remember: DTOs are about **control**. They give you precise control over what data enters and leaves your application, which is essential for security, performance, and maintainability.

Happy mapping!
