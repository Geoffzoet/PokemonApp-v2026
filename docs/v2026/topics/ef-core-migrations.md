# EF Core Migrations

**Estimated Reading Time**: 55 minutes

## Table of Contents
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [Core Concepts & Theory](#core-concepts--theory)
- [Installation Guide](#installation-guide)
- [Initial Setup & Configuration](#initial-setup--configuration)
- [Basic Usage](#basic-usage)
- [Testing & Validation](#testing--validation)
- [Practical Examples](#practical-examples)
- [Common Patterns & Best Practices](#common-patterns--best-practices)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)

## Overview

### What Are Migrations?

**Migrations** are Entity Framework Core's way of keeping your database schema in sync with your C# entity classes. Think of migrations as "version control for your database" - they track every change you make to your data model and can apply those changes to any database.

**Real-World Analogy**: Imagine you're writing a book, and your editor requests changes. Instead of manually rewriting every copy of the book that's already been printed, you create a "diff" that shows exactly what changed from version 1 to version 2. Migrations work the same way - they generate the minimum set of SQL commands needed to update a database from one version to another.

### Why Use Migrations?

**Without migrations**, you would need to:
- Manually write SQL scripts for every schema change
- Track which scripts have been applied to which database
- Risk data loss when making structural changes
- Coordinate database changes across team members

**With migrations**, you get:
- Automatic schema synchronization
- Version-controlled database changes
- Safe, repeatable deployments
- Automatic rollback capability
- Built-in change tracking

### When to Use Migrations

Migrations are essential when:
- Building applications with evolving data models
- Working in teams where multiple developers modify entities
- Deploying to multiple environments (dev, staging, production)
- Need to preserve existing data during schema changes
- Want to track the history of database structure changes

### Key Benefits

| Benefit | Description |
|---------|-------------|
| **Automatic SQL Generation** | EF Core creates the SQL for you based on model changes |
| **Version Control** | Each migration is a versioned file you can commit to git |
| **Team Collaboration** | Developers can share and merge database changes |
| **Safe Updates** | Migrations preserve existing data during schema changes |
| **Rollback Support** | Can undo changes if something goes wrong |
| **Environment Consistency** | Same migration applies to dev, test, and production |

---

## Quick Start

Here's the fastest way to get started with migrations:

```bash
# 1. Install EF Core tools (one-time setup)
dotnet tool install --global dotnet-ef

# 2. Create your first migration
dotnet ef migrations add InitialCreate

# 3. Apply migration to create/update database
dotnet ef database update

# 4. View migration status
dotnet ef migrations list
```

**Result**: Your database now matches your entity model, and you have a migration file tracking this initial schema.

---

## Prerequisites

### Required Knowledge

Before working with migrations, you should understand:
- **C# Classes and Properties**: Migrations are generated from your entity classes
- **Entity Framework Core Basics**: DbContext, DbSet, entities (see [EF Core Fundamentals](entity-framework-core-fundamentals.md))
- **Command Line Interface**: Running dotnet commands
- **Basic SQL** (helpful): Understanding CREATE TABLE, ALTER TABLE helps when reviewing migrations

### Required Tools

| Tool | Version | Purpose |
|------|---------|---------|
| .NET SDK | 8.0+ | Core framework |
| dotnet-ef CLI | 8.0+ | Migration commands |
| Database | Any | SQLite, SQL Server, PostgreSQL, etc. |

### Verify Your Setup

```bash
# Check .NET SDK
dotnet --version
# Should show: 8.0.x or higher

# Check EF Core tools (install first if needed)
dotnet ef --version
# Should show: Entity Framework Core .NET Command-line Tools 8.0.x
```

---

## Core Concepts & Theory

### 1. What Is a Migration?

A **migration** is a C# class containing two methods:
- `Up()` - applies the change (e.g., creates a table)
- `Down()` - reverts the change (e.g., drops a table)

**Example of what EF Core generates**:

```csharp
public partial class InitialCreate : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "Products",
            columns: table => new
            {
                Id = table.Column<int>(nullable: false)
                    .Annotation("SqlServer:Identity", "1, 1"),
                Name = table.Column<string>(maxLength: 100, nullable: false),
                Price = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_Products", x => x.Id);
            });
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(name: "Products");
    }
}
```

### 2. Migration Workflow

The typical migration workflow:

```
1. Modify Entity Classes
   └─> Add/remove/change properties

2. Create Migration
   └─> dotnet ef migrations add <Name>
   └─> EF compares model to last migration
   └─> Generates C# migration file

3. Review Migration Code
   └─> Check the generated Up()/Down() methods
   └─> Verify SQL will do what you expect

4. Apply Migration
   └─> dotnet ef database update
   └─> Executes migration against database
   └─> Updates __EFMigrationsHistory table

5. Commit Migration File
   └─> Add migration to version control
```

### 3. How EF Core Tracks Migrations

EF Core creates a special table called `__EFMigrationsHistory`:

```sql
CREATE TABLE [__EFMigrationsHistory] (
    [MigrationId] nvarchar(150) NOT NULL,
    [ProductVersion] nvarchar(32) NOT NULL,
    CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
);
```

**Each row represents an applied migration**:

| MigrationId | ProductVersion |
|-------------|----------------|
| 20261122120000_InitialCreate | 8.0.0 |
| 20261122130000_AddCategory | 8.0.0 |
| 20261122140000_AddIndexes | 8.0.0 |

This table ensures migrations are applied only once and in the correct order.

### 4. Model Snapshot

Along with migrations, EF Core maintains a **model snapshot** (`<ContextName>ModelSnapshot.cs`):
- Represents the current state of your entire model
- Used to calculate differences when creating new migrations
- Should always match your latest entity classes

**You typically don't edit this file manually** - EF Core manages it.

### 5. Migration Naming

Migrations are named with a timestamp prefix:
- `20261122120000_InitialCreate.cs`
- Format: `{timestamp}_{YourName}.cs`
- Timestamp ensures correct ordering

**Naming Best Practices**:
- Use descriptive names: `AddUserEmail`, `CreateOrdersTable`, `AddIndexToProducts`
- Use PascalCase: `AddProductCategory` not `add_product_category`
- Be specific: `AddEmailToUser` is better than `UpdateUser`

### 6. Data Seeding in Migrations

Migrations can include data:

```csharp
protected override void Up(MigrationBuilder migrationBuilder)
{
    migrationBuilder.InsertData(
        table: "Categories",
        columns: new[] { "Id", "Name" },
        values: new object[] { 1, "Electronics" });
}
```

This ensures reference data is available after migration.

### 7. Schema vs Data Migrations

| Migration Type | Purpose | Example |
|----------------|---------|---------|
| **Schema Migration** | Changes table structure | Add column, create index |
| **Data Migration** | Modifies existing data | Update old values, populate new column |

Both can be in the same migration file.

### 8. Idempotent Migrations

An **idempotent migration** can be applied multiple times with the same result. EF Core migrations are idempotent because:
- They check `__EFMigrationsHistory` before applying
- Won't re-run if already applied
- Safe to run on any database, regardless of current state

### 9. Code-First vs Database-First

**Code-First** (what we're covering):
- Define entities in C#
- Generate migrations from code
- Apply to database

**Database-First** (alternative):
- Design database in SQL
- Reverse-engineer to C# entities
- Use `dotnet ef dbcontext scaffold`

Migrations are primarily for **Code-First** workflows.

---

## Installation Guide

### Installing EF Core Tools

The `dotnet ef` command-line tool is required for migrations.

#### Global Installation (Recommended)

Install once for all projects:

```bash
dotnet tool install --global dotnet-ef
```

**Verify installation**:

```bash
dotnet ef --version
# Output: Entity Framework Core .NET Command-line Tools
#         8.0.11
```

#### Update Existing Tools

If you already have an older version:

```bash
dotnet tool update --global dotnet-ef
```

#### Local Installation (Project-Specific)

For projects with specific tool versions:

```bash
# Create tool manifest (first time only)
dotnet new tool-manifest

# Install locally
dotnet tool install dotnet-ef

# Run with dotnet prefix
dotnet dotnet-ef --version
```

### Installing EF Core Design Package

Your project needs the design-time package:

```bash
dotnet add package Microsoft.EntityFrameworkCore.Design
```

**Complete package list for migrations**:

```xml
<ItemGroup>
  <!-- Core EF Core -->
  <PackageReference Include="Microsoft.EntityFrameworkCore" Version="8.0.11" />

  <!-- Design-time tools (required for migrations) -->
  <PackageReference Include="Microsoft.EntityFrameworkCore.Design" Version="8.0.11">
    <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
    <PrivateAssets>all</PrivateAssets>
  </PackageReference>

  <!-- Database provider (choose one) -->
  <PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="8.0.11" />
  <!-- OR -->
  <PackageReference Include="Microsoft.EntityFrameworkCore.Sqlite" Version="8.0.11" />
  <!-- OR -->
  <PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL" Version="8.0.11" />
</ItemGroup>
```

### Troubleshooting Installation

**Problem**: `dotnet ef` not found after installation

**Solution**:
```bash
# Check if tools directory is in PATH
echo $PATH | grep .dotnet

# Add to PATH (macOS/Linux)
export PATH="$PATH:$HOME/.dotnet/tools"

# Add to PATH (Windows PowerShell)
$env:Path += ";$HOME\.dotnet\tools"

# Make permanent by adding to .bashrc / .zshrc / PowerShell profile
```

**Problem**: "No executable found matching command 'dotnet-ef'"

**Solution**:
```bash
# Uninstall and reinstall
dotnet tool uninstall --global dotnet-ef
dotnet tool install --global dotnet-ef
```

---

## Initial Setup & Configuration

### Project Structure for Migrations

Recommended folder structure:

```
MyProject/
├── Data/
│   ├── AppDbContext.cs          # Your DbContext
│   └── Entities/
│       ├── Product.cs
│       └── Category.cs
├── Migrations/                   # Auto-generated by EF Core
│   ├── 20261122120000_InitialCreate.cs
│   ├── 20261122120000_InitialCreate.Designer.cs
│   └── AppDbContextModelSnapshot.cs
└── Program.cs
```

### DbContext Configuration

Ensure your DbContext is properly configured:

```csharp
public class AppDbContext : DbContext
{
    public DbSet<Product> Products { get; set; }
    public DbSet<Category> Categories { get; set; }

    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    // Optional: OnConfiguring for tools support
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {
            // Design-time configuration (for migrations)
            optionsBuilder.UseSqlite("Data Source=app.db");
        }
    }
}
```

**Why OnConfiguring?** The migrations tools need to instantiate your DbContext. If you only configure it in `Program.cs`, the tools can't find your connection string.

### Alternative: Design-Time Factory

For more complex scenarios, create a factory:

```csharp
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

public class AppDbContextFactory : IDesignTimeDbContextFactory<AppDbContext>
{
    public AppDbContext CreateDbContext(string[] args)
    {
        var optionsBuilder = new DbContextOptionsBuilder<AppDbContext>();
        optionsBuilder.UseSqlite("Data Source=app.db");

        return new AppDbContext(optionsBuilder.Options);
    }
}
```

**When to use factory**:
- Connection string comes from environment variables
- Need different settings for design-time vs runtime
- Multiple DbContexts in one project

### Configuration in Program.cs

For ASP.NET Core applications:

```csharp
var builder = WebApplication.CreateBuilder(args);

// Register DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("DefaultConnection")));

var app = builder.Build();

// Optional: Apply migrations on startup (see Common Patterns section)
// using (var scope = app.Services.CreateScope())
// {
//     var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
//     db.Database.Migrate();
// }

app.Run();
```

**appsettings.json**:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Data Source=app.db"
  }
}
```

---

## Basic Usage

### Creating Your First Migration

**Step 1**: Define your entity classes

```csharp
public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
}
```

**Step 2**: Add DbSet to DbContext

```csharp
public class AppDbContext : DbContext
{
    public DbSet<Product> Products { get; set; }

    // ... constructor and configuration
}
```

**Step 3**: Create migration

```bash
dotnet ef migrations add InitialCreate
```

**Output**:
```
Build started...
Build succeeded.
Done. To undo this action, use 'dotnet ef migrations remove'
```

**What was created**:
- `Migrations/20261122120000_InitialCreate.cs` - Migration file
- `Migrations/20261122120000_InitialCreate.Designer.cs` - Metadata
- `Migrations/AppDbContextModelSnapshot.cs` - Current model state

### Applying Migrations

**Apply all pending migrations**:

```bash
dotnet ef database update
```

**Output**:
```
Build started...
Build succeeded.
Applying migration '20261122120000_InitialCreate'.
Done.
```

**Verify in SQLite**:
```bash
sqlite3 app.db ".tables"
# Output: Products  __EFMigrationsHistory
```

### Reviewing Migration Code

Open `Migrations/20261122120000_InitialCreate.cs`:

```csharp
public partial class InitialCreate : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "Products",
            columns: table => new
            {
                Id = table.Column<int>(type: "INTEGER", nullable: false)
                    .Annotation("Sqlite:Autoincrement", true),
                Name = table.Column<string>(type: "TEXT", nullable: false),
                Price = table.Column<decimal>(type: "TEXT", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_Products", x => x.Id);
            });
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(name: "Products");
    }
}
```

**Key points**:
- `Up()` creates the Products table
- `Down()` drops the Products table (for rollback)
- Primary key is automatically configured
- SQLite uses `INTEGER AUTOINCREMENT` for `Id`

### Adding Another Migration

**Step 1**: Modify your entity

```csharp
public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
    public string Description { get; set; }  // NEW PROPERTY
}
```

**Step 2**: Create migration

```bash
dotnet ef migrations add AddProductDescription
```

**Step 3**: Review generated code

```csharp
public partial class AddProductDescription : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.AddColumn<string>(
            name: "Description",
            table: "Products",
            type: "TEXT",
            nullable: false,
            defaultValue: "");
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropColumn(
            name: "Description",
            table: "Products");
    }
}
```

**Step 4**: Apply migration

```bash
dotnet ef database update
```

### Removing a Migration

If you haven't applied a migration yet, you can remove it:

```bash
# Remove the last migration (only if not applied)
dotnet ef migrations remove
```

**Important**: You can only remove unapplied migrations. If you've already run `database update`, see the rollback section.

### Listing Migrations

**View all migrations**:

```bash
dotnet ef migrations list
```

**Output**:
```
20261122120000_InitialCreate (Applied)
20261122130000_AddProductDescription (Applied)
20261122140000_AddCategory (Pending)
```

### Generating SQL Scripts

**Preview SQL without applying**:

```bash
dotnet ef migrations script
```

**Generate SQL for specific migration range**:

```bash
# From beginning to specific migration
dotnet ef migrations script 0 AddProductDescription

