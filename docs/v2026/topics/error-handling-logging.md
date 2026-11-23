# Error Handling and Logging

---
**Technology Version**: .NET 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-23
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What is Error Handling?

Error handling is the process of anticipating, detecting, and responding to errors that occur during your application's execution. When something goes wrong - a database connection fails, a file is missing, or a user provides invalid input - proper error handling ensures your application responds gracefully instead of crashing.

Think of error handling as your application's safety net. Just like a trapeze artist needs a net to catch them if they fall, your application needs error handling to catch problems and handle them appropriately.

### What is Logging?

Logging is the practice of recording events, errors, and information about your application's execution. Logs are like a detailed diary of everything your application does - who logged in, what database queries ran, which errors occurred, and how long operations took.

Logs are essential for:
- **Debugging** - Understanding what went wrong
- **Monitoring** - Tracking application health
- **Auditing** - Recording who did what
- **Performance** - Identifying slow operations
- **Troubleshooting** - Diagnosing production issues

### Why Use Error Handling and Logging?

You should implement proper error handling and logging because:

- **User experience** - Show friendly error messages instead of technical stack traces
- **Security** - Don't expose sensitive information in error messages
- **Debugging** - Quickly identify and fix issues
- **Monitoring** - Detect problems before users report them
- **Compliance** - Meet audit and regulatory requirements
- **Maintainability** - Understand application behavior over time

###When to Use Error Handling and Logging

**Always use error handling and logging for:**
- Production applications
- User-facing websites
- API endpoints
- Database operations
- External service calls
- File I/O operations
- Payment processing
- Authentication and authorization

---

## 2. Quick Start

**TL;DR - Add error handling and logging in 3 minutes:**

**Step 1: Configure error handling in Program.cs**

```csharp
var app = builder.Build();

// Development: Show detailed errors
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}
else
{
    // Production: Show custom error page
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.Run();
```

**Step 2: Add logging to controller**

```csharp
public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;

    public HomeController(ILogger<HomeController> logger)
    {
        _logger = logger;
    }

    public IActionResult Index()
    {
        _logger.LogInformation("Index page accessed");

        try
        {
            // Your code
            return View();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error in Index action");
            throw;
        }
    }
}
```

**Step 3: Create error page**

Create `Views/Shared/Error.cshtml`:

```cshtml
<h1>Oops! Something went wrong</h1>
<p>We're sorry, but an error occurred. Please try again later.</p>
```

**Expected result:** Errors are logged and users see friendly error pages in production.

For detailed explanations, continue reading the sections below.

---

## 3. Prerequisites

### Required Knowledge

- **C# basics** - Try-catch blocks, exceptions
- **ASP.NET Core MVC** - Controllers, middleware (see POK-10)
- **HTTP status codes** - 200 OK, 404 Not Found, 500 Internal Server Error

### Required Software/Tools

- **.NET SDK** - Version 8.0 or higher
- **Code Editor** - Visual Studio, VS Code, or Rider
- **Existing ASP.NET Core Project**

### System Requirements

- **Operating System**: Windows 10+, macOS 11+, or modern Linux
- **RAM**: 4GB minimum
- **Disk Space**: 100MB for project files

---

## 4. Core Concepts & Theory

### Key Concepts

#### Concept 1: Exception Handling Middleware

ASP.NET Core uses middleware to handle exceptions globally.

**Developer Exception Page** (Development):
- Shows detailed error information
- Stack trace
- Request details
- Useful for debugging

**Exception Handler** (Production):
- Catches unhandled exceptions
- Redirects to custom error page
- Hides sensitive details

**Middleware flow:**

```
Request
  ↓
┌─────────────────────┐
│ Exception Handling  │
│ Middleware          │
│ (Try)               │
└──────────┬──────────┘
           │
      (Executes)
           │
     ┌─────▼─────┐
     │ Your App  │
     │ Logic     │
     └─────┬─────┘
           │
      Exception?
       ↙     ↘
     Yes      No
      │       │
      │   Response
      │
  (Catches)
      │
 ┌────▼────┐
 │ Error   │
 │ Handler │
 └─────────┘
```

