# Model Validation in ASP.NET Core

**Estimated Reading Time**: 40 minutes

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

### What Is Model Validation?

**Model validation** is the process of ensuring that data received by your API meets specific requirements before processing it. It's your first line of defense against bad data, malicious input, and application errors.

**Real-World Analogy**: Model validation is like a bouncer at a club. Before someone enters (data enters your system), the bouncer checks their ID (validation rules). If they don't meet the requirements (invalid data), they're not allowed in, and you get a clear reason why.

### Why Validate on the Server?

You might think: "I'm validating on the client-side (JavaScript), why validate on the server?"

**Client-side validation can be bypassed**:
- Users can disable JavaScript
- Attackers can send direct HTTP requests (bypassing your UI)
- Mobile apps or third-party clients might not validate

**Server-side validation is mandatory** for:
- **Security**: Prevent injection attacks, malformed data
- **Data integrity**: Ensure database constraints are met
- **Business rules**: Enforce domain-specific requirements
- **User experience**: Provide clear error messages

### Key Benefits

| Benefit | Description |
|---------|-------------|
| **Security** | Prevent malicious or malformed input |
| **Data Quality** | Ensure data meets business requirements |
| **Error Prevention** | Catch issues before they reach the database |
| **User Feedback** | Provide clear, actionable error messages |
| **Code Clarity** | Declarative validation rules are self-documenting |
| **Consistency** | Same validation logic across the application |

### Validation Layers

```
┌─────────────────────────────────────────┐
│  Client (Optional)                      │
│  - Quick feedback                       │
│  - Can be bypassed                      │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│  API Controller (Required)              │
│  - Data Annotations                     │
│  - ModelState.IsValid                   │
│  - Cannot be bypassed                   │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│  Business Layer (Optional)              │
│  - Complex business rules               │
│  - Cross-entity validation              │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│  Database (Last Resort)                 │
│  - Constraints (NOT NULL, UNIQUE)       │
│  - Triggers                             │
└─────────────────────────────────────────┘
```

**We focus on the API Controller layer in this guide.**

---

## Quick Start

Here's the fastest way to validate models:

```csharp
// 1. Add validation attributes to your DTO
public class ProductCreateDto
{
    [Required(ErrorMessage = "Product name is required")]
    [StringLength(100, MinimumLength = 3, ErrorMessage = "Name must be 3-100 characters")]
    public string Name { get; set; }

    [Required]
    [Range(0.01, 10000, ErrorMessage = "Price must be between $0.01 and $10,000")]
    public decimal Price { get; set; }

    [EmailAddress(ErrorMessage = "Invalid email format")]
    public string SupplierEmail { get; set; }
}

// 2. Check ModelState in controller
[HttpPost]
public IActionResult Create(ProductCreateDto dto)
{
    if (!ModelState.IsValid)
    {
        return BadRequest(ModelState);  // Returns 400 with errors
    }

    // Process valid data...
    return Ok();
}
```

**Result**: If validation fails, API returns 400 Bad Request with error details.

**Example response**:
```json
{
  "errors": {
    "Name": ["Product name is required"],
    "Price": ["Price must be between $0.01 and $10,000"]
  }
}
```

---

## Prerequisites

### Required Knowledge

Before working with model validation, you should understand:
- **C# Attributes**: Validation uses attributes like `[Required]`
- **DTOs**: Validation typically applies to DTOs (see [Data Transfer Objects](data-transfer-objects.md))
- **Controllers**: Where validation happens (see [Controllers and Routing](controllers-and-routing.md))
- **HTTP Status Codes**: 400 Bad Request for validation errors

### Required Tools

| Tool | Version | Purpose |
|------|---------|---------|
| .NET SDK | 8.0+ | Built-in validation |
| ASP.NET Core | 8.0+ | ModelState, validation attributes |

**Good news**: Data Annotations are built into .NET - no additional packages needed!

---

## Core Concepts & Theory

### 1. Data Annotations

**Data Annotations** are attributes you apply to properties to specify validation rules.

**Common annotations**:

