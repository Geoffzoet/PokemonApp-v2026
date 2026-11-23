# Authentication and Authorization Basics

---
**Technology Version**: .NET 8.0, ASP.NET Core Identity 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-23
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What is Authentication?

**Authentication** is the process of verifying **who you are**. It's like showing your ID at the entrance to prove your identity. When you log in to a website with a username and password, you're authenticating - proving that you are who you claim to be.

In web applications, authentication typically involves:
- User provides credentials (username/password, fingerprint, etc.)
- System verifies the credentials
- If valid, system creates a session or token
- User is now "logged in" and can access protected resources

**Common authentication methods:**
- Username and password
- Social login (Google, Facebook, Microsoft)
- Two-factor authentication (2FA)
- Biometric (fingerprint, face recognition)
- API keys or tokens (for APIs)

### What is Authorization?

**Authorization** is the process of verifying **what you're allowed to do**. It happens *after* authentication. Once the system knows who you are, authorization determines what resources you can access and what actions you can perform.

Think of it like hotel key cards:
- **Authentication**: The card proves you're a guest (you checked in)
- **Authorization**: The card only opens certain rooms (not all rooms)

In applications, authorization determines:
- Can this user access this page?
- Can this user edit this data?
- Can this user perform this action?
- What features are available to this user?

### Authentication vs Authorization

| Authentication | Authorization |
|----------------|---------------|
| **Who are you?** | **What can you do?** |
| Verifies identity | Verifies permissions |
| Happens first | Happens after authentication |
| Login process | Access control |
| Example: Entering password | Example: Admin can delete, User cannot |
| Answers: Are you John? | Answers: Can John delete this? |

**Real-world analogy:**
- **Airport security** (Authentication): Show your passport to prove who you are
- **Boarding gate** (Authorization): Your ticket determines which flight you can board

### Why Use Authentication and Authorization?

You should implement auth when:

- **Protect user data** - Ensure users can only access their own information
- **Secure sensitive operations** - Restrict actions like delete, edit to authorized users
- **Personalize experience** - Show different content to different users
- **Comply with regulations** - GDPR, HIPAA require proper access controls
- **Track user actions** - Know who performed what action for audit trails
- **Monetization** - Restrict premium features to paid users

### When to Use Authentication and Authorization

**Use authentication when:**
- Users need personal accounts
- Application has user-specific data
- Need to track who does what
- Personalizing user experience
- Restricting access to any part of the app

**Use authorization when:**
- Different users have different permissions
- Some features are only for certain user types
- Need role-based access control (Admin, User, Guest)
- Protecting sensitive operations
- Implementing paid vs free tiers

---

## 2. Quick Start

**TL;DR - Add authentication to your MVC app in 5 minutes:**

**Step 1: Install ASP.NET Core Identity**

```bash
dotnet add package Microsoft.AspNetCore.Identity.EntityFrameworkCore
```

**Step 2: Update DbContext**

```csharp
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;

public class ApplicationDbContext : IdentityDbContext<IdentityUser>
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }
}
```

**Step 3: Configure in Program.cs**

```csharp
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddIdentity<IdentityUser, IdentityRole>()
    .AddEntityFrameworkStores<ApplicationDbContext>()
    .AddDefaultTokenProviders();

// After var app = builder.Build();
app.UseAuthentication();
app.UseAuthorization();
```

**Step 4: Protect a controller**

```csharp
using Microsoft.AspNetCore.Authorization;

[Authorize]  // ← Requires login
public class PokemonController : Controller
{
    public IActionResult MyPokemon()
    {
        return View();
    }
}
```

**Expected result:** Accessing `/Pokemon/MyPokemon` redirects to login page if not authenticated.

For detailed explanations, continue reading the sections below.

---

## 3. Prerequisites

### Required Knowledge

- **C# basics** - Classes, interfaces, async/await
- **ASP.NET Core MVC** - Controllers, views, routing (see POK-22)
- **Entity Framework Core** - Database context, migrations (see POK-14)
- **HTTP fundamentals** - Cookies, sessions, redirects

### Required Software/Tools

- **.NET SDK** - Version 8.0 or higher
- **Database** - SQL Server, SQLite, or PostgreSQL
- **Code Editor** - Visual Studio, VS Code, or Rider
- **Existing MVC Project** - You should have a working MVC application with EF Core

### System Requirements

- **Operating System**: Windows 10+, macOS 11+, or modern Linux
- **RAM**: 4GB minimum (8GB recommended)
- **Disk Space**: 500MB for packages and database

---

## 4. Core Concepts & Theory

### Key Concepts

#### Concept 1: Identity in ASP.NET Core

