# CORS (Cross-Origin Resource Sharing)

**Estimated Reading Time**: 35-40 minutes
**Prerequisites**: HTTP Basics, Web API Fundamentals
**Module**: ASP.NET Core Web API (Module 2)
**Difficulty**: Intermediate

---

## Table of Contents
1. [Overview & Introduction](#1-overview--introduction)
2. [What You'll Learn](#2-what-youll-learn)
3. [Prerequisites](#3-prerequisites)
4. [Core Concepts & Theory](#4-core-concepts--theory)
5. [Initial Setup & Configuration](#5-initial-setup--configuration)
6. [Basic Usage](#6-basic-usage)
7. [Advanced Features](#7-advanced-features)
8. [Common Patterns & Best Practices](#8-common-patterns--best-practices)
9. [Troubleshooting](#9-troubleshooting)
10. [Performance Considerations](#10-performance-considerations)
11. [Real-World Examples](#11-real-world-examples)
12. [Hands-on Exercises](#12-hands-on-exercises)

---

## 1. Overview & Introduction

### What is CORS?

**CORS (Cross-Origin Resource Sharing)** is a security feature implemented by web browsers that controls how web pages from one domain can request resources from another domain. It's a relaxation of the Same-Origin Policy that allows secure cross-origin requests.

### Why CORS Exists

Modern web applications often have:
- **Frontend**: Running on `http://localhost:3000` (React, Angular, Vue)
- **Backend API**: Running on `http://localhost:5000` (ASP.NET Core)

By default, browsers **block** these cross-origin requests for security. CORS provides a way to safely allow them.

### Real-World Scenario

```
Frontend (React App)          Backend (ASP.NET Core API)
http://myapp.com              https://api.myapp.com
       |                               |
       |------ GET /api/pokemon ------>|
       |                               |
       |<----- ❌ BLOCKED BY BROWSER --|

Why? Different origins = Security risk!
```

Without CORS configuration, the browser blocks this request, even though both are part of your application.

### When You Need CORS

You need CORS when:
- Building a Single Page Application (SPA) that calls your API
- Your frontend and backend are on different domains/ports
- Creating a public API consumed by other websites
- Developing locally with separate frontend/backend servers

---

## 2. What You'll Learn

By the end of this guide, you'll understand:

- ✅ What the Same-Origin Policy is and why it matters
- ✅ How CORS works under the hood
- ✅ How to configure CORS in ASP.NET Core
- ✅ Different CORS policies (restrictive vs permissive)
- ✅ What preflight requests are and when they occur
- ✅ How to debug common CORS errors
- ✅ Security best practices for production

---

## 3. Prerequisites

### Required Knowledge

Before diving into CORS, you should understand:

1. **HTTP Basics**: Request methods (GET, POST, PUT, DELETE), headers, status codes
2. **Web API Fundamentals**: How to create API endpoints in ASP.NET Core
3. **URLs**: Understanding of protocols, domains, and ports

### Required Tools

- .NET 8 SDK or later
- Code editor (Visual Studio, VS Code, Rider)
- Browser with Developer Tools (Chrome, Firefox, Edge)
- Basic understanding of JavaScript (for testing)

### Recommended Reading

- [HTTP Fundamentals](./http-basics.md)
- [ASP.NET Core Web API](./web-api-basics.md)

---

## 4. Core Concepts & Theory

### Understanding Origins

An **origin** consists of three parts:
1. **Protocol** (scheme): `http` or `https`
2. **Domain** (host): `example.com`
3. **Port**: `:80`, `:443`, `:5000`, etc.

Two URLs have the **same origin** only if all three parts match.

**Examples**:

| URL 1 | URL 2 | Same Origin? | Reason |
|-------|-------|--------------|--------|
| `http://example.com/page1` | `http://example.com/page2` | ✅ Yes | Same protocol, domain, port |
| `http://example.com` | `https://example.com` | ❌ No | Different protocol |
| `http://example.com:80` | `http://example.com:8080` | ❌ No | Different port |
| `http://example.com` | `http://api.example.com` | ❌ No | Different subdomain |
| `http://localhost:3000` | `http://localhost:5000` | ❌ No | Different port |

### The Same-Origin Policy (SOP)

The **Same-Origin Policy** is a critical browser security mechanism that:

- **Prevents** JavaScript on one page from accessing data on another page unless they share the same origin
- **Protects** users from malicious websites stealing sensitive data
- **Blocks** cross-origin requests by default

**Why SOP Exists**: Imagine if evil.com could make requests to yourbank.com using your logged-in session. SOP prevents this!

```javascript
// On http://evil.com
fetch('https://yourbank.com/api/account')
  .then(response => response.json())
  .then(data => {
    // ❌ BLOCKED by Same-Origin Policy
    // Can't steal your bank data!
  });
```

### How CORS Relaxes SOP

CORS is a mechanism that allows servers to tell browsers: "It's okay to allow cross-origin requests from these specific origins."

The server adds special HTTP headers to responses:

```
Access-Control-Allow-Origin: http://trusted-app.com
Access-Control-Allow-Methods: GET, POST, PUT
Access-Control-Allow-Headers: Content-Type, Authorization
```

### CORS Headers Explained

#### Response Headers (Server → Browser)

| Header | Purpose | Example |
|--------|---------|---------|
| `Access-Control-Allow-Origin` | Which origins can access | `*` or `https://myapp.com` |
| `Access-Control-Allow-Methods` | Which HTTP methods allowed | `GET, POST, PUT, DELETE` |
| `Access-Control-Allow-Headers` | Which request headers allowed | `Content-Type, Authorization` |
| `Access-Control-Allow-Credentials` | Allow cookies/auth | `true` or `false` |
| `Access-Control-Max-Age` | Cache preflight response | `3600` (seconds) |
| `Access-Control-Expose-Headers` | Which headers JS can read | `X-Total-Count` |

#### Request Headers (Browser → Server)

| Header | Purpose | Example |
|--------|---------|---------|
| `Origin` | Where request came from | `https://myapp.com` |
| `Access-Control-Request-Method` | Method for preflight | `PUT` |
| `Access-Control-Request-Headers` | Headers for preflight | `Content-Type` |

### Simple vs Preflight Requests

#### Simple Requests

**Simple requests** are sent directly without a preflight check. Requirements:
- Methods: `GET`, `HEAD`, or `POST`
- Headers: Only simple headers (Content-Type with specific values, Accept, etc.)
- Content-Type: `application/x-www-form-urlencoded`, `multipart/form-data`, or `text/plain`

```javascript
// Simple request - sent immediately
fetch('https://api.example.com/pokemon', {
  method: 'GET'
});
```

#### Preflight Requests

**Preflight requests** are sent before the actual request when:
- Using methods: `PUT`, `DELETE`, `PATCH`
- Sending custom headers (e.g., `Authorization`)
- Using `Content-Type: application/json`

The browser first sends an `OPTIONS` request to check if the actual request is allowed:

```
1. Browser sends OPTIONS (preflight):
   OPTIONS /api/pokemon HTTP/1.1
   Origin: http://localhost:3000
   Access-Control-Request-Method: POST
   Access-Control-Request-Headers: Content-Type

2. Server responds:
   HTTP/1.1 204 No Content
   Access-Control-Allow-Origin: http://localhost:3000
   Access-Control-Allow-Methods: POST, PUT, DELETE
   Access-Control-Allow-Headers: Content-Type

3. Browser sends actual request:
   POST /api/pokemon HTTP/1.1
   Content-Type: application/json
   {"name": "Pikachu"}
```

### CORS Flow Diagram

```
┌──────────────┐                    ┌──────────────┐
│   Browser    │                    │    Server    │
│ (Frontend)   │                    │   (API)      │
└──────┬───────┘                    └──────┬───────┘
       │                                   │
       │  1. Request with Origin header    │
       │──────────────────────────────────>│
       │                                   │
       │                                   │ 2. Check CORS policy
       │                                   │
       │  3. Response with CORS headers    │
       │<──────────────────────────────────│
       │                                   │
       │ 4. Browser checks CORS headers    │
       │                                   │
       │ 5a. ✅ Allow if headers match     │
       │ 5b. ❌ Block if headers missing   │
       │                                   │
```

---

## 5. Initial Setup & Configuration

### Adding CORS to Your ASP.NET Core Project

CORS is built into ASP.NET Core. Here's how to set it up:

#### Step 1: Configure CORS in Program.cs

```csharp
var builder = WebApplication.CreateBuilder(args);

// Add controllers
builder.Services.AddControllers();

// Add CORS service
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("http://localhost:3000") // Frontend URL
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

var app = builder.Build();

// IMPORTANT: UseCors must be called AFTER UseRouting
// and BEFORE UseAuthentication/UseAuthorization
app.UseRouting();
app.UseCors();  // Apply CORS policy
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
```

#### Step 2: Test Your API

Create a simple controller:

```csharp
using Microsoft.AspNetCore.Mvc;

namespace PokemonApp.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll()
    {
        var pokemon = new[]
        {
            new { Id = 1, Name = "Pikachu" },
            new { Id = 2, Name = "Charizard" }
        };

        return Ok(pokemon);
    }
}
```

#### Step 3: Test from Frontend

Create a simple HTML file to test:

```html
<!DOCTYPE html>
<html>
<head>
    <title>CORS Test</title>
</head>
<body>
    <h1>CORS Test</h1>
    <button onclick="fetchPokemon()">Fetch Pokemon</button>
    <div id="result"></div>

    <script>
        async function fetchPokemon() {
            try {
                const response = await fetch('http://localhost:5000/api/pokemon');
                const data = await response.json();
                document.getElementById('result').innerHTML =
                    JSON.stringify(data, null, 2);
            } catch (error) {
                document.getElementById('result').innerHTML =
                    'Error: ' + error.message;
            }
        }
    </script>
</body>
</html>
```

Serve this HTML file on a different port (e.g., `http://localhost:3000`) and test!

### Middleware Order Matters!

The order of middleware is **critical**:

```csharp
app.UseRouting();      // 1. Must be first
app.UseCors();         // 2. Must be after UseRouting
app.UseAuthentication(); // 3. After CORS
app.UseAuthorization(); // 4. After Authentication
app.MapControllers();  // 5. Last
```

**Why?** CORS needs to intercept requests before authentication/authorization, but after routing.

---

## 6. Basic Usage

### Policy 1: Allow Specific Origin

The most common and **secure** approach:

```csharp
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("https://myapp.com", "https://www.myapp.com")
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});
```

**Use this when**: You know exactly which domains will call your API.

### Policy 2: Allow Any Origin (Development Only)

```csharp
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});
```

**⚠️ WARNING**: Never use `AllowAnyOrigin()` in production! It allows any website to call your API.

### Policy 3: Allow Specific Methods

Restrict which HTTP methods are allowed:

```csharp
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("https://myapp.com")
              .WithMethods("GET", "POST") // Only GET and POST
              .AllowAnyHeader();
    });
});
```

### Policy 4: Allow Specific Headers

Restrict which headers can be sent:

```csharp
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("https://myapp.com")
              .AllowAnyMethod()
              .WithHeaders("Content-Type", "Authorization");
    });
});
```

### Policy 5: Allow Credentials (Cookies/Auth)

If you need to send cookies or authentication:

```csharp
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("https://myapp.com")
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials(); // Allow cookies and auth headers
    });
});
```

**Note**: You **cannot** use `AllowAnyOrigin()` with `AllowCredentials()`. You must specify exact origins.

### Applying CORS to Specific Controllers

Instead of applying CORS globally, you can apply it to specific controllers or actions:

```csharp
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/[controller]")]
[EnableCors] // Uses default policy
public class PokemonController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll()
    {
        return Ok(new[] { "Pikachu", "Charizard" });
    }

    [HttpPost]
    [DisableCors] // Disable CORS for this endpoint
    public IActionResult Create()
    {
        return Ok();
    }
}
```

---

## 7. Advanced Features

### Named CORS Policies

You can define multiple policies with different rules:

```csharp
builder.Services.AddCors(options =>
{
    // Policy 1: For public API endpoints
    options.AddPolicy("PublicApi", policy =>
    {
        policy.AllowAnyOrigin()
              .WithMethods("GET")
              .AllowAnyHeader();
    });

    // Policy 2: For authenticated clients
    options.AddPolicy("AuthenticatedClients", policy =>
    {
        policy.WithOrigins("https://myapp.com", "https://admin.myapp.com")
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials();
    });

    // Policy 3: For development
    options.AddPolicy("Development", policy =>
    {
        policy.WithOrigins("http://localhost:3000", "http://localhost:4200")
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials();
    });
});

var app = builder.Build();

// Apply policy globally
app.UseCors("Development");
```

### Using Different Policies Per Controller

```csharp
[ApiController]
[Route("api/[controller]")]
[EnableCors("PublicApi")] // Public endpoints
public class PublicController : ControllerBase
{
    [HttpGet]
    public IActionResult GetData()
    {
        return Ok("Public data");
    }
}

[ApiController]
[Route("api/[controller]")]
[EnableCors("AuthenticatedClients")] // Restricted endpoints
public class AdminController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAdminData()
    {
        return Ok("Admin data");
    }
}
```

### Environment-Based CORS

Configure different policies for development vs production:

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    if (builder.Environment.IsDevelopment())
    {
        // Development: Allow localhost
        options.AddDefaultPolicy(policy =>
        {
            policy.WithOrigins("http://localhost:3000", "http://localhost:4200")
                  .AllowAnyMethod()
                  .AllowAnyHeader()
                  .AllowCredentials();
        });
    }
    else
    {
        // Production: Strict origins
        options.AddDefaultPolicy(policy =>
        {
            policy.WithOrigins("https://myapp.com", "https://www.myapp.com")
                  .AllowAnyMethod()
                  .AllowAnyHeader()
                  .AllowCredentials();
        });
    }
});
```

### Dynamic Origin Validation

Validate origins dynamically from configuration or database:

```csharp
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.SetIsOriginAllowed(origin =>
        {
            // Check if origin is in allowed list from appsettings.json
            var allowedOrigins = builder.Configuration
                .GetSection("AllowedOrigins")
                .Get<string[]>();

            return allowedOrigins?.Contains(origin) ?? false;
        })
        .AllowAnyMethod()
        .AllowAnyHeader()
        .AllowCredentials();
    });
});
```

**appsettings.json**:

```json
{
  "AllowedOrigins": [
    "https://myapp.com",
    "https://www.myapp.com",
    "https://admin.myapp.com"
  ]
}
```

### Preflight Request Caching

Reduce preflight requests by caching the response:

```csharp
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("https://myapp.com")
              .AllowAnyMethod()
              .AllowAnyHeader()
              .SetPreflightMaxAge(TimeSpan.FromHours(1)); // Cache for 1 hour
    });
});
```

The browser will cache the preflight response for 1 hour, reducing OPTIONS requests.

### Exposing Custom Response Headers

By default, JavaScript can only read a few response headers. To expose custom headers:

```csharp
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("https://myapp.com")
              .AllowAnyMethod()
              .AllowAnyHeader()
              .WithExposedHeaders("X-Total-Count", "X-Page-Number");
    });
});
```

Now JavaScript can read these headers:

```javascript
fetch('https://api.myapp.com/pokemon')
    .then(response => {
        const totalCount = response.headers.get('X-Total-Count');
        console.log('Total count:', totalCount);
        return response.json();
    });