# Between two migrations
dotnet ef migrations script InitialCreate AddCategory
```

**Output to file**:

```bash
dotnet ef migrations script > migration.sql
```

**Use case**: Useful for reviewing SQL or applying migrations manually in production.

---

## Testing & Validation

### Verifying Migration Was Applied

**Method 1: Check database directly**

```bash
# SQLite
sqlite3 app.db "SELECT * FROM __EFMigrationsHistory;"

# SQL Server (using sqlcmd)
sqlcmd -S localhost -d MyDatabase -Q "SELECT * FROM __EFMigrationsHistory"

# PostgreSQL (using psql)
psql -d mydb -c "SELECT * FROM \"__EFMigrationsHistory\";"
```

**Method 2: EF Core API**

```csharp
using Microsoft.EntityFrameworkCore;

public class MigrationTester
{
    public static async Task CheckMigrations(AppDbContext context)
    {
        var pendingMigrations = await context.Database.GetPendingMigrationsAsync();
        var appliedMigrations = await context.Database.GetAppliedMigrationsAsync();

        Console.WriteLine("Applied migrations:");
        foreach (var migration in appliedMigrations)
        {
            Console.WriteLine($"  - {migration}");
        }

        Console.WriteLine("\nPending migrations:");
        foreach (var migration in pendingMigrations)
        {
            Console.WriteLine($"  - {migration}");
        }
    }
}
```

**Method 3: EF Core CLI**

```bash
dotnet ef migrations list
```

### Testing Migration Rollback

**Rollback to previous migration**:

```bash
# Rollback to specific migration
dotnet ef database update InitialCreate