ASP.NET Core Identity is a membership system that provides:
- User account management (register, login, logout)
- Password hashing and security
- Role management
- Claims-based authorization
- Two-factor authentication
- External login providers (Google, Facebook, etc.)
- Cookie-based authentication

**Identity comes with built-in features:**
- User registration and login UI
- Password reset and email confirmation
- Lockout after failed login attempts
- Security stamp for session invalidation

#### Concept 2: Cookie Authentication

When a user logs in, Identity creates an **authentication cookie** that is sent with every subsequent request. This cookie contains encrypted information about the user.

**How it works:**

```
1. User logs in with credentials
   ↓
2. Server validates credentials
   ↓
3. Server creates encrypted authentication cookie
   ↓
4. Browser stores cookie
   ↓
5. Browser sends cookie with every request
   ↓
6. Server reads cookie to identify user
```

**Cookie contains:**
- User ID
- Username
- Roles
- Expiration time
- Security stamp

#### Concept 3: Claims

A **claim** is a piece of information about a user. Claims are name-value pairs that describe the user.

**Standard claims:**
- `ClaimTypes.NameIdentifier` - User ID
- `ClaimTypes.Name` - Username
- `ClaimTypes.Email` - Email address
- `ClaimTypes.Role` - User role

**Custom claims:**
- `"TrainerLevel"` - `"25"`
- `"Region"` - `"Kanto"`
- `"Premium"` - `"true"`

**Example:**
```csharp
var claims = new List<Claim>
{
    new Claim(ClaimTypes.NameIdentifier, "123"),
    new Claim(ClaimTypes.Name, "Ash"),
    new Claim(ClaimTypes.Email, "ash@pokemon.com"),
    new Claim(ClaimTypes.Role, "Trainer"),
    new Claim("TrainerLevel", "50")
};
```

#### Concept 4: Role-Based Authorization

**Roles** group users with similar permissions. Common roles:
- `Admin` - Full access to everything
- `Moderator` - Can manage content but not users
- `User` - Regular user access
- `Guest` - Limited read-only access

**Usage:**
```csharp
[Authorize(Roles = "Admin")]
public IActionResult DeletePokemon(int id)
{
    // Only admins can delete
}

[Authorize(Roles = "Admin,Moderator")]
public IActionResult EditPokemon(int id)
{
    // Admins OR Moderators can edit
}
```

#### Concept 5: Policy-Based Authorization

**Policies** are more flexible than roles. A policy defines requirements that must be met.

**Example policies:**
- `"RequireAdminRole"` - User must be in Admin role
- `"MinimumAge18"` - User must be 18 or older
- `"PremiumSubscription"` - User must have active subscription

**Define policy:**
```csharp
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("RequireAdmin", policy =>
        policy.RequireRole("Admin"));

    options.AddPolicy("MinimumAge18", policy =>
        policy.RequireClaim("Age", "18", "19", "20")); // ... and so on
});
```

**Use policy:**
```csharp
[Authorize(Policy = "RequireAdmin")]
public IActionResult AdminPanel()
{
    return View();
}
```

#### Concept 6: The [Authorize] Attribute

The `[Authorize]` attribute is the primary way to protect endpoints.

**Apply to controller** (all actions require auth):
```csharp
[Authorize]
public class ProfileController : Controller
{
    // All actions require authentication
}
```

**Apply to action** (specific action requires auth):
```csharp
public class HomeController : Controller
{
    public IActionResult Index() => View(); // Public

    [Authorize]
    public IActionResult Dashboard() => View(); // Requires login
}
```

**Allow anonymous access**:
```csharp
[Authorize]
public class ProfileController : Controller
{
    [AllowAnonymous]  // This action is public
    public IActionResult PublicProfile(int userId)
    {
        return View();
    }

    public IActionResult MyProfile()  // Requires auth
    {
        return View();
    }
}
```

### Important Terminology

| Term | Definition |
|------|------------|
| **Authentication** | Verifying who the user is (identity) |
| **Authorization** | Verifying what the user can do (permissions) |
| **Identity** | ASP.NET Core's authentication/authorization framework |
| **Claims** | Information about a user (name, email, role, etc.) |
| **Principal** | The authenticated user and their claims |
| **Role** | A group of users with similar permissions |
| **Policy** | A set of requirements for authorization |
| **[Authorize]** | Attribute to require authentication/authorization |
| **Cookie** | Encrypted data sent with requests to identify user |
| **Session** | Server-side storage of user data |
| **Sign In** | Authenticate user and create auth cookie |
| **Sign Out** | Invalidate auth cookie and end session |

### Architecture Overview

**How authentication works in ASP.NET Core:**

