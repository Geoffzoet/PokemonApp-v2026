# Filters in ASP.NET Core

---
**Technology Version**: .NET 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-23
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What are Filters?

Filters in ASP.NET Core MVC are a powerful feature that allows you to run code before or after specific stages in the request processing pipeline. Think of filters as "hooks" that intercept requests and responses, letting you add cross-cutting functionality like logging, error handling, authentication, or caching without cluttering your controller actions.

For example, instead of adding logging code to every single action method, you can create a filter that automatically logs all requests. Instead of repeating authorization checks in multiple controllers, a filter can enforce security rules centrally.

Filters execute within the **MVC action invocation pipeline** (also called the filter pipeline), which runs after routing selects an action to execute. They provide a clean way to implement cross-cutting concerns - functionality that affects multiple parts of your application.

### Why Use Filters?

You should use filters when:

- **DRY principle** - Avoid repeating the same code (logging, validation, etc.) across multiple controllers or actions
- **Cross-cutting concerns** - Implement functionality that spans multiple layers (security, caching, error handling)
- **Separation of concerns** - Keep controllers focused on business logic, not infrastructure concerns
- **Centralized logic** - Apply consistent behavior across your application from one place
- **Testability** - Filters can be tested independently from controllers
- **Reusability** - Create filters once, apply them anywhere

### When to Use Filters

**Good use cases:**
- **Authorization and authentication** - Check if users have permission before executing actions
- **Logging and auditing** - Track who did what and when
- **Exception handling** - Handle errors consistently across the application
- **Caching** - Cache action results to improve performance
- **Validation** - Validate model state before action execution
- **Request/Response modification** - Add headers, modify data, compress responses
- **Performance monitoring** - Measure action execution times

**Not recommended for:**
- Application-wide middleware concerns (use middleware instead for broader scope)
- One-off logic that only applies to a single action (put it in the action method)
- Complex business logic (belongs in services, not filters)

### Filters vs Middleware

**Middleware:**
- Runs for **every request** in the application
- Executes before MVC pipeline
- Works with HttpContext
- Good for: Static files, authentication, CORS, global error handling

**Filters:**
- Run only for **MVC actions** (controllers)
- Execute within MVC pipeline after routing
- Work with MVC-specific contexts
- Good for: Action-specific logic, model validation, authorization per action

```
Request → Middleware Pipeline → Routing → MVC Filter Pipeline → Controller Action
          ↑                                ↑
     App-wide concerns              Controller-specific concerns
```

---

## 2. Quick Start

**TL;DR - Create and use a filter in 3 minutes:**

**Step 1: Create a simple action filter**

```csharp
using Microsoft.AspNetCore.Mvc.Filters;

public class LogActionFilter : IActionFilter
{
    public void OnActionExecuting(ActionExecutingContext context)
    {
        // Before action executes
        Console.WriteLine($"Executing: {context.ActionDescriptor.DisplayName}");
    }

    public void OnActionExecuted(ActionExecutedContext context)
    {
        // After action executes
        Console.WriteLine($"Executed: {context.ActionDescriptor.DisplayName}");
    }
}
```

**Step 2: Apply the filter to a controller**

```csharp
[ServiceFilter(typeof(LogActionFilter))]
public class PokemonController : Controller
{
    public IActionResult List()
    {
        return View();
    }
}
```

**Step 3: Register the filter**

```csharp
// Program.cs
builder.Services.AddScoped<LogActionFilter>();
```

**Expected output:**
```
Executing: PokemonController.List
Executed: PokemonController.List
```

For detailed explanations, continue reading the sections below.

---

## 3. Prerequisites

### Required Knowledge

- **C# basics** - Classes, interfaces, attributes, async/await
- **ASP.NET Core MVC** - Controllers, actions, routing (see POK-22)
- **Dependency Injection** - Understanding how DI works in .NET (see POK-11)
- **HTTP fundamentals** - Requests, responses, status codes (see POK-6)

### Required Software/Tools

- **.NET SDK** - Version 8.0 or higher
- **Code Editor** - Visual Studio, VS Code, or Rider
- **Existing MVC Project** - You should have a working MVC application

### System Requirements

- **Operating System**: Windows 10+, macOS 11+, or modern Linux
- **RAM**: 4GB minimum (8GB recommended)
- **Disk Space**: 500MB for project files

---

## 4. Core Concepts & Theory

### Key Concepts

#### Concept 1: The Filter Pipeline

Filters execute in a specific order within the MVC pipeline:

```
1. Authorization Filters    → Check if user is authorized
2. Resource Filters (before) → Can short-circuit the pipeline
3. Model Binding             → Bind request data to action parameters
4. Action Filters (before)   → Run before action method
5. Action Method Execution   → Your controller action runs
6. Action Filters (after)    → Run after action method
7. Exception Filters         → Handle exceptions (if any occurred)
8. Result Filters (before)   → Run before result execution
9. Result Execution          → Generate response (View, JSON, etc.)
10. Result Filters (after)   → Run after result execution
11. Resource Filters (after) → Clean up resources
```

**Flow diagram:**