| Attribute | Purpose | Example |
|-----------|---------|---------|
| `[Required]` | Property must have a value | `[Required]` |
| `[StringLength]` | String length constraints | `[StringLength(100, MinimumLength = 3)]` |
| `[Range]` | Numeric range | `[Range(1, 100)]` |
| `[EmailAddress]` | Valid email format | `[EmailAddress]` |
| `[Phone]` | Valid phone format | `[Phone]` |
| `[Url]` | Valid URL format | `[Url]` |
| `[RegularExpression]` | Custom regex pattern | `[RegularExpression(@"^\d{5}$")]` |
| `[Compare]` | Must match another property | `[Compare("Password")]` |
| `[CreditCard]` | Valid credit card number | `[CreditCard]` |
| `[MinLength]` | Minimum collection/string length | `[MinLength(2)]` |
| `[MaxLength]` | Maximum collection/string length | `[MaxLength(50)]` |

**Example**:

```csharp
public class UserRegisterDto
{
    [Required(ErrorMessage = "Username is required")]
    [StringLength(50, MinimumLength = 3)]
    public string Username { get; set; }

    [Required]
    [EmailAddress(ErrorMessage = "Invalid email address")]
    public string Email { get; set; }

    [Required]
    [StringLength(100, MinimumLength = 8, ErrorMessage = "Password must be 8-100 characters")]
    [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$",
        ErrorMessage = "Password must contain uppercase, lowercase, and digit")]
    public string Password { get; set; }

    [Required]
    [Compare("Password", ErrorMessage = "Passwords do not match")]
    public string ConfirmPassword { get; set; }
}
```

### 2. ModelState

**ModelState** is a dictionary that holds:
- Property values submitted
- Validation errors for each property
- Overall validation status

**Key properties**:

```csharp
ModelState.IsValid         // true if all validations passed
ModelState.ErrorCount      // number of validation errors
ModelState.Values          // collection of property states
```

**Checking validation**:

```csharp
[HttpPost]
public IActionResult Create(ProductCreateDto dto)
{
    if (!ModelState.IsValid)
    {
        // Validation failed - return errors
        return BadRequest(ModelState);
    }

    // Validation passed - process data
    return Ok();
}
```

### 3. Automatic Validation with [ApiController]

When you use `[ApiController]` attribute, validation is **automatic**:

```csharp
[ApiController]  // Enables automatic validation
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    [HttpPost]
    public IActionResult Create(ProductCreateDto dto)
    {
        // No need to check ModelState.IsValid manually!
        // If validation fails, ASP.NET Core automatically returns 400 Bad Request

        // This code only runs if validation passed
        return Ok();
    }
}
```

**Without `[ApiController]`, you must check manually**:

```csharp
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    [HttpPost]
    public IActionResult Create(ProductCreateDto dto)
    {
        if (!ModelState.IsValid)  // Manual check required
        {
            return BadRequest(ModelState);
        }

        return Ok();
    }
}
```

**Recommendation**: Always use `[ApiController]` for Web APIs.

### 4. Custom Validation Attributes

Create custom validation for domain-specific rules:

```csharp
public class FutureDateAttribute : ValidationAttribute
{
    protected override ValidationResult IsValid(object value, ValidationContext validationContext)
    {
        if (value is DateTime dateTime)
        {
            if (dateTime <= DateTime.Now)
            {
                return new ValidationResult("Date must be in the future");
            }
        }

        return ValidationResult.Success;
    }
}

// Usage
public class EventCreateDto
{
    [Required]
    public string Name { get; set; }

    [Required]
    [FutureDate]  // Custom validation
    public DateTime EventDate { get; set; }
}
```

### 5. Validation Error Response Format

**Default format** (with `[ApiController]`):

```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
  "title": "One or more validation errors occurred.",
  "status": 400,
  "traceId": "00-abc123...",
  "errors": {
    "Name": [
      "Product name is required"
    ],
    "Price": [
      "The field Price must be between 0.01 and 10000."
    ]
  }
}
```

**Custom format** (see Common Patterns section).

### 6. Client-Side vs Server-Side Validation

