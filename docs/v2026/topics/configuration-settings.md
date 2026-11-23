# Configuration and Settings

---
**Technology Version**: .NET 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-23
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What is Configuration?

Configuration is the process of providing settings and options to your application without hardcoding them in your source code. Instead of writing `var apiKey = "abc123"` directly in your code, you store it in a configuration file like `appsettings.json` and read it when needed.

Think of configuration as your application's "control panel" - a place where you can adjust behavior, connection strings, API keys, feature flags, and other settings without recompiling your code.

In ASP.NET Core, configuration is:
- **File-based** - Settings stored in JSON files (appsettings.json)
- **Environment-specific** - Different settings for Development, Staging, Production
- **Hierarchical** - Settings can override each other based on priority
- **Flexible** - Can come from files, environment variables, command line, or custom sources

### Why Use Configuration?

You should use configuration when:

- **Environment differences** - Database connections differ between dev, staging, production
- **Security** - Store sensitive data (API keys, passwords) outside source code
- **Flexibility** - Change behavior without recompiling (enable/disable features)
- **Team collaboration** - Each developer can have local settings without affecting others
- **Deployment** - Deploy same code to different environments with different configurations
- **Maintainability** - Central location for all application settings

### When to Use Configuration

**Use configuration for:**
- Database connection strings
- API keys and secrets
- Feature flags (enable/disable features)
- URLs for external services
- Application behavior settings (page size, timeout values)
- Environment-specific settings
- Logging levels

**Don't use configuration for:**
- Business logic
- Code that changes frequently
- Large amounts of data
- Settings that require complex validation

---

## 2. Quick Start

**TL;DR - Use configuration in 2 minutes:**

**Step 1: Add setting to appsettings.json**

```json
{
  "ApplicationName": "Pokemon App",
  "MaxPokemonPerTrainer": 6
}
```

**Step 2: Read configuration in controller**

```csharp
public class HomeController : Controller
{
    private readonly IConfiguration _configuration;

    public HomeController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public IActionResult Index()
    {
        var appName = _configuration["ApplicationName"];
        var maxPokemon = _configuration.GetValue<int>("MaxPokemonPerTrainer");

        ViewBag.AppName = appName;
        ViewBag.MaxPokemon = maxPokemon;

        return View();
    }
}
```

**Expected result:** Settings are read from appsettings.json and available in your controller.

For detailed explanations, continue reading the sections below.

---

## 3. Prerequisites

### Required Knowledge

- **C# basics** - Classes, properties, dependency injection
- **ASP.NET Core basics** - Program.cs, services, controllers (see POK-10)
- **JSON format** - Understanding JSON structure

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

#### Concept 1: Configuration Files

ASP.NET Core uses JSON files for configuration:

**appsettings.json** - Base configuration for all environments
```json
{
  "ApplicationName": "Pokemon App",
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  }
}
```

**appsettings.Development.json** - Development-specific settings
```json
{
  "DetailedErrors": true,
  "Logging": {
    "LogLevel": {
      "Default": "Debug"
    }
  }
}
```

**appsettings.Production.json** - Production-specific settings
```json
{
  "DetailedErrors": false,
  "Logging": {
    "LogLevel": {
      "Default": "Warning"
    }
  }
}
```

#### Concept 2: Configuration Hierarchy

ASP.NET Core loads configuration from multiple sources in this order (later sources override earlier ones):

```
1. appsettings.json (base)
   ↓
2. appsettings.{Environment}.json (environment-specific)
   ↓
3. User Secrets (development only)
   ↓
4. Environment Variables
   ↓
5. Command Line Arguments
   ↓
Final Configuration (all merged together)
```

**Example:**

**appsettings.json:**
```json
{
  "Database": {
    "Server": "localhost",
    "Name": "PokemonDb"
  }
}
```

**appsettings.Production.json:**
```json
{
  "Database": {
    "Server": "production-server.database.windows.net"
  }
}
```

**Result in Production:**
```json
{
  "Database": {
    "Server": "production-server.database.windows.net",  // ← Overridden
    "Name": "PokemonDb"  // ← Kept from base
  }
}
```

#### Concept 3: Reading Configuration

Three ways to read configuration:

**1. Direct access with IConfiguration:**
```csharp
var value = _configuration["SettingName"];
var nestedValue = _configuration["Section:SubSection:Key"];
var typedValue = _configuration.GetValue<int>("NumberSetting");
```

