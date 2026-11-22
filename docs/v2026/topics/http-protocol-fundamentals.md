# HTTP Protocol Fundamentals

---
**Technology Version**: HTTP/1.1 (with HTTP/2 notes)
**Document Version**: 1.0
**Last Updated**: 2026-11-22
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What is HTTP?

HTTP (HyperText Transfer Protocol) is the foundation of data communication on the web. It's a set of rules that determines how web browsers and web servers talk to each other. When you type a URL in your browser or click a link, your browser sends an HTTP request to a server, and the server sends back an HTTP response.

Think of HTTP as a language that computers use to ask for and deliver web pages, images, data, and everything else you see on the internet. It's the postal service of the web - it defines how to package requests (like letters) and how to deliver responses (like packages).

### Why Use HTTP?

HTTP is not just for websites. Modern applications use HTTP to communicate between different parts of a system. You should understand HTTP when:

- **Building web APIs** - Your backend needs to send and receive data with frontend applications
- **Integrating with third-party services** - Most online services (payment gateways, social media APIs, weather services) use HTTP
- **Creating mobile apps** - Mobile apps communicate with backend servers using HTTP
- **Understanding how the web works** - Every web developer needs to know HTTP basics

### When to Use It

**Good use cases:**
- RESTful APIs for web and mobile applications
- Microservices communication (though gRPC is gaining popularity for internal services)
- Public-facing APIs that need to be accessible from browsers
- Integration with webhooks and third-party services
- File uploads and downloads

**Not recommended for:**
- Real-time, bidirectional communication (consider WebSockets instead)
- Very high-frequency data streaming (consider gRPC or WebSockets)
- Applications requiring guaranteed message delivery without additional protocols

---

## 2. Quick Start

**TL;DR - Understanding HTTP in 5 minutes:**

HTTP is a request-response protocol. A client (like a web browser) sends a request, and a server sends back a response.

**Basic HTTP Request Structure:**
```http
GET /api/pokemon/1 HTTP/1.1
Host: api.pokemon.com
Accept: application/json
```

**Basic HTTP Response Structure:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 1,
  "name": "Bulbasaur",
  "type": "Grass"
}
```

**Key concepts:**
- **Methods**: GET (retrieve), POST (create), PUT (update), DELETE (remove)
- **Status codes**: 200 (success), 404 (not found), 500 (server error)
- **Headers**: Metadata about the request/response
- **Body**: The actual data being sent

For detailed explanations, continue reading the sections below.

---

## 3. Prerequisites

### Required Knowledge

- **Basic programming concepts** - Variables, functions, and data structures. You should be comfortable reading code.
- **Understanding of client-server architecture** - The concept that one computer (client) requests information from another computer (server).
- **JSON format** (helpful but not required) - Most modern APIs use JSON to format data. It's similar to JavaScript objects or C# dictionaries.

### Required Software/Tools

To test HTTP requests while learning, you'll need at least one of these tools:

- **Web Browser** - Any modern browser (Chrome, Firefox, Edge, Safari)
  - Built-in Developer Tools (F12) let you inspect HTTP requests
- **Postman** - Version 10.0 or higher (Recommended for API testing)
  - Installation: [Download from postman.com](https://www.postman.com/downloads/)
- **cURL** - Usually pre-installed on macOS and Linux
  - Windows: [Download from curl.se](https://curl.se/windows/)
- **REST Client Extension** (for VS Code users)
  - Installation: Search "REST Client" in VS Code extensions

### System Requirements

HTTP itself has no system requirements - it's a protocol, not software. However, to test HTTP requests:

- **Operating System**: Windows 10+, macOS 11+, or any modern Linux distribution
- **Internet Connection**: Required for testing with real APIs
- **Text Editor**: Any editor to view HTTP request/response text

---

## 4. Core Concepts & Theory

### Key Concepts

#### Concept 1: Request-Response Cycle

HTTP follows a simple pattern: the client sends a request, and the server sends back a response. This happens every single time - there's no connection that stays open (in HTTP/1.1 without keep-alive).

```
Client                           Server
   |                                |
   |  1. HTTP Request               |
   |------------------------------->|
   |                                |
   |                                | 2. Process request
   |                                |
   |  3. HTTP Response              |
   |<-------------------------------|
   |                                |
```

**Example:**
When you type `www.example.com` in your browser:
1. Your browser sends: `GET / HTTP/1.1` (the request)
2. The server processes this
3. The server responds with the HTML page (the response)

#### Concept 2: Stateless Protocol

HTTP is "stateless" - each request is independent and doesn't remember previous requests. If you request the same page twice, the server treats each request as brand new.

**Why this matters:**
- **Sessions and cookies** exist to work around this. The server sends a unique ID (cookie) that the browser includes in future requests.
- **APIs often use tokens** (like JWT) to maintain "state" across requests.

Think of it like talking to someone with amnesia - each conversation starts from scratch unless you give them a note (cookie/token) to remember you.

#### Concept 3: HTTP Methods (Verbs)

HTTP methods tell the server what action you want to perform. The main methods are:

| Method | Purpose | Has Body? | Idempotent?* |
|--------|---------|-----------|--------------|
| GET | Retrieve data | No | Yes |
| POST | Create new resource | Yes | No |
| PUT | Update entire resource | Yes | Yes |
| PATCH | Update part of resource | Yes | No** |
| DELETE | Remove resource | Usually no | Yes |

*Idempotent means you can repeat the request multiple times with the same result.
**PATCH idempotency depends on implementation.

**Example:**
```http
GET /api/pokemon/25        # Get Pokemon with ID 25
POST /api/pokemon          # Create a new Pokemon
PUT /api/pokemon/25        # Update Pokemon 25 (send complete data)
PATCH /api/pokemon/25      # Update Pokemon 25 (send only changed fields)
DELETE /api/pokemon/25     # Delete Pokemon 25
```

#### Concept 4: HTTP Status Codes

Status codes are three-digit numbers that tell you the result of the request. They're grouped into categories:

| Range | Category | Meaning |
|-------|----------|---------|
| 1xx | Informational | Request received, continuing process |
| 2xx | Success | Request successfully received and processed |
| 3xx | Redirection | Further action needed to complete request |
| 4xx | Client Error | Request has an error (wrong URL, unauthorized, etc.) |
| 5xx | Server Error | Server failed to fulfill a valid request |

**Most common codes you'll see:**

**Success (2xx):**
- `200 OK` - Request succeeded
- `201 Created` - New resource was created (after POST)
- `204 No Content` - Success, but no data to return (common after DELETE)

**Client Errors (4xx):**
- `400 Bad Request` - Invalid request format
- `401 Unauthorized` - Authentication required or failed
- `403 Forbidden` - You don't have permission
- `404 Not Found` - Resource doesn't exist
- `409 Conflict` - Request conflicts with current state (e.g., duplicate resource)

**Server Errors (5xx):**
- `500 Internal Server Error` - Something went wrong on the server
- `502 Bad Gateway` - Server got an invalid response from another server
- `503 Service Unavailable` - Server is temporarily down

#### Concept 5: Headers

Headers are key-value pairs that provide metadata about the request or response. They're like the envelope of a letter - they contain information about the contents.

**Common Request Headers:**
```http
Host: api.example.com              # Which server you're contacting
Content-Type: application/json     # Format of data you're sending
Accept: application/json           # Format of data you want back
Authorization: Bearer token123     # Authentication credentials
User-Agent: Mozilla/5.0            # What client is making the request
```

**Common Response Headers:**
```http
Content-Type: application/json     # Format of data being returned
Content-Length: 348                # Size of response body in bytes
Cache-Control: no-cache            # How to cache this response
Set-Cookie: sessionId=abc123       # Store this cookie for future requests
```

#### Concept 6: Request and Response Body

The body contains the actual data being sent or received. Not all requests have a body:

- **GET requests** - No body (data is in the URL)
- **POST/PUT/PATCH requests** - Usually have a body with data
- **DELETE requests** - Typically no body

**Example POST request with body:**
```http
POST /api/pokemon HTTP/1.1
Host: api.example.com
Content-Type: application/json

{
  "name": "Pikachu",
  "type": "Electric",
  "level": 25
}
```

#### Concept 7: URL Structure

A URL (Uniform Resource Locator) is broken into parts:

```
https://api.example.com:443/api/pokemon/25?include=stats&sort=name#abilities
|      |                |   |             |                        |
|      |                |   |             |                        └─ Fragment (not sent to server)
|      |                |   |             └─ Query parameters (key=value pairs)
|      |                |   └─ Path (identifies the resource)
|      |                └─ Port (usually implicit: 443 for HTTPS, 80 for HTTP)
|      └─ Host (domain name or IP)
└─ Scheme (protocol: http or https)
```

**Query Parameters vs Route Parameters:**

**Route parameters** are part of the path:
```
/api/pokemon/25         # 25 is a route parameter (Pokemon ID)
/api/users/john/posts   # john is a route parameter (username)
```

**Query parameters** come after the `?`:
```
/api/pokemon?type=fire&limit=10    # type and limit are query parameters
/api/search?q=pikachu&page=2       # q and page are query parameters
```

**When to use each:**
- **Route parameters**: For identifying a specific resource (IDs, usernames)
- **Query parameters**: For filtering, sorting, pagination, or optional data

### Important Terminology

| Term | Definition |
|------|------------|
| **HTTP** | HyperText Transfer Protocol - the protocol for transferring data on the web |
| **HTTPS** | HTTP Secure - HTTP with encryption (using SSL/TLS) |
| **Request** | A message sent from client to server asking for something |
| **Response** | A message sent from server to client with the requested data or status |
| **Endpoint** | A specific URL path on a server that handles requests (e.g., `/api/pokemon`) |
| **REST API** | An API that follows REST architectural principles using HTTP |
| **Payload** | The data being sent in the body of a request or response |
| **Header** | Metadata about the request or response (not the actual data) |
| **Status Code** | A three-digit number indicating the result of the request |
| **Method/Verb** | The action being performed (GET, POST, PUT, DELETE, etc.) |
| **Content-Type** | A header specifying the format of the data (JSON, XML, HTML, etc.) |
| **Idempotent** | An operation that produces the same result no matter how many times it's repeated |

### Architecture Overview

**How an HTTP request flows through the internet:**

```
┌─────────────┐                                      ┌─────────────┐
│   Browser   │                                      │  Web Server │
│  (Client)   │                                      │             │
└──────┬──────┘                                      └──────┬──────┘
       │                                                    │
       │ 1. User types URL or clicks button                │
       │                                                    │
       │ 2. HTTP Request                                   │
       │    GET /api/pokemon/1 HTTP/1.1                    │
       │    Host: api.example.com                          │
       │───────────────────────────────────────────────────>│
       │                                                    │
       │                                     3. Server      │
       │                                        processes   │
       │                                        request     │
       │                                                    │
       │ 4. HTTP Response                                  │
       │    HTTP/1.1 200 OK                                │
       │    Content-Type: application/json                 │
       │    {"id": 1, "name": "Bulbasaur"}                 │
       │<───────────────────────────────────────────────────│
       │                                                    │
       │ 5. Browser displays the data                      │
       │                                                    │
```

**Key points:**
1. The client initiates all communication
2. Each request is independent (stateless)
3. The server can only respond, never initiate
4. Multiple requests can be made over the same TCP connection (HTTP keep-alive)

---

## 5. Installation Guide

### No Installation Required!

HTTP is a protocol, not software, so there's nothing to install. However, to test and work with HTTP, you'll want to set up some tools.

### Method 1: Browser Developer Tools (Recommended for Beginners)

Every modern browser has built-in tools to inspect HTTP requests.

**Step 1: Open Developer Tools**
- **Chrome/Edge**: Press `F12` or `Ctrl+Shift+I` (Windows) / `Cmd+Option+I` (Mac)
- **Firefox**: Press `F12` or `Ctrl+Shift+I` (Windows) / `Cmd+Option+I` (Mac)
- **Safari**: Enable Developer Menu in Preferences, then press `Cmd+Option+I`

**Step 2: Navigate to Network Tab**
Click the "Network" tab in the developer tools.

**Step 3: Visit a Website**
Navigate to any website (e.g., `https://jsonplaceholder.typicode.com/posts/1`)

