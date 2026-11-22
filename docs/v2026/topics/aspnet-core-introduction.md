# Introduction to ASP.NET Core

---
**Technology Version**: ASP.NET Core 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-22
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What is ASP.NET Core?

ASP.NET Core is Microsoft's modern, open-source framework for building web applications, APIs, and microservices. Think of it as a complete toolkit that provides everything you need to create powerful web-based software that runs on any platform.

**Simple analogy**: If building a web application is like constructing a house, ASP.NET Core is your complete construction kit - it provides the foundation, the tools, the blueprints, and even some pre-built components. You just need to put them together according to your needs.

ASP.NET Core is:
- **Cross-platform**: Runs on Windows, macOS, and Linux
- **High-performance**: One of the fastest web frameworks available
- **Modern**: Built with current best practices and patterns
- **Open-source**: Free to use, with community contributions
- **Unified**: One framework for web UI, APIs, and real-time apps

### Why Use ASP.NET Core?

You should use ASP.NET Core when you need:

**Modern Web Development**
- Build RESTful APIs that serve mobile apps, SPAs, or other services
- Create web applications with server-side rendering
- Develop microservices architectures
- Build real-time applications with SignalR

**Performance Requirements**
- Applications that need to handle many concurrent users
- APIs that must respond quickly
- Cloud-native applications where resource efficiency matters

**Cross-Platform Development**
- Deploy the same code on Windows, Linux, or macOS
- Develop on any operating system
- Run in containers (Docker, Kubernetes)

**Enterprise Features**
- Built-in dependency injection
- Comprehensive middleware pipeline
- Configuration management
- Logging and monitoring support

### When to Use It

**Good use cases:**
- Building RESTful APIs for mobile or web applications
- Creating microservices architectures
- Developing cloud-native applications (Azure, AWS, Google Cloud)
- Building enterprise web applications with high performance requirements
- Creating real-time applications (chat, notifications, live dashboards)
- Modernizing existing .NET Framework applications

**Not recommended for:**
- Simple static websites (use static site generators like Hugo, Jekyll)
- Desktop applications (use WPF, WinForms, or MAUI instead)
- Mobile native apps (use Xamarin/MAUI instead, though ASP.NET Core can provide the backend API)
- Very small scripts or utilities (use console applications or PowerShell)

**When to choose ASP.NET Core over other frameworks:**
- You're in the Microsoft/C# ecosystem
- You need excellent performance
- You want strong typing and compile-time safety
- You need to run on multiple platforms
- You want mature tooling and enterprise support

---

## 2. Quick Start

**TL;DR - Get started in 5 minutes:**

```bash
# 1. Install .NET SDK
# Download from: https://dotnet.microsoft.com/download

# 2. Verify installation
dotnet --version
# Should output: 8.0.x or higher

# 3. Create a new Web API project
dotnet new webapi -n MyFirstApi
cd MyFirstApi

# 4. Run the application
dotnet run

# 5. Test it in your browser or terminal
# Navigate to: https://localhost:5001/weatherforecast
# Or use curl:
curl https://localhost:5001/weatherforecast
```

**Expected output:**
```json
[
  {
    "date": "2026-11-23",
    "temperatureC": 10,
    "temperatureF": 49,
    "summary": "Cool"
  },
  ...
]
```

