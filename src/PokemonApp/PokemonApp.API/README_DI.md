# Dependency Injection in PokemonApp

## What is Dependency Injection?

Dependency Injection (DI) is a design pattern where objects receive their dependencies from external sources rather than creating them internally. ASP.NET Core has built-in DI container.

## Service Lifetimes

- **Transient**: Created each time they're requested
- **Scoped**: Created once per request
- **Singleton**: Created once for the application lifetime

## Currently Registered Services

### DbContext (Scoped)
```csharp
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("DefaultConnection")));
```

The DbContext is registered as Scoped, meaning one instance per HTTP request.

## Next Steps

In the following steps, we will register:
- **Repository** (Scoped) - Data access layer
- **Service** (Scoped) - Business logic layer

These will be injected into controllers via constructor injection.
