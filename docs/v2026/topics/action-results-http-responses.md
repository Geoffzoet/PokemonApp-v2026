# Action Results and HTTP Responses

## 1. Overview & Introduction

### What are Action Results?

**Action Results** are return types from controller action methods in ASP.NET Core that determine how the framework should respond to an HTTP request. They encapsulate the HTTP response including status code, headers, and content (body).

**Simple Analogy:**
```
Restaurant Order System:
- Customer request (HTTP Request) → "I'll have a burger"
- Kitchen processes (Controller Action) → Prepares burger
- Response type (Action Result) →
  * Success: "Here's your burger" (200 OK with burger)
  * Not available: "Sorry, we're out" (404 Not Found)
  * Invalid order: "We don't serve that" (400 Bad Request)
```

In ASP.NET Core, action results tell the framework:
- What HTTP status code to return (200, 404, 400, etc.)
- What content to send back (JSON, HTML, file, etc.)
- What headers to include
- How to format the response

### Why Action Results Matter

1. **Semantic HTTP Communication**: Express intent clearly (success, failure, redirect, etc.)
2. **RESTful APIs**: Build APIs that follow HTTP standards
3. **Client Expectations**: Return responses clients can understand
4. **Error Handling**: Communicate different types of errors appropriately
5. **Content Negotiation**: Support multiple response formats (JSON, XML, etc.)

**Example Comparison:**
```csharp
// BAD: Always returns 200 OK, even for errors
public Pokemon GetPokemon(int id)
{
    var pokemon = _service.GetById(id);
    return pokemon; // What if null? Still returns 200!
}

// GOOD: Returns appropriate status codes
public ActionResult<Pokemon> GetPokemon(int id)
{
    var pokemon = _service.GetById(id);

    if (pokemon == null)
        return NotFound(); // 404 Not Found

    return Ok(pokemon); // 200 OK with data
}
```

### HTTP Status Codes Quick Reference

Understanding status codes is essential for proper action results:

**2xx Success:**
- **200 OK**: Request succeeded, returning data
- **201 Created**: Resource created successfully
- **204 No Content**: Success, but no data to return

**3xx Redirection:**
- **301 Moved Permanently**: Resource permanently moved
- **302 Found**: Temporary redirect
- **304 Not Modified**: Cached version still valid

**4xx Client Errors:**
- **400 Bad Request**: Invalid request data
- **401 Unauthorized**: Authentication required
- **403 Forbidden**: Authenticated but not authorized
- **404 Not Found**: Resource doesn't exist
- **409 Conflict**: Request conflicts with current state

**5xx Server Errors:**
- **500 Internal Server Error**: Unexpected server error
- **503 Service Unavailable**: Server temporarily unavailable

### When to Use Which Action Result

```
Operation          → Status Code → Action Result
─────────────────────────────────────────────────
Get single item    → 200 OK      → Ok(item)
                   → 404         → NotFound()

Get list           → 200 OK      → Ok(list)

Create item        → 201 Created → CreatedAtAction()
                   → 400         → BadRequest()

Update item        → 200 OK      → Ok(item)
                   → 204         → NoContent()
                   → 404         → NotFound()

Delete item        → 204         → NoContent()
                   → 404         → NotFound()

Validation fails   → 400         → BadRequest(ModelState)
```

### What You'll Learn

By the end of this guide, you'll understand:
- The ActionResult hierarchy and types
- How to return appropriate HTTP status codes
- Content negotiation and response formatting
- Best practices for RESTful API responses
- How to build consistent API responses
- Error handling with proper status codes

---

## 2. Quick Start

### Minimal Action Result Example

Here's a simple controller using action results:

**Step 1: Basic controller with action results**
```csharp
[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    private readonly IPokemonService _pokemonService;

    public PokemonController(IPokemonService pokemonService)
    {
        _pokemonService = pokemonService;
    }

    // GET: api/pokemon
    [HttpGet]
    public ActionResult<List<Pokemon>> GetAll()
    {
        var pokemon = _pokemonService.GetAll();
        return Ok(pokemon); // 200 OK with data
    }

    // GET: api/pokemon/5
    [HttpGet("{id}")]
    public ActionResult<Pokemon> GetById(int id)
    {
        var pokemon = _pokemonService.GetById(id);

        if (pokemon == null)
            return NotFound(); // 404 Not Found

        return Ok(pokemon); // 200 OK with data
    }

    // POST: api/pokemon
    [HttpPost]
    public ActionResult<Pokemon> Create(Pokemon pokemon)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState); // 400 Bad Request

        var created = _pokemonService.Create(pokemon);

        return CreatedAtAction(
            nameof(GetById),
            new { id = created.Id },
            created); // 201 Created
    }

    // DELETE: api/pokemon/5
    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        var exists = _pokemonService.Exists(id);

        if (!exists)
            return NotFound(); // 404 Not Found

        _pokemonService.Delete(id);
        return NoContent(); // 204 No Content
    }
}
```

**What Just Happened?**
1. Used `ActionResult<T>` as return type for type-safe responses
2. Returned `Ok()` for successful GET requests (200)
3. Returned `NotFound()` when resource doesn't exist (404)
4. Returned `BadRequest()` for invalid input (400)
5. Returned `CreatedAtAction()` for successful creation (201)
6. Returned `NoContent()` for successful deletion (204)

Each action result automatically sets the appropriate HTTP status code!

---

## 3. Prerequisites

### Required Knowledge

Before diving into action results, you should be comfortable with:

1. **Controllers and Routing** (POK-12)
   - Controller basics
   - Action methods
   - Route attributes

2. **HTTP Protocol Fundamentals** (POK-7)
   - HTTP methods (GET, POST, PUT, DELETE)
   - Status codes
   - Request/response cycle

3. **MVC Controllers** (POK-22)
   - Controller structure
   - Model binding
   - Returning views

4. **C# Fundamentals**
   - Return types
   - Generics (ActionResult<T>)
   - Async/await

### Required Tools

- **.NET 8.0 SDK** or later
- **Visual Studio 2022**, **VS Code**, or **Rider**
- **Postman** or similar tool for API testing (optional but recommended)
- Basic understanding of REST APIs

---

