# Creating an MVC Project

---
**Technology Version**: .NET 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-23
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What is an ASP.NET Core MVC Project?

An ASP.NET Core MVC project is a web application built using the Model-View-Controller pattern. It's a complete, ready-to-run project structure that Microsoft provides to help you build websites quickly. When you create an MVC project, .NET automatically sets up all the folders, files, and configuration you need to start building web pages.

Think of it like getting a pre-furnished apartment instead of an empty room. You get the kitchen (Controllers), the living room (Views), and storage (Models) all set up and ready to use. You just need to add your own content and customize it to your needs.

### Why Create an MVC Project?

You should create an MVC project when you want to:

- **Build a website with server-rendered pages** - MVC generates HTML on the server and sends complete pages to the browser
- **Learn ASP.NET Core web development** - MVC projects provide a clear structure that helps you understand how web apps work
- **Create a full-stack application** - Combine your backend logic with user-facing web pages in one project
- **Build a traditional web application** - Admin panels, content management systems, e-commerce sites work great with MVC

### When to Use It

**Good use cases:**
- Traditional websites with server-rendered pages (blogs, e-commerce, admin dashboards)
- Applications where you want tight integration between backend and frontend
- Projects where SEO (Search Engine Optimization) is important
- Learning web development with a clear, structured approach
- Building internal tools and admin interfaces

**Not recommended for:**
- Single Page Applications (SPAs) - Consider using a Web API + React/Angular/Vue instead
- Mobile app backends - Use Web API for JSON-only endpoints
- Real-time applications requiring constant bi-directional communication - Consider SignalR
- Microservices that only serve data - Use Web API projects

---

## 2. Quick Start

**TL;DR - Create and run an MVC project in 2 minutes:**

```bash
# Create new MVC project
dotnet new mvc -n MyFirstMvcApp

# Navigate into the project
cd MyFirstMvcApp

# Run the application
dotnet run
```

**Expected output:**
```
Building...
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: https://localhost:5001
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5000
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
```

Open your browser and navigate to `https://localhost:5001` to see your running MVC application!

For detailed explanations and understanding what just happened, continue reading the sections below.

---

## 3. Prerequisites

### Required Knowledge

- **Basic C# programming** - Variables, classes, methods, and basic syntax. You should be comfortable reading C# code.
- **Basic HTML** - Understanding of HTML tags like `<div>`, `<h1>`, `<form>`. MVC generates HTML, so you need to recognize it.
- **Understanding of web basics** - What a URL is, how browsers work, what HTTP requests and responses are.
- **MVC Pattern knowledge** - You should have completed the "Introduction to MVC Pattern" guide first to understand the concepts.

### Required Software/Tools