**What just happened?**
- You created a fully functional REST API in seconds
- The app is running on Kestrel (ASP.NET Core's built-in web server)
- It's serving JSON data at an HTTPS endpoint
- It includes automatic API documentation with Swagger

For detailed explanations, continue reading the sections below.

---

## 3. Prerequisites

### Required Knowledge

Before starting with ASP.NET Core, you should understand:

- **C# Basics** - Variables, classes, methods, properties
  - *Why needed*: ASP.NET Core applications are written in C#
  - *Skill level*: Basic understanding is sufficient

- **Object-Oriented Programming** - Classes, inheritance, interfaces
  - *Why needed*: ASP.NET Core uses OOP principles extensively
  - *Skill level*: Understanding of classes and interfaces

- **HTTP Fundamentals** - Request/response, status codes, methods (GET, POST, etc.)
  - *Why needed*: Web applications communicate over HTTP
  - *Skill level*: Basic understanding of how the web works

- **JSON** - Reading and understanding JSON structure
  - *Why needed*: APIs typically use JSON for data exchange
  - *Skill level*: Basic familiarity

### Required Software/Tools

#### Essential
- **.NET SDK** - Version 8.0 or higher
  - Download: https://dotnet.microsoft.com/download
  - Includes runtime, libraries, and command-line tools

#### Code Editor (choose one)
- **Visual Studio 2022** (Windows/Mac)
  - Full-featured IDE with built-in tools
  - Download: https://visualstudio.microsoft.com/

- **Visual Studio Code** (Windows/Mac/Linux)
  - Lightweight, with C# extension
  - Download: https://code.visualstudio.com/
  - Install C# extension: Search "C#" in Extensions

- **JetBrains Rider** (Windows/Mac/Linux)
  - Professional IDE (paid, but powerful)
  - Download: https://www.jetbrains.com/rider/

#### Optional but Recommended
- **Postman** or **Insomnia** - For testing APIs
- **Git** - For version control
- **Docker** - For containerization (advanced)

### System Requirements

- **Operating System**:
  - Windows 10 or higher
  - macOS 11 (Big Sur) or higher
  - Linux (various distributions supported)

- **RAM**: 4GB minimum (8GB recommended for comfortable development)

- **Disk Space**: 2GB for .NET SDK and tools

- **Internet Connection**: Required for downloading packages and documentation

---

## 4. Core Concepts & Theory

### Key Concepts

#### Concept 1: What Makes ASP.NET Core Different?

ASP.NET Core represents a complete redesign of ASP.NET, built from the ground up for modern development:

**Evolution Timeline:**
```
ASP.NET (.NET Framework)     →    ASP.NET Core (.NET Core/6+)
━━━━━━━━━━━━━━━━━━━━━━━━         ━━━━━━━━━━━━━━━━━━━━━━━━━
• Windows only                    • Cross-platform ✅
• Legacy System.Web              • Modern, modular design
• Slower                         • High performance
• Closed source                  • Open source
• Mature but dated               • Modern and evolving
```

#### Concept 2: .NET Core vs .NET Framework

Understanding the difference is crucial:

| Aspect | .NET Framework | .NET Core / .NET 6+ |
|--------|----------------|---------------------|
| **Platform** | Windows only | Windows, macOS, Linux |
| **Open Source** | No | Yes ✅ |
| **Performance** | Good | Excellent (much faster) |
| **Deployment** | Machine-wide installation | Self-contained or framework-dependent |
| **Cloud** | Limited | Optimized for cloud |
| **Active Development** | Maintenance only | Active, new features |
| **Latest Version** | 4.8 (final) | .NET 8 (and growing) |
| **API Development** | ASP.NET Web API | ASP.NET Core Web API |
| **MVC** | ASP.NET MVC | ASP.NET Core MVC |

**Key Decision:**
- **Use .NET Framework** if: You have an existing .NET Framework app that can't be migrated, or you need Windows-specific features (WCF, remoting, etc.)
- **Use ASP.NET Core (.NET 6+)** for: All new development, cross-platform needs, cloud applications, microservices ✅ **Recommended**

**Current Naming Confusion:**
Microsoft unified naming starting with .NET 5:
- .NET Core 3.1 → .NET 5 → .NET 6 → .NET 7 → .NET 8
- Now just called ".NET" (but we often say ".NET Core" to distinguish from .NET Framework)

#### Concept 3: ASP.NET Core Architecture

ASP.NET Core has a layered, modular architecture:

**High-Level Architecture:**

```
┌─────────────────────────────────────────────────────┐
│                   Your Application                   │
│            (Controllers, Services, etc.)            │
└─────────────────┬───────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────┐
│              ASP.NET Core MVC/API                   │
│    (Routing, Model Binding, Controllers, etc.)      │
└─────────────────┬───────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────┐
│            Middleware Pipeline                       │
│   (Authentication, Logging, Error Handling, etc.)   │
└─────────────────┬───────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────┐
│              Kestrel Web Server                      │
│        (Receives HTTP requests/responses)           │
└─────────────────┬───────────────────────────────────┘
                  │
         HTTP Requests/Responses
```

**Key Layers:**

1. **Kestrel**: Built-in, cross-platform web server
2. **Middleware Pipeline**: Processes requests in a chain
3. **MVC/API Framework**: Routes requests to your code
4. **Your Application**: Business logic, controllers, services

#### Concept 4: Kestrel Web Server

**Kestrel** is the web server built into ASP.NET Core.

**What is a web server?**
A web server listens for HTTP requests and sends HTTP responses. Kestrel does this job for ASP.NET Core applications.

**Key features:**
- **Cross-platform**: Works on Windows, macOS, Linux
- **High-performance**: One of the fastest web servers available
- **Built-in**: No external server needed for development
- **Production-ready**: Can be used directly or behind a reverse proxy

**Typical setups:**

**Development:**
```
Your Computer
┌────────────────────────┐
│   Browser              │
│      ↓↑                │
│   Kestrel (port 5001)  │
│      ↓↑                │
│   Your ASP.NET Core App│
└────────────────────────┘
```

**Production (recommended):**
```
Internet
   ↓↑
Reverse Proxy (IIS, Nginx, Apache)
   ↓↑
Kestrel
   ↓↑
Your ASP.NET Core App
```

**Why use a reverse proxy in production?**
- Load balancing
- SSL termination
- Static file serving
- Advanced security features

**But Kestrel can run standalone too!**
```csharp
// This is enough for production in many cases
var app = WebApplication.Create(args);
app.Run(); // Kestrel starts and serves requests
```

#### Concept 5: The Request Pipeline (Middleware)

One of ASP.NET Core's most powerful concepts is the **middleware pipeline**.

**What is middleware?**
Middleware is software that sits between the web server and your application, processing HTTP requests and responses.

**Pipeline visualization:**

```
HTTP Request
     │
     ├─→ [Middleware 1: Logging]
     │        └─→ Log the request
     │
     ├─→ [Middleware 2: Authentication]
     │        └─→ Check if user is logged in
     │
     ├─→ [Middleware 3: Routing]
     │        └─→ Determine which controller to call
     │
     ├─→ [Middleware 4: Your Controller]
     │        └─→ Execute business logic
     │
     ├─→ [Middleware 3: Routing]  ← Response flows back
     │
     ├─→ [Middleware 2: Authentication]
     │
     ├─→ [Middleware 1: Logging]
     │        └─→ Log the response
     │
HTTP Response
```

**Key characteristics:**
- Middleware executes **in order**
- Each middleware can:
  - Process the request and pass it to the next middleware
  - Short-circuit the pipeline (stop processing and return a response)
  - Process the response on the way back
- Order matters! (e.g., authentication must come before authorization)

**Common middleware:**
- **Static Files**: Serves CSS, JS, images
- **Routing**: Matches URLs to controllers
- **Authentication**: Verifies user identity
- **Authorization**: Checks user permissions
- **CORS**: Handles cross-origin requests
- **Error Handling**: Catches exceptions

**Example configuration:**
```csharp
var app = WebApplication.Create(args);

// Order matters!
app.UseHttpsRedirection();  // 1. Redirect HTTP to HTTPS
app.UseStaticFiles();       // 2. Serve static files
app.UseRouting();           // 3. Enable routing
app.UseAuthentication();    // 4. Who are you?
app.UseAuthorization();     // 5. What can you do?
app.MapControllers();       // 6. Route to controllers

app.Run();
```

#### Concept 6: Dependency Injection (DI)

ASP.NET Core has **dependency injection built-in** from day one.

**What is Dependency Injection?**
Instead of creating dependencies yourself, you declare what you need, and the framework provides them.

**Without DI (bad):**
```csharp
public class ProductsController
{
    private readonly ProductService _service;

    public ProductsController()
    {
        // ❌ Tightly coupled - hard to test, hard to change
        _service = new ProductService(new ProductRepository(new DbContext()));
    }
}
```

**With DI (good):**
```csharp
public class ProductsController
{
    private readonly IProductService _service;

    // ✅ Dependencies injected - easy to test, flexible
    public ProductsController(IProductService service)
    {
        _service = service;
    }
}
```

**Service lifetimes:**
- **Transient**: New instance every time (use for lightweight, stateless services)
- **Scoped**: One instance per HTTP request (use for database contexts)
- **Singleton**: One instance for the app lifetime (use for caches, shared state)

We'll cover DI in depth in a later chapter.

#### Concept 7: Configuration System

ASP.NET Core has a flexible, hierarchical configuration system.

**Configuration sources (in order of priority):**
1. Command-line arguments
2. Environment variables
3. User secrets (development only)
4. `appsettings.{Environment}.json`
5. `appsettings.json`

**Example:**
```json
// appsettings.json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  },
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=MyDb;"
  },
  "MySettings": {
    "ApiKey": "default-key",
    "MaxRetries": 3
  }
}
```

**Reading configuration:**
```csharp
// In Program.cs or controllers
var apiKey = builder.Configuration["MySettings:ApiKey"];
var maxRetries = builder.Configuration.GetValue<int>("MySettings:MaxRetries");
```

#### Concept 8: Hosting Model

ASP.NET Core uses a **generic host** that manages:
- Application lifetime
- Dependency injection
- Configuration
- Logging

**Minimal hosting model (ASP.NET Core 6+):**
```csharp
// Program.cs - This is all you need!
var builder = WebApplication.CreateBuilder(args);

// Configure services
builder.Services.AddControllers();

var app = builder.Build();

// Configure middleware pipeline
app.MapControllers();

app.Run(); // Start the application
```

**What's happening behind the scenes:**
1. `WebApplication.CreateBuilder()` sets up hosting, DI, configuration
2. `builder.Services` configures dependency injection
3. `app.Build()` builds the application
4. Middleware configuration happens between Build() and Run()
5. `app.Run()` starts Kestrel and begins listening for requests

---

## 5. Installation Guide

### Step 1: Download .NET SDK

#### Windows

**Option 1: Using the installer (recommended)**
1. Visit https://dotnet.microsoft.com/download
2. Click "Download .NET SDK" (choose version 8.0 or higher)
3. Run the downloaded `.exe` installer
4. Follow the installation wizard (accept defaults)
5. Installation typically takes 2-5 minutes

**Option 2: Using winget (command-line)**
```powershell
# Open PowerShell as Administrator
winget install Microsoft.DotNet.SDK.8
```

**Option 3: Using Chocolatey**
```powershell
choco install dotnet-sdk
```

#### macOS

**Option 1: Using the installer**
1. Visit https://dotnet.microsoft.com/download
2. Download the macOS installer
3. Open the `.pkg` file and follow instructions
4. Enter your password when prompted

**Option 2: Using Homebrew (recommended)**
```bash
# Install Homebrew if you haven't already
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install .NET SDK
brew install --cask dotnet-sdk
```

#### Linux

**Ubuntu/Debian:**
```bash
# Add Microsoft package repository
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Install SDK
sudo apt-get update
sudo apt-get install -y dotnet-sdk-8.0
```

**Fedora/RHEL/CentOS:**
```bash
# Add Microsoft package repository
sudo dnf install https://packages.microsoft.com/config/fedora/37/packages-microsoft-prod.rpm

# Install SDK
sudo dnf install dotnet-sdk-8.0
```

**Other Linux distributions:**
Visit https://learn.microsoft.com/en-us/dotnet/core/install/linux

### Step 2: Verify Installation

Open a terminal/command prompt and run:

```bash
dotnet --version
```

**Expected output:**
```
8.0.100  # Or similar version 8.0.x
```

**Check installed SDKs:**
```bash
dotnet --list-sdks
```

**Expected output:**
```
8.0.100 [C:\Program Files\dotnet\sdk]  # Windows
8.0.100 [/usr/local/share/dotnet/sdk]  # macOS/Linux
```

**If you see an error:**
- Windows: Restart your terminal or computer
- macOS/Linux: Check if `/usr/local/share/dotnet` or `/usr/share/dotnet` is in your PATH
- Try opening a new terminal window

### Step 3: Install IDE/Editor

#### Visual Studio 2022 (Windows/Mac)

1. Download from https://visualstudio.microsoft.com/
2. During installation, select:
   - **ASP.NET and web development** workload ✅
   - **.NET desktop development** (optional)
3. Installation takes 10-30 minutes depending on selections

#### Visual Studio Code (All Platforms)

1. Download from https://code.visualstudio.com/
2. Install VS Code
3. Open VS Code
4. Click Extensions icon (or Ctrl+Shift+X / Cmd+Shift+X)
5. Search for "C#" and install the official C# extension by Microsoft
6. Search for "C# Dev Kit" and install it (optional but recommended)

**Recommended VS Code extensions:**
- C# (Microsoft) - Essential
- C# Dev Kit (Microsoft) - Enhanced features
- REST Client - Test APIs without leaving VS Code
- GitLens - Enhanced Git features

### Step 4: Create Your First Project

```bash
# Navigate to your desired directory
cd ~/projects  # macOS/Linux
cd C:\projects  # Windows

# Create a new Web API project
dotnet new webapi -n MyFirstApi

# Navigate into the project
cd MyFirstApi

# Open in your editor
code .  # VS Code
# or just open with Visual Studio
```

### Step 5: Verify Setup

```bash
# In your project directory
dotnet build

# Expected output:
#   Build succeeded.
#   0 Warning(s)
#   0 Error(s)

# Run the application
dotnet run

# Expected output:
#   info: Microsoft.Hosting.Lifetime[14]
#         Now listening on: https://localhost:5001
#   info: Microsoft.Hosting.Lifetime[0]
#         Application started. Press Ctrl+C to shut down.
```

**Test in browser:**
Navigate to: https://localhost:5001/swagger

You should see the Swagger UI with the WeatherForecast API!

---

## 6. Initial Setup & Configuration

### Understanding the Project Structure

When you create a new Web API project, you get this structure:

```
MyFirstApi/
├── Controllers/
│   └── WeatherForecastController.cs   # Sample API controller
├── Properties/
│   └── launchSettings.json            # Debug settings
├── appsettings.json                   # Configuration
├── appsettings.Development.json       # Dev-specific config
├── Program.cs                         # Application entry point
├── MyFirstApi.csproj                  # Project file
└── WeatherForecast.cs                 # Sample model
```

### Key Files Explained

#### Program.cs - The Heart of Your Application

```csharp
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();

app.Run();
```

**What each part does:**

1. `WebApplication.CreateBuilder(args)`: Creates and configures the host
   - Sets up logging
   - Loads configuration
   - Prepares dependency injection

2. `builder.Services.AddControllers()`: Registers controller services
   - Enables MVC/API controllers
   - Configures JSON serialization
   - Sets up model binding

3. `builder.Services.AddSwaggerGen()`: Adds Swagger/OpenAPI
   - Generates API documentation
   - Provides interactive API testing UI

4. `app.Build()`: Builds the application (creates the DI container)

5. Middleware configuration:
   - `app.UseSwagger()`: Enables Swagger JSON endpoint
   - `app.UseSwaggerUI()`: Enables Swagger UI
   - `app.UseHttpsRedirection()`: Redirects HTTP to HTTPS
   - `app.UseAuthorization()`: Enables authorization checks
   - `app.MapControllers()`: Maps controller routes

6. `app.Run()`: Starts the web server and begins listening

#### appsettings.json - Configuration

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
```

**What it configures:**
- **Logging levels**: Controls how much information is logged
  - `Trace`: Most detailed
  - `Debug`: Debug information
  - `Information`: General flow
  - `Warning`: Unusual events
  - `Error`: Errors that need attention
  - `Critical`: Fatal errors
- **AllowedHosts**: Which hosts can connect (security feature)

**You can add your own settings:**
```json
{
  "Logging": { ... },
  "AllowedHosts": "*",
  "MySettings": {
    "ApiKey": "my-secret-key",
    "MaxItemsPerPage": 50,
    "EnableFeatureX": true
  }
}
```

#### launchSettings.json - Development Settings

```json
{
  "profiles": {
    "http": {
      "commandName": "Project",
      "dotnetRunMessages": true,
      "launchBrowser": true,
      "launchUrl": "swagger",
      "applicationUrl": "http://localhost:5000",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      }
    },
    "https": {
      "commandName": "Project",
      "dotnetRunMessages": true,
      "launchBrowser": true,
      "launchUrl": "swagger",
      "applicationUrl": "https://localhost:5001;http://localhost:5000",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      }
    }
  }
}
```

**What it controls:**
- **applicationUrl**: The URL your app runs on during development
- **launchBrowser**: Whether to open a browser automatically
- **launchUrl**: Which page to open (swagger in this case)
- **ASPNETCORE_ENVIRONMENT**: The environment name (Development, Staging, Production)

### Common Configuration Tasks

#### Change the Port

Edit `launchSettings.json`:
```json
"applicationUrl": "https://localhost:7000;http://localhost:7001"
```

Or use command-line:
```bash
dotnet run --urls "https://localhost:7000"
```

#### Add Environment-Specific Settings

Create `appsettings.Production.json`:
```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Warning"  // Less logging in production
    }
  },
  "MySettings": {
    "ApiKey": "production-key"
  }
}
```

ASP.NET Core automatically loads the right file based on `ASPNETCORE_ENVIRONMENT`.

#### Enable CORS (for frontend apps)

```csharp
// In Program.cs, after var builder = ...
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("http://localhost:4200")  // Your frontend URL
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