# Rollback all migrations (empty database)
dotnet ef database update 0
```

**Verify rollback**:

```bash
dotnet ef migrations list
# Should show migrations as "Pending" after rollback
```

### Testing in Development

**Complete test workflow**:

```bash
# 1. Apply all migrations
dotnet ef database update

# 2. Test your application
dotnet run

# 3. If issues found, rollback
dotnet ef database update PreviousMigration

# 4. Fix entity models

# 5. Create new migration
dotnet ef migrations add FixIssue

# 6. Apply and test again
dotnet ef database update
```

### Integration Testing Migrations

Create a test to verify migrations work:

```csharp
using Microsoft.EntityFrameworkCore;
using Xunit;

public class MigrationTests
{
    [Fact]
    public async Task CanApplyAllMigrations()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseSqlite("Data Source=:memory:")
            .Options;

        // Act & Assert
        await using var context = new AppDbContext(options);

        // This applies all migrations
        await context.Database.MigrateAsync();

        // Verify database was created
        var canConnect = await context.Database.CanConnectAsync();
        Assert.True(canConnect);

        // Verify migrations were applied
        var appliedMigrations = await context.Database.GetAppliedMigrationsAsync();
        Assert.NotEmpty(appliedMigrations);
    }
}
```

### Validation Checklist

Before deploying migrations to production:

- [ ] All migrations build without errors
- [ ] `dotnet ef migrations list` shows expected migrations
- [ ] Test applying migrations to empty database
- [ ] Test applying migrations to database with existing data
- [ ] Review generated SQL (`dotnet ef migrations script`)
- [ ] Test rollback scenarios
- [ ] Verify data is preserved after migration
- [ ] Check for any breaking changes
- [ ] Confirm proper indexing and constraints

---

## Practical Examples

### Example 1: Adding a New Table

**Scenario**: Add a `Category` table with a relationship to `Product`.

**Step 1**: Define entities

```csharp
public class Category
{
    public int Id { get; set; }
    public string Name { get; set; }