- **.NET SDK** - Version 8.0 or higher
  - Installation: [Download from dotnet.microsoft.com](https://dotnet.microsoft.com/download)
  - Verify: Run `dotnet --version` in terminal

- **Code Editor** - Choose one:
  - **Visual Studio 2022** (Windows/Mac) - Full-featured IDE with great debugging
  - **Visual Studio Code** (Windows/Mac/Linux) - Lightweight with C# extension
  - **JetBrains Rider** (Windows/Mac/Linux) - Powerful alternative IDE

- **Web Browser** - Any modern browser:
  - Chrome, Firefox, Edge, or Safari for testing your application

### System Requirements

- **Operating System**: Windows 10+, macOS 11+, or modern Linux distribution
- **RAM**: 4GB minimum (8GB recommended)
- **Disk Space**: 2GB free space for .NET SDK and project files
- **Internet Connection**: Required for initial download of .NET SDK and NuGet packages

---

## 4. Core Concepts & Theory

### Key Concepts

#### Concept 1: Project Structure

An MVC project follows a specific folder structure that separates different concerns:

```
MyMvcApp/
├── Controllers/           # Controllers handle incoming requests
├── Views/                # Views contain HTML templates
│   ├── Home/            # Views for HomeController
│   ├── Shared/          # Shared layouts and partial views
│   └── _ViewStart.cshtml
├── Models/               # Models represent your data
├── wwwroot/              # Static files (CSS, JS, images)
│   ├── css/
│   ├── js/
│   ├── lib/
│   └── favicon.ico
├── Program.cs            # Application entry point and configuration
├── appsettings.json      # Configuration settings
└── MyMvcApp.csproj       # Project file
```

**Why this structure?**
- **Separation of concerns**: Each folder has a clear purpose
- **Maintainability**: Easy to find files when you need them
- **Team collaboration**: Multiple developers can work on different parts without conflicts
- **Convention over configuration**: .NET knows where to find things automatically

#### Concept 2: Controllers Folder

The `Controllers/` folder contains controller classes that handle HTTP requests.

**Example:**
```
Controllers/
├── HomeController.cs      # Handles requests to /Home/*
├── AccountController.cs   # Handles requests to /Account/*
└── ProductController.cs   # Handles requests to /Product/*
```

Each controller:
- Inherits from `Controller` base class
- Contains action methods that respond to URLs
- Decides which view to display
- Passes data to views using ViewData, ViewBag, or strongly-typed models

**Simple HomeController.cs:**
```csharp
using Microsoft.AspNetCore.Mvc;

namespace MyMvcApp.Controllers
{
    public class HomeController : Controller
    {
        // Action method for URL: /Home/Index or just /
        public IActionResult Index()
        {
            return View();  // Returns Views/Home/Index.cshtml
        }

        // Action method for URL: /Home/About
        public IActionResult About()
        {
            ViewData["Message"] = "Your application description page.";
            return View();
        }
    }
}
```

#### Concept 3: Views Folder

The `Views/` folder contains Razor view files (.cshtml) that generate HTML.

**Structure:**
```
Views/
├── Home/                 # Views for HomeController
│   ├── Index.cshtml     # Corresponds to Index action
│   ├── About.cshtml     # Corresponds to About action
│   └── Contact.cshtml
├── Shared/               # Shared across all controllers
│   ├── _Layout.cshtml   # Master page template
│   ├── _ViewStart.cshtml
│   └── Error.cshtml
└── _ViewImports.cshtml   # Imports namespaces for all views
```

**Naming convention:**
- Views are organized in folders matching controller names (minus "Controller")
- `HomeController` → `Views/Home/`
- `ProductController` → `Views/Product/`
- View files are named after action methods: `Index()` → `Index.cshtml`

**Simple Index.cshtml:**
```cshtml
@{
    ViewData["Title"] = "Home Page";
}

<div class="text-center">
    <h1 class="display-4">Welcome</h1>
    <p>Learn about <a href="https://docs.microsoft.com/aspnet/core">building Web apps with ASP.NET Core</a>.</p>
</div>
```

#### Concept 4: wwwroot Folder

The `wwwroot/` folder contains static files that are served directly to the browser without processing.

**Structure:**
```
wwwroot/
├── css/                  # Stylesheets
│   └── site.css         # Your custom styles
├── js/                   # JavaScript files
│   └── site.js          # Your custom scripts
├── lib/                  # Third-party libraries
│   ├── bootstrap/
│   └── jquery/
├── images/               # (you create this)
│   └── logo.png
└── favicon.ico           # Website icon
```

**Key points:**
- Only files in `wwwroot/` are publicly accessible via URLs
- Access via: `<link href="~/css/site.css" ... />` (the `~` means wwwroot)
- Files outside wwwroot cannot be accessed directly by browsers (security)
- Common file types: CSS, JavaScript, images, fonts, PDFs

**Why separate static files?**
- **Security**: Prevents access to source code and configuration files
- **Performance**: Static files can be cached and served faster
- **CDN integration**: Easy to move static files to a Content Delivery Network

#### Concept 5: Program.cs

`Program.cs` is the entry point of your application. This is where you configure services and the HTTP request pipeline.

**Modern .NET 8 Program.cs:**
```csharp
var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllersWithViews();

var app = builder.Build();

// Configure the HTTP request pipeline
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

**What's happening:**
1. **CreateBuilder**: Sets up configuration, logging, and dependency injection
2. **AddControllersWithViews**: Registers MVC services
3. **UseStaticFiles**: Enables serving files from wwwroot
4. **MapControllerRoute**: Defines URL routing pattern
5. **Run**: Starts the web server

#### Concept 6: Routing Pattern

The default route pattern is: `{controller=Home}/{action=Index}/{id?}`

**How it works:**

| URL | Controller | Action | id | View |
|-----|------------|--------|-----|------|
| `/` | Home | Index | - | Views/Home/Index.cshtml |
| `/Home/About` | Home | About | - | Views/Home/About.cshtml |
| `/Product/Details/5` | Product | Details | 5 | Views/Product/Details.cshtml |
| `/Account/Login` | Account | Login | - | Views/Account/Login.cshtml |

**Pattern breakdown:**
- `{controller=Home}`: Controller name (defaults to "Home")
- `{action=Index}`: Action method name (defaults to "Index")
- `{id?}`: Optional parameter (the `?` makes it optional)

#### Concept 7: Razor Syntax

Razor is a syntax for embedding C# code in HTML. It uses the `@` symbol.

**Basic Razor examples:**
```cshtml
@* This is a comment *@

@* Display a variable *@
<h1>@ViewData["Title"]</h1>

@* C# code block *@
@{
    var name = "World";
    var greeting = $"Hello, {name}!";
}

@* Display the variable *@
<p>@greeting</p>

@* If statement *@
@if (DateTime.Now.Hour < 12)
{
    <p>Good morning!</p>
}
else
{
    <p>Good afternoon!</p>
}

@* Loop *@
<ul>
@for (int i = 1; i <= 5; i++)
{
    <li>Item @i</li>
}
</ul>
```

**Key rules:**
- `@` switches from HTML to C#
- `@{ }` for multi-line C# code blocks
- `@variable` to output a variable
- HTML tags automatically switch back to HTML mode
- Use `@( )` for explicit expressions

### Important Terminology

| Term | Definition |
|------|------------|
| **MVC** | Model-View-Controller - Design pattern separating data, presentation, and logic |
| **Controller** | Class that handles HTTP requests and returns responses |
| **Action** | Method in a controller that responds to a specific URL |
| **View** | Razor template (.cshtml file) that generates HTML |
| **Model** | Class representing data and business logic |
| **Razor** | Templating syntax for mixing C# and HTML |
| **Layout** | Master page template used by multiple views (_Layout.cshtml) |
| **Partial View** | Reusable view component included in other views |
| **ViewData** | Dictionary for passing data from controller to view |
| **ViewBag** | Dynamic wrapper around ViewData |
| **wwwroot** | Folder containing static files (CSS, JS, images) |
| **Route** | URL pattern mapping to controller and action |
| **Middleware** | Component that handles requests in the pipeline |

### Architecture Overview

**How an MVC request flows:**

```
┌─────────────┐
│   Browser   │
│   (Client)  │
└──────┬──────┘
       │
       │ 1. HTTP Request
       │    GET /Home/Index
       │
       ▼
┌─────────────────────────────────┐
│      ASP.NET Core Pipeline      │
│   (Middleware components)       │
│  - Routing                      │
│  - Static Files                 │
│  - Authentication               │
│  - etc.                         │
└──────────┬──────────────────────┘
           │
           │ 2. Route to Controller
           │
           ▼
    ┌─────────────┐
    │ Controller  │
    │   (C#)      │
    └──────┬──────┘
           │
           │ 3. Execute Action
           │    Process data
           │
           ▼
    ┌─────────────┐
    │   Model     │  (Optional)
    │   (Data)    │
    └──────┬──────┘
           │
           │ 4. Pass Model to View
           │
           ▼
    ┌─────────────┐
    │    View     │
    │  (Razor)    │
    │             │
    │ 5. Generate │
    │    HTML     │
    └──────┬──────┘
           │
           │ 6. HTML Response
           │
           ▼
    ┌─────────────┐
    │   Browser   │
    │  (Display)  │
    └─────────────┘
```

---

## 5. Installation Guide

### Method 1: Using .NET CLI (Recommended)

The .NET CLI (Command Line Interface) is the fastest way to create MVC projects and works on all platforms.

**Step 1: Verify .NET is installed**
```bash
dotnet --version
```

You should see version 8.0 or higher. If not, install .NET SDK from [dotnet.microsoft.com](https://dotnet.microsoft.com/download).

**Step 2: Create a new MVC project**
```bash
dotnet new mvc -n PokemonMvcApp
```

This creates a new folder called `PokemonMvcApp` with a complete MVC project.

**Command breakdown:**
- `dotnet new` - Creates a new project from a template
- `mvc` - Specifies the MVC template
- `-n PokemonMvcApp` - Names the project "PokemonMvcApp"

**Step 3: Navigate into the project folder**
```bash
cd PokemonMvcApp
```

**Step 4: Restore dependencies**
```bash
dotnet restore
```

This downloads all required NuGet packages. Usually happens automatically, but good to run explicitly.

**Step 5: Build the project**
```bash
dotnet build
```

This compiles your code and reports any errors.

**Expected output:**
```
Build succeeded.
    0 Warning(s)
    0 Error(s)

Time Elapsed 00:00:03.45
```

**Step 6: Run the application**
```bash
dotnet run
```

**Expected output:**
```
Building...
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: https://localhost:5001
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5000
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
```

**Step 7: Open in browser**

Navigate to `https://localhost:5001` or `http://localhost:5000` in your browser.

You should see the default ASP.NET Core MVC welcome page!

### Method 2: Using Visual Studio (Windows/Mac)

Visual Studio provides a graphical interface for creating projects.

**Step 1: Open Visual Studio**

Launch Visual Studio 2022 or later.

**Step 2: Create New Project**

1. Click "Create a new project"
2. Search for "ASP.NET Core Web App (Model-View-Controller)"
3. Click "Next"

**Step 3: Configure Project**

1. **Project name**: `PokemonMvcApp`
2. **Location**: Choose where to save the project
3. **Solution name**: `PokemonMvcApp` (can be different)
4. Click "Next"

**Step 4: Additional Information**

1. **Framework**: .NET 8.0
2. **Authentication type**: None (for now)
3. **Configure for HTTPS**: Checked ✓
4. **Enable Docker**: Unchecked (not needed for now)
5. Click "Create"

Visual Studio will create the project and open it automatically.

**Step 5: Run the application**

Press `F5` or click the green "Play" button (IIS Express or project name).

Your default browser will open automatically with the running application.

### Method 3: Using Visual Studio Code

VS Code is a lightweight editor that works on all platforms.

**Step 1: Install C# Extension**

1. Open VS Code
2. Click Extensions (Ctrl+Shift+X)
3. Search "C# Dev Kit"
4. Click "Install"

**Step 2: Create project using terminal**

1. Open VS Code
2. Open Terminal (Ctrl+`)
3. Navigate to where you want the project
4. Run:

```bash
dotnet new mvc -n PokemonMvcApp
cd PokemonMvcApp
code .
```

This creates the project and opens it in VS Code.

**Step 3: Trust the workspace**

If prompted about trusting the workspace, click "Yes".

**Step 4: Restore dependencies**

VS Code should prompt you to restore dependencies. Click "Restore".

Or run manually in terminal:
```bash
dotnet restore
```

**Step 5: Run the application**

In the terminal:
```bash
dotnet run
```

Or press `F5` to run with debugging.

### Verify Installation

**Check 1: Project structure exists**
```bash
ls -la  # Linux/Mac
dir     # Windows
```

You should see:
- Controllers/ folder
- Views/ folder
- wwwroot/ folder
- Program.cs file
- PokemonMvcApp.csproj file

**Check 2: Application builds successfully**
```bash
dotnet build
```

Should show "Build succeeded" with 0 errors.

**Check 3: Application runs**
```bash
dotnet run
```

Should show "Now listening on" with URLs.

**Check 4: Browser access works**

Open `https://localhost:5001` - you should see the MVC welcome page with:
- Navigation menu (Home, Privacy)
- Welcome heading
- Bootstrap styling

---

## 6. Initial Setup & Configuration

### Understanding appsettings.json

The `appsettings.json` file contains configuration for your application.

**Default appsettings.json:**
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

**What each setting means:**

| Setting | Purpose | Values |
|---------|---------|--------|
| `Logging.LogLevel.Default` | How much to log | Trace, Debug, Information, Warning, Error, Critical |
| `Logging.LogLevel.Microsoft.AspNetCore` | ASP.NET Core logging | Usually Warning to reduce noise |
| `AllowedHosts` | Which hostnames can access the app | "*" = all, or specific domains |

**Add your own settings:**

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
    "ApplicationName": "Pokemon MVC App",
    "MaxItemsPerPage": 10,
    "EnableCache": true
  }
}
```

**Access in code:**

```csharp
// In Program.cs
var appName = builder.Configuration["AppSettings:ApplicationName"];

// Or using IConfiguration in controller
public class HomeController : Controller
{
    private readonly IConfiguration _configuration;

    public HomeController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public IActionResult Index()
    {
        var appName = _configuration["AppSettings:ApplicationName"];
        ViewData["AppName"] = appName;
        return View();
    }
}
```

### Customizing the Layout

The `Views/Shared/_Layout.cshtml` file is the master template for your site.

**Find the title:**
```cshtml
<title>@ViewData["Title"] - PokemonMvcApp</title>
```

**Customize the navigation:**
```cshtml
<nav class="navbar navbar-expand-sm navbar-toggleable-sm navbar-light bg-white border-bottom box-shadow mb-3">
    <div class="container-fluid">
        <a class="navbar-brand" asp-area="" asp-controller="Home" asp-action="Index">
            Pokemon MVC App  @* Changed this *@
        </a>
        <button class="navbar-toggler" ... >
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="navbar-collapse collapse d-sm-inline-flex justify-content-between">
            <ul class="navbar-nav flex-grow-1">
                <li class="nav-item">
                    <a class="nav-link text-dark" asp-area="" asp-controller="Home" asp-action="Index">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-dark" asp-area="" asp-controller="Pokemon" asp-action="Index">Pokemon</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-dark" asp-area="" asp-controller="Home" asp-action="Privacy">Privacy</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
```

**Customize the footer:**
```cshtml
<footer class="border-top footer text-muted">
    <div class="container">
        &copy; 2026 - Pokemon MVC App - <a asp-area="" asp-controller="Home" asp-action="Privacy">Privacy</a>
    </div>
</footer>
```

### Adding Custom CSS

**Edit wwwroot/css/site.css:**

```css
/* Custom Pokemon theme colors */
:root {
    --pokemon-red: #EE1515;
    --pokemon-blue: #3B4CCA;
    --pokemon-yellow: #FFDE00;
}

/* Custom navbar styling */
.navbar-brand {
    font-weight: bold;
    color: var(--pokemon-red) !important;
}

/* Custom button styling */
.btn-pokemon {
    background-color: var(--pokemon-red);
    color: white;
    border: none;
}

.btn-pokemon:hover {
    background-color: #cc0000;
    color: white;
}

/* Custom card styling */
.pokemon-card {
    border: 2px solid var(--pokemon-yellow);
    border-radius: 10px;
    padding: 20px;
    margin: 10px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}
```

### Configuring HTTPS

By default, MVC projects redirect HTTP to HTTPS for security.

**In Program.cs:**
```csharp
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();  // HTTP Strict Transport Security
}