// In the middleware pipeline, before MapControllers
app.UseCors();
```

---

## 7. Basic Usage

### Example 1: "Hello World" API

Let's create the simplest possible API endpoint.

**Create a new controller** (`Controllers/HelloController.cs`):

```csharp
using Microsoft.AspNetCore.Mvc;

namespace MyFirstApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class HelloController : ControllerBase
{
    [HttpGet]
    public IActionResult Get()
    {
        return Ok("Hello, World!");
    }
}
```

**Run it:**
```bash
dotnet run
```

**Test it:**
```bash
# Using curl
curl https://localhost:5001/api/hello

# Or open in browser:
# https://localhost:5001/api/hello
```

**Output:**
```
Hello, World!
```

**What's happening:**
1. `[ApiController]`: Marks this as an API controller
2. `[Route("api/[controller]")]`: Sets the base route to `/api/hello`
3. `[HttpGet]`: This method responds to GET requests
4. `Ok("Hello, World!")`: Returns HTTP 200 with the string

### Example 2: Returning JSON Data

```csharp
[HttpGet("json")]
public IActionResult GetJson()
{
    var data = new
    {
        Message = "Hello, JSON!",
        Timestamp = DateTime.UtcNow,
        Status = "Success"
    };

    return Ok(data);
}
```

**Test:**
```bash
curl https://localhost:5001/api/hello/json
```

**Output:**
```json
{
  "message": "Hello, JSON!",
  "timestamp": "2026-11-22T14:30:00Z",
  "status": "Success"
}
```

ASP.NET Core automatically serializes objects to JSON!

### Example 3: Accepting Parameters

#### From Route:
```csharp
[HttpGet("greet/{name}")]
public IActionResult Greet(string name)
{
    return Ok($"Hello, {name}!");
}
```

**Test:**
```bash
curl https://localhost:5001/api/hello/greet/John
# Output: Hello, John!
```

#### From Query String:
```csharp
[HttpGet("search")]
public IActionResult Search([FromQuery] string term, [FromQuery] int page = 1)
{
    return Ok(new {
        SearchTerm = term,
        Page = page,
        Results = new[] { "Result 1", "Result 2" }
    });
}
```

**Test:**
```bash
curl "https://localhost:5001/api/hello/search?term=aspnet&page=2"
```

**Output:**
```json
{
  "searchTerm": "aspnet",
  "page": 2,
  "results": ["Result 1", "Result 2"]
}
```

### Example 4: Accepting POST Data

```csharp
public class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
}