**2. Bind to a section:**
```csharp
var databaseConfig = new DatabaseConfig();
_configuration.GetSection("Database").Bind(databaseConfig);
```

**3. Options Pattern (recommended):**
```csharp
// Strongly-typed configuration
public class DatabaseOptions
{
    public string Server { get; set; }
    public string Name { get; set; }
}

// Register
builder.Services.Configure<DatabaseOptions>(
    builder.Configuration.GetSection("Database"));

// Use
public MyController(IOptions<DatabaseOptions> options)
{
    var server = options.Value.Server;
}
```

#### Concept 4: Environment-Specific Configuration

ASP.NET Core determines the environment from the `ASPNETCORE_ENVIRONMENT` variable:

**Development:**
- `ASPNETCORE_ENVIRONMENT=Development`
- Loads `appsettings.Development.json`
- Enables detailed errors, debugging

**Staging:**
- `ASPNETCORE_ENVIRONMENT=Staging`
- Loads `appsettings.Staging.json`
- Testing environment before production

**Production:**
- `ASPNETCORE_ENVIRONMENT=Production`
- Loads `appsettings.Production.json`
- Optimized for performance, security

**Check environment in code:**
```csharp
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}
```

#### Concept 5: User Secrets

User Secrets allow you to store sensitive data during development without committing it to source control.

**Use for:**
- API keys during development
- Connection strings with passwords
- Personal development settings

**Initialize:**
```bash
dotnet user-secrets init
```

**Add secret:**
```bash
dotnet user-secrets set "ApiKey" "my-secret-key"
```

**Read like any configuration:**
```csharp
var apiKey = _configuration["ApiKey"];
```

Secrets are stored outside your project directory (never committed to Git).

#### Concept 6: Environment Variables

Environment variables override all file-based configuration.

**Set environment variable:**

**Windows:**
```powershell
$env:Database__Server="production-server"
```

**Linux/macOS:**
```bash
export Database__Server="production-server"
```

**Docker:**
```yaml
environment:
  - Database__Server=production-server
```

**Note:** Use double underscore (`__`) to represent hierarchy:
- `Database__Server` → `Database:Server`
- `Jwt__Key` → `Jwt:Key`

### Important Terminology

| Term | Definition |
|------|------------|
| **appsettings.json** | Base configuration file for all environments |
| **Environment** | Development, Staging, or Production mode |
| **IConfiguration** | Service for reading configuration values |
| **Options Pattern** | Strongly-typed configuration binding |
| **User Secrets** | Local development secrets not in source control |
| **Environment Variables** | OS-level configuration that overrides files |
| **Configuration Provider** | Source of configuration data (files, env vars, etc.) |
| **Hierarchical Configuration** | Nested settings using colon notation (e.g., "Database:Server") |
| **Configuration Binding** | Mapping configuration to C# objects |

### Architecture Overview

**How configuration is loaded:**

```
┌──────────────────────────────────┐
│   Application Startup            │
└──────────────┬───────────────────┘
               │
      ┌────────▼────────┐
      │  Configuration  │
      │  Builder        │
      └────────┬────────┘
               │
     ┌─────────▼────────────────────┐
     │  Load appsettings.json       │
     └─────────┬────────────────────┘
               │
     ┌─────────▼────────────────────┐
     │  Load appsettings.           │
     │  {Environment}.json          │
     │  (if exists)                 │
     └─────────┬────────────────────┘
               │
     ┌─────────▼────────────────────┐
     │  Load User Secrets           │
     │  (Development only)          │
     └─────────┬────────────────────┘
               │
     ┌─────────▼────────────────────┐
     │  Load Environment Variables  │
     └─────────┬────────────────────┘
               │
     ┌─────────▼────────────────────┐
     │  Load Command Line Args      │
     └─────────┬────────────────────┘
               │
     ┌─────────▼────────────────────┐
     │  Merged Configuration        │
     │  (IConfiguration service)    │
     └─────────┬────────────────────┘
               │
     ┌─────────▼────────────────────┐
     │  Available throughout        │
     │  application via DI          │
     └──────────────────────────────┘
```

---

## 5. Installation Guide

### No Installation Required

Configuration is built into ASP.NET Core. All new projects include `appsettings.json` by default.

### Verify Configuration is Working

**Check 1: appsettings.json exists**

Your project should have:
```
YourProject/
├── appsettings.json
├── appsettings.Development.json
└── Program.cs
```