#### Concept 2: HTTP Status Codes

Status codes communicate what happened with a request:

**Success (2xx):**
- `200 OK` - Request succeeded
- `201 Created` - Resource created
- `204 No Content` - Success, no content to return

**Client Errors (4xx):**
- `400 Bad Request` - Invalid request
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - User lacks permission
- `404 Not Found` - Resource doesn't exist
- `422 Unprocessable Entity` - Validation failed

**Server Errors (5xx):**
- `500 Internal Server Error` - Unhandled exception
- `503 Service Unavailable` - Service temporarily down

#### Concept 3: Logging Levels

Logging levels indicate severity:

| Level | Use Case | Example |
|-------|----------|---------|
| **Trace** | Very detailed, development only | "Entering method X with param Y" |
| **Debug** | Diagnostic information | "Database query: SELECT..." |
| **Information** | General flow | "User logged in", "API called" |
| **Warning** | Unexpected but handled | "Cache miss", "Retry attempt 2" |
| **Error** | Errors and exceptions | "Database connection failed" |
| **Critical** | Serious failures | "Application crash", "Data loss" |

**Hierarchy:**
```
Trace < Debug < Information < Warning < Error < Critical
```

If you set log level to `Warning`, you'll see Warning, Error, and Critical (but not Information, Debug, Trace).

#### Concept 4: Logging Providers

Providers determine where logs are written:

**Built-in providers:**
- **Console** - Writes to console (stdout)
- **Debug** - Visual Studio debug output
- **EventSource** - Windows Event Log
- **EventLog** - Windows Event Log (Windows only)

**Third-party providers:**
- **Serilog** - Structured logging, multiple sinks
- **NLog** - Flexible logging framework
- **Application Insights** - Azure monitoring
- **Seq** - Centralized log server

#### Concept 5: Structured Logging

Structured logging records data in a structured format, not just strings.

**Unstructured (bad):**
```csharp
_logger.LogInformation($"User {userId} logged in at {DateTime.Now}");
// Output: "User 123 logged in at 11/23/2026 10:30:00 AM"
```

**Structured (good):**
```csharp
_logger.LogInformation("User {UserId} logged in", userId);
// Output with structured data:
// {
//   "Message": "User 123 logged in",
//   "UserId": 123,
//   "Timestamp": "2026-11-23T10:30:00Z"
// }
```

Structured logs are searchable and can be queried.

### Important Terminology

| Term | Definition |
|------|------------|
| **Exception** | An error that occurs during execution |
| **Stack Trace** | List of method calls leading to an error |
| **Middleware** | Component in the request pipeline |
| **ILogger** | Interface for logging in .NET |
| **Log Level** | Severity of a log message (Trace, Debug, Info, etc.) |
| **Logging Provider** | Destination for log messages (Console, File, etc.) |
| **Developer Exception Page** | Detailed error page for development |
| **Exception Handler** | Middleware that catches unhandled exceptions |
| **Status Code Pages** | Custom pages for HTTP status codes |
| **Structured Logging** | Logging with structured data, not just strings |

---

## 5. Installation Guide

### No Installation Required for Basic Logging

Basic logging and error handling are built into ASP.NET Core.

### Installing Additional Logging Providers

**Serilog (recommended for production):**

```bash
dotnet add package Serilog.AspNetCore
dotnet add package Serilog.Sinks.Console
dotnet add package Serilog.Sinks.File
```

**NLog:**

```bash
dotnet add package NLog.Web.AspNetCore
```

---

## 6. Initial Setup & Configuration

### Configure Error Handling

**Program.cs:**

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();

var app = builder.Build();

// Development: Detailed errors
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}
else
{
    // Production: Custom error page
    app.UseExceptionHandler("/Error");

    // HTTP Strict Transport Security
    app.UseHsts();
}

// Custom status code pages
app.UseStatusCodePagesWithReExecute("/Error/{0}");

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