[HttpPost("person")]
public IActionResult CreatePerson([FromBody] Person person)
{
    return Ok(new {
        Message = $"Created person: {person.Name}, age {person.Age}",
        Person = person
    });
}
```

**Test:**
```bash
curl -X POST https://localhost:5001/api/hello/person \
  -H "Content-Type: application/json" \
  -d '{"name":"Alice","age":30}'
```

**Output:**
```json
{
  "message": "Created person: Alice, age 30",
  "person": {
    "name": "Alice",
    "age": 30
  }
}
```

### Example 5: Using Dependency Injection

**Create a service** (`Services/GreetingService.cs`):

```csharp
namespace MyFirstApi.Services;

public interface IGreetingService
{
    string GetGreeting(string name);
}

public class GreetingService : IGreetingService
{
    public string GetGreeting(string name)
    {
        return $"Hello from the service, {name}!";
    }
}
```

**Register the service in Program.cs:**
```csharp
// After var builder = ...
builder.Services.AddScoped<IGreetingService, GreetingService>();
```

**Use it in a controller:**
```csharp
[ApiController]
[Route("api/[controller]")]
public class GreetingController : ControllerBase
{
    private readonly IGreetingService _greetingService;

    // Service injected via constructor
    public GreetingController(IGreetingService greetingService)
    {
        _greetingService = greetingService;
    }

