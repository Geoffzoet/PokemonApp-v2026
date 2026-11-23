# JWT Tokens (Quick Reference)

---
**Technology Version**: .NET 8.0, JWT Bearer 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-23
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What are JWT Tokens?

JWT (JSON Web Tokens) is an open standard (RFC 7519) for securely transmitting information between parties as a JSON object. In web applications, JWTs are primarily used for **authentication and authorization** - proving who you are and what you're allowed to do.

Think of a JWT as a **digital passport**. When you log in to a website, the server issues you a JWT token that contains your identity and permissions. Every time you make a request, you show this token (like showing your passport at customs), and the server can verify it's legitimate without needing to check a database.

Unlike traditional session-based authentication where the server stores session data, JWTs are **stateless** - all the information needed is contained in the token itself. This makes JWTs perfect for modern applications, especially APIs and mobile apps.

### Why Use JWT Tokens?

You should use JWT tokens when:

- **Building APIs** - RESTful APIs that serve mobile apps, SPAs, or third-party clients
- **Stateless authentication** - Don't want to store session data on the server
- **Microservices** - Need to pass user identity between different services
- **Single Sign-On (SSO)** - Allow users to authenticate once and access multiple systems
- **Scalability** - Horizontal scaling is easier without server-side session storage
- **Cross-domain authentication** - Share authentication across different domains
- **Mobile apps** - Native mobile apps that consume your API

### JWT vs Cookie-Based Authentication

**JWT (Token-Based):**
- Stateless (no server-side storage)
- Perfect for APIs
- Works across domains
- Mobile-friendly
- Can be stored in localStorage or cookies
- Requires manual refresh logic

**Cookie-Based (Session):**
- Stateful (server stores session data)
- Traditional web apps
- Automatic with browsers
- Built-in CSRF protection
- Requires sticky sessions for load balancing
- Automatic expiration handling

### When to Use JWTs

**Use JWTs when:**
- Building a RESTful API for mobile/SPA clients
- Need authentication across multiple services
- Scaling horizontally with load balancers
- Supporting third-party API access
- Building a microservices architecture

**Use cookies/sessions when:**
- Building traditional server-rendered web apps
- Security is critical (cookies have HttpOnly, Secure flags)
- Simplicity is preferred (framework handles everything)
- Need built-in CSRF protection

---

## 2. Core Concepts & Theory

### JWT Structure

A JWT consists of three parts separated by dots (`.`):

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

**Structure:**
```
[Header].[Payload].[Signature]
```

#### Part 1: Header

The header contains metadata about the token:

```json
{
  "alg": "HS256",    // Algorithm used for signing
  "typ": "JWT"       // Token type
}
```

**Encoded**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9`

#### Part 2: Payload (Claims)

The payload contains claims - statements about the user and additional data:

```json
{
  "sub": "1234567890",           // Subject (user ID)
  "name": "Ash Ketchum",         // User name
  "email": "ash@pokemon.com",    // User email
  "role": "trainer",             // User role
  "iat": 1516239022,             // Issued at (timestamp)
  "exp": 1516242622              // Expiration (timestamp)
}
```

**Encoded**: `eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ikpva...`

**Standard claims:**
- `iss` (issuer) - Who issued the token
- `sub` (subject) - User identifier
- `aud` (audience) - Who the token is intended for
- `exp` (expiration) - When the token expires
- `iat` (issued at) - When the token was created
- `nbf` (not before) - Token not valid before this time
- `jti` (JWT ID) - Unique identifier for the token

**Custom claims:** You can add any data you need:
- User roles, permissions
- User name, email
- Application-specific data

#### Part 3: Signature

The signature ensures the token hasn't been tampered with:

```
HMACSHA256(
  base64UrlEncode(header) + "." + base64UrlEncode(payload),
  secret
)
```

**Purpose:**
- Verifies the token hasn't been modified
- Proves the token was issued by a trusted source
- Uses a secret key known only to the server

### How JWT Authentication Works

**Flow diagram:**

```
1. User Login:
   Client                           Server
     |                                |
     |------ POST /login ------------>|
     |  { username, password }        |
     |                                |
     |<------ 200 OK ----------------|
     |  { token: "eyJ..." }           |
     |                                |
     | Store token (localStorage)     |

2. Authenticated Requests:
   Client                           Server
     |                                |
     |------ GET /api/pokemon ------->|
     |  Header: Authorization:        |
     |  Bearer eyJ...                 |
     |                                |
     |          Verify token ✓        |
     |          Extract user info     |
     |                                |
     |<------ 200 OK ----------------|
     |  [ pokemon data ]              |