```
┌─────────────────────────────────────────────┐
│          HTTP Request                       │
│  Cookie: .AspNetCore.Identity.Application   │
└─────────────────┬───────────────────────────┘
                  │
         ┌────────▼────────┐
         │  Middleware     │
         │  Pipeline       │
         └────────┬────────┘
                  │
         ┌────────▼────────────┐
         │  Authentication     │
         │  Middleware         │
         │  - Reads cookie     │
         │  - Validates user   │
         │  - Sets User        │
         │    property         │
         └────────┬────────────┘
                  │
         ┌────────▼────────────┐
         │  Authorization      │
         │  Middleware         │
         │  - Checks [Authorize]│
         │  - Validates roles  │
         │  - Enforces policies│
         └────────┬────────────┘
                  │
              Authorized?
                  │
         ┌────────▼────────┐
         │  YES            │
         └────────┬────────┘
                  │
         ┌────────▼────────┐
         │  Controller     │
         │  Action         │
         │  User.Identity  │
         │  available      │
         └────────┬────────┘
                  │
         ┌────────▼────────┐
         │  Response       │
         └─────────────────┘
```

---

## 5. Installation Guide

### Step 1: Install Required Packages

```bash
# ASP.NET Core Identity with EF Core
dotnet add package Microsoft.AspNetCore.Identity.EntityFrameworkCore

# EF Core SQL Server provider (if not already installed)
dotnet add package Microsoft.EntityFrameworkCore.SqlServer

# EF Core tools for migrations
dotnet add package Microsoft.EntityFrameworkCore.Tools
```

### Step 2: Update Database Context

**Before (without Identity):**
```csharp
public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public DbSet<Pokemon> Pokemon { get; set; }
}
```

**After (with Identity):**
```csharp
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;

public class ApplicationDbContext : IdentityDbContext<IdentityUser>
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public DbSet<Pokemon> Pokemon { get; set; }
}
```

**What changed:**
- Inherit from `IdentityDbContext<IdentityUser>` instead of `DbContext`
- Identity adds tables for users, roles, claims automatically

### Step 3: Create Initial Migration

```bash
# Create migration
dotnet ef migrations add AddIdentity

# Apply to database
dotnet ef database update
```

**Identity tables created:**
- `AspNetUsers` - User accounts
- `AspNetRoles` - Roles
- `AspNetUserRoles` - User-role relationships
- `AspNetUserClaims` - User claims
- `AspNetUserLogins` - External logins
- `AspNetUserTokens` - Tokens for password reset, etc.

### Step 4: Verify Installation

Check that tables were created in your database:

```sql
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE 'AspNet%';
```

Should see 7 AspNet* tables.

---

## 6. Initial Setup & Configuration

### Configure Identity in Program.cs

**Complete configuration:**

```csharp
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add database context
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection")));

// Add Identity
builder.Services.AddIdentity<IdentityUser, IdentityRole>(options =>
{
    // Password settings
    options.Password.RequireDigit = true;
    options.Password.RequireLowercase = true;
    options.Password.RequireUppercase = true;
    options.Password.RequireNonAlphanumeric = false;
    options.Password.RequiredLength = 6;

    // Lockout settings
    options.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromMinutes(5);
    options.Lockout.MaxFailedAccessAttempts = 5;
    options.Lockout.AllowedForNewUsers = true;

    // User settings
    options.User.RequireUniqueEmail = true;

    // Sign in settings
    options.SignIn.RequireConfirmedEmail = false;
    options.SignIn.RequireConfirmedPhoneNumber = false;
})
.AddEntityFrameworkStores<ApplicationDbContext>()
.AddDefaultTokenProviders();

// Configure cookie
builder.Services.ConfigureApplicationCookie(options =>
{
    options.Cookie.HttpOnly = true;
    options.ExpireTimeSpan = TimeSpan.FromHours(24);
    options.LoginPath = "/Account/Login";
    options.LogoutPath = "/Account/Logout";
    options.AccessDeniedPath = "/Account/AccessDenied";
    options.SlidingExpiration = true;
});

builder.Services.AddControllersWithViews();

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();

// IMPORTANT: Order matters!
app.UseAuthentication();  // ← Must come before UseAuthorization
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

### Configure Authorization Policies

**Add custom policies:**

```csharp
builder.Services.AddAuthorization(options =>
{
    // Require Admin role
    options.AddPolicy("RequireAdmin", policy =>
        policy.RequireRole("Admin"));

    // Require Trainer role
    options.AddPolicy("RequireTrainer", policy =>
        policy.RequireRole("Trainer", "Admin"));

    // Require specific claim
    options.AddPolicy("PremiumOnly", policy =>
        policy.RequireClaim("SubscriptionType", "Premium"));

    // Combine requirements
    options.AddPolicy("SeniorAdmin", policy =>
    {
        policy.RequireRole("Admin");
        policy.RequireClaim("YearsOfService", "5", "6", "7", "8", "9", "10");
    });
});
```

### Connection String Configuration

**appsettings.json:**

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=PokemonAppDb;Trusted_Connection=True;MultipleActiveResultSets=true"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  }
}
```