    // Navigation property
    public List<Product> Products { get; set; }
}

public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }

    // Foreign key
    public int CategoryId { get; set; }

    // Navigation property
    public Category Category { get; set; }
}
```

**Step 2**: Update DbContext

```csharp
public class AppDbContext : DbContext
{
    public DbSet<Product> Products { get; set; }
    public DbSet<Category> Categories { get; set; }  // NEW
}
```

**Step 3**: Create migration

```bash
dotnet ef migrations add AddCategoryTable
```

**Generated migration**:

```csharp
public partial class AddCategoryTable : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        // Create Categories table
        migrationBuilder.CreateTable(
            name: "Categories",
            columns: table => new
            {
                Id = table.Column<int>(nullable: false)
                    .Annotation("Sqlite:Autoincrement", true),
                Name = table.Column<string>(nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_Categories", x => x.Id);
            });

        // Add foreign key to Products
        migrationBuilder.AddColumn<int>(
            name: "CategoryId",
            table: "Products",
            nullable: false,
            defaultValue: 1);  // Default for existing products

        migrationBuilder.CreateIndex(
            name: "IX_Products_CategoryId",
            table: "Products",
            column: "CategoryId");

        migrationBuilder.AddForeignKey(
            name: "FK_Products_Categories_CategoryId",
            table: "Products",
            column: "CategoryId",
            principalTable: "Categories",
            principalColumn: "Id",
            onDelete: ReferentialAction.Cascade);
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropForeignKey(
            name: "FK_Products_Categories_CategoryId",
            table: "Products");

        migrationBuilder.DropIndex(
            name: "IX_Products_CategoryId",
            table: "Products");

        migrationBuilder.DropColumn(
            name: "CategoryId",
            table: "Products");

        migrationBuilder.DropTable(
            name: "Categories");
    }
}
```

**Step 4**: Apply migration

```bash
dotnet ef database update
```

### Example 2: Seeding Reference Data

**Scenario**: Add initial categories when creating the Categories table.

**Step 1**: Override `OnModelCreating` in DbContext

```csharp
public class AppDbContext : DbContext
{
    public DbSet<Category> Categories { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Category>().HasData(
            new Category { Id = 1, Name = "Electronics" },
            new Category { Id = 2, Name = "Books" },
            new Category { Id = 3, Name = "Clothing" }
        );
    }
}
```

**Step 2**: Create migration

```bash
dotnet ef migrations add SeedCategories
```

**Generated migration**:

```csharp
public partial class SeedCategories : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.InsertData(
            table: "Categories",
            columns: new[] { "Id", "Name" },
            values: new object[] { 1, "Electronics" });

        migrationBuilder.InsertData(
            table: "Categories",
            columns: new[] { "Id", "Name" },
            values: new object[] { 2, "Books" });

        migrationBuilder.InsertData(
            table: "Categories",
            columns: new[] { "Id", "Name" },
            values: new object[] { 3, "Clothing" });
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DeleteData(
            table: "Categories",
            keyColumn: "Id",
            keyValue: 1);

        migrationBuilder.DeleteData(
            table: "Categories",
            keyColumn: "Id",
            keyValue: 2);

        migrationBuilder.DeleteData(
            table: "Categories",
            keyColumn: "Id",
            keyValue: 3);
    }
}
```

**Step 3**: Apply migration

```bash
dotnet ef database update
```

### Example 3: Renaming a Column

**Scenario**: Rename `Product.Name` to `Product.ProductName`.

**Step 1**: Rename property in entity

```csharp
public class Product
{
    public int Id { get; set; }
    public string ProductName { get; set; }  // Renamed from Name
    public decimal Price { get; set; }
}
```

**Step 2**: Create migration

```bash
dotnet ef migrations add RenameProductName
```

**Problem**: EF Core generates DROP + CREATE instead of RENAME:

```csharp
// WRONG - loses data!
migrationBuilder.DropColumn(name: "Name", table: "Products");
migrationBuilder.AddColumn<string>(name: "ProductName", table: "Products");
```

**Step 3**: Manually edit migration to use RENAME

```csharp
public partial class RenameProductName : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.RenameColumn(
            name: "Name",
            table: "Products",
            newName: "ProductName");
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.RenameColumn(
            name: "ProductName",
            table: "Products",
            newName: "Name");
    }
}
```

**Step 4**: Apply migration

```bash
dotnet ef database update
```

### Example 4: Adding an Index

**Scenario**: Add an index to `Product.Name` for faster searches.

**Step 1**: Configure index in `OnModelCreating`

```csharp
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder.Entity<Product>()
        .HasIndex(p => p.Name)
        .HasDatabaseName("IX_Products_Name");
}
```

**Step 2**: Create migration

```bash
dotnet ef migrations add AddProductNameIndex
```

**Generated migration**:

```csharp
public partial class AddProductNameIndex : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateIndex(
            name: "IX_Products_Name",
            table: "Products",
            column: "Name");
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropIndex(
            name: "IX_Products_Name",
            table: "Products");
    }
}
```

**Step 3**: Apply migration

```bash
dotnet ef database update
```

---

## Common Patterns & Best Practices

### 1. Applying Migrations on Application Startup

**Pattern**: Automatically apply pending migrations when the app starts.

```csharp
// Program.cs (ASP.NET Core)
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("DefaultConnection")));