```
       Request
          ↓
  ┌──────────────────┐
  │Authorization     │ ← Can short-circuit
  └────────┬─────────┘
           ↓
  ┌──────────────────┐
  │Resource (Before) │ ← Can short-circuit
  └────────┬─────────┘
           ↓
  ┌──────────────────┐
  │Model Binding     │
  └────────┬─────────┘
           ↓
  ┌──────────────────┐
  │Action (Before)   │
  └────────┬─────────┘
           ↓
  ┌──────────────────┐
  │Controller Action │ ← Your code
  └────────┬─────────┘
           ↓
  ┌──────────────────┐
  │Action (After)    │
  └────────┬─────────┘
           ↓
    Exception? ───Yes──→ ┌──────────────────┐
           │             │Exception Filter  │
          No             └────────┬─────────┘
           ↓                      ↓
  ┌──────────────────┐           │
  │Result (Before)   │←──────────┘
  └────────┬─────────┘
           ↓
  ┌──────────────────┐
  │Execute Result    │
  └────────┬─────────┘
           ↓
  ┌──────────────────┐
  │Result (After)    │
  └────────┬─────────┘
           ↓
  ┌──────────────────┐
  │Resource (After)  │
  └────────┬─────────┘
           ↓
       Response
```

#### Concept 2: Filter Types

ASP.NET Core provides five filter types, each for a specific purpose:

**1. Authorization Filters (`IAuthorizationFilter`)**
- **Execute first** in the pipeline
- Determine if user is authorized for the request
- Can short-circuit the pipeline
- Example: Check if user has "Admin" role

**2. Resource Filters (`IResourceFilter`)**
- Run **before and after** the rest of the pipeline
- Good for caching, logging, timing
- Can short-circuit to prevent action execution
- Example: Cache responses, measure request duration

**3. Action Filters (`IActionFilter`)**
- Run **before and after** the action method
- Most commonly used filter type
- Can modify action arguments or results
- Example: Logging, validation, modifying model data

**4. Exception Filters (`IExceptionFilter`)**
- Handle exceptions that occur during action execution
- Run when an unhandled exception is thrown
- Example: Log errors, return custom error responses

**5. Result Filters (`IResultFilter`)**
- Run **before and after** the action result executes
- Useful for modifying results (Views, JSON, etc.)
- Example: Add headers, modify JSON output

#### Concept 3: Synchronous vs Asynchronous Filters

Filters can be implemented in two ways:

**Synchronous:**
```csharp
public class MyActionFilter : IActionFilter
{
    public void OnActionExecuting(ActionExecutingContext context) { }
    public void OnActionExecuted(ActionExecutedContext context) { }
}
```

**Asynchronous:**
```csharp
public class MyAsyncActionFilter : IAsyncActionFilter
{
    public async Task OnActionExecutionAsync(
        ActionExecutingContext context,
        ActionExecutionDelegate next)
    {
        // Before action
        await next(); // Execute action
        // After action
    }
}
```

**When to use async filters:**
- When performing I/O operations (database, file, network)
- When calling async services
- For better performance under load

#### Concept 4: Filter Scopes

Filters can be applied at three scopes:

**1. Global scope** - Applies to all controllers and actions
```csharp
builder.Services.AddControllersWithViews(options =>
{
    options.Filters.Add<MyGlobalFilter>();
});
```

**2. Controller scope** - Applies to all actions in a controller
```csharp
[ServiceFilter(typeof(MyFilter))]
public class PokemonController : Controller { }
```

**3. Action scope** - Applies to a single action
```csharp
public class PokemonController : Controller
{
    [ServiceFilter(typeof(MyFilter))]
    public IActionResult Details(int id) { }
}
```

**Execution order:** Global → Controller → Action

#### Concept 5: Short-Circuiting

Filters can short-circuit (stop) the pipeline by setting the Result:

```csharp
public void OnActionExecuting(ActionExecutingContext context)
{
    if (!context.ModelState.IsValid)
    {
        // Short-circuit: return BadRequest immediately
        context.Result = new BadRequestObjectResult(context.ModelState);
        // Pipeline stops here, action never executes
    }
}
```

### Important Terminology

| Term | Definition |
|------|------------|
| **Filter** | Code that runs before/after pipeline stages |
| **Filter Pipeline** | The sequence of filters that execute for an action |
| **Short-circuit** | Stop pipeline execution and return a result immediately |
| **Filter Scope** | Where the filter applies (Global, Controller, Action) |
| **Context** | Object containing request/response information |
| **ActionExecutingContext** | Context before action runs |
| **ActionExecutedContext** | Context after action runs |
| **IActionFilter** | Interface for synchronous action filters |
| **IAsyncActionFilter** | Interface for asynchronous action filters |
| **Filter Attribute** | Attribute class that also implements filter interface |
| **ServiceFilter** | Attribute that resolves filters from DI container |
| **TypeFilter** | Attribute that creates filter instances with DI support |

### Architecture Overview

**How filters integrate with MVC:**

```
┌─────────────────────────────────────────────┐
│          HTTP Request                       │
└─────────────────┬───────────────────────────┘
                  │
         ┌────────▼────────┐
         │  Middleware     │
         │  Pipeline       │
         └────────┬────────┘
                  │
         ┌────────▼────────┐
         │   Routing       │
         │   (Selects      │
         │   Controller)   │
         └────────┬────────┘
                  │
    ┌─────────────▼─────────────┐
    │     MVC FILTER PIPELINE   │
    │                           │
    │  ┌─────────────────────┐ │
    │  │Authorization Filters│ │
    │  └──────────┬──────────┘ │
    │             │             │
    │  ┌──────────▼──────────┐ │
    │  │Resource Filters     │ │
    │  │(Before)             │ │
    │  └──────────┬──────────┘ │
    │             │             │
    │  ┌──────────▼──────────┐ │
    │  │Action Filters       │ │
    │  │(Before)             │ │
    │  └──────────┬──────────┘ │
    │             │             │
    │  ┌──────────▼──────────┐ │
    │  │  Controller Action  │ │
    │  │  (Your Code)        │ │
    │  └──────────┬──────────┘ │
    │             │             │
    │  ┌──────────▼──────────┐ │
    │  │Action Filters       │ │
    │  │(After)              │ │
    │  └──────────┬──────────┘ │
    │             │             │
    │  ┌──────────▼──────────┐ │
    │  │Result Filters       │ │
    │  │(Before/After)       │ │
    │  └──────────┬──────────┘ │
    │             │             │
    │  ┌──────────▼──────────┐ │
    │  │Resource Filters     │ │
    │  │(After)              │ │
    │  └──────────┬──────────┘ │
    └──────────────┼────────────┘
                   │
         ┌─────────▼─────────┐
         │   HTTP Response   │
         └───────────────────┘
```