```

---

## 8. Common Patterns & Best Practices

### Best Practice 1: Never Use `AllowAnyOrigin()` in Production

```csharp
// ❌ BAD - Security risk
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyOrigin()  // Any website can call your API!
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// ✅ GOOD - Specific origins
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("https://myapp.com")
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});
```

### Best Practice 2: Be Specific with Methods

```csharp
// ❌ BAD - Allows all methods
policy.AllowAnyMethod();

// ✅ GOOD - Only allow needed methods
policy.WithMethods("GET", "POST", "PUT", "DELETE");
```

### Best Practice 3: Use HTTPS in Production

```csharp
// ❌ BAD - Using HTTP
policy.WithOrigins("http://myapp.com");

// ✅ GOOD - Using HTTPS
policy.WithOrigins("https://myapp.com");
```

### Best Practice 4: Validate Origins from Configuration

Store allowed origins in `appsettings.json` instead of hardcoding:

```json
{
  "CorsSettings": {
    "AllowedOrigins": [
      "https://myapp.com",
      "https://www.myapp.com"
    ]
  }
}
```

```csharp
var allowedOrigins = builder.Configuration
    .GetSection("CorsSettings:AllowedOrigins")
    .Get<string[]>();

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins(allowedOrigins)
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});
```

### Best Practice 5: Use Named Policies for Different Security Levels

```csharp
// Public read-only endpoints
options.AddPolicy("Public", policy =>
{
    policy.AllowAnyOrigin()
          .WithMethods("GET")
          .AllowAnyHeader();
});