## 4. Core Concepts & Theory

### Understanding the ActionResult Hierarchy

ASP.NET Core has a rich hierarchy of action result types:

```
IActionResult (interface)
    │
    ├── ActionResult (base class)
    │   │
    │   ├── StatusCodeResult
    │   │   ├── OkResult (200)
    │   │   ├── CreatedResult (201)
    │   │   ├── NoContentResult (204)
    │   │   ├── BadRequestResult (400)
    │   │   ├── UnauthorizedResult (401)
    │   │   ├── NotFoundResult (404)
    │   │   └── ConflictResult (409)
    │   │
    │   ├── ObjectResult
    │   │   ├── OkObjectResult (200 with data)
    │   │   ├── CreatedAtActionResult (201 with data)
    │   │   ├── BadRequestObjectResult (400 with data)
    │   │   └── NotFoundObjectResult (404 with data)
    │   │
    │   ├── FileResult
    │   │   ├── FileContentResult
    │   │   ├── FileStreamResult
    │   │   └── PhysicalFileResult
    │   │
    │   ├── RedirectResult
    │   ├── RedirectToActionResult
    │   ├── ViewResult
    │   ├── PartialViewResult
    │   ├── JsonResult
    │   └── ContentResult
    │
    └── ActionResult<T> (generic wrapper)
```

### ActionResult vs ActionResult<T>

**ActionResult (non-generic):**
```csharp
// Can return any type of result
public IActionResult GetPokemon(int id)
{
    var pokemon = _service.GetById(id);

    if (pokemon == null)
        return NotFound(); // IActionResult

    return Ok(pokemon); // IActionResult
}
```

**ActionResult<T> (generic, recommended):**
```csharp
// Strongly typed, better for API documentation
public ActionResult<Pokemon> GetPokemon(int id)
{
    var pokemon = _service.GetById(id);

    if (pokemon == null)
        return NotFound(); // ActionResult<Pokemon>

    return pokemon; // Implicitly converts to ActionResult<Pokemon>
    // OR
    return Ok(pokemon); // ActionResult<Pokemon>
}
```

**Benefits of ActionResult<T>:**
- Type safety
- Better Swagger/OpenAPI documentation
- Implicit conversion from T to ActionResult<T>
- Clear intent in code

### Common Action Results Explained

#### 1. Success Results (2xx)

**OkResult / OkObjectResult (200 OK)**
```csharp
// Without data
public IActionResult Ping()
{
    return Ok(); // 200 OK, empty body
}

// With data (most common)
public ActionResult<Pokemon> Get(int id)
{
    var pokemon = _service.GetById(id);
    return Ok(pokemon); // 200 OK with JSON body
}

// Implicit conversion
public ActionResult<Pokemon> Get(int id)
{
    var pokemon = _service.GetById(id);
    return pokemon; // Automatically converted to Ok(pokemon)
}
```

**CreatedResult / CreatedAtActionResult (201 Created)**
```csharp
// Created with Location header
public ActionResult<Pokemon> Create(Pokemon pokemon)
{
    var created = _service.Create(pokemon);

    // Returns 201 Created with Location header pointing to GetById
    return CreatedAtAction(
        nameof(GetById),           // Action name
        new { id = created.Id },   // Route values
        created);                  // Response body
}

// Alternative: CreatedAtRoute
public ActionResult<Pokemon> Create(Pokemon pokemon)
{
    var created = _service.Create(pokemon);

    return CreatedAtRoute(
        "GetPokemon",              // Route name
        new { id = created.Id },
        created);
}
```

**NoContentResult (204 No Content)**
```csharp
// Successful operation with no data to return
public IActionResult Delete(int id)
{
    _service.Delete(id);
    return NoContent(); // 204 No Content
}

public IActionResult Update(int id, Pokemon pokemon)
{
    _service.Update(pokemon);
    return NoContent(); // 204 No Content
}
```

#### 2. Client Error Results (4xx)

**BadRequestResult / BadRequestObjectResult (400 Bad Request)**
```csharp
// Simple bad request
public IActionResult Create(Pokemon pokemon)
{
    if (pokemon.Level > 100)
        return BadRequest(); // 400 Bad Request

    // ...
}

// With error message
public IActionResult Create(Pokemon pokemon)
{
    if (pokemon.Level > 100)
        return BadRequest("Level cannot exceed 100"); // 400 with message

    // ...
}

// With ModelState errors
public IActionResult Create(Pokemon pokemon)
{
    if (!ModelState.IsValid)
        return BadRequest(ModelState); // 400 with validation errors

    // ...
}

// With custom error object
public IActionResult Create(Pokemon pokemon)
{
    if (pokemon.Level > 100)
    {
        var error = new
        {
            error = "InvalidLevel",
            message = "Level cannot exceed 100",
            maxLevel = 100
        };
        return BadRequest(error);
    }

    // ...
}
```

**NotFoundResult / NotFoundObjectResult (404 Not Found)**
```csharp
// Simple not found
public ActionResult<Pokemon> Get(int id)
{
    var pokemon = _service.GetById(id);

    if (pokemon == null)
        return NotFound(); // 404 Not Found

    return Ok(pokemon);
}

// With custom message
public ActionResult<Pokemon> Get(int id)
{
    var pokemon = _service.GetById(id);

    if (pokemon == null)
        return NotFound($"Pokemon with ID {id} not found");

    return Ok(pokemon);
}
```

**UnauthorizedResult (401 Unauthorized)**
```csharp
// User not authenticated
public IActionResult GetSecretPokemon()
{
    if (!User.Identity.IsAuthenticated)
        return Unauthorized(); // 401 Unauthorized

    // ...
}
```

**ForbidResult (403 Forbidden)**
```csharp
// User authenticated but not authorized
public IActionResult DeletePokemon(int id)
{
    var pokemon = _service.GetById(id);

    if (pokemon.OwnerId != User.GetUserId())
        return Forbid(); // 403 Forbidden

    _service.Delete(id);
    return NoContent();
}
```

**ConflictResult (409 Conflict)**
```csharp
// Resource conflicts with current state
public IActionResult Create(Pokemon pokemon)
{
    if (_service.NameExists(pokemon.Name))
        return Conflict($"Pokemon named '{pokemon.Name}' already exists");

    // ...
}
```