3. Token Expired:
   Client                           Server
     |                                |
     |------ GET /api/pokemon ------->|
     |  Header: Authorization:        |
     |  Bearer eyJ... (expired)       |
     |                                |
     |          Verify token ✗        |
     |                                |
     |<------ 401 Unauthorized -------|
     |                                |
     | Redirect to login              |
```

### Token Lifetime and Refresh Tokens

**Access Token:**
- Short-lived (15 minutes to 1 hour)
- Used for API requests
- Contains user identity and permissions

**Refresh Token:**
- Long-lived (days to weeks)
- Used to obtain new access tokens
- Stored securely, can be revoked

**Refresh flow:**
```
1. Access token expires
2. Client sends refresh token to /refresh endpoint
3. Server validates refresh token
4. Server issues new access token
5. Client continues making requests
```

---

## 3. Basic Usage

### Installing Required Packages

**Add JWT Bearer authentication package:**

```bash
dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer
```

### Configuring JWT Authentication

**Program.cs:**

```csharp
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Configure JWT authentication
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = builder.Configuration["Jwt:Issuer"],
        ValidAudience = builder.Configuration["Jwt:Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]))
    };
});

builder.Services.AddControllers();

var app = builder.Build();

// Add authentication middleware (before authorization!)
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
```

### Configuration Settings

**appsettings.json:**

```json
{
  "Jwt": {
    "Key": "YourSuperSecretKeyThatIsAtLeast32CharactersLong!",
    "Issuer": "https://pokemonapp.com",
    "Audience": "https://pokemonapp.com",
    "ExpiryMinutes": 60
  }
}
```

**Important:**
- Never commit secrets to source control
- Use environment variables or Azure Key Vault in production
- Key should be at least 32 characters for HS256

### Creating a JWT Token

**Services/TokenService.cs:**

```csharp
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

public class TokenService
{
    private readonly IConfiguration _configuration;

    public TokenService(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public string GenerateToken(string userId, string username, string role)
    {
        // Create claims
        var claims = new[]
        {
            new Claim(JwtRegisteredClaimNames.Sub, userId),
            new Claim(JwtRegisteredClaimNames.Name, username),
            new Claim(ClaimTypes.Role, role),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            new Claim(JwtRegisteredClaimNames.Iat,
                DateTimeOffset.UtcNow.ToUnixTimeSeconds().ToString())
        };

        // Create signing key
        var key = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));

        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        // Create token
        var token = new JwtSecurityToken(
            issuer: _configuration["Jwt:Issuer"],
            audience: _configuration["Jwt:Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(
                int.Parse(_configuration["Jwt:ExpiryMinutes"])),
            signingCredentials: credentials
        );

        // Return serialized token
        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
```

**Register service:**

```csharp
// Program.cs
builder.Services.AddScoped<TokenService>();
```

### Login Endpoint

**Controllers/AuthController.cs:**

```csharp
using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly TokenService _tokenService;
    private readonly IUserService _userService;

    public AuthController(TokenService tokenService, IUserService userService)
    {
        _tokenService = tokenService;
        _userService = userService;
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        // Validate credentials
        var user = await _userService.ValidateCredentialsAsync(
            request.Username,
            request.Password);

        if (user == null)
        {
            return Unauthorized(new { message = "Invalid username or password" });
        }

        // Generate JWT token
        var token = _tokenService.GenerateToken(
            user.Id.ToString(),
            user.Username,
            user.Role);

        return Ok(new
        {
            token = token,
            expiration = DateTime.UtcNow.AddHours(1),
            user = new
            {
                id = user.Id,
                username = user.Username,
                role = user.Role
            }
        });
    }
}

public class LoginRequest
{
    public string Username { get; set; }
    public string Password { get; set; }
}
```

### Protecting Endpoints with [Authorize]

**Apply to entire controller:**

```csharp
using Microsoft.AspNetCore.Authorization;