// Authenticated endpoints
options.AddPolicy("Authenticated", policy =>
{
    policy.WithOrigins("https://myapp.com")
          .AllowAnyMethod()
          .AllowAnyHeader()
          .AllowCredentials();
});
```

### Pattern: CORS + Authentication

When using CORS with authentication:

```csharp
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("https://myapp.com")
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials(); // Required for cookies and auth headers
    });
});

// Middleware order is critical!
var app = builder.Build();
app.UseRouting();
app.UseCors();         // Before authentication
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
```

### Pattern: CORS for SPAs

For Single Page Applications (React, Angular, Vue):

```csharp
// Development
if (builder.Environment.IsDevelopment())
{
    builder.Services.AddCors(options =>
    {
        options.AddDefaultPolicy(policy =>
        {
            policy.WithOrigins("http://localhost:3000", "http://localhost:4200")
                  .AllowAnyMethod()
                  .AllowAnyHeader()
                  .AllowCredentials();
        });
    });
}
// Production
else
{
    builder.Services.AddCors(options =>
    {
        options.AddDefaultPolicy(policy =>
        {
            policy.WithOrigins(
                      "https://myapp.com",
                      "https://www.myapp.com"
                  )
                  .AllowAnyMethod()
                  .AllowAnyHeader()
                  .AllowCredentials();
        });
    });
}
```

---

## 9. Troubleshooting

### Common Error 1: "CORS policy: No 'Access-Control-Allow-Origin' header"

**Error Message**:
```
Access to fetch at 'http://localhost:5000/api/pokemon' from origin
'http://localhost:3000' has been blocked by CORS policy: No
'Access-Control-Allow-Origin' header is present on the requested resource.
```

**Causes**:
1. CORS not configured in `Program.cs`
2. `app.UseCors()` not called
3. Origin not in allowed list

**Solution**:

```csharp
// Make sure these are in Program.cs
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("http://localhost:3000") // Add your frontend URL
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

