# Passing Data in ASP.NET Core MVC

---
**Technology Version**: .NET 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-23
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What is Passing Data in MVC?

Passing data in MVC refers to the various mechanisms ASP.NET Core provides for transferring information between controllers and views, and sometimes across multiple requests. Understanding these mechanisms is crucial for building interactive web applications that can display dynamic content and maintain state.

Think of passing data like delivering packages in a city. You have different delivery services (ViewData, ViewBag, TempData, Session) for different needs - some for quick local deliveries within a neighborhood (single request), others for deliveries that need to survive longer journeys (multiple requests), and some for packages that need to be stored in a warehouse for extended periods (session state).

### Why Use Different Data Passing Mechanisms?

ASP.NET Core MVC provides multiple ways to pass data because different scenarios have different requirements:

- **Control data scope** - Some data only needs to exist for one request, while other data must persist across multiple requests
- **Choose the right tool** - Each mechanism has trade-offs in terms of performance, complexity, and appropriate use cases
- **Maintain state** - Web applications are stateless by default, so we need mechanisms to remember information
- **Share data efficiently** - Pass information between controller actions and views without creating tight coupling
- **Handle redirects** - Some mechanisms work across redirects, while others don't
- **Store user-specific information** - Session state allows storing data specific to each user

### When to Use Each Mechanism

**ViewData (Dictionary-based):**
- Passing small amounts of data from controller to view
- When you need to pass metadata or supplementary information
- Cases where strongly-typed models don't make sense

**ViewBag (Dynamic):**
- Same use cases as ViewData, but with cleaner syntax
- When you prefer dynamic typing over dictionary syntax
- Passing simple values without creating a ViewModel

**TempData (Cross-request):**
- Passing data after a redirect (PRG pattern)
- Displaying success/error messages after form submission
- Passing data between two actions in a workflow

**Session State:**
- Storing user-specific data across multiple requests
- Shopping cart contents
- User preferences or settings
- Multi-step forms or wizards

**Strongly-typed Models (Recommended):**
- Primary mechanism for passing structured data
- When type safety and IntelliSense are important
- Most production scenarios

---

## 2. Quick Start

**TL;DR - Get started with data passing in 5 minutes:**

**ViewData Example:**
```csharp
// Controller
ViewData["Title"] = "Pokemon List";
ViewData["Count"] = 151;

// View
<h1>@ViewData["Title"]</h1>
<p>Total: @ViewData["Count"]</p>
```

**ViewBag Example:**
```csharp
// Controller
ViewBag.Title = "Pokemon List";
ViewBag.Count = 151;

// View
<h1>@ViewBag.Title</h1>
<p>Total: @ViewBag.Count</p>
```

**TempData Example:**
```csharp
// Controller - Action 1
TempData["Message"] = "Pokemon created successfully!";
return RedirectToAction("Index");

// Controller - Action 2 (after redirect)
// TempData["Message"] is still available

// View
@if (TempData["Message"] != null)
{
    <div class="alert">@TempData["Message"]</div>
}
```

**Session Example:**
```csharp
// Controller
HttpContext.Session.SetString("Username", "Ash");

// Later in another request
var username = HttpContext.Session.GetString("Username");
```

For detailed explanations, continue reading the sections below.

---

## 3. Prerequisites

### Required Knowledge
- **C# basics** - Variables, classes, properties, and methods
- **MVC pattern** - Understanding of controllers, views, and models
- **Razor syntax** - Basic knowledge of how to write Razor views
- **HTTP fundamentals** - Request/response cycle, what a redirect is

### Required Software/Tools
- **.NET SDK** - Version 8.0 or higher
  - Verify: `dotnet --version`
- **IDE** - Visual Studio 2022, VS Code, or JetBrains Rider
- **Web browser** - For testing your application

### System Requirements
- **Operating System**: Windows 10+, macOS 11+, or Linux
- **RAM**: 4GB minimum (8GB recommended)
- **Disk Space**: 5GB for .NET SDK and IDE

---

## 4. Core Concepts & Theory

### Key Concepts

#### Concept 1: Request Scope vs. Cross-Request Scope

**Request Scope** means data exists only for the duration of a single HTTP request. When the response is sent, the data is gone.

**Example:** ViewData and ViewBag are request-scoped:
```
Browser → Request → Controller → ViewData/ViewBag → View → Response → Browser
(Data is destroyed after response is sent)
```

**Cross-Request Scope** means data can survive across multiple HTTP requests.

**Example:** TempData and Session are cross-request:
```
Request 1 → Set TempData → Redirect → Request 2 → Read TempData
(Data survives the redirect)
```

#### Concept 2: Dictionary-Based vs. Dynamic Access

**Dictionary-Based (ViewData)** uses string keys to store and retrieve values:
```csharp
ViewData["Key"] = value;
var result = (Type)ViewData["Key"]; // Requires casting
```

**Dynamic Access (ViewBag)** uses properties that are resolved at runtime:
```csharp
ViewBag.Key = value;
var result = ViewBag.Key; // No casting needed, but no compile-time checking
```

Both approaches access the same underlying data storage.

#### Concept 3: State Management

Web applications are **stateless** by default - each HTTP request is independent and doesn't remember previous requests. State management mechanisms let us work around this:

- **ViewData/ViewBag**: No state management (single request only)
- **TempData**: Short-term state (survives one additional request)
- **Session**: Long-term state (survives for the duration of a user's session)

#### Concept 4: Strongly-Typed vs. Weakly-Typed Data

**Strongly-typed** (ViewModels):
```csharp
// Controller
var model = new PokemonViewModel { Name = "Pikachu" };
return View(model);

// View
@model PokemonViewModel
<h1>@Model.Name</h1> // Compile-time type checking, IntelliSense
```

**Weakly-typed** (ViewData/ViewBag):
```csharp
// Controller
ViewBag.Name = "Pikachu";

// View
<h1>@ViewBag.Name</h1> // No compile-time checking, runtime resolution
```

### Important Terminology

| Term | Definition |
|------|------------|
| **ViewData** | A dictionary-based mechanism for passing data from controller to view |
| **ViewBag** | A dynamic wrapper around ViewData providing property-based syntax |
| **TempData** | A mechanism for storing data across requests (survives redirects) |
| **Session** | Long-term storage for user-specific data across multiple requests |
| **PRG Pattern** | Post-Redirect-Get: form submission → redirect → display result |
| **State** | Information retained between requests in a stateless environment |
| **Scope** | The lifetime and visibility of data (request, session, application) |

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Data Passing Flow                        │
└─────────────────────────────────────────────────────────────┘

Request Scope (ViewData/ViewBag):
Browser → Controller → ViewData/ViewBag → View → Response
         (Set data)                     (Read data)

Cross-Request Scope (TempData):
Browser → Controller → TempData → Redirect → Controller → View
         (Set data)              Response    (Read data)

Session Scope:
Browser → Controller 1 → Session → Response
         (Set data)
           ↓
         Multiple requests later...
           ↓
Browser → Controller 5 → Session → Response
                        (Read data)
```

---

## 5. Installation Guide

### No Additional Installation Required

All data passing mechanisms (ViewData, ViewBag, TempData) are built into ASP.NET Core MVC and require no additional packages or installation.

**Session state** requires minimal configuration (see Section 6 for setup).

### Verify MVC is Set Up

Ensure your ASP.NET Core MVC project is properly configured.

**Check Program.cs:**
```csharp
var builder = WebApplication.CreateBuilder(args);

// Add MVC services
builder.Services.AddControllersWithViews();

var app = builder.Build();

// Configure middleware
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

If you see `AddControllersWithViews()` and `MapControllerRoute()`, you're ready to use ViewData, ViewBag, and TempData.

---

## 6. Initial Setup & Configuration

### ViewData and ViewBag - No Setup Required

ViewData and ViewBag work out of the box in any MVC controller and view. No configuration needed!

### TempData - No Setup Required

TempData also works out of the box. By default, it uses cookie-based storage in .NET 8.0+.

### Session State - Requires Configuration

Session state needs to be explicitly enabled.

**Step 1: Add Session Middleware in Program.cs**

```csharp
var builder = WebApplication.CreateBuilder(args);

// Add session services
builder.Services.AddDistributedMemoryCache(); // Required for session
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30); // Session timeout
    options.Cookie.HttpOnly = true; // Security: prevent JavaScript access
    options.Cookie.IsEssential = true; // Required for GDPR
});

builder.Services.AddControllersWithViews();

var app = builder.Build();

// IMPORTANT: Add session middleware BEFORE routing
app.UseSession();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

**Step 2: Verify Session is Working**

```csharp
public IActionResult TestSession()
{
    HttpContext.Session.SetString("Test", "It works!");
    var value = HttpContext.Session.GetString("Test");
    return Content($"Session value: {value}");
}
```

### Configuration Options

**Session configuration options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `IdleTimeout` | TimeSpan | 20 minutes | How long session data is retained after last access |
| `Cookie.Name` | string | ".AspNetCore.Session" | Name of the session cookie |
| `Cookie.HttpOnly` | bool | true | Prevent JavaScript access to cookie |
| `Cookie.IsEssential` | bool | false | Mark cookie as essential (required for GDPR compliance) |
| `Cookie.SameSite` | enum | Lax | CSRF protection setting |

**Example with custom configuration:**
```csharp
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromHours(1);
    options.Cookie.Name = ".PokemonApp.Session";
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always; // HTTPS only
});
```

---

## 7. Basic Usage

### Using ViewData

ViewData is a dictionary that stores key-value pairs.

**Setting data in controller:**
```csharp
public class PokemonController : Controller
{
    public IActionResult Index()
    {
        ViewData["Title"] = "Pokemon List";
        ViewData["Count"] = 151;
        ViewData["IsFiltered"] = false;

        return View();
    }
}
```

**Reading data in view:**
```cshtml
@{
    var title = ViewData["Title"] as string;
    var count = (int)ViewData["Count"];
    var isFiltered = (bool)ViewData["IsFiltered"];
}