| Aspect | Client-Side | Server-Side |
|--------|-------------|-------------|
| **Purpose** | Quick user feedback | Security & data integrity |
| **Required?** | No (optional) | **Yes (mandatory)** |
| **Can be bypassed?** | Yes (disable JS, direct HTTP) | No |
| **Technologies** | JavaScript, HTML5 | C#, Data Annotations |
| **When runs** | Before submission | After submission |
| **User experience** | Instant feedback | Slower (network round-trip) |

**Best practice**: Use both for optimal UX and security.

---

## Installation Guide

**Good news**: Data Annotations are built into .NET Core!

No additional packages needed for basic validation.

### Optional: FluentValidation

For complex validation scenarios, you can use **FluentValidation**:

```bash
dotnet add package FluentValidation.AspNetCore
```

**Package reference**:

```xml
<PackageReference Include="FluentValidation.AspNetCore" Version="11.3.0" />
```

**We focus on Data Annotations in this guide, but mention FluentValidation in Additional Resources.**

---

## Initial Setup & Configuration

### Enabling Automatic Validation

**Add `[ApiController]` to controllers**:

```csharp
[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    // Validation happens automatically
}
```

### Customizing Validation Behavior

**Configure in `Program.cs`**:

```csharp
builder.Services.AddControllers()
    .ConfigureApiBehaviorOptions(options =>
    {
        // Suppress automatic 400 response (if you want custom handling)
        // options.SuppressModelStateInvalidFilter = true;

        // Customize error response format
        options.InvalidModelStateResponseFactory = context =>
        {
            var errors = context.ModelState
                .Where(e => e.Value.Errors.Count > 0)
                .Select(e => new
                {
                    Name = e.Key,
                    Message = e.Value.Errors.First().ErrorMessage
                })
                .ToList();

            return new BadRequestObjectResult(new
            {
                Success = false,
                Errors = errors
            });
        };
    });
```

---

## Basic Usage

### Example 1: Simple Validation

**DTO with validation**:

```csharp
public class ProductCreateDto
{
    [Required(ErrorMessage = "Product name is required")]
    [StringLength(100, MinimumLength = 3)]
    public string Name { get; set; }

    [Required]
    [Range(0.01, 10000)]
    public decimal Price { get; set; }
}
```

**Controller**:

```csharp
[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    [HttpPost]
    public IActionResult Create(ProductCreateDto dto)
    {
        // If validation fails, ASP.NET Core automatically returns 400
        // This code only executes if dto is valid

        return Ok(new { message = "Product created", product = dto });
    }
}
```

**Test with curl**:

```bash
# Valid request
curl -X POST http://localhost:5000/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Widget","price":19.99}'

# Invalid request (missing name)
curl -X POST http://localhost:5000/api/products \
  -H "Content-Type: application/json" \
  -d '{"price":19.99}'

# Response:
{
  "errors": {
    "Name": ["Product name is required"]
  }
}
```

### Example 2: Multiple Validations

```csharp
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
    [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$",
        ErrorMessage = "Password must contain uppercase, lowercase, and digit")]
    public string Password { get; set; }

    [Range(13, 120, ErrorMessage = "Age must be between 13 and 120")]
    public int Age { get; set; }

    [Url]
    public string Website { get; set; }

    [Phone]
    public string PhoneNumber { get; set; }
}
```

### Example 3: Manual ModelState Check (without [ApiController])

```csharp
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    [HttpPost]
    public IActionResult Create(ProductCreateDto dto)
    {
        if (!ModelState.IsValid)
        {
            var errors = ModelState
                .Where(x => x.Value.Errors.Count > 0)
                .SelectMany(x => x.Value.Errors)
                .Select(x => x.ErrorMessage)
                .ToList();

            return BadRequest(new { errors });
        }

        return Ok();
    }
}
```

### Example 4: Conditional Validation

**Use `Required` with nullable types**:

```csharp
public class ProductUpdateDto
{
    [StringLength(100)]  // Optional, but if provided, max 100 chars
    public string Name { get; set; }

    [Range(0.01, 10000)]  // Optional, but if provided, must be in range
    public decimal? Price { get; set; }

    [Required]  // Always required
    public int CategoryId { get; set; }
}
```

### Example 5: Collection Validation