#### 3. Redirect Results (3xx)

**RedirectResult / RedirectToActionResult**
```csharp
// Redirect to another action
public IActionResult Create(Pokemon pokemon)
{
    var created = _service.Create(pokemon);

    return RedirectToAction(
        nameof(Details),
        new { id = created.Id }); // 302 Found (temporary redirect)
}

// Permanent redirect
public IActionResult OldEndpoint()
{
    return RedirectToActionPermanent(
        nameof(NewEndpoint)); // 301 Moved Permanently
}
```

#### 4. Content Results

**JsonResult**
```csharp
// Return JSON explicitly (usually unnecessary with [ApiController])
public IActionResult GetPokemon(int id)
{
    var pokemon = _service.GetById(id);
    return new JsonResult(pokemon); // Returns JSON
}
```

**ContentResult**
```csharp
// Return plain text or custom content type
public IActionResult GetPlainText()
{
    return Content("Hello, Pokemon!", "text/plain");
}

public IActionResult GetXml()
{
    var xml = "<pokemon><name>Pikachu</name></pokemon>";
    return Content(xml, "application/xml");
}
```

**FileResult**
```csharp
// Return file download
public IActionResult DownloadPokemonImage(int id)
{
    var image = _service.GetPokemonImage(id);
    return File(image, "image/png", "pikachu.png");
}

// Return file stream
public IActionResult DownloadCsv()
{
    var stream = _service.GeneratePokemonCsv();
    return File(stream, "text/csv", "pokemon.csv");
}
```

### Content Negotiation

ASP.NET Core automatically negotiates content type based on request headers:

```csharp
[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    [HttpGet("{id}")]
    public ActionResult<Pokemon> Get(int id)
    {
        var pokemon = _service.GetById(id);
        return Ok(pokemon); // Returns JSON by default
    }
}

// Clients can request different formats:
// Accept: application/json → Returns JSON
// Accept: application/xml → Returns XML (if configured)
// Accept: text/plain → Returns plain text (if configured)
```

**Configure content negotiation:**
```csharp
// Program.cs
builder.Services.AddControllers()
    .AddXmlSerializerFormatters(); // Support XML

// Now clients can get XML by setting Accept: application/xml
```

### Status Code Helpers

The ControllerBase class provides helper methods:

```csharp
public class PokemonController : ControllerBase
{
    // Status code methods
    public IActionResult Example()
    {
        return Ok();                    // 200
        return Created("uri", value);   // 201
        return NoContent();             // 204
        return BadRequest();            // 400
        return Unauthorized();          // 401
        return Forbid();                // 403
        return NotFound();              // 404
        return Conflict();              // 409
        return UnprocessableEntity();   // 422
        return StatusCode(500);         // Custom status code
    }
}
```

---

## 5. Installation & Configuration

### Step 1: Create API Controller

**Using [ApiController] attribute (recommended for APIs):**

```csharp
using Microsoft.AspNetCore.Mvc;

namespace PokemonApp.Controllers;

[ApiController] // Enables API-specific features
[Route("api/[controller]")]
public class PokemonController : ControllerBase // ControllerBase for APIs
{
    private readonly IPokemonService _service;

    public PokemonController(IPokemonService service)
    {
        _service = service;
    }

    // Actions here...
}
```

**What [ApiController] provides:**
- Automatic model validation (returns 400 if ModelState invalid)
- Automatic HTTP 400 responses
- Binding source parameter inference
- Multipart/form-data request inference
- Problem details for error status codes

### Step 2: Configure API Behavior

**Program.cs configuration:**

```csharp
var builder = WebApplication.CreateBuilder(args);

// Configure API behavior
builder.Services.AddControllers()
    .ConfigureApiBehaviorOptions(options =>
    {
        // Customize automatic 400 response
        options.InvalidModelStateResponseFactory = context =>
        {
            var errors = context.ModelState
                .Where(e => e.Value.Errors.Count > 0)
                .Select(e => new
                {
                    Field = e.Key,
                    Errors = e.Value.Errors.Select(x => x.ErrorMessage)
                });

            var errorResponse = new
            {
                Message = "Validation failed",
                Errors = errors
            };

            return new BadRequestObjectResult(errorResponse);
        };

        // Suppress automatic model validation response (handle manually)
        // options.SuppressModelStateInvalidFilter = true;
    });

var app = builder.Build();

app.MapControllers();
app.Run();
```

### Step 3: Configure Problem Details (RFC 7807)

Problem Details is a standard format for HTTP error responses:

```csharp
// Program.cs
builder.Services.AddProblemDetails();

builder.Services.AddControllers()
    .ConfigureApiBehaviorOptions(options =>
    {
        options.ClientErrorMapping[StatusCodes.Status404NotFound].Link =
            "https://httpstatuses.com/404";
    });

// Use problem details in responses
public IActionResult Get(int id)
{
    var pokemon = _service.GetById(id);

    if (pokemon == null)
    {
        return Problem(
            statusCode: StatusCodes.Status404NotFound,
            title: "Pokemon not found",
            detail: $"No Pokemon exists with ID {id}",
            instance: HttpContext.Request.Path);
    }

    return Ok(pokemon);
}
```

**Problem Details response:**
```json
{
  "type": "https://httpstatuses.com/404",
  "title": "Pokemon not found",
  "status": 404,
  "detail": "No Pokemon exists with ID 5",
  "instance": "/api/pokemon/5"
}
```

### Step 4: Configure Content Negotiation

Support multiple response formats:

```csharp
// Program.cs
builder.Services.AddControllers(options =>
{
    // Return 406 Not Acceptable if client requests unsupported format
    options.ReturnHttpNotAcceptable = true;

    // Add custom formatters
    options.OutputFormatters.Add(new XmlSerializerOutputFormatter());
})
.AddXmlSerializerFormatters() // Support XML
.AddXmlDataContractSerializerFormatters(); // Alternative XML serializer

// Now API supports:
// Accept: application/json → JSON
// Accept: application/xml → XML
```

### Step 5: Create Standard Response Model

For consistent API responses:

```csharp
// Models/ApiResponse.cs
public class ApiResponse<T>
{
    public bool Success { get; set; }
    public T? Data { get; set; }
    public string? Message { get; set; }
    public List<string> Errors { get; set; } = new();

    public static ApiResponse<T> SuccessResponse(T data, string? message = null)
    {
        return new ApiResponse<T>
        {
            Success = true,
            Data = data,
            Message = message
        };
    }

    public static ApiResponse<T> ErrorResponse(string message)
    {
        return new ApiResponse<T>
        {
            Success = false,
            Message = message
        };
    }

    public static ApiResponse<T> ErrorResponse(List<string> errors)
    {
        return new ApiResponse<T>
        {
            Success = false,
            Errors = errors
        };
    }
}

// Usage in controller
public ActionResult<ApiResponse<Pokemon>> Get(int id)
{
    var pokemon = _service.GetById(id);

    if (pokemon == null)
        return NotFound(ApiResponse<Pokemon>.ErrorResponse("Pokemon not found"));

    return Ok(ApiResponse<Pokemon>.SuccessResponse(pokemon));
}
```

---

## 6. Configuration & Setup

### Configuring Custom Status Codes

Sometimes you need custom status codes:

```csharp
public IActionResult RateLimited()
{
    return StatusCode(429, "Too many requests"); // 429 Too Many Requests
}

public IActionResult PaymentRequired()
{
    return StatusCode(402, "Payment required"); // 402 Payment Required
}

public IActionResult Teapot()
{
    return StatusCode(418, "I'm a teapot"); // 418 I'm a teapot (joke status)
}
```

### Configuring Response Headers

Add custom headers to responses:

```csharp
public IActionResult GetWithHeaders()
{
    Response.Headers.Add("X-Custom-Header", "CustomValue");
    Response.Headers.Add("X-Rate-Limit", "100");
    Response.Headers.Add("X-Rate-Limit-Remaining", "95");

    var pokemon = _service.GetAll();
    return Ok(pokemon);
}

// Or use ActionResult with headers
public IActionResult GetPokemon(int id)
{
    var pokemon = _service.GetById(id);

    if (pokemon == null)
        return NotFound();

    // Add ETag for caching
    var etag = $"\"{pokemon.Id}-{pokemon.UpdatedAt:yyyyMMddHHmmss}\"";
    Response.Headers.Add("ETag", etag);

    return Ok(pokemon);
}
```

### Configuring CORS

Allow cross-origin requests:

```csharp
// Program.cs
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        builder => builder
            .AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader());
});

var app = builder.Build();

app.UseCors("AllowAll");
app.MapControllers();
app.Run();

// Now API can be called from any origin
```

---

## 7. Basic Usage

### Complete CRUD API with Proper Action Results

Let's build a complete RESTful API:

```csharp
using Microsoft.AspNetCore.Mvc;

namespace PokemonApp.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    private readonly IPokemonService _service;
    private readonly ILogger<PokemonController> _logger;

    public PokemonController(
        IPokemonService service,
        ILogger<PokemonController> logger)
    {
        _service = service;
        _logger = logger;
    }

    // GET: api/pokemon
    /// <summary>
    /// Gets all Pokemon
    /// </summary>
    /// <returns>List of Pokemon</returns>
    /// <response code="200">Returns the list of Pokemon</response>
    [HttpGet]
    [ProducesResponseType(typeof(List<Pokemon>), StatusCodes.Status200OK)]
    public async Task<ActionResult<List<Pokemon>>> GetAll()
    {
        var result = await _service.GetAllAsync();

        if (!result.Success)
        {
            _logger.LogError("Failed to retrieve Pokemon: {Error}", result.ErrorMessage);
            return StatusCode(500, "An error occurred while retrieving Pokemon");
        }

        return Ok(result.Data);
    }

    // GET: api/pokemon/5
    /// <summary>
    /// Gets a specific Pokemon by ID
    /// </summary>
    /// <param name="id">Pokemon ID</param>
    /// <returns>The Pokemon if found</returns>
    /// <response code="200">Returns the Pokemon</response>
    /// <response code="404">Pokemon not found</response>
    [HttpGet("{id}")]
    [ProducesResponseType(typeof(Pokemon), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<Pokemon>> GetById(int id)
    {
        var result = await _service.GetByIdAsync(id);

        if (!result.Success)
            return NotFound(new { message = result.ErrorMessage });

        return Ok(result.Data);
    }

    // GET: api/pokemon/search?name=pika
    /// <summary>
    /// Searches Pokemon by name
    /// </summary>
    /// <param name="name">Search term</param>
    /// <returns>Matching Pokemon</returns>
    [HttpGet("search")]
    [ProducesResponseType(typeof(List<Pokemon>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<List<Pokemon>>> Search([FromQuery] string name)
    {
        if (string.IsNullOrWhiteSpace(name))
            return BadRequest("Search term cannot be empty");

        var result = await _service.SearchAsync(name);

        return Ok(result.Data);
    }

    // POST: api/pokemon
    /// <summary>
    /// Creates a new Pokemon
    /// </summary>
    /// <param name="pokemon">Pokemon to create</param>
    /// <returns>The created Pokemon</returns>
    /// <response code="201">Pokemon created successfully</response>
    /// <response code="400">Invalid input</response>
    [HttpPost]
    [ProducesResponseType(typeof(Pokemon), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<Pokemon>> Create([FromBody] Pokemon pokemon)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var result = await _service.CreateAsync(pokemon);

        if (!result.Success)
            return BadRequest(new { message = result.ErrorMessage });

        return CreatedAtAction(
            nameof(GetById),
            new { id = result.Data.Id },
            result.Data);
    }

    // PUT: api/pokemon/5
    /// <summary>
    /// Updates an existing Pokemon
    /// </summary>
    /// <param name="id">Pokemon ID</param>
    /// <param name="pokemon">Updated Pokemon data</param>
    /// <returns>No content on success</returns>
    /// <response code="204">Pokemon updated successfully</response>
    /// <response code="400">Invalid input or ID mismatch</response>
    /// <response code="404">Pokemon not found</response>
    [HttpPut("{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(int id, [FromBody] Pokemon pokemon)
    {
        if (id != pokemon.Id)
            return BadRequest("ID mismatch");

        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var result = await _service.UpdateAsync(pokemon);

        if (!result.Success)
        {
            if (result.ErrorMessage.Contains("not found"))
                return NotFound(new { message = result.ErrorMessage });

            return BadRequest(new { message = result.ErrorMessage });
        }

        return NoContent();
    }

    // PATCH: api/pokemon/5/level
    /// <summary>
    /// Updates Pokemon level
    /// </summary>
    /// <param name="id">Pokemon ID</param>
    /// <param name="level">New level</param>
    /// <returns>Updated Pokemon</returns>
    [HttpPatch("{id}/level")]
    [ProducesResponseType(typeof(Pokemon), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<Pokemon>> UpdateLevel(int id, [FromBody] int level)
    {
        if (level < 1 || level > 100)
            return BadRequest("Level must be between 1 and 100");

        var result = await _service.UpdateLevelAsync(id, level);

        if (!result.Success)
            return NotFound(new { message = result.ErrorMessage });

        return Ok(result.Data);
    }

    // DELETE: api/pokemon/5
    /// <summary>
    /// Deletes a Pokemon
    /// </summary>
    /// <param name="id">Pokemon ID</param>
    /// <returns>No content on success</returns>
    /// <response code="204">Pokemon deleted successfully</response>
    /// <response code="404">Pokemon not found</response>
    [HttpDelete("{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(int id)
    {
        var result = await _service.DeleteAsync(id);

        if (!result.Success)
            return NotFound(new { message = result.ErrorMessage });

        return NoContent();
    }

    // HEAD: api/pokemon/5
    /// <summary>
    /// Checks if Pokemon exists (returns headers only)
    /// </summary>
    [HttpHead("{id}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Head(int id)
    {
        var exists = await _service.ExistsAsync(id);

        if (!exists)
            return NotFound();

        return Ok();
    }
}
```