<h1>@title</h1>
<p>Showing @count Pokemon</p>
@if (!isFiltered)
{
    <p>All Pokemon are displayed</p>
}
```

**What's happening here:**
1. Controller sets values using string keys
2. Values are stored as `object` type
3. View retrieves values using the same keys
4. Type casting is required when reading (`as` or `()`)

**Key characteristics:**
- Dictionary-based access
- Requires type casting
- Compile-time type safety only for keys (string)
- No IntelliSense for values

### Using ViewBag

ViewBag is a dynamic wrapper around ViewData with cleaner syntax.

**Setting data in controller:**
```csharp
public class PokemonController : Controller
{
    public IActionResult Details(int id)
    {
        ViewBag.Title = "Pokemon Details";
        ViewBag.PokemonId = id;
        ViewBag.CanEdit = true;

        return View();
    }
}
```

**Reading data in view:**
```cshtml
<h1>@ViewBag.Title</h1>
<p>ID: @ViewBag.PokemonId</p>

@if (ViewBag.CanEdit)
{
    <a href="/Pokemon/Edit/@ViewBag.PokemonId">Edit</a>
}
```

**What's happening here:**
1. Controller sets properties dynamically
2. Properties are resolved at runtime
3. View accesses properties directly (no casting needed)
4. No compile-time checking

**Key characteristics:**
- Property-based access
- No type casting needed
- Dynamic typing (resolved at runtime)
- No IntelliSense support
- **Note**: ViewBag and ViewData share the same underlying storage

**Relationship between ViewBag and ViewData:**
```csharp
ViewBag.Message = "Hello";
ViewData["Message"] = "Hello"; // These are equivalent

ViewData["Count"] = 10;
var count = ViewBag.Count; // Reads the same value (count = 10)
```

### Using TempData

TempData stores data that survives a redirect.

**Common pattern - Post-Redirect-Get (PRG):**

**Step 1: User submits form (POST)**
```csharp
[HttpPost]
public IActionResult Create(PokemonViewModel model)
{
    if (!ModelState.IsValid)
    {
        return View(model);
    }

    _pokemonService.Create(model);

    // Store success message in TempData
    TempData["SuccessMessage"] = $"Pokemon '{model.Name}' created successfully!";

    // Redirect to Index (PRG pattern)
    return RedirectToAction("Index");
}
```

**Step 2: Redirect happens (browser makes new GET request)**

**Step 3: Display page reads TempData (GET)**
```csharp
public IActionResult Index()
{
    // TempData is automatically available
    // No need to explicitly read it here if view will read it

    var pokemons = _pokemonService.GetAll();
    return View(pokemons);
}
```

**View displays the message:**
```cshtml
@if (TempData["SuccessMessage"] != null)
{
    <div class="alert alert-success">
        @TempData["SuccessMessage"]
    </div>
}

<h1>Pokemon List</h1>
<!-- Rest of the view -->
```

**What's happening here:**
1. User submits form → POST action processes it
2. POST action stores message in TempData
3. POST action redirects to Index (new GET request)
4. Index action runs (new request)
5. View reads TempData (message survives the redirect!)
6. After TempData is read, it's automatically deleted

**TempData lifecycle:**
```
Request 1 (POST)  → Set TempData → Redirect
                                      ↓
Request 2 (GET)   → Read TempData → Display → TempData deleted
```

**Keep TempData for another request:**
```csharp
// In controller or view
var message = TempData["Message"];
TempData.Keep("Message"); // Keep for one more request

// Or keep all TempData
TempData.Keep();
```

**Peek at TempData without marking it for deletion:**
```csharp
var message = TempData.Peek("Message"); // Read without removing
```

### Using Session State

Session stores data for the duration of a user's session (typically 20-30 minutes of inactivity).

**Setting session data:**
```csharp
public IActionResult SetPreferences(string theme)
{
    // Store simple string
    HttpContext.Session.SetString("Theme", theme);

    // Store integer
    HttpContext.Session.SetInt32("PreferredPageSize", 25);

    return RedirectToAction("Index");
}
```

**Reading session data:**
```csharp
public IActionResult Index()
{
    // Read string (returns null if not found)
    var theme = HttpContext.Session.GetString("Theme") ?? "light";

    // Read integer (returns null if not found)
    var pageSize = HttpContext.Session.GetInt32("PreferredPageSize") ?? 10;

    ViewBag.Theme = theme;
    ViewBag.PageSize = pageSize;

    return View();
}
```

**Storing complex objects (requires serialization):**
```csharp
using System.Text.Json;

public IActionResult SaveCart(ShoppingCart cart)
{
    var cartJson = JsonSerializer.Serialize(cart);
    HttpContext.Session.SetString("ShoppingCart", cartJson);

    return RedirectToAction("Index");
}

public IActionResult GetCart()
{
    var cartJson = HttpContext.Session.GetString("ShoppingCart");

    if (cartJson != null)
    {
        var cart = JsonSerializer.Deserialize<ShoppingCart>(cartJson);
        return View(cart);
    }

    return View(new ShoppingCart()); // Empty cart
}
```

**Clearing session data:**
```csharp
// Remove specific item
HttpContext.Session.Remove("Theme");

// Clear all session data
HttpContext.Session.Clear();
```

**Key characteristics:**
- Survives multiple requests
- User-specific (each user has their own session)
- Stored server-side (more secure than cookies)
- Has expiration (IdleTimeout)
- Requires serialization for complex objects

---

## 8. Testing & Validation

### How to Test Your Data Passing Code

#### Test ViewData/ViewBag

**Create a test controller:**
```csharp
public class TestController : Controller
{
    public IActionResult TestViewData()
    {
        ViewData["Message"] = "This is ViewData";
        ViewData["Count"] = 42;
        return View();
    }

    public IActionResult TestViewBag()
    {
        ViewBag.Message = "This is ViewBag";
        ViewBag.Count = 42;
        return View();
    }
}
```

**Create corresponding views:**
```cshtml
@* Views/Test/TestViewData.cshtml *@
<h1>ViewData Test</h1>
<p>Message: @ViewData["Message"]</p>
<p>Count: @ViewData["Count"]</p>
```

**Expected behavior:**
- Navigate to `/Test/TestViewData`
- Should display: "This is ViewData" and "42"
- Refresh page → data is gone (request-scoped)

#### Test TempData

**Create test actions:**
```csharp
public IActionResult SetTempData()
{
    TempData["TestMessage"] = "TempData works!";
    return RedirectToAction("ReadTempData");
}

public IActionResult ReadTempData()
{
    ViewBag.Message = TempData["TestMessage"] ?? "No TempData found";
    return View();
}
```

**Expected behavior:**
- Navigate to `/Test/SetTempData`
- Should redirect to `/Test/ReadTempData`
- Should display: "TempData works!"
- Refresh page → message disappears (TempData consumed after first read)

#### Test Session

**Create test actions:**
```csharp
public IActionResult SetSession()
{
    HttpContext.Session.SetString("Username", "Ash");
    HttpContext.Session.SetInt32("Level", 10);
    return Content("Session data set!");
}

public IActionResult ReadSession()
{
    var username = HttpContext.Session.GetString("Username") ?? "Not found";
    var level = HttpContext.Session.GetInt32("Level") ?? 0;

    return Content($"Username: {username}, Level: {level}");
}
```

**Expected behavior:**
- Navigate to `/Test/SetSession` → "Session data set!"
- Navigate to `/Test/ReadSession` → "Username: Ash, Level: 10"
- Refresh page → data persists (session-scoped)
- Wait for session timeout or clear cookies → data disappears

### Common Validation Checks

**Check 1: Verify data persists after redirect**
```csharp
// Set TempData and redirect
TempData["Test"] = "Value";
return RedirectToAction("Target");