```csharp
public class OrderCreateDto
{
    [Required]
    [MinLength(1, ErrorMessage = "Order must have at least one item")]
    public List<OrderItemDto> Items { get; set; }
}

public class OrderItemDto
{
    [Required]
    [Range(1, int.MaxValue)]
    public int ProductId { get; set; }

    [Required]
    [Range(1, 1000)]
    public int Quantity { get; set; }
}
```

---

## Testing & Validation

### Unit Testing Validation

```csharp
using System.ComponentModel.DataAnnotations;
using Xunit;

public class ProductCreateDtoTests
{
    [Fact]
    public void Validate_ValidProduct_PassesValidation()
    {
        // Arrange
        var dto = new ProductCreateDto
        {
            Name = "Test Product",
            Price = 19.99m
        };

        var context = new ValidationContext(dto);
        var results = new List<ValidationResult>();

        // Act
        var isValid = Validator.TryValidateObject(dto, context, results, true);

        // Assert
        Assert.True(isValid);
        Assert.Empty(results);
    }

    [Fact]
    public void Validate_MissingName_FailsValidation()
    {
        // Arrange
        var dto = new ProductCreateDto
        {
            Name = null,  // Required field missing
            Price = 19.99m
        };

        var context = new ValidationContext(dto);
        var results = new List<ValidationResult>();

        // Act
        var isValid = Validator.TryValidateObject(dto, context, results, true);

        // Assert
        Assert.False(isValid);
        Assert.Contains(results, r => r.MemberNames.Contains("Name"));
    }

    [Fact]
    public void Validate_PriceTooLow_FailsValidation()
    {
        // Arrange
        var dto = new ProductCreateDto
        {
            Name = "Test",
            Price = 0m  // Below minimum (0.01)
        };

        var context = new ValidationContext(dto);
        var results = new List<ValidationResult>();

        // Act
        var isValid = Validator.TryValidateObject(dto, context, results, true);

        // Assert
        Assert.False(isValid);
        Assert.Contains(results, r => r.MemberNames.Contains("Price"));
    }
}
```

### Integration Testing Validation

```csharp
using Microsoft.AspNetCore.Mvc.Testing;
using System.Net;
using System.Net.Http.Json;
using Xunit;

public class ProductsApiValidationTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public ProductsApiValidationTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task CreateProduct_ValidData_ReturnsOk()
    {
        // Arrange
        var dto = new ProductCreateDto
        {
            Name = "Test Product",
            Price = 19.99m
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/products", dto);

        // Assert
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task CreateProduct_MissingName_ReturnsBadRequest()
    {
        // Arrange
        var dto = new ProductCreateDto
        {
            Price = 19.99m
            // Name missing
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/products", dto);

        // Assert
        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);

        var content = await response.Content.ReadAsStringAsync();
        Assert.Contains("name", content.ToLower());
    }
}
```

---

## Practical Examples

### Example 1: Comprehensive User Registration Validation

```csharp
public class UserRegisterDto
{
    [Required(ErrorMessage = "Username is required")]
    [StringLength(50, MinimumLength = 3,
        ErrorMessage = "Username must be between 3 and 50 characters")]
    [RegularExpression(@"^[a-zA-Z0-9_]+$",
        ErrorMessage = "Username can only contain letters, numbers, and underscores")]
    public string Username { get; set; }

    [Required(ErrorMessage = "Email is required")]
    [EmailAddress(ErrorMessage = "Invalid email format")]
    [StringLength(100)]
    public string Email { get; set; }

    [Required(ErrorMessage = "Password is required")]
    [StringLength(100, MinimumLength = 8,
        ErrorMessage = "Password must be at least 8 characters")]
    [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$",
        ErrorMessage = "Password must contain uppercase, lowercase, digit, and special character")]
    public string Password { get; set; }

    [Required]
    [Compare("Password", ErrorMessage = "Passwords do not match")]
    public string ConfirmPassword { get; set; }

    [Required]
    [Range(13, 120, ErrorMessage = "You must be between 13 and 120 years old")]
    public int Age { get; set; }

    [Url(ErrorMessage = "Invalid URL format")]
    public string Website { get; set; }

    [Phone(ErrorMessage = "Invalid phone number format")]
    public string PhoneNumber { get; set; }

    [Required]
    public bool AcceptTerms { get; set; }
}

[HttpPost("register")]
public IActionResult Register(UserRegisterDto dto)
{
    // Validation happens automatically

    // Additional business logic validation
    if (_userRepository.UsernameExists(dto.Username))
    {
        ModelState.AddModelError("Username", "Username already taken");
        return BadRequest(ModelState);
    }

    if (_userRepository.EmailExists(dto.Email))
    {
        ModelState.AddModelError("Email", "Email already registered");
        return BadRequest(ModelState);
    }

    // Create user...
    return Ok(new { message = "User registered successfully" });
}
```