var app = builder.Build();

// Apply migrations on startup
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.Migrate();  // Applies all pending migrations
}

app.MapControllers();
app.Run();
```

**Pros**:
- Ensures database is always up-to-date
- Works for development and simple deployments

**Cons**:
- Not ideal for production (see next pattern)
- Can cause delays on startup
- Risk if migration fails during startup

**When to use**: Development environments, simple applications.

### 2. Separating Migration Deployment from Application Deployment

**Pattern**: Apply migrations as a separate step before deploying the application.

```bash
# Production deployment script
# Step 1: Apply migrations
dotnet ef database update --connection "Server=prod;Database=MyDb;..."

# Step 2: Deploy application
dotnet publish -c Release
# ... copy to production server
# ... restart application
```

**Pros**:
- More control over when migrations run
- Can validate migrations before app deployment
- Easier to rollback if needed

**Cons**:
- Requires separate deployment step
- Need to manage connection strings securely

**When to use**: Production environments, critical applications.

### 3. Using Idempotent SQL Scripts

**Pattern**: Generate SQL scripts that can be run multiple times safely.

```bash
# Generate idempotent script
dotnet ef migrations script --idempotent > deploy.sql
```

**Generated SQL includes checks**:

```sql
IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20261122120000_InitialCreate')
BEGIN
    CREATE TABLE [Products] (...);
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20261122120000_InitialCreate', N'8.0.0');
END;
```

**When to use**:
- Production databases where you can't run `dotnet ef` commands
- When DBAs need to review and apply SQL manually

### 4. Migration Naming Conventions

**Good naming**:
```bash
dotnet ef migrations add AddUserEmail
dotnet ef migrations add CreateOrdersTable
dotnet ef migrations add AddIndexToProductName
dotnet ef migrations add SeedInitialCategories
```

**Bad naming**:
```bash
dotnet ef migrations add Migration1
dotnet ef migrations add Update
dotnet ef migrations add Fix
```

**Best practices**:
- Use imperative mood: `AddColumn` not `AddedColumn`
- Be specific: `AddEmailToUser` not `UpdateUser`
- Include what changed: `CreateOrdersTable` not `Orders`

### 5. Handling Large Data Migrations

**Pattern**: For large data updates, use custom SQL to avoid memory issues.

```csharp
public partial class MigrateLargeData : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        // DON'T: Load all records into memory
        // var products = context.Products.ToList();
        // foreach (var p in products) { p.Price *= 1.1m; }

        // DO: Use SQL for large updates
        migrationBuilder.Sql(
            "UPDATE Products SET Price = Price * 1.1 WHERE Price > 0");
    }
}
```

**When to use**: Updating thousands+ of records.

### 6. Environment-Specific Migrations

**Pattern**: Use different connection strings for different environments.

**appsettings.Development.json**:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Data Source=dev.db"
  }
}
```

