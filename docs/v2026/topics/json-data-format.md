# JSON Data Format

---
**Technology Version**: JSON (JavaScript Object Notation)
**Document Version**: 1.0
**Last Updated**: 2026-11-22
**Author**: PokemonApp Team
**Target Audience**: Beginners
**Estimated Reading Time**: 15-20 minutes
---

## 1. Overview & Introduction

### What is JSON?

JSON (JavaScript Object Notation) is a lightweight text format for storing and exchanging data. Despite its name, JSON is language-independent and can be used with any programming language, including C#.

Think of JSON as a simple way to write down structured information in a text file. It's like writing a shopping list, but in a format that both humans and computers can easily read and understand.

### Why Use JSON?

JSON has become the most popular format for sending data between web applications, APIs, and services. You should use JSON when:

- **Sending data between a web API and a client** - JSON is the standard format for REST APIs
- **Storing configuration settings** - Many applications use JSON files for configuration (like `appsettings.json` in .NET)
- **Saving data in a readable format** - JSON is easy to read and edit by hand
- **Working with JavaScript** - JSON is the native data format for JavaScript

### When to Use It

**Good use cases:**
- RESTful web APIs (sending/receiving data)
- Configuration files
- Data exchange between different systems
- Storing structured data in a NoSQL database

**Not recommended for:**
- Very large datasets (consider binary formats like Protocol Buffers)
- Data that needs to be secret or encrypted (JSON is plain text)
- Complex documents with metadata (XML might be better)

---

## 2. Quick Start

**TL;DR - JSON in 2 minutes:**

JSON uses two main structures:
- **Objects**: Collections of key-value pairs in curly braces `{}`
- **Arrays**: Ordered lists of values in square brackets `[]`

**Simple JSON example:**
```json
{
  "name": "Pikachu",
  "type": "Electric",
  "level": 25,
  "moves": ["Thunderbolt", "Quick Attack", "Iron Tail"],
  "isWild": false
}
```

**What you're looking at:**
- Strings are in double quotes: `"Pikachu"`
- Numbers don't need quotes: `25`
- Booleans are lowercase: `true` or `false`
- Arrays use square brackets: `["item1", "item2"]`
- Objects use curly braces: `{ "key": "value" }`

---

## 3. Basic Usage

### JSON Syntax Rules

JSON has very simple syntax rules:

**Data Types:**
- **String**: Text in double quotes - `"Hello"`
- **Number**: Integer or decimal - `42` or `3.14`
- **Boolean**: `true` or `false`
- **Null**: `null` (represents no value)
- **Array**: Ordered list - `[1, 2, 3]`
- **Object**: Key-value pairs - `{"key": "value"}`