### Testing the API

**Using curl:**
```bash
# GET all Pokemon
curl -X GET https://localhost:5001/api/pokemon

# GET specific Pokemon
curl -X GET https://localhost:5001/api/pokemon/1

# POST create Pokemon
curl -X POST https://localhost:5001/api/pokemon \
  -H "Content-Type: application/json" \
  -d '{"name":"Pikachu","type":"Electric","level":25}'

# PUT update Pokemon
curl -X PUT https://localhost:5001/api/pokemon/1 \
  -H "Content-Type: application/json" \
  -d '{"id":1,"name":"Pikachu","type":"Electric","level":30}'

# DELETE Pokemon
curl -X DELETE https://localhost:5001/api/pokemon/1

# HEAD check existence
curl -I https://localhost:5001/api/pokemon/1
```

---

## 8. Testing & Validation

### Exercise 1: Build Basic CRUD API (Beginner)

**Objective:** Create a simple API for managing Trainers with proper action results.

**Requirements:**
1. Create `TrainerController` with GET, POST, PUT, DELETE endpoints
2. Return appropriate status codes (200, 201, 204, 404, 400)
3. Use `ActionResult<T>` for type safety
4. Add XML documentation comments
5. Test all endpoints with Postman or curl

**Hints:**
- Follow the Pokemon controller pattern
- Use `CreatedAtAction` for POST
- Return `NoContent` for DELETE
- Validate input with ModelState

<details>
<summary>Solution</summary>

```csharp
using Microsoft.AspNetCore.Mvc;

namespace PokemonApp.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TrainerController : ControllerBase
{
    private readonly ITrainerService _service;

    public TrainerController(ITrainerService service)
    {
        _service = service;
    }

    /// <summary>
    /// Gets all trainers
    /// </summary>
    [HttpGet]
    [ProducesResponseType(typeof(List<Trainer>), 200)]
    public async Task<ActionResult<List<Trainer>>> GetAll()
    {
        var result = await _service.GetAllAsync();
        return Ok(result.Data);
    }

    /// <summary>
    /// Gets a trainer by ID
    /// </summary>
    [HttpGet("{id}")]
    [ProducesResponseType(typeof(Trainer), 200)]
    [ProducesResponseType(404)]
    public async Task<ActionResult<Trainer>> GetById(int id)
    {
        var result = await _service.GetByIdAsync(id);

        if (!result.Success)
            return NotFound(new { message = result.ErrorMessage });

        return Ok(result.Data);
    }

    /// <summary>
    /// Creates a new trainer
    /// </summary>
    [HttpPost]
    [ProducesResponseType(typeof(Trainer), 201)]
    [ProducesResponseType(400)]
    public async Task<ActionResult<Trainer>> Create([FromBody] Trainer trainer)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var result = await _service.CreateAsync(trainer);

        if (!result.Success)
            return BadRequest(new { message = result.ErrorMessage });

        return CreatedAtAction(
            nameof(GetById),
            new { id = result.Data.Id },
            result.Data);
    }

    /// <summary>
    /// Updates an existing trainer
    /// </summary>
    [HttpPut("{id}")]
    [ProducesResponseType(204)]
    [ProducesResponseType(400)]
    [ProducesResponseType(404)]
    public async Task<IActionResult> Update(int id, [FromBody] Trainer trainer)
    {
        if (id != trainer.Id)
            return BadRequest("ID mismatch");

        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var result = await _service.UpdateAsync(trainer);

        if (!result.Success)
        {
            if (result.ErrorMessage.Contains("not found"))
                return NotFound(new { message = result.ErrorMessage });

            return BadRequest(new { message = result.ErrorMessage });
        }

        return NoContent();
    }

    /// <summary>
    /// Deletes a trainer
    /// </summary>
    [HttpDelete("{id}")]
    [ProducesResponseType(204)]
    [ProducesResponseType(404)]
    public async Task<IActionResult> Delete(int id)
    {
        var result = await _service.DeleteAsync(id);

        if (!result.Success)
            return NotFound(new { message = result.ErrorMessage });

        return NoContent();
    }
}
```