var app = builder.Build();
app.UseRouting();
app.UseCors(); // Don't forget this!
```

### Common Error 2: "Credentials flag is true, but Access-Control-Allow-Credentials is not"

**Error Message**:
```
Access to fetch has been blocked by CORS policy: The value of the
'Access-Control-Allow-Credentials' header in the response is '' which
must be 'true' when the request's credentials mode is 'include'.
```

**Cause**: Frontend sending credentials but backend not allowing them.

**Solution**:

Backend:
```csharp
policy.WithOrigins("http://localhost:3000")
      .AllowAnyMethod()
      .AllowAnyHeader()
      .AllowCredentials(); // Add this
```

Frontend:
```javascript
fetch('http://localhost:5000/api/pokemon', {
    credentials: 'include' // Sends cookies
});
```

### Common Error 3: "Wildcard '*' cannot be used when credentials flag is true"

**Error Message**:
```
The CORS protocol does not allow specifying a wildcard (any) origin and
credentials at the same time.
```

**Cause**: Using `AllowAnyOrigin()` with `AllowCredentials()`.

**Solution**:

```csharp
// ❌ BAD - Can't use both
policy.AllowAnyOrigin()
      .AllowCredentials();

// ✅ GOOD - Specify exact origins
policy.WithOrigins("http://localhost:3000")
      .AllowCredentials();