---

## 5. Installation Guide

### No Installation Required

Filters are built into ASP.NET Core MVC. No additional packages are needed for basic filter functionality.

### Verify Filter Support

**Check 1: Create a test filter**

```csharp
// Filters/TestFilter.cs
using Microsoft.AspNetCore.Mvc.Filters;

namespace PokemonApp.Filters
{
    public class TestFilter : IActionFilter
    {
        public void OnActionExecuting(ActionExecutingContext context)
        {
            Console.WriteLine("TestFilter is working!");
        }

        public void OnActionExecuted(ActionExecutedContext context)
        {
        }
    }
}
```

**Check 2: Apply to a controller**

```csharp
using PokemonApp.Filters;

[ServiceFilter(typeof(TestFilter))]
public class HomeController : Controller
{
    public IActionResult Index()
    {
        return View();
    }
}
```

**Check 3: Register in Program.cs**

```csharp
builder.Services.AddScoped<TestFilter>();
```

**Check 4: Run and verify**

Navigate to `/Home/Index` and check the console output. You should see "TestFilter is working!"

---

## 6. Initial Setup & Configuration

### Creating a Filters Folder

Organize filters in a dedicated folder:

```
PokemonApp/
├── Controllers/
├── Filters/                     ← Create this folder
│   ├── LogActionFilter.cs
│   ├── ValidateModelFilter.cs
│   └── CustomExceptionFilter.cs
├── Models/
├── Views/
└── Program.cs
```

### Filter Base Setup Pattern

**Create a base filter class (optional but recommended):**

```csharp
// Filters/BaseActionFilter.cs
using Microsoft.AspNetCore.Mvc.Filters;

namespace PokemonApp.Filters
{
    public abstract class BaseActionFilter : IActionFilter
    {
        protected readonly ILogger _logger;

        protected BaseActionFilter(ILogger logger)
        {
            _logger = logger;
        }

        public virtual void OnActionExecuting(ActionExecutingContext context)
        {
            // Can be overridden by derived classes
        }

        public virtual void OnActionExecuted(ActionExecutedContext context)
        {
            // Can be overridden by derived classes
        }
    }
}
```

### Registering Filters Globally

**Add filters to all controllers:**

```csharp
// Program.cs
builder.Services.AddControllersWithViews(options =>
{
    // Add global filters
    options.Filters.Add<GlobalExceptionFilter>();
    options.Filters.Add<ValidateModelStateFilter>();
});
```

### Registering Filters for Dependency Injection

**Register filter services:**

```csharp
// Program.cs
builder.Services.AddScoped<LogActionFilter>();
builder.Services.AddScoped<ValidateModelFilter>();
builder.Services.AddScoped<CustomExceptionFilter>();
```

---

## 7. Basic Usage

### Creating a Simple Action Filter

**Scenario:** Log every time an action is called.

**Filters/LogActionFilter.cs:**

```csharp
using Microsoft.AspNetCore.Mvc.Filters;

namespace PokemonApp.Filters
{
    public class LogActionFilter : IActionFilter
    {
        private readonly ILogger<LogActionFilter> _logger;

        public LogActionFilter(ILogger<LogActionFilter> logger)
        {
            _logger = logger;
        }

        public void OnActionExecuting(ActionExecutingContext context)
        {
            var controllerName = context.RouteData.Values["controller"];
            var actionName = context.RouteData.Values["action"];

            _logger.LogInformation(
                "Executing action: {Controller}.{Action}",
                controllerName,
                actionName);
        }

        public void OnActionExecuted(ActionExecutedContext context)
        {
            var controllerName = context.RouteData.Values["controller"];
            var actionName = context.RouteData.Values["action"];

            _logger.LogInformation(
                "Executed action: {Controller}.{Action}",
                controllerName,
                actionName);
        }
    }
}
```

**Register:**

```csharp
builder.Services.AddScoped<LogActionFilter>();
```

**Apply to controller:**

```csharp
[ServiceFilter(typeof(LogActionFilter))]
public class PokemonController : Controller
{
    public IActionResult List()
    {
        return View();
    }
}
```

### Creating a Model Validation Filter

**Scenario:** Automatically return BadRequest if model state is invalid.

**Filters/ValidateModelStateFilter.cs:**

```csharp
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace PokemonApp.Filters
{
    public class ValidateModelStateFilter : IActionFilter
    {
        public void OnActionExecuting(ActionExecutingContext context)
        {
            if (!context.ModelState.IsValid)
            {
                // Short-circuit: return error response
                context.Result = new BadRequestObjectResult(context.ModelState);
            }
        }

        public void OnActionExecuted(ActionExecutedContext context)
        {
            // Nothing to do after action
        }
    }
}
```

**Apply globally:**

```csharp
builder.Services.AddControllersWithViews(options =>
{
    options.Filters.Add<ValidateModelStateFilter>();
});
```

**Now all actions automatically validate model state:**

```csharp
[HttpPost]
public IActionResult Create(Pokemon pokemon)
{
    // No need to check ModelState.IsValid here
    // Filter already handled it

    _service.Create(pokemon);
    return RedirectToAction("List");
}
```