### Configure Logging

**appsettings.json:**

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning",
      "Microsoft.EntityFrameworkCore": "Warning"
    }
  }
}
```

**appsettings.Development.json:**

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Debug",
      "Microsoft.AspNetCore": "Information"
    }
  }
}
```

**appsettings.Production.json:**

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Warning",
      "Microsoft.AspNetCore": "Error"
    }
  }
}
```

### Create Error Controller

**Controllers/ErrorController.cs:**

```csharp
public class ErrorController : Controller
{
    private readonly ILogger<ErrorController> _logger;

    public ErrorController(ILogger<ErrorController> logger)
    {
        _logger = logger;
    }

    [Route("/Error")]
    public IActionResult Error()
    {
        var exceptionFeature = HttpContext.Features.Get<IExceptionHandlerPathFeature>();

        if (exceptionFeature != null)
        {
            _logger.LogError(
                exceptionFeature.Error,
                "Unhandled exception occurred at path: {Path}",
                exceptionFeature.Path);
        }

        return View();
    }

    [Route("/Error/{statusCode}")]
    public IActionResult HttpStatusCodeHandler(int statusCode)
    {
        _logger.LogWarning("HTTP {StatusCode} at path: {Path}",
            statusCode,
            HttpContext.Request.Path);

        switch (statusCode)
        {
            case 404:
                ViewBag.ErrorMessage = "Page not found";
                break;
            case 403:
                ViewBag.ErrorMessage = "Access denied";
                break;
            default:
                ViewBag.ErrorMessage = "An error occurred";
                break;
        }

        ViewBag.StatusCode = statusCode;
        return View("Error");
    }
}
```

### Create Error Views

**Views/Error/Error.cshtml:**

```cshtml
@{
    ViewData["Title"] = "Error";
}

<div class="text-center">
    <h1 class="display-4">Oops!</h1>

    @if (ViewBag.StatusCode != null)
    {
        <h2>Error @ViewBag.StatusCode</h2>
        <p>@ViewBag.ErrorMessage</p>
    }
    else
    {
        <p>Something went wrong. Please try again later.</p>
    }

    <a asp-controller="Home" asp-action="Index" class="btn btn-primary">
        Go to Home
    </a>
</div>
```

---

## 7. Basic Usage

### Using ILogger

**Inject ILogger:**

```csharp
public class PokemonController : Controller
{
    private readonly ILogger<PokemonController> _logger;
    private readonly IPokemonService _pokemonService;

    public PokemonController(
        ILogger<PokemonController> logger,
        IPokemonService pokemonService)
    {
        _logger = logger;
        _pokemonService = pokemonService;
    }

    public async Task<IActionResult> Index()
    {
        _logger.LogInformation("Fetching all Pokemon");

        try
        {
            var pokemon = await _pokemonService.GetAllAsync();

            _logger.LogInformation("Retrieved {Count} Pokemon", pokemon.Count);

            return View(pokemon);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching Pokemon");
            return StatusCode(500, "An error occurred");
        }
    }
}
```

### Log Levels

```csharp
// Trace - Very detailed
_logger.LogTrace("Entering method with param: {Id}", id);

// Debug - Diagnostic info
_logger.LogDebug("Database query: {Query}", query);

// Information - General flow
_logger.LogInformation("User {UserId} logged in", userId);

// Warning - Unexpected but handled
_logger.LogWarning("Cache miss for key: {Key}", key);

// Error - Errors and exceptions
_logger.LogError(exception, "Failed to save Pokemon {Id}", id);