```

### Common Error 4: Preflight Request Failing

**Error Message**:
```
Access to fetch has been blocked by CORS policy: Response to
preflight request doesn't pass access control check.
```

**Cause**: Server not responding correctly to OPTIONS requests.

**Solution**:

Ensure CORS middleware is configured properly:

```csharp
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("http://localhost:3000")
              .AllowAnyMethod()
              .AllowAnyHeader()
              .WithExposedHeaders("Content-Type", "Authorization");
    });
});

// Make sure UseCors is in the right place
app.UseRouting();
app.UseCors();
app.UseAuthentication();
app.UseAuthorization();
```

### Common Error 5: Middleware Order Wrong

**Symptoms**: CORS headers not appearing in responses, 401/403 before CORS check.

**Solution**: Follow this exact order:

```csharp
var app = builder.Build();

app.UseRouting();      // 1. First
app.UseCors();         // 2. After UseRouting
app.UseAuthentication(); // 3. After UseCors
app.UseAuthorization(); // 4. After UseAuthentication
app.MapControllers();  // 5. Last
```

### Debugging CORS Issues

#### Use Browser Developer Tools

1. Open Developer Tools (F12)
2. Go to Network tab
3. Make the failing request
4. Check the request headers:
   - `Origin`: Should show your frontend URL
5. Check the response headers:
   - `Access-Control-Allow-Origin`: Should match your origin or be `*`
   - `Access-Control-Allow-Methods`: Should include your method
   - `Access-Control-Allow-Headers`: Should include your headers

#### Check Preflight Requests

Look for an OPTIONS request before your actual request:

```
OPTIONS /api/pokemon HTTP/1.1
Origin: http://localhost:3000
Access-Control-Request-Method: POST
Access-Control-Request-Headers: Content-Type

Response should include:
Access-Control-Allow-Origin: http://localhost:3000
Access-Control-Allow-Methods: POST, PUT, DELETE
Access-Control-Allow-Headers: Content-Type
```

#### Add Logging

```csharp
var app = builder.Build();