**Step 4: Inspect the Request**
Click on the request in the Network tab to see:
- Request method and URL
- Request headers
- Response status code
- Response headers
- Response body

### Method 2: Install Postman (Recommended for API Testing)

Postman is a popular tool for testing APIs without writing code.

**Step 1: Download Postman**
Visit [postman.com/downloads](https://www.postman.com/downloads/) and download for your OS.

**Step 2: Install**
- **Windows**: Run the downloaded `.exe` file
- **macOS**: Open the `.dmg` file and drag Postman to Applications
- **Linux**: Extract and run the Postman executable

**Step 3: Launch Postman**
Open the application - no account required for basic use.

**Step 4: Make Your First Request**
1. Click "+" to create a new request
2. Enter URL: `https://jsonplaceholder.typicode.com/posts/1`
3. Leave method as "GET"
4. Click "Send"
5. View the response below

### Method 3: cURL (Command Line Tool)

cURL is a command-line tool for making HTTP requests.

#### Windows
```powershell
# Windows 10+ has cURL built in
curl --version
```

If not installed, download from [curl.se/windows](https://curl.se/windows/)

#### macOS
```bash
# cURL comes pre-installed
curl --version
```

#### Linux
```bash
# Usually pre-installed, if not:
sudo apt-get install curl    # Ubuntu/Debian
sudo yum install curl        # CentOS/RHEL
```

### Verify Installation

To confirm you can make HTTP requests:

**Using cURL:**
```bash
curl https://jsonplaceholder.typicode.com/posts/1
```

**Expected output:**
```json
{
  "userId": 1,
  "id": 1,
  "title": "sunt aut facere repellat provident",
  "body": "quia et suscipit..."
}
```

If you see JSON data, you're ready to go!

---

## 6. Initial Setup & Configuration

### Understanding HTTP Clients in .NET

When you're building .NET applications that need to make HTTP requests, you'll use the `HttpClient` class. Here's how to set it up properly.

### Setting Up HttpClient in .NET

**Step 1: Basic HttpClient Usage**

In a simple console app or test project:

```csharp
using System;
using System.Net.Http;
using System.Threading.Tasks;

public class Program
{
    // DON'T do this in production - for learning only
    private static readonly HttpClient client = new HttpClient();

    public static async Task Main(string[] args)
    {
        string url = "https://jsonplaceholder.typicode.com/posts/1";
        HttpResponseMessage response = await client.GetAsync(url);
        string content = await response.Content.ReadAsStringAsync();

        Console.WriteLine($"Status: {response.StatusCode}");
        Console.WriteLine($"Content: {content}");
    }
}
```

**Step 2: Proper Setup in ASP.NET Core**

In ASP.NET Core, register HttpClient in `Program.cs`:

```csharp
// Program.cs
var builder = WebApplication.CreateBuilder(args);

// Register HttpClient properly
builder.Services.AddHttpClient();

var app = builder.Build();
```

**Step 3: Use HttpClient via Dependency Injection**

```csharp
public class PokemonService
{
    private readonly HttpClient _httpClient;

    // HttpClient injected by .NET dependency injection
    public PokemonService(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }

    public async Task<string> GetPokemonAsync(int id)
    {
        var response = await _httpClient.GetAsync($"https://pokeapi.co/api/v2/pokemon/{id}");
        response.EnsureSuccessStatusCode(); // Throw if not success
        return await response.Content.ReadAsStringAsync();
    }
}
```

### Configuration Options for HttpClient

**Configuring a named HttpClient:**

```csharp
// Program.cs
builder.Services.AddHttpClient("PokemonAPI", client =>
{
    client.BaseAddress = new Uri("https://pokeapi.co/api/v2/");
    client.DefaultRequestHeaders.Add("User-Agent", "PokemonApp");
    client.Timeout = TimeSpan.FromSeconds(30);
});
```

**Using the named client:**

```csharp
public class PokemonService
{
    private readonly HttpClient _httpClient;

    public PokemonService(IHttpClientFactory httpClientFactory)
    {
        _httpClient = httpClientFactory.CreateClient("PokemonAPI");
    }

    public async Task<string> GetPokemonAsync(int id)
    {
        // No need for full URL since BaseAddress is set
        var response = await _httpClient.GetAsync($"pokemon/{id}");
        return await response.Content.ReadAsStringAsync();
    }
}
```

### Essential Settings

**Common HttpClient configuration:**

```csharp
builder.Services.AddHttpClient("MyAPI", client =>
{
    // Base URL for all requests
    client.BaseAddress = new Uri("https://api.example.com/");

    // Default headers sent with every request
    client.DefaultRequestHeaders.Add("Accept", "application/json");
    client.DefaultRequestHeaders.Add("User-Agent", "MyApp/1.0");

    // Timeout for requests (default is 100 seconds)
    client.Timeout = TimeSpan.FromSeconds(30);
})
.ConfigurePrimaryHttpMessageHandler(() => new HttpClientHandler
{
    // Allow automatic redirects (default: true)
    AllowAutoRedirect = true,

    // Maximum number of redirects (default: 50)
    MaxAutomaticRedirections = 10
});
```

### Testing HTTP Requests

**Using REST Client Extension in VS Code:**

Create a file named `test.http`:

```http
### Get a Pokemon
GET https://pokeapi.co/api/v2/pokemon/1 HTTP/1.1

### Get Pokemon with specific headers
GET https://pokeapi.co/api/v2/pokemon/25 HTTP/1.1
Accept: application/json
User-Agent: MyTestApp

### Create a new post (test API)
POST https://jsonplaceholder.typicode.com/posts HTTP/1.1
Content-Type: application/json

{
  "title": "My Test Post",
  "body": "This is a test",
  "userId": 1
}
```

Click "Send Request" above each request to test.

---

## 7. Basic Usage

### Hello World Example

The most basic HTTP request you can make:

**Using cURL (Command Line):**
```bash
curl https://jsonplaceholder.typicode.com/posts/1
```

**Using C# (.NET):**
```csharp
using System;
using System.Net.Http;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        using var client = new HttpClient();

        // Make a GET request
        string response = await client.GetStringAsync("https://jsonplaceholder.typicode.com/posts/1");

        Console.WriteLine(response);
    }
}
```

**What's happening here:**
1. We create an `HttpClient` to make HTTP requests
2. We call `GetStringAsync()` which sends a GET request to the URL
3. The server responds with JSON data
4. We display the response

**Running the example:**
```bash
dotnet run
```

**Expected output:**
```json
{
  "userId": 1,
  "id": 1,
  "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  "body": "quia et suscipit\nsuscipit recusandae consequuntur..."
}
```

### Common Use Cases

#### Use Case 1: Making a GET Request

GET is used to retrieve data from a server.

**Using C#:**
```csharp
using System;
using System.Net.Http;
using System.Threading.Tasks;

public class PokemonClient
{
    private readonly HttpClient _client;

    public PokemonClient()
    {
        _client = new HttpClient();
    }

    public async Task<string> GetPokemonAsync(int id)
    {
        // Send GET request
        HttpResponseMessage response = await _client.GetAsync($"https://pokeapi.co/api/v2/pokemon/{id}");

        // Check if successful (status code 200-299)
        if (response.IsSuccessStatusCode)
        {
            // Read response body
            string content = await response.Content.ReadAsStringAsync();
            return content;
        }
        else
        {
            throw new Exception($"Failed with status: {response.StatusCode}");
        }
    }
}

// Usage
var client = new PokemonClient();
string pokemon = await client.GetPokemonAsync(25); // Get Pikachu
Console.WriteLine(pokemon);
```

**Explanation:**
1. We create an `HttpClient` to handle HTTP communication
2. `GetAsync()` sends a GET request and returns an `HttpResponseMessage`
3. We check `IsSuccessStatusCode` to see if the request succeeded (2xx status code)
4. We read the response body as a string using `ReadAsStringAsync()`

**Using cURL:**
```bash
curl https://pokeapi.co/api/v2/pokemon/25
```

#### Use Case 2: Making a POST Request

POST is used to send data to a server to create a new resource.

**Using C#:**
```csharp
using System;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

public class TodoClient
{
    private readonly HttpClient _client;

    public TodoClient()
    {
        _client = new HttpClient();
    }

    public async Task<string> CreateTodoAsync(string title, string body)
    {
        // Create the data to send
        var todo = new
        {
            title = title,
            body = body,
            userId = 1
        };

        // Convert to JSON
        string jsonContent = JsonSerializer.Serialize(todo);

        // Create HTTP content with JSON
        var content = new StringContent(jsonContent, Encoding.UTF8, "application/json");

        // Send POST request
        HttpResponseMessage response = await _client.PostAsync(
            "https://jsonplaceholder.typicode.com/posts",
            content
        );

        // Read and return response
        return await response.Content.ReadAsStringAsync();
    }
}

// Usage
var client = new TodoClient();
string result = await client.CreateTodoAsync("My New Todo", "This is the description");
Console.WriteLine(result);
```

**Explanation:**
1. We create an object with the data we want to send
2. We serialize it to JSON using `JsonSerializer.Serialize()`
3. We wrap it in `StringContent` with encoding and content type
4. We send it with `PostAsync()`
5. The server responds with the created resource (usually including an ID)

**Using cURL:**
```bash
curl -X POST https://jsonplaceholder.typicode.com/posts \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My New Todo",
    "body": "This is the description",
    "userId": 1
  }'
```

#### Use Case 3: Making a PUT Request

PUT is used to update an entire resource.

**Using C#:**
```csharp
public async Task<string> UpdateTodoAsync(int id, string title, string body)
{
    var todo = new
    {
        id = id,
        title = title,
        body = body,
        userId = 1
    };

    string jsonContent = JsonSerializer.Serialize(todo);
    var content = new StringContent(jsonContent, Encoding.UTF8, "application/json");

    // Send PUT request to specific resource URL
    HttpResponseMessage response = await _client.PutAsync(
        $"https://jsonplaceholder.typicode.com/posts/{id}",
        content
    );

    return await response.Content.ReadAsStringAsync();
}

// Usage
string result = await client.UpdateTodoAsync(1, "Updated Title", "Updated body");
```

**Using cURL:**
```bash
curl -X PUT https://jsonplaceholder.typicode.com/posts/1 \
  -H "Content-Type: application/json" \
  -d '{
    "id": 1,
    "title": "Updated Title",
    "body": "Updated body",
    "userId": 1
  }'
```

#### Use Case 4: Making a DELETE Request

DELETE is used to remove a resource.

**Using C#:**
```csharp
public async Task<bool> DeleteTodoAsync(int id)
{
    // Send DELETE request
    HttpResponseMessage response = await _client.DeleteAsync(
        $"https://jsonplaceholder.typicode.com/posts/{id}"
    );

    // Return true if successful (status code 200-299)
    return response.IsSuccessStatusCode;
}

// Usage
bool success = await client.DeleteTodoAsync(1);
Console.WriteLine(success ? "Deleted successfully" : "Failed to delete");
```

**Using cURL:**
```bash
curl -X DELETE https://jsonplaceholder.typicode.com/posts/1
```

#### Use Case 5: Handling HTTP Headers

Headers provide metadata about the request or response.

**Setting Request Headers:**
```csharp
using System.Net.Http.Headers;

public async Task<string> GetWithAuthAsync(string token)
{
    // Clear any existing headers
    _client.DefaultRequestHeaders.Clear();

    // Add authorization header
    _client.DefaultRequestHeaders.Authorization =
        new AuthenticationHeaderValue("Bearer", token);

    // Add custom header
    _client.DefaultRequestHeaders.Add("X-Custom-Header", "MyValue");

    // Add accept header (what format we want back)
    _client.DefaultRequestHeaders.Accept.Add(
        new MediaTypeWithQualityHeaderValue("application/json")
    );

    HttpResponseMessage response = await _client.GetAsync("https://api.example.com/data");
    return await response.Content.ReadAsStringAsync();
}
```

**Reading Response Headers:**
```csharp
public async Task ShowResponseHeadersAsync()
{
    HttpResponseMessage response = await _client.GetAsync("https://jsonplaceholder.typicode.com/posts/1");

    // Read specific header
    if (response.Headers.Contains("Date"))
    {
        var dateHeader = response.Headers.GetValues("Date").FirstOrDefault();
        Console.WriteLine($"Date: {dateHeader}");
    }

    // Read content-type header
    string contentType = response.Content.Headers.ContentType?.MediaType;
    Console.WriteLine($"Content-Type: {contentType}");

    // Show all headers
    Console.WriteLine("\nAll Headers:");
    foreach (var header in response.Headers)
    {
        Console.WriteLine($"{header.Key}: {string.Join(", ", header.Value)}");
    }
}
```

#### Use Case 6: Working with Query Parameters

Query parameters are added to the URL after a `?` to filter or modify the request.

**Manual approach:**
```csharp
public async Task<string> SearchPokemonAsync(string type, int limit)
{
    // Build URL with query parameters
    string url = $"https://pokeapi.co/api/v2/pokemon?type={type}&limit={limit}";

    HttpResponseMessage response = await _client.GetAsync(url);
    return await response.Content.ReadAsStringAsync();
}

// Usage
string result = await client.SearchPokemonAsync("fire", 10);
```

**Using query string builder (recommended):**
```csharp
using Microsoft.AspNetCore.WebUtilities;

public async Task<string> SearchWithQueryBuilder(string type, int limit)
{
    string baseUrl = "https://pokeapi.co/api/v2/pokemon";

    // Build query parameters safely
    var queryParams = new Dictionary<string, string>
    {
        { "type", type },
        { "limit", limit.ToString() }
    };

    string url = QueryHelpers.AddQueryString(baseUrl, queryParams);
    // Result: https://pokeapi.co/api/v2/pokemon?type=fire&limit=10

    HttpResponseMessage response = await _client.GetAsync(url);
    return await response.Content.ReadAsStringAsync();
}
```

---

## 8. Testing & Validation

### How to Test Your Code

#### Method 1: Manual Testing with Postman

**Step 1: Create a request**
1. Open Postman
2. Create a new request
3. Set method to GET
4. Enter URL: `https://jsonplaceholder.typicode.com/posts`

**Step 2: Send and verify**
- Click "Send"
- Check status code is `200 OK`
- Verify response body contains an array of posts

**Step 3: Test POST request**
1. Change method to POST
2. URL: `https://jsonplaceholder.typicode.com/posts`
3. Go to "Body" tab → Select "raw" → Choose "JSON"
4. Enter:
```json
{
  "title": "Test Post",
  "body": "This is a test",
  "userId": 1
}
```
5. Click "Send"
6. Verify status code is `201 Created`

**Expected behavior:**
- POST should return status `201 Created`
- Response should include an `id` field
- Response should echo back your data

#### Method 2: Automated Testing in C#

**Simple test with xUnit:**
```csharp
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Xunit;

public class HttpClientTests
{
    private readonly HttpClient _client;

    public HttpClientTests()
    {
        _client = new HttpClient();
    }

    [Fact]
    public async Task GetPokemon_ReturnsSuccess()
    {
        // Arrange
        string url = "https://pokeapi.co/api/v2/pokemon/1";

        // Act
        HttpResponseMessage response = await _client.GetAsync(url);

        // Assert
        Assert.True(response.IsSuccessStatusCode);
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task GetNonExistentPokemon_Returns404()
    {
        // Arrange
        string url = "https://pokeapi.co/api/v2/pokemon/999999";

        // Act
        HttpResponseMessage response = await _client.GetAsync(url);

        // Assert
        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
    }
}
```

### Common Validation Checks

**Check 1: Verify status code**
```csharp
HttpResponseMessage response = await client.GetAsync(url);
if (response.StatusCode == HttpStatusCode.OK)
{
    Console.WriteLine("✓ Request successful");
}
else
{
    Console.WriteLine($"✗ Request failed with status: {response.StatusCode}");
}
```

**Check 2: Verify content type**
```csharp
string contentType = response.Content.Headers.ContentType?.MediaType;
if (contentType == "application/json")
{
    Console.WriteLine("✓ Response is JSON");
}
else
{
    Console.WriteLine($"✗ Expected JSON but got: {contentType}");
}
```

**Check 3: Verify response can be parsed**
```csharp
using System.Text.Json;

try
{
    string json = await response.Content.ReadAsStringAsync();
    JsonDocument.Parse(json); // Will throw if invalid JSON
    Console.WriteLine("✓ Response is valid JSON");
}
catch (JsonException)
{
    Console.WriteLine("✗ Response is not valid JSON");
}
```

### Hands-On Exercises

#### Exercise 1: Your First GET Request (Beginner Level)

**Objective:** Learn to make a basic GET request and display the result

**Task:**
Create a C# console application that:
1. Makes a GET request to `https://jsonplaceholder.typicode.com/users/1`
2. Displays the response status code
3. Displays the user's name and email from the response

**Requirements:**
- Use `HttpClient` to make the request
- Check if the request was successful before reading the response
- Parse the JSON to extract specific fields

**Hints:**
- Use `HttpClient.GetAsync()` for the request
- Use `System.Text.Json.JsonDocument` to parse JSON
- Check `response.IsSuccessStatusCode` before proceeding

**Solution:**
<details>
<summary>Click to reveal solution</summary>

```csharp
using System;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        using var client = new HttpClient();

        // Step 1: Make GET request
        string url = "https://jsonplaceholder.typicode.com/users/1";
        HttpResponseMessage response = await client.GetAsync(url);

        // Step 2: Display status code
        Console.WriteLine($"Status Code: {response.StatusCode}");

        // Step 3: Check if successful and parse response
        if (response.IsSuccessStatusCode)
        {
            string json = await response.Content.ReadAsStringAsync();

            using JsonDocument doc = JsonDocument.Parse(json);
            JsonElement root = doc.RootElement;

            string name = root.GetProperty("name").GetString();
            string email = root.GetProperty("email").GetString();

            Console.WriteLine($"Name: {name}");
            Console.WriteLine($"Email: {email}");
        }
        else
        {
            Console.WriteLine("Request failed!");
        }
    }
}
```

**Explanation:**
- We create an `HttpClient` for making HTTP requests
- `GetAsync()` sends a GET request and returns a response object
- We check `IsSuccessStatusCode` to verify the request succeeded
- We parse the JSON using `JsonDocument` and extract specific fields
- The `using` statements ensure proper resource cleanup
</details>

---

#### Exercise 2: Create a Resource with POST (Intermediate Level)

**Objective:** Learn to send data to an API using POST

**Task:**
Create a C# console application that:
1. Prompts the user for a todo title and description
2. Sends a POST request to `https://jsonplaceholder.typicode.com/posts`
3. Displays the created resource with its new ID

**Requirements:**
- Accept user input for title and body
- Serialize the data to JSON
- Send it with the correct Content-Type header
- Display the server's response including the assigned ID

**Hints:**
- Use `System.Text.Json.JsonSerializer.Serialize()` to create JSON
- Wrap the JSON in `StringContent` with UTF-8 encoding
- The Content-Type should be "application/json"

**Solution:**
<details>
<summary>Click to reveal solution</summary>

```csharp
using System;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        using var client = new HttpClient();

        // Step 1: Get user input
        Console.Write("Enter todo title: ");
        string title = Console.ReadLine();

        Console.Write("Enter todo description: ");
        string body = Console.ReadLine();

        // Step 2: Create the object to send
        var todo = new
        {
            title = title,
            body = body,
            userId = 1
        };

        // Step 3: Serialize to JSON
        string jsonContent = JsonSerializer.Serialize(todo);
        Console.WriteLine($"\nSending JSON:\n{jsonContent}\n");

        // Step 4: Create HTTP content
        var content = new StringContent(
            jsonContent,
            Encoding.UTF8,
            "application/json"
        );

        // Step 5: Send POST request
        string url = "https://jsonplaceholder.typicode.com/posts";
        HttpResponseMessage response = await client.PostAsync(url, content);

        // Step 6: Display result
        Console.WriteLine($"Status: {response.StatusCode}");

        if (response.IsSuccessStatusCode)
        {
            string responseJson = await response.Content.ReadAsStringAsync();
            Console.WriteLine($"\nServer response:\n{responseJson}");

            // Parse to show the ID
            using JsonDocument doc = JsonDocument.Parse(responseJson);
            int id = doc.RootElement.GetProperty("id").GetInt32();
            Console.WriteLine($"\n✓ Created with ID: {id}");
        }
    }
}
```

**Explanation:**
- We collect user input for the todo data
- We create an anonymous object and serialize it to JSON
- We wrap the JSON in `StringContent` with proper encoding and content type
- We send the POST request with `PostAsync()`
- The server responds with the created object including a new ID
</details>

---

#### Exercise 3: Build a Complete CRUD Client (Challenge Level)

**Objective:** Combine all HTTP methods into a reusable class

**Task:**
Create a `TodoApiClient` class that implements all CRUD operations:
1. `GetAllAsync()` - GET all todos
2. `GetByIdAsync(int id)` - GET a specific todo
3. `CreateAsync(Todo todo)` - POST to create a new todo
4. `UpdateAsync(int id, Todo todo)` - PUT to update a todo
5. `DeleteAsync(int id)` - DELETE a todo

Then create a simple console menu to test all operations.

**Requirements:**
- Create a `Todo` class with properties: Id, Title, Body, UserId
- Implement all five methods with proper error handling
- Each method should return a strongly-typed result (not just strings)
- Include a console menu to test each operation

**Bonus Challenges:**
- Add proper exception handling with custom exception types
- Implement retry logic for failed requests
- Add logging to show what's happening

**Solution:**
<details>
<summary>Click to reveal solution</summary>

```csharp
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Json;
using System.Threading.Tasks;

// Todo model
public class Todo
{
    public int Id { get; set; }
    public string Title { get; set; }
    public string Body { get; set; }
    public int UserId { get; set; }
}

// API Client
public class TodoApiClient
{
    private readonly HttpClient _client;
    private const string BaseUrl = "https://jsonplaceholder.typicode.com/posts";

    public TodoApiClient()
    {
        _client = new HttpClient();
    }

    public async Task<List<Todo>> GetAllAsync()
    {
        var response = await _client.GetAsync(BaseUrl);
        response.EnsureSuccessStatusCode();
        return await response.Content.ReadFromJsonAsync<List<Todo>>();
    }

    public async Task<Todo> GetByIdAsync(int id)
    {
        var response = await _client.GetAsync($"{BaseUrl}/{id}");
        response.EnsureSuccessStatusCode();
        return await response.Content.ReadFromJsonAsync<Todo>();
    }

    public async Task<Todo> CreateAsync(Todo todo)
    {
        var response = await _client.PostAsJsonAsync(BaseUrl, todo);
        response.EnsureSuccessStatusCode();
        return await response.Content.ReadFromJsonAsync<Todo>();
    }

    public async Task<Todo> UpdateAsync(int id, Todo todo)
    {
        var response = await _client.PutAsJsonAsync($"{BaseUrl}/{id}", todo);
        response.EnsureSuccessStatusCode();
        return await response.Content.ReadFromJsonAsync<Todo>();
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var response = await _client.DeleteAsync($"{BaseUrl}/{id}");
        return response.IsSuccessStatusCode;
    }
}

// Console Application
class Program
{
    static async Task Main()
    {
        var client = new TodoApiClient();
        bool running = true;

        while (running)
        {
            Console.WriteLine("\n=== Todo API Client ===");
            Console.WriteLine("1. Get all todos");
            Console.WriteLine("2. Get todo by ID");
            Console.WriteLine("3. Create new todo");
            Console.WriteLine("4. Update todo");
            Console.WriteLine("5. Delete todo");
            Console.WriteLine("0. Exit");
            Console.Write("\nChoice: ");

            string choice = Console.ReadLine();

            try
            {
                switch (choice)
                {
                    case "1":
                        await GetAllTodos(client);
                        break;
                    case "2":
                        await GetTodoById(client);
                        break;
                    case "3":
                        await CreateTodo(client);
                        break;
                    case "4":
                        await UpdateTodo(client);
                        break;
                    case "5":
                        await DeleteTodo(client);
                        break;
                    case "0":
                        running = false;
                        break;
                    default:
                        Console.WriteLine("Invalid choice");
                        break;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }
        }
    }

    static async Task GetAllTodos(TodoApiClient client)
    {
        Console.WriteLine("\nFetching all todos (showing first 5)...");
        var todos = await client.GetAllAsync();

        foreach (var todo in todos.Take(5))
        {
            Console.WriteLine($"[{todo.Id}] {todo.Title}");
        }
        Console.WriteLine($"... and {todos.Count - 5} more");
    }

    static async Task GetTodoById(TodoApiClient client)
    {
        Console.Write("Enter todo ID: ");
        int id = int.Parse(Console.ReadLine());

        var todo = await client.GetByIdAsync(id);
        Console.WriteLine($"\nID: {todo.Id}");
        Console.WriteLine($"Title: {todo.Title}");
        Console.WriteLine($"Body: {todo.Body}");
        Console.WriteLine($"User ID: {todo.UserId}");
    }

    static async Task CreateTodo(TodoApiClient client)
    {
        Console.Write("Enter title: ");
        string title = Console.ReadLine();

        Console.Write("Enter body: ");
        string body = Console.ReadLine();

        var newTodo = new Todo
        {
            Title = title,
            Body = body,
            UserId = 1
        };

        var created = await client.CreateAsync(newTodo);
        Console.WriteLine($"\n✓ Created todo with ID: {created.Id}");
    }

    static async Task UpdateTodo(TodoApiClient client)
    {
        Console.Write("Enter todo ID to update: ");
        int id = int.Parse(Console.ReadLine());

        Console.Write("Enter new title: ");
        string title = Console.ReadLine();

        Console.Write("Enter new body: ");
        string body = Console.ReadLine();

        var todo = new Todo
        {
            Id = id,
            Title = title,
            Body = body,
            UserId = 1
        };

        var updated = await client.UpdateAsync(id, todo);
        Console.WriteLine($"\n✓ Updated todo {updated.Id}");
    }

    static async Task DeleteTodo(TodoApiClient client)
    {
        Console.Write("Enter todo ID to delete: ");
        int id = int.Parse(Console.ReadLine());

        bool success = await client.DeleteAsync(id);

        if (success)
            Console.WriteLine($"\n✓ Deleted todo {id}");
        else
            Console.WriteLine($"\n✗ Failed to delete todo {id}");
    }
}
```

**Explanation:**
This solution demonstrates:
- Creating a reusable API client class with all CRUD operations
- Using `ReadFromJsonAsync` and `PostAsJsonAsync` for easier JSON handling
- Proper error handling with `EnsureSuccessStatusCode()`
- A clean console interface for testing all operations
- Strongly-typed models instead of working with raw strings
</details>

---

### Comprehension Questions

**Question 1:** What's the difference between PUT and PATCH HTTP methods?

<details>
<summary>Answer</summary>

**PUT** is used to replace an entire resource. You send the complete object, and the server replaces everything.

**PATCH** is used to partially update a resource. You send only the fields you want to change.

**Example:**

If you have a Pokemon:
```json
{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric",
  "level": 20,
  "hp": 100
}
```

**Using PUT** - You must send ALL fields:
```http
PUT /api/pokemon/25
{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric",
  "level": 21,    // Changed
  "hp": 100
}
```

**Using PATCH** - You send only what changed:
```http
PATCH /api/pokemon/25
{
  "level": 21    // Only this changed
}
```

**When to use each:**
- Use **PUT** when you have the complete object and want to ensure consistency
- Use **PATCH** when you only know specific fields to change (more efficient)
</details>

---

**Question 2:** Why are status codes important? Can't we just check the response body?

<details>
<summary>Answer</summary>

Status codes are important because they provide immediate, standardized information about the result without parsing the response body.

**Key reasons:**

1. **Standardization**: Status codes mean the same thing across all APIs. A 404 always means "not found", whether it's from GitHub, Twitter, or your own API.

2. **Efficiency**: You can make decisions based on status codes without parsing potentially large response bodies.

3. **Different types of responses**: Sometimes there is no body (like a 204 No Content response).

4. **Client behavior**: Browsers and HTTP clients use status codes to determine what to do next (cache, retry, redirect, etc.).

**Example:**

```csharp
HttpResponseMessage response = await client.GetAsync(url);

// Quick decision based on status code
if (response.StatusCode == HttpStatusCode.NotFound)
{
    // Don't waste time parsing body - resource doesn't exist
    return null;
}
else if (response.StatusCode == HttpStatusCode.Unauthorized)
{
    // Redirect user to login - no need to check body
    RedirectToLogin();
}
else if (response.IsSuccessStatusCode)
{
    // Now it makes sense to parse the body
    return await response.Content.ReadFromJsonAsync<Pokemon>();
}
```

Without status codes, every API would handle errors differently, making it harder to write consistent client code.
</details>

---

**Question 3:** When should you use query parameters vs route parameters?

<details>
<summary>Answer</summary>

**Route parameters** are part of the URL path and identify a specific resource:
```
/api/pokemon/25           # 25 is a route parameter (which Pokemon)
/api/users/john/posts     # john is a route parameter (which user)
```

**Query parameters** come after `?` and are used for filtering, sorting, or optional modifications:
```
/api/pokemon?type=fire&limit=10     # Filter and limit
/api/pokemon?sort=name&order=asc    # Sort and order
```

**Guidelines:**

Use **route parameters** when:
- Identifying a specific resource (ID, username, slug)
- The parameter is required for the endpoint to work
- The parameter represents a noun (a "thing")
- Example: `/api/pokemon/25` - 25 identifies which Pokemon

Use **query parameters** when:
- Filtering a collection: `/api/pokemon?type=fire`
- Sorting: `/api/pokemon?sort=name`
- Pagination: `/api/pokemon?page=2&limit=20`
- Optional parameters: `/api/pokemon?includeStats=true`
- Multiple options: `/api/pokemon?type=fire&region=kanto`

**Example API design:**

```
Good:
  GET /api/pokemon/25                      # Get specific Pokemon
  GET /api/pokemon?type=fire               # Filter by type
  GET /api/pokemon?type=fire&limit=10      # Filter and limit

Bad:
  GET /api/pokemon?id=25                   # Should use route parameter
  GET /api/pokemon/fire/10                 # Filters shouldn't be in path
```

**Rule of thumb**: If removing the parameter makes the endpoint meaningless, it should be a route parameter. If removing it still makes sense (but changes what's returned), it should be a query parameter.
</details>

---

**Question 4:** What does it mean that HTTP is "stateless"? How do websites remember you're logged in?

<details>
<summary>Answer</summary>

**HTTP is stateless** means each request is independent and contains no memory of previous requests. The server doesn't automatically remember who you are between requests.

**Analogy:**
Imagine calling a restaurant where the person answering the phone has amnesia:
- **Stateless (HTTP)**: "I'd like to add a pizza to my order" → "What order? I don't remember you calling before."
- **Stateful**: "I'd like to add a pizza to my order" → "Sure, adding a pizza to order #123."

**How websites "remember" you:**

Websites use several techniques to work around HTTP's statelessness:

**1. Cookies:**
```http
# Server's first response
HTTP/1.1 200 OK
Set-Cookie: sessionId=abc123; Path=/; HttpOnly

# Client's next request automatically includes:
GET /api/profile HTTP/1.1
Cookie: sessionId=abc123
```

The server sends a cookie (like a claim ticket), and the browser automatically includes it in future requests. The server uses this to look up your session.

**2. Tokens (like JWT):**
```http
# After login, server returns token
{ "token": "eyJhbGciOiJIUzI1..." }

# Client includes in future requests
GET /api/profile HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1...
```

The client stores the token and includes it in every request. The token contains or references your identity.

**3. Session storage on server:**
Server maintains a table:
```
Session ID    User ID    Last Activity
abc123        42         2024-11-22 10:30
def456        17         2024-11-22 10:28
```

**Why stateless is good:**
- **Scalability**: Any server can handle any request (no need to route to the same server)
- **Reliability**: No state to lose if server restarts
- **Simplicity**: Easier to understand and debug

**Why stateless is challenging:**
- Requires extra work (cookies, tokens) to maintain user sessions
- Each request must include all necessary information
</details>

---

**Question 5:** You're getting a 401 Unauthorized error. What should you check?

<details>
<summary>Answer</summary>

A **401 Unauthorized** error means authentication failed or is missing. Here's what to check in order:

**1. Are you sending authentication credentials?**
```csharp
// Missing authentication ❌
var response = await client.GetAsync("https://api.example.com/protected");

// With authentication ✅
client.DefaultRequestHeaders.Authorization =
    new AuthenticationHeaderValue("Bearer", "your-token-here");
var response = await client.GetAsync("https://api.example.com/protected");
```

**2. Is the token/credentials still valid?**
- Tokens expire (check expiration time)
- Password might have been changed
- API key might have been revoked

**3. Is the token in the correct format?**
```csharp
// Wrong ❌
"Authorization: your-token-here"

// Correct for Bearer token ✅
"Authorization: Bearer your-token-here"

// Correct for Basic auth ✅
"Authorization: Basic base64EncodedCredentials"
```

**4. Are you using the right header?**
Different APIs use different headers:
- `Authorization: Bearer token` (most common)
- `X-API-Key: key` (some APIs)
- `Cookie: session=abc123` (session-based)

**5. Did you get the token from the right endpoint?**
```csharp
// First, get token
var loginResponse = await client.PostAsJsonAsync("https://api.example.com/login",
    new { username = "user", password = "pass" });
var token = await loginResponse.Content.ReadFromJsonAsync<TokenResponse>();

// Then use it
client.DefaultRequestHeaders.Authorization =
    new AuthenticationHeaderValue("Bearer", token.AccessToken);
```

**6. Check the API documentation**
Every API handles authentication differently. Common schemes:
- Bearer tokens (OAuth 2.0, JWT)
- API keys
- Basic authentication (username:password)
- Custom headers

**Debugging steps:**
```csharp
HttpResponseMessage response = await client.GetAsync(url);

if (response.StatusCode == HttpStatusCode.Unauthorized)
{
    Console.WriteLine("Authentication failed!");

    // Check what you sent
    var authHeader = client.DefaultRequestHeaders.Authorization;
    Console.WriteLine($"Auth header: {authHeader?.Scheme} {authHeader?.Parameter}");

    // Check response for hints
    string body = await response.Content.ReadAsStringAsync();
    Console.WriteLine($"Server message: {body}");
}
```

**Common mistakes:**
- Forgetting to include the word "Bearer" before the token
- Including extra quotes around the token
- Token expired and needs refresh
- Using token for wrong environment (dev token in production)
</details>

### Self-Assessment Checklist

After completing this section, you should be able to:

- [ ] Explain what HTTP is and why it's the foundation of web communication
- [ ] Describe the HTTP request-response cycle
- [ ] List and explain all five main HTTP methods (GET, POST, PUT, PATCH, DELETE)
- [ ] Identify common HTTP status codes and what they mean (200, 201, 400, 401, 404, 500)
- [ ] Differentiate between route parameters and query parameters
- [ ] Make HTTP requests using C# and HttpClient
- [ ] Send and receive JSON data with proper headers
- [ ] Handle HTTP errors gracefully in code
- [ ] Read and understand HTTP requests in browser developer tools
- [ ] Explain why HTTP is stateless and how sessions work around this

**If you can't check all these boxes:**
- Review the Core Concepts & Theory section
- Try the hands-on exercises again
- Test HTTP requests using Postman or browser tools
- Practice with the PokéAPI or JSONPlaceholder test APIs

### Debugging Tips

If your HTTP requests aren't working:

**1. Check the status code first**
```csharp
Console.WriteLine($"Status: {response.StatusCode}");
```

**2. Read the response body even on errors**
```csharp
string body = await response.Content.ReadAsStringAsync();
Console.WriteLine($"Response: {body}");
```

**3. Verify the URL is correct**
```csharp
Console.WriteLine($"Requesting: {url}");
// Check for typos, http vs https, correct domain
```

**4. Check your request headers**
```csharp
foreach (var header in client.DefaultRequestHeaders)
{
    Console.WriteLine($"{header.Key}: {string.Join(", ", header.Value)}");
}
```

**5. Use browser developer tools**
- Press F12 in browser
- Go to Network tab
- Make the request
- Inspect the actual HTTP traffic

**Common debugging workflow:**
```
1. Check status code (200? 404? 500?)
2. If 4xx, check your request (URL, headers, body)
3. If 5xx, the server has a problem (check server logs)
4. Read the error message in response body
5. Verify content-type matches what you're sending
6. Test the same request in Postman
7. Compare working request to your code
```

---

## 9. Practical Examples

### Example 1: Simple Weather Check (Beginner)

**Scenario:**
You want to check if a URL is reachable and responds successfully. This is useful for health checks or monitoring.

**Code:**
```csharp
using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;

public class HealthChecker
{
    private readonly HttpClient _client;

    public HealthChecker()
    {
        _client = new HttpClient();
        _client.Timeout = TimeSpan.FromSeconds(5); // Don't wait forever
    }

    public async Task<bool> IsServiceHealthyAsync(string url)
    {
        try
        {
            HttpResponseMessage response = await _client.GetAsync(url);

            // Log the check
            Console.WriteLine($"Checked: {url}");
            Console.WriteLine($"Status: {response.StatusCode}");

            // Success if status code is in 200-299 range
            return response.IsSuccessStatusCode;
        }
        catch (HttpRequestException ex)
        {
            Console.WriteLine($"Request failed: {ex.Message}");
            return false;
        }
        catch (TaskCanceledException)
        {
            Console.WriteLine("Request timed out");
            return false;
        }
    }
}

// Usage
var checker = new HealthChecker();

bool healthy = await checker.IsServiceHealthyAsync("https://jsonplaceholder.typicode.com/posts/1");
Console.WriteLine(healthy ? "✓ Service is healthy" : "✗ Service is down");
```

**Walkthrough:**
1. We create an `HttpClient` with a 5-second timeout to avoid waiting forever
2. We use `GetAsync()` to make a simple GET request
3. We check `IsSuccessStatusCode` to see if the status is in the 200-299 range
4. We catch `HttpRequestException` for network errors (DNS failure, connection refused, etc.)
5. We catch `TaskCanceledException` for timeouts

**Try it yourself:**
- Modify it to check multiple URLs in parallel
- Add retry logic for transient failures
- Create a background service that checks health every minute

---

### Example 2: API Client with Retry Logic (Intermediate)

**Scenario:**
Sometimes HTTP requests fail due to temporary network issues or server overload. You want to automatically retry failed requests a few times before giving up.

**Code:**
```csharp
using System;
using System.Net.Http;
using System.Threading.Tasks;

public class ResilientHttpClient
{
    private readonly HttpClient _client;
    private const int MaxRetries = 3;

    public ResilientHttpClient()
    {
        _client = new HttpClient();
    }

    public async Task<string> GetWithRetryAsync(string url)
    {
        int attempt = 0;

        while (attempt < MaxRetries)
        {
            try
            {
                Console.WriteLine($"Attempt {attempt + 1} of {MaxRetries}");

                HttpResponseMessage response = await _client.GetAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    Console.WriteLine("✓ Success!");
                    return await response.Content.ReadAsStringAsync();
                }

                // If 4xx error, don't retry (client error, won't fix itself)
                if ((int)response.StatusCode >= 400 && (int)response.StatusCode < 500)
                {
                    throw new Exception($"Client error: {response.StatusCode}");
                }

                // 5xx errors might be temporary, retry
                Console.WriteLine($"Server error: {response.StatusCode}, retrying...");
            }
            catch (HttpRequestException ex)
            {
                Console.WriteLine($"Request failed: {ex.Message}");

                // Network error, might be temporary
                if (attempt >= MaxRetries - 1)
                {
                    throw; // Last attempt, give up
                }
            }

            // Wait before retrying (exponential backoff)
            int delaySeconds = (int)Math.Pow(2, attempt); // 1, 2, 4 seconds
            Console.WriteLine($"Waiting {delaySeconds} seconds before retry...\n");
            await Task.Delay(TimeSpan.FromSeconds(delaySeconds));

            attempt++;
        }

        throw new Exception($"Failed after {MaxRetries} attempts");
    }
}

// Usage
var client = new ResilientHttpClient();

try
{
    string result = await client.GetWithRetryAsync("https://jsonplaceholder.typicode.com/posts/1");
    Console.WriteLine($"Result: {result.Substring(0, 100)}...");
}
catch (Exception ex)
{
    Console.WriteLine($"All retries failed: {ex.Message}");
}
```

**Walkthrough:**
1. We attempt the request up to `MaxRetries` times
2. If we get a 4xx error (client error), we don't retry - these won't fix themselves
3. If we get a 5xx error (server error) or network error, we retry
4. We use exponential backoff (1s, 2s, 4s) to avoid hammering the server
5. After max retries, we throw an exception

**Key takeaways:**
- **Don't retry 4xx errors** - these are client mistakes (wrong URL, bad data)
- **Do retry 5xx errors** - server might be temporarily overloaded
- **Use exponential backoff** - gives the server time to recover
- **Have a maximum retry limit** - don't retry forever

---

### Example 3: Parallel Requests for Performance (Advanced)

**Scenario:**
You need to fetch data from multiple API endpoints. Making sequential requests is slow. You want to make all requests in parallel to improve performance.

**Code:**
```csharp
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Json;
using System.Threading.Tasks;

public class Pokemon
{
    public int Id { get; set; }
    public string Name { get; set; }
}

public class ParallelApiClient
{
    private readonly HttpClient _client;

    public ParallelApiClient()
    {
        _client = new HttpClient();
    }

    // Sequential approach (slow)
    public async Task<List<Pokemon>> GetPokemonSequentialAsync(int[] ids)
    {
        var pokemons = new List<Pokemon>();

        foreach (int id in ids)
        {
            string url = $"https://pokeapi.co/api/v2/pokemon/{id}";
            var pokemon = await _client.GetFromJsonAsync<Pokemon>(url);
            pokemons.Add(pokemon);
        }

        return pokemons;
    }

    // Parallel approach (fast)
    public async Task<List<Pokemon>> GetPokemonParallelAsync(int[] ids)
    {
        // Create all tasks at once
        var tasks = ids.Select(id =>
        {
            string url = $"https://pokeapi.co/api/v2/pokemon/{id}";
            return _client.GetFromJsonAsync<Pokemon>(url);
        });

        // Wait for all to complete
        Pokemon[] results = await Task.WhenAll(tasks);

        return results.ToList();
    }
}

// Usage - Compare performance
var client = new ParallelApiClient();
int[] pokemonIds = { 1, 2, 3, 4, 5, 25, 94, 150 };

// Sequential
Console.WriteLine("Sequential approach:");
var sw = Stopwatch.StartNew();
var sequential = await client.GetPokemonSequentialAsync(pokemonIds);
sw.Stop();
Console.WriteLine($"Fetched {sequential.Count} Pokemon in {sw.ElapsedMilliseconds}ms");

// Parallel
Console.WriteLine("\nParallel approach:");
sw.Restart();
var parallel = await client.GetPokemonParallelAsync(pokemonIds);
sw.Stop();
Console.WriteLine($"Fetched {parallel.Count} Pokemon in {sw.ElapsedMilliseconds}ms");

// Show results
Console.WriteLine("\nFetched Pokemon:");
foreach (var p in parallel)
{
    Console.WriteLine($"- {p.Name} (#{p.Id})");
}
```

**Walkthrough:**
1. **Sequential**: We loop through IDs and await each request one-by-one (slow)
2. **Parallel**: We create all tasks upfront using `Select()` (they start immediately)
3. We use `Task.WhenAll()` to wait for all tasks to complete
4. The parallel version is typically 5-8x faster for 8 requests

**Key takeaways:**
- Use parallel requests when fetching multiple independent resources
- `Task.WhenAll()` waits for all tasks and returns all results
- Be mindful of rate limits - don't make 1000 parallel requests
- Parallel requests don't guarantee order - results come back in completion order

**When to use:**
- Fetching multiple resources by ID
- Calling multiple different APIs
- Batch processing

**When not to use:**
- Requests depend on each other (need result from first to make second)
- API has strict rate limits
- Server can't handle concurrent requests

---

## 10. Common Patterns & Best Practices

### Recommended Patterns

#### Pattern 1: RESTful Resource Naming

**Description:**
REST (Representational State Transfer) is an architectural style that uses HTTP methods and URLs to represent operations on resources.

**When to use:**
When designing any web API that will be used by multiple clients (web, mobile, etc.).

**Example:**

**Good RESTful API design:**
```
GET    /api/pokemon           # Get all Pokemon
GET    /api/pokemon/25        # Get Pokemon with ID 25
POST   /api/pokemon           # Create new Pokemon
PUT    /api/pokemon/25        # Update Pokemon 25 (full update)
PATCH  /api/pokemon/25        # Update Pokemon 25 (partial update)
DELETE /api/pokemon/25        # Delete Pokemon 25

GET    /api/pokemon/25/moves  # Get moves for Pokemon 25
POST   /api/pokemon/25/moves  # Add move to Pokemon 25
```

**Bad API design:**
```
GET    /api/getPokemon?id=25        # Don't use verbs in URL (GET already says "get")
POST   /api/createPokemon           # Don't use verbs (POST already says "create")
GET    /api/pokemon/delete/25       # Don't use GET for actions that modify data
POST   /api/pokemon/25              # Don't use POST for retrieving data
```

**Why this is good:**
- **Predictable**: Developers can guess endpoints without documentation
- **Consistent**: All resources follow the same pattern
- **Semantic**: HTTP methods have clear meanings
- **Cacheable**: GET requests can be cached by browsers/proxies

**Rules for RESTful URLs:**
1. Use nouns for resources, not verbs: `/pokemon`, not `/getPokemon`
2. Use plural names for collections: `/pokemon`, not `/pokemon-list`
3. Use HTTP methods to indicate actions, not URL paths
4. Use hierarchical URLs for related resources: `/pokemon/25/moves`

#### Pattern 2: HTTP Client Factory Pattern (IHttpClientFactory)

**Description:**
Instead of creating HttpClient instances directly, use `IHttpClientFactory` to manage HttpClient instances. This prevents socket exhaustion and allows for centralized configuration.

**When to use:**
Always, in production ASP.NET Core applications.

**Example:**

**Setup in Program.cs:**
```csharp
var builder = WebApplication.CreateBuilder(args);

// Register named client
builder.Services.AddHttpClient("PokemonAPI", client =>
{
    client.BaseAddress = new Uri("https://pokeapi.co/api/v2/");
    client.Timeout = TimeSpan.FromSeconds(30);
    client.DefaultRequestHeaders.Add("User-Agent", "PokemonApp/1.0");
});

// Or register typed client (recommended)
builder.Services.AddHttpClient<IPokemonService, PokemonService>(client =>
{
    client.BaseAddress = new Uri("https://pokeapi.co/api/v2/");
});
```

**Using named client:**
```csharp
public class PokemonService
{
    private readonly HttpClient _httpClient;

    public PokemonService(IHttpClientFactory httpClientFactory)
    {
        _httpClient = httpClientFactory.CreateClient("PokemonAPI");
    }

    public async Task<string> GetPokemonAsync(int id)
    {
        // BaseAddress already set, just use relative path
        var response = await _httpClient.GetAsync($"pokemon/{id}");
        return await response.Content.ReadAsStringAsync();
    }
}
```

**Why this is good:**
- **Prevents socket exhaustion**: Properly manages connection pooling
- **Centralized configuration**: Configure once, use everywhere
- **Testability**: Easy to mock `IHttpClientFactory` in tests
- **Performance**: Reuses connections efficiently

#### Pattern 3: Strongly-Typed Responses with Models

**Description:**
Instead of working with raw JSON strings, deserialize responses into C# classes.

**When to use:**
Always, unless you're just exploring an API.

**Example:**

**Define models:**
```csharp
public class Pokemon
{
    public int Id { get; set; }
    public string Name { get; set; }
    public int Height { get; set; }
    public int Weight { get; set; }
}
```

**Use strongly-typed deserialization:**
```csharp
public async Task<Pokemon> GetPokemonAsync(int id)
{
    var response = await _httpClient.GetAsync($"https://pokeapi.co/api/v2/pokemon/{id}");
    response.EnsureSuccessStatusCode();

    // Deserialize directly to model
    return await response.Content.ReadFromJsonAsync<Pokemon>();
}

// Usage
Pokemon pikachu = await service.GetPokemonAsync(25);
Console.WriteLine($"{pikachu.Name} is {pikachu.Height} decimeters tall");
```

**Why this is good:**
- **Type safety**: Compiler catches errors
- **IntelliSense**: Auto-completion in IDE
- **Refactoring**: Easy to find all usages
- **Validation**: Can add data annotations to models

#### Pattern 4: Proper Error Handling

**Description:**
Handle different types of HTTP errors appropriately, distinguishing between client errors, server errors, and network errors.

**When to use:**
Every production HTTP client.

**Example:**
```csharp
public async Task<Pokemon> GetPokemonAsync(int id)
{
    try
    {
        var response = await _httpClient.GetAsync($"https://pokeapi.co/api/v2/pokemon/{id}");

        // Check status code
        switch ((int)response.StatusCode)
        {
            case 200:
                return await response.Content.ReadFromJsonAsync<Pokemon>();

            case 404:
                throw new PokemonNotFoundException($"Pokemon with ID {id} not found");

            case 400:
                throw new BadRequestException("Invalid Pokemon ID");

            case 401:
            case 403:
                throw new UnauthorizedException("Access denied to Pokemon API");

            case >= 500:
                throw new PokemonApiException("Pokemon API is experiencing issues");

            default:
                throw new PokemonApiException($"Unexpected status code: {response.StatusCode}");
        }
    }
    catch (HttpRequestException ex)
    {
        // Network error (DNS failure, connection refused, etc.)
        throw new PokemonApiException("Failed to connect to Pokemon API", ex);
    }
    catch (TaskCanceledException ex)
    {
        // Timeout
        throw new PokemonApiException("Request to Pokemon API timed out", ex);
    }
}

// Custom exceptions
public class PokemonNotFoundException : Exception
{
    public PokemonNotFoundException(string message) : base(message) { }
}

public class PokemonApiException : Exception
{
    public PokemonApiException(string message) : base(message) { }
    public PokemonApiException(string message, Exception inner) : base(message, inner) { }
}
```

**Why this is good:**
- **Specific exceptions**: Caller can handle different errors differently
- **Network errors handled**: Distinguishes network issues from API errors
- **Timeouts handled**: Doesn't hang forever
- **Meaningful messages**: Clear error descriptions

### Do's and Don'ts

#### Do's

- ✅ **Use HTTPS in production** - Encrypts data in transit, preventing eavesdropping
  ```csharp
  // Good
  "https://api.example.com/data"

  // Bad (in production)
  "http://api.example.com/data"
  ```

- ✅ **Set appropriate timeouts** - Don't let requests hang forever
  ```csharp
  client.Timeout = TimeSpan.FromSeconds(30);
  ```

- ✅ **Use IHttpClientFactory in ASP.NET Core** - Prevents socket exhaustion
  ```csharp
  builder.Services.AddHttpClient<IMyService, MyService>();
  ```

- ✅ **Return appropriate status codes from your APIs** - Use 200/201/204 for success, 400/404 for client errors, 500 for server errors
  ```csharp
  // In controller
  if (pokemon == null)
      return NotFound(); // 404

  return Ok(pokemon); // 200
  ```

- ✅ **Use async/await for HTTP requests** - Keeps your app responsive
  ```csharp
  var response = await _httpClient.GetAsync(url); // ✅
  // Not: var response = _httpClient.GetAsync(url).Result; // ❌
  ```

- ✅ **Check status codes before reading response** - Avoid parsing error responses as data
  ```csharp
  if (response.IsSuccessStatusCode)
  {
      var data = await response.Content.ReadFromJsonAsync<Pokemon>();
  }
  ```

#### Don'ts

- ❌ **Don't create new HttpClient for every request** - Causes socket exhaustion
  - **Instead:** Use `IHttpClientFactory` or reuse a single static `HttpClient`
  ```csharp
  // Bad ❌
  public async Task<string> GetDataAsync()
  {
      using var client = new HttpClient(); // Creates new client every time!
      return await client.GetStringAsync(url);
  }

  // Good ✅
  public class MyService
  {
      private readonly HttpClient _client;

      public MyService(HttpClient client)
      {
          _client = client;
      }

      public async Task<string> GetDataAsync()
      {
          return await _client.GetStringAsync(url);
      }
  }
  ```

- ❌ **Don't use GET requests to modify data** - GET should be read-only
  - **Instead:** Use POST, PUT, PATCH, or DELETE for modifications
  ```csharp
  // Bad ❌
  GET /api/pokemon/25/delete

  // Good ✅
  DELETE /api/pokemon/25
  ```

- ❌ **Don't ignore SSL certificate errors in production** - Major security risk
  - **Instead:** Fix your certificates
  ```csharp
  // Never do this in production! ❌
  var handler = new HttpClientHandler
  {
      ServerCertificateCustomValidationCallback = (message, cert, chain, errors) => true
  };
  ```

- ❌ **Don't put sensitive data in URLs** - URLs are logged everywhere
  - **Instead:** Use request headers or body
  ```csharp
  // Bad ❌
  GET /api/user?password=secret123

  // Good ✅
  POST /api/auth
  Headers: Authorization: Bearer token
  ```

- ❌ **Don't block async calls with .Result or .Wait()** - Can cause deadlocks
  - **Instead:** Use await
  ```csharp
  // Bad ❌
  var result = _client.GetAsync(url).Result;

  // Good ✅
  var result = await _client.GetAsync(url);
  ```

### Code Organization

**Recommended structure for HTTP clients:**

```
MyProject/
├── Services/
│   ├── Interfaces/
│   │   └── IPokemonService.cs         # Service interface
│   └── PokemonService.cs              # HTTP client implementation
├── Models/
│   ├── Pokemon.cs                     # Domain models
│   └── ApiResponses/
│       └── PokemonApiResponse.cs      # API-specific response models
├── Exceptions/
│   ├── PokemonNotFoundException.cs    # Custom exceptions
│   └── PokemonApiException.cs
└── Program.cs                         # HttpClient registration
```

**Example structure:**

**Models/Pokemon.cs:**
```csharp
namespace MyProject.Models;

public class Pokemon
{
    public int Id { get; set; }
    public string Name { get; set; }
    public int Height { get; set; }
    public int Weight { get; set; }
}
```

**Services/Interfaces/IPokemonService.cs:**
```csharp
namespace MyProject.Services.Interfaces;

public interface IPokemonService
{
    Task<Pokemon> GetPokemonAsync(int id);
    Task<List<Pokemon>> GetAllPokemonAsync();
    Task<Pokemon> CreatePokemonAsync(Pokemon pokemon);
}
```

**Services/PokemonService.cs:**
```csharp
namespace MyProject.Services;

public class PokemonService : IPokemonService
{
    private readonly HttpClient _httpClient;
    private readonly ILogger<PokemonService> _logger;

    public PokemonService(HttpClient httpClient, ILogger<PokemonService> logger)
    {
        _httpClient = httpClient;
        _logger = logger;
    }

    public async Task<Pokemon> GetPokemonAsync(int id)
    {
        _logger.LogInformation("Fetching Pokemon {PokemonId}", id);

        var response = await _httpClient.GetAsync($"pokemon/{id}");
        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<Pokemon>();
    }
}
```

**Program.cs:**
```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddHttpClient<IPokemonService, PokemonService>(client =>
{
    client.BaseAddress = new Uri("https://pokeapi.co/api/v2/");
});
```

### Performance Considerations

**Performance tips:**

1. **Reuse HttpClient instances** - Creating new clients is expensive
   ```csharp
   // Expensive ❌
   for (int i = 0; i < 100; i++)
   {
       using var client = new HttpClient();
       await client.GetAsync(url);
   }

   // Efficient ✅
   using var client = new HttpClient();
   for (int i = 0; i < 100; i++)
   {
       await client.GetAsync(url);
   }
   ```

2. **Use HTTP/2 when possible** - Multiplexes multiple requests over one connection
   ```csharp
   var handler = new SocketsHttpHandler
   {
       EnableMultipleHttp2Connections = true
   };
   ```

3. **Enable compression** - Reduces bandwidth usage
   ```csharp
   var handler = new HttpClientHandler
   {
       AutomaticDecompression = DecompressionMethods.GZip | DecompressionMethods.Deflate
   };
   ```

4. **Use streaming for large responses** - Don't load everything into memory
   ```csharp
   using var response = await _httpClient.GetAsync(url, HttpCompletionOption.ResponseHeadersRead);
   using var stream = await response.Content.ReadAsStreamAsync();
   // Process stream incrementally
   ```

5. **Make parallel requests when appropriate** - Don't wait for requests sequentially
   ```csharp
   var tasks = ids.Select(id => _httpClient.GetAsync($"/pokemon/{id}"));
   var responses = await Task.WhenAll(tasks);
   ```

**Common performance pitfalls:**

- **Creating HttpClient per request** - Exhausts sockets. Use `IHttpClientFactory`.
- **Not reusing connections** - HTTP keep-alive should be enabled (default in .NET).
- **Blocking on async calls** - Using `.Result` or `.Wait()` wastes thread pool threads.
- **Not setting timeouts** - One slow request can block your app.
- **Serializing requests that could be parallel** - Makes things slower than necessary.

---

## 11. Troubleshooting & Common Issues

### Frequently Encountered Problems

#### Problem 1: "HttpRequestException: No such host is known"

**Symptoms:**
- Exception thrown when making request
- Error message mentions DNS or "host is known"
- Happens before getting any HTTP response

**Cause:**
The domain name in your URL can't be resolved to an IP address. This usually means:
1. You have a typo in the URL
2. You're offline or have no internet connection
3. The domain doesn't exist
4. DNS server is having issues

**Solution:**

**Step 1: Check the URL for typos**
```csharp
// Wrong ❌
"https://api.exmaple.com"  // "exmaple" instead of "example"

// Correct ✅
"https://api.example.com"
```

**Step 2: Verify internet connectivity**
```bash
# Test if you can reach the host
ping api.example.com
```

**Step 3: Try the URL in a browser**
If it works in the browser but not in your code, compare the exact URLs.

**Step 4: Check for hardcoded vs configured URLs**
```csharp
// Better: Use configuration
var apiUrl = configuration["ApiSettings:BaseUrl"];
```

---

#### Problem 2: "TaskCanceledException: A task was canceled"

**Symptoms:**
- Request throws `TaskCanceledException`
- Takes a long time before throwing
- Error message mentions "task was canceled"

**Cause:**
The request timed out. The default timeout is 100 seconds, but can be configured.

**Solution:**

**Step 1: Increase timeout if needed**
```csharp
// Set timeout to 30 seconds
_httpClient.Timeout = TimeSpan.FromSeconds(30);

// Or per request
using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(30));
var response = await _httpClient.GetAsync(url, cts.Token);
```

**Step 2: Check if the API is responding slowly**
Test the API with Postman or cURL to see how long it takes.

**Step 3: Handle timeout gracefully**
```csharp
try
{
    var response = await _httpClient.GetAsync(url);
}
catch (TaskCanceledException)
{
    Console.WriteLine("Request timed out. The server is responding slowly or is down.");
    // Maybe retry or use a fallback
}
```

**Step 4: Consider if the API is too slow**
- Is the API doing too much work?
- Do you need pagination to fetch less data?
- Can you cache the response?

---

#### Problem 3: "401 Unauthorized" - Authentication Failed

**Symptoms:**
- Status code 401
- Error message about authorization or authentication
- Happens on protected endpoints

**Cause:**
Your authentication credentials are missing, invalid, or expired.

**Solution:**

**Step 1: Verify you're sending authentication**
```csharp
// Check if header is set
var authHeader = _httpClient.DefaultRequestHeaders.Authorization;
Console.WriteLine($"Auth: {authHeader?.Scheme} {authHeader?.Parameter?.Substring(0, 10)}...");
```

**Step 2: Ensure correct format**
```csharp
// For Bearer tokens
_httpClient.DefaultRequestHeaders.Authorization =
    new AuthenticationHeaderValue("Bearer", token);

// For API keys (check API docs)
_httpClient.DefaultRequestHeaders.Add("X-API-Key", apiKey);

// For Basic auth
var credentials = Convert.ToBase64String(Encoding.ASCII.GetBytes($"{username}:{password}"));
_httpClient.DefaultRequestHeaders.Authorization =
    new AuthenticationHeaderValue("Basic", credentials);
```

**Step 3: Check token expiration**
```csharp
// If using JWT, decode and check expiration
var handler = new JwtSecurityTokenHandler();
var token = handler.ReadJwtToken(yourToken);

if (token.ValidTo < DateTime.UtcNow)
{
    Console.WriteLine("Token expired! Need to refresh.");
    // Get new token
}
```

**Step 4: Verify you're using the right credentials**
- Check environment (dev token won't work in production)
- Ensure credentials haven't been revoked
- Confirm you're using the right authentication method

---

#### Problem 4: "415 Unsupported Media Type"

**Symptoms:**
- Status code 415 on POST/PUT requests
- Server rejects your request
- Error message about media type or content type

**Cause:**
You're sending data in a format the server doesn't accept, or the `Content-Type` header is wrong/missing.

**Solution:**

**Step 1: Set Content-Type header correctly**
```csharp
// Most APIs expect JSON
var content = new StringContent(
    jsonString,
    Encoding.UTF8,
    "application/json"  // This is crucial!
);
```

**Step 2: Use helper methods that set it automatically**
```csharp
// This automatically sets Content-Type: application/json
await _httpClient.PostAsJsonAsync(url, data);
```

**Step 3: Check API documentation**
Some APIs expect different formats:
```csharp
// XML
"application/xml"

// Form data
"application/x-www-form-urlencoded"

// Multipart (file uploads)
"multipart/form-data"
```

**Step 4: Inspect what you're sending**
```csharp
Console.WriteLine($"Content-Type: {content.Headers.ContentType}");
Console.WriteLine($"Content: {await content.ReadAsStringAsync()}");
```

---

#### Problem 5: "JsonException: The JSON value could not be converted"

**Symptoms:**
- Exception when trying to deserialize response
- Error mentions JSON conversion or parsing
- Happens after successful HTTP response

**Cause:**
The JSON structure doesn't match your C# model, or the JSON is invalid.

**Solution:**

**Step 1: Look at the actual JSON**
```csharp
// Don't deserialize yet, just see the raw JSON
var response = await _httpClient.GetAsync(url);
string json = await response.Content.ReadAsStringAsync();
Console.WriteLine(json);
```

**Step 2: Validate your model matches the JSON**
```json
// API returns:
{
  "id": 1,
  "name": "Pikachu",
  "type": "Electric"
}
```

```csharp
// Your model should match:
public class Pokemon
{
    public int Id { get; set; }        // Matches "id"
    public string Name { get; set; }   // Matches "name"
    public string Type { get; set; }   // Matches "type"
}
```

**Step 3: Handle null values properly**
```csharp
// If API might return null
public string Name { get; set; } = string.Empty;  // Default value

// Or use nullable types
public string? Name { get; set; }  // Can be null
```

**Step 4: Use JsonPropertyName for mismatched names**
```csharp
// If JSON has "pokemon_name" but you want "Name" in C#
public class Pokemon
{
    [JsonPropertyName("pokemon_name")]
    public string Name { get; set; }
}
```

**Step 5: Check for array vs object mismatch**
```csharp
// If API returns an array but you expect object
var items = await response.Content.ReadFromJsonAsync<List<Pokemon>>();  // List, not single Pokemon

// If API returns object with data property
public class ApiResponse
{
    public List<Pokemon> Data { get; set; }  // Wrapper class
}
```

---

#### Problem 6: "HttpRequestException: The SSL connection could not be established"

**Symptoms:**
- Error about SSL/TLS
- Mentions certificate validation
- Happens immediately when connecting

**Cause:**
SSL certificate issue - either invalid certificate, self-signed certificate, or SSL/TLS protocol mismatch.

**Solution:**

**Step 1: Check if URL uses HTTPS**
```csharp
// Make sure you're using https://
"https://api.example.com"  // Not "http://"
```

**Step 2: For development with self-signed certificates**
```csharp
// ONLY FOR DEVELOPMENT! NEVER IN PRODUCTION!
var handler = new HttpClientHandler();
handler.ServerCertificateCustomValidationCallback =
    HttpClientHandler.DangerousAcceptAnyServerCertificateValidator;

var client = new HttpClient(handler);
```

**Step 3: For production, fix the certificate**
- Ensure server has valid SSL certificate
- Check certificate expiration date
- Verify certificate chain is complete

**Step 4: Update TLS protocol version**
```csharp
// Enable newer TLS versions
ServicePointManager.SecurityProtocol =
    SecurityProtocolType.Tls12 | SecurityProtocolType.Tls13;
```

---

### Error Messages Explained

| Error Message | Meaning | Solution |
|---------------|---------|----------|
| `No such host is known` | DNS can't resolve domain name | Check URL for typos, verify internet connection |
| `A task was canceled` | Request timed out | Increase timeout or investigate slow API |
| `401 Unauthorized` | Authentication failed | Check credentials and authorization headers |
| `403 Forbidden` | Authenticated but not permitted | Verify account has necessary permissions |
| `404 Not Found` | Resource doesn't exist | Check URL, verify resource ID exists |
| `415 Unsupported Media Type` | Wrong Content-Type header | Set `Content-Type: application/json` |
| `500 Internal Server Error` | Server-side error | Check server logs, may need to retry |
| `502 Bad Gateway` | Proxy/gateway error | Server or upstream service is down |
| `503 Service Unavailable` | Server temporarily down | Retry with exponential backoff |
| `JsonException` | Can't parse JSON | Verify model matches JSON structure |
| `SSL connection could not be established` | Certificate error | Check HTTPS URL, verify SSL certificate |

### Debugging Strategies

**Step-by-step debugging:**

1. **Check if you can reach the endpoint at all**
   ```bash
   curl https://api.example.com/health
   ```

2. **Verify the URL in your code matches what works**
   ```csharp
   Console.WriteLine($"Requesting: {url}");
   ```

3. **Look at the status code first**
   ```csharp
   Console.WriteLine($"Status: {response.StatusCode}");
   ```

4. **Read the response body even on errors**
   ```csharp
   string body = await response.Content.ReadAsStringAsync();
   Console.WriteLine($"Response: {body}");
   ```

5. **Check all request headers**
   ```csharp
   foreach (var header in _httpClient.DefaultRequestHeaders)
   {
       Console.WriteLine($"{header.Key}: {string.Join(", ", header.Value)}");
   }
   ```

6. **Compare with working request in Postman**
   - Export working request from Postman as cURL
   - Compare headers, body, URL with your code

**Useful debugging commands:**

```bash
# Test endpoint with cURL (verbose mode)
curl -v https://api.example.com/endpoint

# See just HTTP headers
curl -I https://api.example.com/endpoint

# Test with custom headers
curl -H "Authorization: Bearer token" https://api.example.com/endpoint

# Test POST with JSON
curl -X POST -H "Content-Type: application/json" \
  -d '{"key":"value"}' \
  https://api.example.com/endpoint
```

**Using Fiddler or similar proxy:**

```csharp
// Configure HttpClient to use Fiddler (runs on localhost:8888)
var handler = new HttpClientHandler
{
    Proxy = new WebProxy("http://localhost:8888"),
    UseProxy = true
};

var client = new HttpClient(handler);
```

This lets you see the exact HTTP traffic.

### Where to Get Help

- **Official .NET HTTP Documentation**: [docs.microsoft.com/dotnet/api/system.net.http](https://docs.microsoft.com/en-us/dotnet/api/system.net.http)
- **MDN HTTP Guide**: [developer.mozilla.org/docs/Web/HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP)
- **Stack Overflow Tag**: [`c#`] + [`httpclient`]
- **.NET Discord**: [discord.gg/dotnet](https://discord.gg/dotnet)
- **Reddit**: [r/dotnet](https://reddit.com/r/dotnet), [r/csharp](https://reddit.com/r/csharp)
- **GitHub Discussions**: [dotnet/runtime discussions](https://github.com/dotnet/runtime/discussions)

---

## 12. Additional Resources

### Official Documentation

- [HTTP - Mozilla Developer Network (MDN)](https://developer.mozilla.org/en-US/docs/Web/HTTP) - Comprehensive HTTP reference
- [System.Net.Http Namespace - Microsoft Docs](https://docs.microsoft.com/en-us/dotnet/api/system.net.http) - .NET HTTP client documentation
- [HttpClient Class - Microsoft Docs](https://docs.microsoft.com/en-us/dotnet/api/system.net.http.httpclient) - HttpClient API reference
- [IHttpClientFactory - Microsoft Docs](https://docs.microsoft.com/en-us/dotnet/core/extensions/httpclient-factory) - Best practices for HttpClient in .NET
- [RFC 7230 - HTTP/1.1 Message Syntax and Routing](https://tools.ietf.org/html/rfc7230) - Official HTTP specification (advanced)

### Recommended Tutorials

- [HTTP: The Definitive Guide (Book)](https://www.oreilly.com/library/view/http-the-definitive/1565925092/) - Deep dive into HTTP protocol
- [REST API Tutorial](https://restfulapi.net/) - Understanding RESTful API design principles
- [.NET HTTP Best Practices](https://docs.microsoft.com/en-us/dotnet/fundamentals/networking/http/httpclient-guidelines) - Microsoft's official guidelines

### Video Resources

- [HTTP Crash Course (Traversy Media)](https://www.youtube.com/watch?v=iYM2zFP3Zn0) - 38-minute introduction to HTTP
- [.NET HttpClient Best Practices (Nick Chapsas)](https://www.youtube.com/watch?v=Z6Y2adsMnAA) - Common HttpClient mistakes
- [REST API Concepts (CodeWithMosh)](https://www.youtube.com/watch?v=SLwpqD8n3d0) - REST API fundamentals

### Books

- **HTTP: The Definitive Guide** by David Gourley & Brian Totty - Comprehensive guide to HTTP protocol
- **RESTful Web APIs** by Leonard Richardson & Mike Amundsen - REST architectural style and best practices
- **C# 11 and .NET 7** by Mark J. Price - Includes chapters on HttpClient and web APIs

### Community Resources

- [JSONPlaceholder](https://jsonplaceholder.typicode.com/) - Free fake REST API for testing
- [PokéAPI](https://pokeapi.co/) - Free Pokemon API perfect for learning
- [HTTPBin](https://httpbin.org/) - HTTP request & response testing service
- [Reqres](https://reqres.in/) - Hosted REST API for testing
- [Postman Learning Center](https://learning.postman.com/) - API testing tutorials

### Related Technologies

- **WebSockets** - Real-time bidirectional communication (when HTTP request-response is too limiting)
- **gRPC** - High-performance RPC framework using HTTP/2 (alternative to REST for internal services)
- **SignalR** - Real-time web functionality for .NET (built on WebSockets/HTTP)
- **GraphQL** - Query language for APIs (alternative approach to REST)
- **OAuth 2.0** - Industry-standard protocol for authorization

### Tools

- **Postman** - [postman.com](https://www.postman.com/) - API testing and development
- **Insomnia** - [insomnia.rest](https://insomnia.rest/) - Alternative to Postman
- **Fiddler** - [telerik.com/fiddler](https://www.telerik.com/fiddler) - HTTP debugging proxy
- **REST Client (VS Code Extension)** - Test HTTP requests directly in VS Code
- **Swagger/OpenAPI** - [swagger.io](https://swagger.io/) - API documentation and testing

### Next Steps

After mastering HTTP fundamentals covered in this guide, consider learning:

1. **RESTful API Design** - Learn to design clean, intuitive APIs following REST principles. This builds directly on HTTP knowledge and is essential for backend development.

2. **ASP.NET Core Web API** - Build your own APIs using .NET. You'll apply everything you learned about HTTP methods, status codes, and headers.

3. **Authentication & Authorization** - Learn OAuth 2.0, JWT tokens, and identity management. Understanding HTTP is prerequisite for these concepts.

4. **API Security** - Learn about CORS, rate limiting, API keys, and security best practices. Critical for production APIs.

5. **Advanced Topics**:
   - HTTP/2 and HTTP/3 features
   - WebSockets for real-time communication
   - GraphQL as an alternative to REST
   - API versioning strategies
   - Performance optimization and caching

---

## Appendix

### Glossary

**API (Application Programming Interface)**: A set of rules and protocols for how software components should interact. Web APIs use HTTP.

**Authentication**: The process of verifying who you are (proving your identity).

**Authorization**: The process of verifying what you're allowed to do (checking permissions).

**Body**: The data payload of an HTTP request or response (optional).

**Cache**: Temporary storage of responses to avoid repeated requests for the same data.

**Client**: The software making HTTP requests (browser, mobile app, HttpClient).

**Content-Type**: HTTP header specifying the format of the data in the body (e.g., `application/json`).

**Cookie**: Small piece of data sent by server and stored by client, automatically included in future requests.

**CORS (Cross-Origin Resource Sharing)**: Security mechanism that allows web pages to request resources from different domains.

**DNS (Domain Name System)**: System that translates domain names (example.com) to IP addresses (93.184.216.34).

**Endpoint**: A specific URL path on a server that handles requests (e.g., `/api/pokemon`).

**Header**: Key-value pair providing metadata about an HTTP request or response.

**HTTP (HyperText Transfer Protocol)**: The protocol used for transferring data on the web.

**HTTPS (HTTP Secure)**: HTTP with encryption using SSL/TLS.

**Idempotent**: An operation that produces the same result no matter how many times it's repeated. GET, PUT, DELETE are idempotent; POST is not.

**JSON (JavaScript Object Notation)**: Lightweight data format commonly used in APIs. Example: `{"name": "Pikachu"}`.

**JWT (JSON Web Token)**: Compact token format used for authentication, encoded in base64.

**Method/Verb**: The action to perform (GET, POST, PUT, PATCH, DELETE).

**Payload**: The data being sent in the body of a request or response.

**Query Parameter**: Key-value pairs appended to URL after `?` for filtering or options. Example: `?type=fire&limit=10`.

**Request**: Message sent from client to server asking for something.

**Response**: Message sent from server to client with the result.

**REST (Representational State Transfer)**: Architectural style for designing web APIs using HTTP methods and resource-based URLs.

**Route Parameter**: Variable part of URL path identifying a specific resource. Example: `/pokemon/25` where `25` is the route parameter.

**Server**: The software receiving and processing HTTP requests.

**SSL/TLS**: Encryption protocols that make HTTP secure (HTTPS).

**Status Code**: Three-digit number indicating the result of an HTTP request (200, 404, 500, etc.).

**Stateless**: Each request is independent with no memory of previous requests (how HTTP works).

**Token**: A string used for authentication, included in requests to prove identity.

**URL (Uniform Resource Locator)**: The address of a resource on the web. Example: `https://api.example.com/pokemon/25`.

**Verb**: Another name for HTTP method (GET, POST, etc.).

**WebSocket**: Protocol for persistent bidirectional communication (unlike HTTP's request-response model).

### HTTP Status Code Reference

**1xx - Informational**
- `100 Continue` - Client should continue with request
- `101 Switching Protocols` - Switching to WebSocket, for example

**2xx - Success**
- `200 OK` - Request succeeded (most common success code)
- `201 Created` - New resource was created (after POST)
- `202 Accepted` - Request accepted but not yet processed
- `204 No Content` - Success but no content to return (common after DELETE)

**3xx - Redirection**
- `301 Moved Permanently` - Resource permanently moved to new URL
- `302 Found` - Resource temporarily at different URL
- `304 Not Modified` - Cached version is still valid (for performance)
- `307 Temporary Redirect` - Temporary redirect, keep same HTTP method

**4xx - Client Errors**
- `400 Bad Request` - Malformed request (syntax error, invalid JSON)
- `401 Unauthorized` - Authentication required or failed
- `403 Forbidden` - Authenticated but not authorized (no permission)
- `404 Not Found` - Resource doesn't exist
- `405 Method Not Allowed` - GET used on endpoint that only accepts POST, etc.
- `409 Conflict` - Request conflicts with current state (e.g., duplicate resource)
- `415 Unsupported Media Type` - Wrong Content-Type header
- `422 Unprocessable Entity` - Valid syntax but semantic errors (validation failed)
- `429 Too Many Requests` - Rate limit exceeded

**5xx - Server Errors**
- `500 Internal Server Error` - Generic server error
- `501 Not Implemented` - Server doesn't support this functionality
- `502 Bad Gateway` - Invalid response from upstream server
- `503 Service Unavailable` - Server temporarily unavailable (maintenance, overload)
- `504 Gateway Timeout` - Upstream server didn't respond in time

### HTTP Methods Reference

| Method | Purpose | Has Body? | Safe?* | Idempotent?** | Cache? |
|--------|---------|-----------|--------|---------------|--------|
| **GET** | Retrieve resource | No | Yes | Yes | Yes |
| **POST** | Create new resource | Yes | No | No | No |
| **PUT** | Replace entire resource | Yes | No | Yes | No |
| **PATCH** | Partially update resource | Yes | No | No*** | No |
| **DELETE** | Remove resource | Usually no | No | Yes | No |
| **HEAD** | Get headers only (no body) | No | Yes | Yes | Yes |
| **OPTIONS** | Get allowed methods for resource | No | Yes | Yes | No |

*Safe = Doesn't modify data
**Idempotent = Same result if repeated
***PATCH can be idempotent depending on implementation

**Examples:**

```http
GET /api/pokemon/25        # Get Pokemon #25 (safe, idempotent, cacheable)
POST /api/pokemon          # Create new Pokemon (not idempotent - creates new each time)
PUT /api/pokemon/25        # Replace Pokemon #25 (idempotent - same result if repeated)
PATCH /api/pokemon/25      # Update specific fields of Pokemon #25
DELETE /api/pokemon/25     # Delete Pokemon #25 (idempotent - still deleted if repeated)
HEAD /api/pokemon/25       # Get just headers (check if exists without downloading body)
OPTIONS /api/pokemon       # Find out what methods are allowed
```

### Common HTTP Headers Reference

**Request Headers:**

```http
# Content negotiation
Accept: application/json                          # What format client wants
Accept-Language: en-US,en;q=0.9                  # Preferred languages
Accept-Encoding: gzip, deflate, br               # Compression methods supported

# Authentication
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Authorization: Basic base64(username:password)
X-API-Key: your-api-key-here

# Content info
Content-Type: application/json                   # Format of body you're sending
Content-Length: 348                              # Size of body in bytes

# Client info
User-Agent: Mozilla/5.0 (Windows NT 10.0...)    # What client is making request
Referer: https://example.com/previous-page      # Where request came from

# Caching
If-None-Match: "686897696a7c876b7e"             # ETag from previous response
If-Modified-Since: Wed, 21 Oct 2024 07:28:00 GMT

# Custom headers
X-Request-ID: 123e4567-e89b-12d3-a456-426614174000  # Tracking ID
X-Correlation-ID: abc-123-def-456                   # For distributed tracing
```

**Response Headers:**

```http
# Content info
Content-Type: application/json; charset=utf-8   # Format of body
Content-Length: 1234                             # Size in bytes
Content-Encoding: gzip                           # Compression used

# Caching
Cache-Control: no-cache                          # Caching rules
Cache-Control: max-age=3600                      # Cache for 1 hour
ETag: "686897696a7c876b7e"                      # Unique identifier for this version
Expires: Wed, 21 Oct 2024 07:28:00 GMT         # When to expire cache

# Security
Strict-Transport-Security: max-age=31536000     # Always use HTTPS
X-Content-Type-Options: nosniff                 # Don't guess content type
X-Frame-Options: DENY                           # Don't allow in iframes

# CORS
Access-Control-Allow-Origin: *                  # Allow any origin
Access-Control-Allow-Methods: GET, POST, PUT    # Allowed methods
Access-Control-Allow-Headers: Content-Type      # Allowed headers

# Cookies
Set-Cookie: sessionId=abc123; Path=/; HttpOnly; Secure

# Rate limiting
X-RateLimit-Limit: 100                          # Max requests
X-RateLimit-Remaining: 95                       # Requests left
X-RateLimit-Reset: 1699632000                   # When limit resets (Unix time)

# Server info
Server: nginx/1.18.0                            # Server software
Date: Wed, 22 Nov 2024 10:30:00 GMT            # Response timestamp
```

### Quick Reference - HttpClient in C#

**Basic GET:**
```csharp
var response = await httpClient.GetAsync("https://api.example.com/data");
string content = await response.Content.ReadAsStringAsync();
```

**GET with JSON deserialization:**
```csharp
var pokemon = await httpClient.GetFromJsonAsync<Pokemon>("https://api.example.com/pokemon/25");
```

**POST with JSON:**
```csharp
var newPokemon = new Pokemon { Name = "Pikachu", Type = "Electric" };
var response = await httpClient.PostAsJsonAsync("https://api.example.com/pokemon", newPokemon);
```

**PUT:**
```csharp
await httpClient.PutAsJsonAsync("https://api.example.com/pokemon/25", updatedPokemon);
```

**DELETE:**
```csharp
await httpClient.DeleteAsync("https://api.example.com/pokemon/25");
```

**With headers:**
```csharp
httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
httpClient.DefaultRequestHeaders.Add("X-Custom-Header", "value");
```

**Check status:**
```csharp
if (response.IsSuccessStatusCode)
{
    // Success (2xx)
}
else if (response.StatusCode == HttpStatusCode.NotFound)
{
    // 404
}
```

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-11-22 | Initial version - Complete HTTP Protocol Fundamentals documentation |

---

**Estimated Reading Time**: 35-40 minutes

**Prerequisites**: Basic programming knowledge

**What's Next**: After completing this guide, proceed to [REST API Design Principles](rest-api-design.md) and [ASP.NET Core Web API Basics](aspnet-core-webapi-basics.md).