app.UseHttpsRedirection();  // Redirects HTTP to HTTPS
```

**Development certificate:**

The first time you run the app, .NET creates a development HTTPS certificate.

If you see certificate warnings:
```bash
# Trust the development certificate
dotnet dev-certs https --trust
```

**Port configuration:**

Ports are configured in `Properties/launchSettings.json`:

```json
{
  "profiles": {
    "https": {
      "commandName": "Project",
      "launchBrowser": true,
      "applicationUrl": "https://localhost:5001;http://localhost:5000",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      }
    }
  }
}
```

You can change `5001` and `5000` to different ports if needed.

---

## 7. Basic Usage

### Running Your MVC Application

#### Method 1: Using the .NET CLI

**Simple run:**
```bash
dotnet run
```

This builds and runs the application. Press `Ctrl+C` to stop.

**Run with hot reload (auto-refresh on changes):**
```bash
dotnet watch run
```

When you save changes to .cs or .cshtml files, the app automatically recompiles and refreshes!

**Run on specific port:**
```bash
dotnet run --urls "https://localhost:7001;http://localhost:7000"
```

**Run in production mode:**
```bash
dotnet run --environment Production
```

#### Method 2: Using Visual Studio

**Debug mode (with breakpoints):**
1. Press `F5`, or
2. Click the green "Play" button, or
3. Menu: Debug → Start Debugging

**Run without debugging:**
1. Press `Ctrl+F5`, or
2. Menu: Debug → Start Without Debugging

**Stop the application:**
- Click the red "Stop" button, or
- Press `Shift+F5`

#### Method 3: Using Visual Studio Code

**Run with debugging:**
1. Press `F5`, or
2. Menu: Run → Start Debugging

**Run without debugging:**
1. Press `Ctrl+F5`, or
2. Use terminal: `dotnet run`

**Use watch mode for hot reload:**
```bash
dotnet watch run
```

### Accessing Your Application

**Default URLs:**
- HTTPS: `https://localhost:5001`
- HTTP: `http://localhost:5000`

**Available pages (default template):**
- Home page: `https://localhost:5001/`
- Privacy page: `https://localhost:5001/Home/Privacy`
- Error page: `https://localhost:5001/Home/Error` (only appears on actual errors)

### Navigating the Default Application

**Home Page (/):**
```
┌─────────────────────────────────────┐
│  Pokemon MVC App        Home Privacy│  ← Navigation
├─────────────────────────────────────┤
│                                     │
│         Welcome                     │  ← Main heading
│                                     │
│  Learn about building Web apps      │  ← Content
│  with ASP.NET Core                  │
│                                     │
└─────────────────────────────────────┘
```

**What you can do:**
- Click "Home" to go to the home page (/)
- Click "Privacy" to see the privacy page
- View the page source (Right-click → View Page Source) to see generated HTML

### Understanding the Default Pages

**HomeController.cs:**
```csharp
public class HomeController : Controller
{
    // Handles: / and /Home/Index
    public IActionResult Index()
    {
        return View();
    }

    // Handles: /Home/Privacy
    public IActionResult Privacy()
    {
        return View();
    }

    // Handles errors
    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
```

**Views/Home/Index.cshtml:**
```cshtml
@{
    ViewData["Title"] = "Home Page";
}

<div class="text-center">
    <h1 class="display-4">Welcome</h1>
    <p>Learn about <a href="https://docs.microsoft.com/aspnet/core">building Web apps with ASP.NET Core</a>.</p>
</div>
```

This view:
1. Sets the page title to "Home Page"
2. Creates a centered div
3. Displays "Welcome" as a large heading
4. Shows a paragraph with a link

### Making Your First Change

Let's customize the home page!

**Step 1: Open Views/Home/Index.cshtml**

**Step 2: Replace the content:**
```cshtml
@{
    ViewData["Title"] = "Pokemon Home";
}

<div class="text-center">
    <h1 class="display-4">Welcome to Pokemon MVC App</h1>
    <p>Your journey to becoming a Pokemon master starts here!</p>

    <div class="row mt-5">
        <div class="col-md-4">
            <h3>Catch Pokemon</h3>
            <p>Explore and catch your favorite Pokemon</p>
        </div>
        <div class="col-md-4">
            <h3>Train</h3>
            <p>Level up your Pokemon and make them stronger</p>
        </div>
        <div class="col-md-4">
            <h3>Battle</h3>
            <p>Challenge other trainers to become the best</p>
        </div>
    </div>
</div>
```

**Step 3: Save the file**

**Step 4: Refresh your browser**

If using `dotnet watch run`, the page updates automatically!
Otherwise, refresh the browser manually (F5).

You should now see your customized Pokemon-themed home page!

### Viewing Generated HTML

**In browser:**
1. Right-click on the page
2. Select "View Page Source" or "Inspect"
3. Look at the HTML structure

**What you'll see:**

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Pokemon Home - Pokemon MVC App</title>
    <link rel="stylesheet" href="/lib/bootstrap/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="/css/site.css" />