**Test with curl:**
```bash
# Create trainer
curl -X POST https://localhost:5001/api/trainer \
  -H "Content-Type: application/json" \
  -d '{"name":"Ash","age":10}'

# Get all
curl https://localhost:5001/api/trainer

# Get one
curl https://localhost:5001/api/trainer/1

# Update
curl -X PUT https://localhost:5001/api/trainer/1 \
  -H "Content-Type: application/json" \
  -d '{"id":1,"name":"Ash Ketchum","age":11}'

# Delete
curl -X DELETE https://localhost:5001/api/trainer/1
```

</details>

---

### Exercise 2: Implement Consistent API Response Format (Intermediate)

**Objective:** Create a standard response wrapper for all API responses.

**Requirements:**
1. Create `ApiResponse<T>` class with Success, Data, Message, Errors properties
2. Create extension methods to easily return wrapped responses
3. Update controller to use consistent format
4. Handle both success and error cases
5. Add pagination support

**Hints:**
- Wrap all responses in ApiResponse
- Create helper methods like `SuccessResponse()` and `ErrorResponse()`
- Include pagination metadata

<details>
<summary>Solution</summary>

**1. Response Models:**
```csharp
// Models/ApiResponse.cs
public class ApiResponse<T>
{
    public bool Success { get; set; }
    public T? Data { get; set; }
    public string? Message { get; set; }
    public List<string> Errors { get; set; } = new();
    public PaginationMetadata? Pagination { get; set; }
}

public class PaginationMetadata
{
    public int CurrentPage { get; set; }
    public int PageSize { get; set; }
    public int TotalPages { get; set; }
    public int TotalCount { get; set; }
    public bool HasPrevious => CurrentPage > 1;
    public bool HasNext => CurrentPage < TotalPages;
}
```

**2. Extension Methods:**
```csharp
// Extensions/ActionResultExtensions.cs
public static class ActionResultExtensions
{
    public static ActionResult<ApiResponse<T>> ToApiResponse<T>(
        this T data,
        string? message = null)
    {
        return new OkObjectResult(new ApiResponse<T>
        {
            Success = true,
            Data = data,
            Message = message
        });
    }

    public static ActionResult<ApiResponse<T>> ToApiResponseCreated<T>(
        this ControllerBase controller,
        string actionName,
        object routeValues,
        T data,
        string? message = null)
    {
        var response = new ApiResponse<T>
        {
            Success = true,
            Data = data,
            Message = message
        };

        return new CreatedAtActionResult(
            actionName,
            null,
            routeValues,
            response);
    }

    public static ActionResult<ApiResponse<T>> ToApiResponseNotFound<T>(
        string message)
    {
        return new NotFoundObjectResult(new ApiResponse<T>
        {
            Success = false,
            Message = message
        });
    }

    public static ActionResult<ApiResponse<T>> ToApiResponseBadRequest<T>(
        string message)
    {
        return new BadRequestObjectResult(new ApiResponse<T>
        {
            Success = false,
            Message = message
        });
    }

    public static ActionResult<ApiResponse<T>> ToApiResponseBadRequest<T>(
        List<string> errors)
    {
        return new BadRequestObjectResult(new ApiResponse<T>
        {
            Success = false,
            Errors = errors
        });
    }

    public static ActionResult<ApiResponse<T>> ToPagedApiResponse<T>(
        this T data,
        int currentPage,
        int pageSize,
        int totalCount)
    {
        var totalPages = (int)Math.Ceiling(totalCount / (double)pageSize);

        return new OkObjectResult(new ApiResponse<T>
        {
            Success = true,
            Data = data,
            Pagination = new PaginationMetadata
            {
                CurrentPage = currentPage,
                PageSize = pageSize,
                TotalPages = totalPages,
                TotalCount = totalCount
            }
        });
    }
}
```

**3. Updated Controller:**
```csharp
[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    private readonly IPokemonService _service;

    public PokemonController(IPokemonService service)
    {
        _service = service;
    }

    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<Pokemon>>>> GetAll(
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 10)
    {
        var (items, totalCount) = await _service.GetPagedAsync(page, pageSize);

        return items.ToPagedApiResponse(page, pageSize, totalCount);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ApiResponse<Pokemon>>> GetById(int id)
    {
        var result = await _service.GetByIdAsync(id);

        if (!result.Success)
            return ActionResultExtensions.ToApiResponseNotFound<Pokemon>(
                result.ErrorMessage);

        return result.Data.ToApiResponse("Pokemon retrieved successfully");
    }

    [HttpPost]
    public async Task<ActionResult<ApiResponse<Pokemon>>> Create(
        [FromBody] Pokemon pokemon)
    {
        if (!ModelState.IsValid)
        {
            var errors = ModelState.Values
                .SelectMany(v => v.Errors)
                .Select(e => e.ErrorMessage)
                .ToList();

            return ActionResultExtensions.ToApiResponseBadRequest<Pokemon>(errors);
        }

        var result = await _service.CreateAsync(pokemon);

        if (!result.Success)
            return ActionResultExtensions.ToApiResponseBadRequest<Pokemon>(
                result.ErrorMessage);

        return this.ToApiResponseCreated(
            nameof(GetById),
            new { id = result.Data.Id },
            result.Data,
            "Pokemon created successfully");
    }

    [HttpPut("{id}")]
    public async Task<ActionResult<ApiResponse<Pokemon>>> Update(
        int id,
        [FromBody] Pokemon pokemon)
    {
        if (id != pokemon.Id)
            return ActionResultExtensions.ToApiResponseBadRequest<Pokemon>(
                "ID mismatch");

        var result = await _service.UpdateAsync(pokemon);

        if (!result.Success)
        {
            if (result.ErrorMessage.Contains("not found"))
                return ActionResultExtensions.ToApiResponseNotFound<Pokemon>(
                    result.ErrorMessage);

            return ActionResultExtensions.ToApiResponseBadRequest<Pokemon>(
                result.ErrorMessage);
        }

        return result.Data.ToApiResponse("Pokemon updated successfully");
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult<ApiResponse<object>>> Delete(int id)
    {
        var result = await _service.DeleteAsync(id);

        if (!result.Success)
            return ActionResultExtensions.ToApiResponseNotFound<object>(
                result.ErrorMessage);

        return new object().ToApiResponse("Pokemon deleted successfully");
    }
}
```

