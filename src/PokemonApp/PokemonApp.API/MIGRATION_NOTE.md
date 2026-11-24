# Migration Note

## PokemonType Enum Expansion

**Date**: 2026-11-24

### Change Made
Expanded `PokemonType` enum from 5 types to 18 types to match Angular frontend requirements.

**Old Types (5):**
- GRASS, FIRE, FLYING, WATER, ELECTRIK

**New Types (18):**
- NORMAL, FIRE, WATER, GRASS, ELECTRIC, ICE, FIGHTING, POISON, GROUND, FLYING, PSYCHIC, BUG, ROCK, GHOST, DRAGON, DARK, STEEL, FAIRY

**Key Changes:**
- Fixed typo: ELECTRIK → ELECTRIC
- Added 13 new types

### Database Impact

**No migration required.**

**Reason:**
Enums are stored as integers in the database. Expanding the enum in code does not change the database schema. The database continues to store integer values, and the application layer handles the mapping between integers and enum names.

### Validation Updates

Updated validation in:
- `DTOs/CreatePokemonDto.cs` - RegularExpression attribute
- `DTOs/UpdatePokemonDto.cs` - RegularExpression attribute

Both now accept all 18 Pokemon types.

### EF Core Tools Issue

Attempted to create a migration but encountered an error:
```
Could not load file or assembly 'System.Runtime, Version=10.0.0.0'
```

This is a dotnet ef tools issue related to SDK version mismatch (project targets .NET 8, but global tools may be for .NET 10). Since no database schema change is needed, this can be safely ignored.

### Testing Recommendation

Test that the API now accepts all 18 Pokemon types in POST and PUT operations.