    [HttpGet("{name}")]
    public IActionResult Get(string name)
    {
        var greeting = _greetingService.GetGreeting(name);
        return Ok(greeting);
    }
}
```

**Test:**
```bash
curl https://localhost:5001/api/greeting/World
# Output: Hello from the service, World!
```

---

## 8. Testing & Validation

### Exercise 1: Create Your First API (Beginner)

**Objective:** Create a simple API that returns information about books.

**Requirements:**
1. Create a new controller called `BooksController`
2. Add a GET endpoint that returns a list of book titles
3. The route should be `/api/books`

<details>
<summary>💡 Hint</summary>

- Create a file `Controllers/BooksController.cs`
- Inherit from `ControllerBase`
- Add `[ApiController]` and `[Route("api/[controller]")]`
- Use `[HttpGet]` for the action method
- Return `Ok()` with an array of strings

</details>

<details>
<summary>✅ Solution</summary>

```csharp
using Microsoft.AspNetCore.Mvc;

namespace MyFirstApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class BooksController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll()
    {
        var books = new[]
        {
            "To Kill a Mockingbird",
            "1984",
            "The Great Gatsby",
            "Pride and Prejudice",
            "The Catcher in the Rye"
        };

        return Ok(books);
    }
}
```

**Test it:**
```bash
dotnet run

# In another terminal:
curl https://localhost:5001/api/books
```

**Expected output:**
```json
[
  "To Kill a Mockingbird",
  "1984",
  "The Great Gatsby",
  "Pride and Prejudice",
  "The Catcher in the Rye"
]
```

**Why this works:**
- `[ApiController]` enables automatic API features
- `[Route("api/[controller]")]` creates the route `/api/books`
- `[HttpGet]` makes this respond to GET requests
- `Ok()` returns HTTP 200 with JSON-serialized data
- ASP.NET Core automatically converts the array to JSON

</details>

### Exercise 2: Add Route Parameters (Intermediate)

**Objective:** Extend the Books API to return a specific book by ID.

**Requirements:**
1. Add a new endpoint to `BooksController`
2. Accept an `id` parameter from the route
3. Return a book object with id, title, and author
4. Route should be `/api/books/{id}`

<details>
<summary>💡 Hint</summary>

- Use `[HttpGet("{id}")]`
- Add an `int id` parameter to the method
- Create an anonymous object or a class for the book
- Return `Ok()` with the book data

</details>

<details>
<summary>✅ Solution</summary>

```csharp
// Add this to your BooksController