### Creating an Exception Filter

**Scenario:** Handle exceptions and return consistent error responses.

**Filters/CustomExceptionFilter.cs:**

```csharp
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace PokemonApp.Filters
{
    public class CustomExceptionFilter : IExceptionFilter
    {
        private readonly ILogger<CustomExceptionFilter> _logger;

        public CustomExceptionFilter(ILogger<CustomExceptionFilter> logger)
        {
            _logger = logger;
        }

        public void OnException(ExceptionContext context)
        {
            _logger.LogError(
                context.Exception,
                "An error occurred: {Message}",
                context.Exception.Message);

            // Return custom error response
            context.Result = new ObjectResult(new
            {
                error = "An error occurred processing your request",
                message = context.Exception.Message
            })
            {
                StatusCode = 500
            };

            // Mark exception as handled
            context.ExceptionHandled = true;
        }
    }
}
```

**Apply globally:**

```csharp
builder.Services.AddControllersWithViews(options =>
{
    options.Filters.Add<CustomExceptionFilter>();
});
```

### Creating an Async Action Filter

**Scenario:** Measure action execution time asynchronously.

**Filters/PerformanceFilter.cs:**

```csharp
using Microsoft.AspNetCore.Mvc.Filters;
using System.Diagnostics;

namespace PokemonApp.Filters
{
    public class PerformanceFilter : IAsyncActionFilter
    {
        private readonly ILogger<PerformanceFilter> _logger;

        public PerformanceFilter(ILogger<PerformanceFilter> logger)
        {
            _logger = logger;
        }

        public async Task OnActionExecutionAsync(
            ActionExecutingContext context,
            ActionExecutionDelegate next)
        {
            // Before action
            var stopwatch = Stopwatch.StartNew();
            var actionName = context.ActionDescriptor.DisplayName;

            // Execute action
            var resultContext = await next();

            // After action
            stopwatch.Stop();

            _logger.LogInformation(
                "Action {ActionName} took {ElapsedMilliseconds}ms",
                actionName,
                stopwatch.ElapsedMilliseconds);
        }
    }
}
```

### Using TypeFilter vs ServiceFilter

**ServiceFilter** - Resolves from DI (recommended):

```csharp
// Register in DI
builder.Services.AddScoped<LogActionFilter>();

// Use ServiceFilter
[ServiceFilter(typeof(LogActionFilter))]
public class PokemonController : Controller { }
```

**TypeFilter** - Creates new instance:

```csharp
// No registration needed

// Use TypeFilter (creates instance on each request)
[TypeFilter(typeof(LogActionFilter))]
public class PokemonController : Controller { }
```

**When to use each:**
- **ServiceFilter**: When filter needs DI dependencies (ILogger, services, etc.)
- **TypeFilter**: For simple filters without dependencies

### Filter Attributes

**Create filter as an attribute:**

```csharp
using Microsoft.AspNetCore.Mvc.Filters;

namespace PokemonApp.Filters
{
    public class LogAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext context)
        {
            Console.WriteLine($"Executing: {context.ActionDescriptor.DisplayName}");
        }

        public override void OnActionExecuted(ActionExecutedContext context)
        {
            Console.WriteLine($"Executed: {context.ActionDescriptor.DisplayName}");
        }
    }
}
```

**Use as attribute (no registration needed):**

```csharp
[Log]  // ← Simple attribute
public class PokemonController : Controller
{
    public IActionResult List()
    {
        return View();
    }
}
```

---

## 8. Testing & Validation

### How to Test Filters

#### Method 1: Unit Testing

**Test action filter:**

```csharp
using Xunit;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Moq;

public class LogActionFilterTests
{
    [Fact]
    public void OnActionExecuting_LogsInformation()
    {
        // Arrange
        var mockLogger = new Mock<ILogger<LogActionFilter>>();
        var filter = new LogActionFilter(mockLogger.Object);

        var context = CreateActionExecutingContext();

        // Act
        filter.OnActionExecuting(context);

        // Assert
        mockLogger.Verify(
            x => x.Log(
                LogLevel.Information,
                It.IsAny<EventId>(),
                It.Is<It.IsAnyType>((v, t) => true),
                null,
                It.IsAny<Func<It.IsAnyType, Exception, string>>()),
            Times.Once);
    }

    private ActionExecutingContext CreateActionExecutingContext()
    {
        var actionContext = new ActionContext(
            new DefaultHttpContext(),
            new RouteData(),
            new Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor());

        return new ActionExecutingContext(
            actionContext,
            new List<IFilterMetadata>(),
            new Dictionary<string, object>(),
            new Mock<Controller>().Object);
    }
}
```

#### Method 2: Integration Testing

**Test filter in real HTTP requests:**

```csharp
using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;

public class FilterIntegrationTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;

    public FilterIntegrationTests(WebApplicationFactory<Program> factory)
    {
        _factory = factory;
    }

    [Fact]
    public async Task Pokemon_List_ExecutesWithFilter()
    {
        // Arrange
        var client = _factory.CreateClient();

        // Act
        var response = await client.GetAsync("/Pokemon/List");

        // Assert
        response.EnsureSuccessStatusCode();
        // Verify filter executed (check logs, headers, etc.)
    }
}
```

#### Method 3: Manual Testing

**Add logging to verify filters execute:**

```csharp
public class LogActionFilter : IActionFilter
{
    public void OnActionExecuting(ActionExecutingContext context)
    {
        Console.WriteLine("✅ LogActionFilter - OnActionExecuting");
    }

    public void OnActionExecuted(ActionExecutedContext context)
    {
        Console.WriteLine("✅ LogActionFilter - OnActionExecuted");
    }
}
```