// Critical - Serious failures
_logger.LogCritical("Database connection lost!");
```

### Try-Catch in Controllers

```csharp
[HttpPost]
public async Task<IActionResult> Create(Pokemon pokemon)
{
    if (!ModelState.IsValid)
        return View(pokemon);

    try
    {
        await _pokemonService.CreateAsync(pokemon);

        _logger.LogInformation(
            "Created Pokemon: {Name} (ID: {Id})",
            pokemon.Name,
            pokemon.Id);

        return RedirectToAction(nameof(Index));
    }
    catch (DbUpdateException ex)
    {
        _logger.LogError(ex, "Database error creating Pokemon");
        ModelState.AddModelError("", "Unable to save. Database error.");
        return View(pokemon);
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Unexpected error creating Pokemon");
        return StatusCode(500, "An unexpected error occurred");
    }
}
```

### Structured Logging

**Use message templates with parameters:**

```csharp
// Good ✅ - Structured
_logger.LogInformation(
    "User {UserId} caught Pokemon {PokemonName} at {Location}",
    userId,
    pokemonName,
    location);

// Bad ❌ - String concatenation
_logger.LogInformation($"User {userId} caught Pokemon {pokemonName} at {location}");
```

Structured logs allow querying:
```
// Find all logs where UserId = 123
Logs.Where(l => l.UserId == 123)

// Find all Pokemon catches
Logs.Where(l => l.Message.Contains("caught Pokemon"))
```

---

## 8. Testing & Validation

### How to Test Error Handling

#### Method 1: Throw Test Exception

```csharp
public IActionResult TestError()
{
    throw new Exception("This is a test error");
}
```

Navigate to `/Home/TestError`:
- **Development**: Should show detailed exception page
- **Production**: Should show custom error page

#### Method 2: Test HTTP Status Codes

```csharp
public IActionResult Test404()
{
    return NotFound();  // Returns 404
}

public IActionResult Test403()
{
    return Forbid();  // Returns 403
}
```

Navigate to these endpoints to verify status code pages.

#### Method 3: Check Logs

**Console logs:**

Run your app and check console output for log messages.

**File logs (if configured):**

Check log files in configured location.

### Unit Testing with ILogger

```csharp
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

public class PokemonControllerTests
{
    [Fact]
    public async Task Index_LogsInformation()
    {
        // Arrange
        var mockLogger = new Mock<ILogger<PokemonController>>();
        var mockService = new Mock<IPokemonService>();

        mockService.Setup(s => s.GetAllAsync())
            .ReturnsAsync(new List<Pokemon> { new Pokemon() });

        var controller = new PokemonController(mockLogger.Object, mockService.Object);

        // Act
        await controller.Index();

        // Assert
        mockLogger.Verify(
            x => x.Log(
                LogLevel.Information,
                It.IsAny<EventId>(),
                It.Is<It.IsAnyType>((v, t) => v.ToString().Contains("Fetching")),
                null,
                It.IsAny<Func<It.IsAnyType, Exception, string>>()),
            Times.Once);
    }
}
```

### Hands-On Exercises

#### Exercise 1: Add Logging to Controller (Beginner)

**Objective:** Add logging to track user actions

**Task:**
1. Inject ILogger into a controller
2. Log when actions are called
3. Log any errors that occur
4. Run app and verify logs appear

**Requirements:**
- Use LogInformation for normal flow
- Use LogError for exceptions
- Include relevant data in logs

**Solution:**
<details>
<summary>Click to reveal solution</summary>

```csharp
public class PokemonController : Controller
{
    private readonly ILogger<PokemonController> _logger;
    private readonly IPokemonService _service;

    public PokemonController(
        ILogger<PokemonController> logger,
        IPokemonService service)
    {
        _logger = logger;
        _service = service;
    }

    public async Task<IActionResult> Index()
    {
        _logger.LogInformation("Pokemon Index page accessed");

        try
        {
            var pokemon = await _service.GetAllAsync();
            _logger.LogInformation("Retrieved {Count} Pokemon", pokemon.Count);
            return View(pokemon);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving Pokemon list");
            TempData["Error"] = "Unable to load Pokemon list";
            return View(new List<Pokemon>());
        }
    }

