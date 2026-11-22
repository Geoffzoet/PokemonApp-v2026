# REST API Principles

---
**Technology Version**: REST Architectural Style
**Document Version**: 1.0
**Last Updated**: 2026-11-22
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
**Estimated Reading Time**: 30-45 minutes
---

## 1. Overview & Introduction

### What is REST?

REST stands for **Representational State Transfer**. It's an architectural style for designing networked applications, particularly web services. REST was introduced by Roy Fielding in his 2000 doctoral dissertation and has since become the dominant approach for building web APIs.

Think of REST as a set of guidelines for how computers should talk to each other over the internet. Just like humans follow social rules when communicating (saying "hello," taking turns speaking), REST provides rules that make it easier for different software systems to communicate reliably and efficiently.

When we say an API is "RESTful," we mean it follows REST principles. A RESTful API uses standard HTTP methods and focuses on resources (things like users, products, or in our case, Pokemon) rather than actions.

### Why Use REST?

REST has become the standard for web APIs because it solves several important problems:

You should use REST when:
- **Building web APIs that need to be simple and intuitive** - REST uses familiar HTTP methods (GET, POST, PUT, DELETE) that map naturally to Create, Read, Update, Delete (CRUD) operations
- **You want your API to be easy for other developers to understand** - RESTful URLs are readable and self-descriptive (e.g., `/api/pokemon/25` clearly refers to Pokemon with ID 25)
- **Scalability matters** - REST's stateless nature means each request is independent, making it easier to scale horizontally across multiple servers
- **You need to support multiple clients** - REST works with web browsers, mobile apps, desktop applications, and IoT devices
- **You want to leverage existing web infrastructure** - REST uses standard HTTP, so it works with existing caches, load balancers, and security mechanisms

### When to Use It

**Good use cases:**
- Public-facing APIs that third-party developers will use (like Twitter API, GitHub API, Stripe API)
- Mobile applications that need to communicate with a backend server
- Microservices architectures where services need to communicate over HTTP
- Web applications where the frontend and backend are separate (Single Page Applications)
- APIs that expose CRUD operations on resources (users, products, orders, etc.)
- Systems where caching can significantly improve performance

**Not recommended for:**
- Real-time applications requiring persistent connections (use WebSockets instead)
- Operations that don't map well to resources (complex business workflows might need RPC-style APIs)
- Internal systems where both sides are tightly coupled (might be overkill)
- Systems requiring strict transactional integrity across multiple operations (consider GraphQL or traditional RPC)
- Applications requiring complex queries with many filtering options (GraphQL might be better)

---

## 2. Quick Start

**TL;DR - Understanding REST in 5 minutes:**

REST is about treating everything as a **resource** that can be accessed via a unique URL.

**Key principles:**
```
1. Resources: Everything is a resource (users, products, pokemon)
2. URLs identify resources: /api/pokemon/25
3. HTTP methods define actions:
   - GET: Retrieve data
   - POST: Create new data
   - PUT: Update existing data
   - DELETE: Remove data
4. Stateless: Each request is independent
5. Standard formats: Usually JSON for data exchange
```

**Example RESTful API:**
```http
GET    /api/pokemon         # Get all Pokemon
GET    /api/pokemon/25      # Get Pokemon with ID 25
POST   /api/pokemon         # Create a new Pokemon
PUT    /api/pokemon/25      # Update Pokemon with ID 25
DELETE /api/pokemon/25      # Delete Pokemon with ID 25
```

**Example request and response:**
```http
GET /api/pokemon/25 HTTP/1.1
Host: example.com
Accept: application/json

HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric",
  "level": 50
}
```

For detailed explanations, continue reading the sections below.

---

## 3. Prerequisites

### Required Knowledge

Before diving into REST API principles, you should be familiar with:

- **HTTP Protocol Fundamentals** - Understanding of HTTP requests, responses, methods, status codes, and headers. If you haven't reviewed this yet, please read the [HTTP Protocol Fundamentals](./http-protocol-fundamentals.md) guide first (POK-7).
- **Basic Programming Concepts** - Variables, data structures (objects/arrays), and functions. Any programming language is fine.
- **JSON Format** - Understanding of JSON syntax since most RESTful APIs use JSON for data exchange. You should know what `{"key": "value"}` means.
- **Web Basics** - Understanding of URLs, how the web works, and client-server architecture at a high level.

### Required Software/Tools

To follow along with the examples and exercises, you'll need:

- **A Web Browser** - Any modern browser (Chrome, Firefox, Safari, Edge)
  - Used to understand how REST APIs work and to test some examples

- **A REST Client Tool** - One of the following:
  - **Postman** (Recommended for beginners) - Free, user-friendly GUI for testing APIs
    - Download: https://www.postman.com/downloads/
  - **curl** - Command-line tool, usually pre-installed on macOS/Linux
    - Windows installation: https://curl.se/windows/
  - **REST Client Extension for VS Code** - If you use Visual Studio Code

- **A Text Editor or IDE** - For viewing and editing code examples
  - Visual Studio Code, Visual Studio, Rider, or any text editor

### System Requirements

REST is an architectural style, not software you install, so there are no specific system requirements. However, to test REST APIs:

- **Operating System**: Windows 10+, macOS 10.15+, or any modern Linux distribution
- **Internet Connection**: Required to access example APIs and documentation
- **RAM**: 4GB minimum for running API testing tools
- **Disk Space**: 500MB for installing tools like Postman

---

## 4. Core Concepts & Theory

### Key Concepts

#### Concept 1: Resources

In REST, everything is a **resource**. A resource is any piece of information that can be named: a document, an image, a user, a Pokemon, a collection of items, etc.

Think of resources like nouns in a sentence. Instead of focusing on verbs (actions), REST focuses on the things themselves. Each resource should:
- Have a unique identifier (URI/URL)
- Be representable in one or more formats (usually JSON or XML)
- Support one or more operations (via HTTP methods)

**Example:**
```
Resources in a Pokemon application:
- A single Pokemon: /api/pokemon/25
- Collection of Pokemon: /api/pokemon
- A Pokemon's moves: /api/pokemon/25/moves
- A specific move: /api/pokemon/25/moves/thunderbolt
- A trainer: /api/trainers/ash
- A trainer's Pokemon: /api/trainers/ash/pokemon
```

The key insight: We identify **what** we're working with (the resource) separately from **what we do with it** (the HTTP method).

#### Concept 2: Representations

A **representation** is a specific format or view of a resource at a particular point in time. The same resource can have multiple representations.

When a client requests a resource, the server sends back a representation of that resource's current state. This is typically JSON, but could be XML, HTML, or other formats.

**Example:**
```json
// JSON representation of a Pokemon resource
{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric",
  "baseStats": {
    "hp": 35,
    "attack": 55,
    "defense": 40
  },
  "abilities": ["Static", "Lightning Rod"]
}
```

The same Pokemon resource could have different representations:
- JSON for APIs
- HTML for web browsers
- XML for legacy systems
- CSV for data export

#### Concept 3: Statelessness

**Stateless** means that each request from a client to a server must contain all the information needed to understand and process the request. The server doesn't store any client context between requests.

This is like ordering at a fast-food restaurant where you have to give your complete order every time, rather than saying "I'll have the usual."

**Why statelessness matters:**
- **Scalability**: Any server can handle any request since there's no session state to maintain
- **Reliability**: If a server crashes, clients can retry requests on another server
- **Simplicity**: Servers don't need to manage complex session state

**Example:**
```http
// BAD: Stateful (depends on previous requests)
POST /api/setuser
{ "userId": 123 }

GET /api/getpokemon  // Which user? Server must remember from previous request

// GOOD: Stateless (each request is complete)
GET /api/users/123/pokemon
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### Concept 4: Uniform Interface

The **uniform interface** is REST's most distinctive feature. It means that all resources are accessed and manipulated in the same, standardized way using HTTP methods.

The four main constraints of the uniform interface:
1. **Identification of resources** - Resources are identified by URIs
2. **Manipulation through representations** - Clients manipulate resources via representations (JSON, XML, etc.)
3. **Self-descriptive messages** - Each message contains enough info to describe how to process it
4. **HATEOAS** - Hypermedia as the Engine of Application State (explained below)

**Example of uniform interface:**
```http
// Same pattern works for ANY resource type
GET    /api/pokemon/25     # Get a Pokemon
GET    /api/trainers/ash   # Get a trainer
GET    /api/items/potion   # Get an item

// Same HTTP methods for all resources
POST   /api/pokemon        # Create a Pokemon
POST   /api/trainers       # Create a trainer
POST   /api/items          # Create an item
```

#### Concept 5: HTTP Methods (Verbs)

REST leverages standard HTTP methods to perform operations on resources:

| HTTP Method | CRUD Operation | Idempotent* | Safe** | Purpose |
|-------------|----------------|-------------|--------|---------|
| **GET** | Read | Yes | Yes | Retrieve a resource |
| **POST** | Create | No | No | Create a new resource |
| **PUT** | Update | Yes | No | Update/replace a resource |
| **PATCH** | Update | No | No | Partially update a resource |
| **DELETE** | Delete | Yes | No | Remove a resource |

*Idempotent: Making the same request multiple times has the same effect as making it once
**Safe: Doesn't modify the resource

**Example:**
```http
# GET - Retrieve a Pokemon (safe and idempotent)
GET /api/pokemon/25
Response: { "id": 25, "name": "Pikachu", "type": "Electric" }

# POST - Create a new Pokemon (not idempotent)
POST /api/pokemon
Body: { "name": "Charmander", "type": "Fire" }
Response: { "id": 4, "name": "Charmander", "type": "Fire" }

# PUT - Update entire Pokemon (idempotent)
PUT /api/pokemon/4
Body: { "name": "Charmander", "type": "Fire", "level": 10 }
Response: { "id": 4, "name": "Charmander", "type": "Fire", "level": 10 }

# PATCH - Update part of Pokemon (not always idempotent)
PATCH /api/pokemon/4
Body: { "level": 11 }
Response: { "id": 4, "name": "Charmander", "type": "Fire", "level": 11 }