Run your application and watch console output when actions execute.

### Hands-On Exercises

#### Exercise 1: Create a Simple Logging Filter (Beginner)

**Objective:** Create a filter that logs action name and execution time

**Task:**
1. Create a filter that logs when an action starts and completes
2. Display the controller and action name
3. Apply it to a controller
4. Test it works

**Requirements:**
- Use `IActionFilter` interface
- Log to `ILogger`
- Apply with `[ServiceFilter]` attribute
- Test by navigating to an action

**Hints:**
- Use `context.RouteData.Values["controller"]` to get controller name
- Use `context.RouteData.Values["action"]` to get action name
- Register filter in DI before using ServiceFilter

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Create filter**

```csharp
// Filters/SimpleLogFilter.cs
using Microsoft.AspNetCore.Mvc.Filters;

public class SimpleLogFilter : IActionFilter
{
    private readonly ILogger<SimpleLogFilter> _logger;

    public SimpleLogFilter(ILogger<SimpleLogFilter> logger)
    {
        _logger = logger;
    }

    public void OnActionExecuting(ActionExecutingContext context)
    {
        var controller = context.RouteData.Values["controller"];
        var action = context.RouteData.Values["action"];

        _logger.LogInformation("▶️  Starting {Controller}.{Action}", controller, action);
    }

    public void OnActionExecuted(ActionExecutedContext context)
    {
        var controller = context.RouteData.Values["controller"];
        var action = context.RouteData.Values["action"];

        _logger.LogInformation("✅ Completed {Controller}.{Action}", controller, action);
    }
}
```

**Step 2: Register**

```csharp
// Program.cs
builder.Services.AddScoped<SimpleLogFilter>();
```

**Step 3: Apply**

```csharp
[ServiceFilter(typeof(SimpleLogFilter))]
public class PokemonController : Controller
{
    public IActionResult List()
    {
        return View();
    }
}
```

**Step 4: Test**

Navigate to `/Pokemon/List` and check console output:
```
▶️  Starting Pokemon.List
✅ Completed Pokemon.List
```

</details>

---

#### Exercise 2: Create a Model Validation Filter (Intermediate)

**Objective:** Create a filter that automatically handles invalid model state

**Task:**
1. Create a filter that checks `ModelState.IsValid`
2. If invalid, return a `BadRequest` with errors
3. If valid, let action continue
4. Apply filter globally
5. Test with a form submission

**Requirements:**
- Use `IActionFilter`
- Short-circuit on invalid models
- Return structured error response
- Apply globally to all controllers

**Hints:**
- Check `context.ModelState.IsValid`
- Set `context.Result = new BadRequestObjectResult(...)`
- Register as global filter in `AddControllersWithViews`

**Solution:**
<details>
<summary>Click to reveal solution</summary>

```csharp
// Filters/AutoValidateModelFilter.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

public class AutoValidateModelFilter : IActionFilter
{
    private readonly ILogger<AutoValidateModelFilter> _logger;

    public AutoValidateModelFilter(ILogger<AutoValidateModelFilter> logger)
    {
        _logger = logger;
    }

    public void OnActionExecuting(ActionExecutingContext context)
    {
        if (!context.ModelState.IsValid)
        {
            _logger.LogWarning("Model validation failed for {Action}",
                context.ActionDescriptor.DisplayName);

            // Short-circuit with error response
            context.Result = new BadRequestObjectResult(new
            {
                error = "Validation failed",
                errors = context.ModelState
                    .Where(e => e.Value.Errors.Count > 0)
                    .Select(e => new
                    {
                        field = e.Key,
                        messages = e.Value.Errors.Select(er => er.ErrorMessage)
                    })
            });
        }
    }

    public void OnActionExecuted(ActionExecutedContext context)
    {
        // Nothing to do
    }
}
```

**Register globally:**

```csharp
// Program.cs
builder.Services.AddControllersWithViews(options =>
{
    options.Filters.Add<AutoValidateModelFilter>();
});
```

**Test controller:**

```csharp
public class PokemonController : Controller
{
    [HttpPost]
    public IActionResult Create(Pokemon pokemon)
    {
        // No need to check ModelState - filter handles it!

        _service.Create(pokemon);
        return Ok(new { message = "Pokemon created!" });
    }
}
```

**Test:** Submit invalid form data, should get structured error response automatically.

</details>

---

#### Exercise 3: Create a Performance Monitoring Filter (Challenge)

**Objective:** Create an async filter that measures and logs action execution time, with warnings for slow actions

**Task:**
1. Create an async action filter
2. Measure action execution time using Stopwatch
3. Log execution time
4. Warn if action takes longer than 1 second
5. Add custom header with execution time

**Requirements:**
- Use `IAsyncActionFilter`
- Use `Stopwatch` for timing
- Add HTTP response header with time
- Log warning for slow actions
- Test with both fast and slow actions

**Solution:**
<details>
<summary>Click to reveal solution</summary>

