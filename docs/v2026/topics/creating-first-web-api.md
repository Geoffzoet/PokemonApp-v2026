# Creating Your First Web API Project

---
**Technology Version**: ASP.NET Core 8.0+
**Document Version**: 1.0
**Last Updated**: 2026-11-22
**Author**: PokemonApp Team
**Target Audience**: Beginners
**Estimated Reading Time**: 60-90 minutes
---

## 1. Overview & Introduction

### What is ASP.NET Core Web API?

ASP.NET Core Web API is a framework for building HTTP-based services that can be accessed by clients like web browsers, mobile apps, desktop applications, and other services. Think of it as a way to create a backend service that speaks JSON and responds to web requests.

A Web API is essentially a collection of endpoints (URLs) that clients can call to retrieve or send data. For example, a Pokemon API might have endpoints like:
- `GET /api/pokemon` - Get all Pokemon
- `GET /api/pokemon/25` - Get Pikachu (ID 25)
- `POST /api/pokemon` - Create a new Pokemon

Unlike traditional web applications that return HTML pages, Web APIs return data (usually JSON) that client applications can use however they want.

### Why Use ASP.NET Core Web API?

You should use ASP.NET Core Web API when:

- **Building modern web applications** - Separate your backend (API) from your frontend (React, Angular, Vue)
- **Creating mobile app backends** - iOS and Android apps need APIs to fetch data
- **Connecting different systems** - APIs allow different applications to communicate
- **Building microservices** - Break large applications into smaller, independent services
- **Supporting multiple clients** - One API can serve web, mobile, desktop, and IoT clients

**Key benefits:**
- **Cross-platform**: Runs on Windows, macOS, and Linux
- **High performance**: One of the fastest web frameworks available
- **Modern**: Built-in support for async/await, dependency injection, and middleware
- **Flexible**: Returns JSON by default, but supports XML and other formats
- **Well-documented**: Extensive Microsoft documentation and community support

### When to Use It

**Good use cases:**
- Building a RESTful API for a web or mobile application
- Creating backend services for single-page applications (SPAs)
- Developing microservices architecture
- Building data services consumed by multiple clients
- Creating webhooks or integration endpoints

**Not recommended for:**
- Simple websites with traditional page navigation (use ASP.NET Core MVC instead)
- Real-time applications requiring constant connections (consider SignalR for WebSockets)
- Static websites with no backend logic (use static site generators)

---

## 2. Quick Start

**TL;DR - Get your first API running in 5 minutes:**

```bash
# 1. Create a new Web API project
dotnet new webapi -n PokemonApi

# 2. Navigate to the project
cd PokemonApi

# 3. Run the application
dotnet run

# 4. Open your browser
# Navigate to: https://localhost:7xxx/swagger (port will be shown in terminal)
```

**Expected output in terminal:**
```
Building...
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: https://localhost:7001
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5000
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
```

**What you'll see in browser:**
A Swagger UI page displaying your API documentation with a sample WeatherForecast endpoint you can test immediately.

**[Screenshot Placeholder: Swagger UI with WeatherForecast endpoint]**

For detailed explanations, continue reading the sections below.

---

## 3. Prerequisites

### Required Knowledge

Before starting, you should have:

- **Basic programming concepts** - Variables, loops, functions, classes (in any language)
- **Command line basics** - How to navigate directories and run commands
- **JSON format** - Understanding of JSON structure (see our [JSON Data Format guide](json-data-format.md))
- **HTTP basics** - Understanding what a URL is and how browsers make requests (helpful but not required)

Don't worry if you're new to C# or .NET - we'll explain everything as we go!

### Required Software/Tools

You need to install:

- **.NET SDK 8.0 or higher**
  - Download: [https://dotnet.microsoft.com/download](https://dotnet.microsoft.com/download)
  - Includes the `dotnet` command-line tool and C# compiler
  - Verify installation: `dotnet --version`

- **Code Editor or IDE** (choose one):
  - **Visual Studio Code** (Free, lightweight, cross-platform) - Recommended for beginners
    - Download: [https://code.visualstudio.com/](https://code.visualstudio.com/)
    - Install C# extension: Search "C# Dev Kit" in extensions
  - **Visual Studio 2022** (Free Community Edition, Windows/Mac)
    - Download: [https://visualstudio.microsoft.com/](https://visualstudio.microsoft.com/)
  - **JetBrains Rider** (Paid, excellent for professionals)
    - Download: [https://www.jetbrains.com/rider/](https://www.jetbrains.com/rider/)

- **API Testing Tool** (optional but recommended):
  - **Postman** (Free, user-friendly GUI)
    - Download: [https://www.postman.com/downloads/](https://www.postman.com/downloads/)
  - Or use browser/curl commands (we'll show both methods)

### System Requirements

- **Operating System**: Windows 10+, macOS 11+, or Linux (Ubuntu 20.04+, Debian 11+, etc.)
- **RAM**: 4GB minimum, 8GB+ recommended
- **Disk Space**: 2GB for .NET SDK and tools
- **Internet Connection**: For downloading packages and tools

---

## 4. Core Concepts & Theory

Before we build our first API, let's understand the key concepts.

### Key Concepts

#### Concept 1: HTTP and RESTful APIs

HTTP (Hypertext Transfer Protocol) is how clients and servers communicate on the web. When you visit a website, your browser makes HTTP requests to a server, which sends back HTTP responses.

**HTTP Methods (Verbs):**
- **GET** - Retrieve data (e.g., get a Pokemon)
- **POST** - Create new data (e.g., add a new Pokemon)
- **PUT** - Update existing data (e.g., update Pokemon level)
- **DELETE** - Remove data (e.g., delete a Pokemon)

**REST (Representational State Transfer)** is a design pattern for APIs that uses these HTTP methods in a predictable way.

**Example RESTful API design:**
```
GET    /api/pokemon         → Get all Pokemon
GET    /api/pokemon/25      → Get Pokemon with ID 25
POST   /api/pokemon         → Create a new Pokemon
PUT    /api/pokemon/25      → Update Pokemon with ID 25
DELETE /api/pokemon/25      → Delete Pokemon with ID 25
```

#### Concept 2: Controllers

Controllers are classes that handle incoming HTTP requests. They contain methods (called **action methods** or **endpoints**) that respond to specific URLs.

**Simple analogy:** Think of a controller as a receptionist at a hotel. When someone (a client) asks for something (makes a request), the receptionist (controller) processes the request and provides a response.

**Example:**
```csharp
[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    [HttpGet]  // Responds to GET /api/pokemon
    public IActionResult GetAllPokemon()
    {
        return Ok(new { message = "List of Pokemon" });
    }
}
```

#### Concept 3: Endpoints and Routing

An **endpoint** is a URL that clients can call to trigger specific functionality. **Routing** is the system that maps URLs to controller actions.

**Route template:** `[Route("api/[controller]")]`
- `api` - Prefix for all API routes
- `[controller]` - Placeholder for controller name without "Controller" suffix
- Example: `PokemonController` → `/api/pokemon`

**Example with route parameters:**
```csharp
[HttpGet("{id}")]  // /api/pokemon/25
public IActionResult GetPokemon(int id)
{
    return Ok(new { id = id, name = "Pikachu" });
}
```

#### Concept 4: Middleware Pipeline

Middleware are components that process HTTP requests and responses in a pipeline. Each middleware can:
1. Process the incoming request
2. Pass it to the next middleware
3. Process the outgoing response

**Visual representation:**
```
Client Request
      ↓
[Middleware 1: Logging]
      ↓
[Middleware 2: Authentication]
      ↓
[Middleware 3: Routing]
      ↓
[Controller Action]
      ↓
[Response]
      ↓
Back through middleware
      ↓
Client Response
```

Common middleware:
- **Routing** - Maps URLs to controllers
- **Authentication** - Verifies user identity
- **CORS** - Allows cross-origin requests
- **Static Files** - Serves images, CSS, JavaScript
- **Exception Handling** - Catches errors gracefully

#### Concept 5: Dependency Injection (DI)

Dependency Injection is a pattern where objects receive their dependencies from external sources rather than creating them internally. ASP.NET Core has built-in DI.

**Simple analogy:** Instead of a chef growing their own vegetables (creating dependencies), the restaurant provides them (injects dependencies).

**Example:**
```csharp
// Register service in Program.cs
builder.Services.AddScoped<IPokemonService, PokemonService>();

// Controller receives it via constructor
public class PokemonController : ControllerBase
{
    private readonly IPokemonService _pokemonService;

    public PokemonController(IPokemonService pokemonService)
    {
        _pokemonService = pokemonService;  // Injected by DI container
    }
}
```

### Important Terminology

| Term | Definition |
|------|------------|
| **API** | Application Programming Interface - a way for programs to communicate |
| **Endpoint** | A specific URL that accepts HTTP requests and returns responses |
| **Controller** | A class that groups related endpoints together |
| **Action Method** | A method in a controller that handles a specific HTTP request |
| **Route** | The URL pattern that maps to a controller action |
| **Middleware** | Software components that process HTTP requests in a pipeline |
| **JSON** | JavaScript Object Notation - the most common data format for APIs |
| **Swagger/OpenAPI** | Tools for documenting and testing APIs |
| **Status Code** | HTTP codes indicating request success or failure (200, 404, 500, etc.) |

### Architecture Overview

**High-level Web API architecture:**

```
┌─────────────────────────────────────────────────┐
│  Client (Browser, Mobile App, etc.)             │
└───────────────┬─────────────────────────────────┘
                │
                │ HTTP Request (JSON)
                ▼
┌─────────────────────────────────────────────────┐
│  ASP.NET Core Web API                           │
│                                                  │
│  ┌────────────────────────────────────────┐    │
│  │  Middleware Pipeline                    │    │
│  │  - Routing                              │    │
│  │  - Authentication                       │    │
│  │  - Exception Handling                   │    │
│  └───────────┬────────────────────────────┘    │
│              │                                   │
│              ▼                                   │
│  ┌────────────────────────────────────────┐    │
│  │  Controller                             │    │
│  │  - Receives HTTP request                │    │
│  │  - Validates input                      │    │
│  │  - Calls business logic                 │    │
│  └───────────┬────────────────────────────┘    │
│              │                                   │
│              ▼                                   │
│  ┌────────────────────────────────────────┐    │
│  │  Service Layer (Business Logic)         │    │
│  └───────────┬────────────────────────────┘    │
│              │                                   │
│              ▼                                   │
│  ┌────────────────────────────────────────┐    │
│  │  Data Access / Database                 │    │
│  └────────────────────────────────────────┘    │
│                                                  │
└───────────────┬─────────────────────────────────┘
                │
                │ HTTP Response (JSON)
                ▼
┌─────────────────────────────────────────────────┐
│  Client receives response                        │
└─────────────────────────────────────────────────┘
```

---

## 5. Installation Guide

### Step 1: Verify .NET SDK Installation

First, check if .NET is installed:

```bash
dotnet --version
```

**Expected output:**
```
8.0.100
```

If you see a version number (8.0 or higher), you're good to go! If not, download and install the .NET SDK from [https://dotnet.microsoft.com/download](https://dotnet.microsoft.com/download).

### Step 2: Choose Your Workspace

Create a folder for your projects:

**Windows (PowerShell):**
```powershell
mkdir C:\Projects\PokemonApp
cd C:\Projects\PokemonApp
```

**macOS/Linux:**
```bash
mkdir ~/Projects/PokemonApp
cd ~/Projects/PokemonApp
```

### Step 3: Create Your First Web API Project

Use the `dotnet new webapi` command to create a new Web API project:

```bash
dotnet new webapi -n PokemonApi
```

**What this does:**
- `dotnet new` - Creates a new project from a template
- `webapi` - Specifies the Web API template
- `-n PokemonApi` - Names the project "PokemonApi"

**Expected output:**
```
The template "ASP.NET Core Web API" was created successfully.

Processing post-creation actions...
Restoring C:\Projects\PokemonApp\PokemonApi\PokemonApi.csproj:
  Determining projects to restore...
  Restored C:\Projects\PokemonApp\PokemonApi\PokemonApi.csproj (in 2.5 sec).
Restore succeeded.
```

**[Screenshot Placeholder: Terminal showing successful project creation]**

### Step 4: Navigate to Project Directory

```bash
cd PokemonApi
```

### Step 5: Verify Project Structure

List the files created:

**Windows:**
```powershell
dir
```

**macOS/Linux:**
```bash
ls -la
```

You should see:
```
PokemonApi.csproj           # Project file
Program.cs                  # Main application entry point
appsettings.json           # Configuration file
appsettings.Development.json
Properties/
  launchSettings.json      # Development settings
Controllers/
  WeatherForecastController.cs  # Sample controller
WeatherForecast.cs         # Sample model
```

### Alternative: Creating Project with Visual Studio

If you prefer using Visual Studio:

1. Open Visual Studio 2022
2. Click "Create a new project"
3. Search for "ASP.NET Core Web API"
4. Click "Next"
5. Enter project name: "PokemonApi"
6. Choose location
7. Click "Next"
8. Select ".NET 8.0" (or latest version)
9. Leave "Use controllers" checked
10. Click "Create"

**[Screenshot Placeholder: Visual Studio new project dialog]**

### Verify Installation

Run the project to verify everything works:

```bash
dotnet run
```

**Expected output:**
```
Building...
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: https://localhost:7001
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5000
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
```

Open your browser and navigate to: `https://localhost:7001/swagger`

You should see the Swagger UI with the WeatherForecast API!

**[Screenshot Placeholder: Swagger UI displaying WeatherForecast endpoints]**

Press `Ctrl+C` in the terminal to stop the application.

---

## 6. Initial Setup & Configuration

### Understanding Project Structure

Let's explore the files and folders created:

```
PokemonApi/
├── Controllers/                # Where controllers live
│   └── WeatherForecastController.cs
├── Properties/
│   └── launchSettings.json    # Development environment settings
├── appsettings.json           # Application configuration
├── appsettings.Development.json  # Development-specific config
├── Program.cs                 # Application entry point and configuration
├── PokemonApi.csproj          # Project file (dependencies, build settings)
└── WeatherForecast.cs         # Sample model class
```

### Configuration Files Explained

#### 1. `PokemonApi.csproj` - Project File

This XML file defines your project settings and dependencies.

**Contents:**
```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Swashbuckle.AspNetCore" Version="6.5.0" />
  </ItemGroup>
</Project>
```

**Key settings:**
- `TargetFramework` - Which .NET version to use
- `Nullable` - Enables nullable reference types (helps prevent null errors)
- `ImplicitUsings` - Automatically includes common using statements
- `PackageReference` - NuGet packages your project depends on

#### 2. `appsettings.json` - Application Configuration

Stores application-wide settings like database connections, API keys, etc.

**Default contents:**
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

**Configuration options:**

| Setting | Type | Description |
|---------|------|-------------|
| `Logging:LogLevel:Default` | string | Default log level (Trace, Debug, Information, Warning, Error, Critical) |
| `Logging:LogLevel:Microsoft.AspNetCore` | string | Log level for ASP.NET Core framework messages |
| `AllowedHosts` | string | Which domains can access the API (`"*"` = all) |

**Example with custom settings:**
```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "AppSettings": {
    "ApplicationName": "Pokemon API",
    "MaxResultsPerPage": 20
  }
}
```

#### 3. `launchSettings.json` - Development Environment Settings

Located in `Properties/launchSettings.json`, this file controls how the app runs during development.

**Key sections:**
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
      "applicationUrl": "https://localhost:7001;http://localhost:5000",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      }
    }
  }
}
```

**Important settings:**

| Setting | Description |
|---------|-------------|
| `launchBrowser` | Automatically open browser when app starts |
| `launchUrl` | URL to open (default: "swagger") |
| `applicationUrl` | Ports the app listens on |
| `ASPNETCORE_ENVIRONMENT` | Environment name (Development, Staging, Production) |

### Essential Settings for Beginners

For now, the default settings work perfectly! You don't need to change anything yet. Here's when you might modify these files:

**`appsettings.json`** - Modify when:
- Adding database connection strings
- Storing API keys or external service URLs
- Changing logging levels
- Adding custom application settings

**`launchSettings.json`** - Modify when:
- Changing default ports (if 5000/7001 are taken)
- Disabling automatic browser launch
- Changing the startup URL

### Environment-Specific Configuration

ASP.NET Core supports multiple environments:
- **Development** - Local development (uses `appsettings.Development.json`)
- **Staging** - Pre-production testing
- **Production** - Live application

Settings in `appsettings.Development.json` override `appsettings.json` during development.

**Example:**
```json
// appsettings.Development.json
{
  "Logging": {
    "LogLevel": {
      "Default": "Debug"  // More verbose logging in development
    }
  }
}
```

---

## 7. Basic Usage

### Understanding Program.cs

`Program.cs` is the heart of your application. Let's understand it line by line.

**Default Program.cs:**
```csharp
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
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

**Line-by-line explanation:**

```csharp
var builder = WebApplication.CreateBuilder(args);
```
Creates a builder for configuring services and the app. Think of this as setting up the foundation.

```csharp
builder.Services.AddControllers();
```
Registers controller services so ASP.NET Core knows to use controllers for handling requests.

```csharp
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
```
Enables Swagger/OpenAPI documentation. This creates the interactive API documentation page.

```csharp
var app = builder.Build();
```
Builds the application with all configured services. After this line, you configure middleware.

```csharp
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
```
Enables Swagger UI only in development environment (not in production for security).

```csharp
app.UseHttpsRedirection();
```
Middleware that redirects HTTP requests to HTTPS for security.

```csharp
app.UseAuthorization();
```
Middleware that checks if users are authorized to access endpoints (we'll use this later).

```csharp
app.MapControllers();
```
Maps controller routes - tells ASP.NET Core to look for `[ApiController]` classes.

```csharp
app.Run();
```
Starts the application and begins listening for HTTP requests.

### Understanding the Sample Controller

Open `Controllers/WeatherForecastController.cs`:

```csharp
using Microsoft.AspNetCore.Mvc;

namespace PokemonApi.Controllers;

[ApiController]
[Route("[controller]")]
public class WeatherForecastController : ControllerBase
{
    private static readonly string[] Summaries = new[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild",
        "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

    private readonly ILogger<WeatherForecastController> _logger;

    public WeatherForecastController(ILogger<WeatherForecastController> logger)
    {
        _logger = logger;
    }

    [HttpGet(Name = "GetWeatherForecast")]
    public IEnumerable<WeatherForecast> Get()
    {
        return Enumerable.Range(1, 5).Select(index => new WeatherForecast
        {
            Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            TemperatureC = Random.Shared.Next(-20, 55),
            Summary = Summaries[Random.Shared.Next(Summaries.Length)]
        })
        .ToArray();
    }
}
```

**Breaking it down:**

```csharp
[ApiController]
```
Marks this as an API controller. Enables automatic model validation, binding, and API-specific behavior.

```csharp
[Route("[controller]")]
```
Sets the route template. `[controller]` is replaced with "WeatherForecast", so the route is `/weatherforecast`.

```csharp
public class WeatherForecastController : ControllerBase
```
Inherits from `ControllerBase` which provides methods like `Ok()`, `NotFound()`, `BadRequest()`.

```csharp
public WeatherForecastController(ILogger<WeatherForecastController> logger)
{
    _logger = logger;
}
```
Constructor injection - receives an `ILogger` from the DI container for logging.

```csharp
[HttpGet(Name = "GetWeatherForecast")]
public IEnumerable<WeatherForecast> Get()
```
Action method that responds to GET requests at `/weatherforecast`. Returns a collection of weather forecasts.

### Running Your Application

#### Method 1: Using dotnet CLI (Command Line)

**Run the application:**
```bash
dotnet run
```

**Run with hot reload (auto-restart on code changes):**
```bash
dotnet watch run
```

**Run on specific port:**
```bash
dotnet run --urls "https://localhost:5001"
```

**Build without running:**
```bash
dotnet build
```

#### Method 2: Using Visual Studio Code

1. Open the project folder in VS Code
2. Press `F5` or click "Run" → "Start Debugging"
3. VS Code will build and run the project
4. Browser opens automatically to Swagger UI

**[Screenshot Placeholder: VS Code debug panel]**

#### Method 3: Using Visual Studio

1. Open `PokemonApi.sln`
2. Press `F5` or click the green "Play" button
3. Visual Studio builds and launches the app
4. Browser opens automatically

#### Method 4: Using JetBrains Rider

1. Open the project
2. Click the green "Run" button or press `Shift+F10`
3. Rider builds and runs the application

### Testing Your API

#### Method 1: Using Swagger UI (Easiest for Beginners)

1. Run your application
2. Navigate to `https://localhost:7001/swagger`
3. Click on `GET /WeatherForecast`
4. Click "Try it out"
5. Click "Execute"
6. See the response below!

**[Screenshot Placeholder: Swagger UI with response]**

#### Method 2: Using Browser

Simply navigate to:
```
https://localhost:7001/weatherforecast
```

You'll see JSON response directly in the browser!

**Expected response:**
```json
[
  {
    "date": "2026-11-23",
    "temperatureC": 32,
    "temperatureF": 89,
    "summary": "Warm"
  },
  {
    "date": "2026-11-24",
    "temperatureC": -5,
    "temperatureF": 24,
    "summary": "Chilly"
  }
]
```

#### Method 3: Using curl (Command Line)

```bash
curl https://localhost:7001/weatherforecast
```

**On Windows PowerShell, use:**
```powershell
Invoke-WebRequest -Uri https://localhost:7001/weatherforecast | Select-Object -Expand Content
```

#### Method 4: Using Postman

1. Open Postman
2. Create a new request
3. Set method to `GET`
4. Enter URL: `https://localhost:7001/weatherforecast`
5. Click "Send"
6. View response in the bottom panel

**[Screenshot Placeholder: Postman showing GET request]**

### Stopping Your Application

**In terminal:** Press `Ctrl+C`

**In Visual Studio/VS Code/Rider:** Click the "Stop" button or close the debug console

---

## 8. Testing & Validation

### How to Test Your Code

Let's verify your API works correctly using multiple methods.

#### Manual Testing with Swagger

**Test the WeatherForecast endpoint:**

1. Run your application: `dotnet run`
2. Open Swagger: `https://localhost:7001/swagger`
3. Expand `GET /WeatherForecast`
4. Click "Try it out"
5. Click "Execute"

**Expected behavior:**
- Status code: `200 OK`
- Response body contains array of 5 weather objects
- Each object has: `date`, `temperatureC`, `temperatureF`, `summary`

**[Screenshot Placeholder: Successful Swagger test]**

#### Testing with Multiple Requests

**Test 1: Verify JSON format**
Make a request and verify the response is valid JSON with correct structure.

**Test 2: Check response status**
```bash
curl -i https://localhost:7001/weatherforecast
```
Look for `HTTP/1.1 200 OK` in the response headers.

**Test 3: Verify HTTPS redirect**
```bash
curl -i http://localhost:5000/weatherforecast
```
Should see `307 Temporary Redirect` to HTTPS version.

### Common Validation Checks

**Check 1: Application starts successfully**
```bash
dotnet run
```
Expected: See "Now listening on..." messages without errors.

**Check 2: Swagger UI loads**
Navigate to `https://localhost:7001/swagger`
Expected: See interactive API documentation.

**Check 3: API responds to requests**
```bash
curl https://localhost:7001/weatherforecast
```
Expected: Receive JSON array with weather data.

**Check 4: Build succeeds without warnings**
```bash
dotnet build
```
Expected: "Build succeeded. 0 Warning(s), 0 Error(s)"

### Hands-On Exercises

Now it's your turn! Complete these exercises to practice what you've learned.

---

#### Exercise 1: Create a Simple Pokemon Endpoint (Beginner Level)

**Objective:** Create your first controller with a simple GET endpoint that returns hardcoded Pokemon data.

**Task:**
Create a new controller called `PokemonController` that returns a list of three Pokemon names.

**Requirements:**
- Controller file named `PokemonController.cs` in the `Controllers/` folder
- Route: `GET /api/pokemon`
- Returns an array of three Pokemon names as strings
- Use the `[ApiController]` and `[Route]` attributes

**Hints:**
- Look at `WeatherForecastController.cs` as a reference
- Use `[Route("api/[controller]")]` for the route
- Return type can be `IEnumerable<string>` or `string[]`
- Use `return new string[] { ... }` to return an array

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Create `Controllers/PokemonController.cs`:**
```csharp
using Microsoft.AspNetCore.Mvc;

namespace PokemonApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    [HttpGet]
    public IEnumerable<string> GetAll()
    {
        return new string[]
        {
            "Pikachu",
            "Charizard",
            "Bulbasaur"
        };
    }
}
```

**Step 2: Run the application:**
```bash
dotnet run
```

**Step 3: Test in Swagger:**
- Navigate to `https://localhost:7001/swagger`
- Find `GET /api/Pokemon`
- Click "Try it out" → "Execute"
- You should see: `["Pikachu", "Charizard", "Bulbasaur"]`

**Step 4: Test in browser:**
- Navigate to `https://localhost:7001/api/pokemon`
- You should see the JSON array

**Explanation:**
- `[Route("api/[controller]")]` creates the route `/api/pokemon`
- `[HttpGet]` makes this method respond to GET requests
- Returning `IEnumerable<string>` automatically serializes to JSON array
- ASP.NET Core handles all the JSON conversion for you!

</details>

---

#### Exercise 2: Return Structured Pokemon Data (Intermediate Level)

**Objective:** Create a Pokemon model class and return structured data instead of just strings.

**Task:**
1. Create a `Pokemon` model class with properties: `Id`, `Name`, `Type`
2. Modify your `PokemonController` to return a list of `Pokemon` objects
3. Add a second endpoint that returns a single Pokemon by ID

**Requirements:**
- Create `Models/Pokemon.cs` file
- Pokemon class has: `int Id`, `string Name`, `string Type` properties
- `GET /api/pokemon` returns array of Pokemon objects
- `GET /api/pokemon/{id}` returns a single Pokemon
- Return `NotFound()` if Pokemon ID doesn't exist

**Hints:**
- Create a `Models` folder in your project root
- Use `[HttpGet("{id}")]` for the route parameter
- Use LINQ `.FirstOrDefault()` to find a Pokemon by ID
- Check if result is `null` to return `NotFound()`

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Create `Models/Pokemon.cs`:**
```csharp
namespace PokemonApi.Models;

public class Pokemon
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Type { get; set; } = string.Empty;
}
```

**Step 2: Update `Controllers/PokemonController.cs`:**
```csharp
using Microsoft.AspNetCore.Mvc;
using PokemonApi.Models;

namespace PokemonApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    // Static list to simulate a database
    private static readonly List<Pokemon> _pokemon = new()
    {
        new Pokemon { Id = 1, Name = "Bulbasaur", Type = "Grass" },
        new Pokemon { Id = 4, Name = "Charmander", Type = "Fire" },
        new Pokemon { Id = 7, Name = "Squirtle", Type = "Water" },
        new Pokemon { Id = 25, Name = "Pikachu", Type = "Electric" }
    };

    [HttpGet]
    public ActionResult<IEnumerable<Pokemon>> GetAll()
    {
        return Ok(_pokemon);
    }

    [HttpGet("{id}")]
    public ActionResult<Pokemon> GetById(int id)
    {
        var pokemon = _pokemon.FirstOrDefault(p => p.Id == id);

        if (pokemon == null)
        {
            return NotFound(new { message = $"Pokemon with ID {id} not found" });
        }

        return Ok(pokemon);
    }
}
```

**Step 3: Test the endpoints:**

Test `GET /api/pokemon`:
```bash
curl https://localhost:7001/api/pokemon
```

Expected response:
```json
[
  { "id": 1, "name": "Bulbasaur", "type": "Grass" },
  { "id": 4, "name": "Charmander", "type": "Fire" },
  { "id": 7, "name": "Squirtle", "type": "Water" },
  { "id": 25, "name": "Pikachu", "type": "Electric" }
]
```

Test `GET /api/pokemon/25`:
```bash
curl https://localhost:7001/api/pokemon/25
```

Expected response:
```json
{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric"
}
```

Test with invalid ID:
```bash
curl https://localhost:7001/api/pokemon/999
```

Expected response (404):
```json
{
  "message": "Pokemon with ID 999 not found"
}
```

**Explanation:**
- `ActionResult<T>` allows returning both the object and status codes
- `Ok()` returns HTTP 200 with the data
- `NotFound()` returns HTTP 404
- `FirstOrDefault()` returns null if no match found
- Static `_pokemon` list simulates a database (temporary, resets when app restarts)

</details>

---

#### Exercise 3: Add POST Endpoint to Create Pokemon (Challenge Level)

**Objective:** Implement a POST endpoint that accepts JSON and adds a new Pokemon to the list.

**Task:**
Add functionality to create new Pokemon via POST request.

**Requirements:**
- Route: `POST /api/pokemon`
- Accepts a Pokemon object in the request body (JSON)
- Automatically assigns the next available ID
- Returns the created Pokemon with `201 Created` status
- Validates that Name and Type are not empty

**Bonus Challenges:**
- Add validation to prevent duplicate names
- Return `400 Bad Request` if Name or Type is missing
- Include a `Location` header pointing to the new Pokemon's GET endpoint

**Hints:**
- Use `[HttpPost]` attribute
- Parameter should have `[FromBody]` attribute (optional in newer versions)
- Use `CreatedAtAction()` to return 201 status with location
- Use `ModelState.IsValid` for validation or manual checks

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Updated `Controllers/PokemonController.cs`:**
```csharp
using Microsoft.AspNetCore.Mvc;
using PokemonApi.Models;

namespace PokemonApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    // Static list to simulate a database
    private static readonly List<Pokemon> _pokemon = new()
    {
        new Pokemon { Id = 1, Name = "Bulbasaur", Type = "Grass" },
        new Pokemon { Id = 4, Name = "Charmander", Type = "Fire" },
        new Pokemon { Id = 7, Name = "Squirtle", Type = "Water" },
        new Pokemon { Id = 25, Name = "Pikachu", Type = "Electric" }
    };

    [HttpGet]
    public ActionResult<IEnumerable<Pokemon>> GetAll()
    {
        return Ok(_pokemon);
    }

    [HttpGet("{id}")]
    public ActionResult<Pokemon> GetById(int id)
    {
        var pokemon = _pokemon.FirstOrDefault(p => p.Id == id);

        if (pokemon == null)
        {
            return NotFound(new { message = $"Pokemon with ID {id} not found" });
        }

        return Ok(pokemon);
    }

    [HttpPost]
    public ActionResult<Pokemon> Create([FromBody] Pokemon newPokemon)
    {
        // Validation: Check if Name and Type are provided
        if (string.IsNullOrWhiteSpace(newPokemon.Name) ||
            string.IsNullOrWhiteSpace(newPokemon.Type))
        {
            return BadRequest(new { message = "Name and Type are required" });
        }

        // Validation: Check for duplicate names
        if (_pokemon.Any(p => p.Name.Equals(newPokemon.Name, StringComparison.OrdinalIgnoreCase)))
        {
            return BadRequest(new { message = $"Pokemon with name '{newPokemon.Name}' already exists" });
        }

        // Assign next available ID
        newPokemon.Id = _pokemon.Any() ? _pokemon.Max(p => p.Id) + 1 : 1;

        // Add to list
        _pokemon.Add(newPokemon);

        // Return 201 Created with location header
        return CreatedAtAction(
            nameof(GetById),
            new { id = newPokemon.Id },
            newPokemon
        );
    }
}
```

**Testing with curl:**

Create a new Pokemon:
```bash
curl -X POST https://localhost:7001/api/pokemon \
  -H "Content-Type: application/json" \
  -d '{"name":"Eevee","type":"Normal"}'
```

**Windows PowerShell:**
```powershell
$body = @{
    name = "Eevee"
    type = "Normal"
} | ConvertTo-Json

Invoke-WebRequest -Uri https://localhost:7001/api/pokemon `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body $body
```

Expected response (201 Created):
```json
{
  "id": 26,
  "name": "Eevee",
  "type": "Normal"
}
```

**Testing with Postman:**
1. Set method to `POST`
2. URL: `https://localhost:7001/api/pokemon`
3. Go to "Body" tab
4. Select "raw" and "JSON"
5. Enter:
```json
{
  "name": "Eevee",
  "type": "Normal"
}
```
6. Click "Send"

**Verify it was added:**
```bash
curl https://localhost:7001/api/pokemon
```

You should see Eevee in the list!

**Test validation - empty name:**
```bash
curl -X POST https://localhost:7001/api/pokemon \
  -H "Content-Type: application/json" \
  -d '{"name":"","type":"Fire"}'
```

Expected response (400 Bad Request):
```json
{
  "message": "Name and Type are required"
}
```

**Test validation - duplicate name:**
```bash
curl -X POST https://localhost:7001/api/pokemon \
  -H "Content-Type: application/json" \
  -d '{"name":"Pikachu","type":"Electric"}'
```

Expected response (400 Bad Request):
```json
{
  "message": "Pokemon with name 'Pikachu' already exists"
}
```

**Explanation:**
- `[HttpPost]` makes this method respond to POST requests
- `[FromBody]` tells ASP.NET Core to deserialize JSON from request body
- Validation checks prevent bad data
- `CreatedAtAction()` returns 201 with `Location` header pointing to `GetById`
- The `Location` header will be: `https://localhost:7001/api/pokemon/26`

</details>

---

### Comprehension Questions

Test your understanding!

**Question 1:** What is the difference between a Controller and an Endpoint?
<details>
<summary>Answer</summary>

A **Controller** is a class that groups related endpoints together. An **Endpoint** is a specific URL and HTTP method combination that performs an action.

Example:
- `PokemonController` is a controller
- `GET /api/pokemon` is an endpoint
- `GET /api/pokemon/{id}` is another endpoint
- Both endpoints belong to the `PokemonController`

Think of a controller as a chapter in a book, and endpoints as individual pages in that chapter.
</details>

**Question 2:** Why do we return `ActionResult<T>` instead of just `T` from controller actions?
<details>
<summary>Answer</summary>

`ActionResult<T>` allows you to return either:
1. The actual object (`T`) with an HTTP status code
2. A status code result without data (like `NotFound()`, `BadRequest()`)

Example:
```csharp
public ActionResult<Pokemon> GetById(int id)
{
    var pokemon = _pokemon.FirstOrDefault(p => p.Id == id);

    if (pokemon == null)
        return NotFound();  // Returns 404

    return Ok(pokemon);     // Returns 200 with Pokemon data
}
```

If you return just `Pokemon`, you can't return `NotFound()` or other status codes.
</details>

**Question 3:** What does the `[ApiController]` attribute do?
<details>
<summary>Answer</summary>

The `[ApiController]` attribute enables several API-specific behaviors:

1. **Automatic model validation** - Returns 400 Bad Request if model validation fails
2. **Binding source inference** - Automatically knows to bind from body, route, or query string
3. **Problem details for errors** - Returns standardized error responses
4. **Required attribute routing** - Forces all actions to use routing attributes

Without this attribute, you'd need to manually check `ModelState.IsValid` and handle validation yourself.
</details>

**Question 4:** What happens if you don't specify an HTTP method attribute like `[HttpGet]`?
<details>
<summary>Answer</summary>

The action method won't be accessible via HTTP requests. The endpoint won't be registered with the routing system.

You **must** use attributes like `[HttpGet]`, `[HttpPost]`, `[HttpPut]`, or `[HttpDelete]` to specify which HTTP methods the action responds to.

If you forget the attribute, navigating to the route will return `404 Not Found` because ASP.NET Core doesn't know that method is an endpoint.
</details>

**Question 5:** Why does the sample project include Swagger, and should you remove it in production?
<details>
<summary>Answer</summary>

**Why Swagger is included:**
- Provides interactive API documentation
- Lets you test endpoints directly in the browser
- Automatically generates documentation from your code
- Helps developers understand your API

**Should you remove it in production?**
Generally, yes! The default template only enables Swagger in Development environment:
```csharp
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
```

This is for security - you don't want to expose all your API endpoints and their parameters to the public in production.

However, some companies do expose Swagger in production for public APIs (like Stripe, Twitter API docs), but with authentication required.
</details>

### Self-Assessment Checklist

After completing this section, you should be able to:

- [ ] Explain what ASP.NET Core Web API is and why it's used
- [ ] Create a new Web API project using `dotnet new webapi`
- [ ] Understand the purpose of Program.cs and how the middleware pipeline works
- [ ] Create a controller with multiple endpoints
- [ ] Use routing attributes like `[Route]` and `[HttpGet]`
- [ ] Return different status codes (`Ok`, `NotFound`, `BadRequest`)
- [ ] Test APIs using Swagger, browser, curl, and Postman
- [ ] Read and understand controller code written by others
- [ ] Find and use the official Microsoft documentation
- [ ] Debug common issues like port conflicts and routing errors

**If you can't check all these boxes:**
- Review the sections where you're struggling
- Complete the exercises again
- Try creating a different controller (e.g., `TrainerController`)
- Ask for help in the community resources listed in Section 12

### Debugging Tips

If something doesn't work:

1. **Check the error message in terminal** - ASP.NET Core gives detailed error messages
2. **Verify the application is running** - Look for "Now listening on..." messages
3. **Check the port number** - Make sure you're using the correct port (shown in terminal)
4. **Clear browser cache** - Sometimes old API responses are cached
5. **Restart the application** - Press `Ctrl+C` and run `dotnet run` again

**Common debugging workflow:**
```
1. Read the error message carefully
2. Check if the route is correct (/api/pokemon, not /pokemon)
3. Verify HTTP method matches (GET vs POST)
4. Check Swagger UI to see registered endpoints
5. Look at Program.cs to ensure MapControllers() is called
6. Search for the error message online
7. Ask for help with specific error details
```

---

## 9. Practical Examples

Let's build real-world scenarios with progressive complexity.

### Example 1: Simple Health Check Endpoint (Beginner)

**Scenario:**
Every production API needs a health check endpoint that monitoring systems can ping to verify the API is running.

**Code:**

Create `Controllers/HealthController.cs`:
```csharp
using Microsoft.AspNetCore.Mvc;

namespace PokemonApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class HealthController : ControllerBase
{
    [HttpGet]
    public IActionResult GetHealth()
    {
        return Ok(new
        {
            status = "healthy",
            timestamp = DateTime.UtcNow,
            service = "Pokemon API"
        });
    }
}
```

**Walkthrough:**
1. This creates a simple endpoint at `GET /api/health`
2. Returns an anonymous object with status, timestamp, and service name
3. Anonymous objects are automatically serialized to JSON
4. Returns 200 OK status code

**Try it yourself:**
- Add a `version` property to the response
- Add a `uptime` property showing how long the API has been running (hint: track start time in a static variable)
- Create a separate endpoint `GET /api/health/detailed` with more information

**Expected response:**
```json
{
  "status": "healthy",
  "timestamp": "2026-11-22T14:30:00Z",
  "service": "Pokemon API"
}
```

---

### Example 2: Pokemon Search with Query Parameters (Intermediate)

**Scenario:**
Users want to search Pokemon by type or filter by name. We'll add query parameter support.

**Code:**

Update `PokemonController`:
```csharp
[HttpGet("search")]
public ActionResult<IEnumerable<Pokemon>> Search(
    [FromQuery] string? type = null,
    [FromQuery] string? name = null)
{
    var results = _pokemon.AsEnumerable();

    // Filter by type if provided
    if (!string.IsNullOrWhiteSpace(type))
    {
        results = results.Where(p =>
            p.Type.Equals(type, StringComparison.OrdinalIgnoreCase));
    }

    // Filter by name if provided (partial match)
    if (!string.IsNullOrWhiteSpace(name))
    {
        results = results.Where(p =>
            p.Name.Contains(name, StringComparison.OrdinalIgnoreCase));
    }

    var pokemonList = results.ToList();

    if (!pokemonList.Any())
    {
        return NotFound(new { message = "No Pokemon found matching the criteria" });
    }

    return Ok(pokemonList);
}
```

**Walkthrough:**
1. `[HttpGet("search")]` creates route `/api/pokemon/search`
2. `[FromQuery]` binds parameters from URL query string
3. Parameters are nullable (`string?`) and have default values
4. LINQ `.Where()` filters the collection
5. `StringComparison.OrdinalIgnoreCase` makes search case-insensitive
6. Returns 404 if no matches found

**Testing:**

Search by type:
```bash
curl "https://localhost:7001/api/pokemon/search?type=Fire"
```

Search by name:
```bash
curl "https://localhost:7001/api/pokemon/search?name=char"
```

Combine both:
```bash
curl "https://localhost:7001/api/pokemon/search?type=Fire&name=char"
```

**Expected responses:**

Type=Fire:
```json
[
  { "id": 4, "name": "Charmander", "type": "Fire" }
]
```

Name=char:
```json
[
  { "id": 4, "name": "Charmander", "type": "Fire" },
  { "id": 6, "name": "Charizard", "type": "Fire" }
]
```

**Key takeaways:**
- Query parameters make APIs flexible
- Use `[FromQuery]` to bind URL parameters
- LINQ makes filtering easy and readable
- Always handle empty results gracefully

---

### Example 3: Pagination for Large Lists (Advanced)

**Scenario:**
When you have thousands of Pokemon, returning all at once is slow and wastes bandwidth. Implement pagination.

**Code:**

Create a pagination helper class `Models/PagedResult.cs`:
```csharp
namespace PokemonApi.Models;

public class PagedResult<T>
{
    public int PageNumber { get; set; }
    public int PageSize { get; set; }
    public int TotalCount { get; set; }
    public int TotalPages { get; set; }
    public List<T> Data { get; set; } = new();
    public bool HasPreviousPage => PageNumber > 1;
    public bool HasNextPage => PageNumber < TotalPages;
}
```

Add pagination endpoint to `PokemonController`:
```csharp
[HttpGet("paged")]
public ActionResult<PagedResult<Pokemon>> GetPaged(
    [FromQuery] int pageNumber = 1,
    [FromQuery] int pageSize = 10)
{
    // Validation
    if (pageNumber < 1)
    {
        return BadRequest(new { message = "Page number must be greater than 0" });
    }

    if (pageSize < 1 || pageSize > 100)
    {
        return BadRequest(new { message = "Page size must be between 1 and 100" });
    }

    // Get total count
    var totalCount = _pokemon.Count;

    // Calculate total pages
    var totalPages = (int)Math.Ceiling(totalCount / (double)pageSize);

    // Get page data
    var pagedData = _pokemon
        .Skip((pageNumber - 1) * pageSize)
        .Take(pageSize)
        .ToList();

    var result = new PagedResult<Pokemon>
    {
        PageNumber = pageNumber,
        PageSize = pageSize,
        TotalCount = totalCount,
        TotalPages = totalPages,
        Data = pagedData
    };

    return Ok(result);
}
```

**Walkthrough:**
1. `PagedResult<T>` is a generic wrapper for paginated data
2. Validates page number and size
3. `Skip()` skips items from previous pages
4. `Take()` takes only the requested page size
5. Calculates total pages for navigation
6. Includes metadata for building pagination UI

**Testing:**

Get first page (2 items per page):
```bash
curl "https://localhost:7001/api/pokemon/paged?pageNumber=1&pageSize=2"
```

Expected response:
```json
{
  "pageNumber": 1,
  "pageSize": 2,
  "totalCount": 4,
  "totalPages": 2,
  "data": [
    { "id": 1, "name": "Bulbasaur", "type": "Grass" },
    { "id": 4, "name": "Charmander", "type": "Fire" }
  ],
  "hasPreviousPage": false,
  "hasNextPage": true
}
```

Get second page:
```bash
curl "https://localhost:7001/api/pokemon/paged?pageNumber=2&pageSize=2"
```

**Key takeaways:**
- Pagination improves performance for large datasets
- Include metadata to help clients build navigation
- Validate input to prevent abuse (e.g., pageSize=1000000)
- Use `Skip()` and `Take()` for LINQ pagination

---

### Example 4: Adding Logging

**Scenario:**
Add logging to track API usage and debug issues.

**Code:**

Update `PokemonController` to use logging:
```csharp
using Microsoft.AspNetCore.Mvc;
using PokemonApi.Models;

namespace PokemonApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    private readonly ILogger<PokemonController> _logger;

    private static readonly List<Pokemon> _pokemon = new()
    {
        new Pokemon { Id = 1, Name = "Bulbasaur", Type = "Grass" },
        new Pokemon { Id = 4, Name = "Charmander", Type = "Fire" },
        new Pokemon { Id = 7, Name = "Squirtle", Type = "Water" },
        new Pokemon { Id = 25, Name = "Pikachu", Type = "Electric" }
    };

    public PokemonController(ILogger<PokemonController> logger)
    {
        _logger = logger;
    }

    [HttpGet]
    public ActionResult<IEnumerable<Pokemon>> GetAll()
    {
        _logger.LogInformation("Getting all Pokemon. Total count: {Count}", _pokemon.Count);
        return Ok(_pokemon);
    }

    [HttpGet("{id}")]
    public ActionResult<Pokemon> GetById(int id)
    {
        _logger.LogInformation("Getting Pokemon by ID: {PokemonId}", id);

        var pokemon = _pokemon.FirstOrDefault(p => p.Id == id);

        if (pokemon == null)
        {
            _logger.LogWarning("Pokemon with ID {PokemonId} not found", id);
            return NotFound(new { message = $"Pokemon with ID {id} not found" });
        }

        _logger.LogInformation("Found Pokemon: {PokemonName}", pokemon.Name);
        return Ok(pokemon);
    }

    [HttpPost]
    public ActionResult<Pokemon> Create([FromBody] Pokemon newPokemon)
    {
        _logger.LogInformation("Creating new Pokemon: {PokemonName}", newPokemon.Name);

        if (string.IsNullOrWhiteSpace(newPokemon.Name) ||
            string.IsNullOrWhiteSpace(newPokemon.Type))
        {
            _logger.LogWarning("Create Pokemon failed: Name or Type missing");
            return BadRequest(new { message = "Name and Type are required" });
        }

        newPokemon.Id = _pokemon.Any() ? _pokemon.Max(p => p.Id) + 1 : 1;
        _pokemon.Add(newPokemon);

        _logger.LogInformation("Pokemon created successfully: {PokemonId} - {PokemonName}",
            newPokemon.Id, newPokemon.Name);

        return CreatedAtAction(nameof(GetById), new { id = newPokemon.Id }, newPokemon);
    }
}
```

**What you'll see in terminal:**
```
info: PokemonApi.Controllers.PokemonController[0]
      Getting all Pokemon. Total count: 4
info: PokemonApi.Controllers.PokemonController[0]
      Getting Pokemon by ID: 25
info: PokemonApi.Controllers.PokemonController[0]
      Found Pokemon: Pikachu
warn: PokemonApi.Controllers.PokemonController[0]
      Pokemon with ID 999 not found
```

**Log levels:**
- `LogTrace` - Very detailed, usually disabled
- `LogDebug` - Debugging information
- `LogInformation` - General informational messages
- `LogWarning` - Unexpected but recoverable issues
- `LogError` - Errors and exceptions
- `LogCritical` - Critical failures

**Key takeaways:**
- Logging helps debug production issues
- Use structured logging with parameters: `{PokemonId}`
- Choose appropriate log levels
- ILogger is provided by dependency injection

---

## 10. Common Patterns & Best Practices

### Recommended Patterns

#### Pattern 1: Repository Pattern (Preview)

**Description:**
Separates data access logic from business logic. Controllers call repositories instead of directly accessing data.

**When to use:**
- Working with databases (Entity Framework Core)
- Need to swap data sources (SQL Server → MongoDB)
- Want to unit test controllers without a database

**Simple example structure:**
```csharp
// Interface
public interface IPokemonRepository
{
    Task<List<Pokemon>> GetAllAsync();
    Task<Pokemon?> GetByIdAsync(int id);
    Task<Pokemon> CreateAsync(Pokemon pokemon);
}

// Implementation
public class PokemonRepository : IPokemonRepository
{
    private readonly DbContext _context;

    public async Task<List<Pokemon>> GetAllAsync()
    {
        return await _context.Pokemon.ToListAsync();
    }
    // ... other methods
}

// Controller uses the interface
public class PokemonController : ControllerBase
{
    private readonly IPokemonRepository _repository;

    public PokemonController(IPokemonRepository repository)
    {
        _repository = repository;
    }
}
```

**Why this is good:**
- Controllers are simpler and focused on HTTP concerns
- Easy to test (mock the repository)
- Data access logic is reusable
- Can switch databases without changing controllers

#### Pattern 2: DTO (Data Transfer Object) Pattern

**Description:**
Create separate classes for API requests/responses instead of exposing database models directly.

**When to use:**
- Database models have sensitive fields (passwords, internal IDs)
- API shape differs from database structure
- Need different validation rules for create vs update

**Example:**
```csharp
// Database model (internal)
public class Pokemon
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }
    public DateTime CreatedAt { get; set; }
    public string InternalNotes { get; set; }  // Don't expose via API!
}

// API response DTO (what clients see)
public class PokemonDto
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }
}

// API create request DTO
public class CreatePokemonRequest
{
    [Required]
    [StringLength(50)]
    public string Name { get; set; }

    [Required]
    public string Type { get; set; }
}
```

**Why this is good:**
- Controls exactly what data is exposed
- Prevents over-posting attacks
- API can evolve independently from database
- Clear separation of concerns

### Do's and Don'ts

#### Do's

- ✅ **Do use async/await for I/O operations** - Improves scalability
  ```csharp
  public async Task<ActionResult<Pokemon>> GetById(int id)
  {
      var pokemon = await _repository.GetByIdAsync(id);
      return Ok(pokemon);
  }
  ```

- ✅ **Do return appropriate HTTP status codes** - Makes API predictable
  - 200 OK - Success
  - 201 Created - Resource created
  - 204 No Content - Success with no body
  - 400 Bad Request - Invalid input
  - 404 Not Found - Resource doesn't exist
  - 500 Internal Server Error - Server error

- ✅ **Do validate input** - Prevent bad data from entering your system
  ```csharp
  if (string.IsNullOrWhiteSpace(pokemon.Name))
  {
      return BadRequest("Name is required");
  }
  ```

- ✅ **Do use dependency injection** - Makes code testable and maintainable
  ```csharp
  public PokemonController(IPokemonService service)
  {
      _service = service;
  }
  ```

- ✅ **Do version your API** - Allows breaking changes without breaking clients
  ```csharp
  [Route("api/v1/[controller]")]
  public class PokemonController : ControllerBase
  ```

- ✅ **Do log important events** - Helps debug production issues
  ```csharp
  _logger.LogInformation("Pokemon created: {Id}", pokemon.Id);
  ```

#### Don'ts

- ❌ **Don't return domain models directly** - Use DTOs instead
  - **Instead:** Create separate response models

- ❌ **Don't put business logic in controllers** - Controllers should be thin
  - **Instead:** Move logic to service classes
  ```csharp
  // Bad
  [HttpGet("{id}")]
  public ActionResult<Pokemon> GetById(int id)
  {
      // Complex business logic here...
  }

  // Good
  [HttpGet("{id}")]
  public ActionResult<Pokemon> GetById(int id)
  {
      return Ok(_service.GetById(id));  // Service handles logic
  }
  ```

- ❌ **Don't use blocking calls** - Blocks threads and reduces scalability
  - **Instead:** Use async/await
  ```csharp
  // Bad
  var pokemon = _repository.GetById(id).Result;

  // Good
  var pokemon = await _repository.GetByIdAsync(id);
  ```

- ❌ **Don't expose Swagger in production** - Security risk
  - **Instead:** Keep the `if (app.Environment.IsDevelopment())` check

- ❌ **Don't return generic "Internal Server Error" messages** - Not helpful
  - **Instead:** Log the error and return a user-friendly message
  ```csharp
  try
  {
      return Ok(await _service.GetPokemonAsync(id));
  }
  catch (Exception ex)
  {
      _logger.LogError(ex, "Error getting Pokemon {Id}", id);
      return StatusCode(500, "An error occurred while processing your request");
  }
  ```

### Code Organization

**Recommended project structure:**
```
PokemonApi/
├── Controllers/           # HTTP request handlers
│   ├── PokemonController.cs
│   └── TrainerController.cs
├── Models/               # Data models
│   ├── Pokemon.cs
│   ├── Trainer.cs
│   └── DTOs/            # API request/response models
│       ├── PokemonDto.cs
│       └── CreatePokemonRequest.cs
├── Services/            # Business logic
│   ├── IPokemonService.cs
│   └── PokemonService.cs
├── Repositories/        # Data access
│   ├── IPokemonRepository.cs
│   └── PokemonRepository.cs
├── Data/               # Database context
│   └── PokemonDbContext.cs
├── Middleware/         # Custom middleware
│   └── ErrorHandlingMiddleware.cs
├── appsettings.json
└── Program.cs
```

### Performance Considerations

**Performance tips:**

1. **Use async/await for database and HTTP calls** - Frees up threads
2. **Implement pagination** - Don't return huge lists
3. **Use caching for frequently accessed data** - Reduces database load
4. **Enable response compression** - Reduces bandwidth
   ```csharp
   builder.Services.AddResponseCompression();
   ```
5. **Use minimal APIs for simple endpoints** - Less overhead than controllers

**Common performance pitfalls:**
- **N+1 queries** - Load related data in one query using `.Include()`
- **Synchronous I/O** - Always use async methods for I/O
- **Missing indexes** - Ensure database tables are properly indexed
- **Over-fetching data** - Only select fields you need

---

## 11. Troubleshooting & Common Issues

### Frequently Encountered Problems

#### Problem 1: "Port already in use" Error

**Symptoms:**
```
Unhandled exception. System.IO.IOException: Failed to bind to address https://127.0.0.1:7001: address already in use.
```

**Cause:**
Another application is using port 7001 or 5000, or a previous instance of your app is still running.

**Solution:**

**Option 1: Stop the other application**
```bash
# Windows - Find process using port
netstat -ano | findstr :7001
# Kill process (replace PID with actual process ID)
taskkill /PID <PID> /F

# macOS/Linux - Find and kill process
lsof -ti:7001 | xargs kill -9
```

**Option 2: Change the port in `launchSettings.json`**
```json
"applicationUrl": "https://localhost:7002;http://localhost:5001"
```

**Option 3: Run with custom port**
```bash
dotnet run --urls "https://localhost:8000"
```

---

#### Problem 2: 404 Not Found on Valid Endpoint

**Symptoms:**
- Navigate to `/api/pokemon`
- Receive 404 Not Found
- Controller exists and has `[Route]` attribute

**Cause:**
Common causes:
1. Missing `[HttpGet]`, `[HttpPost]`, etc. attribute
2. Route template doesn't match URL
3. Forgot to call `app.MapControllers()` in Program.cs
4. Controller not in `Controllers` namespace or folder

**Solution:**

**Check 1: Verify HTTP method attribute**
```csharp
[HttpGet]  // <-- Make sure this is present!
public IActionResult GetAll()
{
    return Ok(_pokemon);
}
```

**Check 2: Verify Program.cs has MapControllers**
```csharp
app.MapControllers();  // Required!
app.Run();
```

**Check 3: Check route template**
```csharp
[ApiController]
[Route("api/[controller]")]  // Creates /api/pokemon
public class PokemonController : ControllerBase
```

**Check 4: Look at Swagger UI**
Navigate to `/swagger` to see all registered endpoints. If your endpoint isn't listed, the route isn't registered.

---

#### Problem 3: JSON Deserialization Fails (400 Bad Request)

**Symptoms:**
```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
  "title": "One or more validation errors occurred.",
  "status": 400,
  "errors": {
    "$": ["The JSON value could not be converted to PokemonApi.Models.Pokemon."]
  }
}
```

**Cause:**
JSON in request body doesn't match the model structure, has incorrect property names, or has type mismatches.

**Solution:**

**Check 1: Verify JSON structure matches model**

Model:
```csharp
public class Pokemon
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }
}
```

Correct JSON:
```json
{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric"
}
```

**Check 2: Property names are case-sensitive (by default)**

Wrong:
```json
{
  "ID": 25,
  "NAME": "Pikachu"
}
```

**Fix:** Use correct casing or enable case-insensitive deserialization in Program.cs:
```csharp
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.PropertyNameCaseInsensitive = true;
    });
```

**Check 3: Type mismatches**

Wrong (Id is string, should be int):
```json
{
  "id": "twenty-five",
  "name": "Pikachu",
  "type": "Electric"
}
```

---

#### Problem 4: Swagger UI Not Loading

**Symptoms:**
- Navigate to `/swagger`
- Receive 404 or blank page

**Cause:**
Swagger is only enabled in Development environment by default.

**Solution:**

**Check 1: Verify ASPNETCORE_ENVIRONMENT**
```bash
# Windows PowerShell
$env:ASPNETCORE_ENVIRONMENT

# macOS/Linux
echo $ASPNETCORE_ENVIRONMENT
```

Should return "Development". If not:
```bash
# Windows PowerShell
$env:ASPNETCORE_ENVIRONMENT="Development"

# macOS/Linux
export ASPNETCORE_ENVIRONMENT=Development
```

**Check 2: Verify Swagger is added in Program.cs**
```csharp
builder.Services.AddSwaggerGen();  // Required

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
```

**Check 3: Try the full URL**
Navigate to: `https://localhost:7001/swagger/index.html`

---

#### Problem 5: HTTPS Certificate Errors

**Symptoms:**
```
The SSL connection could not be established
Your connection is not private
```

**Cause:**
Development HTTPS certificate is not trusted.

**Solution:**

**Trust the development certificate:**
```bash
dotnet dev-certs https --trust
```

**Windows:** Click "Yes" when prompted to install certificate

**macOS:** Enter your password to add certificate to Keychain

**Linux:** May need to manually trust the certificate or use HTTP during development

**Alternative:** Use HTTP instead during development:
```bash
dotnet run --urls "http://localhost:5000"
```

Navigate to `http://localhost:5000/swagger` (note: HTTP, not HTTPS)

---

### Error Messages Explained

| Error Message | Meaning | Solution |
|---------------|---------|----------|
| `JsonException: The JSON value could not be converted` | JSON doesn't match model structure | Check property names and types |
| `InvalidOperationException: Unable to resolve service` | Service not registered in DI | Add `builder.Services.AddScoped<IService, Service>()` |
| `NullReferenceException` | Trying to access null object | Add null checks before accessing properties |
| `HttpRequestException: No connection could be made` | API not running or wrong URL | Verify app is running and URL is correct |
| `System.IO.IOException: Failed to bind to address` | Port already in use | Change port or stop other application |

### Debugging Strategies

**Step-by-step debugging:**

1. **Check if app is running** - Look for "Now listening on..." message
2. **Verify the URL** - Copy exact URL from terminal output
3. **Check Swagger UI** - See all registered endpoints
4. **Look at terminal logs** - ASP.NET Core logs all requests
5. **Use browser DevTools** - See exact request/response (F12)
6. **Add logging** - Use `_logger.LogInformation()` to see what's happening
7. **Use breakpoints** - Set breakpoints in Visual Studio/VS Code to step through code

**Useful debugging commands:**

```bash
# Check .NET version
dotnet --version

# Clean and rebuild
dotnet clean
dotnet build

# Run with detailed logging
dotnet run --verbosity detailed

# Check environment variables
dotnet run --environment Development

# List all endpoints
dotnet run
# Then navigate to /swagger
```

### Where to Get Help

- **Official Documentation**: [https://learn.microsoft.com/aspnet/core](https://learn.microsoft.com/aspnet/core)
- **Community Forum**: [https://forums.asp.net](https://forums.asp.net)
- **Stack Overflow Tag**: [`asp.net-core-webapi`](https://stackoverflow.com/questions/tagged/asp.net-core-webapi)
- **GitHub Issues**: [https://github.com/dotnet/aspnetcore/issues](https://github.com/dotnet/aspnetcore/issues)
- **Discord**: [.NET Discord Server](https://discord.gg/dotnet)
- **Reddit**: [r/dotnet](https://reddit.com/r/dotnet)

**When asking for help, include:**
1. Exact error message
2. Code that's not working
3. .NET version (`dotnet --version`)
4. What you've already tried
5. Expected vs actual behavior

---

## 12. Additional Resources

### Official Documentation

- [ASP.NET Core Documentation](https://learn.microsoft.com/aspnet/core) - Main documentation hub
- [Web API Tutorial](https://learn.microsoft.com/aspnet/core/tutorials/first-web-api) - Official tutorial
- [Controller Action Return Types](https://learn.microsoft.com/aspnet/core/web-api/action-return-types) - Understanding return types
- [Routing in ASP.NET Core](https://learn.microsoft.com/aspnet/core/fundamentals/routing) - Deep dive into routing
- [Dependency Injection](https://learn.microsoft.com/aspnet/core/fundamentals/dependency-injection) - DI in ASP.NET Core

### Recommended Tutorials

- [Microsoft Learn: Create a web API](https://learn.microsoft.com/training/modules/build-web-api-aspnet-core/) - Interactive tutorial
- [FreeCodeCamp: Web API Tutorial](https://www.youtube.com/watch?v=_8nLSsK5NDg) - Video tutorial
- [Tim Corey: ASP.NET Core](https://www.youtube.com/playlist?list=PLLWMQd6PeGY0-jmJxFw5j27HWx7OWC3Bd) - Comprehensive playlist

### Video Resources

- [.NET YouTube Channel](https://www.youtube.com/@dotnet) - Official .NET videos
- [Nick Chapsas](https://www.youtube.com/@nickchapsas) - Advanced C# and ASP.NET Core content
- [IAmTimCorey](https://www.youtube.com/@IAmTimCorey) - Beginner-friendly .NET tutorials
- [Coding with Mosh](https://www.youtube.com/@programmingwithmosh) - Clean code and best practices

### Books

- **C# 12 and .NET 8 - Modern Cross-Platform Development** by Mark J. Price - Comprehensive guide
- **ASP.NET Core in Action** by Andrew Lock - Deep dive into ASP.NET Core
- **Pro ASP.NET Core 7** by Adam Freeman - Reference book for experienced developers

### Community Resources

- [.NET Blog](https://devblogs.microsoft.com/dotnet/) - Official .NET team blog
- [ASP.NET Community Standup](https://dotnet.microsoft.com/live/aspnet-community-standup) - Weekly community call
- [Weekly .NET Newsletter](https://www.dotnetweekly.com/) - Curated .NET news
- [C# Discord](https://discord.gg/csharp) - Active C# community

### Related Technologies

- **Entity Framework Core** - Database access and ORM
- **Swagger/OpenAPI** - API documentation
- **Minimal APIs** - Lightweight alternative to controllers
- **gRPC** - High-performance RPC framework
- **SignalR** - Real-time web functionality
- **ASP.NET Core MVC** - Building web pages

### Next Steps

After mastering the basics covered in this guide, consider:

1. **Entity Framework Core** - Learn database integration
   - Create Pokemon database
   - Implement CRUD operations with real persistence
   - Learn migrations and database seeding

2. **Authentication & Authorization** - Secure your API
   - Add user authentication with JWT tokens
   - Implement role-based authorization
   - Protect endpoints requiring login

3. **Advanced Patterns** - Improve code quality
   - Implement Repository and Service patterns
   - Add validation using FluentValidation
   - Implement CQRS with MediatR

4. **Testing** - Ensure code quality
   - Write unit tests for controllers
   - Integration tests for endpoints
   - Learn Moq for mocking dependencies

5. **Deployment** - Get your API online
   - Deploy to Azure App Service
   - Containerize with Docker
   - Set up CI/CD pipelines

---

## Appendix

### Glossary

**API (Application Programming Interface)**: A set of rules that allows programs to communicate with each other.

**ASP.NET Core**: Microsoft's cross-platform framework for building modern web applications.

**Async/Await**: C# keywords for writing asynchronous code that doesn't block threads.

**Controller**: A class that groups related HTTP endpoints together.

**CORS (Cross-Origin Resource Sharing)**: A security feature that allows/blocks web pages from making requests to different domains.

**Dependency Injection (DI)**: A design pattern where objects receive their dependencies from external sources rather than creating them.

**DTO (Data Transfer Object)**: An object that carries data between processes, often used to shape API responses.

**Endpoint**: A specific URL and HTTP method combination that performs an action.

**HTTP Methods**: Verbs that describe the action to perform (GET, POST, PUT, DELETE).

**JSON (JavaScript Object Notation)**: A lightweight text format for storing and exchanging data.

**Middleware**: Software components that process HTTP requests in a pipeline.

**REST (Representational State Transfer)**: An architectural style for designing networked applications.

**Route**: A URL pattern that maps to a controller action.

**Swagger/OpenAPI**: Tools for documenting and testing APIs.

**Status Code**: HTTP codes indicating the result of a request (200 OK, 404 Not Found, etc.).

### Cheat Sheet

**Common Commands:**
```bash
# Create new Web API project
dotnet new webapi -n ProjectName

# Run the application
dotnet run

# Run with hot reload
dotnet watch run

# Build without running
dotnet build

# Clean build artifacts
dotnet clean

# Restore NuGet packages
dotnet restore

# Run on specific port
dotnet run --urls "https://localhost:5001"
```

**Common Attributes:**
```csharp
[ApiController]           // Marks class as API controller
[Route("api/[controller]")]  // Sets base route
[HttpGet]                // GET request
[HttpPost]               // POST request
[HttpPut]                // PUT request
[HttpDelete]             // DELETE request
[FromBody]               // Binds from request body
[FromQuery]              // Binds from query string
[FromRoute]              // Binds from route parameters
```

**Common Return Types:**
```csharp
Ok(data)                      // 200 OK
Created(uri, data)            // 201 Created
CreatedAtAction(action, data) // 201 Created with location
NoContent()                   // 204 No Content
BadRequest(error)             // 400 Bad Request
NotFound(error)               // 404 Not Found
StatusCode(500, error)        // Custom status code
```

**Common LINQ Methods:**
```csharp
.Where(predicate)        // Filter
.Select(selector)        // Transform
.FirstOrDefault()        // Get first or null
.ToList()               // Convert to List
.Any()                  // Check if any exist
.Count()                // Count items
.Skip(n).Take(m)        // Pagination
```

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-11-22 | Initial version - Complete guide for creating first Web API |

---

**[Screenshot Placeholders in this document]:**
1. Swagger UI with WeatherForecast endpoint
2. Terminal showing successful project creation
3. Visual Studio new project dialog
4. Swagger UI displaying WeatherForecast endpoints
5. VS Code debug panel
6. Swagger UI with response
7. Postman showing GET request
8. Successful Swagger test

**To complete this document:** Replace screenshot placeholders with actual screenshots of each step during implementation.