app.Use(async (context, next) =>
{
    Console.WriteLine($"Request: {context.Request.Method} {context.Request.Path}");
    Console.WriteLine($"Origin: {context.Request.Headers["Origin"]}");

    await next();

    Console.WriteLine($"Response Status: {context.Response.StatusCode}");
    Console.WriteLine($"CORS Header: {context.Response.Headers["Access-Control-Allow-Origin"]}");
});

app.UseRouting();
app.UseCors();
// ... rest of middleware
```

---

## 10. Performance Considerations

### Preflight Request Optimization

Preflight requests add latency. Minimize them:

```csharp
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("https://myapp.com")
              .AllowAnyMethod()
              .AllowAnyHeader()
              .SetPreflightMaxAge(TimeSpan.FromHours(24)); // Cache for 24 hours
    });
});
```

**Impact**: Browsers cache the preflight response for 24 hours, reducing OPTIONS requests by 95%+.

### Use Simple Requests When Possible

If you can avoid preflight requests, do it:

```javascript
// ❌ Triggers preflight (Content-Type: application/json)
fetch('http://api.example.com/pokemon', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ name: 'Pikachu' })
});

// ✅ Simple request (no preflight)
fetch('http://api.example.com/pokemon', {
    method: 'POST',
    headers: { 'Content-Type': 'text/plain' },
    body: 'name=Pikachu'
});
```

However, using JSON is usually worth the preflight overhead for clarity.

### CORS Overhead

CORS checking is very lightweight:
- **Preflight request**: ~10-50ms (first time)
- **Preflight cached**: 0ms (subsequent requests)
- **CORS header validation**: <1ms

The performance impact is negligible for most applications.

---

## 11. Real-World Examples

### Example 1: React SPA with Authentication

**Backend (ASP.NET Core)**:

```csharp
// Program.cs
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddAuthentication(/* JWT config */);

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("http://localhost:3000")
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials(); // For JWT tokens
    });
});

var app = builder.Build();

app.UseRouting();
app.UseCors();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();
```

**Frontend (React)**:

```javascript
// Login and store JWT token
async function login(username, password) {
    const response = await fetch('http://localhost:5000/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include', // Send cookies
        body: JSON.stringify({ username, password })
    });

    const data = await response.json();
    localStorage.setItem('token', data.token);
}

// Make authenticated request
async function fetchPokemon() {
    const token = localStorage.getItem('token');

    const response = await fetch('http://localhost:5000/api/pokemon', {
        headers: {
            'Authorization': `Bearer ${token}`
        },
        credentials: 'include'
    });

    return await response.json();
}
```

### Example 2: Public API with Rate Limiting

**Backend**:

```csharp
builder.Services.AddCors(options =>
{
    // Public read-only endpoints
    options.AddPolicy("PublicApi", policy =>
    {
        policy.AllowAnyOrigin()
              .WithMethods("GET")
              .AllowAnyHeader();
    });

    // Authenticated write endpoints
    options.AddPolicy("Authenticated", policy =>
    {
        policy.WithOrigins("https://myapp.com")
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials();
    });
});

var app = builder.Build();

app.UseRouting();
app.UseCors();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
```

**Controllers**:

```csharp
[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    [HttpGet]
    [EnableCors("PublicApi")] // Anyone can read
    public IActionResult GetAll()
    {
        return Ok(_pokemonService.GetAll());
    }

    [HttpPost]
    [EnableCors("Authenticated")] // Only authenticated users can create
    [Authorize]
    public IActionResult Create([FromBody] Pokemon pokemon)
    {
        _pokemonService.Add(pokemon);
        return CreatedAtAction(nameof(GetById), new { id = pokemon.Id }, pokemon);
    }
}
```

### Example 3: Microservices Architecture

**API Gateway** (allows requests from frontend):

```csharp
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins(
                  "https://myapp.com",
                  "https://admin.myapp.com"
              )
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials();
    });
});
```

**Internal Services** (no CORS needed - server-to-server):

```csharp
// No CORS configuration needed
builder.Services.AddControllers();

// Internal services trust each other
// CORS only applies to browser requests
```

---

## 12. Hands-on Exercises

### Exercise 1: Basic CORS Setup

**Goal**: Create a simple API with CORS enabled for a React app.

**Requirements**:
1. Create a `WeatherController` with a `GET` endpoint that returns weather data
2. Configure CORS to allow requests from `http://localhost:3000`
3. Test with a simple HTML page

<details>
<summary>Solution</summary>

**Backend - Program.cs**:

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("http://localhost:3000")
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

var app = builder.Build();

app.UseRouting();
app.UseCors();
app.MapControllers();