# DELETE - Remove a Pokemon (idempotent)
DELETE /api/pokemon/4
Response: 204 No Content
```

#### Concept 6: HATEOAS (Hypermedia as the Engine of Application State)

**HATEOAS** is the principle that a REST API should provide links to related resources in its responses, allowing clients to discover available actions dynamically.

Think of it like a website: you don't need to memorize every URL because pages contain links to other pages. Similarly, API responses should include links to related resources.

**Example without HATEOAS:**
```json
GET /api/pokemon/25
{
  "id": 25,
  "name": "Pikachu",
  "trainerId": 1
}
// Client must know to construct: /api/trainers/1
```

**Example with HATEOAS:**
```json
GET /api/pokemon/25
{
  "id": 25,
  "name": "Pikachu",
  "trainerId": 1,
  "links": {
    "self": "/api/pokemon/25",
    "trainer": "/api/trainers/1",
    "moves": "/api/pokemon/25/moves",
    "evolve": "/api/pokemon/25/evolve"
  }
}
// Client discovers available actions from the response
```

**Note:** HATEOAS is the most advanced REST constraint and is often skipped in practical implementations. Many APIs that call themselves RESTful don't fully implement HATEOAS.

### Important Terminology

| Term | Definition |
|------|------------|
| **REST** | Representational State Transfer - an architectural style for distributed systems |
| **Resource** | Any information that can be named (users, documents, images, etc.) |
| **URI** | Uniform Resource Identifier - a string that identifies a resource |
| **Endpoint** | A specific URI where a resource can be accessed |
| **Representation** | A specific format/state of a resource (JSON, XML, etc.) |
| **Stateless** | Each request is independent and contains all necessary information |
| **Idempotent** | An operation that produces the same result no matter how many times it's performed |
| **Safe Method** | An HTTP method that doesn't modify resources (GET, HEAD, OPTIONS) |
| **CRUD** | Create, Read, Update, Delete - basic operations on data |
| **HATEOAS** | Hypermedia as the Engine of Application State - providing links in responses |
| **HTTP Method** | The action to perform on a resource (GET, POST, PUT, DELETE, etc.) |
| **Status Code** | A 3-digit code indicating the result of an HTTP request (200, 404, 500, etc.) |
| **Content Negotiation** | Process of selecting the best representation for a response |
| **API** | Application Programming Interface - how software components communicate |
| **RESTful** | An API that follows REST architectural principles |

### REST Architectural Constraints

Roy Fielding defined six architectural constraints that define a RESTful system:

#### 1. Client-Server Architecture
Separates user interface concerns from data storage concerns. This improves portability and scalability.

```
┌─────────┐                    ┌─────────┐
│ Client  │ ◄──── HTTP ─────► │ Server  │
│ (UI)    │                    │ (Data)  │
└─────────┘                    └─────────┘
```

#### 2. Stateless
Each request from client to server must contain all information needed. Server stores no client context.

#### 3. Cacheable
Responses must define themselves as cacheable or non-cacheable to prevent clients from reusing stale data.

```http
HTTP/1.1 200 OK
Cache-Control: max-age=3600
ETag: "abc123"
```

#### 4. Uniform Interface
Standardized way to interact with resources (URIs, HTTP methods, representations).

#### 5. Layered System
Client cannot tell if connected directly to end server or intermediary (load balancers, caches, etc.).

```
Client → CDN → Load Balancer → API Gateway → Server
```

#### 6. Code-on-Demand (Optional)
Servers can extend client functionality by transferring executable code (JavaScript, applets). This constraint is optional.

### Architecture Overview

A typical RESTful API architecture:

```
┌──────────────────────────────────────────────────────────────┐
│                         Client Layer                          │
│  (Web Browser, Mobile App, Desktop App, IoT Device, etc.)    │
└───────────────────┬──────────────────────────────────────────┘
                    │
                    │ HTTP/HTTPS Requests
                    │ (GET, POST, PUT, DELETE)
                    │
┌───────────────────▼──────────────────────────────────────────┐
│                      API Gateway / Load Balancer              │
│            (Routing, Rate Limiting, Authentication)           │
└───────────────────┬──────────────────────────────────────────┘
                    │
┌───────────────────▼──────────────────────────────────────────┐
│                     RESTful API Server                        │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │              Controllers / Endpoints                    │  │
│  │  GET /api/pokemon, POST /api/pokemon, etc.             │  │
│  └───────────────────┬────────────────────────────────────┘  │
│                      │                                        │
│  ┌───────────────────▼────────────────────────────────────┐  │
│  │              Business Logic Layer                       │  │
│  │  (Services, Validation, Authorization)                  │  │
│  └───────────────────┬────────────────────────────────────┘  │
│                      │                                        │
│  ┌───────────────────▼────────────────────────────────────┐  │
│  │              Data Access Layer                          │  │
│  │  (Repository Pattern, ORM)                              │  │
│  └───────────────────┬────────────────────────────────────┘  │
└────────────────────┬─┴────────────────────────────────────────┘
                     │
┌────────────────────▼─────────────────────────────────────────┐
│                      Database                                 │
│         (PostgreSQL, MySQL, MongoDB, etc.)                    │
└──────────────────────────────────────────────────────────────┘
```

---

## 5. Installation Guide

**Note:** REST is an architectural style, not a tool or library you install. There's no "REST software" to download.

However, to build RESTful APIs, you'll use existing frameworks and tools:

### For .NET Development (This Course)

We'll use ASP.NET Core Web API, which is included with .NET:

**Installation:**
```bash
# Check if .NET is installed
dotnet --version

# If not installed, download from:
# https://dotnet.microsoft.com/download
```

**Create a new Web API project:**
```bash
dotnet new webapi -n MyRestfulApi
cd MyRestfulApi
dotnet run
```

This creates a RESTful API project following REST principles by default.

### For Other Languages

REST APIs can be built in any language:

- **Node.js**: Express.js, Fastify, NestJS
- **Python**: Flask, Django REST Framework, FastAPI
- **Java**: Spring Boot, JAX-RS
- **Ruby**: Ruby on Rails, Sinatra
- **Go**: Gin, Echo
- **PHP**: Laravel, Symfony

### Testing Tools

**Postman (Recommended):**
```bash
# Download from: https://www.postman.com/downloads/
# Or install via package managers:

# macOS
brew install --cask postman

# Windows (Chocolatey)
choco install postman

# Linux (Snap)
snap install postman
```

**curl (Command-line):**
```bash
# Usually pre-installed on macOS/Linux
# For Windows, download from: https://curl.se/windows/

# Verify installation
curl --version
```

---

## 6. Initial Setup & Configuration

**Note:** Since REST is an architectural style, there's no specific "configuration" for REST itself. Instead, this section covers how to think about designing a RESTful API.

### Design Principles for Your First REST API

When designing a RESTful API, follow these steps:

**Step 1: Identify Your Resources**

List the main entities (nouns) in your application:
```
Example for Pokemon App:
- Pokemon
- Trainers
- Moves
- Items
- Battles
```

**Step 2: Design Resource URIs**

Create clean, hierarchical URIs for each resource:
```
# Collections (plural nouns)
/api/pokemon
/api/trainers
/api/moves

# Individual resources (by ID)
/api/pokemon/25
/api/trainers/ash

# Nested resources (relationships)
/api/trainers/ash/pokemon
/api/pokemon/25/moves
```

**Step 3: Map HTTP Methods to Operations**

Decide what operations each resource supports:
```
Pokemon Resource:
- GET /api/pokemon       → List all Pokemon
- GET /api/pokemon/25    → Get specific Pokemon
- POST /api/pokemon      → Create new Pokemon
- PUT /api/pokemon/25    → Update Pokemon
- DELETE /api/pokemon/25 → Delete Pokemon
```

**Step 4: Define Response Formats**

Choose consistent JSON structure:
```json
// Single resource
{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric"
}

// Collection
{
  "data": [
    { "id": 25, "name": "Pikachu" },
    { "id": 1, "name": "Bulbasaur" }
  ],
  "total": 150,
  "page": 1,
  "pageSize": 20
}

// Error response
{
  "error": {
    "code": "POKEMON_NOT_FOUND",
    "message": "Pokemon with ID 999 does not exist",
    "statusCode": 404
  }
}
```

**Step 5: Plan Status Codes**

| Scenario | Status Code | Meaning |
|----------|-------------|---------|
| Successfully retrieved resource | 200 OK | Request succeeded |
| Successfully created resource | 201 Created | Resource created |
| Successfully updated resource | 200 OK | Resource updated |
| Successfully deleted resource | 204 No Content | Resource deleted, no content to return |
| Client sent invalid data | 400 Bad Request | Validation failed |
| Authentication required | 401 Unauthorized | Not authenticated |
| Insufficient permissions | 403 Forbidden | Authenticated but not authorized |
| Resource not found | 404 Not Found | Resource doesn't exist |
| Server error | 500 Internal Server Error | Server encountered an error |

### Essential REST API Design Decisions

Before implementing, decide on:

**1. API Versioning Strategy**
```
# Option 1: URL versioning (most common)
/api/v1/pokemon
/api/v2/pokemon

# Option 2: Header versioning
GET /api/pokemon
Accept: application/vnd.myapi.v1+json

# Option 3: Query parameter
/api/pokemon?version=1
```

**2. Pagination Strategy**
```
# Offset-based (most common)
GET /api/pokemon?page=1&pageSize=20

# Cursor-based (better for large datasets)
GET /api/pokemon?cursor=abc123&limit=20
```

**3. Filtering and Sorting**
```
# Filtering
GET /api/pokemon?type=Electric&level=50

# Sorting
GET /api/pokemon?sortBy=name&order=asc

# Combined
GET /api/pokemon?type=Electric&sortBy=level&order=desc&page=1&pageSize=10
```

**4. Authentication Method**
```
# JWT (JSON Web Tokens) - Most common for modern APIs
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# API Keys - Simple, good for public APIs
X-API-Key: abc123def456

# OAuth 2.0 - Best for third-party access
Authorization: Bearer [OAuth2 access token]
```

---

## 7. Basic Usage

### Understanding RESTful URLs

RESTful URLs should be intuitive and follow predictable patterns. Think of them like filing folders:

```
/api/pokemon              → Folder with all Pokemon
/api/pokemon/25           → Specific Pokemon (Pikachu)
/api/pokemon/25/moves     → Pikachu's moves
/api/trainers             → All trainers
/api/trainers/ash         → Specific trainer
/api/trainers/ash/pokemon → Ash's Pokemon collection
```

**Key principles for URL design:**
- Use nouns, not verbs (`/api/pokemon` not `/api/getPokemon`)
- Use plural nouns for collections (`/api/pokemon` not `/api/pokemon1`)
- Use hyphens for multi-word resources (`/api/pokemon-types` not `/api/pokemonTypes`)
- Keep URLs lowercase
- Avoid deep nesting (maximum 2-3 levels)

### Basic REST Operations Examples

#### Example 1: Retrieving Data (GET)

**Get all Pokemon:**
```http
GET /api/pokemon HTTP/1.1
Host: api.pokemon.com
Accept: application/json
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "data": [
    { "id": 1, "name": "Bulbasaur", "type": "Grass/Poison" },
    { "id": 25, "name": "Pikachu", "type": "Electric" },
    { "id": 4, "name": "Charmander", "type": "Fire" }
  ],
  "total": 150
}
```

**Get a specific Pokemon:**
```http
GET /api/pokemon/25 HTTP/1.1
Host: api.pokemon.com
Accept: application/json
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric",
  "baseStats": {
    "hp": 35,
    "attack": 55,
    "defense": 40,
    "speed": 90
  },
  "abilities": ["Static", "Lightning Rod"],
  "evolutionLevel": 1
}
```

#### Example 2: Creating Data (POST)

**Create a new Pokemon:**
```http
POST /api/pokemon HTTP/1.1
Host: api.pokemon.com
Content-Type: application/json
Accept: application/json

{
  "name": "Charmander",
  "type": "Fire",
  "baseStats": {
    "hp": 39,
    "attack": 52,
    "defense": 43
  }
}
```

**Response:**
```http
HTTP/1.1 201 Created
Location: /api/pokemon/4
Content-Type: application/json

{
  "id": 4,
  "name": "Charmander",
  "type": "Fire",
  "baseStats": {
    "hp": 39,
    "attack": 52,
    "defense": 43
  },
  "createdAt": "2026-11-22T10:30:00Z"
}
```

**What's happening here:**
1. Client sends POST request with new Pokemon data
2. Server creates the Pokemon and assigns it ID 4
3. Server responds with 201 Created status
4. Response includes `Location` header pointing to new resource
5. Response body contains the created Pokemon with its ID

#### Example 3: Updating Data (PUT)

**Update entire Pokemon (replace):**
```http
PUT /api/pokemon/4 HTTP/1.1
Host: api.pokemon.com
Content-Type: application/json

{
  "name": "Charmander",
  "type": "Fire",
  "level": 16,
  "baseStats": {
    "hp": 39,
    "attack": 52,
    "defense": 43
  }
}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 4,
  "name": "Charmander",
  "type": "Fire",
  "level": 16,
  "baseStats": {
    "hp": 39,
    "attack": 52,
    "defense": 43
  },
  "updatedAt": "2026-11-22T11:00:00Z"
}
```

**Update partial data (PATCH):**
```http
PATCH /api/pokemon/4 HTTP/1.1
Host: api.pokemon.com
Content-Type: application/json