**appsettings.Production.json**:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=prod-sql;Database=MyApp;..."
  }
}
```

**Apply migrations with environment-specific settings**:

```bash
# Development
dotnet ef database update

# Production (using environment variable)
export ConnectionStrings__DefaultConnection="Server=prod;..."
dotnet ef database update
```

### 7. Testing Migrations

**Pattern**: Create integration tests for migrations.

```csharp
[Fact]
public async Task AllMigrationsApplySuccessfully()
{
    // Arrange
    var options = new DbContextOptionsBuilder<AppDbContext>()
        .UseSqlite("Data Source=:memory:")
        .Options;

    // Act
    await using var context = new AppDbContext(options);
    await context.Database.MigrateAsync();

    // Assert
    var appliedMigrations = await context.Database.GetAppliedMigrationsAsync();
    Assert.NotEmpty(appliedMigrations);

    // Verify specific migrations
    Assert.Contains("20261122120000_InitialCreate", appliedMigrations);
}
```

### 8. Rollback Strategy

**Pattern**: Always test that `Down()` methods work before deploying.

```bash
# Apply migration
dotnet ef database update AddNewFeature

# Test rollback
dotnet ef database update PreviousMigration

# Re-apply if rollback worked
dotnet ef database update
```

**Include rollback scripts in deployment documentation**:

```markdown
## Rollback Procedure
If deployment fails, run:
```bash
dotnet ef database update PreviousStableMigration
```
```

---

## Troubleshooting

### Issue 1: "Build failed" When Running Migrations

**Symptom**:
```
Build started...
Build FAILED.
```

**Causes**:
- Code doesn't compile
- Project not restored

**Solutions**:

```bash
# 1. Check for compilation errors
dotnet build

# 2. Restore packages
dotnet restore