</head>
<body>
    <header>
        <nav class="navbar...">
            <!-- Navigation from _Layout.cshtml -->
        </nav>
    </header>
    <div class="container">
        <main role="main" class="pb-3">
            <!-- Your Index.cshtml content inserted here -->
            <div class="text-center">
                <h1 class="display-4">Welcome to Pokemon MVC App</h1>
                ...
            </div>
        </main>
    </div>
    <footer>
        <!-- Footer from _Layout.cshtml -->
    </footer>
    <script src="/lib/jquery/dist/jquery.min.js"></script>
    <script src="/lib/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/site.js"></script>
</body>
</html>
```

**Notice:**
- Complete HTML structure (even though you didn't write it)
- Layout from _Layout.cshtml wraps your view content
- CSS and JavaScript files are included
- Your view content is inserted into the `<main>` section

---

## 8. Testing & Validation

### How to Test Your MVC Application

#### Method 1: Browser Testing (Manual)

**Basic functionality test:**

1. **Start the application**
   ```bash
   dotnet run
   ```

2. **Open browser to `https://localhost:5001`**

3. **Check home page loads:**
   - Page displays without errors
   - Navigation menu appears
   - Content is visible
   - Styles are applied (Bootstrap styling visible)

4. **Test navigation:**
   - Click "Home" - should stay on home page
   - Click "Privacy" - should navigate to /Home/Privacy
   - Use browser back button - should return to previous page

5. **Test responsiveness:**
   - Resize browser window
   - Menu should collapse to hamburger icon on mobile size
   - Content should reflow appropriately

6. **Check browser console:**
   - Press F12 to open Developer Tools
   - Go to Console tab
   - Should see no errors (red messages)

**Expected behavior:**
- All pages load in under 1 second
- No 404 errors
- CSS and JavaScript files load successfully
- Images display correctly
- Links work and navigate to correct pages

#### Method 2: Testing Static Files

**Check CSS is loading:**

1. Navigate to `https://localhost:5001/css/site.css` directly
2. You should see the CSS file contents
3. If you get 404, static files aren't configured

**Check JavaScript is loading:**

1. Navigate to `https://localhost:5001/js/site.js`
2. Should see JavaScript code
3. Check browser console for any JS errors

**Test custom static file:**

1. Add an image to `wwwroot/images/pikachu.png`
2. Navigate to `https://localhost:5001/images/pikachu.png`
3. Image should display

#### Method 3: Using Browser Developer Tools

**Network tab inspection:**

1. Open Developer Tools (F12)
2. Go to Network tab
3. Refresh the page (F5)
4. Check all requests:
   - Main document: 200 OK
   - CSS files: 200 OK
   - JS files: 200 OK
   - Fonts: 200 OK

**Elements tab inspection:**

1. Right-click on page element
2. Select "Inspect"
3. See the HTML structure
4. Hover over elements to see their bounding boxes
5. Edit HTML/CSS in real-time to test changes

### Common Validation Checks

**Check 1: Application starts successfully**
```bash
dotnet run
```

Expected output includes:
```
Now listening on: https://localhost:5001
Application started
```

**Check 2: No build errors**
```bash
dotnet build
```

Expected: "Build succeeded" with 0 errors.

**Check 3: Routes are working**

Test these URLs:
- `https://localhost:5001/` → Home page (200 OK)
- `https://localhost:5001/Home/Index` → Home page (200 OK)
- `https://localhost:5001/Home/Privacy` → Privacy page (200 OK)
- `https://localhost:5001/NotExists` → Error page or 404

**Check 4: Layout is applied**

View page source and verify:
- DOCTYPE is present
- HTML structure is complete
- Navigation menu exists
- Footer exists
- CSS files are linked

**Check 5: wwwroot files are accessible**

Test direct access:
- `/css/site.css` → CSS content
- `/js/site.js` → JavaScript content
- `/lib/bootstrap/dist/css/bootstrap.min.css` → Bootstrap CSS

### Hands-On Exercises

#### Exercise 1: Create Your First Page (Beginner Level)

**Objective:** Create a new page in your MVC application from scratch

**Task:**
Create an "About" page that displays information about your Pokemon app.

**Requirements:**
1. Add an `About()` action method to `HomeController`
2. Create a corresponding view at `Views/Home/About.cshtml`
3. Add a link to the About page in the navigation menu
4. The page should display:
   - A heading "About Pokemon MVC App"
   - A paragraph describing the app
   - Your name as the creator

**Hints:**
- Action methods return `View()`
- Views go in the folder matching the controller name
- Use tag helpers for navigation: `asp-controller="Home" asp-action="About"`

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Add action method to Controllers/HomeController.cs:**
```csharp
public class HomeController : Controller
{
    public IActionResult Index()
    {
        return View();
    }

    // Add this new action
    public IActionResult About()
    {
        return View();
    }

    public IActionResult Privacy()
    {
        return View();
    }

    // ... rest of controller
}
```

**Step 2: Create Views/Home/About.cshtml:**
```cshtml
@{
    ViewData["Title"] = "About";
}

<div class="text-center">
    <h1>About Pokemon MVC App</h1>

    <div class="mt-4">
        <p>This application is designed to help you learn ASP.NET Core MVC by building a Pokemon management system.</p>

        <p>Through this app, you'll learn:</p>
        <ul class="text-start" style="max-width: 400px; margin: 0 auto;">
            <li>Creating controllers and views</li>
            <li>Working with models and data</li>
            <li>Building forms and handling input</li>
            <li>Using Entity Framework Core</li>
        </ul>

        <p class="mt-4">
            <strong>Created by:</strong> [Your Name]<br>
            <strong>Version:</strong> 1.0
        </p>
    </div>
</div>
```

**Step 3: Add navigation link in Views/Shared/_Layout.cshtml:**

Find the navbar section and add:
```cshtml
<ul class="navbar-nav flex-grow-1">
    <li class="nav-item">
        <a class="nav-link text-dark" asp-area="" asp-controller="Home" asp-action="Index">Home</a>
    </li>
    <li class="nav-item">
        <a class="nav-link text-dark" asp-area="" asp-controller="Home" asp-action="About">About</a>
    </li>
    <li class="nav-item">
        <a class="nav-link text-dark" asp-area="" asp-controller="Home" asp-action="Privacy">Privacy</a>
    </li>
</ul>
```

**Step 4: Test:**
1. Run the app: `dotnet run`
2. Navigate to `https://localhost:5001/Home/About`
3. Click the "About" link in the navigation
4. Verify the page displays correctly

</details>

---

#### Exercise 2: Pass Data to a View (Intermediate Level)

**Objective:** Learn to pass data from a controller to a view

**Task:**
Create a "Stats" page that displays dynamic information about your Pokemon app.

**Requirements:**
1. Create a `Stats()` action in `HomeController`
2. Pass the following data to the view using ViewData or ViewBag:
   - Total number of Pokemon (use a fake number for now)
   - Total number of trainers
   - Current date and time
3. Create a view that displays this information in a nice layout
4. Add navigation link to the Stats page

**Hints:**
- Use `ViewData["Key"] = value` or `ViewBag.Property = value`
- Access in view: `@ViewData["Key"]` or `@ViewBag.Property`
- Use `DateTime.Now` for current date/time
- Format dates with `.ToString("MMMM dd, yyyy")`

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Add action method to Controllers/HomeController.cs:**
```csharp
public IActionResult Stats()
{
    // Pass data using ViewData
    ViewData["TotalPokemon"] = 151;
    ViewData["TotalTrainers"] = 42;
    ViewData["CurrentDate"] = DateTime.Now.ToString("MMMM dd, yyyy");
    ViewData["CurrentTime"] = DateTime.Now.ToString("hh:mm:ss tt");

    // Alternative: Using ViewBag (dynamic)
    // ViewBag.TotalPokemon = 151;
    // ViewBag.TotalTrainers = 42;

    return View();
}
```

