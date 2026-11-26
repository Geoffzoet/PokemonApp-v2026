# Frontend Compatibility Report

**Date**: 2026-11-24
**Angular Frontend**: `/Users/geoffroyzoetardt/Documents/Professionel/Hermes/CursusJT/Angular/angular-pokemon`
**API Backend**: `/Users/geoffroyzoetardt/Documents/Professionel/Hermes/CursusJT/dotNET-API-MVC/v2026/PokemonApp`

## Executive Summary

The current .NET API **is NOT fully compatible** with the Angular Pokemon frontend. There are **5 critical issues** that must be resolved before the frontend can communicate with the API.

---

## Critical Issues

### ❌ Issue 1: Port and Protocol Mismatch

**Problem:**
- **Frontend expects**: `http://localhost:5001` (HTTP on port 5001)
- **API provides**: `https://localhost:7000` (HTTPS on port 7000)

**Impact**: Frontend cannot connect to API at all.

**Location:**
- Frontend: `src/app/shared/service/pokemon-service.ts:11`
- Backend: `src/PokemonApp/PokemonApp.API/Properties/launchSettings.json:8`

**Solution Options:**

**Option A - Change API (Recommended for Development):**
```json
// launchSettings.json
{
  "profiles": {
    "http": {
      "commandName": "Project",
      "dotnetRunMessages": true,
      "launchBrowser": false,
      "applicationUrl": "http://localhost:5001",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      }
    }
  }
}
```

**Option B - Change Frontend:**
Update Angular services to use `https://localhost:7000`

---

### ❌ Issue 2: Authentication Required

**Problem:**
- **Frontend**: Makes unauthenticated requests (no Authorization header)
- **API**: Requires JWT Bearer token + Admin role for POST/PUT/DELETE operations

**Impact**: All create, update, and delete operations will fail with 401 Unauthorized or 403 Forbidden.

**Affected Endpoints:**
- POST `/api/pokemon` - Requires `[Authorize(Roles = "Admin")]`
- PUT `/api/pokemon/{id}` - Requires `[Authorize(Roles = "Admin")]`
- DELETE `/api/pokemon/{id}` - Requires `[Authorize(Roles = "Admin")]`

**Solution Options:**

**Option A - Remove Authentication (Development Only):**
```csharp
// In PokemonController.cs, comment out or remove:
// [Authorize(Roles = "Admin")]

// In Program.cs, comment out middleware:
// app.UseAuthentication();
// app.UseAuthorization();
```

**Option B - Add Authentication to Frontend:**
- Implement login flow
- Store JWT token
- Add HTTP interceptor to include `Authorization: Bearer {token}` header
- Login as admin: `admin@pokemonapp.com` / `Admin123!`

---

### ❌ Issue 3: Missing /api/attacks Endpoint

**Problem:**
- **Frontend expects**: `GET http://localhost:5001/api/attacks`
- **API provides**: No attacks endpoint

**Impact**: Attack selection dropdown in Pokemon form will not work.

**Location**: Frontend calls this in `attack-service.ts:20`

**Solution**: Create AttacksController

```csharp
// File: Controllers/AttacksController.cs
[ApiController]
[Route("api/[controller]")]
public class AttacksController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll()
    {
        // Return available attacks
        var attacks = new[]
        {
            new { Id = 1, Name = "Éclair", Points = 55 },
            new { Id = 2, Name = "Tonnerre", Points = 90 },
            new { Id = 3, Name = "Charge", Points = 40 },
            new { Id = 4, Name = "Lance-Flammes", Points = 90 },
            new { Id = 5, Name = "Hydrocanon", Points = 110 }
        };
        return Ok(attacks);
    }
}
```

---

### ❌ Issue 4: Pokemon Type Enum Mismatch

**Problem:**

**Frontend expects (18 types):**
```typescript
NORMAL, FIRE, WATER, GRASS, ELECTRIC, ICE, FIGHTING, POISON,
GROUND, FLYING, PSYCHIC, BUG, ROCK, GHOST, DRAGON, DARK, STEEL, FAIRY
```

**API provides (5 types):**
```csharp
GRASS, FIRE, FLYING, WATER, ELECTRIK  // Note: ELECTRIK vs ELECTRIC
```

**Impact**:
- Frontend cannot create Pokemon with most types
- Validation will fail for unsupported types
- Typo: "ELECTRIK" vs "ELECTRIC"

**Solution**: Expand PokemonType enum