**Check 2: Configuration is loaded**

Add to any controller:
```csharp
public HomeController(IConfiguration configuration)
{
    var test = configuration["ApplicationName"] ?? "Not found";
    Console.WriteLine($"Configuration test: {test}");
}
```

Run the app and check console output.

---

## 6. Initial Setup & Configuration

### Creating appsettings.json Structure

**Well-organized appsettings.json:**

```json
{
  "ApplicationSettings": {
    "ApplicationName": "Pokemon App",
    "Version": "1.0.0",
    "MaxPokemonPerTrainer": 6,
    "EnableTradingFeature": true
  },

  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=PokemonDb;Trusted_Connection=True;"
  },

  "Jwt": {
    "Key": "YourSuperSecretKeyHere",
    "Issuer": "https://pokemonapp.com",
    "Audience": "https://pokemonapp.com",
    "ExpiryMinutes": 60
  },

  "ExternalApis": {
    "PokeApi": {
      "BaseUrl": "https://pokeapi.co/api/v2/",
      "TimeoutSeconds": 30
    },
    "WeatherApi": {
      "BaseUrl": "https://api.weather.com/",
      "ApiKey": "your-api-key-here"
    }
  },

  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },

  "AllowedHosts": "*"
}
```

**Best practices:**
- Group related settings
- Use descriptive names
- Nest settings logically
- Keep secrets out of source control

### Environment-Specific Configuration

**appsettings.Development.json:**

```json
{
  "ApplicationSettings": {
    "EnableTradingFeature": false  // Disable in dev for testing
  },

  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=PokemonDb_Dev;Trusted_Connection=True;"
  },

  "Logging": {
    "LogLevel": {
      "Default": "Debug",  // More logging in development
      "Microsoft.AspNetCore": "Information"
    }
  }
}
```

**appsettings.Production.json:**

```json
{
  "ApplicationSettings": {
    "EnableTradingFeature": true
  },

  "ConnectionStrings": {
    "DefaultConnection": "Server=production-server;Database=PokemonDb;User Id=app_user;Password=***;"
  },

  "Logging": {
    "LogLevel": {
      "Default": "Warning",  // Less logging in production
      "Microsoft.AspNetCore": "Error"
    }
  }
}
```

### Setting Up User Secrets

**Initialize user secrets:**

```bash
# In your project directory
dotnet user-secrets init
```

This adds a UserSecretsId to your .csproj:

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <UserSecretsId>aspnet-PokemonApp-guid</UserSecretsId>
  </PropertyGroup>
</Project>
```

**Add secrets:**

```bash
dotnet user-secrets set "Jwt:Key" "my-development-secret-key"
dotnet user-secrets set "ExternalApis:WeatherApi:ApiKey" "dev-api-key"
```

**List secrets:**

```bash
dotnet user-secrets list
```

**Remove secret:**

```bash
dotnet user-secrets remove "Jwt:Key"
```

**Clear all secrets:**

```bash
dotnet user-secrets clear
```

**Secrets location:**
- **Windows**: `%APPDATA%\Microsoft\UserSecrets\<UserSecretsId>\secrets.json`
- **Linux/macOS**: `~/.microsoft/usersecrets/<UserSecretsId>/secrets.json`

### Configuring Environment Variables

**Development (launchSettings.json):**

```json
{
  "profiles": {
    "Development": {
      "commandName": "Project",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development",
        "Database__Server": "localhost"
      }
    },
    "Production": {
      "commandName": "Project",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Production",
        "Database__Server": "production-server"
      }
    }
  }
}
```

**Production (Azure, Docker, etc.):**

Set environment variables in your hosting environment.

---

## 7. Basic Usage

### Reading Configuration with IConfiguration

**Inject IConfiguration:**

```csharp
public class HomeController : Controller
{
    private readonly IConfiguration _configuration;

    public HomeController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public IActionResult Index()
    {
        // Read simple value
        var appName = _configuration["ApplicationSettings:ApplicationName"];

        // Read with default value
        var maxPokemon = _configuration.GetValue<int>("ApplicationSettings:MaxPokemonPerTrainer", 6);

        // Read boolean
        var tradingEnabled = _configuration.GetValue<bool>("ApplicationSettings:EnableTradingFeature");

        // Read connection string
        var connectionString = _configuration.GetConnectionString("DefaultConnection");

        return View();
    }
}
```

### Binding Configuration to Objects

**Create configuration class:**

```csharp
// Options/ApplicationSettings.cs
public class ApplicationSettings
{
    public string ApplicationName { get; set; }
    public string Version { get; set; }
    public int MaxPokemonPerTrainer { get; set; }
    public bool EnableTradingFeature { get; set; }
}
```

**Bind in controller:**

```csharp
public class HomeController : Controller
{
    private readonly IConfiguration _configuration;

