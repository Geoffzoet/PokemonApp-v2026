# Configuration Guide

This document explains how to configure the Pokemon API for different environments.

## Configuration Files

- `appsettings.json` - Base configuration shared across all environments
- `appsettings.Development.json` - Development-specific overrides (more verbose logging)
- `appsettings.Production.json` - Production-specific overrides

## Strongly-Typed Configuration

The API uses the Options pattern for strongly-typed configuration:

### JwtOptions

Located in `Options/JwtOptions.cs`, this class provides type-safe access to JWT settings:

```csharp
public class JwtOptions
{
    public string Key { get; set; }      // Secret key for signing tokens
    public string Issuer { get; set; }   // Token issuer
    public string Audience { get; set; } // Token audience
}
```

## Development Environment

### Using User Secrets (Recommended)

For development, use User Secrets to store sensitive configuration like JWT keys:

```bash
# Initialize user secrets
dotnet user-secrets init

# Set JWT configuration
dotnet user-secrets set "Jwt:Key" "your-development-secret-key-at-least-32-characters"
dotnet user-secrets set "Jwt:Issuer" "PokemonApp.API"
dotnet user-secrets set "Jwt:Audience" "PokemonApp.Clients"
```

User secrets are stored outside the project directory and never committed to source control.

### Location of User Secrets

- **Windows**: `%APPDATA%\Microsoft\UserSecrets\<user_secrets_id>\secrets.json`
- **Linux/macOS**: `~/.microsoft/usersecrets/<user_secrets_id>/secrets.json`

## Production Environment

### Using Environment Variables

In production, use environment variables for sensitive configuration:

```bash
# Linux/macOS
export Jwt__Key="production-secret-key-minimum-32-characters-long"
export Jwt__Issuer="PokemonApp.API"
export Jwt__Audience="PokemonApp.Clients"
export ConnectionStrings__DefaultConnection="Data Source=production.db"

# Windows PowerShell
$env:Jwt__Key="production-secret-key-minimum-32-characters-long"
$env:Jwt__Issuer="PokemonApp.API"
$env:Jwt__Audience="PokemonApp.Clients"
$env:ConnectionStrings__DefaultConnection="Data Source=production.db"
```

**Note**: Use double underscores (`__`) in environment variable names to represent nested configuration sections.

### Azure App Service

When deploying to Azure App Service, configure application settings in the Azure Portal:

1. Navigate to your App Service
2. Go to Configuration → Application settings
3. Add settings with `:` separator (e.g., `Jwt:Key`)

## Security Best Practices

### Never Commit Secrets

- ✅ Use User Secrets for development
- ✅ Use Environment Variables for production
- ✅ Use Azure Key Vault for production secrets
- ❌ Never commit `appsettings.Development.json` with secrets
- ❌ Never hardcode secrets in source code

### JWT Key Requirements

- Minimum 32 characters
- Use cryptographically strong random values
- Rotate keys periodically
- Use different keys for each environment

### Generate Secure Keys

```bash
# Generate a secure random key (Linux/macOS)
openssl rand -base64 32

# Generate a secure random key (Windows PowerShell)
[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Minimum 0 -Maximum 256 }))
```

## Connection Strings

### Development

SQLite database in project directory (suitable for development):

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Data Source=pokemon.db"
  }
}
```

### Production

Use environment variables for production connection strings:

```bash
export ConnectionStrings__DefaultConnection="Server=prod-server;Database=PokemonDB;User=sa;Password=***;"
```

## Logging Configuration

### Development

Verbose logging for debugging (`appsettings.Development.json`):

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Debug",
      "Microsoft.AspNetCore": "Information",
      "Microsoft.EntityFrameworkCore.Database.Command": "Information",
      "PokemonApp.API": "Debug"
    }
  }
}
```

### Production

Minimal logging for performance (`appsettings.Production.json`):

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning",
      "PokemonApp.API": "Information"
    }
  }
}
```

## Admin User Credentials

### Default Admin Account

The application automatically seeds an admin account on startup:

- **Email**: `admin@pokemonapp.com`
- **Password**: `Admin123!`

**IMPORTANT**: Change the default admin password immediately in production environments!

## Configuration Priority

ASP.NET Core loads configuration in this order (later sources override earlier ones):

1. `appsettings.json`
2. `appsettings.{Environment}.json`
3. User Secrets (Development only)
4. Environment Variables
5. Command-line arguments

## Verifying Configuration

To verify your configuration is loaded correctly:

1. Check the logs on application startup
2. Test authentication endpoints
3. Verify database connection
4. Check Swagger UI is accessible

## Troubleshooting

### "Invalid JWT Key" Error

- Ensure the JWT key is at least 32 characters
- Verify the key is set in the correct configuration source
- Check for typos in environment variable names

### "Database Connection Failed"

- Verify the connection string is correct
- Ensure database file/server is accessible
- Check permissions on the database file (SQLite)

### "Configuration Section Not Found"

- Verify the section name matches exactly (case-sensitive)
- Check the configuration file syntax (valid JSON)
- Ensure environment-specific files are being loaded