// In Target action
var value = TempData["Test"]; // Should be "Value"
```
Expected: TempData survives the redirect

**Check 2: Verify ViewData doesn't survive redirect**
```csharp
// Set ViewData and redirect
ViewData["Test"] = "Value";
return RedirectToAction("Target");

// In Target action
var value = ViewData["Test"]; // Will be null
```
Expected: ViewData is null (doesn't survive redirect)

**Check 3: Verify Session persists across multiple requests**
```csharp
// Request 1: Set session
HttpContext.Session.SetString("Test", "Value");

// Request 2, 3, 4... (many requests later)
var value = HttpContext.Session.GetString("Test"); // Should still be "Value"
```
Expected: Session data persists until timeout or clear

### Hands-On Exercises

#### Exercise 1: Page Title with ViewBag (Beginner)
**Objective:** Practice using ViewBag to set page titles dynamically

**Task:**
Create a Pokemon list page where the page title is set using ViewBag and displays the count of Pokemon.

**Requirements:**
- Use ViewBag to pass the title from controller to view
- Include the count of Pokemon in the title
- Display the title in an `<h1>` tag

**Hints:**
- Use `ViewBag.Title` in the controller
- Access `@ViewBag.Title` in the view
- You can combine strings when setting ViewBag properties

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Controller:**
```csharp
public class PokemonController : Controller
{
    public IActionResult Index()
    {
        var pokemonCount = 151; // Imagine this comes from database
        ViewBag.Title = $"Pokemon List ({pokemonCount} total)";

        return View();
    }
}
```

**View:**
```cshtml
<h1>@ViewBag.Title</h1>
<p>Welcome to the Pokemon list!</p>
```

**Explanation:**
- The controller sets `ViewBag.Title` with a formatted string including the count
- The view accesses the dynamic property directly
- ViewBag provides clean syntax without casting
</details>

---

#### Exercise 2: Success Message with TempData (Intermediate)
**Objective:** Implement the Post-Redirect-Get pattern with success messages

**Task:**
Create a form submission flow where:
1. User submits a form to create a Pokemon
2. After successful creation, redirect to the list page
3. Display a success message on the list page
4. Message should disappear on refresh

**Requirements:**
- Use TempData to pass the success message
- Implement PRG pattern (Post-Redirect-Get)
- Message should only display once
- Handle both success and error cases

**Hints:**
- Use `[HttpPost]` and `[HttpGet]` attributes
- Store message in TempData before `RedirectToAction`
- Check if TempData value exists before displaying

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Controller:**
```csharp
public class PokemonController : Controller
{
    [HttpGet]
    public IActionResult Create()
    {
        return View();
    }

    [HttpPost]
    public IActionResult Create(PokemonViewModel model)
    {
        if (!ModelState.IsValid)
        {
            TempData["ErrorMessage"] = "Please fix the validation errors.";
            return View(model);
        }

        // Imagine saving to database here
        // _pokemonService.Create(model);

        TempData["SuccessMessage"] = $"Pokemon '{model.Name}' created successfully!";
        return RedirectToAction("Index");
    }

    public IActionResult Index()
    {
        // TempData is automatically available to the view
        return View();
    }
}
```

**View (Index.cshtml):**
```cshtml
@if (TempData["SuccessMessage"] != null)
{
    <div class="alert alert-success">
        @TempData["SuccessMessage"]
    </div>
}

@if (TempData["ErrorMessage"] != null)
{
    <div class="alert alert-danger">
        @TempData["ErrorMessage"]
    </div>
}

<h1>Pokemon List</h1>
<a href="/Pokemon/Create">Create New Pokemon</a>
```

**Explanation:**
- POST action stores message in TempData before redirect
- Redirect causes a new GET request to Index
- TempData survives the redirect
- View checks for messages and displays them
- After displaying, TempData is automatically cleared
- Refreshing the page won't show the message again
</details>

---

#### Exercise 3: User Preferences with Session (Challenge)
**Objective:** Build a preference system that remembers user settings across requests

**Task:**
Create a Pokemon gallery that remembers the user's preferred view mode (grid/list) and items per page using Session.

**Requirements:**
- Store view mode preference in Session (grid or list)
- Store items-per-page preference in Session (10, 25, or 50)
- Provide a settings page to change preferences
- Apply preferences to the Pokemon list page
- Preferences should persist across browser sessions (until timeout)

**Bonus Challenges:**
- Add a "Reset Preferences" button
- Display current preferences in the UI
- Use default values if preferences haven't been set

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Controller:**
```csharp
using System.Text.Json;

public class PokemonController : Controller
{
    // Helper methods for session
    private string GetViewMode() =>
        HttpContext.Session.GetString("ViewMode") ?? "grid";

    private int GetItemsPerPage() =>
        HttpContext.Session.GetInt32("ItemsPerPage") ?? 10;

    public IActionResult Index()
    {
        var viewMode = GetViewMode();
        var itemsPerPage = GetItemsPerPage();

        ViewBag.ViewMode = viewMode;
        ViewBag.ItemsPerPage = itemsPerPage;

        // Imagine getting Pokemon from database here
        // var pokemons = _pokemonService.GetAll().Take(itemsPerPage);

        return View();
    }

    [HttpGet]
    public IActionResult Settings()
    {
        ViewBag.CurrentViewMode = GetViewMode();
        ViewBag.CurrentItemsPerPage = GetItemsPerPage();

        return View();
    }

    [HttpPost]
    public IActionResult Settings(string viewMode, int itemsPerPage)
    {
        // Validate input
        if (viewMode != "grid" && viewMode != "list")
        {
            viewMode = "grid";
        }

        if (itemsPerPage != 10 && itemsPerPage != 25 && itemsPerPage != 50)
        {
            itemsPerPage = 10;
        }

        // Store in session
        HttpContext.Session.SetString("ViewMode", viewMode);
        HttpContext.Session.SetInt32("ItemsPerPage", itemsPerPage);

        TempData["SuccessMessage"] = "Preferences saved successfully!";
        return RedirectToAction("Index");
    }

    public IActionResult ResetPreferences()
    {
        HttpContext.Session.Remove("ViewMode");
        HttpContext.Session.Remove("ItemsPerPage");

        TempData["SuccessMessage"] = "Preferences reset to defaults.";
        return RedirectToAction("Index");
    }
}
```

**View (Settings.cshtml):**
```cshtml
<h1>Settings</h1>

<form method="post" asp-action="Settings">
    <div class="form-group">
        <label>View Mode:</label>
        <select name="viewMode" class="form-control">
            <option value="grid" selected="@(ViewBag.CurrentViewMode == "grid")">Grid</option>
            <option value="list" selected="@(ViewBag.CurrentViewMode == "list")">List</option>
        </select>
    </div>

    <div class="form-group">
        <label>Items Per Page:</label>
        <select name="itemsPerPage" class="form-control">
            <option value="10" selected="@(ViewBag.CurrentItemsPerPage == 10)">10</option>
            <option value="25" selected="@(ViewBag.CurrentItemsPerPage == 25)">25</option>
            <option value="50" selected="@(ViewBag.CurrentItemsPerPage == 50)">50</option>
        </select>
    </div>

    <button type="submit" class="btn btn-primary">Save Preferences</button>
    <a href="/Pokemon/ResetPreferences" class="btn btn-secondary">Reset to Defaults</a>
</form>
```

**View (Index.cshtml):**
```cshtml
@if (TempData["SuccessMessage"] != null)
{
    <div class="alert alert-success">@TempData["SuccessMessage"]</div>
}

<h1>Pokemon Gallery</h1>

<div class="settings-info">
    <p>Current View: <strong>@ViewBag.ViewMode</strong> | Items per page: <strong>@ViewBag.ItemsPerPage</strong></p>
    <a href="/Pokemon/Settings">Change Settings</a>
</div>

@if (ViewBag.ViewMode == "grid")
{
    <div class="pokemon-grid">
        <!-- Grid view -->
    </div>
}
else
{
    <div class="pokemon-list">
        <!-- List view -->
    </div>
}
```

**Explanation:**
- Session stores user preferences across multiple requests
- Helper methods provide defaults if preferences haven't been set
- Settings page allows users to change preferences
- Preferences are applied to the gallery display
- TempData provides feedback after saving
- Reset action clears session data
- Session data persists until timeout or manual clear
</details>

---

### Comprehension Questions

**Question 1:** What's the main difference between ViewData and TempData in terms of scope?
<details>
<summary>Answer</summary>

ViewData is **request-scoped** - it only exists for a single HTTP request and is destroyed after the response is sent. It does NOT survive redirects.

TempData is **cross-request scoped** - it survives redirects and persists until it's read. This makes it perfect for the Post-Redirect-Get (PRG) pattern where you need to pass data after a redirect.

**Example:**
```csharp
// ViewData - doesn't survive redirect
ViewData["Message"] = "Hello";
return RedirectToAction("Target"); // ViewData is lost