{
  "level": 16
}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 4,
  "name": "Charmander",
  "type": "Fire",
  "level": 16,
  "baseStats": {
    "hp": 39,
    "attack": 52,
    "defense": 43
  },
  "updatedAt": "2026-11-22T11:05:00Z"
}
```

**Difference between PUT and PATCH:**
- **PUT**: Replaces the entire resource (send all fields)
- **PATCH**: Updates only specified fields (send only changed fields)

#### Example 4: Deleting Data (DELETE)

**Delete a Pokemon:**
```http
DELETE /api/pokemon/4 HTTP/1.1
Host: api.pokemon.com
```

**Response:**
```http
HTTP/1.1 204 No Content
```

**What's happening:**
- 204 No Content means deletion was successful
- No response body needed (resource is gone)

**If Pokemon doesn't exist:**
```http
HTTP/1.1 404 Not Found
Content-Type: application/json

{
  "error": {
    "code": "POKEMON_NOT_FOUND",
    "message": "Pokemon with ID 4 does not exist"
  }
}
```

### Common Use Cases

#### Use Case 1: Filtering Collections

**Get all Electric-type Pokemon:**
```http
GET /api/pokemon?type=Electric HTTP/1.1
```

**Response:**
```json
{
  "data": [
    { "id": 25, "name": "Pikachu", "type": "Electric" },
    { "id": 26, "name": "Raichu", "type": "Electric" },
    { "id": 100, "name": "Voltorb", "type": "Electric" }
  ],
  "total": 3,
  "filters": { "type": "Electric" }
}
```

#### Use Case 2: Sorting

**Get Pokemon sorted by level:**
```http
GET /api/pokemon?sortBy=level&order=desc HTTP/1.1
```

#### Use Case 3: Pagination

**Get page 2 of Pokemon (20 per page):**
```http
GET /api/pokemon?page=2&pageSize=20 HTTP/1.1
```

**Response:**
```json
{
  "data": [ /* Pokemon 21-40 */ ],
  "page": 2,
  "pageSize": 20,
  "total": 150,
  "totalPages": 8,
  "links": {
    "first": "/api/pokemon?page=1&pageSize=20",
    "prev": "/api/pokemon?page=1&pageSize=20",
    "self": "/api/pokemon?page=2&pageSize=20",
    "next": "/api/pokemon?page=3&pageSize=20",
    "last": "/api/pokemon?page=8&pageSize=20"
  }
}
```

#### Use Case 4: Nested Resources

**Get all Pokemon owned by a specific trainer:**
```http
GET /api/trainers/ash/pokemon HTTP/1.1
```

**Response:**
```json
{
  "trainer": {
    "id": "ash",
    "name": "Ash Ketchum"
  },
  "pokemon": [
    { "id": 25, "name": "Pikachu", "level": 50 },
    { "id": 94, "name": "Gengar", "level": 45 }
  ]
}
```

---

## 8. Testing & Validation

### How to Test Your REST API

#### Method 1: Using Postman (Recommended for Beginners)

**Step 1: Open Postman and create a new request**

1. Click "New" → "HTTP Request"
2. Select the HTTP method (GET, POST, etc.)
3. Enter the URL: `https://pokeapi.co/api/v2/pokemon/25`
4. Click "Send"

**Step 2: View the response**
- Status code (should be 200 OK)
- Response body (JSON data)
- Response time
- Response headers

**Step 3: Save your requests**
- Create a "Collection" for related requests
- Save each request with a descriptive name
- Add tests to verify responses

**Expected behavior:**
- Status code 200 for successful GET requests
- JSON response with Pokemon data
- Response time under 500ms (usually)

#### Method 2: Using curl (Command-line)

**Testing GET requests:**
```bash
# Get all Pokemon
curl https://pokeapi.co/api/v2/pokemon

# Get specific Pokemon
curl https://pokeapi.co/api/v2/pokemon/25

# Get with verbose output (shows headers)
curl -v https://pokeapi.co/api/v2/pokemon/25

# Save response to file
curl https://pokeapi.co/api/v2/pokemon/25 > pikachu.json
```

**Testing POST requests:**
```bash
curl -X POST https://api.example.com/pokemon \
  -H "Content-Type: application/json" \
  -d '{"name": "Charmander", "type": "Fire"}'
```

**Testing PUT requests:**
```bash
curl -X PUT https://api.example.com/pokemon/4 \
  -H "Content-Type: application/json" \
  -d '{"name": "Charmander", "type": "Fire", "level": 16}'
```

**Testing DELETE requests:**
```bash
curl -X DELETE https://api.example.com/pokemon/4
```

**Testing with authentication:**
```bash
curl -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  https://api.example.com/pokemon
```

#### Method 3: Using Browser Developer Tools

For simple GET requests:
1. Open any website
2. Press F12 to open Developer Tools
3. Go to "Console" tab
4. Type:
```javascript
fetch('https://pokeapi.co/api/v2/pokemon/25')
  .then(response => response.json())
  .then(data => console.log(data));
```

### Common Validation Checks

**Check 1: Verify status codes**
```bash
curl -w "\nHTTP Status: %{http_code}\n" https://pokeapi.co/api/v2/pokemon/25
```
Expected: HTTP Status: 200

**Check 2: Verify response content type**
```bash
curl -I https://pokeapi.co/api/v2/pokemon/25
```
Expected: `Content-Type: application/json`

**Check 3: Verify response structure**
```bash
# Using jq (JSON processor)
curl https://pokeapi.co/api/v2/pokemon/25 | jq '.name'
```
Expected: "pikachu"

**Check 4: Verify error handling**
```bash
curl https://pokeapi.co/api/v2/pokemon/9999
```
Expected: 404 status code with error message

### Hands-On Exercises

#### Exercise 1: Exploring a Public REST API (Beginner Level)

**Objective:** Learn to interact with a real REST API and understand RESTful patterns

**Task:**
Use the PokeAPI (a free, public Pokemon API) to retrieve and analyze Pokemon data.

**Requirements:**
1. Get information about Pikachu (Pokemon #25)
2. Get a list of all Pokemon (first 20)
3. Get information about the "Electric" type
4. Find at least 3 pieces of information about Pikachu (name, weight, height, abilities, etc.)
5. Identify the URL pattern used by the API

**Base URL:** `https://pokeapi.co/api/v2/`

**Hints:**
- Start with: `https://pokeapi.co/api/v2/pokemon/25`
- Try: `https://pokeapi.co/api/v2/pokemon?limit=20`
- For types: `https://pokeapi.co/api/v2/type/electric`
- Use Postman or curl to make requests
- Look at the JSON structure in the response

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Using curl:**
```bash
# 1. Get Pikachu's information
curl https://pokeapi.co/api/v2/pokemon/25

# 2. Get list of first 20 Pokemon
curl https://pokeapi.co/api/v2/pokemon?limit=20

# 3. Get Electric type information
curl https://pokeapi.co/api/v2/type/electric

# 4. Extract specific information using jq
curl https://pokeapi.co/api/v2/pokemon/25 | jq '{name: .name, weight: .weight, height: .height, abilities: [.abilities[].ability.name]}'
```

**URL Pattern Analysis:**
- Collections: `/api/v2/pokemon` (plural noun)
- Individual resource: `/api/v2/pokemon/25` (resource + ID)
- Related resource: `/api/v2/type/electric` (different resource type)
- Consistent structure across all endpoints
- Uses query parameters for pagination: `?limit=20&offset=0`

**Key Findings about Pikachu:**
```json
{
  "name": "pikachu",
  "weight": 60,
  "height": 4,
  "abilities": ["static", "lightning-rod"],
  "types": ["electric"],
  "stats": {
    "hp": 35,
    "attack": 55,
    "defense": 40
  }
}
```

**Explanation:**
The PokeAPI follows REST principles:
- Uses resource-based URLs
- GET method for retrieving data
- JSON responses
- Consistent URL structure
- Query parameters for filtering/pagination
</details>

---

#### Exercise 2: Designing RESTful URLs (Intermediate Level)

**Objective:** Practice designing clean, RESTful URL structures

**Task:**
Design a RESTful API for a Library Management System. Create URLs for the following resources and operations:

**Resources:**
- Books (title, author, ISBN, publicationYear, available)
- Authors (name, birthYear, nationality, biography)
- Members (name, email, membershipDate)
- Loans (bookId, memberId, loanDate, returnDate)

**Requirements:**
Design URLs for these operations:
1. Get all books
2. Get a specific book by ID
3. Get all books by a specific author
4. Create a new book
5. Update a book's information
6. Delete a book
7. Get all members
8. Get a specific member's loan history
9. Create a new loan (member borrows a book)
10. Return a book (complete a loan)
11. Search books by title
12. Get all available (not loaned) books

**Hints:**
- Use plural nouns for collections
- Use hierarchical structure for relationships
- Think about nested resources
- Consider query parameters for filtering and searching
- Remember: URLs identify resources, HTTP methods indicate actions

**Solution:**
<details>
<summary>Click to reveal solution</summary>

```http
# Books
GET    /api/books                          # 1. Get all books
GET    /api/books/{id}                     # 2. Get specific book
GET    /api/authors/{authorId}/books       # 3. Get books by author
POST   /api/books                          # 4. Create new book
PUT    /api/books/{id}                     # 5. Update book
DELETE /api/books/{id}                     # 6. Delete book

# Members
GET    /api/members                        # 7. Get all members
GET    /api/members/{id}/loans             # 8. Get member's loan history

# Loans
POST   /api/loans                          # 9. Create new loan
PUT    /api/loans/{id}/return              # 10. Return book (mark loan complete)
# Alternative for #10:
PATCH  /api/loans/{id}                     # With body: { "returned": true }

# Search and Filter
GET    /api/books?search=potter            # 11. Search books by title
GET    /api/books?available=true           # 12. Get available books
GET    /api/books?author=rowling&available=true  # Combined filters

# Additional useful endpoints
GET    /api/authors                        # Get all authors
GET    /api/authors/{id}                   # Get specific author
POST   /api/authors                        # Create author
GET    /api/loans?status=active            # Get active loans
GET    /api/loans?memberId={id}            # Get loans by member (alternative to #8)
```

**Complete Example Requests:**

```http
# Create a new book
POST /api/books
Content-Type: application/json

{
  "title": "Harry Potter and the Philosopher's Stone",
  "authorId": 15,
  "isbn": "978-0-7475-3269-9",
  "publicationYear": 1997
}

# Create a loan (member borrows book)
POST /api/loans
Content-Type: application/json

{
  "bookId": 42,
  "memberId": 123,
  "loanDate": "2026-11-22"
}

# Return a book
PUT /api/loans/789/return

# Or using PATCH
PATCH /api/loans/789
Content-Type: application/json

{
  "returnDate": "2026-12-01",
  "returned": true
}

# Search for books
GET /api/books?search=harry%20potter&available=true&limit=10
```

**Design Principles Applied:**
1. ✅ Used plural nouns (`/books`, `/members`, `/loans`)
2. ✅ Resource hierarchy (`/authors/{id}/books`, `/members/{id}/loans`)
3. ✅ Query parameters for filtering (`?available=true`, `?search=potter`)
4. ✅ Clear relationship between resources
5. ✅ Actions indicated by HTTP methods, not URLs
6. ✅ Consistent naming conventions

**Why these URLs are RESTful:**
- Focus on resources (nouns), not actions
- Use standard HTTP methods for operations
- Hierarchical structure shows relationships
- Query parameters for filtering, not part of URL path
- Predictable and intuitive
</details>

---

#### Exercise 3: Status Code Detective (Challenge Level)

**Objective:** Understand when to use different HTTP status codes

**Task:**
For each scenario below, identify the correct HTTP status code and explain why. Then design the complete HTTP response.

**Scenarios:**

1. User successfully retrieves a Pokemon
2. User creates a new Pokemon
3. User tries to get a Pokemon that doesn't exist (ID 9999)
4. User tries to create a Pokemon but forgets to include the name field
5. User tries to delete a Pokemon but isn't logged in
6. User tries to update another user's Pokemon (they don't have permission)
7. Server crashes while processing request
8. User successfully deletes a Pokemon
9. User requests a Pokemon but the database is temporarily down
10. User sends a request with invalid JSON format
11. User updates a Pokemon successfully
12. API rate limit exceeded (user made too many requests)