    public async Task<IActionResult> Details(int id)
    {
        _logger.LogInformation("Viewing Pokemon details for ID: {Id}", id);

        try
        {
            var pokemon = await _service.GetByIdAsync(id);

            if (pokemon == null)
            {
                _logger.LogWarning("Pokemon with ID {Id} not found", id);
                return NotFound();
            }

            return View(pokemon);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving Pokemon with ID: {Id}", id);
            return StatusCode(500);
        }
    }
}
```

**Test:**
1. Run application
2. Navigate to Pokemon pages
3. Check console for log messages
4. Should see "Pokemon Index page accessed", "Retrieved X Pokemon", etc.

</details>

---

#### Exercise 2: Create Custom Error Pages (Intermediate)

**Objective:** Create custom error pages for different HTTP status codes

**Task:**
1. Create ErrorController with status code handler
2. Create custom views for 404, 403, 500
3. Configure status code pages middleware
4. Test by triggering different errors

**Requirements:**
- Handle 404 (Not Found)
- Handle 403 (Forbidden)
- Handle 500 (Internal Server Error)
- Display user-friendly messages

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Configure in Program.cs**

```csharp
app.UseStatusCodePagesWithReExecute("/Error/{0}");
app.UseExceptionHandler("/Error");
```

**Step 2: ErrorController**

```csharp
public class ErrorController : Controller
{
    [Route("/Error/{statusCode}")]
    public IActionResult HttpStatusCodeHandler(int statusCode)
    {
        ViewBag.StatusCode = statusCode;

        switch (statusCode)
        {
            case 404:
                ViewBag.Title = "Page Not Found";
                ViewBag.Message = "The page you're looking for doesn't exist.";
                break;
            case 403:
                ViewBag.Title = "Access Denied";
                ViewBag.Message = "You don't have permission to access this resource.";
                break;
            case 500:
                ViewBag.Title = "Server Error";
                ViewBag.Message = "Something went wrong on our end.";
                break;
            default:
                ViewBag.Title = "Error";
                ViewBag.Message = "An error occurred.";
                break;
        }

        return View("HttpError");
    }

    [Route("/Error")]
    public IActionResult Error()
    {
        return View();
    }
}
```

**Step 3: Views/Error/HttpError.cshtml**

```cshtml
@{
    ViewData["Title"] = ViewBag.Title;
}

<div class="container text-center mt-5">
    <h1 class="display-1">@ViewBag.StatusCode</h1>
    <h2>@ViewBag.Title</h2>
    <p class="lead">@ViewBag.Message</p>

    @if (ViewBag.StatusCode == 404)
    {
        <img src="~/images/404-pikachu.png" alt="404" class="img-fluid" style="max-width: 400px;" />
    }

    <div class="mt-4">
        <a asp-controller="Home" asp-action="Index" class="btn btn-primary">
            Go Home
        </a>
    </div>
</div>
```

**Step 4: Test**

Create test endpoints:
```csharp
public IActionResult Test404() => NotFound();
public IActionResult Test403() => Forbid();
public IActionResult Test500() => throw new Exception("Test");
```

</details>

---

#### Exercise 3: Implement Global Exception Filter (Challenge)

**Objective:** Create a global exception filter that logs all unhandled exceptions

**Task:**
1. Create custom exception filter
2. Register globally
3. Log exceptions with context
4. Return appropriate responses
5. Test with various exceptions

**Requirements:**
- Log exception details
- Include request path and user info
- Return JSON for API requests
- Return view for MVC requests

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Create filter**

```csharp
// Filters/GlobalExceptionFilter.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

public class GlobalExceptionFilter : IExceptionFilter
{
    private readonly ILogger<GlobalExceptionFilter> _logger;
    private readonly IHostEnvironment _environment;

    public GlobalExceptionFilter(
        ILogger<GlobalExceptionFilter> logger,
        IHostEnvironment environment)
    {
        _logger = logger;
        _environment = environment;
    }