### Example 2: Custom Validation Attribute

```csharp
// Custom attribute for future dates
public class FutureDateAttribute : ValidationAttribute
{
    protected override ValidationResult IsValid(object value, ValidationContext validationContext)
    {
        if (value is DateTime dateTime)
        {
            if (dateTime <= DateTime.Now)
            {
                return new ValidationResult(
                    ErrorMessage ?? "Date must be in the future");
            }
        }

        return ValidationResult.Success;
    }
}

// Custom attribute for allowed file extensions
public class AllowedExtensionsAttribute : ValidationAttribute
{
    private readonly string[] _extensions;

    public AllowedExtensionsAttribute(params string[] extensions)
    {
        _extensions = extensions;
    }

    protected override ValidationResult IsValid(object value, ValidationContext validationContext)
    {
        if (value is string fileName && !string.IsNullOrEmpty(fileName))
        {
            var extension = Path.GetExtension(fileName);
            if (!_extensions.Contains(extension.ToLower()))
            {
                return new ValidationResult(
                    $"File extension must be one of: {string.Join(", ", _extensions)}");
            }
        }

        return ValidationResult.Success;
    }
}

// Usage
public class EventCreateDto
{
    [Required]
    [StringLength(200)]
    public string Title { get; set; }

    [Required]
    [FutureDate(ErrorMessage = "Event date must be in the future")]
    public DateTime EventDate { get; set; }

    [AllowedExtensions(".jpg", ".png", ".gif")]
    public string BannerImage { get; set; }
}
```

### Example 3: Class-Level Validation (IValidatableObject)

**For validation that involves multiple properties**:

```csharp
public class DateRangeDto : IValidatableObject
{
    [Required]
    public DateTime StartDate { get; set; }

    [Required]
    public DateTime EndDate { get; set; }

    public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
    {
        if (EndDate <= StartDate)
        {
            yield return new ValidationResult(
                "End date must be after start date",
                new[] { nameof(EndDate) });
        }

        if ((EndDate - StartDate).TotalDays > 365)
        {
            yield return new ValidationResult(
                "Date range cannot exceed 365 days",
                new[] { nameof(StartDate), nameof(EndDate) });
        }
    }
}
```

### Example 4: Custom Error Response Format

```csharp
// Program.cs
builder.Services.AddControllers()
    .ConfigureApiBehaviorOptions(options =>
    {
        options.InvalidModelStateResponseFactory = context =>
        {
            var errors = context.ModelState
                .Where(e => e.Value.Errors.Count > 0)
                .ToDictionary(
                    kvp => kvp.Key,
                    kvp => kvp.Value.Errors.Select(e => e.ErrorMessage).ToArray()
                );

            var response = new
            {
                Success = false,
                Message = "Validation failed",
                Errors = errors,
                Timestamp = DateTime.UtcNow
            };

            return new BadRequestObjectResult(response);
        };
    });
```

**Custom response format**:

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "Name": ["Product name is required"],
    "Price": ["Price must be between 0.01 and 10000"]
  },
  "timestamp": "2026-11-22T12:00:00Z"
}
```

---

## Common Patterns & Best Practices

### 1. Always Validate on the Server

**Never trust client-side validation alone**:

```csharp
// ALWAYS do this
[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    [HttpPost]
    public IActionResult Create(ProductCreateDto dto)
    {
        // Validation happens automatically
        return Ok();
    }
}
```

### 2. Use Descriptive Error Messages

**Good**:
```csharp
[Required(ErrorMessage = "Product name is required")]
[StringLength(100, MinimumLength = 3,
    ErrorMessage = "Product name must be between 3 and 100 characters")]