---

## 7. Basic Usage

### Creating the Account Controller

**Controllers/AccountController.cs:**

```csharp
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

public class AccountController : Controller
{
    private readonly UserManager<IdentityUser> _userManager;
    private readonly SignInManager<IdentityUser> _signInManager;

    public AccountController(
        UserManager<IdentityUser> userManager,
        SignInManager<IdentityUser> signInManager)
    {
        _userManager = userManager;
        _signInManager = signInManager;
    }

    // GET: /Account/Register
    [HttpGet]
    public IActionResult Register()
    {
        return View();
    }

    // POST: /Account/Register
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Register(RegisterViewModel model)
    {
        if (!ModelState.IsValid)
            return View(model);

        var user = new IdentityUser
        {
            UserName = model.Email,
            Email = model.Email
        };

        var result = await _userManager.CreateAsync(user, model.Password);

        if (result.Succeeded)
        {
            await _signInManager.SignInAsync(user, isPersistent: false);
            return RedirectToAction("Index", "Home");
        }

        foreach (var error in result.Errors)
        {
            ModelState.AddModelError(string.Empty, error.Description);
        }

        return View(model);
    }

    // GET: /Account/Login
    [HttpGet]
    public IActionResult Login(string returnUrl = null)
    {
        ViewData["ReturnUrl"] = returnUrl;
        return View();
    }

    // POST: /Account/Login
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Login(LoginViewModel model, string returnUrl = null)
    {
        ViewData["ReturnUrl"] = returnUrl;

        if (!ModelState.IsValid)
            return View(model);

        var result = await _signInManager.PasswordSignInAsync(
            model.Email,
            model.Password,
            model.RememberMe,
            lockoutOnFailure: true);

        if (result.Succeeded)
        {
            return RedirectToLocal(returnUrl);
        }

        if (result.IsLockedOut)
        {
            ModelState.AddModelError(string.Empty, "Account is locked out");
            return View(model);
        }

        ModelState.AddModelError(string.Empty, "Invalid login attempt");
        return View(model);
    }

    // POST: /Account/Logout
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Logout()
    {
        await _signInManager.SignOutAsync();
        return RedirectToAction("Index", "Home");
    }

    private IActionResult RedirectToLocal(string returnUrl)
    {
        if (Url.IsLocalUrl(returnUrl))
            return Redirect(returnUrl);
        else
            return RedirectToAction("Index", "Home");
    }
}
```

### View Models

**ViewModels/RegisterViewModel.cs:**

```csharp
using System.ComponentModel.DataAnnotations;

public class RegisterViewModel
{
    [Required]
    [EmailAddress]
    [Display(Name = "Email")]
    public string Email { get; set; }

    [Required]
    [StringLength(100, MinimumLength = 6)]
    [DataType(DataType.Password)]
    [Display(Name = "Password")]
    public string Password { get; set; }

    [DataType(DataType.Password)]
    [Display(Name = "Confirm password")]
    [Compare("Password", ErrorMessage = "Passwords do not match")]
    public string ConfirmPassword { get; set; }
}
```

**ViewModels/LoginViewModel.cs:**

```csharp
using System.ComponentModel.DataAnnotations;

public class LoginViewModel
{
    [Required]
    [EmailAddress]
    public string Email { get; set; }

    [Required]
    [DataType(DataType.Password)]
    public string Password { get; set; }

    [Display(Name = "Remember me?")]
    public bool RememberMe { get; set; }
}
```

### Register View

**Views/Account/Register.cshtml:**

```cshtml
@model RegisterViewModel

@{
    ViewData["Title"] = "Register";
}

<div class="row">
    <div class="col-md-6 offset-md-3">
        <h2>Create a new account</h2>
        <hr />

        <form asp-action="Register" method="post">
            <div asp-validation-summary="ModelOnly" class="text-danger"></div>

            <div class="mb-3">
                <label asp-for="Email" class="form-label"></label>
                <input asp-for="Email" class="form-control" />
                <span asp-validation-for="Email" class="text-danger"></span>
            </div>

            <div class="mb-3">
                <label asp-for="Password" class="form-label"></label>
                <input asp-for="Password" class="form-control" />
                <span asp-validation-for="Password" class="text-danger"></span>
            </div>

            <div class="mb-3">
                <label asp-for="ConfirmPassword" class="form-label"></label>
                <input asp-for="ConfirmPassword" class="form-control" />
                <span asp-validation-for="ConfirmPassword" class="text-danger"></span>
            </div>

            <button type="submit" class="btn btn-primary">Register</button>
        </form>

        <hr />
        <p>
            Already have an account? <a asp-action="Login">Log in</a>
        </p>
    </div>
</div>

@section Scripts {
    <partial name="_ValidationScriptsPartial" />
}
```