```csharp
// Filters/PerformanceMonitorFilter.cs
using Microsoft.AspNetCore.Mvc.Filters;
using System.Diagnostics;

public class PerformanceMonitorFilter : IAsyncActionFilter
{
    private readonly ILogger<PerformanceMonitorFilter> _logger;
    private const int SlowActionThresholdMs = 1000;

    public PerformanceMonitorFilter(ILogger<PerformanceMonitorFilter> logger)
    {
        _logger = logger;
    }

    public async Task OnActionExecutionAsync(
        ActionExecutingContext context,
        ActionExecutionDelegate next)
    {
        var stopwatch = Stopwatch.StartNew();
        var actionName = context.ActionDescriptor.DisplayName;

        _logger.LogInformation("⏱️  Starting performance monitoring for {Action}", actionName);

        // Execute action
        var resultContext = await next();

        stopwatch.Stop();
        var elapsedMs = stopwatch.ElapsedMilliseconds;

        // Add header to response
        context.HttpContext.Response.Headers.Add("X-Execution-Time-Ms", elapsedMs.ToString());

        // Log execution time
        if (elapsedMs > SlowActionThresholdMs)
        {
            _logger.LogWarning(
                "⚠️  SLOW ACTION: {Action} took {ElapsedMs}ms (threshold: {ThresholdMs}ms)",
                actionName,
                elapsedMs,
                SlowActionThresholdMs);
        }
        else
        {
            _logger.LogInformation(
                "✅ {Action} completed in {ElapsedMs}ms",
                actionName,
                elapsedMs);
        }
    }
}
```

**Register:**

```csharp
builder.Services.AddScoped<PerformanceMonitorFilter>();
```

**Apply to controller:**

```csharp
[ServiceFilter(typeof(PerformanceMonitorFilter))]
public class PokemonController : Controller
{
    // Fast action
    public IActionResult List()
    {
        return View();
    }

    // Slow action for testing
    public async Task<IActionResult> SlowAction()
    {
        await Task.Delay(2000); // Simulate slow operation
        return Ok();
    }
}
```

**Test:**
1. Navigate to `/Pokemon/List` - Should complete quickly, no warning
2. Navigate to `/Pokemon/SlowAction` - Should show warning for slow execution
3. Check response headers for `X-Execution-Time-Ms`

</details>

---

### Self-Assessment Checklist

After completing this section, you should be able to:

- [ ] Explain what filters are and why they're useful
- [ ] Understand the filter pipeline and execution order
- [ ] List all five filter types and their purposes
- [ ] Create synchronous action filters with `IActionFilter`
- [ ] Create asynchronous filters with `IAsyncActionFilter`
- [ ] Apply filters at Global, Controller, and Action scopes
- [ ] Use ServiceFilter and TypeFilter to apply filters
- [ ] Short-circuit the pipeline by setting context.Result
- [ ] Create exception filters to handle errors
- [ ] Test filters using unit and integration tests
- [ ] Debug filter execution and troubleshoot issues

---

## 9. Practical Examples

### Example 1: Request/Response Logging Filter

**Scenario:** Log all incoming requests and outgoing responses for audit purposes.

**Filters/RequestResponseLoggingFilter.cs:**

```csharp
using Microsoft.AspNetCore.Mvc.Filters;
using System.Text.Json;

public class RequestResponseLoggingFilter : IAsyncActionFilter
{
    private readonly ILogger<RequestResponseLoggingFilter> _logger;

    public RequestResponseLoggingFilter(ILogger<RequestResponseLoggingFilter> logger)
    {
        _logger = logger;
    }

    public async Task OnActionExecutionAsync(
        ActionExecutingContext context,
        ActionExecutionDelegate next)
    {
        // Log request
        LogRequest(context);

        // Execute action
        var resultContext = await next();

        // Log response
        LogResponse(resultContext);
    }

    private void LogRequest(ActionExecutingContext context)
    {
        var request = context.HttpContext.Request;

        var requestLog = new
        {
            Timestamp = DateTime.UtcNow,
            Method = request.Method,
            Path = request.Path,
            QueryString = request.QueryString.ToString(),
            User = context.HttpContext.User.Identity?.Name ?? "Anonymous",
            ActionArguments = context.ActionArguments
        };

        _logger.LogInformation(
            "📥 REQUEST: {RequestLog}",
            JsonSerializer.Serialize(requestLog));
    }

    private void LogResponse(ActionExecutedContext context)
    {
        var statusCode = context.HttpContext.Response.StatusCode;

        var responseLog = new
        {
            Timestamp = DateTime.UtcNow,
            StatusCode = statusCode,
            Success = context.Exception == null,
            ExceptionMessage = context.Exception?.Message
        };

        if (context.Exception != null)
        {
            _logger.LogError(
                "📤 RESPONSE (ERROR): {ResponseLog}",
                JsonSerializer.Serialize(responseLog));
        }
        else
        {
            _logger.LogInformation(
                "📤 RESPONSE: {ResponseLog}",
                JsonSerializer.Serialize(responseLog));
        }
    }
}
```

---

### Example 2: API Key Authorization Filter

**Scenario:** Require API key for certain controllers/actions.

**Filters/ApiKeyAuthorizationFilter.cs:**

```csharp
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

public class ApiKeyAuthorizationFilter : IAuthorizationFilter
{
    private const string ApiKeyHeaderName = "X-API-Key";
    private readonly IConfiguration _configuration;

    public ApiKeyAuthorizationFilter(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public void OnAuthorization(AuthorizationFilterContext context)
    {
        // Get API key from header
        if (!context.HttpContext.Request.Headers.TryGetValue(ApiKeyHeaderName, out var providedApiKey))
        {
            context.Result = new UnauthorizedObjectResult(new
            {
                error = "API Key is missing",
                message = $"Please provide API key in {ApiKeyHeaderName} header"
            });
            return;
        }

        // Validate API key
        var validApiKey = _configuration["ApiKey"];
        if (providedApiKey != validApiKey)
        {
            context.Result = new UnauthorizedObjectResult(new
            {
                error = "Invalid API Key",
                message = "The provided API key is invalid"
            });
            return;
        }

        // API key is valid, continue
    }
}
```

**Usage:**

```csharp
[ServiceFilter(typeof(ApiKeyAuthorizationFilter))]
public class ApiController : Controller
{
    [HttpGet]
    public IActionResult GetPokemon()
    {
        // Only accessible with valid API key
        return Ok(new { name = "Pikachu" });
    }
}
```