**Important Rules:**
1. Property names must be in double quotes
2. String values must be in double quotes (single quotes don't work)
3. No trailing commas allowed
4. No comments allowed in standard JSON

### JSON Objects

Objects store data as key-value pairs:

```json
{
  "id": 25,
  "name": "Pikachu",
  "type": "Electric"
}
```

### JSON Arrays

Arrays store ordered lists of values:

```json
{
  "types": ["Electric", "Fire", "Water"],
  "levels": [5, 10, 15, 20]
}
```

### Nested JSON

You can nest objects and arrays inside each other:

```json
{
  "pokemon": {
    "name": "Charizard",
    "types": ["Fire", "Flying"],
    "stats": {
      "hp": 78,
      "attack": 84,
      "defense": 78
    }
  }
}
```

### JSON vs XML

Both JSON and XML can store structured data, but JSON is simpler and more popular for modern web applications.

**Same data in JSON:**
```json
{
  "pokemon": {
    "name": "Bulbasaur",
    "type": "Grass",
    "level": 10
  }
}
```

**Same data in XML:**
```xml
<pokemon>
  <name>Bulbasaur</name>
  <type>Grass</type>
  <level>10</level>
</pokemon>
```

**Key Differences:**

| Feature | JSON | XML |
|---------|------|-----|
| **Readability** | More concise and easier to read | More verbose with opening/closing tags |
| **Data Types** | Has native types (string, number, boolean, null) | Everything is text |
| **Arrays** | Built-in array syntax `[]` | Need repeated elements |
| **Size** | Smaller file size | Larger due to tags |
| **Comments** | Not supported | Supports comments |
| **Attributes** | Not supported | Supports element attributes |

**When to choose JSON:**
- Building REST APIs
- Working with JavaScript
- Need simple, lightweight format
- Speed and efficiency matter

**When to choose XML:**
- Need document metadata and attributes
- Working with legacy systems
- Need comments in data files
- Complex document structure with mixed content

---

## 4. Practical Examples

### Working with JSON in C#

.NET provides built-in support for JSON through the `System.Text.Json` namespace (recommended) or the older `Newtonsoft.Json` library.

### Example 1: Creating a Simple C# Class for JSON

**Scenario:** You want to represent Pokemon data that can be converted to/from JSON.

**Code:**
```csharp
public class Pokemon
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }
    public int Level { get; set; }
    public bool IsWild { get; set; }
}
```

This C# class matches the structure of our JSON data.

---

### Example 2: Serialization (C# Object → JSON)

**Scenario:** You have a Pokemon object and want to convert it to JSON text.

**Code:**
```csharp
using System.Text.Json;

// Create a Pokemon object
var pikachu = new Pokemon
{
    Id = 25,
    Name = "Pikachu",
    Type = "Electric",
    Level = 25,
    IsWild = false
};

// Convert to JSON string
string jsonString = JsonSerializer.Serialize(pikachu);
Console.WriteLine(jsonString);
```

**Output:**
```json
{"Id":25,"Name":"Pikachu","Type":"Electric","Level":25,"IsWild":false}
```

**Prettier output with indentation:**
```csharp
var options = new JsonSerializerOptions { WriteIndented = true };
string jsonString = JsonSerializer.Serialize(pikachu, options);
Console.WriteLine(jsonString);
```

**Output:**
```json
{
  "Id": 25,
  "Name": "Pikachu",
  "Type": "Electric",
  "Level": 25,
  "IsWild": false
}
```

---

### Example 3: Deserialization (JSON → C# Object)

**Scenario:** You receive JSON from an API and want to convert it to a C# object.

**Code:**
```csharp
using System.Text.Json;

// JSON string from API
string jsonString = @"{
  ""Id"": 25,
  ""Name"": ""Pikachu"",
  ""Type"": ""Electric"",
  ""Level"": 25,
  ""IsWild"": false
}";

// Convert JSON to C# object
Pokemon pikachu = JsonSerializer.Deserialize<Pokemon>(jsonString);

// Use the object
Console.WriteLine($"Pokemon: {pikachu.Name}, Level: {pikachu.Level}");
```

**Output:**
```
Pokemon: Pikachu, Level: 25
```

---

### Example 4: Working with Collections

**Scenario:** You have a list of Pokemon to serialize.

**Code:**
```csharp
using System.Text.Json;
using System.Collections.Generic;

// Create a list of Pokemon
var pokemonList = new List<Pokemon>
{
    new Pokemon { Id = 1, Name = "Bulbasaur", Type = "Grass", Level = 5, IsWild = true },
    new Pokemon { Id = 4, Name = "Charmander", Type = "Fire", Level = 5, IsWild = true },
    new Pokemon { Id = 7, Name = "Squirtle", Type = "Water", Level = 5, IsWild = true }
};

// Serialize to JSON
var options = new JsonSerializerOptions { WriteIndented = true };
string jsonString = JsonSerializer.Serialize(pokemonList, options);
Console.WriteLine(jsonString);
```

**Output:**
```json
[
  {
    "Id": 1,
    "Name": "Bulbasaur",
    "Type": "Grass",
    "Level": 5,
    "IsWild": true
  },
  {
    "Id": 4,
    "Name": "Charmander",
    "Type": "Fire",
    "Level": 5,
    "IsWild": true
  },
  {
    "Id": 7,
    "Name": "Squirtle",
    "Type": "Water",
    "Level": 5,
    "IsWild": true
  }
]
```

**Deserializing a list:**
```csharp
List<Pokemon> pokemonList = JsonSerializer.Deserialize<List<Pokemon>>(jsonString);
Console.WriteLine($"Found {pokemonList.Count} Pokemon");
```

---

### Example 5: Customizing Property Names

**Scenario:** Your C# property names don't match the JSON format (e.g., API uses snake_case).

**Code:**
```csharp
using System.Text.Json.Serialization;

public class Pokemon
{
    [JsonPropertyName("id")]
    public int Id { get; set; }

    [JsonPropertyName("pokemon_name")]
    public string Name { get; set; }

    [JsonPropertyName("pokemon_type")]
    public string Type { get; set; }
}
```

This will produce JSON like:
```json
{
  "id": 25,
  "pokemon_name": "Pikachu",
  "pokemon_type": "Electric"
}
```

---

### Example 6: Reading JSON from a File

**Scenario:** You have a JSON configuration file you need to read.

**Code:**
```csharp
using System.Text.Json;
using System.IO;

// Read JSON from file
string jsonString = File.ReadAllText("pokemon.json");

// Deserialize
Pokemon pokemon = JsonSerializer.Deserialize<Pokemon>(jsonString);
Console.WriteLine($"Loaded: {pokemon.Name}");
```

**Writing JSON to a file:**
```csharp
var pikachu = new Pokemon { Id = 25, Name = "Pikachu", Type = "Electric", Level = 25 };

var options = new JsonSerializerOptions { WriteIndented = true };
string jsonString = JsonSerializer.Serialize(pikachu, options);

File.WriteAllText("pikachu.json", jsonString);
```

---

## 5. Common Pitfalls

### 1. Forgetting Double Quotes on Property Names

**Wrong:**
```json
{
  name: "Pikachu"
}
```

**Correct:**
```json
{
  "name": "Pikachu"
}
```

**Why it matters:** JSON requires property names to be in double quotes. Without them, the JSON is invalid.

---

### 2. Using Single Quotes Instead of Double Quotes

**Wrong:**
```json
{
  "name": 'Pikachu'
}
```

**Correct:**
```json
{
  "name": "Pikachu"
}
```

**Why it matters:** JSON only accepts double quotes for strings. Single quotes will cause parsing errors.

---

### 3. Trailing Commas

**Wrong:**
```json
{
  "name": "Pikachu",
  "level": 25,
}
```

**Correct:**
```json
{
  "name": "Pikachu",
  "level": 25
}
```

**Why it matters:** JSON doesn't allow trailing commas. Many developers add them out of habit from other languages, but they cause JSON parsing to fail.

---

### 4. Not Handling Null Values

**Code:**
```csharp
string jsonString = @"{""Name"": null}";
Pokemon pokemon = JsonSerializer.Deserialize<Pokemon>(jsonString);

// This will be null!
Console.WriteLine(pokemon.Name.ToUpper()); // NullReferenceException!
```

**Better approach:**
```csharp
if (!string.IsNullOrEmpty(pokemon.Name))
{
    Console.WriteLine(pokemon.Name.ToUpper());
}
```

**Why it matters:** JSON allows `null` values, which can cause NullReferenceException in C# if not handled.

---

### 5. Case Sensitivity Issues

By default, `System.Text.Json` is case-sensitive when deserializing:

**JSON:**
```json
{
  "name": "Pikachu"
}
```

**C# Class:**
```csharp
public class Pokemon
{
    public string Name { get; set; }  // Capital 'N'
}
```

**Problem:** The property won't be populated because "name" doesn't match "Name".

**Solution:** Use case-insensitive options:
```csharp
var options = new JsonSerializerOptions
{
    PropertyNameCaseInsensitive = true
};
Pokemon pokemon = JsonSerializer.Deserialize<Pokemon>(jsonString, options);
```

---

### 6. Trying to Add Comments

**Wrong:**
```json
{
  // This is a comment
  "name": "Pikachu"
}
```

**Why it doesn't work:** Standard JSON doesn't support comments. If you need comments, consider:
- Using JSONC (JSON with Comments) in configuration files
- Putting documentation in a separate file
- Using a property for metadata: `"_comment": "This is a note"`

---

### 7. Forgetting Async Operations

When reading JSON from web APIs, always use async methods:

**Less efficient (blocking):**
```csharp
HttpClient client = new HttpClient();
string json = client.GetStringAsync(url).Result;  // Blocks thread!
```

**Better (async):**
```csharp
HttpClient client = new HttpClient();
string json = await client.GetStringAsync(url);  // Non-blocking
```

---

### 8. Not Validating JSON Before Deserializing

**Problem:** Invalid JSON will throw an exception.

**Solution:** Wrap deserialization in try-catch:
```csharp
try
{
    Pokemon pokemon = JsonSerializer.Deserialize<Pokemon>(jsonString);
}
catch (JsonException ex)
{
    Console.WriteLine($"Invalid JSON: {ex.Message}");
    // Handle error gracefully
}
```

---

### 9. Memory Issues with Large JSON

**Problem:** Loading huge JSON files into memory can cause performance issues.

**Solution:** Use streaming for large files:
```csharp
using FileStream stream = File.OpenRead("large-pokemon-data.json");
List<Pokemon> pokemonList = await JsonSerializer.DeserializeAsync<List<Pokemon>>(stream);
```

---

### 10. Circular References

**Problem:** Objects that reference each other create infinite loops:

```csharp
public class Trainer
{
    public string Name { get; set; }
    public Pokemon FavoritePokemon { get; set; }
}

public class Pokemon
{
    public string Name { get; set; }
    public Trainer Owner { get; set; }  // Circular reference!
}
```

**Solution:** Use `JsonIgnore` or configure reference handling:
```csharp
public class Pokemon
{
    public string Name { get; set; }

    [JsonIgnore]  // Skip this property during serialization
    public Trainer Owner { get; set; }
}
```

---

## Summary

JSON is the standard format for data exchange in modern web applications. Key takeaways:

- **Simple syntax**: Objects use `{}`, arrays use `[]`, and data types are straightforward
- **Language-independent**: Works with any programming language
- **C# Integration**: Use `System.Text.Json` for serialization and deserialization
- **Watch out for**: Trailing commas, single quotes, case sensitivity, and null values
- **Best for**: REST APIs, configuration files, and data exchange between systems

**Next Steps:**
- Practice serializing and deserializing objects in C#
- Explore the `System.Text.Json` namespace documentation
- Build a simple API that sends/receives JSON
- Learn about JSON Schema for validating JSON structure

---

## Additional Resources

### Official Documentation
- [JSON.org](https://www.json.org/) - Official JSON specification
- [System.Text.Json Documentation](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json-overview) - Microsoft's JSON library
- [JSON Serialization Guide](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json-how-to)

### Tools
- [JSONLint](https://jsonlint.com/) - Validate and format JSON
- [JSON Formatter](https://jsonformatter.org/) - Pretty-print JSON
- [QuickType](https://quicktype.io/) - Generate C# classes from JSON

### Related Topics
- **REST APIs** - Learn how APIs use JSON for communication
- **HTTP Clients** - Making API requests with HttpClient in C#
- **Configuration Files** - Using `appsettings.json` in .NET applications