### Login View

**Views/Account/Login.cshtml:**

```cshtml
@model LoginViewModel

@{
    ViewData["Title"] = "Log in";
}

<div class="row">
    <div class="col-md-6 offset-md-3">
        <h2>Log in</h2>
        <hr />

        <form asp-action="Login" method="post">
            <input type="hidden" asp-for="@ViewData["ReturnUrl"]" />
            <div asp-validation-summary="ModelOnly" class="text-danger"></div>

            <div class="mb-3">
                <label asp-for="Email" class="form-label"></label>
                <input asp-for="Email" class="form-control" />
                <span asp-validation-for="Email" class="text-danger"></span>
            </div>

            <div class="mb-3">
                <label asp-for="Password" class="form-label"></label>
                <input asp-for="Password" class="form-control" />
                <span asp-validation-for="Password" class="text-danger"></span>
            </div>

            <div class="mb-3 form-check">
                <input asp-for="RememberMe" class="form-check-input" />
                <label asp-for="RememberMe" class="form-check-label"></label>
            </div>

            <button type="submit" class="btn btn-primary">Log in</button>
        </form>

        <hr />
        <p>
            Don't have an account? <a asp-action="Register">Register</a>
        </p>
    </div>
</div>

@section Scripts {
    <partial name="_ValidationScriptsPartial" />
}
```

### Protecting Controllers and Actions

**Require authentication for entire controller:**

```csharp
using Microsoft.AspNetCore.Authorization;

[Authorize]
public class ProfileController : Controller
{
    public IActionResult Index()
    {
        // User must be logged in
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var username = User.Identity.Name;

        return View();
    }
}
```

**Require specific role:**

```csharp
[Authorize(Roles = "Admin")]
public class AdminController : Controller
{
    public IActionResult Dashboard()
    {
        // Only admins can access
        return View();
    }
}
```

**Use policy:**

```csharp
[Authorize(Policy = "RequireTrainer")]
public class PokemonController : Controller
{
    public IActionResult MyPokemon()
    {
        return View();
    }
}
```

### Display User Info in Views

**_Layout.cshtml:**

```cshtml
<!DOCTYPE html>
<html>
<head>
    <title>@ViewData["Title"] - Pokemon App</title>
</head>
<body>
    <header>
        <nav class="navbar navbar-expand-sm">
            <div class="container">
                <a class="navbar-brand" asp-controller="Home" asp-action="Index">Pokemon App</a>
                <ul class="navbar-nav ms-auto">
                    @if (User.Identity.IsAuthenticated)
                    {
                        <li class="nav-item">
                            <span class="nav-link">Hello, @User.Identity.Name!</span>
                        </li>
                        <li class="nav-item">
                            <form asp-controller="Account" asp-action="Logout" method="post" class="d-inline">
                                <button type="submit" class="btn btn-link nav-link">Logout</button>
                            </form>
                        </li>
                    }
                    else
                    {
                        <li class="nav-item">
                            <a class="nav-link" asp-controller="Account" asp-action="Login">Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" asp-controller="Account" asp-action="Register">Register</a>
                        </li>
                    }
                </ul>
            </div>
        </nav>
    </header>

    <main>
        @RenderBody()
    </main>
</body>
</html>
```

---

## 8. Testing & Validation

### Manual Testing

**Test registration:**
1. Navigate to `/Account/Register`
2. Fill in email and password
3. Submit form
4. Should redirect to home page, logged in
5. Check navbar shows username

**Test login:**
1. Logout if logged in
2. Navigate to `/Account/Login`
3. Enter credentials
4. Submit form
5. Should redirect to home page, logged in

**Test authorization:**
1. Add `[Authorize]` to a controller
2. Try accessing without login
3. Should redirect to login page
4. After login, should access successfully

**Test role-based:**
1. Create user with Admin role
2. Create user without Admin role
3. Add `[Authorize(Roles = "Admin")]` to action
4. Test both users access the action
5. Only admin should succeed

### Unit Testing Authentication