    public void OnException(ExceptionContext context)
    {
        var exception = context.Exception;
        var request = context.HttpContext.Request;
        var user = context.HttpContext.User.Identity?.Name ?? "Anonymous";

        _logger.LogError(exception,
            "Unhandled exception occurred. Path: {Path}, User: {User}",
            request.Path,
            user);

        // Check if it's an API request
        var isApiRequest = request.Path.StartsWithSegments("/api");

        if (isApiRequest)
        {
            // Return JSON for API
            context.Result = new ObjectResult(new
            {
                error = "An error occurred",
                message = _environment.IsDevelopment() ? exception.Message : "Internal server error",
                path = request.Path.ToString()
            })
            {
                StatusCode = 500
            };
        }
        else
        {
            // Redirect to error page for MVC
            context.Result = new RedirectToActionResult("Error", "Error", null);
        }

        context.ExceptionHandled = true;
    }
}
```

**Step 2: Register globally**

```csharp
// Program.cs
builder.Services.AddControllersWithViews(options =>
{
    options.Filters.Add<GlobalExceptionFilter>();
});
```

**Step 3: Test**

```csharp
// Test MVC exception
public IActionResult TestMvcException()
{
    throw new Exception("Test MVC exception");
}

// Test API exception
[Route("api/test/error")]
public IActionResult TestApiException()
{
    throw new Exception("Test API exception");
}
```

Access both endpoints and verify:
- MVC redirects to error page
- API returns JSON error response
- Both are logged

</details>

---

### Self-Assessment Checklist

After completing this guide, you should be able to:

- [ ] Understand exception handling middleware
- [ ] Configure different error handling for dev vs production
- [ ] Create custom error pages
- [ ] Handle specific HTTP status codes
- [ ] Use ILogger to log messages
- [ ] Understand and use log levels appropriately
- [ ] Implement structured logging
- [ ] Configure logging providers
- [ ] Create global exception filters
- [ ] Test error handling and logging

---

## 9. Practical Examples

### Example 1: Logging Service Operations

```csharp
public class PokemonService : IPokemonService
{
    private readonly ApplicationDbContext _context;
    private readonly ILogger<PokemonService> _logger;

    public PokemonService(
        ApplicationDbContext context,
        ILogger<PokemonService> logger)
    {
        _context = context;
        _logger = logger;
    }

    public async Task<Pokemon> GetByIdAsync(int id)
    {
        _logger.LogDebug("Fetching Pokemon with ID: {Id}", id);

        try
        {
            var pokemon = await _context.Pokemon.FindAsync(id);

            if (pokemon == null)
            {
                _logger.LogWarning("Pokemon with ID {Id} not found", id);
                return null;
            }

            _logger.LogDebug("Found Pokemon: {Name} (ID: {Id})",
                pokemon.Name, pokemon.Id);

            return pokemon;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex,
                "Error fetching Pokemon with ID: {Id}", id);
            throw;
        }
    }

    public async Task CreateAsync(Pokemon pokemon)
    {
        _logger.LogInformation(
            "Creating Pokemon: {Name}, Type: {Type}, Level: {Level}",
            pokemon.Name,
            pokemon.Type,
            pokemon.Level);

        try
        {
            _context.Pokemon.Add(pokemon);
            await _context.SaveChangesAsync();

            _logger.LogInformation(
                "Successfully created Pokemon with ID: {Id}",
                pokemon.Id);
        }
        catch (DbUpdateException ex)
        {
            _logger.LogError(ex,
                "Database error creating Pokemon: {Name}",
                pokemon.Name);
            throw;
        }
    }
}
```

---

### Example 2: API Error Handling

```csharp
[ApiController]
[Route("api/[controller]")]
public class PokemonApiController : ControllerBase
{
    private readonly IPokemonService _service;
    private readonly ILogger<PokemonApiController> _logger;