**Bonus Challenges:**
- Write the complete HTTP response for each scenario (including headers and body)
- Explain when you'd use 200 OK vs 201 Created vs 204 No Content
- Design a consistent error response format

**Solution:**
<details>
<summary>Click to reveal solution</summary>

**Answers:**

**1. User successfully retrieves a Pokemon**
```http
HTTP/1.1 200 OK
Content-Type: application/json
Cache-Control: max-age=3600

{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric"
}
```
**Why:** 200 OK indicates successful GET request with content in response.

---

**2. User creates a new Pokemon**
```http
HTTP/1.1 201 Created
Content-Type: application/json
Location: /api/pokemon/151

{
  "id": 151,
  "name": "Mew",
  "type": "Psychic",
  "createdAt": "2026-11-22T14:30:00Z"
}
```
**Why:** 201 Created indicates new resource was successfully created. Location header points to the new resource.

---

**3. Pokemon doesn't exist (ID 9999)**
```http
HTTP/1.1 404 Not Found
Content-Type: application/json

{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "Pokemon with ID 9999 does not exist",
    "statusCode": 404
  }
}
```
**Why:** 404 Not Found means the requested resource doesn't exist.

---

**4. Missing required field (name)**
```http
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "statusCode": 400,
    "details": [
      {
        "field": "name",
        "message": "Name is required"
      }
    ]
  }
}
```
**Why:** 400 Bad Request indicates client sent invalid data.

---

**5. Not logged in**
```http
HTTP/1.1 401 Unauthorized
Content-Type: application/json
WWW-Authenticate: Bearer realm="api"

{
  "error": {
    "code": "AUTHENTICATION_REQUIRED",
    "message": "You must be logged in to perform this action",
    "statusCode": 401
  }
}
```
**Why:** 401 Unauthorized means authentication is required but wasn't provided.

---

**6. No permission (not user's Pokemon)**
```http
HTTP/1.1 403 Forbidden
Content-Type: application/json

{
  "error": {
    "code": "INSUFFICIENT_PERMISSIONS",
    "message": "You do not have permission to modify this Pokemon",
    "statusCode": 403
  }
}
```
**Why:** 403 Forbidden means user is authenticated but doesn't have permission.

---

**7. Server crashes**
```http
HTTP/1.1 500 Internal Server Error
Content-Type: application/json

{
  "error": {
    "code": "INTERNAL_SERVER_ERROR",
    "message": "An unexpected error occurred. Please try again later.",
    "statusCode": 500,
    "requestId": "req_abc123"
  }
}
```
**Why:** 500 Internal Server Error indicates server-side failure.

---

**8. Successfully deleted Pokemon**
```http
HTTP/1.1 204 No Content
```
**Why:** 204 No Content indicates successful deletion with no response body needed.

---

**9. Database temporarily down**
```http
HTTP/1.1 503 Service Unavailable
Content-Type: application/json
Retry-After: 60

{
  "error": {
    "code": "SERVICE_UNAVAILABLE",
    "message": "Database is temporarily unavailable. Please try again in 60 seconds.",
    "statusCode": 503
  }
}
```
**Why:** 503 Service Unavailable indicates temporary server issue. Retry-After header suggests when to retry.

---

**10. Invalid JSON format**
```http
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "error": {
    "code": "INVALID_JSON",
    "message": "Request body contains invalid JSON",
    "statusCode": 400,
    "details": "Unexpected token at position 15"
  }
}
```
**Why:** 400 Bad Request for malformed request data.

---

**11. Successfully updated Pokemon**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric",
  "level": 55,
  "updatedAt": "2026-11-22T15:00:00Z"
}
```
**Why:** 200 OK with updated resource in response.

---

**12. Rate limit exceeded**
```http
HTTP/1.1 429 Too Many Requests
Content-Type: application/json
Retry-After: 3600
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1700000000

{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "API rate limit exceeded. Try again in 1 hour.",
    "statusCode": 429,
    "limit": 1000,
    "resetAt": "2026-11-22T16:00:00Z"
  }
}
```
**Why:** 429 Too Many Requests indicates rate limiting. Headers provide limit details.

---

**Bonus: Status Code Comparison**

| Status Code | Use Case | Response Body |
|-------------|----------|---------------|
| **200 OK** | Successful GET, PUT, PATCH | Yes - the resource |
| **201 Created** | Successful POST (created resource) | Yes - the new resource |
| **204 No Content** | Successful DELETE, or PUT with no content to return | No |

**When to use each:**
- **200 OK**: Most successful requests that return data
- **201 Created**: Only for POST requests that create new resources
- **204 No Content**: DELETE operations, or when no response body is needed

**Consistent Error Response Format:**
```json
{
  "error": {
    "code": "ERROR_CODE",           // Machine-readable error code
    "message": "Human-readable description",
    "statusCode": 400,              // HTTP status code
    "timestamp": "2026-11-22T15:30:00Z",
    "path": "/api/pokemon",
    "details": {},                   // Optional: additional error details
    "requestId": "req_123"           // For tracking/debugging
  }
}
```

</details>

---

### Comprehension Questions

**Question 1:** What's the difference between PUT and PATCH, and when should you use each?
<details>
<summary>Answer</summary>

**PUT** is used to replace an entire resource. When you use PUT, you send the complete resource representation, and it replaces the existing resource entirely.

**PATCH** is used to partially update a resource. You only send the fields that need to change.

**Example:**
```http
# PUT - Must send all fields (replaces entire resource)
PUT /api/pokemon/25
{
  "name": "Pikachu",
  "type": "Electric",
  "level": 50,
  "hp": 100,
  "attack": 85
}

# PATCH - Only send changed fields
PATCH /api/pokemon/25
{
  "level": 51
}
```

**Use PUT when:**
- You have the complete resource representation
- You want to replace the entire resource
- Idempotency is important (calling multiple times has same effect)

**Use PATCH when:**
- You only want to update specific fields
- Sending the entire resource would be wasteful
- Partial updates make more sense for your use case

**Important:** PUT is idempotent (calling it multiple times has the same effect), while PATCH may or may not be idempotent depending on implementation.
</details>

**Question 2:** Why is statelessness important in REST, and what does it mean in practice?
<details>
<summary>Answer</summary>

**Statelessness** means the server doesn't store any client context between requests. Each request must contain all information needed to process it.

**Why it's important:**

1. **Scalability**: Any server can handle any request since there's no session state
   - Load balancers can distribute requests freely
   - Easy to add more servers

2. **Reliability**: If a server crashes, clients just retry on another server
   - No lost session data
   - Simpler disaster recovery

3. **Simplicity**: Servers don't need complex session management
   - Easier to implement and maintain
   - Fewer bugs related to session state

**In practice:**

```http
# BAD: Stateful (server must remember previous requests)
POST /api/login
{ "username": "ash" }

GET /api/pokemon
# Server needs to remember who made the request

# GOOD: Stateless (each request is complete)
POST /api/auth/login
{ "username": "ash", "password": "pikachu123" }

Response: { "token": "eyJhbGc..." }

GET /api/pokemon
Authorization: Bearer eyJhbGc...
# Request contains everything needed (authentication token)
```

**Client handles state:**
- Authentication tokens in headers
- User preferences in request parameters
- Session data in JWT tokens or cookies

The server just processes requests - it doesn't need to "remember" anything about the client.
</details>

**Question 3:** When should you NOT use REST, and what are the alternatives?
<details>
<summary>Answer</summary>

**When NOT to use REST:**

1. **Real-time, bidirectional communication**
   - Alternative: **WebSockets**
   - Use case: Chat applications, live gaming, real-time dashboards

2. **Complex queries with many related resources**
   - Alternative: **GraphQL**
   - Use case: Mobile apps that need flexible data fetching, avoiding over-fetching

3. **High-performance, low-latency internal services**
   - Alternative: **gRPC**
   - Use case: Microservices communication, high-throughput systems

4. **Streaming large datasets**
   - Alternative: **Server-Sent Events (SSE)** or **Streaming APIs**
   - Use case: Log streaming, real-time analytics

5. **Complex transactions spanning multiple operations**
   - Alternative: **RPC-style APIs** or **SOAP**
   - Use case: Banking operations, complex business workflows

6. **Pub/Sub patterns**
   - Alternative: **Message queues** (RabbitMQ, Kafka)
   - Use case: Event-driven architectures, async processing

**Comparison:**

| Need | Use This | Instead of REST |
|------|----------|-----------------|
| Real-time updates | WebSockets | Polling REST endpoints |
| Flexible queries | GraphQL | Multiple REST requests |
| High performance | gRPC | REST with JSON |
| Streaming data | SSE/WebSockets | Polling |
| Complex workflows | RPC/SOAP | Multiple REST calls |

**Example scenarios:**

- **Chat app**: WebSockets (needs instant, bidirectional communication)
- **Social media feed**: GraphQL (flexible querying, avoid over-fetching)
- **Microservices**: gRPC (performance, type safety)
- **Public API**: REST (simplicity, wide adoption, cacheable)

REST is great for most web APIs, but it's not a one-size-fits-all solution.
</details>

**Question 4:** How would you design a RESTful API endpoint for a complex operation that doesn't map to a simple CRUD operation?
<details>
<summary>Answer</summary>

Complex operations that don't map to CRUD are a common challenge in REST. Here are several approaches:

**Approach 1: Treat the operation as a resource (Recommended)**

Instead of thinking of the operation as a verb, model it as a noun (resource).

```http
# Instead of: POST /api/pokemon/evolve
# Think of evolution as a resource:
POST /api/evolutions
{
  "pokemonId": 25,
  "targetForm": "raichu"
}

# Battle example - battle is a resource
POST /api/battles
{
  "trainer1Id": "ash",
  "trainer2Id": "gary",
  "pokemonTeam1": [25, 94],
  "pokemonTeam2": [3, 6]
}

GET /api/battles/123
DELETE /api/battles/123
```

**Approach 2: Use sub-resources for actions**

```http
# Pokemon evolution
POST /api/pokemon/25/evolutions
{
  "evolutionStone": "thunder-stone"
}

# Transfer Pokemon between trainers
POST /api/pokemon/25/transfers
{
  "fromTrainerId": "ash",
  "toTrainerId": "brock"
}

# Level up a Pokemon
POST /api/pokemon/25/level-ups
{
  "experience": 1000
}
```

**Approach 3: Use action-oriented endpoints (less RESTful, but pragmatic)**

When nothing else makes sense, use a verb in the URL:

```http
# Search (common exception)
POST /api/pokemon/search
{
  "types": ["electric", "psychic"],
  "minLevel": 30,
  "maxLevel": 50
}

# Calculate damage
POST /api/battles/calculate-damage
{
  "attackerId": 25,
  "defenderId": 94,
  "moveId": 85
}
```

**Approach 4: Use status updates (for state changes)**

```http
# Activate/deactivate an account
PATCH /api/trainers/ash
{
  "status": "inactive"
}

# Publish a draft Pokemon design
PATCH /api/pokemon-designs/151
{
  "status": "published"
}
```

**Best Practices:**

1. ✅ **Prefer treating operations as resources** (Approach 1)
2. ✅ **Use PATCH for state changes** (Approach 4)
3. ✅ **Sub-resources for related actions** (Approach 2)
4. ⚠️ **Action endpoints as last resort** (Approach 3)

**Example: Payment Processing**

```http
# GOOD: Payment as a resource
POST /api/payments
{
  "orderId": 123,
  "amount": 59.99,
  "method": "credit-card",
  "token": "tok_xyz"
}

# Then check payment status
GET /api/payments/pay_123