[Authorize]  // ← Requires JWT token for all actions
[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll()
    {
        // User is authenticated
        var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        var username = User.Identity.Name;

        return Ok(new { message = $"Hello {username}" });
    }
}
```

**Apply to specific actions:**

```csharp
[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll()
    {
        // Public - no authentication required
        return Ok(pokemon);
    }

    [Authorize]  // ← Requires authentication
    [HttpPost]
    public IActionResult Create(Pokemon pokemon)
    {
        // Only authenticated users can create
        return Ok();
    }

    [Authorize(Roles = "Admin")]  // ← Requires specific role
    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        // Only admins can delete
        return NoContent();
    }
}
```

### Accessing User Information

**Get claims from the token:**

```csharp
[Authorize]
[HttpGet("profile")]
public IActionResult GetProfile()
{
    // Get user ID from token
    var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
    var userId2 = User.FindFirst(JwtRegisteredClaimNames.Sub)?.Value;

    // Get username
    var username = User.Identity.Name;

    // Get role
    var role = User.FindFirst(ClaimTypes.Role)?.Value;

    // Check if user is in role
    var isAdmin = User.IsInRole("Admin");

    return Ok(new
    {
        userId,
        username,
        role,
        isAdmin
    });
}
```

### Client-Side Usage (JavaScript)

**Store token after login:**

```javascript
// Login
async function login(username, password) {
    const response = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password })
    });

    const data = await response.json();

    if (response.ok) {
        // Store token
        localStorage.setItem('token', data.token);
        console.log('Logged in successfully!');
    } else {
        console.error('Login failed');
    }
}
```

**Send token with requests:**

```javascript
// Make authenticated request
async function getPokemon() {
    const token = localStorage.getItem('token');

    const response = await fetch('/api/pokemon', {
        headers: {
            'Authorization': `Bearer ${token}`
        }
    });

    if (response.ok) {
        const pokemon = await response.json();
        console.log(pokemon);
    } else if (response.status === 401) {
        console.log('Token expired, please login again');
        // Redirect to login
    }
}
```

**Handle token expiration:**

```javascript
// Check if token is expired
function isTokenExpired(token) {
    const payload = JSON.parse(atob(token.split('.')[1]));
    const expiry = payload.exp * 1000; // Convert to milliseconds
    return Date.now() >= expiry;
}

// Logout
function logout() {
    localStorage.removeItem('token');
    window.location.href = '/login';
}

// Auto-logout on expiration
setInterval(() => {
    const token = localStorage.getItem('token');
    if (token && isTokenExpired(token)) {
        alert('Session expired, please login again');
        logout();
    }
}, 60000); // Check every minute
```

---

## 4. Common Patterns & Best Practices

### Pattern 1: Refresh Token Implementation

**Add refresh token to response:**

```csharp
[HttpPost("login")]
public async Task<IActionResult> Login([FromBody] LoginRequest request)
{
    var user = await _userService.ValidateCredentialsAsync(
        request.Username, request.Password);

    if (user == null)
        return Unauthorized();

    // Generate access token (short-lived)
    var accessToken = _tokenService.GenerateToken(
        user.Id.ToString(), user.Username, user.Role);

    // Generate refresh token (long-lived)
    var refreshToken = _tokenService.GenerateRefreshToken();

    // Store refresh token in database
    await _userService.SaveRefreshTokenAsync(user.Id, refreshToken);

    return Ok(new
    {
        accessToken,
        refreshToken,
        expiresIn = 3600 // seconds
    });
}

[HttpPost("refresh")]
public async Task<IActionResult> Refresh([FromBody] RefreshRequest request)
{
    // Validate refresh token
    var user = await _userService.ValidateRefreshTokenAsync(request.RefreshToken);

    if (user == null)
        return Unauthorized(new { message = "Invalid refresh token" });

    // Generate new access token
    var newAccessToken = _tokenService.GenerateToken(
        user.Id.ToString(), user.Username, user.Role);

    return Ok(new
    {
        accessToken = newAccessToken,
        expiresIn = 3600
    });
}
```

### Pattern 2: Role-Based Access Control

**Multiple roles:**

```csharp
[Authorize(Roles = "Admin,Moderator")]
[HttpDelete("{id}")]
public IActionResult Delete(int id)
{
    // Admins OR Moderators can delete
    return NoContent();
}
```

**Custom authorization policies:**

```csharp
// Program.cs
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("RequireAdminRole", policy =>
        policy.RequireRole("Admin"));

    options.AddPolicy("RequireTrainerLevel5", policy =>
        policy.RequireClaim("TrainerLevel", "5", "6", "7", "8", "9", "10"));
});

// Controller
[Authorize(Policy = "RequireTrainerLevel5")]
[HttpPost("legendary")]
public IActionResult CatchLegendary()
{
    // Only high-level trainers can catch legendaries
    return Ok();
}
```

### Pattern 3: Security Best Practices

**Do's:**

✅ **Use HTTPS only**
```csharp
// Program.cs
app.UseHttpsRedirection();
```

✅ **Set appropriate expiration times**
```csharp
// Short access token (15-60 minutes)
expires: DateTime.UtcNow.AddMinutes(15)