app.Run();
```

**Backend - WeatherController.cs**:

```csharp
using Microsoft.AspNetCore.Mvc;

namespace CorsDemo.Controllers;

[ApiController]
[Route("api/[controller]")]
public class WeatherController : ControllerBase
{
    [HttpGet]
    public IActionResult Get()
    {
        var weather = new[]
        {
            new { City = "Paris", Temperature = 22, Condition = "Sunny" },
            new { City = "London", Temperature = 18, Condition = "Cloudy" },
            new { City = "Tokyo", Temperature = 25, Condition = "Rainy" }
        };

        return Ok(weather);
    }
}
```

**Frontend - index.html** (serve on http://localhost:3000):

```html
<!DOCTYPE html>
<html>
<head>
    <title>Weather App</title>
</head>
<body>
    <h1>Weather Data</h1>
    <button onclick="fetchWeather()">Get Weather</button>
    <div id="weather"></div>

    <script>
        async function fetchWeather() {
            try {
                const response = await fetch('http://localhost:5000/api/weather');
                const data = await response.json();

                document.getElementById('weather').innerHTML = data.map(w =>
                    `<p>${w.city}: ${w.temperature}°C - ${w.condition}</p>`
                ).join('');
            } catch (error) {
                console.error('Error:', error);
                document.getElementById('weather').innerHTML =
                    'Error: ' + error.message;
            }
        }
    </script>
</body>
</html>
```

**Testing**:
1. Run your API: `dotnet run`
2. Serve the HTML file on port 3000
3. Click "Get Weather" - should work!
4. Check Network tab to see CORS headers

</details>

---

### Exercise 2: Multiple CORS Policies

**Goal**: Create different CORS policies for public and admin endpoints.

**Requirements**:
1. Create a `PublicApi` policy that allows any origin for GET requests only
2. Create an `AdminApi` policy that allows only `http://localhost:3001` for all methods
3. Create two controllers: `PublicController` and `AdminController`
4. Apply the appropriate policy to each

<details>
<summary>Solution</summary>

**Program.cs**:

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddCors(options =>
{
    // Public API - read-only, any origin
    options.AddPolicy("PublicApi", policy =>
    {
        policy.AllowAnyOrigin()
              .WithMethods("GET")
              .AllowAnyHeader();
    });

    // Admin API - full access, restricted origin
    options.AddPolicy("AdminApi", policy =>
    {
        policy.WithOrigins("http://localhost:3001")
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials();
    });
});

var app = builder.Build();

app.UseRouting();
app.UseCors();
app.MapControllers();

app.Run();
```

**PublicController.cs**:

```csharp
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;

namespace CorsDemo.Controllers;

[ApiController]
[Route("api/[controller]")]
[EnableCors("PublicApi")]
public class PublicController : ControllerBase
{
    [HttpGet]
    public IActionResult GetData()
    {
        return Ok(new { message = "This is public data", timestamp = DateTime.UtcNow });
    }
}
```

**AdminController.cs**:

```csharp
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;

namespace CorsDemo.Controllers;

[ApiController]
[Route("api/[controller]")]
[EnableCors("AdminApi")]
public class AdminController : ControllerBase
{
    [HttpGet]
    public IActionResult GetData()
    {
        return Ok(new { message = "This is admin data" });
    }

    [HttpPost]
    public IActionResult CreateData([FromBody] object data)
    {
        return Ok(new { message = "Data created", data });
    }

    [HttpDelete("{id}")]
    public IActionResult DeleteData(int id)
    {
        return Ok(new { message = $"Data {id} deleted" });
    }
}
```

**Testing**:
1. Test public endpoint from any origin - should work for GET only
2. Test admin endpoint from http://localhost:3001 - should work for all methods
3. Test admin endpoint from different origin - should fail

</details>

---

### Exercise 3: CORS with Authentication

**Goal**: Configure CORS for an API that uses JWT authentication.

**Requirements**:
1. Create an authentication endpoint that returns a JWT token
2. Create a protected endpoint that requires authentication
3. Configure CORS to allow credentials
4. Test from a frontend that sends the JWT token

<details>
<summary>Solution</summary>

**Program.cs**:

```csharp
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

// Configure JWT Authentication
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = "your-issuer",
            ValidAudience = "your-audience",
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes("your-secret-key-min-32-characters"))
        };
    });

// Configure CORS
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("http://localhost:3000")
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials(); // Required for auth
    });
});

var app = builder.Build();