---

### Example 3: Response Caching Filter

**Scenario:** Cache GET requests for improved performance.

**Filters/SimpleCacheFilter.cs:**

```csharp
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Caching.Memory;

public class SimpleCacheFilter : IAsyncActionFilter
{
    private readonly IMemoryCache _cache;
    private readonly ILogger<SimpleCacheFilter> _logger;
    private const int CacheDurationSeconds = 60;

    public SimpleCacheFilter(IMemoryCache cache, ILogger<SimpleCacheFilter> logger)
    {
        _cache = cache;
        _logger = logger;
    }

    public async Task OnActionExecutionAsync(
        ActionExecutingContext context,
        ActionExecutionDelegate next)
    {
        // Only cache GET requests
        if (context.HttpContext.Request.Method != "GET")
        {
            await next();
            return;
        }

        // Generate cache key
        var cacheKey = GenerateCacheKey(context);

        // Check cache
        if (_cache.TryGetValue(cacheKey, out IActionResult cachedResult))
        {
            _logger.LogInformation("✅ Cache HIT for {CacheKey}", cacheKey);
            context.Result = cachedResult;
            return; // Short-circuit
        }

        _logger.LogInformation("❌ Cache MISS for {CacheKey}", cacheKey);

        // Execute action
        var executedContext = await next();

        // Cache result if successful
        if (executedContext.Exception == null && executedContext.Result != null)
        {
            _cache.Set(cacheKey, executedContext.Result, TimeSpan.FromSeconds(CacheDurationSeconds));
            _logger.LogInformation("💾 Cached result for {CacheKey}", cacheKey);
        }
    }

    private string GenerateCacheKey(ActionExecutingContext context)
    {
        var controller = context.RouteData.Values["controller"];
        var action = context.RouteData.Values["action"];
        var queryString = context.HttpContext.Request.QueryString;

        return $"{controller}_{action}_{queryString}";
    }
}
```

---

## 10. Common Patterns & Best Practices

### Recommended Patterns

#### Pattern 1: Base Filter Class for Common Logic

```csharp
public abstract class BaseActionFilter : IActionFilter
{
    protected readonly ILogger _logger;

    protected BaseActionFilter(ILogger logger)
    {
        _logger = logger;
    }

    public virtual void OnActionExecuting(ActionExecutingContext context)
    {
        // Default implementation
    }

    public virtual void OnActionExecuted(ActionExecutedContext context)
    {
        // Default implementation
    }

    protected string GetActionName(ActionContext context)
    {
        return $"{context.RouteData.Values["controller"]}.{context.RouteData.Values["action"]}";
    }
}
```

#### Pattern 2: Async Filters for I/O Operations

Always use async filters when performing I/O:

```csharp
public class DatabaseLoggingFilter : IAsyncActionFilter
{
    private readonly ILogger<DatabaseLoggingFilter> _logger;
    private readonly AppDbContext _db;

    public DatabaseLoggingFilter(ILogger<DatabaseLoggingFilter> logger, AppDbContext db)
    {
        _logger = logger;
        _db = db;
    }

    public async Task OnActionExecutionAsync(
        ActionExecutingContext context,
        ActionExecutionDelegate next)
    {
        // Execute action
        var result = await next();

        // Log to database (async operation)
        var log = new ActionLog
        {
            Action = context.ActionDescriptor.DisplayName,
            Timestamp = DateTime.UtcNow,
            Success = result.Exception == null
        };

        _db.ActionLogs.Add(log);
        await _db.SaveChangesAsync();
    }
}
```

### Do's and Don'ts

#### Do's

✅ **Use filters for cross-cutting concerns**
```csharp
// Good: Logging, validation, caching
public class LoggingFilter : IActionFilter { }
```

✅ **Keep filters focused and single-purpose**
```csharp
// Good: One filter = one responsibility
public class ModelValidationFilter : IActionFilter { }
public class LoggingFilter : IActionFilter { }
```

✅ **Use async filters for I/O operations**
```csharp
// Good: Async for database, file, network operations
public class AuditFilter : IAsyncActionFilter
{
    public async Task OnActionExecutionAsync(...)
    {
        await _db.SaveAuditLogAsync();
    }
}
```

✅ **Register filters in DI for testability**
```csharp
// Good: Can inject mocks in tests
builder.Services.AddScoped<MyFilter>();
```

#### Don'ts

❌ **Don't put business logic in filters**
```csharp
// Bad: Business logic belongs in services
public class BusinessLogicFilter : IActionFilter
{
    public void OnActionExecuting(...)
    {
        // Complex business rules here ❌
    }
}
```

❌ **Don't create "God filters" that do everything**
```csharp
// Bad: Too many responsibilities
public class DoEverythingFilter : IActionFilter
{
    // Logging
    // Validation
    // Caching
    // Authorization ❌
}
```

❌ **Don't use blocking code in async filters**
```csharp
// Bad: Blocking in async method
public async Task OnActionExecutionAsync(...)
{
    Thread.Sleep(1000); // ❌ Blocking
    _db.SaveChanges(); // ❌ Sync in async
}
```

### Filter Order and Priority

**Control filter execution order:**

```csharp
[LogFilter(Order = 1)]  // Runs first
[ValidateFilter(Order = 2)]  // Runs second
[CacheFilter(Order = 3)]  // Runs third
public class PokemonController : Controller { }
```

**Global filter order:**

```csharp
builder.Services.AddControllersWithViews(options =>
{
    options.Filters.Add<GlobalFilter1>(order: 1);
    options.Filters.Add<GlobalFilter2>(order: 2);
});
```