```csharp
using Microsoft.AspNetCore.Identity;
using Moq;
using Xunit;

public class AccountControllerTests
{
    [Fact]
    public async Task Register_ValidModel_CreatesUser()
    {
        // Arrange
        var mockUserManager = MockUserManager<IdentityUser>();
        var mockSignInManager = MockSignInManager<IdentityUser>();

        mockUserManager
            .Setup(x => x.CreateAsync(It.IsAny<IdentityUser>(), It.IsAny<string>()))
            .ReturnsAsync(IdentityResult.Success);

        var controller = new AccountController(mockUserManager.Object, mockSignInManager.Object);

        var model = new RegisterViewModel
        {
            Email = "test@example.com",
            Password = "Password123!",
            ConfirmPassword = "Password123!"
        };

        // Act
        var result = await controller.Register(model);

        // Assert
        var redirectResult = Assert.IsType<RedirectToActionResult>(result);
        Assert.Equal("Index", redirectResult.ActionName);
        Assert.Equal("Home", redirectResult.ControllerName);
    }

    private Mock<UserManager<TUser>> MockUserManager<TUser>() where TUser : class
    {
        var store = new Mock<IUserStore<TUser>>();
        return new Mock<UserManager<TUser>>(store.Object, null, null, null, null, null, null, null, null);
    }

    private Mock<SignInManager<TUser>> MockSignInManager<TUser>() where TUser : class
    {
        var userManager = MockUserManager<TUser>();
        return new Mock<SignInManager<TUser>>(
            userManager.Object,
            Mock.Of<IHttpContextAccessor>(),
            Mock.Of<IUserClaimsPrincipalFactory<TUser>>(),
            null, null, null, null);
    }
}
```

### Hands-On Exercises

#### Exercise 1: Implement User Registration (Beginner)

**Objective:** Create a complete user registration system

**Task:**
1. Create RegisterViewModel with Email, Password, ConfirmPassword
2. Create Register GET and POST actions in AccountController
3. Create Register.cshtml view with form
4. Test registration flow

**Requirements:**
- Password must be at least 6 characters
- Email must be valid format
- Passwords must match
- Redirect to home after successful registration

**Solution:**
<details>
<summary>Click to reveal solution</summary>

Already covered in Basic Usage section above. Key points:
- Use `UserManager.CreateAsync()` to create user
- Use `SignInManager.SignInAsync()` to log in after registration
- Validate using data annotations on ViewModel
- Display errors from `IdentityResult.Errors`

</details>

---

#### Exercise 2: Add Role-Based Authorization (Intermediate)

**Objective:** Create Admin and Trainer roles, assign users to roles

**Task:**
1. Create a service to seed default roles
2. Add role selection during registration
3. Create admin-only page
4. Test role authorization

**Requirements:**
- Seed Admin and Trainer roles on startup
- Allow admin to view all users
- Trainers can only view their own profile
- Use `[Authorize(Roles = "Admin")]`

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Create role seeder**

```csharp
// Services/RoleSeeder.cs
public class RoleSeeder
{
    public static async Task SeedRolesAsync(RoleManager<IdentityRole> roleManager)
    {
        string[] roles = { "Admin", "Trainer", "Guest" };

        foreach (var role in roles)
        {
            if (!await roleManager.RoleExistsAsync(role))
            {
                await roleManager.CreateAsync(new IdentityRole(role));
            }
        }
    }
}
```

**Step 2: Call seeder in Program.cs**

```csharp
// After app.Build()
using (var scope = app.Services.CreateScope())
{
    var roleManager = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole>>();
    await RoleSeeder.SeedRolesAsync(roleManager);
}

app.Run();
```

**Step 3: Assign role during registration**

```csharp
[HttpPost]
public async Task<IActionResult> Register(RegisterViewModel model)
{
    if (!ModelState.IsValid)
        return View(model);

    var user = new IdentityUser
    {
        UserName = model.Email,
        Email = model.Email
    };

    var result = await _userManager.CreateAsync(user, model.Password);

    if (result.Succeeded)
    {
        // Assign default role
        await _userManager.AddToRoleAsync(user, "Trainer");

        await _signInManager.SignInAsync(user, isPersistent: false);
        return RedirectToAction("Index", "Home");
    }

    foreach (var error in result.Errors)
    {
        ModelState.AddModelError(string.Empty, error.Description);
    }

    return View(model);
}
```

**Step 4: Create admin controller**

```csharp
[Authorize(Roles = "Admin")]
public class AdminController : Controller
{
    private readonly UserManager<IdentityUser> _userManager;

    public AdminController(UserManager<IdentityUser> userManager)
    {
        _userManager = userManager;
    }

    public IActionResult Users()
    {
        var users = _userManager.Users.ToList();
        return View(users);
    }
}
```

</details>

---

#### Exercise 3: Implement Custom Authorization Policy (Challenge)

**Objective:** Create a policy that requires users to have a minimum trainer level

**Task:**
1. Add TrainerLevel claim during registration
2. Create "MinimumTrainerLevel5" policy
3. Create endpoint that requires this policy
4. Test with users of different levels

**Requirements:**
- Add TrainerLevel as a claim (default to 1)
- Policy should require TrainerLevel >= 5
- Create "LegendaryPokemon" page that requires policy
- Low-level trainers should be denied access

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Step 1: Add claim during registration**