# Or refund (refund is also a resource)
POST /api/refunds
{
  "paymentId": "pay_123",
  "amount": 59.99,
  "reason": "customer-request"
}
```

The key is to think creatively about modeling operations as resources, while being pragmatic when pure REST doesn't fit.
</details>

**Question 5:** What's wrong with this URL design: `/api/getPokemonById?id=25`, and how would you fix it?
<details>
<summary>Answer</summary>

**Problems with `/api/getPokemonById?id=25`:**

1. ❌ **Contains a verb** (`getPokemon`) - REST focuses on resources (nouns), not actions
2. ❌ **Action is in the URL** - HTTP methods already indicate the action (GET, POST, etc.)
3. ❌ **Unnecessary query parameter** - The ID should be part of the path
4. ❌ **Not intuitive** - Harder to guess and remember
5. ❌ **Doesn't follow REST conventions** - Makes API inconsistent

**Correct RESTful design:**
```http
GET /api/pokemon/25
```

**Why this is better:**
- ✅ Uses noun (`pokemon`), not verb (`getPokemon`)
- ✅ HTTP method (GET) indicates the action
- ✅ ID is part of the path, clearly identifying the resource
- ✅ Clean, intuitive, easy to remember
- ✅ Follows REST conventions

**More examples of bad vs. good:**

```http
# BAD: Contains verbs
POST /api/createPokemon
GET  /api/deletePokemon?id=25
GET  /api/updatePokemon

# GOOD: Resource-oriented
POST   /api/pokemon        # Create
DELETE /api/pokemon/25     # Delete
PUT    /api/pokemon/25     # Update

# BAD: Inconsistent patterns
GET /api/pokemon?id=25
GET /api/getTrainerByName?name=ash
GET /api/item/potion

# GOOD: Consistent patterns
GET /api/pokemon/25
GET /api/trainers/ash
GET /api/items/potion

# BAD: Query params for resource IDs
GET /api/pokemon?pokemonId=25&trainerId=ash

# GOOD: Hierarchical paths
GET /api/trainers/ash/pokemon/25
```

**When query parameters ARE appropriate:**

```http
# Filtering
GET /api/pokemon?type=electric&level=50

# Sorting
GET /api/pokemon?sortBy=name&order=asc

# Pagination
GET /api/pokemon?page=2&pageSize=20

# Searching
GET /api/pokemon?search=pikachu

# Optional parameters
GET /api/pokemon?includeStats=true&includeEvolutions=true
```

**Rule of thumb:**
- Path parameters (e.g., `/pokemon/25`): For identifying specific resources
- Query parameters (e.g., `?type=electric`): For filtering, sorting, pagination, or optional features

</details>

### Self-Assessment Checklist

After completing this section, you should be able to:

- [ ] Explain what REST is and why it's the standard for web APIs
- [ ] List the six REST architectural constraints
- [ ] Understand the difference between resources and representations
- [ ] Design clean, RESTful URLs following naming conventions
- [ ] Use appropriate HTTP methods for different operations (GET, POST, PUT, PATCH, DELETE)
- [ ] Understand when each HTTP status code should be used (200, 201, 400, 404, 500, etc.)
- [ ] Explain what statelessness means and why it matters
- [ ] Design a simple RESTful API for a given domain
- [ ] Test REST APIs using Postman or curl
- [ ] Understand the difference between REST, SOAP, and GraphQL at a high level

**If you can't check all these boxes:**
- Review the Core Concepts section for theory
- Retry the hands-on exercises
- Test real APIs using PokeAPI or other public APIs
- Practice designing URLs for different scenarios
- Ask for help in the community resources listed in Section 12

### Debugging Tips

If your REST API isn't working:

1. **Check the HTTP method** - Are you using GET when you should use POST?
2. **Verify the URL** - Typos in URLs are common (`/pokémon` vs `/pokemon`)
3. **Check request headers** - Is `Content-Type: application/json` set?
4. **Validate JSON format** - Use a JSON validator online
5. **Read the status code** - 400s are client errors, 500s are server errors
6. **Check authentication** - Is your token/API key correct and not expired?
7. **Look at response body** - Error messages usually explain what's wrong

**Common debugging workflow:**
```
1. Read the error message carefully
2. Check the HTTP status code
3. Verify your request is correctly formatted
4. Use Postman to isolate the problem
5. Check API documentation for required fields
6. Search for the error message online
7. Ask for help with specific details (include request and response)
```

---

## 9. Practical Examples

### Example 1: Simple Pokemon CRUD API (Beginner)

**Scenario:**
We're building a basic Pokemon management API that supports creating, reading, updating, and deleting Pokemon.

**API Design:**

```http
GET    /api/pokemon         # List all Pokemon
GET    /api/pokemon/{id}    # Get specific Pokemon
POST   /api/pokemon         # Create new Pokemon
PUT    /api/pokemon/{id}    # Update Pokemon
DELETE /api/pokemon/{id}    # Delete Pokemon
```

**Complete Request/Response Examples:**

**1. Create a new Pokemon (POST)**
```http
POST /api/pokemon HTTP/1.1
Host: api.pokemonapp.com
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJI...

{
  "name": "Pikachu",
  "type": "Electric",
  "level": 5,
  "hp": 35,
  "attack": 55,
  "defense": 40
}

---Response---
HTTP/1.1 201 Created
Location: /api/pokemon/25
Content-Type: application/json

{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric",
  "level": 5,
  "hp": 35,
  "attack": 55,
  "defense": 40,
  "createdAt": "2026-11-22T10:00:00Z",
  "updatedAt": "2026-11-22T10:00:00Z"
}
```

**2. Get all Pokemon (GET with pagination)**
```http
GET /api/pokemon?page=1&pageSize=10&sortBy=name HTTP/1.1
Host: api.pokemonapp.com
Accept: application/json

---Response---
HTTP/1.1 200 OK
Content-Type: application/json
X-Total-Count: 150
Link: </api/pokemon?page=2&pageSize=10>; rel="next"

{
  "data": [
    {
      "id": 1,
      "name": "Bulbasaur",
      "type": "Grass/Poison",
      "level": 5
    },
    {
      "id": 4,
      "name": "Charmander",
      "type": "Fire",
      "level": 5
    }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 10,
    "total": 150,
    "totalPages": 15
  }
}
```

**3. Get specific Pokemon (GET)**
```http
GET /api/pokemon/25 HTTP/1.1
Host: api.pokemonapp.com
Accept: application/json

---Response---
HTTP/1.1 200 OK
Content-Type: application/json
Cache-Control: max-age=3600
ETag: "abc123"

{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric",
  "level": 5,
  "hp": 35,
  "attack": 55,
  "defense": 40,
  "abilities": ["Static", "Lightning Rod"],
  "createdAt": "2026-11-22T10:00:00Z",
  "updatedAt": "2026-11-22T10:00:00Z"
}
```

**4. Update Pokemon (PUT)**
```http
PUT /api/pokemon/25 HTTP/1.1
Host: api.pokemonapp.com
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJI...

{
  "name": "Pikachu",
  "type": "Electric",
  "level": 50,
  "hp": 100,
  "attack": 85,
  "defense": 65
}

---Response---
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric",
  "level": 50,
  "hp": 100,
  "attack": 85,
  "defense": 65,
  "abilities": ["Static", "Lightning Rod"],
  "createdAt": "2026-11-22T10:00:00Z",
  "updatedAt": "2026-11-22T14:30:00Z"
}
```

**5. Delete Pokemon (DELETE)**
```http
DELETE /api/pokemon/25 HTTP/1.1
Host: api.pokemonapp.com
Authorization: Bearer eyJhbGciOiJI...

---Response---
HTTP/1.1 204 No Content
```

**Walkthrough:**
1. **POST creates** a new Pokemon, server assigns an ID, responds with 201 and Location header
2. **GET collection** returns paginated list with metadata (total count, page info)
3. **GET individual** returns full details of one Pokemon with caching headers
4. **PUT updates** the entire Pokemon (all fields must be sent)
5. **DELETE removes** the Pokemon, returns 204 (no content needed)

**Try it yourself:**
- Add a PATCH endpoint for partial updates
- Add filtering: `/api/pokemon?type=Electric&minLevel=20`
- Add search: `/api/pokemon?search=pikachu`
- Add validation error responses

---

### Example 2: Nested Resources - Trainer's Pokemon Collection (Intermediate)

**Scenario:**
We're modeling the relationship between Trainers and their Pokemon. A trainer can have multiple Pokemon.

**URL Design:**

```http
# Trainers
GET    /api/trainers              # All trainers
GET    /api/trainers/{id}         # Specific trainer
POST   /api/trainers              # Create trainer

# Trainer's Pokemon (nested resource)
GET    /api/trainers/{id}/pokemon           # All Pokemon owned by trainer
GET    /api/trainers/{id}/pokemon/{pokemonId}  # Specific Pokemon of trainer
POST   /api/trainers/{id}/pokemon           # Add Pokemon to trainer
DELETE /api/trainers/{id}/pokemon/{pokemonId}  # Remove Pokemon from trainer
```

**Complete Examples:**

**1. Get all Pokemon owned by Ash**
```http
GET /api/trainers/ash/pokemon HTTP/1.1
Host: api.pokemonapp.com
Accept: application/json

---Response---
HTTP/1.1 200 OK
Content-Type: application/json

{
  "trainer": {
    "id": "ash",
    "name": "Ash Ketchum",
    "badgeCount": 8,
    "region": "Kanto"
  },
  "pokemon": [
    {
      "id": 25,
      "name": "Pikachu",
      "type": "Electric",
      "level": 50,
      "obtainedAt": "2026-01-01T00:00:00Z"
    },
    {
      "id": 94,
      "name": "Gengar",
      "type": "Ghost/Poison",
      "level": 45,
      "obtainedAt": "2026-03-15T12:00:00Z"
    }
  ],
  "total": 2
}
```

**2. Add a new Pokemon to Ash's team**
```http
POST /api/trainers/ash/pokemon HTTP/1.1
Host: api.pokemonapp.com
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJI...

{
  "name": "Charizard",
  "type": "Fire/Flying",
  "level": 55,
  "hp": 150,
  "attack": 120,
  "defense": 95
}

---Response---
HTTP/1.1 201 Created
Location: /api/trainers/ash/pokemon/6
Content-Type: application/json

{
  "id": 6,
  "name": "Charizard",
  "type": "Fire/Flying",
  "level": 55,
  "hp": 150,
  "attack": 120,
  "defense": 95,
  "trainerId": "ash",
  "obtainedAt": "2026-11-22T15:00:00Z"
}
```

**3. Get specific Pokemon from Ash's team**
```http
GET /api/trainers/ash/pokemon/25 HTTP/1.1
Host: api.pokemonapp.com
Accept: application/json

---Response---
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric",
  "level": 50,
  "hp": 100,
  "trainer": {
    "id": "ash",
    "name": "Ash Ketchum"
  },
  "obtainedAt": "2026-01-01T00:00:00Z",
  "links": {
    "self": "/api/trainers/ash/pokemon/25",
    "trainer": "/api/trainers/ash",
    "allPokemon": "/api/trainers/ash/pokemon",
    "directPokemonLink": "/api/pokemon/25"
  }
}
```

**4. Remove Pokemon from trainer (trade or release)**
```http
DELETE /api/trainers/ash/pokemon/94 HTTP/1.1
Host: api.pokemonapp.com
Authorization: Bearer eyJhbGciOiJI...

---Response---
HTTP/1.1 204 No Content
```

**Walkthrough:**
1. **Nested URLs** show relationships (`/trainers/{id}/pokemon`)
2. **Context is preserved** - responses include trainer information
3. **Multiple ways to access** - same Pokemon accessible via `/trainers/ash/pokemon/25` or `/pokemon/25`
4. **HATEOAS links** help clients discover related resources

**Key takeaways:**
- Use nested resources for strong parent-child relationships
- Keep nesting to 2-3 levels maximum
- Provide links to related resources
- Consider providing both nested and flat access patterns

---

### Example 3: Filtering, Sorting, and Searching (Advanced)

**Scenario:**
Building a comprehensive Pokemon search and filter system with multiple criteria.

**URL Design with Query Parameters:**

```http
# Basic filtering
GET /api/pokemon?type=Electric
GET /api/pokemon?minLevel=30&maxLevel=50
GET /api/pokemon?type=Electric&minLevel=30