[HttpGet("{id}")]
public IActionResult GetById(int id)
{
    // Simulate a book database
    var books = new Dictionary<int, object>
    {
        { 1, new { Id = 1, Title = "To Kill a Mockingbird", Author = "Harper Lee", Year = 1960 } },
        { 2, new { Id = 2, Title = "1984", Author = "George Orwell", Year = 1949 } },
        { 3, new { Id = 3, Title = "The Great Gatsby", Author = "F. Scott Fitzgerald", Year = 1925 } }
    };

    if (!books.ContainsKey(id))
    {
        return NotFound(new { Message = $"Book with ID {id} not found" });
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

**Expected outputs:**

Valid ID:
```json
{
  "id": 1,
  "title": "To Kill a Mockingbird",
  "author": "Harper Lee",
  "year": 1960
}
```

Invalid ID (404 Not Found):
```json
{
  "message": "Book with ID 999 not found"
}
```

**Why this works:**
- `{id}` captures the ID from the URL
- The method parameter `int id` automatically receives the value
- `NotFound()` returns HTTP 404 when book doesn't exist
- `Ok()` returns HTTP 200 when book is found

</details>

### Exercise 3: Create a Service with DI (Challenge)

**Objective:** Refactor the Books API to use dependency injection with a service.

**Requirements:**
1. Create a `IBooksService` interface
2. Create a `BooksService` class that implements the interface
3. Register the service in `Program.cs`
4. Inject the service into `BooksController`
5. Use the service to get book data

<details>
<summary>💡 Hint</summary>

- Create a folder `Services/`
- Define interface methods for `GetAll()` and `GetById(int id)`
- Register with `builder.Services.AddScoped<IBooksService, BooksService>()`
- Add constructor to controller with `IBooksService` parameter
- Call service methods in controller actions

</details>

<details>
<summary>✅ Solution</summary>

**Step 1: Create the interface and service** (`Services/IBooksService.cs`):

```csharp
namespace MyFirstApi.Services;

public interface IBooksService
{
    IEnumerable<string> GetAllTitles();
    Book? GetById(int id);
}

public class Book
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Author { get; set; } = string.Empty;
    public int Year { get; set; }
}
```

**Step 2: Implement the service** (`Services/BooksService.cs`):

```csharp
namespace MyFirstApi.Services;

public class BooksService : IBooksService
{
    private readonly List<Book> _books = new()
    {
        new Book { Id = 1, Title = "To Kill a Mockingbird", Author = "Harper Lee", Year = 1960 },
        new Book { Id = 2, Title = "1984", Author = "George Orwell", Year = 1949 },
        new Book { Id = 3, Title = "The Great Gatsby", Author = "F. Scott Fitzgerald", Year = 1925 },
        new Book { Id = 4, Title = "Pride and Prejudice", Author = "Jane Austen", Year = 1813 },
        new Book { Id = 5, Title = "The Catcher in the Rye", Author = "J.D. Salinger", Year = 1951 }
    };

    public IEnumerable<string> GetAllTitles()
    {
        return _books.Select(b => b.Title);
    }

    public Book? GetById(int id)
    {
        return _books.FirstOrDefault(b => b.Id == id);
    }
}
```

**Step 3: Register the service in Program.cs:**

```csharp
using MyFirstApi.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Register the books service
builder.Services.AddScoped<IBooksService, BooksService>();

var app = builder.Build();
// ... rest of the code
```

**Step 4: Update the controller to use DI:**

```csharp
using Microsoft.AspNetCore.Mvc;
using MyFirstApi.Services;

namespace MyFirstApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class BooksController : ControllerBase
{
    private readonly IBooksService _booksService;

    // Service injected via constructor
    public BooksController(IBooksService booksService)
    {
        _booksService = booksService;
    }

    [HttpGet]
    public IActionResult GetAll()
    {
        var titles = _booksService.GetAllTitles();
        return Ok(titles);
    }

    [HttpGet("{id}")]
    public IActionResult GetById(int id)
    {
        var book = _booksService.GetById(id);

        if (book == null)
        {
            return NotFound(new { Message = $"Book with ID {id} not found" });
        }

        return Ok(book);
    }
}
```

**Test it:**
```bash
# Get all books
curl https://localhost:5001/api/books

# Get specific book
curl https://localhost:5001/api/books/2
```

**Why this solution is better:**
- **Separation of concerns**: Business logic is in the service, not the controller
- **Testability**: You can easily mock `IBooksService` for unit tests
- **Reusability**: Other controllers can use the same service
- **Maintainability**: Changes to book logic only affect the service
- **Follows SOLID principles**: Single responsibility, dependency inversion

</details>

### Self-Assessment Checklist

After completing the exercises, verify you can:

- [ ] Install .NET SDK on your operating system
- [ ] Create a new ASP.NET Core Web API project
- [ ] Run the application and access it in a browser
- [ ] Understand the purpose of `Program.cs`
- [ ] Create a simple controller with GET endpoints
- [ ] Use route parameters
- [ ] Return JSON data from an API
- [ ] Create and register a service with dependency injection
- [ ] Inject services into controllers
- [ ] Test APIs using curl or a browser

---

## 9. Practical Examples

### Example 1: Configuration with Options Pattern

**Better way to access configuration:**

**Step 1: Create a settings class** (`AppSettings.cs`):

```csharp
public class AppSettings
{
    public string ApplicationName { get; set; } = string.Empty;
    public int MaxItemsPerPage { get; set; }
    public EmailSettings Email { get; set; } = new();
}

public class EmailSettings
{
    public string SmtpServer { get; set; } = string.Empty;
    public int Port { get; set; }
    public string FromAddress { get; set; } = string.Empty;
}
```

**Step 2: Configure in appsettings.json:**

```json
{
  "AppSettings": {
    "ApplicationName": "MyFirstApi",
    "MaxItemsPerPage": 50,
    "Email": {
      "SmtpServer": "smtp.example.com",
      "Port": 587,
      "FromAddress": "noreply@example.com"
    }
  }
}
```

**Step 3: Register in Program.cs:**

```csharp
builder.Services.Configure<AppSettings>(
    builder.Configuration.GetSection("AppSettings"));
```

**Step 4: Use in a controller:**

```csharp
using Microsoft.Extensions.Options;

[ApiController]
[Route("api/[controller]")]
public class SettingsController : ControllerBase
{
    private readonly AppSettings _settings;

    public SettingsController(IOptions<AppSettings> options)
    {
        _settings = options.Value;
    }

    [HttpGet]
    public IActionResult Get()
    {
        return Ok(new
        {
            AppName = _settings.ApplicationName,
            MaxItems = _settings.MaxItemsPerPage,
            EmailServer = _settings.Email.SmtpServer
        });
    }
}
```

### Example 2: Logging

ASP.NET Core has built-in logging:

```csharp
[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    private readonly ILogger<ProductsController> _logger;

    public ProductsController(ILogger<ProductsController> logger)
    {
        _logger = logger;
    }

    [HttpGet("{id}")]
    public IActionResult GetById(int id)
    {
        _logger.LogInformation("Getting product with ID: {ProductId}", id);

        try
        {
            // Simulate getting a product
            var product = new { Id = id, Name = $"Product {id}" };

            _logger.LogDebug("Found product: {@Product}", product);
            return Ok(product);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting product {ProductId}", id);
            return StatusCode(500, "Internal server error");
        }
    }
}
```

**Output in console:**
```
info: MyFirstApi.Controllers.ProductsController[0]
      Getting product with ID: 5
dbug: MyFirstApi.Controllers.ProductsController[0]
      Found product: {"Id": 5, "Name": "Product 5"}
```

### Example 3: Error Handling Middleware

Create a global error handler:

```csharp
// In Program.cs, early in the middleware pipeline
app.Use(async (context, next) =>
{
    try
    {
        await next();
    }
    catch (Exception ex)
    {
        var logger = context.RequestServices.GetRequiredService<ILogger<Program>>();
        logger.LogError(ex, "Unhandled exception");

        context.Response.StatusCode = 500;
        context.Response.ContentType = "application/json";

        var error = new
        {
            Message = "An error occurred",
            Details = app.Environment.IsDevelopment() ? ex.Message : "Internal server error"
        };

        await context.Response.WriteAsJsonAsync(error);
    }
});
```

### Example 4: Health Checks

Add health check endpoints:

**In Program.cs:**
```csharp
// Add health checks
builder.Services.AddHealthChecks();

// In middleware pipeline
app.MapHealthChecks("/health");
```

**Test:**
```bash
curl https://localhost:5001/health
# Output: Healthy
```

**Add custom health check:**
```csharp
using Microsoft.Extensions.Diagnostics.HealthChecks;

public class DatabaseHealthCheck : IHealthCheck
{
    public Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context,
        CancellationToken cancellationToken = default)
    {
        // Check database connection
        var isDatabaseHealthy = true; // Your check here

        if (isDatabaseHealthy)
        {
            return Task.FromResult(HealthCheckResult.Healthy("Database is healthy"));
        }

        return Task.FromResult(HealthCheckResult.Unhealthy("Database is unhealthy"));
    }
}

// Register it
builder.Services.AddHealthChecks()
    .AddCheck<DatabaseHealthCheck>("database");
```

---

## 10. Common Patterns & Best Practices

### Pattern 1: Organize by Feature

**Instead of organizing by type:**
```
❌ BAD
Controllers/
  ProductsController.cs
  OrdersController.cs
Services/
  ProductService.cs
  OrderService.cs
Models/
  Product.cs
  Order.cs
```

**Organize by feature:**
```
✅ GOOD
Features/
  Products/
    ProductsController.cs
    ProductService.cs
    Product.cs
    IProductRepository.cs
  Orders/
    OrdersController.cs
    OrderService.cs
    Order.cs
    IOrderRepository.cs
```

**Benefits:**
- Related code is together
- Easier to find and maintain
- Better for large applications
- Facilitates microservices architecture

### Pattern 2: Use appsettings for Environment-Specific Config

```json
// appsettings.json (defaults)
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=DevDb;"
  }
}

// appsettings.Production.json (overrides for production)
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=prod-server;Database=ProdDb;"
  }
}
```

### Pattern 3: Minimal API for Simple Endpoints

For very simple APIs, use minimal APIs:

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => "Hello World!");

app.MapGet("/time", () => new
{
    ServerTime = DateTime.UtcNow,
    TimeZone = "UTC"
});

app.MapGet("/weather/{city}", (string city) => new
{
    City = city,
    Temperature = Random.Shared.Next(-10, 40),
    Condition = "Sunny"
});

app.Run();
```

**When to use:**
- Simple APIs with few endpoints
- Microservices with focused functionality
- Quick prototypes

**When not to use:**
- Complex applications
- Many endpoints with shared logic
- Need for controllers organization

### Pattern 4: Use Result Objects

Create consistent result objects:

```csharp
public class ApiResult<T>
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public T? Data { get; set; }
    public List<string> Errors { get; set; } = new();
}