// Long refresh token (7-30 days)
expires: DateTime.UtcNow.AddDays(7)
```

✅ **Validate all token parameters**
```csharp
ValidateIssuer = true,
ValidateAudience = true,
ValidateLifetime = true,
ValidateIssuerSigningKey = true
```

✅ **Store secrets securely**
```csharp
// Use environment variables or Azure Key Vault
var jwtKey = Environment.GetEnvironmentVariable("JWT_KEY");
```

✅ **Implement token revocation**
```csharp
// Store token blacklist in Redis or database
public async Task RevokeTokenAsync(string token)
{
    await _cache.SetStringAsync($"revoked:{token}", "true",
        new DistributedCacheEntryOptions
        {
            AbsoluteExpirationRelativeToNow = TimeSpan.FromHours(1)
        });
}
```

**Don'ts:**

❌ **Don't store sensitive data in tokens**
```csharp
// Bad: Passwords, credit cards, SSN
new Claim("password", user.Password) // ❌

// Good: User ID, username, roles
new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()) // ✅
```

❌ **Don't use weak signing keys**
```csharp
// Bad: Short key
var key = "secret123" // ❌

// Good: Strong key (32+ characters)
var key = "YourSuperSecretKeyThatIsAtLeast32CharactersLong!" // ✅
```

❌ **Don't forget to revoke tokens on logout**
```csharp
[HttpPost("logout")]
public async Task<IActionResult> Logout()
{
    var token = Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
    await _tokenService.RevokeTokenAsync(token);
    return Ok();
}
```

### Pattern 4: Custom Claims

**Add custom claims:**

```csharp
var claims = new List<Claim>
{
    new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
    new Claim(ClaimTypes.Name, user.Username),
    new Claim(ClaimTypes.Email, user.Email),
    new Claim(ClaimTypes.Role, user.Role),

    // Custom claims
    new Claim("TrainerLevel", user.Level.ToString()),
    new Claim("TeamSize", user.PokemonCount.ToString()),
    new Claim("Region", user.Region)
};
```

**Access custom claims:**

```csharp
[Authorize]
[HttpGet("stats")]
public IActionResult GetStats()
{
    var trainerLevel = int.Parse(User.FindFirst("TrainerLevel")?.Value ?? "0");
    var teamSize = int.Parse(User.FindFirst("TeamSize")?.Value ?? "0");

    return Ok(new { trainerLevel, teamSize });
}
```

---

## Security Considerations

### Token Storage

**localStorage (Common but less secure):**
```javascript
// Vulnerable to XSS attacks
localStorage.setItem('token', token);
```

**httpOnly Cookies (More secure):**
```csharp
// Server sets cookie
Response.Cookies.Append("token", token, new CookieOptions
{
    HttpOnly = true,  // Not accessible via JavaScript
    Secure = true,    // Only sent over HTTPS
    SameSite = SameSiteMode.Strict
});
```

### Common Security Threats

**1. Token Theft (XSS)**
- **Risk**: Attacker steals token from localStorage
- **Mitigation**: Use httpOnly cookies, implement CSP headers

**2. Man-in-the-Middle (MitM)**
- **Risk**: Token intercepted over HTTP
- **Mitigation**: Always use HTTPS

**3. Token Tampering**
- **Risk**: Attacker modifies token payload
- **Mitigation**: Signature verification (automatic with JWT)

**4. Replay Attacks**
- **Risk**: Stolen token used by attacker
- **Mitigation**: Short expiration times, token revocation

---

## Summary

**Key Takeaways:**

1. **JWTs are self-contained** tokens for stateless authentication
2. **Structure**: Header.Payload.Signature
3. **Perfect for APIs**, mobile apps, and microservices
4. **Stateless** - no server-side session storage needed
5. **Bearer token** format: `Authorization: Bearer {token}`
6. **Short-lived access tokens** + long-lived refresh tokens
7. Use **[Authorize]** attribute to protect endpoints
8. **Security**: HTTPS, strong keys, appropriate expiration

**JWT vs Cookies:**
- **Use JWT**: APIs, mobile apps, microservices
- **Use Cookies**: Traditional web apps, simpler security

**Common Flow:**
1. User logs in with credentials
2. Server generates JWT token
3. Client stores token
4. Client sends token with each request
5. Server validates token and processes request

---

**Estimated Reading Time**: 35-40 minutes

**Prerequisites**: Authentication basics, HTTP fundamentals, C# basics

**Related Topics**: Authentication & Authorization (POK-36), API Development, Security Best Practices

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-11-23 | Initial quick reference guide for JWT tokens |