# Sorting
GET /api/pokemon?sortBy=level&order=desc
GET /api/pokemon?sortBy=name&order=asc

# Pagination
GET /api/pokemon?page=2&pageSize=20

# Full-text search
GET /api/pokemon?search=pika

# Combined (real-world example)
GET /api/pokemon?type=Electric&minLevel=20&sortBy=attack&order=desc&page=1&pageSize=10
```

**Complete Example: Advanced Search**

```http
GET /api/pokemon?type=Electric&type=Psychic&minLevel=30&maxLevel=50&sortBy=attack&order=desc&page=1&pageSize=20&include=stats,abilities HTTP/1.1
Host: api.pokemonapp.com
Accept: application/json

---Response---
HTTP/1.1 200 OK
Content-Type: application/json
X-Total-Count: 42
Link: </api/pokemon?...&page=2>; rel="next", </api/pokemon?...&page=3>; rel="last"

{
  "data": [
    {
      "id": 25,
      "name": "Pikachu",
      "type": "Electric",
      "level": 50,
      "attack": 85,
      "stats": {
        "hp": 100,
        "attack": 85,
        "defense": 65,
        "speed": 95
      },
      "abilities": ["Static", "Lightning Rod"]
    },
    {
      "id": 100,
      "name": "Voltorb",
      "type": "Electric",
      "level": 35,
      "attack": 50,
      "stats": {
        "hp": 60,
        "attack": 50,
        "defense": 70,
        "speed": 100
      },
      "abilities": ["Soundproof", "Static"]
    }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "total": 42,
    "totalPages": 3
  },
  "filters": {
    "types": ["Electric", "Psychic"],
    "levelRange": {
      "min": 30,
      "max": 50
    },
    "sortBy": "attack",
    "order": "desc"
  },
  "links": {
    "self": "/api/pokemon?type=Electric&type=Psychic&minLevel=30&maxLevel=50&sortBy=attack&order=desc&page=1&pageSize=20",
    "next": "/api/pokemon?type=Electric&type=Psychic&minLevel=30&maxLevel=50&sortBy=attack&order=desc&page=2&pageSize=20",
    "last": "/api/pokemon?type=Electric&type=Psychic&minLevel=30&maxLevel=50&sortBy=attack&order=desc&page=3&pageSize=20"
  }
}
```

**Handling Complex Search:**

```http
POST /api/pokemon/search HTTP/1.1
Host: api.pokemonapp.com
Content-Type: application/json

{
  "query": {
    "types": ["Electric", "Psychic"],
    "levelRange": {
      "min": 30,
      "max": 50
    },
    "stats": {
      "attack": { "min": 50 },
      "speed": { "min": 70 }
    },
    "abilities": ["Static"]
  },
  "sort": {
    "field": "attack",
    "order": "desc"
  },
  "pagination": {
    "page": 1,
    "pageSize": 20
  }
}

---Response---
HTTP/1.1 200 OK
Content-Type: application/json

{
  "results": [ /* Pokemon matching criteria */ ],
  "total": 15,
  "page": 1,
  "pageSize": 20
}
```

**Walkthrough:**
1. **Simple filters** use query parameters (`?type=Electric`)
2. **Multiple values** for same parameter (`?type=Electric&type=Psychic`)
3. **Range filters** use min/max (`?minLevel=30&maxLevel=50`)
4. **Sorting** with field and order (`?sortBy=attack&order=desc`)
5. **Pagination** prevents overwhelming responses
6. **Complex searches** may use POST when query string gets too long
7. **Response includes metadata** about applied filters
8. **Links** help with pagination navigation

**Key takeaways:**
- Query parameters for simple filtering
- POST `/search` endpoint for complex queries
- Always paginate large result sets
- Include metadata about applied filters in response
- Provide navigation links for pagination
- Document all supported query parameters

---

## 10. Common Patterns & Best Practices

### Recommended Patterns

#### Pattern 1: Consistent Error Responses

**Description:**
Standardize error response format across your entire API for predictability.

**When to use:**
Always - for every error response in your API.

**Example:**
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "The request data is invalid",
    "statusCode": 400,
    "timestamp": "2026-11-22T15:30:00Z",
    "path": "/api/pokemon",
    "details": [
      {
        "field": "name",
        "message": "Name is required",
        "code": "REQUIRED_FIELD"
      },
      {
        "field": "level",
        "message": "Level must be between 1 and 100",
        "code": "OUT_OF_RANGE"
      }
    ],
    "requestId": "req_abc123def"
  }
}
```

**Why this is good:**
- Clients can reliably parse errors
- Machine-readable error codes for handling
- Human-readable messages for debugging
- Request ID helps with troubleshooting
- Validation details show exactly what's wrong

#### Pattern 2: API Versioning

**Description:**
Version your API to allow changes without breaking existing clients.

**When to use:**
From the start, even for v1. Plan for future changes.

**Example:**
```http
# URL versioning (most common and recommended)
GET /api/v1/pokemon/25
GET /api/v2/pokemon/25

# Header versioning (cleaner URLs)
GET /api/pokemon/25
Accept: application/vnd.pokemonapi.v1+json

# Query parameter versioning (easy to test)
GET /api/pokemon/25?version=1
```

**Why this is good:**
- Old clients continue working when you release v2
- Clear communication about API changes
- Gradual migration path for clients
- Can maintain multiple versions simultaneously

**Best practices:**
- Use URL versioning for simplicity
- Only increment major version for breaking changes
- Deprecate old versions with plenty of notice
- Document version differences clearly

#### Pattern 3: Pagination with Links

**Description:**
Include pagination metadata and navigation links in collection responses.

**When to use:**
Any endpoint that returns a collection of items.

**Example:**
```json
{
  "data": [ /* Pokemon items */ ],
  "pagination": {
    "page": 2,
    "pageSize": 20,
    "total": 150,
    "totalPages": 8
  },
  "links": {
    "first": "/api/pokemon?page=1&pageSize=20",
    "prev": "/api/pokemon?page=1&pageSize=20",
    "self": "/api/pokemon?page=2&pageSize=20",
    "next": "/api/pokemon?page=3&pageSize=20",
    "last": "/api/pokemon?page=8&pageSize=20"
  }
}
```

**Why this is good:**
- Clients don't need to calculate pagination
- Easy to navigate through results
- Clear indication of position in result set
- Follows HATEOAS principles

#### Pattern 4: Resource Filtering

**Description:**
Use query parameters for filtering collections.

**When to use:**
When clients need to narrow down results.

**Example:**
```http
# Single filter
GET /api/pokemon?type=Electric

# Multiple filters
GET /api/pokemon?type=Electric&minLevel=30&region=Kanto

# Multiple values for same filter
GET /api/pokemon?type=Electric&type=Psychic

# Date range filtering
GET /api/pokemon?createdAfter=2026-01-01&createdBefore=2026-12-31
```

**Why this is good:**
- Reduces data transfer
- Improves performance
- Intuitive for API consumers
- Easier than complex query languages

#### Pattern 5: Partial Responses (Field Selection)

**Description:**
Allow clients to specify which fields they want in the response.

**When to use:**
When resources have many fields and clients may only need a few.

**Example:**
```http
# Get only name and type
GET /api/pokemon/25?fields=name,type

Response:
{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric"
}

# Include nested fields
GET /api/pokemon/25?fields=name,stats.attack,stats.defense

Response:
{
  "id": 25,
  "name": "Pikachu",
  "stats": {
    "attack": 55,
    "defense": 40
  }
}
```

**Why this is good:**
- Reduces bandwidth usage
- Faster responses
- Mobile-friendly (less data)
- Clients get only what they need

#### Pattern 6: Bulk Operations

**Description:**
Support operations on multiple resources in a single request.

**When to use:**
When clients frequently need to perform the same operation on multiple items.

**Example:**
```http
# Bulk create
POST /api/pokemon/bulk
{
  "pokemon": [
    { "name": "Bulbasaur", "type": "Grass" },
    { "name": "Charmander", "type": "Fire" },
    { "name": "Squirtle", "type": "Water" }
  ]
}

Response:
{
  "created": 3,
  "results": [
    { "id": 1, "name": "Bulbasaur", "status": "created" },
    { "id": 4, "name": "Charmander", "status": "created" },
    { "id": 7, "name": "Squirtle", "status": "created" }
  ]
}

# Bulk update
PATCH /api/pokemon/bulk
{
  "ids": [1, 4, 7],
  "updates": {
    "level": 10
  }
}

# Bulk delete
DELETE /api/pokemon/bulk
{
  "ids": [1, 4, 7]
}
```

**Why this is good:**
- Reduces number of HTTP requests
- Better performance
- Atomic operations (all succeed or all fail)
- Useful for batch processing

### Do's and Don'ts

#### Do's

- ✅ **Use nouns for resource names** - `/api/pokemon` not `/api/getPokemon`
  - Resources are things, not actions

- ✅ **Use plural nouns for collections** - `/api/pokemon` not `/api/pokemon1`
  - Collections contain multiple items

- ✅ **Use HTTP methods correctly** - GET for reading, POST for creating, PUT/PATCH for updating, DELETE for removing
  - Method indicates the action

- ✅ **Return appropriate status codes** - 200 for success, 404 for not found, 400 for bad request
  - Status codes have specific meanings

- ✅ **Keep URLs simple and intuitive** - `/api/trainers/ash/pokemon` not `/api/getTrainerPokemonList?trainer=ash`
  - Readable URLs are easier to use

- ✅ **Version your API from the start** - `/api/v1/pokemon`
  - Plan for future changes

- ✅ **Use JSON as default format** - Most widely supported and easiest to work with
  - Standard for modern APIs

- ✅ **Provide comprehensive error messages** - Include error code, message, and details
  - Helps developers debug issues

- ✅ **Document your API** - Use OpenAPI/Swagger or similar
  - Good documentation = happy developers

- ✅ **Implement pagination for collections** - Don't return thousands of items at once
  - Prevents performance issues

#### Don'ts

- ❌ **Don't use verbs in URLs** - `/api/pokemon` not `/api/createPokemon`
  - **Instead:** Use HTTP methods to indicate actions

- ❌ **Don't put the version after resource name** - `/api/pokemon/v1` ❌
  - **Instead:** `/api/v1/pokemon` - version applies to entire API

- ❌ **Don't use inconsistent naming** - `/api/pokemon` and `/api/Trainers` and `/api/battle-items`
  - **Instead:** Choose one convention and stick to it (kebab-case or camelCase)

- ❌ **Don't return arrays as root elements** - `[{pokemon1}, {pokemon2}]` ❌
  - **Instead:** Wrap in object: `{"data": [{pokemon1}, {pokemon2}], "total": 2}`
  - Reason: Can't add metadata later without breaking change

- ❌ **Don't include file extensions in URLs** - `/api/pokemon/25.json` ❌
  - **Instead:** Use Accept header: `Accept: application/json`

- ❌ **Don't nest resources too deeply** - `/api/regions/kanto/cities/pewter/gyms/1/trainers/brock/pokemon/95` ❌
  - **Instead:** Maximum 2-3 levels, provide direct access: `/api/trainers/brock/pokemon`

- ❌ **Don't return everything all the time** - Sending 50 fields when client needs 3
  - **Instead:** Implement field selection or multiple endpoint variants

- ❌ **Don't ignore HTTP caching** - Missing Cache-Control, ETag headers
  - **Instead:** Use appropriate caching headers for performance

- ❌ **Don't expose internal IDs unnecessarily** - Database IDs, internal implementation details
  - **Instead:** Use UUIDs or public-facing identifiers

- ❌ **Don't return sensitive data** - Passwords, internal tokens, server paths
  - **Instead:** Explicitly include only safe fields in responses