# 3. Try migration again
dotnet ef migrations add MyMigration
```

### Issue 2: "No DbContext was found"

**Symptom**:
```
Unable to create an object of type 'AppDbContext'. For the different patterns supported at design time, see https://go.microsoft.com/fwlink/?linkid=851728
```

**Causes**:
- DbContext doesn't have a parameterless constructor
- No design-time factory configured

**Solution 1: Add `OnConfiguring`**:

```csharp
public class AppDbContext : DbContext
{
    public AppDbContext() { }  // Add parameterless constructor

    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options) { }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {
            optionsBuilder.UseSqlite("Data Source=app.db");
        }
    }
}
```

**Solution 2: Create design-time factory** (see Initial Setup section).

### Issue 3: "The migration has already been applied"

**Symptom**:
```
The migration '20261122120000_InitialCreate' has already been applied to the database.
```

**Causes**:
- Trying to apply the same migration twice

**Solutions**:

```bash
# Check which migrations are applied
dotnet ef migrations list

# If you need to revert and reapply
dotnet ef database update 0  # Revert all
dotnet ef database update    # Reapply all
```

### Issue 4: Pending Model Changes Not in Migration

**Symptom**: You changed your entity, but `dotnet ef migrations add` says "No changes detected".

**Causes**:
- Entity not added to DbContext as DbSet
- Changes made to non-entity classes

**Solutions**:

```csharp
// Make sure entity is exposed as DbSet
public class AppDbContext : DbContext
{
    public DbSet<Product> Products { get; set; }  // Required!
}
```

### Issue 5: Migration Applied But Table Not Created

**Symptom**: Migration shows as applied, but table doesn't exist.

**Causes**:
- Wrong database connection string
- Multiple databases (connected to different database)

**Solutions**:

```bash
# 1. Verify connection string
dotnet ef dbcontext info

# 2. Check actual database file/server
# SQLite
ls -la *.db

# SQL Server
sqlcmd -S localhost -Q "SELECT name FROM sys.databases"

# 3. Drop and recreate database
dotnet ef database drop
dotnet ef database update
```

### Issue 6: Cannot Remove Last Migration

**Symptom**:
```
The migration '20261122140000_AddCategory' has been applied to the database. Revert it and try again.
```

**Causes**:
- Migration already applied to database

**Solutions**:

```bash
# Option 1: Revert to previous migration first
dotnet ef database update PreviousMigration
dotnet ef migrations remove

# Option 2: Drop entire database (dev only!)
dotnet ef database drop
dotnet ef migrations remove
dotnet ef database update
```

### Issue 7: SQL Syntax Errors in Migration

**Symptom**: Migration code looks correct, but database update fails with SQL errors.

**Causes**:
- Reserved keywords used as column names
- Provider-specific limitations

**Solutions**:

```csharp
// Use [Column] attribute to escape reserved keywords
public class Order
{
    public int Id { get; set; }

    [Column("OrderDate")]  // If "Date" is reserved keyword
    public DateTime Date { get; set; }
}

// Or configure in OnModelCreating
modelBuilder.Entity<Order>()
    .Property(o => o.Date)
    .HasColumnName("OrderDate");
```

### Issue 8: Foreign Key Constraint Violations During Migration

**Symptom**: Migration fails when adding foreign key to table with existing data.

**Causes**:
- Existing rows don't have valid foreign key values

**Solutions**:

```csharp
// Manually edit migration to handle existing data
public partial class AddCategoryFK : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        // 1. Add a default category first
        migrationBuilder.InsertData(
            table: "Categories",
            columns: new[] { "Id", "Name" },
            values: new object[] { 1, "Uncategorized" });

        // 2. Add column with default value
        migrationBuilder.AddColumn<int>(
            name: "CategoryId",
            table: "Products",
            nullable: false,
            defaultValue: 1);  // Points to "Uncategorized"

        // 3. Now add foreign key constraint
        migrationBuilder.AddForeignKey(
            name: "FK_Products_Categories_CategoryId",
            table: "Products",
            column: "CategoryId",
            principalTable: "Categories",
            principalColumn: "Id");
    }
}
```

### Issue 9: Slow Migrations on Large Tables

**Symptom**: Migration takes forever to complete.

**Causes**:
- Adding indexes to large tables
- Complex data migrations

**Solutions**:

```bash
# 1. Generate SQL script
dotnet ef migrations script > migration.sql

# 2. Review SQL to identify slow operations

# 3. Run during maintenance window

# 4. Consider adding indexes CONCURRENTLY (PostgreSQL)
# Manually edit migration:
migrationBuilder.Sql("CREATE INDEX CONCURRENTLY IX_Products_Name ON Products(Name)");
```

### Issue 10: Merge Conflicts in Migrations

**Symptom**: Git merge conflicts in migration files or snapshot.

**Causes**:
- Two developers created migrations simultaneously

**Solutions**:

```bash
# 1. Revert your local migration
dotnet ef migrations remove

# 2. Pull latest changes
git pull

# 3. Recreate your migration
dotnet ef migrations add YourFeature