```csharp
// File: Models/PokemonType.cs
public enum PokemonType
{
    NORMAL,
    FIRE,
    WATER,
    GRASS,
    ELECTRIC,    // Fix: was ELECTRIK
    ICE,
    FIGHTING,
    POISON,
    GROUND,
    FLYING,
    PSYCHIC,
    BUG,
    ROCK,
    GHOST,
    DRAGON,
    DARK,
    STEEL,
    FAIRY
}
```

**Note**: This change requires a new EF Core migration.

---

### ❌ Issue 5: Missing isPartOfTeam Property

**Problem:**
- **Frontend expects**: `isPartOfTeam: boolean` property on Pokemon
- **API provides**: No such property

**Impact**: Frontend team management feature won't work correctly if persisted.

**Analysis**: This appears to be a **client-side only** property. The frontend manages team membership in Angular signals, not on the server.

**Solution**:
- **Option A**: Keep as client-side only (current frontend implementation)
- **Option B**: Add to API if you want to persist team membership:
  ```csharp
  public class PokemonDto
  {
      // ... existing properties
      public bool IsPartOfTeam { get; set; }
  }
  ```

---

## Working Features ✅

### ✅ CORS Configuration
API has CORS enabled with `AllowAll` policy - compatible with Angular dev server.

### ✅ Data Structure Compatibility
Frontend handles conversion between:
- API: `rarityPercentage` (0-100 range)
- Frontend: `captureRate` (0-1 range)

Conversion logic in `pokemon-service.ts` works correctly.

### ✅ Endpoint Structure (GET operations)
- `GET /api/pokemon` ✅
- `GET /api/pokemon/{id}` ✅

These work without authentication and will function correctly.

### ✅ Attack DTO Structure
API's `AttackDto` matches frontend's `Attack` interface:
```csharp
public class AttackDto {
    public string Name { get; set; }
    public int Points { get; set; }
}
```

### ✅ HTTP Methods
API uses correct HTTP methods matching frontend expectations.

---

## Recommended Action Plan

### Phase 1: Quick Fix for Development (30 minutes)

1. **Change API port and protocol**
   - Update `launchSettings.json` to use `http://localhost:5001`

2. **Disable authentication temporarily**
   - Comment out `[Authorize]` attributes in `PokemonController.cs`
   - Comment out authentication middleware in `Program.cs`

3. **Add AttacksController**
   - Create simple endpoint returning hardcoded attacks

4. **Fix PokemonType enum**
   - Expand to 18 types
   - Fix "ELECTRIK" → "ELECTRIC"
   - Create migration: `dotnet ef migrations add ExpandPokemonTypes`
   - Apply migration: `dotnet ef database update`

### Phase 2: Production-Ready (Additional work)

1. **Add authentication to frontend**
   - Implement login page
   - Add HTTP interceptor
   - Store JWT token
   - Handle token refresh

2. **Proper Attacks management**
   - Create Attack entity
   - Store attacks in database
   - Implement full CRUD if needed

3. **Team persistence** (optional)
   - Add `IsPartOfTeam` to API
   - Persist team membership

---

## Testing Checklist

After implementing fixes:

- [ ] Frontend can connect to API (no CORS errors)
- [ ] GET `/api/pokemon` returns Pokemon list
- [ ] GET `/api/pokemon/{id}` returns single Pokemon
- [ ] GET `/api/attacks` returns attack list
- [ ] POST `/api/pokemon` creates new Pokemon
- [ ] PUT `/api/pokemon/{id}` updates Pokemon
- [ ] DELETE `/api/pokemon/{id}` removes Pokemon
- [ ] All Pokemon types from frontend are accepted
- [ ] Attack selection dropdown populates correctly
- [ ] No 401/403 authentication errors (or login works)

---

## Configuration Files to Modify

### Backend Changes:
1. `src/PokemonApp/PokemonApp.API/Properties/launchSettings.json`
2. `src/PokemonApp/PokemonApp.API/Controllers/PokemonController.cs`
3. `src/PokemonApp/PokemonApp.API/Models/PokemonType.cs`
4. `src/PokemonApp/PokemonApp.API/Controllers/AttacksController.cs` (create new)
5. `src/PokemonApp/PokemonApp.API/Program.cs` (comment auth middleware)

### Frontend Changes (if not modifying backend):
1. `src/app/shared/service/pokemon-service.ts` (change base URL)
2. `src/app/shared/service/attack-service.ts` (change base URL)

---

## Summary

**Current State**: ❌ NOT COMPATIBLE

**After Phase 1 Fixes**: ✅ FULLY COMPATIBLE for Development

**After Phase 2**: ✅ PRODUCTION READY

The main blockers are port/protocol mismatch, authentication, missing attacks endpoint, and enum compatibility. These can be resolved with relatively minor changes to either the backend or frontend.