// TempData - survives redirect
TempData["Message"] = "Hello";
return RedirectToAction("Target"); // TempData is available in Target
```
</details>

**Question 2:** When should you use Session instead of TempData?
<details>
<summary>Answer</summary>

Use **TempData** when:
- You need to pass data for just one additional request (typically after a redirect)
- Displaying success/error messages after form submission
- Short-lived data that should be consumed quickly

Use **Session** when:
- You need data to persist across multiple requests (not just one)
- Storing user preferences or settings
- Shopping cart contents
- Multi-step forms or wizards
- User authentication state (though usually handled by ASP.NET Core Identity)

**Rule of thumb:** TempData is for "flash messages," Session is for "user-specific long-term storage."
</details>

**Question 3:** Why is using strongly-typed models (ViewModels) preferred over ViewBag for passing complex data?
<details>
<summary>Answer</summary>

Strongly-typed models are preferred because:

1. **Compile-time type checking** - Errors are caught at compile time, not runtime
2. **IntelliSense support** - IDE provides autocomplete and helps prevent typos
3. **Refactoring support** - Renaming properties updates all references
4. **Self-documenting** - The model class clearly shows what data the view expects
5. **Better performance** - No runtime type resolution needed
6. **Testability** - Easier to write unit tests with concrete types

**Example comparison:**
```csharp
// ViewBag - no compile-time checking, no IntelliSense
ViewBag.PokemnName = "Pikachu"; // Typo! Won't be caught until runtime

// ViewModel - compile-time checking, IntelliSense
var model = new PokemonViewModel
{
    PokemnName = "Pikachu" // Compiler error! Property doesn't exist
};
```

**When ViewBag is acceptable:**
- Passing simple metadata (page titles, breadcrumbs)
- Small amounts of supplementary data
- Quick prototyping or demos
</details>

**Question 4:** What happens if you try to read TempData that has already been read once?
<details>
<summary>Answer</summary>

By default, TempData is **marked for deletion** after it's read once. On the next request, it will be `null`.

**Example:**
```csharp
// Request 1: Set TempData
TempData["Message"] = "Hello";
return RedirectToAction("Step2");

// Request 2: Read TempData (marked for deletion)
var message = TempData["Message"]; // "Hello"

// Request 3: Try to read again
var message2 = TempData["Message"]; // null (already consumed)
```

**To prevent this, use:**
- `TempData.Keep("Message")` - Keep for one more request
- `TempData.Peek("Message")` - Read without marking for deletion

**Example:**
```csharp
// Read without consuming
var message = TempData.Peek("Message"); // Still available next time

// Or read and explicitly keep
var message = TempData["Message"];
TempData.Keep("Message"); // Keep for next request
```
</details>

**Question 5:** How can you tell if ViewBag.Message exists before accessing it in a view?
<details>
<summary>Answer</summary>

Since ViewBag is dynamic, you can check if a property exists using null checking:

**Method 1: Null check**
```cshtml
@if (ViewBag.Message != null)
{
    <p>@ViewBag.Message</p>
}
```

**Method 2: Null-coalescing operator**
```cshtml
<p>@(ViewBag.Message ?? "No message")</p>
```

**Method 3: Check ViewData (since ViewBag uses ViewData)**
```cshtml
@if (ViewData.ContainsKey("Message"))
{
    <p>@ViewBag.Message</p>
}
```

**Best practice:** Always check for null before using ViewBag properties in views to avoid runtime errors.
</details>

### Self-Assessment Checklist

After completing this section, you should be able to:

- [ ] Explain the difference between ViewData, ViewBag, TempData, and Session
- [ ] Choose the appropriate mechanism for different scenarios
- [ ] Use ViewData with dictionary syntax and proper type casting
- [ ] Use ViewBag with dynamic property syntax
- [ ] Implement the Post-Redirect-Get pattern with TempData
- [ ] Configure and use Session state in ASP.NET Core
- [ ] Understand the lifecycle and scope of each mechanism
- [ ] Handle TempData.Keep() and TempData.Peek() appropriately
- [ ] Serialize complex objects for Session storage
- [ ] Recognize when strongly-typed models are more appropriate

**If you can't check all these boxes:**
- Review the sections where you're struggling
- Try the exercises again with different scenarios
- Experiment with the code examples in your own project
- Review the comprehension questions

### Debugging Tips

**If ViewData/ViewBag is null in the view:**
1. Check that you're setting it in the controller action that returns the view
2. Verify you're not redirecting (ViewData doesn't survive redirects)
3. Check for typos in the key/property name
4. Ensure the action is actually executing (add breakpoint)

**If TempData is null after redirect:**
1. Verify Session middleware is configured (`app.UseSession()`)
2. Check that you're setting TempData before the redirect
3. Ensure cookies are enabled in the browser
4. Verify you haven't already read TempData (it's consumed after first read)

**If Session is null:**
1. Confirm `AddSession()` and `UseSession()` are in Program.cs
2. Verify `UseSession()` comes BEFORE `MapControllerRoute()`
3. Check cookies are enabled
4. Verify session hasn't timed out
5. Ensure you're using the correct session key

**Common debugging workflow:**
```
1. Add breakpoint in controller action
2. Inspect ViewData/ViewBag/TempData/Session values
3. Step through to view rendering
4. Check browser dev tools for cookies (Session, TempData)
5. Review middleware order in Program.cs
```

---

## 9. Practical Examples

### Example 1: Dynamic Page Title (Beginner)

**Scenario:**
Every page in your application should have a unique title displayed in the browser tab and as an `<h1>` on the page. We'll use ViewBag to set this dynamically from each controller action.

**Code:**

**_Layout.cshtml:**
```cshtml
<!DOCTYPE html>
<html>
<head>
    <title>@(ViewBag.Title ?? "PokemonApp") - Pokemon Application</title>
</head>
<body>
    <header>
        <h1>@(ViewBag.Title ?? "Welcome")</h1>
    </header>

    <main>
        @RenderBody()
    </main>
</body>
</html>
```

**Controller:**
```csharp
public class PokemonController : Controller
{
    public IActionResult Index()
    {
        ViewBag.Title = "Pokemon List";
        // Get Pokemon from database...
        return View();
    }

    public IActionResult Details(int id)
    {
        ViewBag.Title = $"Pokemon #{id} Details";
        // Get specific Pokemon...
        return View();
    }

    public IActionResult Create()
    {
        ViewBag.Title = "Create New Pokemon";
        return View();
    }
}
```

**Walkthrough:**
1. Each controller action sets `ViewBag.Title` with an appropriate value
2. The layout file uses `@ViewBag.Title` in both the `<title>` tag and `<h1>` tag
3. The null-coalescing operator (`??`) provides a default if Title isn't set
4. This creates a consistent page title system across the entire application

**Try it yourself:**
- Add ViewBag.Subtitle for a secondary heading
- Create a breadcrumb system using ViewBag
- Add a page description for SEO using ViewData

---

### Example 2: Form Submission with Success Messages (Intermediate)

**Scenario:**
Users submit a form to add a new Pokemon. After successful creation, they're redirected to the list page with a success message. If validation fails, they see the form again with an error message.

**Code:**

**Controller:**
```csharp
public class PokemonController : Controller
{
    private readonly IPokemonService _pokemonService;

    public PokemonController(IPokemonService pokemonService)
    {
        _pokemonService = pokemonService;
    }

    [HttpGet]
    public IActionResult Create()
    {
        ViewBag.Title = "Create New Pokemon";
        return View();
    }

    [HttpPost]
    public IActionResult Create(PokemonCreateViewModel model)
    {
        // Validation failed - show form again
        if (!ModelState.IsValid)
        {
            ViewBag.Title = "Create New Pokemon";
            TempData["ErrorMessage"] = "Please fix the validation errors below.";
            return View(model);
        }

        try
        {
            // Save to database
            var pokemon = _pokemonService.Create(model);

            // Success! Store message and redirect
            TempData["SuccessMessage"] = $"Success! {pokemon.Name} has been added to your Pokedex.";
            return RedirectToAction("Index");
        }
        catch (Exception ex)
        {
            // Handle unexpected errors
            TempData["ErrorMessage"] = $"Error creating Pokemon: {ex.Message}";
            ViewBag.Title = "Create New Pokemon";
            return View(model);
        }
    }

    public IActionResult Index()
    {
        ViewBag.Title = "Pokemon List";
        var pokemons = _pokemonService.GetAll();
        return View(pokemons);
    }
}
```

**View (Create.cshtml):**
```cshtml
@model PokemonCreateViewModel

@if (TempData["ErrorMessage"] != null)
{
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        @TempData["ErrorMessage"]
        <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
}

<h2>Add New Pokemon</h2>