---

## 11. Troubleshooting & Common Issues

### Problem 1: Filter Not Executing

**Symptoms:**
- Filter code doesn't run
- No logs from filter

**Causes & Solutions:**

**1. Filter not registered:**
```csharp
// ❌ Forgot to register
[ServiceFilter(typeof(MyFilter))]  // Will fail!

// ✅ Register in DI
builder.Services.AddScoped<MyFilter>();
```

**2. Wrong filter attribute:**
```csharp
// ❌ Used TypeFilter but filter has dependencies
[TypeFilter(typeof(MyFilter))]  // May fail if filter needs ILogger

// ✅ Use ServiceFilter for DI
[ServiceFilter(typeof(MyFilter))]
```

**3. Filter on wrong scope:**
```csharp
// ❌ Applied to wrong controller
[ServiceFilter(typeof(MyFilter))]
public class OtherController : Controller { }

// ✅ Apply to correct controller
[ServiceFilter(typeof(MyFilter))]
public class PokemonController : Controller { }
```

---

### Problem 2: Short-Circuit Not Working

**Symptoms:**
- Action still executes after setting context.Result
- Expected short-circuit doesn't happen

**Cause:**
Not setting Result in correct filter type or stage.

**Solution:**

```csharp
public void OnActionExecuting(ActionExecutingContext context)
{
    if (!isValid)
    {
        // ✅ Set Result to short-circuit
        context.Result = new BadRequestResult();
        // Pipeline stops here
    }
}
```

---

### Problem 3: Filter Runs Multiple Times

**Symptoms:**
- Filter logs appear multiple times
- Logic executes more than expected

**Cause:**
Filter registered at multiple scopes (global, controller, action).

**Solution:**

```csharp
// Check registration:
// ❌ Registered both globally AND on controller
builder.Services.AddControllersWithViews(options =>
{
    options.Filters.Add<MyFilter>();  // Global
});

[ServiceFilter(typeof(MyFilter))]  // Also on controller ❌
public class PokemonController : Controller { }

// ✅ Choose one scope
```

---

## 12. Additional Resources

### Official Documentation

- [Filters in ASP.NET Core](https://learn.microsoft.com/aspnet/core/mvc/controllers/filters)
- [Filter Types](https://learn.microsoft.com/aspnet/core/mvc/controllers/filters#filter-types)
- [Custom Filters](https://learn.microsoft.com/aspnet/core/mvc/controllers/filters#custom-filters)

### Recommended Tutorials

- [Microsoft Learn: Use filters in ASP.NET Core](https://learn.microsoft.com/learn/modules/use-filters-aspnet-core/)
- [Creating Custom Filters](https://learn.microsoft.com/aspnet/core/mvc/controllers/filters#custom-filters)

### Books

- **Pro ASP.NET Core 7** by Adam Freeman - Chapter on Filters
- **ASP.NET Core in Action** by Andrew Lock - Filter Patterns

### Next Steps

After mastering filters, continue with:

1. **Middleware** - Understand how filters differ from middleware
2. **Authorization** - Implement custom authorization policies
3. **Model Binding** - Custom model binders with filters
4. **API Development** - Use filters in Web APIs
5. **Performance Optimization** - Caching strategies with filters

---

## Appendix

### Glossary

**Filter**: Code that runs before/after stages in the request pipeline

**Filter Pipeline**: The ordered sequence of filters that execute for an action

**Short-circuit**: Stopping pipeline execution by setting context.Result

**IActionFilter**: Interface for synchronous action filters

**IAsyncActionFilter**: Interface for asynchronous action filters

**IAuthorizationFilter**: Interface for authorization checks

**IResourceFilter**: Interface for filters that run before/after most of pipeline

**IExceptionFilter**: Interface for handling exceptions

**IResultFilter**: Interface for filters that run before/after result execution

**ServiceFilter**: Attribute that resolves filters from DI

**TypeFilter**: Attribute that creates filter instances with optional DI

**ActionExecutingContext**: Context before action executes

**ActionExecutedContext**: Context after action executes

---

## Filter Types Quick Reference

```csharp
// 1. Authorization Filter
public class MyAuthFilter : IAuthorizationFilter
{
    public void OnAuthorization(AuthorizationFilterContext context) { }
}

// 2. Resource Filter
public class MyResourceFilter : IResourceFilter
{
    public void OnResourceExecuting(ResourceExecutingContext context) { }
    public void OnResourceExecuted(ResourceExecutedContext context) { }
}

// 3. Action Filter
public class MyActionFilter : IActionFilter
{
    public void OnActionExecuting(ActionExecutingContext context) { }
    public void OnActionExecuted(ActionExecutedContext context) { }
}

// 4. Exception Filter
public class MyExceptionFilter : IExceptionFilter
{
    public void OnException(ExceptionContext context) { }
}

// 5. Result Filter
public class MyResultFilter : IResultFilter
{
    public void OnResultExecuting(ResultExecutingContext context) { }
    public void OnResultExecuted(ResultExecutedContext context) { }
}

// Async versions
public class MyAsyncActionFilter : IAsyncActionFilter
{
    public async Task OnActionExecutionAsync(
        ActionExecutingContext context,
        ActionExecutionDelegate next)
    {
        // Before
        await next();
        // After
    }
}
```

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-11-23 | Initial comprehensive documentation for Filters in ASP.NET Core |

---

**Estimated Reading Time**: 50-55 minutes

**Prerequisites**: Controllers (POK-12), MVC basics (POK-22), Dependency Injection (POK-11)

**Related Topics**: Middleware, Authorization, Exception Handling, Model Binding