**Step 2: Create Views/Home/Stats.cshtml:**
```cshtml
@{
    ViewData["Title"] = "Statistics";
}

<div class="container">
    <h1 class="text-center mb-4">Pokemon App Statistics</h1>

    <div class="row">
        <div class="col-md-6">
            <div class="card mb-3">
                <div class="card-body text-center">
                    <h2 class="display-3 text-primary">@ViewData["TotalPokemon"]</h2>
                    <p class="lead">Total Pokemon</p>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card mb-3">
                <div class="card-body text-center">
                    <h2 class="display-3 text-success">@ViewData["TotalTrainers"]</h2>
                    <p class="lead">Total Trainers</p>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <h5 class="card-title">Last Updated</h5>
            <p class="card-text">
                <strong>Date:</strong> @ViewData["CurrentDate"]<br>
                <strong>Time:</strong> @ViewData["CurrentTime"]
            </p>
        </div>
    </div>
</div>
```

**Step 3: Add navigation link in _Layout.cshtml:**
```cshtml
<li class="nav-item">
    <a class="nav-link text-dark" asp-area="" asp-controller="Home" asp-action="Stats">Stats</a>
</li>
```

**Step 4: Test:**
1. Run the app
2. Navigate to /Home/Stats
3. Verify data displays correctly
4. Refresh page - time should update

</details>

---

#### Exercise 3: Create a New Controller (Challenge Level)

**Objective:** Build a complete controller with multiple views

**Task:**
Create a Pokemon controller with pages to list, view, and add Pokemon.

**Requirements:**
1. Create a new controller: `PokemonController`
2. Add three action methods:
   - `Index()` - List all Pokemon
   - `Details(int id)` - Show details of one Pokemon
   - `Create()` - Form to add new Pokemon
3. Create corresponding views for each action
4. Use fake data (hard-coded list) for now
5. Add "Pokemon" link to main navigation

**Bonus Challenges:**
- Add Bootstrap cards to display Pokemon nicely
- Include Pokemon type colors
- Add images (use placeholder images)
- Create a strongly-typed model class

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Create Models/Pokemon.cs:**
```csharp
namespace PokemonMvcApp.Models
{
    public class Pokemon
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public int Level { get; set; }
        public int HP { get; set; }
    }
}
```

**Step 2: Create Controllers/PokemonController.cs:**
```csharp
using Microsoft.AspNetCore.Mvc;
using PokemonMvcApp.Models;

namespace PokemonMvcApp.Controllers
{
    public class PokemonController : Controller
    {
        // Fake data - in real app, this would come from database
        private static List<Pokemon> _pokemonList = new List<Pokemon>
        {
            new Pokemon { Id = 1, Name = "Bulbasaur", Type = "Grass", Level = 5, HP = 45 },
            new Pokemon { Id = 2, Name = "Charmander", Type = "Fire", Level = 5, HP = 39 },
            new Pokemon { Id = 3, Name = "Squirtle", Type = "Water", Level = 5, HP = 44 },
            new Pokemon { Id = 25, Name = "Pikachu", Type = "Electric", Level = 10, HP = 35 }
        };

        // GET: /Pokemon
        public IActionResult Index()
        {
            return View(_pokemonList);
        }

        // GET: /Pokemon/Details/5
        public IActionResult Details(int id)
        {
            var pokemon = _pokemonList.FirstOrDefault(p => p.Id == id);

            if (pokemon == null)
            {
                return NotFound();
            }

            return View(pokemon);
        }

        // GET: /Pokemon/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: /Pokemon/Create
        [HttpPost]
        public IActionResult Create(Pokemon pokemon)
        {
            if (ModelState.IsValid)
            {
                // Generate new ID
                pokemon.Id = _pokemonList.Max(p => p.Id) + 1;

                // Add to list
                _pokemonList.Add(pokemon);

                // Redirect to Index
                return RedirectToAction(nameof(Index));
            }

            return View(pokemon);
        }
    }
}
```

**Step 3: Create Views/Pokemon/Index.cshtml:**
```cshtml
@model List<PokemonMvcApp.Models.Pokemon>

@{
    ViewData["Title"] = "Pokemon List";
}

<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Pokemon List</h1>
        <a asp-action="Create" class="btn btn-primary">Add New Pokemon</a>
    </div>

    <div class="row">
        @foreach (var pokemon in Model)
        {
            <div class="col-md-4 mb-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">@pokemon.Name</h5>
                        <p class="card-text">
                            <strong>Type:</strong> @pokemon.Type<br>
                            <strong>Level:</strong> @pokemon.Level<br>
                            <strong>HP:</strong> @pokemon.HP
                        </p>
                        <a asp-action="Details" asp-route-id="@pokemon.Id" class="btn btn-sm btn-info">View Details</a>
                    </div>
                </div>
            </div>
        }
    </div>
</div>
```

**Step 4: Create Views/Pokemon/Details.cshtml:**
```cshtml
@model PokemonMvcApp.Models.Pokemon

@{
    ViewData["Title"] = Model.Name;
}

<div class="container">
    <div class="mb-3">
        <a asp-action="Index" class="btn btn-secondary">← Back to List</a>
    </div>

    <div class="card">
        <div class="card-header">
            <h2>@Model.Name</h2>
        </div>
        <div class="card-body">
            <dl class="row">
                <dt class="col-sm-3">ID</dt>
                <dd class="col-sm-9">@Model.Id</dd>

                <dt class="col-sm-3">Name</dt>
                <dd class="col-sm-9">@Model.Name</dd>

                <dt class="col-sm-3">Type</dt>
                <dd class="col-sm-9">@Model.Type</dd>

                <dt class="col-sm-3">Level</dt>
                <dd class="col-sm-9">@Model.Level</dd>

                <dt class="col-sm-3">HP</dt>
                <dd class="col-sm-9">@Model.HP</dd>
            </dl>
        </div>
    </div>
</div>
```

**Step 5: Create Views/Pokemon/Create.cshtml:**
```cshtml
@model PokemonMvcApp.Models.Pokemon

@{
    ViewData["Title"] = "Create Pokemon";
}

<div class="container">
    <h1>Create New Pokemon</h1>

    <form asp-action="Create" method="post">
        <div class="form-group mb-3">
            <label asp-for="Name" class="form-label"></label>
            <input asp-for="Name" class="form-control" />
        </div>

        <div class="form-group mb-3">
            <label asp-for="Type" class="form-label"></label>
            <select asp-for="Type" class="form-control">
                <option value="">Select Type</option>
                <option value="Grass">Grass</option>
                <option value="Fire">Fire</option>
                <option value="Water">Water</option>
                <option value="Electric">Electric</option>
                <option value="Psychic">Psychic</option>
                <option value="Normal">Normal</option>
            </select>
        </div>

        <div class="form-group mb-3">
            <label asp-for="Level" class="form-label"></label>
            <input asp-for="Level" type="number" class="form-control" />
        </div>

        <div class="form-group mb-3">
            <label asp-for="HP" class="form-label"></label>
            <input asp-for="HP" type="number" class="form-control" />
        </div>

        <div class="form-group">
            <button type="submit" class="btn btn-primary">Create</button>
            <a asp-action="Index" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>
```

**Step 6: Add navigation link in _Layout.cshtml:**
```cshtml
<li class="nav-item">
    <a class="nav-link text-dark" asp-area="" asp-controller="Pokemon" asp-action="Index">Pokemon</a>
</li>
```

**Step 7: Test the complete functionality:**
1. Navigate to /Pokemon - see the list
2. Click "View Details" on any Pokemon
3. Click "Add New Pokemon" and fill out the form
4. Submit and verify new Pokemon appears in list
5. Test all navigation links

</details>

---

### Self-Assessment Checklist

After completing this guide, you should be able to:

- [ ] Create a new MVC project using `dotnet new mvc`
- [ ] Understand the purpose of each folder (Controllers, Views, wwwroot, Models)
- [ ] Explain what Program.cs does
- [ ] Run an MVC application from CLI and IDE
- [ ] Navigate the default MVC template
- [ ] Create new controller action methods
- [ ] Create corresponding views for actions
- [ ] Pass data from controller to view using ViewData/ViewBag
- [ ] Use Razor syntax to display data in views
- [ ] Modify the layout and navigation
- [ ] Add custom CSS styling
- [ ] Understand URL routing patterns
- [ ] Test your application in a browser
- [ ] Use browser developer tools to debug
- [ ] Add static files to wwwroot and reference them