app.UseRouting();
app.UseCors();         // Before authentication
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();
```

**AuthController.cs**:

```csharp
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace CorsDemo.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    [HttpPost("login")]
    public IActionResult Login([FromBody] LoginRequest request)
    {
        // Simple validation (use real validation in production!)
        if (request.Username == "admin" && request.Password == "password")
        {
            var token = GenerateToken(request.Username);
            return Ok(new { token });
        }

        return Unauthorized();
    }

    private string GenerateToken(string username)
    {
        var claims = new[]
        {
            new Claim(ClaimTypes.Name, username),
            new Claim(ClaimTypes.Role, "Admin")
        };

        var key = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes("your-secret-key-min-32-characters"));
        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: "your-issuer",
            audience: "your-audience",
            claims: claims,
            expires: DateTime.UtcNow.AddHours(1),
            signingCredentials: credentials
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}

public class LoginRequest
{
    public string Username { get; set; }
    public string Password { get; set; }
}
```

**ProtectedController.cs**:

```csharp
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CorsDemo.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ProtectedController : ControllerBase
{
    [HttpGet]
    public IActionResult GetSecretData()
    {
        var username = User.Identity?.Name;
        return Ok(new {
            message = $"Hello {username}, this is protected data!",
            timestamp = DateTime.UtcNow
        });
    }
}
```

**Frontend - auth-test.html**:

```html
<!DOCTYPE html>
<html>
<head>
    <title>CORS Auth Test</title>
</head>
<body>
    <h1>CORS Authentication Test</h1>

    <div>
        <h2>Login</h2>
        <input id="username" type="text" placeholder="Username (admin)" />
        <input id="password" type="password" placeholder="Password (password)" />
        <button onclick="login()">Login</button>
    </div>

    <div>
        <h2>Protected Data</h2>
        <button onclick="getProtectedData()">Get Protected Data</button>
    </div>

    <div id="result"></div>

    <script>
        let token = null;

        async function login() {
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;

            try {
                const response = await fetch('http://localhost:5000/api/auth/login', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    credentials: 'include',
                    body: JSON.stringify({ username, password })
                });

                const data = await response.json();
                token = data.token;

                document.getElementById('result').innerHTML =
                    '<p style="color: green;">Login successful!</p>';
            } catch (error) {
                document.getElementById('result').innerHTML =
                    '<p style="color: red;">Login failed: ' + error.message + '</p>';
            }
        }

        async function getProtectedData() {
            if (!token) {
                document.getElementById('result').innerHTML =
                    '<p style="color: red;">Please login first!</p>';
                return;
            }

            try {
                const response = await fetch('http://localhost:5000/api/protected', {
                    headers: {
                        'Authorization': `Bearer ${token}`
                    },
                    credentials: 'include'
                });

                const data = await response.json();
                document.getElementById('result').innerHTML =
                    '<p style="color: green;">' + data.message + '</p>';
            } catch (error) {
                document.getElementById('result').innerHTML =
                    '<p style="color: red;">Error: ' + error.message + '</p>';
            }
        }
    </script>
</body>
</html>
```

**Testing**:
1. Run the API
2. Open auth-test.html in a browser (served on port 3000)
3. Login with username: `admin`, password: `password`
4. Click "Get Protected Data" - should work with JWT token
5. Check Network tab to see CORS headers and Authorization header

</details>

---

## Summary

CORS is essential for modern web development with separate frontend and backend applications. Key takeaways:

1. **CORS exists because of browser security** - The Same-Origin Policy blocks cross-origin requests by default
2. **CORS is configured on the backend** - Your API tells browsers which origins are allowed
3. **Be specific in production** - Never use `AllowAnyOrigin()` in production
4. **Credentials require exact origins** - You can't use wildcards with `AllowCredentials()`
5. **Middleware order matters** - `UseCors()` must be after `UseRouting()` but before `UseAuthentication()`
6. **Use named policies** - Different endpoints may need different CORS rules
7. **Preflight requests are normal** - OPTIONS requests are part of CORS for complex requests

---

## Next Steps

Now that you understand CORS, explore these related topics:

- **[JWT Tokens](./jwt-tokens.md)** - Authentication in cross-origin scenarios
- **[Authentication & Authorization](./authentication-authorization-basics.md)** - Securing your API
- **[Web API Best Practices](./web-api-best-practices.md)** - Building robust APIs
- **[Deployment](./deployment-basics.md)** - Configuring CORS for production

---

**Questions or Issues?**
If you encounter CORS issues, check the [Troubleshooting](#9-troubleshooting) section first. Most CORS problems are due to misconfiguration or middleware order.