```csharp
[HttpPost]
public async Task<IActionResult> Register(RegisterViewModel model)
{
    // ... create user ...

    if (result.Succeeded)
    {
        await _userManager.AddToRoleAsync(user, "Trainer");

        // Add TrainerLevel claim
        await _userManager.AddClaimAsync(user,
            new Claim("TrainerLevel", "1")); // Start at level 1

        await _signInManager.SignInAsync(user, isPersistent: false);
        return RedirectToAction("Index", "Home");
    }

    // ... handle errors ...
}
```

**Step 2: Create policy**

```csharp
// Program.cs
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("MinimumTrainerLevel5", policy =>
        policy.RequireAssertion(context =>
        {
            var levelClaim = context.User.FindFirst("TrainerLevel");
            if (levelClaim != null && int.TryParse(levelClaim.Value, out int level))
            {
                return level >= 5;
            }
            return false;
        }));
});
```

**Step 3: Use policy**

```csharp
public class PokemonController : Controller
{
    [Authorize(Policy = "MinimumTrainerLevel5")]
    public IActionResult LegendaryPokemon()
    {
        return View();
    }
}
```

**Step 4: Test**
- Register as new user (level 1)
- Try accessing /Pokemon/LegendaryPokemon
- Should be denied (access denied page)
- Manually update claim to level 5 in database or create service to level up
- Try again - should succeed

</details>

---

### Self-Assessment Checklist

After completing this guide, you should be able to:

- [ ] Explain the difference between authentication and authorization
- [ ] Install and configure ASP.NET Core Identity
- [ ] Create user registration and login functionality
- [ ] Use `[Authorize]` attribute to protect endpoints
- [ ] Implement role-based authorization
- [ ] Create and use authorization policies
- [ ] Access user information in controllers and views
- [ ] Configure authentication cookies
- [ ] Understand claims and how to use them
- [ ] Seed roles and assign users to roles
- [ ] Test authentication and authorization

---

## 9. Practical Examples

### Example 1: Personal Pokemon Collection

**Scenario:** Users can only view/edit their own Pokemon collection.

**Models/Pokemon.cs:**

```csharp
public class Pokemon
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }
    public int Level { get; set; }

    // Link to user
    public string UserId { get; set; }
    public IdentityUser User { get; set; }
}
```

**Controllers/PokemonController.cs:**

```csharp
[Authorize]
public class PokemonController : Controller
{
    private readonly ApplicationDbContext _context;
    private readonly UserManager<IdentityUser> _userManager;

    public PokemonController(
        ApplicationDbContext context,
        UserManager<IdentityUser> userManager)
    {
        _context = context;
        _userManager = userManager;
    }

    // GET: My Pokemon
    public async Task<IActionResult> MyPokemon()
    {
        var userId = _userManager.GetUserId(User);

        var pokemon = await _context.Pokemon
            .Where(p => p.UserId == userId)
            .ToListAsync();

        return View(pokemon);
    }

    // POST: Add Pokemon
    [HttpPost]
    public async Task<IActionResult> AddPokemon(Pokemon pokemon)
    {
        // Automatically assign to current user
        pokemon.UserId = _userManager.GetUserId(User);

        _context.Pokemon.Add(pokemon);
        await _context.SaveChangesAsync();

        return RedirectToAction(nameof(MyPokemon));
    }

    // POST: Delete Pokemon (only owner can delete)
    [HttpPost]
    public async Task<IActionResult> Delete(int id)
    {
        var userId = _userManager.GetUserId(User);
        var pokemon = await _context.Pokemon.FindAsync(id);

        if (pokemon == null)
            return NotFound();

        // Verify ownership
        if (pokemon.UserId != userId)
            return Forbid(); // 403 Forbidden

        _context.Pokemon.Remove(pokemon);
        await _context.SaveChangesAsync();

        return RedirectToAction(nameof(MyPokemon));
    }
}
```

---

### Example 2: Admin User Management

**Scenario:** Admins can view all users and manage roles.

**Controllers/AdminController.cs:**