**If you can't check all these boxes:**
- Review the sections where you're struggling
- Complete the hands-on exercises
- Create a practice project from scratch
- Ask for help in the community resources

---

## 9. Practical Examples

### Example 1: Simple Contact Page (Beginner)

**Scenario:**
Create a contact page with static information.

**Code:**

**Controllers/HomeController.cs:**
```csharp
public IActionResult Contact()
{
    ViewData["Title"] = "Contact Us";
    return View();
}
```

**Views/Home/Contact.cshtml:**
```cshtml
@{
    ViewData["Title"] = "Contact Us";
}

<div class="container">
    <h1>Contact Us</h1>

    <div class="row mt-4">
        <div class="col-md-6">
            <h3>Get in Touch</h3>
            <p>Have questions about Pokemon or our app? We'd love to hear from you!</p>

            <ul class="list-unstyled">
                <li><strong>Email:</strong> support@pokemonapp.com</li>
                <li><strong>Phone:</strong> (555) 123-4567</li>
                <li><strong>Address:</strong> 123 Pallet Town, Kanto Region</li>
            </ul>
        </div>

        <div class="col-md-6">
            <h3>Office Hours</h3>
            <table class="table">
                <tr>
                    <td>Monday - Friday</td>
                    <td>9:00 AM - 5:00 PM</td>
                </tr>
                <tr>
                    <td>Saturday</td>
                    <td>10:00 AM - 2:00 PM</td>
                </tr>
                <tr>
                    <td>Sunday</td>
                    <td>Closed</td>
                </tr>
            </table>
        </div>
    </div>
</div>
```

**Result:**
A clean contact page with business information laid out in columns.

---

### Example 2: Dynamic Dashboard (Intermediate)

**Scenario:**
Create a dashboard that shows different content based on time of day.

**Code:**

**Controllers/HomeController.cs:**
```csharp
public IActionResult Dashboard()
{
    var currentHour = DateTime.Now.Hour;

    // Determine greeting based on time
    string greeting;
    if (currentHour < 12)
        greeting = "Good Morning";
    else if (currentHour < 18)
        greeting = "Good Afternoon";
    else
        greeting = "Good Evening";

    ViewData["Greeting"] = greeting;
    ViewData["CurrentTime"] = DateTime.Now.ToString("hh:mm tt");
    ViewData["IsWeekend"] = DateTime.Now.DayOfWeek == DayOfWeek.Saturday ||
                            DateTime.Now.DayOfWeek == DayOfWeek.Sunday;

    // Sample statistics
    ViewBag.TotalPokemon = 151;
    ViewBag.CaughtPokemon = 73;
    ViewBag.BadgesEarned = 5;

    return View();
}
```

**Views/Home/Dashboard.cshtml:**
```cshtml
@{
    ViewData["Title"] = "Dashboard";
    var percentCaught = (ViewBag.CaughtPokemon * 100.0 / ViewBag.TotalPokemon).ToString("F1");
}

<div class="container">
    <div class="jumbotron bg-light p-4 rounded">
        <h1>@ViewData["Greeting"], Trainer!</h1>
        <p class="lead">Current Time: @ViewData["CurrentTime"]</p>

        @if ((bool)ViewData["IsWeekend"])
        {
            <div class="alert alert-success">
                <strong>It's the weekend!</strong> Perfect time for Pokemon training!
            </div>
        }
    </div>

    <div class="row mt-4">
        <div class="col-md-4">
            <div class="card text-center">
                <div class="card-body">
                    <h2 class="display-4">@ViewBag.CaughtPokemon</h2>
                    <p>of @ViewBag.TotalPokemon Pokemon Caught</p>
                    <div class="progress">
                        <div class="progress-bar bg-success" style="width: @percentCaught%"></div>
                    </div>
                    <small>@percentCaught% Complete</small>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card text-center">
                <div class="card-body">
                    <h2 class="display-4">@ViewBag.BadgesEarned</h2>
                    <p>Gym Badges Earned</p>
                    <small>3 more to go!</small>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card text-center">
                <div class="card-body">
                    <h2 class="display-4">@(ViewBag.TotalPokemon - ViewBag.CaughtPokemon)</h2>
                    <p>Pokemon Remaining</p>
                    <small>Keep exploring!</small>
                </div>
            </div>
        </div>
    </div>
</div>
```

**Result:**
A dynamic dashboard that changes greeting based on time of day, shows weekend message, and displays progress statistics.

---

### Example 3: Reusable Partial Views (Advanced)

**Scenario:**
Create a reusable Pokemon card component that can be used throughout the app.

**Code:**

**Step 1: Create Views/Shared/_PokemonCard.cshtml:**
```cshtml
@model PokemonMvcApp.Models.Pokemon

<div class="card pokemon-card mb-3">
    <div class="card-header bg-@Model.Type.ToLower()">
        <h5 class="mb-0 text-white">@Model.Name</h5>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-6">
                <small class="text-muted">Type</small>
                <p class="mb-1"><strong>@Model.Type</strong></p>
            </div>
            <div class="col-6">
                <small class="text-muted">Level</small>
                <p class="mb-1"><strong>@Model.Level</strong></p>
            </div>
        </div>
        <div class="mt-2">
            <small class="text-muted">HP</small>
            <div class="progress">
                <div class="progress-bar bg-danger" style="width: @((Model.HP * 100 / 150))%">
                    @Model.HP
                </div>
            </div>
        </div>
    </div>
    <div class="card-footer">
        <a asp-controller="Pokemon" asp-action="Details" asp-route-id="@Model.Id" class="btn btn-sm btn-primary">
            View Details
        </a>
    </div>
</div>
```

**Step 2: Add CSS to wwwroot/css/site.css:**
```css
.pokemon-card {
    transition: transform 0.2s;
}

.pokemon-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
}

.bg-grass { background-color: #78C850 !important; }
.bg-fire { background-color: #F08030 !important; }
.bg-water { background-color: #6890F0 !important; }
.bg-electric { background-color: #F8D030 !important; }
.bg-normal { background-color: #A8A878 !important; }
```

**Step 3: Use the partial view in Views/Pokemon/Index.cshtml:**
```cshtml
@model List<PokemonMvcApp.Models.Pokemon>

@{
    ViewData["Title"] = "Pokemon List";
}

<div class="container">
    <h1>Pokemon Collection</h1>

    <div class="row mt-4">
        @foreach (var pokemon in Model)
        {
            <div class="col-md-4">
                @* Use the reusable partial view *@
                <partial name="_PokemonCard" model="pokemon" />
            </div>
        }
    </div>
</div>
```

**Result:**
Consistent, reusable Pokemon cards throughout the application with type-based colors and hover effects.

---

## 10. Common Patterns & Best Practices

### Recommended Patterns

#### Pattern 1: Repository Pattern (Preview)

**Description:**
Separate data access logic from business logic by using repository classes.

**Structure:**
```
Models/
  └── Pokemon.cs
Repositories/
  ├── IPokemonRepository.cs
  └── PokemonRepository.cs
Controllers/
  └── PokemonController.cs
```

**Why it's good:**
- Easier to test (can mock the repository)
- Easier to change data source later
- Keeps controllers thin and focused

#### Pattern 2: Strongly-Typed Views

**Description:**
Always use strongly-typed models in views instead of ViewData/ViewBag when possible.

**Bad:**
```csharp
// Controller
ViewData["PokemonName"] = "Pikachu";
ViewData["PokemonType"] = "Electric";

// View
<h1>@ViewData["PokemonName"]</h1>
<p>@ViewData["PokemonType"]</p>
```

**Good:**
```csharp
// Controller
var pokemon = new Pokemon { Name = "Pikachu", Type = "Electric" };
return View(pokemon);

// View
@model Pokemon
<h1>@Model.Name</h1>
<p>@Model.Type</p>
```

**Why it's better:**
- Compile-time type checking
- IntelliSense support
- Easier refactoring
- Self-documenting code

#### Pattern 3: Layout and Partial Views

**Description:**
Use `_Layout.cshtml` for consistent page structure and partial views for reusable components.