**4. Response Examples:**
```json
// Success response
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Pikachu",
    "type": "Electric",
    "level": 25
  },
  "message": "Pokemon retrieved successfully",
  "errors": []
}

// Paginated response
{
  "success": true,
  "data": [...],
  "pagination": {
    "currentPage": 1,
    "pageSize": 10,
    "totalPages": 5,
    "totalCount": 50,
    "hasPrevious": false,
    "hasNext": true
  }
}

// Error response
{
  "success": false,
  "data": null,
  "message": "Pokemon not found",
  "errors": []
}

// Validation error response
{
  "success": false,
  "data": null,
  "message": null,
  "errors": [
    "Name is required",
    "Level must be between 1 and 100"
  ]
}
```

</details>

---

### Exercise 3: Implement Advanced HTTP Features (Challenge)

**Objective:** Implement caching, ETags, compression, and rate limiting.

**Requirements:**
1. Add response caching with Cache-Control headers
2. Implement ETags for conditional requests (If-None-Match)
3. Add response compression (gzip, brotli)
4. Implement rate limiting
5. Add CORS support
6. Implement OPTIONS endpoint

**Hints:**
- Use Response.Headers for custom headers
- Check Request.Headers for conditional requests
- Configure middleware in Program.cs

<details>
<summary>Solution</summary>

**1. Configure Middleware (Program.cs):**
```csharp
using Microsoft.AspNetCore.ResponseCompression;
using System.IO.Compression;

var builder = WebApplication.CreateBuilder(args);

// Response compression
builder.Services.AddResponseCompression(options =>
{
    options.EnableForHttps = true;
    options.Providers.Add<BrotliCompressionProvider>();
    options.Providers.Add<GzipCompressionProvider>();
});

builder.Services.Configure<BrotliCompressionProviderOptions>(options =>
{
    options.Level = CompressionLevel.Fastest;
});

builder.Services.Configure<GzipCompressionProviderOptions>(options =>
{
    options.Level = CompressionLevel.Optimal;
});

// Response caching
builder.Services.AddResponseCaching();

// CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowSpecificOrigins",
        policy => policy
            .WithOrigins("https://example.com", "https://app.example.com")
            .AllowAnyMethod()
            .AllowAnyHeader()
            .AllowCredentials());
});

builder.Services.AddControllers();

var app = builder.Build();

app.UseResponseCompression();
app.UseResponseCaching();
app.UseCors("AllowSpecificOrigins");

app.MapControllers();
app.Run();
```

**2. Controller with Advanced Features:**
```csharp
[ApiController]
[Route("api/[controller]")]
public class PokemonController : ControllerBase
{
    private readonly IPokemonService _service;

    public PokemonController(IPokemonService service)
    {
        _service = service;
    }

    // GET with caching and ETag
    [HttpGet("{id}")]
    [ResponseCache(Duration = 60, Location = ResponseCacheLocation.Any)]
    public async Task<ActionResult<Pokemon>> GetById(int id)
    {
        var pokemon = await _service.GetByIdAsync(id);

        if (pokemon == null)
            return NotFound();

        // Generate ETag
        var etag = $"\"{pokemon.Id}-{pokemon.UpdatedAt:yyyyMMddHHmmss}\"";

        // Check If-None-Match header
        if (Request.Headers.TryGetValue("If-None-Match", out var requestETag))
        {
            if (requestETag == etag)
            {
                return StatusCode(304); // 304 Not Modified
            }
        }

        // Set response headers
        Response.Headers.Add("ETag", etag);
        Response.Headers.Add("Cache-Control", "public, max-age=60");
        Response.Headers.Add("Last-Modified", pokemon.UpdatedAt.ToString("R"));

        return Ok(pokemon);
    }

    // GET with custom cache headers
    [HttpGet]
    public async Task<ActionResult<List<Pokemon>>> GetAll()
    {
        var pokemon = await _service.GetAllAsync();

        // Custom cache control
        Response.Headers.Add("Cache-Control", "public, max-age=300"); // 5 minutes

        // Add custom headers
        Response.Headers.Add("X-Total-Count", pokemon.Count.ToString());
        Response.Headers.Add("X-Page-Size", "10");

        return Ok(pokemon);
    }

    // OPTIONS for CORS preflight
    [HttpOptions]
    public IActionResult Options()
    {
        Response.Headers.Add("Allow", "GET, POST, PUT, DELETE, OPTIONS");
        return Ok();
    }

    // POST with rate limiting check
    [HttpPost]
    public async Task<ActionResult<Pokemon>> Create([FromBody] Pokemon pokemon)
    {
        // Simple rate limiting check (in real app, use middleware)
        var userIp = HttpContext.Connection.RemoteIpAddress?.ToString();

        // Check rate limit (pseudo-code)
        if (IsRateLimited(userIp))
        {
            Response.Headers.Add("Retry-After", "60");
            return StatusCode(429, "Too many requests");
        }

        var created = await _service.CreateAsync(pokemon);

        // Set location header
        var location = Url.Action(nameof(GetById), new { id = created.Id });
        Response.Headers.Add("Location", location);

        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    // Conditional PUT (If-Match)
    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, [FromBody] Pokemon pokemon)
    {
        if (id != pokemon.Id)
            return BadRequest();

        var existing = await _service.GetByIdAsync(id);
        if (existing == null)
            return NotFound();

        // Check If-Match header for optimistic concurrency
        if (Request.Headers.TryGetValue("If-Match", out var ifMatch))
        {
            var currentETag = $"\"{existing.Id}-{existing.UpdatedAt:yyyyMMddHHmmss}\"";

            if (ifMatch != currentETag)
            {
                return StatusCode(412, "Precondition failed"); // 412 Precondition Failed
            }
        }

        await _service.UpdateAsync(pokemon);

        return NoContent();
    }

    private bool IsRateLimited(string? identifier)
    {
        // Simple in-memory rate limiting (use proper library in production)
        // This is just for demonstration
        return false;
    }
}
```