    public HomeController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public IActionResult Index()
    {
        var settings = new ApplicationSettings();
        _configuration.GetSection("ApplicationSettings").Bind(settings);

        // Now use settings object
        var appName = settings.ApplicationName;
        var maxPokemon = settings.MaxPokemonPerTrainer;

        return View();
    }
}
```

### Using the Options Pattern (Recommended)

**Step 1: Create options class**

```csharp
// Options/JwtOptions.cs
public class JwtOptions
{
    public const string SectionName = "Jwt";

    public string Key { get; set; }
    public string Issuer { get; set; }
    public string Audience { get; set; }
    public int ExpiryMinutes { get; set; }
}
```

**Step 2: Register options in Program.cs**

```csharp
// Program.cs
builder.Services.Configure<JwtOptions>(
    builder.Configuration.GetSection(JwtOptions.SectionName));

builder.Services.Configure<ApplicationSettings>(
    builder.Configuration.GetSection("ApplicationSettings"));
```

**Step 3: Inject and use in services**

```csharp
using Microsoft.Extensions.Options;

public class TokenService
{
    private readonly JwtOptions _jwtOptions;

    public TokenService(IOptions<JwtOptions> jwtOptions)
    {
        _jwtOptions = jwtOptions.Value;
    }

    public string GenerateToken()
    {
        var key = _jwtOptions.Key;
        var issuer = _jwtOptions.Issuer;
        // Use configuration values
        return "token";
    }
}
```

**Benefits of Options Pattern:**
- Strongly-typed
- IntelliSense support
- Validation at startup
- Testable
- Reloadable (with IOptionsSnapshot)

### Reading Connection Strings

**appsettings.json:**

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=PokemonDb;...",
    "RedisConnection": "localhost:6379"
  }
}
```

**Read in code:**

```csharp
// Using IConfiguration
var connString = _configuration.GetConnectionString("DefaultConnection");

// In Program.cs for DbContext
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection")));
```

---

## 8. Testing & Validation

### How to Test Configuration

#### Method 1: Console Output

```csharp
public class HomeController : Controller
{
    private readonly IConfiguration _configuration;
    private readonly ILogger<HomeController> _logger;

    public HomeController(IConfiguration configuration, ILogger<HomeController> logger)
    {
        _configuration = configuration;
        _logger = logger;
    }

    public IActionResult Index()
    {
        // Log all configuration
        var appName = _configuration["ApplicationSettings:ApplicationName"];
        var maxPokemon = _configuration.GetValue<int>("ApplicationSettings:MaxPokemonPerTrainer");

        _logger.LogInformation("AppName: {AppName}, MaxPokemon: {MaxPokemon}",
            appName, maxPokemon);

        return View();
    }
}
```

#### Method 2: Configuration Validation

**Create validator:**

```csharp
// Options/JwtOptionsValidator.cs
using Microsoft.Extensions.Options;

public class JwtOptionsValidator : IValidateOptions<JwtOptions>
{
    public ValidateOptionsResult Validate(string name, JwtOptions options)
    {
        if (string.IsNullOrEmpty(options.Key))
            return ValidateOptionsResult.Fail("JWT Key is required");

        if (options.Key.Length < 32)
            return ValidateOptionsResult.Fail("JWT Key must be at least 32 characters");

        if (string.IsNullOrEmpty(options.Issuer))
            return ValidateOptionsResult.Fail("JWT Issuer is required");

        return ValidateOptionsResult.Success;
    }
}
```

**Register validator:**

```csharp
builder.Services.AddSingleton<IValidateOptions<JwtOptions>, JwtOptionsValidator>();
```

Now application will fail to start if configuration is invalid.

#### Method 3: Unit Tests

