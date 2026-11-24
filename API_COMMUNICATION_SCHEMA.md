# API Communication Schema - Frontend ↔ Backend

**Date**: 2026-11-24
**Frontend**: Angular Pokemon App
**Backend**: .NET 8 Pokemon API

This document details the complete request/response flow for each endpoint between the Angular frontend and the .NET API backend.

---

## Table of Contents

1. [GET /api/pokemon - List All Pokemon](#1-get-apipokemon---list-all-pokemon)
2. [GET /api/pokemon/{id} - Get Pokemon by ID](#2-get-apipokemonid---get-pokemon-by-id)
3. [POST /api/pokemon - Create New Pokemon](#3-post-apipokemon---create-new-pokemon)
4. [PUT /api/pokemon/{id} - Update Pokemon](#4-put-apipokemonid---update-pokemon)
5. [DELETE /api/pokemon/{id} - Delete Pokemon](#5-delete-apipokemonid---delete-pokemon)
6. [GET /api/attacks - List All Attacks](#6-get-apiattacks---list-all-attacks)

---

## 1. GET /api/pokemon - List All Pokemon

### 📤 Frontend Request

**Angular Service**: `pokemon-service.ts:getPokemons()`

```typescript
// Service Call
this.http.get<Pokemon[]>('http://localhost:5001/api/pokemon')
```

**HTTP Request**:
```http
GET /api/pokemon HTTP/1.1
Host: localhost:5001
Accept: application/json
```

**No Request Body** ✅

---

### 🔄 Backend Processing

**Controller**: `PokemonController.cs:GetAll()`

```
1. Controller receives request
   ↓
2. Calls IPokemonService.GetAllAsync()
   ↓
3. Service calls IPokemonRepository.GetAllAsync()
   ↓
4. Repository queries database with EF Core
   - SELECT * FROM Pokemon INCLUDE Attacks
   ↓
5. Maps Pokemon entities → PokemonDto
   - Converts PokemonType enum to string
   - Includes related attacks
   ↓
6. Returns IEnumerable<PokemonDto>
```

---

### 📥 Backend Response

**Status Code**: `200 OK`

**Response Body**:
```json
[
  {
    "id": 1,
    "name": "Pikachu",
    "type": "ELECTRIC",
    "attacks": [
      {
        "name": "Éclair",
        "points": 55
      },
      {
        "name": "Tonnerre",
        "points": 90
      }
    ],
    "defensePoints": 40,
    "healthPoints": 35,
    "rarityPercentage": 15.5,
    "imageURL": "https://assets.pokemon.com/assets/cms2/img/pokedex/full/025.png",
    "isPartOfTeam": false
  },
  {
    "id": 2,
    "name": "Salamèche",
    "type": "FIRE",
    "attacks": [
      {
        "name": "Flammèche",
        "points": 40
      }
    ],
    "defensePoints": 43,
    "healthPoints": 39,
    "rarityPercentage": 12.0,
    "imageURL": "https://assets.pokemon.com/assets/cms2/img/pokedex/full/004.png",
    "isPartOfTeam": false
  }
]
```

**DTO Structure**: `PokemonDto`
```csharp
public class PokemonDto
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }                    // Enum → String
    public List<AttackDto> Attacks { get; set; }
    public int DefensePoints { get; set; }
    public int HealthPoints { get; set; }
    public double RarityPercentage { get; set; }        // 0-100 range
    public string? ImageURL { get; set; }
    public bool IsPartOfTeam { get; set; }              // Always false from API
}
```

---

### 🎨 Frontend Processing

**Angular Service**: Data transformation

```typescript
// 1. Receives response
const pokemonsFromAPI: Pokemon[] = response;

// 2. Converts rarityPercentage → captureRate
const transformedPokemons = pokemonsFromAPI.map(pokemon => ({
  ...pokemon,
  captureRate: 1 - (pokemon.rarityPercentage / 100)  // 15.5% → 0.845
}));

// 3. Updates signal
this.$pokemons.set(transformedPokemons);

// 4. Updates team flags based on $myTeam signal
// Sets isPartOfTeam = true if pokemon.id is in team
```

**Frontend Pokemon Interface**:
```typescript
export interface Pokemon {
  id: number;
  name: string;
  type: PokemonType;              // String enum value
  healthPoints: number;
  defensePoints: number;
  captureRate: number;            // 0-1 range (converted from rarityPercentage)
  imageURL: string;
  isPartOfTeam: boolean;          // Overridden by frontend logic
  attacks: Attack[];
}
```

---

### 📊 Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│ FRONTEND (Angular)                                                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  PokemonService.getPokemons()                                        │
│         │                                                            │
│         │ HTTP GET /api/pokemon                                     │
│         ▼                                                            │
└─────────────────────────────────────────────────────────────────────┘
          │
          │ Request: No body
          │ Headers: Accept: application/json
          │
          ▼
┌─────────────────────────────────────────────────────────────────────┐
│ BACKEND (.NET API)                                                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  PokemonController.GetAll()                                          │
│         │                                                            │
│         ├─► PokemonService.GetAllAsync()                            │
│         │         │                                                  │
│         │         ├─► PokemonRepository.GetAllAsync()               │
│         │         │         │                                        │
│         │         │         ├─► EF Core: SELECT Pokemon + Attacks   │
│         │         │         │                                        │
│         │         │         └─► Returns List<Pokemon> entities      │
│         │         │                                                  │
│         │         └─► Maps to List<PokemonDto>                      │
│         │                   - Type enum → string                     │
│         │                   - Includes attacks                       │
│         │                   - isPartOfTeam = false                   │
│         │                                                            │
│         └─► Returns 200 OK with JSON array                          │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘
          │
          │ Response: 200 OK
          │ Body: Array of PokemonDto (JSON)
          │
          ▼
┌─────────────────────────────────────────────────────────────────────┐
│ FRONTEND (Angular)                                                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  Receives: Pokemon[] with rarityPercentage                           │
│         │                                                            │
│         ├─► Transforms data:                                        │
│         │   - rarityPercentage → captureRate                        │
│         │   - Updates isPartOfTeam based on team state              │
│         │                                                            │
│         └─► Updates $pokemons signal                                │
│                   │                                                  │
│                   ├─► PokemonsComponent displays list               │
│                   └─► MyTeamComponent shows team                    │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 2. GET /api/pokemon/{id} - Get Pokemon by ID

### 📤 Frontend Request

**Angular Service**: `pokemon-service.ts:getPokemonById(id)`

```typescript
this.http.get<Pokemon>(`http://localhost:5001/api/pokemon/${id}`)
```

**HTTP Request**:
```http
GET /api/pokemon/1 HTTP/1.1
Host: localhost:5001
Accept: application/json
```

**URL Parameter**: `id` (integer)

---

### 🔄 Backend Processing

```
1. Controller extracts {id} from route
   ↓
2. Calls IPokemonService.GetByIdAsync(id)
   ↓
3. Service calls IPokemonRepository.GetByIdAsync(id)
   ↓
4. Repository queries: SELECT * FROM Pokemon WHERE Id = @id INCLUDE Attacks
   ↓
5. If found: Maps to PokemonDto
   If not found: Returns null
   ↓
6. Controller checks result:
   - If null → Returns 404 NotFound
   - If found → Returns 200 OK with PokemonDto
```

---

### 📥 Backend Response (Success)

**Status Code**: `200 OK`

**Response Body**:
```json
{
  "id": 1,
  "name": "Pikachu",
  "type": "ELECTRIC",
  "attacks": [
    {
      "name": "Éclair",
      "points": 55
    },
    {
      "name": "Tonnerre",
      "points": 90
    }
  ],
  "defensePoints": 40,
  "healthPoints": 35,
  "rarityPercentage": 15.5,
  "imageURL": "https://assets.pokemon.com/assets/cms2/img/pokedex/full/025.png",
  "isPartOfTeam": false
}
```

---

### 📥 Backend Response (Not Found)

**Status Code**: `404 Not Found`

**Response Body**:
```json
{
  "message": "Pokémon avec l'ID 999 introuvable"
}
```

---

### 🎨 Frontend Processing

```typescript
// 1. Receives response
const pokemonFromAPI: Pokemon = response;

// 2. Converts rarityPercentage → captureRate
const pokemon = {
  ...pokemonFromAPI,
  captureRate: 1 - (pokemonFromAPI.rarityPercentage / 100)
};

// 3. Used for:
//    - Navigation to detail view
//    - Pre-filling form for edit
//    - Display in PokemonComponent
```

---

### 📊 Data Flow Diagram

```
┌──────────────────────────────────────────────────────────┐
│ FRONTEND                                                  │
│  User clicks Pokemon → Navigate to detail page           │
│         │                                                 │
│         │ GET /api/pokemon/1                             │
│         ▼                                                 │
└──────────────────────────────────────────────────────────┘
          │
          ▼
┌──────────────────────────────────────────────────────────┐
│ BACKEND                                                   │
│  Controller.GetById(1)                                    │
│         │                                                 │
│         ├─► Service.GetByIdAsync(1)                      │
│         │         │                                       │
│         │         ├─► Repository: Find by ID             │
│         │         │         │                             │
│         │         │         ├─► Found? → PokemonDto      │
│         │         │         └─► Not found? → null        │
│         │         │                                       │
│         │         └─► Returns PokemonDto or null         │
│         │                                                 │
│         └─► 200 OK with data OR 404 Not Found            │
│                                                           │
└──────────────────────────────────────────────────────────┘
          │
          ▼
┌──────────────────────────────────────────────────────────┐
│ FRONTEND                                                  │
│  Receives Pokemon → Transform → Display                  │
└──────────────────────────────────────────────────────────┘
```

---

## 3. POST /api/pokemon - Create New Pokemon

### 📤 Frontend Request

**Angular Service**: `pokemon-service.ts:setPokemons(pokemon)`
- Called when `pokemon.id === -1` (new Pokemon)

```typescript
// 1. User fills form with:
const newPokemon = {
  id: -1,
  name: "Dracaufeu",
  type: "FIRE",
  healthPoints: 78,
  defensePoints: 78,
  captureRate: 0.95,  // User-friendly 0-1 scale
  imageURL: "https://...",
  attacks: [
    { name: "Lance-Flammes", points: 90 },
    { name: "Déflagration", points: 110 }
  ]
};

// 2. Service converts captureRate → rarityPercentage
const requestBody = {
  ...newPokemon,
  rarityPercentage: (1 - newPokemon.captureRate) * 100  // 0.95 → 5.0
};

// 3. Sends POST request
this.http.post<Pokemon>('http://localhost:5001/api/pokemon', requestBody)
```

**HTTP Request**:
```http
POST /api/pokemon HTTP/1.1
Host: localhost:5001
Content-Type: application/json
Accept: application/json

{
  "name": "Dracaufeu",
  "type": "FIRE",
  "attacks": [
    {
      "name": "Lance-Flammes",
      "points": 90
    },
    {
      "name": "Déflagration",
      "points": 110
    }
  ],
  "defensePoints": 78,
  "healthPoints": 78,
  "rarityPercentage": 5.0,
  "imageURL": "https://assets.pokemon.com/assets/cms2/img/pokedex/full/006.png"
}
```

**Request DTO**: `CreatePokemonDto`

---

### 🔄 Backend Processing

```
1. Controller receives CreatePokemonDto
   ↓
2. ModelState validation:
   ✓ Name: Required, 1-50 chars
   ✓ Type: Must match enum regex
   ✓ Attacks: Required, min 1 attack
   ✓ DefensePoints: 0-100
   ✓ HealthPoints: 0-100
   ✓ RarityPercentage: 0-100
   ✓ ImageURL: Valid URL format
   ↓
   If invalid → Returns 400 BadRequest with errors
   ↓
3. Calls IPokemonService.CreateAsync(dto)
   ↓
4. Service:
   - Parses Type string → PokemonType enum
   - Creates Pokemon entity
   - Maps attacks from DTOs
   ↓
5. Repository.AddAsync(pokemon)
   - EF Core: INSERT INTO Pokemon
   - EF Core: INSERT INTO Attacks (cascade)
   - SaveChangesAsync()
   - Returns entity with generated ID
   ↓
6. Maps entity → PokemonDto
   ↓
7. Controller.CreatedAtAction():
   - Status: 201 Created
   - Location header: /api/pokemon/{newId}
   - Body: PokemonDto
```

---

### 📥 Backend Response (Success)

**Status Code**: `201 Created`

**Headers**:
```
Location: http://localhost:5001/api/pokemon/3
```

**Response Body**:
```json
{
  "id": 3,
  "name": "Dracaufeu",
  "type": "FIRE",
  "attacks": [
    {
      "name": "Lance-Flammes",
      "points": 90
    },
    {
      "name": "Déflagration",
      "points": 110
    }
  ],
  "defensePoints": 78,
  "healthPoints": 78,
  "rarityPercentage": 5.0,
  "imageURL": "https://assets.pokemon.com/assets/cms2/img/pokedex/full/006.png",
  "isPartOfTeam": false
}
```

---

### 📥 Backend Response (Validation Error)

**Status Code**: `400 Bad Request`

**Response Body**:
```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
  "title": "One or more validation errors occurred.",
  "status": 400,
  "errors": {
    "Name": [
      "Le nom est obligatoire"
    ],
    "Type": [
      "Le type doit être l'un des suivants: NORMAL, FIRE, WATER, ..."
    ],
    "Attacks": [
      "Au moins une attaque est requise"
    ]
  }
}
```

---

### 🎨 Frontend Processing

```typescript
// 1. Receives 201 Created response
const createdPokemon: Pokemon = response;

// 2. Converts rarityPercentage → captureRate
const pokemon = {
  ...createdPokemon,
  captureRate: 1 - (createdPokemon.rarityPercentage / 100)
};

// 3. Refreshes Pokemon list (calls getPokemons())

// 4. Displays success notification
this.snackBar.open('Pokemon créé avec succès', 'OK');

// 5. Navigates back to list
this.router.navigate(['/pokemons']);
```

---

### 📊 Data Flow Diagram

```
┌────────────────────────────────────────────────────────────────┐
│ FRONTEND                                                        │
│  User fills form → Submit                                      │
│         │                                                       │
│         ├─► Convert captureRate → rarityPercentage            │
│         │   (0.95 → 5.0)                                       │
│         │                                                       │
│         │ POST /api/pokemon                                    │
│         │ Body: CreatePokemonDto (JSON)                        │
│         ▼                                                       │
└────────────────────────────────────────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────────────────────────────┐
│ BACKEND                                                         │
│  Controller receives CreatePokemonDto                           │
│         │                                                       │
│         ├─► Validate ModelState                               │
│         │         │                                             │
│         │         ├─► Invalid? → 400 BadRequest               │
│         │         └─► Valid? → Continue                        │
│         │                                                       │
│         ├─► Service.CreateAsync(dto)                          │
│         │         │                                             │
│         │         ├─► Parse Type string → enum                │
│         │         ├─► Create Pokemon entity                   │
│         │         └─► Repository.AddAsync()                    │
│         │                   │                                   │
│         │                   ├─► INSERT Pokemon                 │
│         │                   ├─► INSERT Attacks (cascade)       │
│         │                   └─► Returns entity with ID         │
│         │                                                       │
│         ├─► Map entity → PokemonDto                           │
│         │                                                       │
│         └─► 201 Created                                        │
│             Location: /api/pokemon/3                           │
│             Body: PokemonDto                                   │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────────────────────────────┐
│ FRONTEND                                                        │
│  Receives 201 Created                                          │
│         │                                                       │
│         ├─► Convert rarityPercentage → captureRate            │
│         ├─► Refresh Pokemon list                              │
│         ├─► Show success message                              │
│         └─► Navigate to list                                   │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 4. PUT /api/pokemon/{id} - Update Pokemon

### 📤 Frontend Request

**Angular Service**: `pokemon-service.ts:setPokemons(pokemon)`
- Called when `pokemon.id > 0` (existing Pokemon)

```typescript
// 1. User edits existing Pokemon
const updatedPokemon = {
  id: 3,
  name: "Dracaufeu Méga",
  type: "FIRE",
  healthPoints: 78,
  defensePoints: 111,
  captureRate: 0.98,  // Changed
  imageURL: "https://...",
  attacks: [
    { name: "Lance-Flammes", points: 90 },
    { name: "Déflagration", points: 110 },
    { name: "Danse Flamme", points: 80 }  // Added new attack
  ]
};

// 2. Service converts captureRate → rarityPercentage
const requestBody = {
  ...updatedPokemon,
  rarityPercentage: (1 - updatedPokemon.captureRate) * 100  // 0.98 → 2.0
};

// 3. Sends PUT request
this.http.put<Pokemon>(`http://localhost:5001/api/pokemon/${id}`, requestBody)
```

**HTTP Request**:
```http
PUT /api/pokemon/3 HTTP/1.1
Host: localhost:5001
Content-Type: application/json
Accept: application/json

{
  "name": "Dracaufeu Méga",
  "type": "FIRE",
  "attacks": [
    {
      "name": "Lance-Flammes",
      "points": 90
    },
    {
      "name": "Déflagration",
      "points": 110
    },
    {
      "name": "Danse Flamme",
      "points": 80
    }
  ],
  "defensePoints": 111,
  "healthPoints": 78,
  "rarityPercentage": 2.0,
  "imageURL": "https://assets.pokemon.com/assets/cms2/img/pokedex/full/006-mega-x.png"
}
```

**Request DTO**: `UpdatePokemonDto`

---

### 🔄 Backend Processing

```
1. Controller extracts {id} from route + receives UpdatePokemonDto
   ↓
2. ModelState validation (same as POST)
   ↓
3. Calls IPokemonService.UpdateAsync(id, dto)
   ↓
4. Service:
   - Gets existing Pokemon by ID
   - If not found → Returns null
   - If found:
     * Updates all properties
     * Clears existing attacks
     * Adds new attacks from DTO
   ↓
5. Repository.UpdateAsync(pokemon)
   - EF Core: UPDATE Pokemon
   - EF Core: DELETE old Attacks
   - EF Core: INSERT new Attacks
   - SaveChangesAsync()
   ↓
6. Maps updated entity → PokemonDto
   ↓
7. Controller returns:
   - If null → 404 NotFound
   - If updated → 200 OK with PokemonDto
```

---

### 📥 Backend Response (Success)

**Status Code**: `200 OK`

**Response Body**:
```json
{
  "id": 3,
  "name": "Dracaufeu Méga",
  "type": "FIRE",
  "attacks": [
    {
      "name": "Lance-Flammes",
      "points": 90
    },
    {
      "name": "Déflagration",
      "points": 110
    },
    {
      "name": "Danse Flamme",
      "points": 80
    }
  ],
  "defensePoints": 111,
  "healthPoints": 78,
  "rarityPercentage": 2.0,
  "imageURL": "https://assets.pokemon.com/assets/cms2/img/pokedex/full/006-mega-x.png",
  "isPartOfTeam": false
}
```

---

### 📥 Backend Response (Not Found)

**Status Code**: `404 Not Found`

**Response Body**:
```json
{
  "message": "Pokémon avec l'ID 999 introuvable"
}
```

---

### 🎨 Frontend Processing

```typescript
// 1. Receives 200 OK response
const updatedPokemon: Pokemon = response;

// 2. Converts rarityPercentage → captureRate
const pokemon = {
  ...updatedPokemon,
  captureRate: 1 - (updatedPokemon.rarityPercentage / 100)
};

// 3. Refreshes Pokemon list

// 4. Displays success notification
this.snackBar.open('Pokemon modifié avec succès', 'OK');

// 5. Navigates back to list
this.router.navigate(['/pokemons']);
```

---

### 📊 Data Flow Diagram

```
┌────────────────────────────────────────────────────────────────┐
│ FRONTEND                                                        │
│  User edits Pokemon → Submit                                   │
│         │                                                       │
│         ├─► Convert captureRate → rarityPercentage            │
│         │                                                       │
│         │ PUT /api/pokemon/3                                   │
│         │ Body: UpdatePokemonDto (JSON)                        │
│         ▼                                                       │
└────────────────────────────────────────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────────────────────────────┐
│ BACKEND                                                         │
│  Controller receives id + UpdatePokemonDto                      │
│         │                                                       │
│         ├─► Validate ModelState                               │
│         │                                                       │
│         ├─► Service.UpdateAsync(3, dto)                       │
│         │         │                                             │
│         │         ├─► Repository.GetByIdAsync(3)              │
│         │         │         │                                   │
│         │         │         ├─► Found? → Update entity        │
│         │         │         │   - Set properties              │
│         │         │         │   - Clear old attacks           │
│         │         │         │   - Add new attacks             │
│         │         │         │                                   │
│         │         │         └─► Not found? → Return null       │
│         │         │                                             │
│         │         ├─► Repository.UpdateAsync()                │
│         │         │         │                                   │
│         │         │         └─► UPDATE Pokemon + Attacks       │
│         │         │                                             │
│         │         └─► Returns PokemonDto or null              │
│         │                                                       │
│         └─► 200 OK with data OR 404 Not Found                 │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────────────────────────────┐
│ FRONTEND                                                        │
│  Receives updated Pokemon                                      │
│         │                                                       │
│         ├─► Convert rarityPercentage → captureRate            │
│         ├─► Refresh list                                       │
│         └─► Show success message                               │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 5. DELETE /api/pokemon/{id} - Delete Pokemon

### 📤 Frontend Request

**Angular Service**: `pokemon-service.ts:deletePokemon(id)`

```typescript
// 1. User clicks delete button → Confirmation
// 2. If confirmed, sends DELETE request
this.http.delete<void>(`http://localhost:5001/api/pokemon/${id}`)
```

**HTTP Request**:
```http
DELETE /api/pokemon/3 HTTP/1.1
Host: localhost:5001
```

**No Request Body** ✅

---

### 🔄 Backend Processing

```
1. Controller extracts {id} from route
   ↓
2. Calls IPokemonService.DeleteAsync(id)
   ↓
3. Service:
   - Gets Pokemon by ID
   - If not found → Returns false
   - If found → Calls Repository.DeleteAsync(pokemon)
   ↓
4. Repository:
   - EF Core: DELETE FROM Pokemon WHERE Id = @id
   - Cascade: DELETE FROM Attacks WHERE PokemonId = @id
   - SaveChangesAsync()
   ↓
5. Service returns true/false
   ↓
6. Controller returns:
   - If false → 404 NotFound
   - If true → 204 NoContent
```

---

### 📥 Backend Response (Success)

**Status Code**: `204 No Content`

**No Response Body** ✅

---

### 📥 Backend Response (Not Found)

**Status Code**: `404 Not Found`

**Response Body**:
```json
{
  "message": "Pokémon avec l'ID 999 introuvable"
}
```

---

### 🎨 Frontend Processing

```typescript
// 1. Receives 204 No Content (success)

// 2. Refreshes Pokemon list (calls getPokemons())

// 3. If Pokemon was in team, removes from $myTeam signal

// 4. Displays success notification
this.snackBar.open('Pokemon supprimé avec succès', 'OK');
```

---

### 📊 Data Flow Diagram

```
┌────────────────────────────────────────────────────────────────┐
│ FRONTEND                                                        │
│  User clicks Delete → Confirm                                  │
│         │                                                       │
│         │ DELETE /api/pokemon/3                                │
│         ▼                                                       │
└────────────────────────────────────────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────────────────────────────┐
│ BACKEND                                                         │
│  Controller receives DELETE request with id                     │
│         │                                                       │
│         ├─► Service.DeleteAsync(3)                            │
│         │         │                                             │
│         │         ├─► Repository.GetByIdAsync(3)              │
│         │         │         │                                   │
│         │         │         ├─► Found? → Delete               │
│         │         │         │   Repository.DeleteAsync()      │
│         │         │         │   - DELETE Pokemon              │
│         │         │         │   - CASCADE Delete Attacks      │
│         │         │         │                                   │
│         │         │         └─► Not found? → Return false      │
│         │         │                                             │
│         │         └─► Returns true/false                       │
│         │                                                       │
│         └─► 204 No Content OR 404 Not Found                   │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────────────────────────────┐
│ FRONTEND                                                        │
│  Receives 204 No Content                                       │
│         │                                                       │
│         ├─► Refresh Pokemon list                              │
│         ├─► Remove from team if applicable                    │
│         └─► Show success message                               │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 6. GET /api/attacks - List All Attacks

### 📤 Frontend Request

**Angular Service**: `attack-service.ts:getAttacks()`

```typescript
this.http.get<Attack[]>('http://localhost:5001/api/attacks')
```

**HTTP Request**:
```http
GET /api/attacks HTTP/1.1
Host: localhost:5001
Accept: application/json
```

**No Request Body** ✅

---

### 🔄 Backend Processing

```
1. Controller receives request
   ↓
2. Returns hardcoded list of AttackDto
   - 20 French attack names with points
   ↓
3. No database query (hardcoded data)
   ↓
4. Returns 200 OK with List<AttackDto>
```

---

### 📥 Backend Response

**Status Code**: `200 OK`

**Response Body**:
```json
[
  {
    "name": "Charge",
    "points": 40
  },
  {
    "name": "Éclair",
    "points": 55
  },
  {
    "name": "Vive-Attaque",
    "points": 40
  },
  {
    "name": "Tonnerre",
    "points": 90
  },
  {
    "name": "Fatal-Foudre",
    "points": 110
  },
  {
    "name": "Lance-Flammes",
    "points": 90
  },
  {
    "name": "Flammèche",
    "points": 40
  },
  {
    "name": "Déflagration",
    "points": 110
  },
  {
    "name": "Hydrocanon",
    "points": 110
  },
  {
    "name": "Pistolet à O",
    "points": 40
  },
  {
    "name": "Surf",
    "points": 90
  },
  {
    "name": "Tranch'Herbe",
    "points": 55
  },
  {
    "name": "Fouet Lianes",
    "points": 45
  },
  {
    "name": "Lance-Soleil",
    "points": 120
  },
  {
    "name": "Cru-Aile",
    "points": 60
  },
  {
    "name": "Tornade",
    "points": 40
  },
  {
    "name": "Piqué",
    "points": 90
  },
  {
    "name": "Plaquage",
    "points": 85
  },
  {
    "name": "Griffe",
    "points": 40
  },
  {
    "name": "Morsure",
    "points": 60
  }
]
```

**DTO Structure**: `AttackDto`
```csharp
public class AttackDto
{
    public string Name { get; set; }
    public int Points { get; set; }
}
```

---

### 🎨 Frontend Processing

```typescript
// 1. Receives attack list
const attacks: Attack[] = response;

// 2. Populates dropdown in Pokemon form
<mat-select formControlName="attacks" multiple>
  <mat-option *ngFor="let attack of availableAttacks" [value]="attack">
    {{ attack.name }} ({{ attack.points }} pts)
  </mat-option>
</mat-select>

// 3. User selects attacks when creating/editing Pokemon
```

**Frontend Attack Interface**:
```typescript
export interface Attack {
  name: string;
  points: number;
}
```

---

### 📊 Data Flow Diagram

```
┌────────────────────────────────────────────────────────────────┐
│ FRONTEND                                                        │
│  User opens Pokemon form                                       │
│         │                                                       │
│         │ GET /api/attacks                                     │
│         ▼                                                       │
└────────────────────────────────────────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────────────────────────────┐
│ BACKEND                                                         │
│  AttacksController.GetAll()                                     │
│         │                                                       │
│         └─► Returns hardcoded List<AttackDto>                 │
│             - 20 French attacks                                │
│             - Each with name and points                        │
│                                                                 │
│         Returns 200 OK with JSON array                         │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────────────────────────────┐
│ FRONTEND                                                        │
│  Receives attack list                                          │
│         │                                                       │
│         └─► Populates dropdown in form                        │
│             User can select multiple attacks                   │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## Summary Table: All Endpoints

| Endpoint | Method | Frontend Sends | Backend Returns | Status Codes |
|----------|--------|----------------|-----------------|--------------|
| `/api/pokemon` | GET | - | `Pokemon[]` | 200, 500 |
| `/api/pokemon/{id}` | GET | - | `Pokemon` | 200, 404 |
| `/api/pokemon` | POST | `CreatePokemonDto` | `Pokemon` | 201, 400, 500 |
| `/api/pokemon/{id}` | PUT | `UpdatePokemonDto` | `Pokemon` | 200, 400, 404, 500 |
| `/api/pokemon/{id}` | DELETE | - | - | 204, 404 |
| `/api/attacks` | GET | - | `Attack[]` | 200 |

---

## Key Data Transformations

### Frontend → Backend (POST/PUT)

```
captureRate (0-1) → rarityPercentage (0-100)

Formula: rarityPercentage = (1 - captureRate) * 100

Examples:
- captureRate: 0.95 → rarityPercentage: 5.0   (rare, easy to catch)
- captureRate: 0.50 → rarityPercentage: 50.0  (common, medium catch)
- captureRate: 0.10 → rarityPercentage: 90.0  (very rare, hard to catch)
```

### Backend → Frontend (GET)

```
rarityPercentage (0-100) → captureRate (0-1)

Formula: captureRate = 1 - (rarityPercentage / 100)

Examples:
- rarityPercentage: 5.0  → captureRate: 0.95
- rarityPercentage: 50.0 → captureRate: 0.50
- rarityPercentage: 90.0 → captureRate: 0.10
```

### Type Enum Handling

**Backend**: Enum stored as integer in DB, returned as string in JSON
```csharp
public enum PokemonType { NORMAL, FIRE, WATER, ... }
// DB: 1 (FIRE)
// JSON: "FIRE"
```

**Frontend**: String value matched to enum
```typescript
export enum PokemonType {
  NORMAL = "NORMAL",
  FIRE = "FIRE",
  ...
}
```

---

## Authentication Notes

**Current State**: Authentication DISABLED on all Pokemon CRUD endpoints

**Headers NOT Required**:
- ❌ `Authorization: Bearer {token}`

**Endpoints That Still Have Auth** (but not used by frontend):
- `POST /api/auth/register`
- `POST /api/auth/login`

---

## Error Handling

### Backend Error Responses

**Validation Error (400)**:
```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
  "title": "One or more validation errors occurred.",
  "status": 400,
  "errors": {
    "PropertyName": ["Error message"]
  }
}
```

**Not Found (404)**:
```json
{
  "message": "Pokémon avec l'ID {id} introuvable"
}
```

**Server Error (500)**:
```json
{
  "message": "An error occurred while processing your request"
}
```

### Frontend Error Handling

```typescript
// All errors caught by service
this.http.get<Pokemon[]>(url).pipe(
  catchError((error: HttpErrorResponse) => {
    if (error.status === 404) {
      this.snackBar.open('Pokemon non trouvé', 'OK');
    } else {
      this.snackBar.open('Une erreur est survenue', 'OK');
    }
    return throwError(() => error);
  })
);
```

---

## CORS Configuration

**Backend**: Allows all origins (development mode)
```csharp
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});
```

**Frontend**: No special CORS handling needed

---

## Complete Request/Response Flow Example

### Creating a New Pokemon - Full Journey

```
1. USER ACTION
   └─► User fills form in Angular app
       Name: "Bulbizarre"
       Type: "GRASS"
       HP: 45
       Defense: 49
       Capture Rate: 0.75 (slider 0-1)
       Attacks: ["Fouet Lianes", "Tranch'Herbe"]

2. ANGULAR SERVICE
   └─► Transforms data:
       captureRate (0.75) → rarityPercentage (25.0)
   └─► Creates request body (CreatePokemonDto)
   └─► Sends POST http://localhost:5001/api/pokemon

3. HTTP REQUEST
   POST /api/pokemon HTTP/1.1
   Content-Type: application/json

   Body: { name: "Bulbizarre", type: "GRASS", ... }

4. .NET CONTROLLER
   └─► Receives CreatePokemonDto
   └─► Validates with Data Annotations
   └─► Calls PokemonService.CreateAsync(dto)

5. SERVICE LAYER
   └─► Parses "GRASS" → PokemonType.GRASS enum
   └─► Creates Pokemon entity
   └─► Maps attacks from DTO to Attack entities
   └─► Calls PokemonRepository.AddAsync(pokemon)

6. REPOSITORY LAYER
   └─► EF Core: INSERT INTO Pokemon VALUES (...)
   └─► EF Core: INSERT INTO Attacks VALUES (...) (x2)
   └─► SaveChangesAsync()
   └─► Returns entity with Id = 4 (auto-generated)

7. SERVICE LAYER
   └─► Maps Pokemon entity → PokemonDto
   └─► Returns PokemonDto with Id = 4

8. CONTROLLER
   └─► Creates 201 Created response
   └─► Adds Location header: /api/pokemon/4
   └─► Returns PokemonDto as JSON

9. HTTP RESPONSE
   201 Created
   Location: http://localhost:5001/api/pokemon/4

   Body: { id: 4, name: "Bulbizarre", type: "GRASS", ... }

10. ANGULAR SERVICE
    └─► Receives PokemonDto
    └─► Transforms: rarityPercentage (25.0) → captureRate (0.75)
    └─► Calls getPokemons() to refresh list

11. ANGULAR COMPONENT
    └─► Displays success message
    └─► Navigates to Pokemon list
    └─► Shows new Pokemon in list with Id = 4

12. USER SEES
    └─► "Pokemon créé avec succès"
    └─► Bulbizarre appears in list
```

---

## End of Documentation

This schema covers all communication between the Angular Pokemon frontend and the .NET 8 Pokemon API backend. All endpoints are documented with request/response structures, data transformations, and processing flows.