**Layout structure:**
```cshtml
<!DOCTYPE html>
<html>
<head>
    <title>@ViewData["Title"] - Pokemon App</title>
    @* Common CSS *@
</head>
<body>
    <header>
        @* Navigation *@
    </header>

    <main>
        @RenderBody()  @* Page content goes here *@
    </main>

    <footer>
        @* Footer content *@
    </footer>

    @* Common JavaScript *@
    @await RenderSectionAsync("Scripts", required: false)
</body>
</html>
```

**Using sections in views:**
```cshtml
@section Scripts {
    <script src="~/js/pokemon-specific.js"></script>
}
```

### Do's and Don'ts

#### Do's

- ✅ **Use meaningful names for controllers and actions**
  ```csharp
  // Good
  public IActionResult Details(int id)

  // Bad
  public IActionResult D(int x)
  ```

- ✅ **Keep controllers thin - business logic belongs in services**
  ```csharp
  // Good
  public class PokemonController : Controller
  {
      private readonly IPokemonService _service;

      public IActionResult Index()
      {
          var pokemon = _service.GetAll();
          return View(pokemon);
      }
  }

  // Bad - too much logic in controller
  public IActionResult Index()
  {
      using var connection = new SqlConnection(connectionString);
      connection.Open();
      var command = new SqlCommand("SELECT * FROM Pokemon", connection);
      // ... lots of data access code
  }
  ```

- ✅ **Use tag helpers instead of HTML helpers**
  ```cshtml
  @* Good - Tag Helpers *@
  <a asp-controller="Pokemon" asp-action="Details" asp-route-id="@pokemon.Id">View</a>

  @* Old style - HTML Helpers *@
  @Html.ActionLink("View", "Details", "Pokemon", new { id = pokemon.Id })
  ```

- ✅ **Organize views in folders matching controllers**
  ```
  Views/
    Pokemon/
      Index.cshtml
      Details.cshtml
    Home/
      Index.cshtml
  ```

- ✅ **Use partial views for reusable components**
  ```cshtml
  <partial name="_PokemonCard" model="pokemon" />
  ```

#### Don'ts

- ❌ **Don't put business logic in views**
  - **Instead:** Keep views simple, do logic in controllers or services
  ```cshtml
  @* Bad *@
  @{
      var totalPrice = 0;
      foreach(var item in Model)
      {
          totalPrice += item.Price * item.Quantity;
      }
  }

  @* Good *@
  @Model.TotalPrice  @* Calculated in controller or model *@
  ```

- ❌ **Don't use magic strings**
  - **Instead:** Use `nameof()` for action/controller names
  ```csharp
  // Bad
  return RedirectToAction("Index", "Home");

  // Good
  return RedirectToAction(nameof(Index), nameof(HomeController));
  ```

- ❌ **Don't return views from other controllers' folders**
  - **Instead:** Keep views organized by controller
  ```csharp
  // Bad - Pokemon controller returning Home view
  public class PokemonController : Controller
  {
      public IActionResult Index()
      {
          return View("~/Views/Home/Index.cshtml");
      }
  }
  ```

- ❌ **Don't duplicate layout code in every view**
  - **Instead:** Use _Layout.cshtml

- ❌ **Don't put sensitive data in views or client-side code**
  - **Instead:** Keep sensitive logic server-side

### Project Organization Best Practices

**Recommended structure:**
```
PokemonMvcApp/
├── Controllers/
│   ├── HomeController.cs
│   ├── PokemonController.cs
│   └── AccountController.cs
├── Models/
│   ├── Pokemon.cs
│   ├── Trainer.cs
│   └── ViewModels/        # Models specific to views
│       └── PokemonListViewModel.cs
├── Views/
│   ├── Home/
│   ├── Pokemon/
│   ├── Shared/
│   │   ├── _Layout.cshtml
│   │   ├── _PokemonCard.cshtml  # Reusable partials
│   │   └── Error.cshtml
│   ├── _ViewImports.cshtml
│   └── _ViewStart.cshtml
├── wwwroot/
│   ├── css/
│   │   ├── site.css
│   │   └── pokemon.css
│   ├── js/
│   │   ├── site.js
│   │   └── pokemon.js
│   ├── images/
│   └── lib/              # Third-party libraries
├── Services/             # Business logic (add later)
├── Data/                 # Database context (add later)
├── appsettings.json
└── Program.cs
```

---

## 11. Troubleshooting & Common Issues

### Frequently Encountered Problems

#### Problem 1: "Unable to bind to https://localhost:5001"

**Symptoms:**
- Error when starting application
- Message about port already in use
- Application won't start

**Cause:**
Another application is already using port 5001, or a previous instance didn't shut down properly.

**Solution:**

**Option 1: Kill the process using the port**

**Windows:**
```powershell
# Find process using port 5001
netstat -ano | findstr :5001

# Kill the process (replace PID with actual process ID)
taskkill /PID <PID> /F
```

**Mac/Linux:**
```bash
# Find process using port 5001
lsof -i :5001

# Kill the process
kill -9 <PID>
```

**Option 2: Change the port**

Edit `Properties/launchSettings.json`:
```json
{
  "profiles": {
    "https": {
      "applicationUrl": "https://localhost:7001;http://localhost:7000"
    }
  }
}
```

---

#### Problem 2: 404 Not Found on Views

**Symptoms:**
- Controller action executes successfully
- Returns `View()`
- Browser shows "404 Not Found"

**Cause:**
View file doesn't exist or is in wrong location.

**Solution:**

**Check 1: Verify view file exists**

For action `Index` in `PokemonController`:
- File must be at: `Views/Pokemon/Index.cshtml`
- NOT: `Views/PokemonController/Index.cshtml`
- NOT: `Views/Pokemon/Index.cs`

**Check 2: Check view name matches action**
```csharp
// If action is named Details
public IActionResult Details(int id)
{
    return View();  // Looks for Details.cshtml
}
```

**Check 3: If using custom view name**
```csharp
// Specify full path
return View("~/Views/Pokemon/CustomView.cshtml");

// Or relative view name
return View("CustomView");  // Looks in Views/Pokemon/ folder
```

**Check 4: Check ViewStart is present**

Ensure `Views/_ViewStart.cshtml` exists:
```cshtml
@{
    Layout = "_Layout";
}
```

---

#### Problem 3: CSS/JavaScript Not Loading (404)

**Symptoms:**
- Page loads but styles don't apply
- Browser console shows 404 errors for CSS/JS files
- Page looks unstyled

**Cause:**
Static files not configured or referenced incorrectly.

**Solution:**

**Check 1: Verify UseStaticFiles is called**

In `Program.cs`:
```csharp
app.UseStaticFiles();  // Must be present
```

**Check 2: Verify files are in wwwroot**

```
wwwroot/
├── css/
│   └── site.css      # ✓ Correct location
├── js/
│   └── site.js       # ✓ Correct location
```

NOT:
```
css/                  # ✗ Wrong - must be in wwwroot
  └── site.css
```

**Check 3: Use ~ for wwwroot references**

```cshtml
@* Correct *@
<link rel="stylesheet" href="~/css/site.css" />
<script src="~/js/site.js"></script>

@* Wrong *@
<link rel="stylesheet" href="/wwwroot/css/site.css" />
<link rel="stylesheet" href="css/site.css" />
```

**Check 4: Check browser network tab**
1. Open browser DevTools (F12)
2. Go to Network tab
3. Refresh page
4. Look for failed requests (red)
5. Check the URL being requested

---

#### Problem 4: "Cannot access a disposed object"

**Symptoms:**
- Error when trying to use a service or database context
- Happens after navigation or on subsequent requests

**Cause:**
Trying to use a disposed object, usually from incorrect service lifetime.

**Solution:**

**Register services with correct lifetime:**

```csharp
// Program.cs
// Scoped = new instance per request (most common)
builder.Services.AddScoped<IPokemonService, PokemonService>();

// Transient = new instance every time
builder.Services.AddTransient<IEmailService, EmailService>();

// Singleton = one instance for entire application lifetime
builder.Services.AddSingleton<IConfiguration>(builder.Configuration);
```

**Don't store scoped services in singletons:**
```csharp
// Bad - DbContext is scoped but stored in singleton
public class MySingleton
{
    private readonly MyDbContext _context;  // ✗ Will be disposed
}
```