public string Name { get; set; }
```

**Bad**:
```csharp
[Required]  // Generic error message
[StringLength(100, MinimumLength = 3)]  // Generic message
public string Name { get; set; }
```

### 3. Validate at the DTO Layer

**Apply validation to DTOs, not entities**:

```csharp
// GOOD - Validation on DTO
public class ProductCreateDto
{
    [Required]
    [StringLength(100)]
    public string Name { get; set; }
}

// AVOID - Validation on entity
public class Product  // Entity
{
    [Required]  // Don't do this on entities
    public string Name { get; set; }
}
```

**Why?** Different operations (create vs update) may have different validation rules.

### 4. Use Specific Validation Attributes

```csharp
// Use specific attributes
[EmailAddress]  // Better than RegularExpression for email
[Url]           // Better than RegularExpression for URL
[Phone]         // Better than RegularExpression for phone
[CreditCard]    // Built-in credit card validation
```

### 5. Separate Create and Update DTOs

```csharp
// Different validation rules for create and update
public class ProductCreateDto
{
    [Required]  // Required for creation
    public string Name { get; set; }
}

public class ProductUpdateDto
{
    // Name is optional for update (partial update)
    [StringLength(100)]
    public string Name { get; set; }
}
```

### 6. Return Consistent Error Format

**Use middleware or configure globally**:

```csharp
builder.Services.AddControllers()
    .ConfigureApiBehaviorOptions(options =>
    {
        options.InvalidModelStateResponseFactory = context =>
        {
            // Consistent error format across all endpoints
            return new BadRequestObjectResult(new
            {
                Success = false,
                Errors = context.ModelState
                    .Where(e => e.Value.Errors.Count > 0)
                    .SelectMany(e => e.Value.Errors)
                    .Select(e => e.ErrorMessage)
            });
        };
    });