    public PokemonApiController(
        IPokemonService service,
        ILogger<PokemonApiController> logger)
    {
        _service = service;
        _logger = logger;
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Pokemon>> GetById(int id)
    {
        _logger.LogInformation("API request: GET Pokemon {Id}", id);

        try
        {
            var pokemon = await _service.GetByIdAsync(id);

            if (pokemon == null)
            {
                _logger.LogWarning("Pokemon {Id} not found in API request", id);
                return NotFound(new { error = "Pokemon not found", id });
            }

            return Ok(pokemon);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error in API GET Pokemon {Id}", id);

            return StatusCode(500, new
            {
                error = "An error occurred",
                message = "Unable to retrieve Pokemon"
            });
        }
    }

    [HttpPost]
    public async Task<ActionResult<Pokemon>> Create(Pokemon pokemon)
    {
        _logger.LogInformation("API request: POST Pokemon {Name}", pokemon.Name);

        if (!ModelState.IsValid)
        {
            _logger.LogWarning("Invalid model state for Pokemon creation");
            return BadRequest(ModelState);
        }

        try
        {
            await _service.CreateAsync(pokemon);
            _logger.LogInformation("API created Pokemon {Id}", pokemon.Id);

            return CreatedAtAction(
                nameof(GetById),
                new { id = pokemon.Id },
                pokemon);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error in API POST Pokemon");

            return StatusCode(500, new
            {
                error = "An error occurred",
                message = "Unable to create Pokemon"
            });
        }
    }
}
```

---

## 10. Common Patterns & Best Practices

### Do's

✅ **Always log exceptions**

```csharp
catch (Exception ex)
{
    _logger.LogError(ex, "Error message with context");
    throw;  // Re-throw to let middleware handle
}
```

✅ **Use structured logging**

```csharp
// Good ✅
_logger.LogInformation("User {UserId} logged in", userId);

// Bad ❌
_logger.LogInformation($"User {userId} logged in");
```

✅ **Different error pages for dev vs production**

```csharp
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}
else
{
    app.UseExceptionHandler("/Error");
}
```

✅ **Log at appropriate levels**

```csharp
_logger.LogDebug("Diagnostic info");
_logger.LogInformation("General flow");
_logger.LogWarning("Unexpected but handled");
_logger.LogError(ex, "Error occurred");
```

### Don'ts

❌ **Don't expose sensitive information in logs**

```csharp
// Bad ❌
_logger.LogInformation("User password: {Password}", password);

// Good ✅
_logger.LogInformation("User authenticated");
```

❌ **Don't swallow exceptions silently**

```csharp
// Bad ❌
try
{
    DoSomething();
}
catch (Exception)
{
    // Silent failure
}

// Good ✅
try
{
    DoSomething();
}
catch (Exception ex)
{
    _logger.LogError(ex, "Error in DoSomething");
    throw;
}
```

❌ **Don't over-log**

```csharp
// Bad ❌ - Too much noise
_logger.LogInformation("Entering method");
_logger.LogInformation("Creating variable");
_logger.LogInformation("Calling service");
_logger.LogInformation("Exiting method");
```

---

## 11. Troubleshooting & Common Issues

### Problem: Logs not appearing

**Cause:** Log level too high

**Solution:**

Check appsettings.json:
```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information"  // Lower this if needed
    }
  }
}
```

### Problem: Error page not showing

**Cause:** UseExceptionHandler not configured

**Solution:**
```csharp
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
}
```

Ensure ErrorController and Error view exist.

---

## 12. Additional Resources

### Official Documentation

- [Error handling in ASP.NET Core](https://learn.microsoft.com/aspnet/core/fundamentals/error-handling)
- [Logging in .NET](https://learn.microsoft.com/dotnet/core/extensions/logging)
- [Logging providers](https://learn.microsoft.com/aspnet/core/fundamentals/logging)

### Next Steps

After mastering error handling and logging:

1. **Serilog** - Advanced structured logging
2. **Application Insights** - Azure monitoring
3. **Health Checks** - Monitor application health
4. **Exception Filters** - Advanced exception handling
5. **Distributed Tracing** - Track requests across services

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-11-23 | Initial comprehensive documentation for Error Handling and Logging |

---

**Estimated Reading Time**: 50-55 minutes

**Prerequisites**: ASP.NET Core basics (POK-10), Middleware concepts

**Related Topics**: Filters (POK-38), Production Deployment, Monitoring