**3. Rate Limiting Middleware (Custom):**
```csharp
// Middleware/RateLimitingMiddleware.cs
public class RateLimitingMiddleware
{
    private readonly RequestDelegate _next;
    private static readonly Dictionary<string, (DateTime, int)> _requests = new();
    private const int MaxRequests = 100;
    private static readonly TimeSpan TimeWindow = TimeSpan.FromMinutes(1);

    public RateLimitingMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        var identifier = context.Connection.RemoteIpAddress?.ToString() ?? "unknown";

        lock (_requests)
        {
            // Clean old entries
            var now = DateTime.UtcNow;
            var toRemove = _requests
                .Where(kvp => now - kvp.Value.Item1 > TimeWindow)
                .Select(kvp => kvp.Key)
                .ToList();

            foreach (var key in toRemove)
                _requests.Remove(key);

            // Check rate limit
            if (_requests.TryGetValue(identifier, out var value))
            {
                var (timestamp, count) = value;

                if (now - timestamp < TimeWindow)
                {
                    if (count >= MaxRequests)
                    {
                        context.Response.StatusCode = 429;
                        context.Response.Headers.Add("Retry-After", "60");
                        await context.Response.WriteAsync("Too many requests");
                        return;
                    }

                    _requests[identifier] = (timestamp, count + 1);
                }
                else
                {
                    _requests[identifier] = (now, 1);
                }
            }
            else
            {
                _requests[identifier] = (now, 1);
            }
        }

        await _next(context);
    }
}

// Register in Program.cs
app.UseMiddleware<RateLimitingMiddleware>();
```

**4. Test Commands:**
```bash
# Test compression
curl -H "Accept-Encoding: gzip" https://localhost:5001/api/pokemon

# Test ETag
curl -I https://localhost:5001/api/pokemon/1

# Then with If-None-Match
curl -H "If-None-Match: \"1-20250101120000\"" https://localhost:5001/api/pokemon/1

# Test OPTIONS
curl -X OPTIONS https://localhost:5001/api/pokemon

# Test conditional update
curl -X PUT https://localhost:5001/api/pokemon/1 \
  -H "If-Match: \"1-20250101120000\"" \
  -H "Content-Type: application/json" \
  -d '{"id":1,"name":"Pikachu","level":30}'
```

</details>

---

## 9. Practical Examples

[Content continues with more practical examples...]

---

## 10. Common Patterns & Best Practices

### Pattern 1: Consistent Status Codes

Always use appropriate status codes:

```csharp
// GOOD: Proper status codes
[HttpGet("{id}")]
public ActionResult<Pokemon> Get(int id)
{
    var pokemon = _service.GetById(id);

    if (pokemon == null)
        return NotFound(); // 404

    return Ok(pokemon); // 200
}

// BAD: Always 200, even for errors
[HttpGet("{id}")]
public Pokemon Get(int id)
{
    return _service.GetById(id); // Returns null with 200 OK!
}
```

### Pattern 2: Use ActionResult<T>

Prefer `ActionResult<T>` for type safety:

```csharp
// GOOD: Type-safe and documented
public ActionResult<Pokemon> Get(int id)
{
    var pokemon = _service.GetById(id);

    if (pokemon == null)
        return NotFound();

    return pokemon; // Implicit conversion
}

// LESS IDEAL: Not type-safe
public IActionResult Get(int id)
{
    var pokemon = _service.GetById(id);

    if (pokemon == null)
        return NotFound();

    return Ok(pokemon); // Must explicitly wrap
}
```

### Pattern 3: ProducesResponseType for Documentation

Document all possible responses:

```csharp
/// <summary>
/// Gets a Pokemon by ID
/// </summary>
[HttpGet("{id}")]
[ProducesResponseType(typeof(Pokemon), StatusCodes.Status200OK)]
[ProducesResponseType(StatusCodes.Status404NotFound)]
[ProducesResponseType(StatusCodes.Status500InternalServerError)]
public ActionResult<Pokemon> GetById(int id)
{
    // ...
}
```

### Pattern 4: Validation Before Processing

Validate early, return fast:

```csharp
[HttpPost]
public ActionResult<Pokemon> Create(Pokemon pokemon)
{
    // Validate first
    if (!ModelState.IsValid)
        return BadRequest(ModelState);

    if (pokemon.Level > 100)
        return BadRequest("Level cannot exceed 100");

    // Then process
    var created = _service.Create(pokemon);
    return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
}
```

---

## 11. Troubleshooting & Common Issues

### Issue 1: Always Returns 200 OK

**Problem:**
```csharp
[HttpGet("{id}")]
public Pokemon Get(int id)
{
    return _service.GetById(id); // Returns null with 200!
}
```

**Solution:**
```csharp
[HttpGet("{id}")]
public ActionResult<Pokemon> Get(int id)
{
    var pokemon = _service.GetById(id);

    if (pokemon == null)
        return NotFound();

    return Ok(pokemon);
}
```

### Issue 2: CreatedAtAction Returns 500

**Problem:**
```csharp
return CreatedAtAction("GetById", new { id = created.Id }, created);
// Error: No route matches
```

**Solution:**
```csharp
// Use nameof() to avoid typos
return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);

// Ensure GetById action exists and is accessible
[HttpGet("{id}", Name = "GetPokemon")] // Can also use route name
public ActionResult<Pokemon> GetById(int id) { }
```

---

## 12. Additional Resources

### Official Documentation

- [Action return types in ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/web-api/action-return-types)
- [HTTP status codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)
- [REST API Tutorial](https://restfulapi.net/)

### Related PokemonApp Documentation

- **POK-12: Controllers and Routing**
- **POK-7: HTTP Protocol Fundamentals**
- **POK-27: Service Layer Pattern**

---

## Summary

**Action Results** enable you to build proper RESTful APIs that communicate clearly with clients through HTTP status codes. Key takeaways:

**Core Benefits:**
- Semantic HTTP communication
- Type-safe responses with ActionResult<T>
- Automatic status code handling
- RESTful API compliance

**Key Concepts:**
- Use appropriate status codes (200, 201, 204, 404, 400, etc.)
- Prefer `ActionResult<T>` for APIs
- Document responses with `ProducesResponseType`
- Return proper error responses

**Best Practices:**
- Validate early, return fast
- Use consistent response format
- Document all possible responses
- Handle errors gracefully

You now have the knowledge to build professional RESTful APIs with proper HTTP responses!