<form asp-action="Create" method="post">
    <div class="form-group">
        <label asp-for="Name"></label>
        <input asp-for="Name" class="form-control" />
        <span asp-validation-for="Name" class="text-danger"></span>
    </div>

    <div class="form-group">
        <label asp-for="Type"></label>
        <input asp-for="Type" class="form-control" />
        <span asp-validation-for="Type" class="text-danger"></span>
    </div>

    <div class="form-group">
        <label asp-for="Level"></label>
        <input asp-for="Level" type="number" class="form-control" />
        <span asp-validation-for="Level" class="text-danger"></span>
    </div>

    <button type="submit" class="btn btn-primary">Create Pokemon</button>
    <a asp-action="Index" class="btn btn-secondary">Cancel</a>
</form>
```

**View (Index.cshtml):**
```cshtml
@model List<PokemonViewModel>

@if (TempData["SuccessMessage"] != null)
{
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        @TempData["SuccessMessage"]
        <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
}

<h2>Your Pokemon</h2>

<a asp-action="Create" class="btn btn-primary mb-3">Add New Pokemon</a>

<table class="table">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Level</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        @foreach (var pokemon in Model)
        {
            <tr>
                <td>@pokemon.Name</td>
                <td>@pokemon.Type</td>
                <td>@pokemon.Level</td>
                <td>
                    <a asp-action="Details" asp-route-id="@pokemon.Id">Details</a>
                </td>
            </tr>
        }
    </tbody>
</table>
```

**Walkthrough:**
1. User clicks "Add New Pokemon" → GET Create action → Shows empty form
2. User fills form and submits → POST Create action receives data
3. If validation fails → TempData stores error → Returns same view with errors
4. If validation passes → Saves to database → TempData stores success message → Redirects to Index
5. Index GET action runs (new request) → View displays success message from TempData
6. TempData is consumed after displaying → Refresh removes the message

**Key takeaways:**
- TempData survives the redirect from POST to GET (PRG pattern)
- Error messages use TempData even without redirect (consistent approach)
- Messages are dismissible and styled appropriately
- After display, messages don't persist on refresh

---

### Example 3: Shopping Cart with Session (Advanced)

**Scenario:**
Build a Pokemon "favorites" system where users can add Pokemon to their favorites list. The list persists across multiple page visits using Session.

**Code:**

**Models:**
```csharp
public class FavoriteItem
{
    public int PokemonId { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }
    public DateTime AddedDate { get; set; }
}

public class FavoritesViewModel
{
    public List<FavoriteItem> Items { get; set; } = new();
    public int Count => Items.Count;
}
```

**Session Helper (Extension Method):**
```csharp
using System.Text.Json;

public static class SessionExtensions
{
    public static void SetObject<T>(this ISession session, string key, T value)
    {
        session.SetString(key, JsonSerializer.Serialize(value));
    }

    public static T GetObject<T>(this ISession session, string key)
    {
        var value = session.GetString(key);
        return value == null ? default : JsonSerializer.Deserialize<T>(value);
    }
}
```

**Controller:**
```csharp
public class FavoritesController : Controller
{
    private const string FavoritesSessionKey = "PokemonFavorites";
    private readonly IPokemonService _pokemonService;

    public FavoritesController(IPokemonService pokemonService)
    {
        _pokemonService = pokemonService;
    }

    // Get current favorites from session
    private FavoritesViewModel GetFavorites()
    {
        return HttpContext.Session.GetObject<FavoritesViewModel>(FavoritesSessionKey)
               ?? new FavoritesViewModel();
    }

    // Save favorites to session
    private void SaveFavorites(FavoritesViewModel favorites)
    {
        HttpContext.Session.SetObject(FavoritesSessionKey, favorites);
    }

    // Display favorites
    public IActionResult Index()
    {
        ViewBag.Title = "My Favorite Pokemon";
        var favorites = GetFavorites();
        return View(favorites);
    }

    // Add to favorites
    [HttpPost]
    public IActionResult Add(int pokemonId)
    {
        var pokemon = _pokemonService.GetById(pokemonId);

        if (pokemon == null)
        {
            TempData["ErrorMessage"] = "Pokemon not found.";
            return RedirectToAction("Index", "Pokemon");
        }

        var favorites = GetFavorites();

        // Check if already in favorites
        if (favorites.Items.Any(f => f.PokemonId == pokemonId))
        {
            TempData["InfoMessage"] = $"{pokemon.Name} is already in your favorites.";
        }
        else
        {
            favorites.Items.Add(new FavoriteItem
            {
                PokemonId = pokemon.Id,
                Name = pokemon.Name,
                Type = pokemon.Type,
                AddedDate = DateTime.Now
            });

            SaveFavorites(favorites);
            TempData["SuccessMessage"] = $"{pokemon.Name} added to favorites!";
        }

        return RedirectToAction("Index", "Pokemon");
    }

    // Remove from favorites
    [HttpPost]
    public IActionResult Remove(int pokemonId)
    {
        var favorites = GetFavorites();
        var item = favorites.Items.FirstOrDefault(f => f.PokemonId == pokemonId);

        if (item != null)
        {
            favorites.Items.Remove(item);
            SaveFavorites(favorites);
            TempData["SuccessMessage"] = $"{item.Name} removed from favorites.";
        }

        return RedirectToAction("Index");
    }

    // Clear all favorites
    [HttpPost]
    public IActionResult Clear()
    {
        HttpContext.Session.Remove(FavoritesSessionKey);
        TempData["SuccessMessage"] = "All favorites cleared.";
        return RedirectToAction("Index");
    }

    // Get favorites count (for displaying in navigation)
    public IActionResult GetCount()
    {
        var favorites = GetFavorites();
        return Json(new { count = favorites.Count });
    }
}
```

**View (Index.cshtml):**
```cshtml
@model FavoritesViewModel

@if (TempData["SuccessMessage"] != null)
{
    <div class="alert alert-success">@TempData["SuccessMessage"]</div>
}

<h2>My Favorite Pokemon (@Model.Count)</h2>

@if (Model.Count == 0)
{
    <div class="alert alert-info">
        <p>You haven't added any favorites yet.</p>
        <a asp-controller="Pokemon" asp-action="Index" class="btn btn-primary">Browse Pokemon</a>
    </div>
}
else
{
    <div class="mb-3">
        <form asp-action="Clear" method="post" class="d-inline"
              onsubmit="return confirm('Are you sure you want to clear all favorites?')">
            <button type="submit" class="btn btn-danger">Clear All</button>
        </form>
    </div>

    <div class="row">
        @foreach (var item in Model.Items)
        {
            <div class="col-md-4 mb-3">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">@item.Name</h5>
                        <p class="card-text">
                            <strong>Type:</strong> @item.Type<br/>
                            <strong>Added:</strong> @item.AddedDate.ToString("MMM dd, yyyy")
                        </p>
                        <a asp-controller="Pokemon" asp-action="Details"
                           asp-route-id="@item.PokemonId"
                           class="btn btn-primary btn-sm">View Details</a>
                        <form asp-action="Remove" method="post" class="d-inline">
                            <input type="hidden" name="pokemonId" value="@item.PokemonId" />
                            <button type="submit" class="btn btn-secondary btn-sm">Remove</button>
                        </form>
                    </div>
                </div>
            </div>
        }
    </div>
}
```

**Pokemon List View (Add favorite button):**
```cshtml
@* In Pokemon/Index.cshtml *@
@foreach (var pokemon in Model)
{
    <div class="pokemon-card">
        <h3>@pokemon.Name</h3>
        <p>Type: @pokemon.Type</p>

        <form asp-controller="Favorites" asp-action="Add" method="post" class="d-inline">
            <input type="hidden" name="pokemonId" value="@pokemon.Id" />
            <button type="submit" class="btn btn-sm btn-outline-primary">
                ⭐ Add to Favorites
            </button>
        </form>
    </div>
}
```

**Layout (Show favorites count in navigation):**
```cshtml
@* In _Layout.cshtml *@
<nav>
    <ul>
        <li><a asp-controller="Pokemon" asp-action="Index">Pokemon</a></li>
        <li>
            <a asp-controller="Favorites" asp-action="Index">
                Favorites <span id="favorites-count">(0)</span>
            </a>
        </li>
    </ul>
</nav>

<script>
    // Update favorites count on page load
    fetch('/Favorites/GetCount')
        .then(response => response.json())
        .then(data => {
            document.getElementById('favorites-count').textContent = `(${data.count})`;
        });