```

### 7. Test Your Validation

```csharp
[Fact]
public void ProductCreateDto_MissingName_FailsValidation()
{
    var dto = new ProductCreateDto { Price = 10 };
    var context = new ValidationContext(dto);
    var results = new List<ValidationResult>();

    var isValid = Validator.TryValidateObject(dto, context, results, true);

    Assert.False(isValid);
}
```

### 8. Document Validation Rules in API Documentation

Use XML comments:

```csharp
/// <summary>
/// Creates a new product
/// </summary>
/// <param name="dto">Product data</param>
/// <remarks>
/// Validation rules:
/// - Name: Required, 3-100 characters
/// - Price: Required, $0.01-$10,000
/// </remarks>
[HttpPost]
public IActionResult Create(ProductCreateDto dto) { }
```

---

## Troubleshooting

### Issue 1: Validation Not Running

**Symptom**: Invalid data is accepted without errors.

**Cause**: Missing `[ApiController]` attribute or not checking `ModelState.IsValid`.

**Solution**:

```csharp
// Add [ApiController]
[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase { }

// OR manually check ModelState
if (!ModelState.IsValid)
{
    return BadRequest(ModelState);
}
```

### Issue 2: Custom Validation Attribute Not Working

**Symptom**: Custom validation is not being called.

**Cause**: Attribute not applied, or `IsValid` method not implemented correctly.

**Solution**:

```csharp
// Ensure attribute is applied
public class MyDto
{
    [MyCustomValidation]  // Apply the attribute
    public string MyProperty { get; set; }
}

// Implement correctly
public class MyCustomValidationAttribute : ValidationAttribute
{
    protected override ValidationResult IsValid(object value, ValidationContext validationContext)
    {
        // Your validation logic
        if (/* invalid */)
        {
            return new ValidationResult("Error message");
        }
        return ValidationResult.Success;
    }
}
```

### Issue 3: Validation Errors Not Returned to Client

**Symptom**: API returns 400 but no error details.

**Cause**: `ModelState` not included in response.

**Solution**:

```csharp
if (!ModelState.IsValid)
{
    return BadRequest(ModelState);  // Include ModelState
}
```

### Issue 4: Required Validation Not Working for Value Types

**Symptom**: `int` or `decimal` properties don't trigger `[Required]` errors.

**Cause**: Value types have default values (0, false), so they're never "null".

**Solution**: Use nullable types if you want to enforce `[Required]`:

```csharp
public class ProductDto
{
    [Required]  // Won't work - int can't be null
    public int CategoryId { get; set; }  // Defaults to 0

    [Required]  // Works - nullable int can be null
    public int? CategoryId { get; set; }  // Can be null
}
```

**Or** use `[Range]` for non-nullable types:

```csharp
[Range(1, int.MaxValue, ErrorMessage = "CategoryId is required")]
public int CategoryId { get; set; }
```

### Issue 5: Nested Object Validation Not Working

**Symptom**: Validation on nested objects is not triggered.

**Cause**: Missing `[ValidateNever]` or complex object validation not enabled.

**Solution**: Ensure nested DTOs are validated:

```csharp
public class OrderCreateDto
{
    [Required]
    public string OrderNumber { get; set; }

    [Required]
    [ValidateComplexType]  // Ensure nested object is validated
    public AddressDto ShippingAddress { get; set; }
}

public class AddressDto
{
    [Required]
    public string Street { get; set; }

    [Required]
    public string City { get; set; }
}
```

---

## Additional Resources

### Official Documentation

- [Model Validation in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/mvc/models/validation) - Microsoft's comprehensive guide
- [Data Annotations](https://learn.microsoft.com/en-us/dotnet/api/system.componentmodel.dataannotations) - All available attributes
- [Custom Validation Attributes](https://learn.microsoft.com/en-us/aspnet/core/mvc/models/validation#custom-attributes) - Creating your own

### Libraries

- [FluentValidation](https://fluentvalidation.net/) - Alternative to Data Annotations, more powerful
- [Guard Clauses](https://github.com/ardalis/GuardClauses) - Defensive programming with validation

### Articles

- [ASP.NET Core Web API Validation](https://code-maze.com/aspnetcore-webapi-data-validation/) - Detailed tutorial
- [Validation Best Practices](https://www.pluralsight.com/guides/validation-best-practices-aspnet-core) - Pluralsight guide

### Video Tutorials

- [Model Validation in ASP.NET Core](https://www.youtube.com/results?search_query=model+validation+asp.net+core) - YouTube tutorials

### Related Topics

1. **[Data Transfer Objects (DTOs)](data-transfer-objects.md)** - Where validation is typically applied
2. **[Controllers and Routing](controllers-and-routing.md)** - Where validation happens
3. **Error Handling** - How to handle validation failures consistently
4. **API Documentation (Swagger)** - Documenting validation rules

---

## Self-Assessment Checklist

After completing this guide, you should be able to:

- [ ] Explain why server-side validation is mandatory
- [ ] Apply Data Annotation attributes to DTOs
- [ ] Use `ModelState.IsValid` to check validation
- [ ] Understand automatic validation with `[ApiController]`
- [ ] Create custom validation attributes
- [ ] Implement `IValidatableObject` for complex validation
- [ ] Format validation error responses
- [ ] Test validation logic in unit tests
- [ ] Choose appropriate validation attributes for different scenarios
- [ ] Handle conditional validation (required vs optional)
- [ ] Troubleshoot common validation issues

---

## Summary

**Model Validation** is essential for building secure, reliable APIs. Key takeaways:

1. **Always validate on the server** - Client-side validation can be bypassed
2. **Use Data Annotations** - Declarative, easy to understand and maintain
3. **[ApiController] enables automatic validation** - No need to check `ModelState.IsValid` manually
4. **Apply validation to DTOs** - Different operations may have different rules
5. **Use descriptive error messages** - Help users understand what's wrong
6. **Custom attributes for domain rules** - Extend validation beyond built-in attributes
7. **Test your validation** - Ensure rules work as expected
8. **Return consistent error formats** - Configure globally for consistency

**Next Steps**:
- Practice adding validation to your DTOs
- Create custom validation attributes for your domain
- Set up consistent error response format
- Write tests for your validation logic
- Explore FluentValidation for complex scenarios

Remember: Validation is your first line of defense. Never trust user input, and always validate on the server. Good validation leads to better data quality, fewer bugs, and happier users.

Happy validating!