```csharp
using Microsoft.Extensions.Configuration;
using Xunit;

public class ConfigurationTests
{
    [Fact]
    public void Configuration_LoadsCorrectly()
    {
        // Arrange
        var config = new ConfigurationBuilder()
            .AddJsonFile("appsettings.json")
            .Build();

        // Act
        var appName = config["ApplicationSettings:ApplicationName"];

        // Assert
        Assert.Equal("Pokemon App", appName);
    }

    [Fact]
    public void Options_BindsCorrectly()
    {
        // Arrange
        var config = new ConfigurationBuilder()
            .AddInMemoryCollection(new Dictionary<string, string>
            {
                ["Jwt:Key"] = "test-key-at-least-32-characters-long",
                ["Jwt:Issuer"] = "test-issuer",
                ["Jwt:ExpiryMinutes"] = "60"
            })
            .Build();

        // Act
        var jwtOptions = new JwtOptions();
        config.GetSection("Jwt").Bind(jwtOptions);

        // Assert
        Assert.Equal("test-key-at-least-32-characters-long", jwtOptions.Key);
        Assert.Equal("test-issuer", jwtOptions.Issuer);
        Assert.Equal(60, jwtOptions.ExpiryMinutes);
    }
}
```

### Hands-On Exercises

#### Exercise 1: Create Application Settings (Beginner)

**Objective:** Create and use application-specific settings

**Task:**
1. Add "ApplicationSettings" section to appsettings.json
2. Include ApplicationName, Version, MaxPokemonPerTrainer
3. Read settings in HomeController
4. Display in view

**Requirements:**
- Use IConfiguration to read values
- Display all three settings on home page
- Use default values if settings missing

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**appsettings.json:**
```json
{
  "ApplicationSettings": {
    "ApplicationName": "Pokemon App",
    "Version": "1.0.0",
    "MaxPokemonPerTrainer": 6
  }
}
```

**HomeController.cs:**
```csharp
public class HomeController : Controller
{
    private readonly IConfiguration _configuration;

    public HomeController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public IActionResult Index()
    {
        ViewBag.AppName = _configuration["ApplicationSettings:ApplicationName"];
        ViewBag.Version = _configuration["ApplicationSettings:Version"];
        ViewBag.MaxPokemon = _configuration.GetValue<int>("ApplicationSettings:MaxPokemonPerTrainer", 6);

        return View();
    }
}
```

**Views/Home/Index.cshtml:**
```cshtml
<h1>@ViewBag.AppName</h1>
<p>Version: @ViewBag.Version</p>
<p>Max Pokemon per Trainer: @ViewBag.MaxPokemon</p>
```

</details>

---

#### Exercise 2: Implement Options Pattern (Intermediate)

**Objective:** Use strongly-typed configuration with Options pattern

**Task:**
1. Create DatabaseOptions class with Server, Name, ConnectionString properties
2. Register options in Program.cs
3. Inject IOptions<DatabaseOptions> in a service
4. Use configuration values

**Requirements:**
- Use Configure<DatabaseOptions>
- Access via IOptions<DatabaseOptions>
- Validate options have values

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Create options class**

```csharp
// Options/DatabaseOptions.cs
public class DatabaseOptions
{
    public const string SectionName = "Database";

    public string Server { get; set; }
    public string Name { get; set; }
    public string ConnectionString => $"Server={Server};Database={Name};Trusted_Connection=True;";
}
```

**Step 2: Add to appsettings.json**

```json
{
  "Database": {
    "Server": "localhost",
    "Name": "PokemonDb"
  }
}
```

**Step 3: Register in Program.cs**

```csharp
builder.Services.Configure<DatabaseOptions>(
    builder.Configuration.GetSection(DatabaseOptions.SectionName));
```

**Step 4: Use in service**

```csharp
// Services/PokemonService.cs
using Microsoft.Extensions.Options;

public class PokemonService
{
    private readonly DatabaseOptions _dbOptions;

    public PokemonService(IOptions<DatabaseOptions> dbOptions)
    {
        _dbOptions = dbOptions.Value;
    }

    public void Connect()
    {
        var connString = _dbOptions.ConnectionString;
        Console.WriteLine($"Connecting to: {connString}");
    }
}
```

**Step 5: Register service**

```csharp
builder.Services.AddScoped<PokemonService>();
```

</details>

---

#### Exercise 3: Use User Secrets for API Keys (Challenge)

**Objective:** Store sensitive API keys using User Secrets

**Task:**
1. Initialize user secrets in your project
2. Add an API key as a user secret
3. Create ExternalApiOptions class
4. Read secret in a service
5. Verify secret is not in appsettings.json