</script>
```

**Walkthrough:**
1. User browses Pokemon list and clicks "Add to Favorites"
2. POST to Favorites/Add → Retrieves current favorites from Session
3. Adds new item to favorites list
4. Serializes list to JSON and stores in Session
5. Redirects back with success message in TempData
6. Favorites persist across all pages and requests
7. User can view, remove items, or clear all favorites
8. Session expires after IdleTimeout (default 20 minutes of inactivity)

**Key takeaways:**
- Session stores complex objects via JSON serialization
- Helper extension methods simplify Session operations
- Favorites persist across multiple requests and page navigations
- TempData provides immediate feedback for user actions
- Session is user-specific (each user has their own favorites)

---

## 10. Common Patterns & Best Practices

### Recommended Patterns

#### Pattern 1: Post-Redirect-Get (PRG) with TempData

**Description:**
After processing a form submission (POST), redirect to a GET action and display a message. This prevents duplicate form submissions when users refresh the page.

**When to use:**
- After creating, updating, or deleting records
- When displaying success/error messages after form submission
- Whenever you want to prevent form resubmission on page refresh

**Example:**
```csharp
[HttpPost]
public IActionResult Create(PokemonViewModel model)
{
    if (!ModelState.IsValid)
    {
        return View(model); // Show form with errors
    }

    _service.Create(model);
    TempData["SuccessMessage"] = "Pokemon created successfully!";
    return RedirectToAction("Index"); // PRG pattern
}
```

**Why this is good:**
- Prevents duplicate submissions
- Improves user experience (refresh doesn't resubmit)
- Provides clean URLs after form submission
- TempData survives the redirect to show messages

---

#### Pattern 2: Strongly-Typed Models as Primary, ViewBag for Metadata

**Description:**
Use strongly-typed ViewModels for primary data and ViewBag/ViewData only for supplementary metadata like page titles, breadcrumbs, or small flags.

**When to use:**
- Passing the main data structure to a view
- When you need type safety and IntelliSense
- Production applications with complex data requirements

**Example:**
```csharp
public IActionResult Details(int id)
{
    // Primary data - strongly typed
    var pokemon = _service.GetById(id);
    var viewModel = _mapper.Map<PokemonDetailsViewModel>(pokemon);

    // Metadata - ViewBag
    ViewBag.Title = $"Pokemon: {pokemon.Name}";
    ViewBag.ShowEditButton = User.IsInRole("Admin");
    ViewBag.Breadcrumbs = new[] { "Home", "Pokemon", pokemon.Name };

    return View(viewModel);
}
```

**View:**
```cshtml
@model PokemonDetailsViewModel

@* Use strongly-typed model for primary data *@
<h1>@Model.Name</h1>
<p>Type: @Model.Type</p>
<p>Level: @Model.Level</p>

@* Use ViewBag for metadata *@
@if (ViewBag.ShowEditButton)
{
    <a href="/Pokemon/Edit/@Model.Id">Edit</a>
}
```

**Why this is good:**
- Clear separation of concerns
- Compile-time safety for important data
- Flexibility for simple metadata
- Best of both worlds

---

#### Pattern 3: Session with Helper Service

**Description:**
Create a dedicated service to manage Session operations instead of accessing Session directly in controllers.

**When to use:**
- When using Session extensively
- Multiple controllers need to access the same session data
- Complex session data structures
- When you want testable code

**Example:**
```csharp
// Service interface
public interface IUserPreferencesService
{
    void SaveViewMode(string mode);
    string GetViewMode();
    void SaveItemsPerPage(int count);
    int GetItemsPerPage();
    void ClearPreferences();
}

// Implementation
public class UserPreferencesService : IUserPreferencesService
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public UserPreferencesService(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    private ISession Session => _httpContextAccessor.HttpContext.Session;

    public void SaveViewMode(string mode)
    {
        Session.SetString("ViewMode", mode);
    }

    public string GetViewMode()
    {
        return Session.GetString("ViewMode") ?? "grid";
    }

    public void SaveItemsPerPage(int count)
    {
        Session.SetInt32("ItemsPerPage", count);
    }

    public int GetItemsPerPage()
    {
        return Session.GetInt32("ItemsPerPage") ?? 10;
    }

    public void ClearPreferences()
    {
        Session.Remove("ViewMode");
        Session.Remove("ItemsPerPage");
    }
}

// Register in Program.cs
builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<IUserPreferencesService, UserPreferencesService>();

// Use in controller
public class PokemonController : Controller
{
    private readonly IUserPreferencesService _preferences;

    public PokemonController(IUserPreferencesService preferences)
    {
        _preferences = preferences;
    }

    public IActionResult Index()
    {
        var viewMode = _preferences.GetViewMode();
        var itemsPerPage = _preferences.GetItemsPerPage();

        // Use preferences...
        return View();
    }
}
```

**Why this is good:**
- Centralizes session logic
- Easier to test (mock the service)
- Encapsulates session key names
- Provides type-safe interface
- Reduces code duplication

---

#### Pattern 4: TempData with Alert Helper

**Description:**
Create a reusable pattern for displaying alerts/notifications using TempData with a consistent structure.

**When to use:**
- Displaying success, error, warning, or info messages
- Providing consistent UI feedback
- Multiple message types across the application

**Example:**
```csharp
// Alert helper
public static class AlertHelper
{
    private const string AlertKey = "Alert";

    public static void Success(ITempDataDictionary tempData, string message)
    {
        tempData[AlertKey] = JsonSerializer.Serialize(new Alert
        {
            Type = "success",
            Message = message
        });
    }

    public static void Error(ITempDataDictionary tempData, string message)
    {
        tempData[AlertKey] = JsonSerializer.Serialize(new Alert
        {
            Type = "danger",
            Message = message
        });
    }

    public static void Warning(ITempDataDictionary tempData, string message)
    {
        tempData[AlertKey] = JsonSerializer.Serialize(new Alert
        {
            Type = "warning",
            Message = message
        });
    }

    public static void Info(ITempDataDictionary tempData, string message)
    {
        tempData[AlertKey] = JsonSerializer.Serialize(new Alert
        {
            Type = "info",
            Message = message
        });
    }

    public static Alert GetAlert(ITempDataDictionary tempData)
    {
        if (tempData[AlertKey] is string alertJson)
        {
            return JsonSerializer.Deserialize<Alert>(alertJson);
        }
        return null;
    }
}

public class Alert
{
    public string Type { get; set; } // success, danger, warning, info
    public string Message { get; set; }
}

// Use in controller
AlertHelper.Success(TempData, "Pokemon created successfully!");
return RedirectToAction("Index");

AlertHelper.Error(TempData, "Failed to save Pokemon. Please try again.");
return RedirectToAction("Create");

// Display in _Layout.cshtml or partial view
@{
    var alert = AlertHelper.GetAlert(TempData);
}

@if (alert != null)
{
    <div class="alert alert-@alert.Type alert-dismissible fade show">
        @alert.Message
        <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
}
```

**Why this is good:**
- Consistent alert styling across the app
- Type-safe message types
- Reusable and maintainable
- Easy to extend with additional features (icons, auto-dismiss, etc.)

---

### Do's and Don'ts

#### Do's

- ✅ **Use strongly-typed models for primary data** - Type safety, IntelliSense, and refactoring support

- ✅ **Use TempData for messages after redirects** - Perfect for PRG pattern success/error messages

- ✅ **Check for null before accessing ViewBag properties** - Avoid runtime errors from missing data
  ```csharp
  @if (ViewBag.Message != null)
  {
      <p>@ViewBag.Message</p>
  }
  ```

- ✅ **Use Session for user-specific, long-term data** - Shopping carts, preferences, multi-step forms

- ✅ **Configure Session timeout appropriately** - Balance user experience with server resources
  ```csharp
  options.IdleTimeout = TimeSpan.FromMinutes(30);
  ```

- ✅ **Keep Session data small** - Only store necessary information, use database for large datasets

- ✅ **Clear sensitive data from Session when done** - Don't keep unnecessary data in memory

#### Don'ts

- ❌ **Don't use ViewData/ViewBag for complex objects** - Use ViewModels instead
  - **Instead:** Create a strongly-typed ViewModel

- ❌ **Don't store large objects in Session** - Performance and memory issues
  - **Instead:** Store only IDs and fetch data from database when needed

- ❌ **Don't use ViewData/ViewBag as a crutch to avoid creating ViewModels** - Only for simple metadata
  - **Instead:** Invest time in proper ViewModel design

- ❌ **Don't rely on Session for critical data** - Can be lost (server restart, timeout, cleared cookies)
  - **Instead:** Persist important data to a database

- ❌ **Don't forget to configure Session middleware** - Session won't work without proper setup
  - **Instead:** Add `AddSession()` and `UseSession()` in Program.cs

- ❌ **Don't store sensitive data in unencrypted Session** - Security risk
  - **Instead:** Use encrypted session providers or avoid storing sensitive data in session

- ❌ **Don't use TempData for data that needs to persist longer than one redirect** - Wrong tool
  - **Instead:** Use Session for multi-request data

### Performance Considerations

**Performance tips:**

1. **Minimize Session serialization overhead** - Session data is serialized/deserialized on each request
   ```csharp
   // Bad - stores large object
   Session.SetObject("AllPokemon", listOf10000Pokemon);

   // Good - stores only necessary IDs
   Session.SetObject("SelectedPokemonIds", selectedIds);
   ```

2. **Use ViewBag sparingly** - Dynamic resolution has overhead compared to strongly-typed models
   ```csharp
   // Less performant
   ViewBag.Data = complexObject;

   // More performant
   var viewModel = new MyViewModel { Data = complexObject };
   ```

3. **Clear TempData when no longer needed** - Frees up cookie space
   ```csharp
   if (someCondition)
   {
       TempData.Clear(); // No longer needed
   }
   ```

**Common performance pitfalls:**

- **Storing too much in Session** - Increases memory usage and serialization time
  - **How to avoid:** Store minimal data, use database for large datasets

- **Excessive ViewBag usage** - Dynamic lookups are slower than strongly-typed properties
  - **How to avoid:** Use ViewModels for primary data

- **Not configuring Session timeout** - Sessions linger in memory unnecessarily
  - **How to avoid:** Set appropriate `IdleTimeout` based on your application needs

---

## 11. Troubleshooting & Common Issues

### Frequently Encountered Problems

#### Problem 1: ViewBag/ViewData is null in the view

**Symptoms:**
- NullReferenceException when accessing ViewBag properties
- Empty or missing data in the view
- Data displays correctly in debugger but not in view

**Cause:**
Most commonly caused by redirecting instead of returning the view directly. ViewData/ViewBag are request-scoped and don't survive redirects.

**Solution:**
```csharp
// WRONG - ViewBag lost on redirect
public IActionResult Index()
{
    ViewBag.Message = "Hello";
    return RedirectToAction("Display"); // ViewBag is lost!
}