```csharp
[Authorize(Roles = "Admin")]
public class AdminController : Controller
{
    private readonly UserManager<IdentityUser> _userManager;
    private readonly RoleManager<IdentityRole> _roleManager;

    public AdminController(
        UserManager<IdentityUser> userManager,
        RoleManager<IdentityRole> roleManager)
    {
        _userManager = userManager;
        _roleManager = roleManager;
    }

    // GET: All Users
    public async Task<IActionResult> Users()
    {
        var users = _userManager.Users.ToList();

        var userViewModels = new List<UserRoleViewModel>();

        foreach (var user in users)
        {
            var roles = await _userManager.GetRolesAsync(user);

            userViewModels.Add(new UserRoleViewModel
            {
                UserId = user.Id,
                Email = user.Email,
                Roles = roles.ToList()
            });
        }

        return View(userViewModels);
    }

    // GET: Edit User Roles
    public async Task<IActionResult> EditRoles(string userId)
    {
        var user = await _userManager.FindByIdAsync(userId);
        if (user == null)
            return NotFound();

        var userRoles = await _userManager.GetRolesAsync(user);
        var allRoles = _roleManager.Roles.Select(r => r.Name).ToList();

        var model = new EditRolesViewModel
        {
            UserId = user.Id,
            Email = user.Email,
            UserRoles = userRoles.ToList(),
            AllRoles = allRoles
        };

        return View(model);
    }

    // POST: Update User Roles
    [HttpPost]
    public async Task<IActionResult> EditRoles(EditRolesViewModel model)
    {
        var user = await _userManager.FindByIdAsync(model.UserId);
        if (user == null)
            return NotFound();

        // Remove all current roles
        var userRoles = await _userManager.GetRolesAsync(user);
        await _userManager.RemoveFromRolesAsync(user, userRoles);

        // Add selected roles
        if (model.SelectedRoles != null && model.SelectedRoles.Any())
        {
            await _userManager.AddToRolesAsync(user, model.SelectedRoles);
        }

        return RedirectToAction(nameof(Users));
    }
}

public class UserRoleViewModel
{
    public string UserId { get; set; }
    public string Email { get; set; }
    public List<string> Roles { get; set; }
}

public class EditRolesViewModel
{
    public string UserId { get; set; }
    public string Email { get; set; }
    public List<string> UserRoles { get; set; }
    public List<string> AllRoles { get; set; }
    public List<string> SelectedRoles { get; set; }
}
```

---

## 10. Common Patterns & Best Practices

### Do's

✅ **Always use HTTPS**
```csharp
app.UseHttpsRedirection();
```

✅ **Hash passwords (Identity does this automatically)**
```csharp
// Don't store plain text passwords!
// Identity handles hashing automatically
await _userManager.CreateAsync(user, password);
```

✅ **Use strong password requirements**
```csharp
options.Password.RequiredLength = 8;
options.Password.RequireDigit = true;
options.Password.RequireUppercase = true;
```

✅ **Implement account lockout**
```csharp
options.Lockout.MaxFailedAccessAttempts = 5;
options.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromMinutes(15);
```

✅ **Use `[ValidateAntiForgeryToken]` on POST actions**
```csharp
[HttpPost]
[ValidateAntiForgeryToken]
public async Task<IActionResult> Login(LoginViewModel model) { }
```

### Don'ts

❌ **Don't store passwords in plain text**
❌ **Don't hardcode credentials in source code**
❌ **Don't forget to add authentication middleware**
❌ **Don't use weak password requirements in production**
❌ **Don't expose user IDs in URLs unnecessarily**

---

## 11. Troubleshooting & Common Issues

### Problem: Unable to access protected pages (always redirected to login)

**Cause:** Authentication middleware not added or in wrong order.

**Solution:**
```csharp
// Correct order:
app.UseAuthentication();  // ← First
app.UseAuthorization();   // ← Second
```

### Problem: Password validation fails with weak passwords

**Cause:** Default password requirements are strict.

**Solution:** Adjust in Program.cs:
```csharp
options.Password.RequiredLength = 6;
options.Password.RequireNonAlphanumeric = false;
```

### Problem: User always null in controller

**Cause:** Not using `[Authorize]` attribute or authentication not configured.

**Solution:**
```csharp
[Authorize]
public class MyController : Controller
{
    public IActionResult Index()
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        // Now userId has a value
    }
}
```

---

## 12. Additional Resources

### Official Documentation

- [ASP.NET Core Identity](https://learn.microsoft.com/aspnet/core/security/authentication/identity)
- [Authorization in ASP.NET Core](https://learn.microsoft.com/aspnet/core/security/authorization/introduction)
- [Claims-based authorization](https://learn.microsoft.com/aspnet/core/security/authorization/claims)

### Next Steps

After mastering authentication and authorization:

1. **Two-Factor Authentication** - Add extra security layer
2. **External Login Providers** - Google, Facebook, Microsoft login
3. **JWT Tokens** - For API authentication (see POK-37)
4. **Custom User Properties** - Extend IdentityUser
5. **Email Confirmation** - Verify user email addresses

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-11-23 | Initial comprehensive documentation for Authentication and Authorization |

---

**Estimated Reading Time**: 65-70 minutes

**Prerequisites**: ASP.NET Core fundamentals (POK-10), Entity Framework Core (POK-14)

**Related Topics**: JWT Tokens (POK-37), Filters (POK-38), Security Best Practices