**Requirements:**
- Use `dotnet user-secrets` commands
- Create strongly-typed options
- Access secret via IOptions
- Confirm secret not committed to Git

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Initialize user secrets**

```bash
dotnet user-secrets init
```

**Step 2: Add secret**

```bash
dotnet user-secrets set "ExternalApis:PokeApi:ApiKey" "my-secret-api-key"
```

**Step 3: Create options class**

```csharp
// Options/PokeApiOptions.cs
public class PokeApiOptions
{
    public const string SectionName = "ExternalApis:PokeApi";

    public string BaseUrl { get; set; }
    public string ApiKey { get; set; }
}
```

**Step 4: Add non-secret settings to appsettings.json**

```json
{
  "ExternalApis": {
    "PokeApi": {
      "BaseUrl": "https://pokeapi.co/api/v2/"
    }
  }
}
```

**Step 5: Register options**

```csharp
builder.Services.Configure<PokeApiOptions>(
    builder.Configuration.GetSection(PokeApiOptions.SectionName));
```

**Step 6: Use in service**

```csharp
// Services/PokeApiService.cs
using Microsoft.Extensions.Options;

public class PokeApiService
{
    private readonly PokeApiOptions _options;
    private readonly HttpClient _httpClient;

    public PokeApiService(
        IOptions<PokeApiOptions> options,
        HttpClient httpClient)
    {
        _options = options.Value;
        _httpClient = httpClient;
        _httpClient.BaseAddress = new Uri(_options.BaseUrl);
    }

    public async Task<string> GetPokemonAsync(int id)
    {
        // Use API key in header
        _httpClient.DefaultRequestHeaders.Add("X-API-Key", _options.ApiKey);

        var response = await _httpClient.GetStringAsync($"pokemon/{id}");
        return response;
    }
}
```

**Step 7: Verify secret not in Git**

Check `.gitignore` includes:
```
**/secrets.json
```

Confirm `appsettings.json` does NOT contain ApiKey.

</details>

---

### Self-Assessment Checklist

After completing this guide, you should be able to:

- [ ] Understand configuration hierarchy and precedence
- [ ] Create and organize appsettings.json
- [ ] Use environment-specific configuration files
- [ ] Read configuration with IConfiguration
- [ ] Implement Options pattern for strongly-typed configuration
- [ ] Set up and use User Secrets
- [ ] Configure environment variables
- [ ] Validate configuration at startup
- [ ] Test configuration loading
- [ ] Keep secrets out of source control

---

## 9. Practical Examples

### Example 1: Feature Flags

**Scenario:** Enable/disable features without redeploying

**appsettings.json:**

```json
{
  "FeatureFlags": {
    "EnableTrading": true,
    "EnableBattles": false,
    "EnableShop": true
  }
}
```

**Options/FeatureFlags.cs:**

```csharp
public class FeatureFlags
{
    public const string SectionName = "FeatureFlags";

    public bool EnableTrading { get; set; }
    public bool EnableBattles { get; set; }
    public bool EnableShop { get; set; }
}
```

**Register:**

```csharp
builder.Services.Configure<FeatureFlags>(
    builder.Configuration.GetSection(FeatureFlags.SectionName));
```

**Use in controller:**

```csharp
public class PokemonController : Controller
{
    private readonly FeatureFlags _features;

    public PokemonController(IOptions<FeatureFlags> features)
    {
        _features = features.Value;
    }

    public IActionResult Trade()
    {
        if (!_features.EnableTrading)
        {
            return Content("Trading feature is currently disabled");
        }

        return View();
    }

    public IActionResult Battle()
    {
        if (!_features.EnableBattles)
        {
            TempData["Message"] = "Battles coming soon!";
            return RedirectToAction("Index");
        }

        return View();
    }
}
```

**Use in view:**

```cshtml
@inject IOptions<FeatureFlags> FeatureFlags

@if (FeatureFlags.Value.EnableShop)
{
    <a asp-controller="Shop" asp-action="Index">Visit Shop</a>
}
```

---

### Example 2: External API Configuration

**Scenario:** Configure multiple external APIs

**appsettings.json:**

```json
{
  "ExternalApis": {
    "PokeApi": {
      "BaseUrl": "https://pokeapi.co/api/v2/",
      "TimeoutSeconds": 30,
      "RetryAttempts": 3
    },
    "WeatherApi": {
      "BaseUrl": "https://api.openweathermap.org/data/2.5/",
      "TimeoutSeconds": 10,
      "RetryAttempts": 2
    }
  }
}
```