// CORRECT - Return view directly
public IActionResult Index()
{
    ViewBag.Message = "Hello";
    return View(); // ViewBag available in view
}

// If you must redirect, use TempData instead
public IActionResult Index()
{
    TempData["Message"] = "Hello";
    return RedirectToAction("Display"); // TempData survives redirect
}
```

---

#### Problem 2: TempData is always null

**Symptoms:**
- TempData values are null even after setting them
- Messages don't appear after redirect
- TempData works locally but not in production

**Cause:**
1. Session middleware not configured
2. Cookies disabled in browser
3. `UseSession()` not called before `MapControllerRoute()`

**Solution:**

**Step 1: Check Program.cs configuration:**
```csharp
var builder = WebApplication.CreateBuilder(args);

// Must have both of these
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession();
builder.Services.AddControllersWithViews();

var app = builder.Build();

// CRITICAL: UseSession() must come BEFORE MapControllerRoute()
app.UseSession(); // ← Add this if missing
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

**Step 2: Verify cookies are enabled:**
- Open browser Developer Tools (F12)
- Go to Application tab → Cookies
- Look for `.AspNetCore.Session` cookie
- If missing, check browser privacy settings

**Step 3: Check HTTPS in production:**
```csharp
// If using HTTPS, ensure cookie settings are correct
builder.Services.AddSession(options =>
{
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always; // For HTTPS
    options.Cookie.SameSite = SameSiteMode.Lax;
});
```

---

#### Problem 3: Session data disappears unexpectedly

**Symptoms:**
- Session data is there, then suddenly gone
- Users lose shopping cart or preferences randomly
- Session works for a while, then stops

**Cause:**
1. Session timeout expired (default: 20 minutes of inactivity)
2. Application pool recycled (IIS/Azure)
3. Server restart
4. Using in-memory session in multi-server environment

**Solution:**

**For timeout issues:**
```csharp
// Increase timeout
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(60); // Increase to 1 hour
});
```

**For production multi-server:**
```csharp
// Use distributed cache instead of in-memory
// Option 1: SQL Server
builder.Services.AddDistributedSqlServerCache(options =>
{
    options.ConnectionString = builder.Configuration.GetConnectionString("SessionDb");
    options.SchemaName = "dbo";
    options.TableName = "Sessions";
});

// Option 2: Redis (recommended for production)
builder.Services.AddStackExchangeRedisCache(options =>
{
    options.Configuration = builder.Configuration.GetConnectionString("Redis");
});

builder.Services.AddSession();
```

**For critical data:**
```csharp
// Don't rely solely on session for critical data
// Persist to database as backup
public IActionResult SaveImportant(ImportantData data)
{
    // Save to session for quick access
    HttpContext.Session.SetObject("ImportantData", data);

    // Also persist to database
    _repository.SaveUserData(User.Identity.Name, data);

    return RedirectToAction("Index");
}
```

---

#### Problem 4: TempData consumed too early

**Symptoms:**
- TempData is null on second read
- Message displays once but not again
- Data disappears after refresh

**Cause:**
TempData is marked for deletion after being read once (default behavior).

**Solution:**
```csharp
// Option 1: Use Peek to read without consuming
var message = TempData.Peek("Message"); // Still available next time

// Option 2: Use Keep after reading
var message = TempData["Message"];
TempData.Keep("Message"); // Keep for one more request

// Option 3: Keep all TempData
TempData.Keep(); // Keep all TempData for another request

// Option 4: Check existence before reading
if (TempData.ContainsKey("Message"))
{
    var message = TempData["Message"];
    // Process message
}
```

---

#### Problem 5: "Cannot access session state" error

**Symptoms:**
- Exception: "Session has not been configured for this application"
- Error when trying to access HttpContext.Session

**Cause:**
Session services not registered or middleware not added.

**Solution:**
```csharp
// Program.cs - Add these in correct order
var builder = WebApplication.CreateBuilder(args);

// 1. Register session services
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession();
builder.Services.AddControllersWithViews();

var app = builder.Build();

// 2. Add session middleware
app.UseRouting();
app.UseSession(); // Must be after UseRouting
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

---

#### Problem 6: Type casting errors with ViewData

**Symptoms:**
- InvalidCastException when reading ViewData
- "Unable to cast object of type X to type Y"

**Cause:**
Wrong type cast or object stored with different type than expected.

**Solution:**
```csharp
// WRONG - Invalid cast
ViewData["Count"] = "10"; // Stored as string
var count = (int)ViewData["Count"]; // ERROR: Can't cast string to int

// CORRECT - Use safe casting
ViewData["Count"] = "10";
if (int.TryParse(ViewData["Count"]?.ToString(), out int count))
{
    // Use count safely
}

// BETTER - Use ViewBag for simpler syntax
ViewBag.Count = 10; // No casting needed
var count = ViewBag.Count; // Works

// BEST - Use strongly-typed model
public class MyViewModel
{
    public int Count { get; set; }
}
```

---

### Error Messages Explained

| Error Message | Meaning | Solution |
|---------------|---------|----------|
| `Session has not been configured` | Session services not registered | Add `AddSession()` in Program.cs |
| `Object reference not set to an instance` on ViewBag | ViewBag property doesn't exist | Add null check: `@if (ViewBag.X != null)` |
| `Unable to cast object` with ViewData | Wrong type cast | Use safe casting or correct type |
| `The session cannot be established` | Session middleware not in pipeline | Add `app.UseSession()` before routing |
| `TempData requires a registered provider` | TempData provider missing | Configure session (TempData uses session by default) |

### Debugging Strategies

**Step-by-step debugging:**

1. **Check data is set in controller:**
   ```csharp
   // Add breakpoint here
   ViewBag.Message = "Test";
   TempData["Info"] = "Test";
   // Inspect values in debugger
   ```

2. **Verify view receives data:**
   ```cshtml
   @* Add this to view *@
   <p>ViewBag.Message: @ViewBag.Message</p>
   <p>TempData["Info"]: @TempData["Info"]</p>
   ```

3. **Check for redirects:**
   ```csharp
   // If this is a redirect, ViewBag won't work
   return RedirectToAction("Index"); // Check this!
   ```

4. **Inspect cookies (for TempData/Session):**
   - Open browser DevTools (F12)
   - Go to Application → Cookies
   - Look for `.AspNetCore.Session`

5. **Check middleware order:**
   ```csharp
   // Correct order
   app.UseRouting();
   app.UseSession(); // Before MapControllerRoute
   app.MapControllerRoute(...);
   ```

**Useful debugging commands:**
```csharp
// In controller - log all ViewData
foreach (var kvp in ViewData)
{
    Debug.WriteLine($"ViewData[{kvp.Key}] = {kvp.Value}");
}

// Log all TempData
foreach (var kvp in TempData)
{
    Debug.WriteLine($"TempData[{kvp.Key}] = {kvp.Value}");
}

// Check session availability
Debug.WriteLine($"Session available: {HttpContext.Session.IsAvailable}");