// Usage in controller
[HttpGet("{id}")]
public IActionResult Get(int id)
{
    var product = _service.GetById(id);

    if (product == null)
    {
        return NotFound(new ApiResult<object>
        {
            Success = false,
            Message = "Product not found",
            Errors = new List<string> { $"No product with ID {id}" }
        });
    }

    return Ok(new ApiResult<Product>
    {
        Success = true,
        Message = "Product retrieved successfully",
        Data = product
    });
}
```

### Pattern 5: Use ActionResult<T> for Better Docs

```csharp
// Instead of IActionResult
[HttpGet("{id}")]
public ActionResult<Product> Get(int id)
{
    var product = _service.GetById(id);

    if (product == null)
    {
        return NotFound();
    }

    return product; // Implicit conversion
}
```

**Benefits:**
- Swagger knows the return type
- Better IntelliSense
- Type safety

### Pattern 6: Environment-Based Behavior

```csharp
var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
    app.UseDeveloperExceptionPage();
}
else
{
    app.UseExceptionHandler("/error");
    app.UseHsts();
}

app.Run();
```

---

## 11. Troubleshooting & Common Issues

### Issue 1: "dotnet command not found"

**Symptoms:**
```bash
dotnet --version
# bash: dotnet: command not found
```

**Solutions:**

**Windows:**
1. Restart your terminal/PowerShell
2. If still not working, check PATH:
   - Search "Environment Variables" in Windows
   - Check if `C:\Program Files\dotnet` is in System PATH
   - Add it if missing
3. Restart computer

**macOS/Linux:**
```bash
# Check if dotnet is installed
which dotnet

# If not found, add to PATH in ~/.bashrc or ~/.zshrc
export PATH="$PATH:/usr/local/share/dotnet"

# Reload shell configuration
source ~/.bashrc  # or source ~/.zshrc
```

### Issue 2: Port Already in Use

**Symptoms:**
```
Failed to bind to address https://127.0.0.1:5001: address already in use
```

**Solutions:**

**Option 1: Kill the process using the port**

Windows:
```powershell
# Find process
netstat -ano | findstr :5001
# Kill process (replace PID with actual process ID)
taskkill /PID <PID> /F
```

macOS/Linux:
```bash
# Find process
lsof -i :5001
# Kill process
kill -9 <PID>
```

**Option 2: Use a different port**
```bash
dotnet run --urls "https://localhost:7000;http://localhost:7001"
```

Or edit `launchSettings.json`:
```json
"applicationUrl": "https://localhost:7000;http://localhost:7001"
```

### Issue 3: "Unable to configure HTTPS endpoint"

**Symptoms:**
```
Unable to configure HTTPS endpoint. No server certificate was specified.
```

**Solution: Trust the development certificate**

```bash
dotnet dev-certs https --trust
```

**If that doesn't work:**
```bash
# Clean and recreate
dotnet dev-certs https --clean
dotnet dev-certs https --trust
```

**Restart your IDE/terminal after running these commands.**

### Issue 4: NuGet Package Restore Fails

**Symptoms:**
```
error NU1301: Unable to load the service index for source
```

**Solutions:**

1. **Check internet connection**

2. **Clear NuGet cache:**
```bash
dotnet nuget locals all --clear
```

3. **Restore packages:**
```bash
dotnet restore
```

4. **Check NuGet sources:**
```bash
dotnet nuget list source
```

### Issue 5: Changes Not Reflected

**Symptoms:** Code changes don't appear when you refresh

**Solutions:**

1. **Stop and restart the app** (Ctrl+C, then `dotnet run`)

2. **Clear build cache:**
```bash
dotnet clean
dotnet build
dotnet run
```

3. **Enable hot reload (ASP.NET Core 6+):**
```bash
dotnet watch run
# Now changes reload automatically!
```

### Issue 6: Swagger Not Showing

**Symptoms:** `/swagger` returns 404

**Solutions:**

1. **Check you're in Development mode:**
```bash
# Windows PowerShell
$env:ASPNETCORE_ENVIRONMENT="Development"

# macOS/Linux
export ASPNETCORE_ENVIRONMENT=Development