# 4. Commit and push
git add Migrations/
git commit -m "Add YourFeature migration"
git push
```

**Prevention**: Communicate with team when creating migrations affecting shared tables.

---

## Additional Resources

### Official Documentation

- [EF Core Migrations Overview](https://learn.microsoft.com/en-us/ef/core/managing-schemas/migrations/) - Microsoft's comprehensive guide
- [Migrations in Team Environments](https://learn.microsoft.com/en-us/ef/core/managing-schemas/migrations/teams) - Best practices for collaboration
- [Custom Migration Operations](https://learn.microsoft.com/en-us/ef/core/managing-schemas/migrations/operations) - Advanced migration scenarios
- [Managing Migration Scripts](https://learn.microsoft.com/en-us/ef/core/managing-schemas/migrations/applying) - Deployment strategies

### Tools

- [dotnet-ef CLI Reference](https://learn.microsoft.com/en-us/ef/core/cli/dotnet) - Complete command reference
- [EF Core Power Tools](https://marketplace.visualstudio.com/items?itemName=ErikEJ.EFCorePowerTools) - Visual Studio extension for migrations
- [Rider EF Core UI](https://www.jetbrains.com/help/rider/Entity_Framework_Core.html) - JetBrains Rider integration

### Video Tutorials

- [Entity Framework Core Migrations - Full Course](https://www.youtube.com/results?search_query=ef+core+migrations+tutorial) - YouTube tutorials
- [.NET Data Community Standup](https://www.youtube.com/playlist?list=PLdo4fOcmZ0oX0obV7B_J70EL2T-mVqN_j) - Official .NET team discussions

### Best Practices Articles

- [EF Core Migration Best Practices](https://www.thereformedprogrammer.net/ef-core-migrations-best-practices/) - Jon P Smith's guide
- [Database Migrations Done Right](https://martinfowler.com/articles/evodb.html) - Martin Fowler on evolutionary database design
- [Zero-Downtime Migrations](https://spring.io/blog/2016/05/31/zero-downtime-deployment-with-a-database) - Strategies for production deployments

### Community Resources

- [EF Core GitHub Repository](https://github.com/dotnet/efcore) - Source code and issue tracker
- [Entity Framework Core Tag on Stack Overflow](https://stackoverflow.com/questions/tagged/entity-framework-core) - Community Q&A
- [r/dotnet Subreddit](https://www.reddit.com/r/dotnet/) - Discussion forum

### Related Topics to Explore Next

1. **[Entity Framework Core Fundamentals](entity-framework-core-fundamentals.md)** - Prerequisites for migrations
2. **Data Seeding** - Populating initial/reference data
3. **EF Core Interceptors** - Customizing migration behavior
4. **Multi-Tenant Migrations** - Managing schemas for multiple tenants
5. **Database Deployment Automation** - CI/CD for database changes

### Books

- **"Entity Framework Core in Action, 2nd Edition"** by Jon P Smith - Comprehensive EF Core guide including migrations
- **"Programming Entity Framework"** by Julia Lerman - Deep dive into EF concepts

---

## Self-Assessment Checklist

After completing this guide, you should be able to:

- [ ] Explain what migrations are and why they're used
- [ ] Install and configure dotnet-ef tools
- [ ] Create a migration from entity changes
- [ ] Apply migrations to a database
- [ ] Review and understand generated migration code
- [ ] Remove or rollback migrations
- [ ] Seed data using migrations
- [ ] Handle common migration scenarios (add table, rename column, add foreign key)
- [ ] Generate SQL scripts from migrations
- [ ] Apply migrations in different environments
- [ ] Troubleshoot common migration errors
- [ ] Understand best practices for team collaboration with migrations
- [ ] Configure design-time DbContext creation
- [ ] Test migrations before deploying to production

---

## Summary

**Entity Framework Core Migrations** provide a robust, version-controlled way to manage database schema changes. Key takeaways:

1. **Migrations are version control for your database** - Every schema change is tracked in code
2. **Use `dotnet ef` commands** - `migrations add`, `database update`, `migrations remove`
3. **Always review generated code** - EF Core is smart, but sometimes needs manual adjustments
4. **Test rollbacks** - Ensure `Down()` methods work before deploying
5. **Apply migrations before deploying apps** - Don't auto-migrate in production without careful consideration
6. **Use idempotent scripts for production** - Generate SQL for manual review and application
7. **Communicate with your team** - Coordinate when multiple developers modify the same tables

**Next Steps**:
- Practice creating and applying migrations with your own entities
- Explore data seeding for reference data
- Learn about EF Core advanced features (relationships, indexes, owned types)
- Read about deployment strategies for production databases

Remember: Migrations are powerful but can't be completely automated. Always review generated code, test thoroughly, and have a rollback plan before applying to production databases.

Happy migrating!