// Log all session keys
foreach (var key in HttpContext.Session.Keys)
{
    Debug.WriteLine($"Session key: {key}");
}
```

### Where to Get Help

- **Official Documentation**:
  - [ASP.NET Core MVC Docs](https://learn.microsoft.com/en-us/aspnet/core/mvc/overview)
  - [Session and State Management](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/app-state)

- **Community Forum**: [ASP.NET Forums](https://forums.asp.net/)

- **Stack Overflow Tags**: [`asp.net-core-mvc`](https://stackoverflow.com/questions/tagged/asp.net-core-mvc), [`tempdata`](https://stackoverflow.com/questions/tagged/tempdata), [`viewbag`](https://stackoverflow.com/questions/tagged/viewbag)

- **GitHub Issues**: [ASP.NET Core GitHub](https://github.com/dotnet/aspnetcore/issues)

- **Discord/Slack**: [.NET Discord Community](https://discord.gg/dotnet)

---

## 12. Additional Resources

### Official Documentation
- [Pass data to views in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/mvc/views/overview)
- [Session and state management in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/app-state)
- [TempData in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/app-state#tempdata)
- [Distributed caching in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/performance/caching/distributed)

### Recommended Tutorials
- [Microsoft Learn: Create web apps with ASP.NET Core for beginners](https://learn.microsoft.com/en-us/training/paths/aspnet-core-web-app/) - Comprehensive learning path
- [Pluralsight: ASP.NET Core MVC](https://www.pluralsight.com/courses/aspdotnet-core-mvc-building-first-app) - In-depth video course
- [.NET Blog: Session State](https://devblogs.microsoft.com/dotnet/session-state-in-asp-net-core/) - Official blog post

### Video Resources
- [IAmTimCorey: ASP.NET Core MVC Tutorial](https://www.youtube.com/watch?v=hZ1DASYd9rk) - Beginner-friendly tutorial series
- [Kudvenkat: ASP.NET Core Tutorial](https://www.youtube.com/playlist?list=PL6n9fhu94yhVkdrusLaQsfERmL_Jh4XmU) - Detailed explanation of MVC concepts

### Books
- **Pro ASP.NET Core 6** by Adam Freeman - Comprehensive guide covering all MVC concepts including data passing
- **ASP.NET Core in Action, Third Edition** by Andrew Lock - Practical approach to building web applications

### Community Resources
- [Reddit: r/dotnet](https://www.reddit.com/r/dotnet/)
- [Reddit: r/csharp](https://www.reddit.com/r/csharp/)
- [.NET Developer Community](https://dotnet.microsoft.com/en-us/platform/community)

### Related Technologies
- **ViewModels** - Learn about strongly-typed models for better data passing
  - See: `docs/v2026/topics/viewmodels.md`
- **Razor Views** - Understanding view syntax helps with accessing passed data
  - See: `docs/v2026/topics/razor-views-syntax.md`
- **MVC Controllers** - Controllers are where data passing begins
  - See: `docs/v2026/topics/mvc-controllers.md`

### Next Steps

After mastering data passing in MVC, consider learning:

1. **Tag Helpers** - Cleaner syntax for creating forms and working with data
   - Why: Improves view code readability and maintainability

2. **Partial Views** - Reusable view components that can receive data
   - Why: Better code organization and reusability

3. **View Components** - More powerful alternative to partial views with their own controller logic
   - Why: Better encapsulation and testability for complex UI components

4. **AJAX and JavaScript** - Client-side data loading and updates
   - Why: Create more dynamic, responsive user interfaces

5. **SignalR** - Real-time communication between server and clients
   - Why: Push data to clients without page refresh

---

## Appendix

### Glossary

**ViewData**: A dictionary-based mechanism that stores key-value pairs to pass data from a controller to a view within a single HTTP request.

**ViewBag**: A dynamic wrapper around ViewData that provides property-based syntax for passing data from controller to view.

**TempData**: A storage mechanism that persists data across HTTP requests, typically used to pass data after a redirect.

**Session**: Long-term storage for user-specific data that persists across multiple HTTP requests until the session expires or is cleared.

**Request Scope**: The lifetime of data that exists only for a single HTTP request-response cycle.

**Cross-Request Scope**: Data that survives beyond a single request, persisting across redirects or multiple requests.

**Post-Redirect-Get (PRG)**: A design pattern where form submissions (POST) are followed by a redirect, which triggers a new GET request to display the result.

**Cookie**: Small piece of data stored in the user's browser, used by TempData and Session to maintain state.

**Serialization**: The process of converting objects into a format that can be stored (like JSON), required for storing complex objects in Session.

**Idle Timeout**: The duration of inactivity after which Session data expires and is cleared.

**State Management**: Techniques for preserving data across HTTP requests in a stateless protocol like HTTP.

**Strongly-Typed**: Data structures where types are known and checked at compile time, providing safety and IntelliSense support.

**Dynamic Typing**: Type resolution that happens at runtime rather than compile time, as used by ViewBag.

### Comparison Table of All Approaches

| Feature | ViewData | ViewBag | TempData | Session |
|---------|----------|---------|----------|---------|
| **Syntax** | Dictionary (`ViewData["Key"]`) | Dynamic (`ViewBag.Property`) | Dictionary (`TempData["Key"]`) | Methods (`Session.SetString()`) |
| **Type Safety** | No (requires casting) | No (dynamic) | No (requires casting) | Partial (typed methods) |
| **Scope** | Single request | Single request | Cross-request (1 extra) | Multi-request |
| **Survives Redirect** | ❌ No | ❌ No | ✅ Yes | ✅ Yes |
| **Storage Location** | Server memory | Server memory | Cookie (default) | Server memory/distributed |
| **Lifetime** | Current request | Current request | Until read (+1 request) | Until timeout/clear |
| **IntelliSense** | Keys only | ❌ No | Keys only | ✅ Yes (methods) |
| **Null Safety** | Requires check | Requires check | Requires check | Requires check |
| **Performance** | Fast | Slightly slower (dynamic) | Moderate (serialization) | Moderate (serialization) |
| **Best For** | Metadata, flags | Metadata, simple values | Messages after redirect | User-specific long-term data |
| **Configuration Required** | ❌ No | ❌ No | ⚠️ Session (default) | ✅ Yes |

### When to Use Each Mechanism - Decision Tree

```
Need to pass data from controller to view?
│
├─ Is it the primary data structure?
│  └─ YES → Use strongly-typed ViewModel ✅
│
├─ Is it simple metadata (title, flags)?
│  └─ YES → Use ViewBag or ViewData ✅
│
├─ Does it need to survive a redirect?
│  │
│  ├─ Just one redirect?
│  │  └─ YES → Use TempData ✅
│  │
│  └─ Multiple requests?
│     └─ YES → Use Session ✅
│
└─ Storing user-specific data long-term?
   └─ YES → Use Session ✅
```

### Quick Reference Cheat Sheet

```csharp
// VIEWDATA - Dictionary syntax
// SET
ViewData["Title"] = "My Page";
ViewData["Count"] = 42;

// GET (requires casting)
var title = ViewData["Title"] as string;
var count = (int)ViewData["Count"];

// CHECK
if (ViewData.ContainsKey("Title")) { }

//--------------------------------------

// VIEWBAG - Dynamic syntax
// SET
ViewBag.Title = "My Page";
ViewBag.Count = 42;

// GET (no casting)
var title = ViewBag.Title;
var count = ViewBag.Count;

// CHECK
if (ViewBag.Title != null) { }

//--------------------------------------

// TEMPDATA - Cross-request dictionary
// SET
TempData["Message"] = "Success!";

// GET
var message = TempData["Message"] as string;

// PEEK (read without removing)
var message = TempData.Peek("Message");

// KEEP (keep for another request)
TempData.Keep("Message");

// CHECK
if (TempData.ContainsKey("Message")) { }

//--------------------------------------

// SESSION - Long-term storage
// SET
HttpContext.Session.SetString("Username", "Ash");
HttpContext.Session.SetInt32("Level", 10);

// SET (complex object)
var json = JsonSerializer.Serialize(obj);
HttpContext.Session.SetString("Cart", json);

// GET
var username = HttpContext.Session.GetString("Username");
var level = HttpContext.Session.GetInt32("Level");

// GET (complex object)
var json = HttpContext.Session.GetString("Cart");
var cart = JsonSerializer.Deserialize<Cart>(json);

// REMOVE
HttpContext.Session.Remove("Username");

// CLEAR ALL
HttpContext.Session.Clear();

// CHECK
var exists = HttpContext.Session.Keys.Contains("Username");
```

### Configuration Quick Reference

```csharp
// Program.cs - Complete setup

var builder = WebApplication.CreateBuilder(args);

// SESSION CONFIGURATION (if using Session or TempData)
builder.Services.AddDistributedMemoryCache(); // Required for session
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.Name = ".MyApp.Session";
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always; // HTTPS only
});

builder.Services.AddControllersWithViews();

var app = builder.Build();

// MIDDLEWARE (Order matters!)
app.UseRouting();
app.UseSession(); // Must be before MapControllerRoute
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-11-23 | Initial version - Complete documentation for passing data in ASP.NET Core MVC |

---

**Estimated Reading Time**: 50-55 minutes