### Resource Naming Conventions

**General rules:**
```
✅ /api/pokemon              # Plural nouns
✅ /api/pokemon/25           # Specific resource
✅ /api/pokemon/25/moves     # Nested resource
✅ /api/trainers/ash         # Non-numeric ID acceptable
✅ /api/pokemon-types        # Hyphen for multi-word

❌ /api/pokemon1             # No numbers unless it's an ID
❌ /api/getPokemon           # No verbs
❌ /api/Pokemon              # No capitals (use lowercase)
❌ /api/pokemonTypes         # No camelCase in URLs
❌ /api/pokemons             # No irregular plurals
```

**URL Structure Pattern:**
```
/api/{version}/{resource}/{id}/{sub-resource}/{sub-id}
```

Examples:
```
/api/v1/trainers/ash/pokemon/25
/api/v1/pokemon/25/moves/thunderbolt
/api/v2/battles/123/participants
```

### Performance Considerations

**Performance tips:**

1. **Implement HTTP caching** - Reduces server load
```http
GET /api/pokemon/25
Response:
Cache-Control: max-age=3600
ETag: "abc123"
```

2. **Use pagination by default** - Limit response size
```
Default: ?page=1&pageSize=20
Maximum: ?pageSize=100 (enforce limits)
```

3. **Support compression** - Reduces bandwidth
```http
Accept-Encoding: gzip
Response:
Content-Encoding: gzip
```

4. **Implement field selection** - Send only needed data
```
/api/pokemon?fields=name,type
```

5. **Use async processing for slow operations** - Return immediately with status URL
```http
POST /api/pokemon/bulk
Response: 202 Accepted
Location: /api/jobs/abc123

GET /api/jobs/abc123
Response: { "status": "processing", "progress": 50 }
```

**Common performance pitfalls:**

- **N+1 queries** - Loading related resources one by one
  - Solution: Eager loading, include related data in response

- **Large payloads** - Sending too much data
  - Solution: Pagination, field selection, compression

- **No caching** - Recalculating same responses
  - Solution: HTTP caching headers, CDN

- **Synchronous long operations** - Blocking requests
  - Solution: Async processing with job status endpoints

---

## 11. Troubleshooting & Common Issues

### Frequently Encountered Problems

#### Problem 1: 404 Not Found - But the Resource Exists!

**Symptoms:**
- API returns 404 but you know the resource exists
- Works sometimes, fails other times
- Different behavior in different environments

**Common Causes:**

1. **Trailing slashes**
```http
✅ GET /api/pokemon/25
❌ GET /api/pokemon/25/     # May cause 404 depending on server config
```

2. **Case sensitivity**
```http
✅ GET /api/pokemon/pikachu
❌ GET /api/pokemon/Pikachu  # May not match if IDs are case-sensitive
```

3. **URL encoding issues**
```http
✅ GET /api/pokemon/mr-mime    # Correctly hyphenated
❌ GET /api/pokemon/mr mime    # Space not encoded
✅ GET /api/pokemon/mr%20mime  # Properly URL-encoded
```

**Solution:**
```bash
# Check exact URL
curl -v http://api.example.com/api/pokemon/25

# Look for 301/302 redirects
# Ensure consistent trailing slash handling
# Verify case sensitivity rules
# Always URL-encode special characters
```

---

#### Problem 2: 400 Bad Request - Invalid JSON

**Symptoms:**
```http
POST /api/pokemon
{ name: "Pikachu", type: "Electric" }

Response: 400 Bad Request
{
  "error": "Invalid JSON"
}
```

**Cause:**
JSON keys must be in double quotes, not unquoted.

**Solution:**
```json
✅ Correct:
{
  "name": "Pikachu",
  "type": "Electric"
}

❌ Wrong:
{
  name: "Pikachu",        # Keys not quoted
  type: "Electric"
}

❌ Wrong:
{
  'name': 'Pikachu',      # Single quotes
  'type': 'Electric'
}
```

**Testing JSON:**
```bash
# Use jq to validate JSON
echo '{"name":"Pikachu"}' | jq .

# Or online validators:
# https://jsonlint.com/
```

---

#### Problem 3: 401 Unauthorized vs 403 Forbidden Confusion

**Symptoms:**
- Not sure which status code to return
- Using 401 and 403 interchangeably

**Cause:**
These codes have different meanings.

**Solution:**

| Scenario | Status Code | Meaning |
|----------|-------------|---------|
| No authentication provided | **401 Unauthorized** | "Who are you? Please log in" |
| Invalid token/credentials | **401 Unauthorized** | "I don't recognize these credentials" |
| Authenticated but no permission | **403 Forbidden** | "I know who you are, but you can't do that" |

```http
# 401: Not authenticated
GET /api/pokemon
Response: 401 Unauthorized
{
  "error": {
    "code": "AUTHENTICATION_REQUIRED",
    "message": "Authentication token is required"
  }
}

# 403: Authenticated but not authorized
DELETE /api/trainers/ash/pokemon/25
Authorization: Bearer [gary's-token]
Response: 403 Forbidden
{
  "error": {
    "code": "INSUFFICIENT_PERMISSIONS",
    "message": "You cannot delete another trainer's Pokemon"
  }
}
```

---

#### Problem 4: PUT vs PATCH Confusion

**Symptoms:**
- Not sure which to use for updates
- Inconsistent behavior across endpoints

**Cause:**
Misunderstanding the difference.

**Solution:**

**PUT** - Replace entire resource:
```http
PUT /api/pokemon/25
{
  "name": "Pikachu",
  "type": "Electric",
  "level": 50,
  "hp": 100,
  "attack": 85
}
# Must send ALL fields
```

**PATCH** - Partial update:
```http
PATCH /api/pokemon/25
{
  "level": 51
}
# Only send changed fields
```

**When to use:**
- Use **PUT** when client has the full resource
- Use **PATCH** for partial updates
- Document which fields are required for PUT

---

#### Problem 5: CORS Errors (Browser-Specific)

**Symptoms:**
```
Access to fetch at 'http://api.example.com/pokemon' from origin
'http://localhost:3000' has been blocked by CORS policy
```

**Cause:**
Browser security prevents cross-origin requests without proper CORS headers.

**Solution:**

Server must include CORS headers:
```http
Response headers:
Access-Control-Allow-Origin: http://localhost:3000
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
Access-Control-Max-Age: 86400
```

**For ASP.NET Core:**
```csharp
// In Program.cs
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});

app.UseCors("AllowAll");
```

**Note:** Only affects browser requests, not curl/Postman.

---

### Error Messages Explained

| Error Message | Meaning | Solution |
|---------------|---------|----------|
| `404 Not Found` | Resource doesn't exist at that URL | Verify URL spelling, check if resource exists |
| `400 Bad Request` | Request is malformed | Check JSON syntax, required fields |
| `401 Unauthorized` | Authentication required or invalid | Provide valid token/credentials |
| `403 Forbidden` | Authenticated but no permission | Check user permissions |
| `405 Method Not Allowed` | HTTP method not supported | Use correct method (GET/POST/etc) |
| `415 Unsupported Media Type` | Wrong Content-Type header | Set `Content-Type: application/json` |
| `422 Unprocessable Entity` | Semantic errors in request | Fix validation errors in request data |
| `429 Too Many Requests` | Rate limit exceeded | Wait and retry, check rate limits |
| `500 Internal Server Error` | Server-side bug | Check server logs, report bug |
| `503 Service Unavailable` | Server temporarily down | Retry later |

### Debugging Strategies

**Step-by-step debugging:**

1. **Check the HTTP status code**
```bash
curl -I http://api.example.com/pokemon/25
# Look at first line: HTTP/1.1 404 Not Found
```

2. **Read the full response**
```bash
curl -v http://api.example.com/pokemon/25
# Shows request and response headers + body
```

3. **Verify request headers**
```bash
curl -H "Content-Type: application/json" \
     -H "Authorization: Bearer TOKEN" \
     http://api.example.com/pokemon
```

4. **Check request body**
```bash
# Save request to file for inspection
cat > request.json <<'EOF'
{
  "name": "Pikachu",
  "type": "Electric"
}
EOF

curl -d @request.json \
     -H "Content-Type: application/json" \
     http://api.example.com/pokemon
```

5. **Use Postman for complex debugging**
- Easier to inspect headers
- JSON formatting
- Save request collections
- Generate code snippets

**Useful debugging commands:**

```bash
# See response headers only
curl -I http://api.example.com/pokemon/25

# Verbose output (shows everything)
curl -v http://api.example.com/pokemon/25

# Save response to file
curl http://api.example.com/pokemon/25 > response.json

# Format JSON output
curl http://api.example.com/pokemon/25 | jq .

# Show response time
curl -w "\nTime: %{time_total}s\n" http://api.example.com/pokemon/25

# Follow redirects
curl -L http://api.example.com/pokemon/25
```

### Where to Get Help

- **Official REST Information**:
  - Roy Fielding's dissertation: https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm

- **HTTP Status Codes Reference**: https://httpstatuses.com/

- **Stack Overflow Tag**: [`rest`] - https://stackoverflow.com/questions/tagged/rest

- **MDN Web Docs**: https://developer.mozilla.org/en-US/docs/Web/HTTP

- **API Design Resources**:
  - REST API Tutorial: https://restfulapi.net/
  - Microsoft REST API Guidelines: https://github.com/microsoft/api-guidelines

- **Testing Tools**:
  - Postman Community: https://community.postman.com/
  - curl Documentation: https://curl.se/docs/

---

## 12. Additional Resources

### Official Documentation

- **Roy Fielding's Dissertation** (Original REST specification): https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm
- **HTTP/1.1 Specification**: https://tools.ietf.org/html/rfc7231
- **HTTP Status Codes**: https://www.iana.org/assignments/http-status-codes/
- **URI Specification**: https://tools.ietf.org/html/rfc3986
- **JSON Specification**: https://www.json.org/

### Recommended Tutorials

- **REST API Tutorial**: https://restfulapi.net/ - Comprehensive guide to REST principles
- **MDN HTTP Guide**: https://developer.mozilla.org/en-US/docs/Web/HTTP - Understanding HTTP fundamentals
- **API Design Patterns**: https://apihandyman.io/ - Best practices for API design
- **Postman Learning Center**: https://learning.postman.com/ - Interactive API testing tutorials

### API Design Guidelines

- **Microsoft REST API Guidelines**: https://github.com/microsoft/api-guidelines - Enterprise-grade REST API standards
- **Google API Design Guide**: https://cloud.google.com/apis/design - Google's approach to API design
- **Zalando RESTful API Guidelines**: https://opensource.zalando.com/restful-api-guidelines/ - Practical REST conventions
- **White House Web API Standards**: https://github.com/whitehouse/api-standards - Government API standards

### Books

- **"RESTful Web APIs" by Leonard Richardson and Mike Amundsen** - Deep dive into REST and hypermedia
- **"REST API Design Rulebook" by Mark Masse** - Practical rules for designing REST APIs
- **"Building Microservices" by Sam Newman** - Includes excellent REST API chapters
- **"Web API Design: The Missing Link" by Brian Mulloy** (Free PDF from Apigee)

### Video Resources

- **REST API concepts and examples**: https://www.youtube.com/watch?v=7YcW25PHnAA
- **What is REST API?**: https://www.youtube.com/watch?v=lsMQRaeKNDk
- **API design best practices**: https://www.youtube.com/watch?v=HkWxJ6nMbqs

### Tools & Testing

- **Postman**: https://www.postman.com/ - API testing and development platform
- **Insomnia**: https://insomnia.rest/ - Alternative REST client
- **HTTPie**: https://httpie.io/ - User-friendly curl alternative
- **Swagger/OpenAPI**: https://swagger.io/ - API documentation standard
- **ReqBin**: https://reqbin.com/ - Online REST API client

### Public REST APIs for Practice

Practice your REST API skills with these free, public APIs:

- **PokeAPI**: https://pokeapi.co/ - Pokemon data (used in this guide)
- **JSONPlaceholder**: https://jsonplaceholder.typicode.com/ - Fake REST API for testing
- **REST Countries**: https://restcountries.com/ - Country data
- **GitHub API**: https://api.github.com/ - Well-designed real-world API
- **OpenWeather API**: https://openweathermap.org/api - Weather data
- **Dog API**: https://dog.ceo/dog-api/ - Random dog images
- **Star Wars API**: https://swapi.dev/ - Star Wars universe data

### Community Resources

- **API Craft Google Group**: https://groups.google.com/g/api-craft - API design discussions
- **r/webdev Reddit**: https://www.reddit.com/r/webdev/ - Web development community
- **Stack Overflow [rest] tag**: https://stackoverflow.com/questions/tagged/rest
- **Dev.to #api tag**: https://dev.to/t/api - Articles about APIs

### Related Technologies

Learn these technologies that complement REST:

- **GraphQL** - Alternative to REST for flexible data querying
  - Learn: https://graphql.org/learn/
  - When: Complex data requirements, mobile apps

- **WebSockets** - Bidirectional, real-time communication
  - Learn: https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API
  - When: Chat apps, live updates, gaming

- **gRPC** - High-performance RPC framework
  - Learn: https://grpc.io/docs/
  - When: Microservices, low latency requirements

- **OpenAPI/Swagger** - API specification format
  - Learn: https://swagger.io/specification/
  - When: Documenting REST APIs

- **JSON:API** - Specification for building APIs in JSON
  - Learn: https://jsonapi.org/
  - When: Need standardized JSON structure

### Next Steps

After mastering REST API principles, consider learning:

1. **ASP.NET Core Web API** (POK-14) - Build your first REST API in .NET
   - Why: Put REST principles into practice
   - You'll learn: Controllers, routing, model binding

2. **HTTP Protocol Deep Dive** - Advanced HTTP features
   - Why: Better understand how REST works under the hood
   - You'll learn: Caching, content negotiation, HTTP/2

3. **API Security** - Secure your REST APIs
   - Why: Production APIs need security
   - You'll learn: JWT, OAuth 2.0, API keys, rate limiting

4. **API Documentation with Swagger** - Document your APIs
   - Why: Good docs are crucial for API adoption
   - You'll learn: OpenAPI spec, Swagger UI, automated docs

5. **Testing REST APIs** - Automated API testing
   - Why: Ensure your API works correctly
   - You'll learn: Integration tests, contract testing, load testing

---

## Appendix

### Glossary

**API (Application Programming Interface)**: A set of rules and protocols that allows different software applications to communicate with each other.

**Client-Server**: An architectural pattern where clients (requesters) are separated from servers (providers of resources).

**CRUD**: Create, Read, Update, Delete - the four basic operations on data.

**Endpoint**: A specific URL where an API can be accessed.

**HATEOAS (Hypermedia as the Engine of Application State)**: REST constraint where responses include links to related resources.

**HTTP (Hypertext Transfer Protocol)**: The protocol used for communication between web clients and servers.

**HTTP Method**: The action to perform on a resource (GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD).

**Idempotent**: An operation that produces the same result regardless of how many times it's executed.

**JSON (JavaScript Object Notation)**: A lightweight data interchange format, commonly used in REST APIs.

**Payload**: The data sent in an HTTP request body or response body.

**Query Parameter**: Parameters added to URL after `?` for filtering, sorting, or pagination (e.g., `?page=1&type=Electric`).

**Representation**: A specific format of a resource (JSON, XML, HTML, etc.).

**Resource**: Any information that can be named and addressed via a URI (users, products, etc.).

**REST (Representational State Transfer)**: An architectural style for designing networked applications.

**RESTful**: An API that follows REST architectural principles.

**Richardson Maturity Model**: A model that categorizes REST APIs into levels 0-3 based on how RESTful they are.

**Safe Method**: An HTTP method that doesn't modify resources (GET, HEAD, OPTIONS).

**Stateless**: Each request contains all information needed; server stores no client context.

**Status Code**: A 3-digit code indicating the result of an HTTP request (200, 404, 500, etc.).

**URI (Uniform Resource Identifier)**: A string that identifies a resource (e.g., `/api/pokemon/25`).

**URL (Uniform Resource Locator)**: A specific type of URI that includes the access mechanism (e.g., `https://api.example.com/pokemon/25`).

### Richardson Maturity Model

The Richardson Maturity Model classifies REST APIs into four levels based on their adherence to REST principles:

```
Level 3: Hypermedia Controls (HATEOAS)
   ↑
   │    Responses include links to related resources
   │    API is self-descriptive
   │
Level 2: HTTP Verbs
   ↑
   │    Uses HTTP methods correctly (GET, POST, PUT, DELETE)
   │    Uses HTTP status codes appropriately
   │
Level 1: Resources
   ↑
   │    Uses resource-based URLs
   │    Individual endpoints for different resources
   │
Level 0: The Swamp of POX (Plain Old XML)
   │
   │    Single endpoint, single HTTP method
   │    Action-based, not resource-based
   └──
```

**Level 0: The Swamp of POX**
```http
POST /api
{
  "action": "getPokemon",
  "id": 25
}

POST /api
{
  "action": "createPokemon",
  "name": "Pikachu"
}
```
- Everything goes to one endpoint
- Uses POST for everything
- Action is in the request body
- Not RESTful at all

**Level 1: Resources**
```http
GET /api/pokemon/25
POST /api/createPokemon
{
  "name": "Pikachu"
}
```
- Different URLs for different resources
- Still uses verbs in URLs
- Still uses POST for most things

**Level 2: HTTP Verbs**
```http
GET    /api/pokemon/25      # Retrieve
POST   /api/pokemon         # Create
PUT    /api/pokemon/25      # Update
DELETE /api/pokemon/25      # Delete
```
- Uses HTTP methods correctly
- Returns appropriate status codes
- No verbs in URLs
- **Most real-world APIs stop here**

**Level 3: Hypermedia Controls (HATEOAS)**
```http
GET /api/pokemon/25

Response:
{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric",
  "links": {
    "self": "/api/pokemon/25",
    "trainer": "/api/trainers/ash",
    "moves": "/api/pokemon/25/moves",
    "evolve": "/api/pokemon/25/evolutions"
  }
}
```
- Responses include links to related resources
- Clients discover actions dynamically
- Fully self-descriptive API
- **True REST**, but rarely implemented

**Most APIs aim for Level 2**, which provides the main benefits of REST without the complexity of full HATEOAS.

### REST vs SOAP vs GraphQL Comparison

| Feature | REST | SOAP | GraphQL |
|---------|------|------|---------|
| **Architecture** | Architectural style | Protocol | Query language |
| **Data Format** | JSON (usually), XML, etc. | XML only | JSON |
| **Transport** | HTTP/HTTPS | HTTP, SMTP, TCP, etc. | HTTP/HTTPS |
| **Learning Curve** | Easy | Steep | Moderate |
| **Performance** | Good | Slower (XML overhead) | Excellent (fetch only needed data) |
| **Caching** | Built-in HTTP caching | Difficult | Requires custom implementation |
| **Versioning** | URL or header versioning | Namespace versioning | Schema evolution |
| **Error Handling** | HTTP status codes | SOAP Fault | Errors in response body |
| **State** | Stateless | Can be stateful | Stateless |
| **Browser Support** | Excellent | Limited | Excellent |
| **Tooling** | Widespread | Enterprise tools | Growing ecosystem |

**When to use each:**

**Use REST when:**
- Building public-facing APIs
- Need simplicity and wide adoption
- Want to leverage HTTP caching
- Building CRUD-focused applications
- Need good browser support

**Use SOAP when:**
- Enterprise environments with existing SOAP infrastructure
- Need built-in security (WS-Security)
- Require ACID transactions
- Banking, payment systems, legacy systems
- Formal contracts (WSDL) are required

**Use GraphQL when:**
- Clients need flexible data fetching
- Mobile apps (avoid over-fetching)
- Complex data relationships
- Multiple clients with different data needs
- Need to aggregate data from multiple sources

**Example comparison:**

```http
# REST - Multiple requests needed
GET /api/trainers/ash
GET /api/trainers/ash/pokemon
GET /api/pokemon/25/moves

# GraphQL - Single request, exact data needed
POST /graphql
{
  trainer(id: "ash") {
    name
    pokemon {
      name
      moves {
        name
        power
      }
    }
  }
}

# SOAP - Verbose XML
POST /PokemonService
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetPokemon xmlns="http://example.com/pokemon">
      <Id>25</Id>
    </GetPokemon>
  </soap:Body>
</soap:Envelope>
```

### HTTP Status Codes Quick Reference

**2xx Success**
- **200 OK**: Request succeeded
- **201 Created**: Resource created successfully
- **202 Accepted**: Request accepted, processing not complete
- **204 No Content**: Success, but no content to return

**3xx Redirection**
- **301 Moved Permanently**: Resource permanently moved
- **302 Found**: Resource temporarily moved
- **304 Not Modified**: Cached version still valid

**4xx Client Errors**
- **400 Bad Request**: Malformed request
- **401 Unauthorized**: Authentication required
- **403 Forbidden**: Authenticated but not authorized
- **404 Not Found**: Resource doesn't exist
- **405 Method Not Allowed**: HTTP method not supported
- **409 Conflict**: Request conflicts with current state
- **422 Unprocessable Entity**: Semantic errors in request
- **429 Too Many Requests**: Rate limit exceeded

**5xx Server Errors**
- **500 Internal Server Error**: Server encountered an error
- **502 Bad Gateway**: Invalid response from upstream server
- **503 Service Unavailable**: Server temporarily unavailable
- **504 Gateway Timeout**: Upstream server timeout

### RESTful API Design Cheat Sheet

```http
# Resource naming
✅ /api/pokemon              # Plural nouns
✅ /api/trainers/ash         # Readable identifiers
✅ /api/pokemon/25/moves     # Nested resources (max 2-3 levels)
✅ /api/pokemon-types        # Hyphens for multi-word

# HTTP Methods
GET    /api/pokemon         # List resources
GET    /api/pokemon/25      # Get specific resource
POST   /api/pokemon         # Create resource
PUT    /api/pokemon/25      # Replace resource (all fields)
PATCH  /api/pokemon/25      # Update resource (partial)
DELETE /api/pokemon/25      # Delete resource

# Query Parameters
?page=1&pageSize=20         # Pagination
?sortBy=name&order=asc      # Sorting
?type=Electric&level=50     # Filtering
?search=pikachu             # Search
?fields=name,type           # Field selection

# Headers
Content-Type: application/json
Accept: application/json
Authorization: Bearer <token>
Cache-Control: max-age=3600
ETag: "abc123"

# Status Codes
200 OK                      # Success with content
201 Created                 # Resource created
204 No Content              # Success, no content
400 Bad Request             # Client error
401 Unauthorized            # Not authenticated
403 Forbidden               # Not authorized
404 Not Found               # Resource doesn't exist
500 Internal Server Error   # Server error

# Response Format
{
  "data": [ /* resources */ ],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "total": 150
  },
  "links": {
    "self": "/api/pokemon?page=1",
    "next": "/api/pokemon?page=2"
  }
}

# Error Format
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable message",
    "statusCode": 400,
    "details": [ /* validation errors */ ]
  }
}
```

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-11-22 | Initial version - Complete REST API Principles guide covering all 12 template sections with beginner-friendly explanations, practical examples, hands-on exercises, Richardson Maturity Model, REST vs SOAP vs GraphQL comparison, and comprehensive resources |

---

**Congratulations!** You've completed the REST API Principles guide. You now have a solid foundation in REST architecture and are ready to build your own RESTful APIs using ASP.NET Core.

**Next recommended reading**: [ASP.NET Core Web API Basics](./aspnetcore-webapi-basics.md) (POK-14) - Learn how to implement these REST principles in .NET!