---

#### Problem 5: Changes Not Appearing in Browser

**Symptoms:**
- You make changes to code
- Rebuild and run
- Changes don't appear in browser

**Cause:**
Browser caching or old build artifacts.

**Solution:**

**Step 1: Hard refresh browser**
- Chrome/Edge: `Ctrl+Shift+R` or `Ctrl+F5`
- Firefox: `Ctrl+Shift+R`
- Mac: `Cmd+Shift+R`

**Step 2: Clear browser cache**
1. Open DevTools (F12)
2. Right-click refresh button
3. Select "Empty Cache and Hard Reload"

**Step 3: Clean and rebuild**
```bash
dotnet clean
dotnet build
dotnet run
```

**Step 4: Check you're editing the right file**
- Verify file path is correct
- Check you're not editing a file in bin/ or obj/ folders

**Step 5: Use watch mode**
```bash
dotnet watch run
```

This automatically rebuilds and refreshes when files change.

---

#### Problem 6: "The name 'Model' does not exist in the current context"

**Symptoms:**
- Razor view shows compile error
- Error mentions 'Model' not existing
- Happens when trying to use `@Model`

**Cause:**
View doesn't have a `@model` directive declaring the model type.

**Solution:**

**Add @model directive at top of view:**

```cshtml
@* Add this at the very top *@
@model PokemonMvcApp.Models.Pokemon

@* Now you can use Model *@
<h1>@Model.Name</h1>
<p>@Model.Type</p>
```

**For collections:**
```cshtml
@model List<PokemonMvcApp.Models.Pokemon>

@foreach(var pokemon in Model)
{
    <p>@pokemon.Name</p>
}
```

**Check controller is passing the model:**
```csharp
public IActionResult Details(int id)
{
    var pokemon = GetPokemon(id);
    return View(pokemon);  // ✓ Passing model to view
}
```

---

### Error Messages Explained

| Error Message | Meaning | Solution |
|---------------|---------|----------|
| `InvalidOperationException: The view 'Index' was not found` | View file missing or misnamed | Create view file in correct location |
| `NullReferenceException` | Trying to access property of null object | Check if model/object is null before using |
| `InvalidOperationException: Unable to resolve service` | Service not registered in DI container | Add service registration in Program.cs |
| `IOException: The process cannot access the file` | File is locked or in use | Close file or restart application |
| `InvalidOperationException: Cannot access a disposed object` | Using disposed service/context | Check service lifetimes (scoped/transient/singleton) |
| `HttpException: 404` | Route/action/view not found | Verify URL, controller name, action name |
| `Compilation error` in view | Syntax error in Razor code | Check @ syntax, missing semicolons, brackets |

### Where to Get Help

- **Official ASP.NET Documentation**: [docs.microsoft.com/aspnet/core](https://docs.microsoft.com/aspnet/core)
- **Microsoft Q&A**: [docs.microsoft.com/answers](https://docs.microsoft.com/answers/topics/dotnet-aspnetcore.html)
- **Stack Overflow**: Tag [`asp.net-core-mvc`]
- **.NET Discord**: [discord.gg/dotnet](https://discord.gg/dotnet)
- **Reddit**: [r/dotnet](https://reddit.com/r/dotnet), [r/csharp](https://reddit.com/r/csharp)
- **GitHub Discussions**: [dotnet/aspnetcore discussions](https://github.com/dotnet/aspnetcore/discussions)

---

## 12. Additional Resources

### Official Documentation

- [ASP.NET Core MVC Overview](https://docs.microsoft.com/aspnet/core/mvc/overview)
- [Razor Syntax Reference](https://docs.microsoft.com/aspnet/core/mvc/views/razor)
- [Tutorial: Get started with ASP.NET Core MVC](https://docs.microsoft.com/aspnet/core/tutorials/first-mvc-app/)
- [.NET CLI Reference](https://docs.microsoft.com/dotnet/core/tools/)

### Recommended Tutorials

- [Microsoft Learn: Create web apps with ASP.NET Core](https://docs.microsoft.com/learn/paths/create-web-apps-with-aspnet-core/)
- [.NET MVC Tutorial for Beginners](https://www.youtube.com/watch?v=hZ1DASYd9rk) - FreeCodeCamp
- [ASP.NET Core MVC Crash Course](https://www.youtube.com/watch?v=_8nqpYTK8-0) - Traversy Media

### Books

- **Pro ASP.NET Core 7** by Adam Freeman - Comprehensive guide to ASP.NET Core MVC
- **ASP.NET Core in Action** by Andrew Lock - Practical guide with real-world examples

### Community Resources

- [AwesomeAspNetCore](https://github.com/thangchung/awesome-dotnet-core) - Curated list of ASP.NET Core resources
- [.NET Foundation](https://dotnetfoundation.org/) - Community projects and resources
- [Weekly .NET Newsletter](https://www.dotnetweekly.com/) - Stay updated with .NET news

### Related Technologies

- **Razor Pages** - Simpler page-based programming model for ASP.NET Core
- **Blazor** - Build interactive web UIs using C# instead of JavaScript
- **ASP.NET Core Web API** - Build HTTP services (covered in other guides)
- **Entity Framework Core** - Database access (covered in later guides)

### Next Steps

After mastering MVC project creation, continue with:

1. **Models and Data** - Learn to create models and work with data
2. **Entity Framework Core** - Connect your MVC app to a database
3. **Forms and Validation** - Accept user input with validation
4. **Authentication** - Add user login and registration
5. **Deployment** - Deploy your MVC application to production

---

## Appendix

### Glossary

**Action**: Method in a controller that handles requests and returns responses

**Controller**: Class that handles HTTP requests and coordinates between model and view

**Layout**: Master page template that provides consistent structure across views (_Layout.cshtml)

**MVC**: Model-View-Controller - architectural pattern separating concerns

**Model**: Class representing data and business logic

**Partial View**: Reusable view component that can be included in other views

**Razor**: Templating syntax for mixing C# code with HTML using @ symbol

**Route**: URL pattern that maps to controller and action

**Static Files**: Files served directly without processing (CSS, JS, images) from wwwroot

**Tag Helper**: Server-side code that generates HTML in Razor files (asp-controller, asp-action)

**View**: Razor template (.cshtml) that generates HTML

**ViewData**: Dictionary for passing data from controller to view

**ViewBag**: Dynamic wrapper around ViewData for easier syntax

**wwwroot**: Folder containing static files accessible to browsers

### .NET CLI Commands Reference

```bash
# Project creation
dotnet new mvc -n ProjectName          # Create new MVC project
dotnet new mvc -n ProjectName -f net8.0  # Specify framework version

# Building and running
dotnet restore                          # Restore NuGet packages
dotnet build                           # Compile the project
dotnet run                             # Build and run
dotnet watch run                       # Run with hot reload
dotnet clean                           # Clean build artifacts

# Adding packages
dotnet add package PackageName         # Add NuGet package
dotnet list package                    # List installed packages
dotnet remove package PackageName      # Remove package

# Project info
dotnet --version                       # Check .NET version
dotnet --info                          # Detailed .NET info
```

### Keyboard Shortcuts

**Visual Studio:**
| Shortcut | Action |
|----------|--------|
| `F5` | Start with debugging |
| `Ctrl+F5` | Start without debugging |
| `Shift+F5` | Stop debugging |
| `Ctrl+Shift+B` | Build solution |
| `Ctrl+.` | Quick actions |
| `F12` | Go to definition |

**Visual Studio Code:**
| Shortcut | Action |
|----------|--------|
| `F5` | Start debugging |
| `Ctrl+F5` | Run without debugging |
| `Ctrl+Shift+B` | Build |
| `Ctrl+` ` | Toggle terminal |
| `F12` | Go to definition |

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-11-23 | Initial version - Complete MVC Project Creation guide |

---

**Estimated Reading Time**: 70-80 minutes

**Prerequisites**: Basic C#, HTML, MVC Pattern knowledge

**What's Next**: After completing this guide, proceed to [Working with Models and Data](working-with-models-data.md) and [Entity Framework Core Basics](entity-framework-core-basics.md).