# Then run
dotnet run
```

2. **Verify Swagger is configured:**
```csharp
// In Program.cs
builder.Services.AddSwaggerGen();  // ✅ Must be present

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();              // ✅ Must be present
    app.UseSwaggerUI();            // ✅ Must be present
}
```

### Debugging Tips

**1. Enable detailed errors:**
```csharp
// In Program.cs (Development only!)
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}
```

**2. Increase logging verbosity:**
```json
// appsettings.Development.json
{
  "Logging": {
    "LogLevel": {
      "Default": "Debug",           // Was "Information"
      "Microsoft.AspNetCore": "Debug"  // Was "Warning"
    }
  }
}
```

**3. Use breakpoints:**
- Visual Studio: Click in left margin or press F9
- VS Code: Click in left margin
- Run with debugger (F5)

**4. Check the console output:**
Most errors are logged to the console when running `dotnet run`

---

## 12. Additional Resources

### Official Documentation
- [ASP.NET Core Documentation](https://learn.microsoft.com/en-us/aspnet/core/)
- [.NET API Browser](https://learn.microsoft.com/en-us/dotnet/api/)
- [What's New in ASP.NET Core 8.0](https://learn.microsoft.com/en-us/aspnet/core/release-notes/aspnetcore-8.0)
- [ASP.NET Core Fundamentals](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/)

### Microsoft Learn Paths
- [Create web APIs with ASP.NET Core](https://learn.microsoft.com/en-us/learn/paths/create-web-api-aspnet-core/)
- [Build web apps with ASP.NET Core for beginners](https://learn.microsoft.com/en-us/learn/paths/aspnet-core-web-app/)
- [ASP.NET Core Learning Resources](https://dotnet.microsoft.com/learn/aspnet)

### Books
- **"ASP.NET Core in Action" by Andrew Lock** - Comprehensive guide for all levels
- **"Pro ASP.NET Core 6" by Adam Freeman** - In-depth coverage
- **"C# 12 and .NET 8 - Modern Cross-Platform Development" by Mark J. Price**

### Video Courses
- [ASP.NET Core Crash Course (YouTube)](https://www.youtube.com/results?search_query=asp.net+core+crash+course)
- [.NET YouTube Channel](https://www.youtube.com/dotnet)
- [Pluralsight - ASP.NET Core Path](https://www.pluralsight.com/paths/aspnet-core)

### Community & Support
- [Stack Overflow - ASP.NET Core](https://stackoverflow.com/questions/tagged/asp.net-core)
- [.NET GitHub Repository](https://github.com/dotnet/aspnetcore)
- [r/dotnet subreddit](https://reddit.com/r/dotnet)
- [.NET Discord Community](https://discord.gg/dotnet)

### Tools & Extensions
- [.NET CLI Documentation](https://learn.microsoft.com/en-us/dotnet/core/tools/)
- [Postman](https://www.postman.com/) - API testing
- [Swagger/OpenAPI](https://swagger.io/)
- [Docker for .NET](https://learn.microsoft.com/en-us/dotnet/core/docker/introduction)

### Blogs & Weekly Updates
- [.NET Blog](https://devblogs.microsoft.com/dotnet/)
- [ASP.NET Blog](https://devblogs.microsoft.com/aspnet/)
- [.NET Weekly](https://www.dotnetweekly.com/)
- [Andrew Lock's Blog](https://andrewlock.net/)

### Next Steps in Your Learning Journey

After mastering ASP.NET Core Introduction, continue with:

1. **Controllers and Routing** ✅ (Already documented - see `controllers-and-routing.md`)
   - Deep dive into routing patterns
   - RESTful API design
   - Action methods and responses

2. **Entity Framework Core Fundamentals**
   - Connect to databases
   - Define models and relationships
   - Query and update data

3. **Dependency Injection in Detail**
   - Service lifetimes explained
   - Advanced DI scenarios
   - Testing with DI

4. **Data Transfer Objects (DTOs)**
   - API contracts
   - Mapping strategies
   - AutoMapper

5. **Model Validation**
   - Data annotations
   - Custom validation
   - Fluent validation

6. **Authentication & Authorization**
   - Identity framework
   - JWT tokens
   - Role-based access

---

## Summary

Congratulations! You've completed the Introduction to ASP.NET Core. Let's recap what you've learned:

### Key Takeaways

✅ **What ASP.NET Core Is**
- Modern, cross-platform framework for web development
- Built on .NET 6+, successor to ASP.NET (.NET Framework)
- High-performance, open-source, and cloud-ready

✅ **.NET Core vs .NET Framework**
- .NET Framework: Windows-only, maintenance mode
- ASP.NET Core: Cross-platform, actively developed, recommended for new projects

✅ **Core Architecture Components**
- **Kestrel**: Built-in, cross-platform web server
- **Middleware Pipeline**: Chain of components processing requests/responses
- **Dependency Injection**: Built-in DI container for loose coupling
- **Configuration System**: Flexible, hierarchical configuration

✅ **Getting Started**
- Install .NET SDK for your platform
- Use `dotnet new webapi` to create projects
- Use `dotnet run` to start applications
- Test with Swagger UI or curl

✅ **Practical Skills**
- Create API controllers
- Use dependency injection
- Configure services and middleware
- Access configuration
- Implement logging
- Handle errors
- Create services and inject them

✅ **Best Practices**
- Organize code by feature
- Use environment-specific configuration
- Implement proper logging
- Use ActionResult<T> for type safety
- Follow RESTful conventions

### What Makes ASP.NET Core Powerful

1. **Performance**: Benchmarks consistently show ASP.NET Core as one of the fastest frameworks
2. **Productivity**: Rapid development with minimal boilerplate
3. **Flexibility**: Can build APIs, web apps, microservices, real-time apps
4. **Modern**: Built with current best practices (DI, async/await, middleware)
5. **Ecosystem**: Huge community, extensive libraries, Microsoft support

### Your Next Steps

You're now ready to:
- Build RESTful APIs with confidence
- Understand how ASP.NET Core applications work
- Configure and customize applications
- Use dependency injection effectively
- Deploy applications to production

**Continue your learning with the next topics in the documentation series!**

---

**Estimated Reading Time:** 60 minutes ⏱️

**Document Complete** ✅