**Options/ExternalApiOptions.cs:**

```csharp
public class ExternalApiOptions
{
    public string BaseUrl { get; set; }
    public int TimeoutSeconds { get; set; }
    public int RetryAttempts { get; set; }
}
```

**Program.cs:**

```csharp
builder.Services.Configure<ExternalApiOptions>(
    "PokeApi",
    builder.Configuration.GetSection("ExternalApis:PokeApi"));

builder.Services.Configure<ExternalApiOptions>(
    "WeatherApi",
    builder.Configuration.GetSection("ExternalApis:WeatherApi"));

builder.Services.AddHttpClient<PokeApiService>((sp, client) =>
{
    var options = sp.GetRequiredService<IOptionsSnapshot<ExternalApiOptions>>()
        .Get("PokeApi");

    client.BaseAddress = new Uri(options.BaseUrl);
    client.Timeout = TimeSpan.FromSeconds(options.TimeoutSeconds);
});
```

---

## 10. Common Patterns & Best Practices

### Do's

✅ **Use Options Pattern for complex configuration**

```csharp
// Good ✅
builder.Services.Configure<JwtOptions>(
    builder.Configuration.GetSection("Jwt"));
```

✅ **Keep secrets out of appsettings.json**

```json
// Bad ❌
{
  "Jwt": {
    "Key": "my-secret-key-visible-in-git"
  }
}

// Good ✅
// Use User Secrets or Environment Variables
dotnet user-secrets set "Jwt:Key" "my-secret-key"
```

✅ **Use environment-specific configurations**

```
appsettings.json               ← Base
appsettings.Development.json   ← Dev overrides
appsettings.Production.json    ← Prod overrides
```

✅ **Validate configuration at startup**

```csharp
builder.Services.AddSingleton<IValidateOptions<JwtOptions>, JwtOptionsValidator>();
```

✅ **Use meaningful section names**

```json
{
  "Database": { },        // ✅ Clear
  "ExternalApis": { },    // ✅ Clear
  "FeatureFlags": { }     // ✅ Clear
}
```

### Don'ts

❌ **Don't commit secrets to source control**
❌ **Don't use magic strings everywhere**
❌ **Don't ignore configuration hierarchy**
❌ **Don't forget environment-specific settings**
❌ **Don't hardcode values that might change**

---

## 11. Troubleshooting & Common Issues

### Problem: Configuration value is null

**Cause:** Wrong key name or configuration not loaded

**Solution:**
```csharp
// Check exact key
var value = _configuration["ApplicationSettings:ApplicationName"];

// Use default value
var value = _configuration.GetValue<string>("ApplicationSettings:ApplicationName", "Default");

// Log all configuration keys
foreach (var kvp in _configuration.AsEnumerable())
{
    Console.WriteLine($"{kvp.Key} = {kvp.Value}");
}
```

### Problem: Environment-specific configuration not loading

**Cause:** ASPNETCORE_ENVIRONMENT not set correctly

**Solution:**

Check environment:
```csharp
Console.WriteLine($"Environment: {app.Environment.EnvironmentName}");
```

Set in launchSettings.json:
```json
{
  "profiles": {
    "Development": {
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      }
    }
  }
}
```

---

## 12. Additional Resources

### Official Documentation

- [Configuration in ASP.NET Core](https://learn.microsoft.com/aspnet/core/fundamentals/configuration)
- [Options pattern](https://learn.microsoft.com/aspnet/core/fundamentals/configuration/options)
- [Safe storage of app secrets](https://learn.microsoft.com/aspnet/core/security/app-secrets)

### Next Steps

After mastering configuration:

1. **Environment Variables in Production** - Azure App Settings, Docker configs
2. **Azure Key Vault** - Secure secret storage
3. **Configuration Reloading** - IOptionsSnapshot and change tokens
4. **Custom Configuration Providers** - Load from databases, APIs
5. **Configuration Validation** - FluentValidation with Options

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-11-23 | Initial comprehensive documentation for Configuration and Settings |

---

**Estimated Reading Time**: 50-55 minutes

**Prerequisites**: ASP.NET Core basics (POK-10), Dependency Injection (POK-11)

**Related Topics**: Deployment, Security, Environment Management
