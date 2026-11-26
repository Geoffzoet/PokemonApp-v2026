# Plan d'Implémentation - Dresseurs & Captures

**Formation .NET MVC - 1 journée**
**Version** : 1.0
**Date** : 26 novembre 2026

---

## 1. Hypothèses et Incohérences Détectées

### Hypothèses de conception

1. **Propriété Team dans Trainer** : La propriété `Team` mentionnée dans les décisions de conception est une collection de `CaughtPokemon`, pas directement de `Pokemon`. Cela respecte la relation M-N via la table de jonction.

2. **Multiplicateur Master Ball** : Fixé à 10.0 (soit 1000% de bonus), mais la probabilité finale reste bornée à 100%. Cela signifie qu'une Master Ball ne garantit pas toujours la capture d'un Pokémon très rare (RarityPercentage très bas).

3. **Affichage des attaques** : Dans `_PokemonCard`, les attaques affichées proviennent de la navigation `CaughtPokemon -> Pokemon -> Attacks`. On affiche les 2 premières attaques seulement.

4. **Surnom (Nickname)** : Le champ `Nickname` de `CaughtPokemon` est optionnel. S'il est vide ou null, on affiche le nom du `Pokemon`. Dans cette version MVP, on ne permet pas de saisir un surnom à la capture (future fonctionnalité).

5. **Statistiques d'attaque** : La maquette `encounter-wild.html` affiche "Attaque : 52", mais l'entité `Pokemon` existante n'a pas de propriété `AttackPoints`. Cette stat sera calculée comme la moyenne des `Points` des attaques du Pokemon, ou ignorée si pas pertinent pour le MVP.

6. **Nombre de Pokémon affiché** : Dans `trainer-index`, "Nb de Pokémon" correspond à `trainer.Team.Count`.

### Incohérences détectées dans les mockups

#### Incohérence mineure 1 : Statistiques dans encounter-wild
La maquette affiche "Attaque : 52" mais `Pokemon` n'a pas cette propriété.
**Résolution** : Ne pas afficher cette stat dans la vue finale, ou la calculer dynamiquement comme `pokemon.Attacks.Average(a => a.Points)`.

#### Incohérence mineure 2 : Lien "Partir à l'aventure"
La maquette `trainer-details.html` pointe vers `encounter-wild.html`, mais selon le parcours défini, cela devrait être un lien vers `Encounter/Start` (GET) qui redirige ensuite vers `Encounter/Wild`.
**Résolution** : Le lien "Partir à l'aventure" appellera `asp-action="Start" asp-controller="Encounter"`.

#### Note : Navbar cohérente
Toutes les maquettes ont une navbar identique avec un seul lien "Dresseurs" pointant vers `trainer-index`. C'est cohérent avec le scope de la formation.

---

## 2. Modèle de Données

### 2.1 Entité `Trainer`

| Champ | Type C# | Nullable | Contraintes | Relation |
|-------|---------|----------|-------------|----------|
| `Id` | `int` | Non | Clé primaire, auto-incrémenté | - |
| `Name` | `string` | Non | MaxLength(100), Required | - |
| `Town` | `string` | Non | MaxLength(100), Required | - |
| `BadgeCount` | `int` | Non | Range(0, 8) | - |
| `Team` | `ICollection<CaughtPokemon>` | Non | Navigation property | 1-N vers CaughtPokemon |

### 2.2 Entité `CaughtPokemon`

| Champ | Type C# | Nullable | Contraintes | Relation |
|-------|---------|----------|-------------|----------|
| `Id` | `int` | Non | Clé primaire, auto-incrémenté | - |
| `TrainerId` | `int` | Non | Foreign key | N-1 vers Trainer |
| `PokemonId` | `int` | Non | Foreign key | N-1 vers Pokemon |
| `Nickname` | `string?` | Oui | MaxLength(50) | - |
| `CaughtAt` | `DateTime` | Non | Default: DateTime.Now | - |
| `BallUsed` | `BallType` | Non | Enum | - |
| `Trainer` | `Trainer` | Non | Navigation property | N-1 vers Trainer |
| `Pokemon` | `Pokemon` | Non | Navigation property | N-1 vers Pokemon |

### 2.3 Enum `BallType`

```csharp
public enum BallType
{
    PokeBall = 1,
    SuperBall = 2,
    MasterBall = 3
}
```

**Valeurs de multiplicateur** :
- `PokeBall` : 1.0
- `SuperBall` : 1.5
- `MasterBall` : 10.0

### 2.4 DbSets à ajouter dans `AppDbContext`

```csharp
public DbSet<Trainer> Trainers { get; set; }
public DbSet<CaughtPokemon> CaughtPokemons { get; set; }
```

**Configuration dans `OnModelCreating`** :

```csharp
modelBuilder.Entity<CaughtPokemon>(entity =>
{
    entity.HasKey(cp => cp.Id);

    entity.HasOne(cp => cp.Trainer)
          .WithMany(t => t.Team)
          .HasForeignKey(cp => cp.TrainerId)
          .OnDelete(DeleteBehavior.Cascade);

    entity.HasOne(cp => cp.Pokemon)
          .WithMany()
          .HasForeignKey(cp => cp.PokemonId)
          .OnDelete(DeleteBehavior.Restrict);

    entity.Property(cp => cp.CaughtAt)
          .HasDefaultValueSql("GETDATE()");
});

modelBuilder.Entity<Trainer>(entity =>
{
    entity.HasKey(t => t.Id);
    entity.Property(t => t.Name).IsRequired().HasMaxLength(100);
    entity.Property(t => t.Town).IsRequired().HasMaxLength(100);
});
```

### 2.5 Migration

**Nom de la migration** : `AddTrainerAndCaughtPokemon`

**Commande** :
```bash
dotnet ef migrations add AddTrainerAndCaughtPokemon
dotnet ef database update
```

### 2.6 Données de seed

**À ajouter dans `OnModelCreating` ou via une classe de seed** :

```csharp
modelBuilder.Entity<Trainer>().HasData(
    new Trainer { Id = 1, Name = "Sacha", Town = "Bourg Palette", BadgeCount = 8 },
    new Trainer { Id = 2, Name = "Ondine", Town = "Azuria", BadgeCount = 6 }
);

// Optionnel : quelques captures pour Sacha
modelBuilder.Entity<CaughtPokemon>().HasData(
    new CaughtPokemon
    {
        Id = 1,
        TrainerId = 1,
        PokemonId = 25, // Pikachu (supposé existant)
        CaughtAt = new DateTime(2026, 11, 15),
        BallUsed = BallType.PokeBall
    },
    new CaughtPokemon
    {
        Id = 2,
        TrainerId = 1,
        PokemonId = 4, // Salamèche
        CaughtAt = new DateTime(2026, 11, 10),
        BallUsed = BallType.SuperBall
    }
);
```

---

## 3. ViewModels

### 3.1 `CreateTrainerViewModel`

| Propriété | Type | DataAnnotations | Message d'erreur |
|-----------|------|-----------------|------------------|
| `Name` | `string` | `[Required]`, `[StringLength(100, MinimumLength = 1)]` | "Le nom est obligatoire", "Le nom doit contenir entre 1 et 100 caractères" |
| `Town` | `string` | `[Required]`, `[StringLength(100, MinimumLength = 1)]` | "La ville est obligatoire", "La ville doit contenir entre 1 et 100 caractères" |
| `BadgeCount` | `int` | `[Range(0, 8)]` | "Le nombre de badges doit être entre 0 et 8" |

### 3.2 `EditTrainerViewModel`

| Propriété | Type | DataAnnotations | Message d'erreur |
|-----------|------|-----------------|------------------|
| `Id` | `int` | Aucune (hidden field) | - |
| `Name` | `string` | `[Required]`, `[StringLength(100, MinimumLength = 1)]` | "Le nom est obligatoire", "Le nom doit contenir entre 1 et 100 caractères" |
| `Town` | `string` | `[Required]`, `[StringLength(100, MinimumLength = 1)]` | "La ville est obligatoire", "La ville doit contenir entre 1 et 100 caractères" |
| `BadgeCount` | `int` | `[Range(0, 8)]` | "Le nombre de badges doit être entre 0 et 8" |

### 3.3 `ThrowBallViewModel`

| Propriété | Type | DataAnnotations | Message d'erreur |
|-----------|------|-----------------|------------------|
| `TrainerId` | `int` | `[Required]` | "L'identifiant du dresseur est requis" |
| `PokemonId` | `int` | `[Required]` | "L'identifiant du Pokémon est requis" |
| `Ball` | `BallType` | `[Required]` | "Le choix de la Poké Ball est obligatoire" |

### 3.4 ViewModels de lecture (pas de validation)

#### `TrainerIndexViewModel`
```csharp
public class TrainerIndexViewModel
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Town { get; set; }
    public int BadgeCount { get; set; }
    public int PokemonCount { get; set; }
}
```

#### `TrainerDetailsViewModel`
```csharp
public class TrainerDetailsViewModel
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Town { get; set; }
    public int BadgeCount { get; set; }
    public List<CaughtPokemonCardViewModel> Team { get; set; }
}
```

#### `CaughtPokemonCardViewModel`
```csharp
public class CaughtPokemonCardViewModel
{
    public string DisplayName { get; set; } // Nickname si présent, sinon Pokemon.Name
    public string PokemonName { get; set; }
    public string Type { get; set; } // Enum.ToString()
    public DateTime CaughtAt { get; set; }
    public string ImageUrl { get; set; }
    public List<AttackViewModel> Attacks { get; set; } // Top 2
}
```

#### `AttackViewModel`
```csharp
public class AttackViewModel
{
    public string Name { get; set; }
    public int Points { get; set; }
}
```

#### `WildEncounterViewModel`
```csharp
public class WildEncounterViewModel
{
    public int TrainerId { get; set; }
    public int PokemonId { get; set; }
    public string PokemonName { get; set; }
    public string Type { get; set; }
    public int HealthPoints { get; set; }
    public int DefensePoints { get; set; }
    public string ImageUrl { get; set; }
}
```

---

## 4. Services

### 4.1 `IEncounterService`

**Responsabilité** : Gérer la logique de rencontre avec un Pokémon sauvage.

**Signatures** :
```csharp
public interface IEncounterService
{
    Task<Pokemon?> GetRandomWildPokemonAsync();
}
```

**Dépendances injectées** :
- `AppDbContext` (via constructeur)

**Durée de vie DI** : `Scoped`

**Règles métier** :
1. Tire un Pokémon aléatoire parmi tous les Pokémon en base.
2. Inclut les attaques (`Include(p => p.Attacks)`).
3. Si aucun Pokémon en base, retourne `null`.

**Implémentation (signature de la classe)** :
```csharp
public class EncounterService : IEncounterService
{
    private readonly AppDbContext _context;

    public EncounterService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<Pokemon?> GetRandomWildPokemonAsync();
}
```

### 4.2 `ICaptureService`

**Responsabilité** : Gérer la logique de capture d'un Pokémon.

**Signatures** :
```csharp
public interface ICaptureService
{
    Task<CaptureResult> TryCaptureAsync(int trainerId, int pokemonId, BallType ball);
}

public class CaptureResult
{
    public bool Success { get; set; }
    public string Message { get; set; }
    public CaughtPokemon? CaughtPokemon { get; set; }
}
```

**Dépendances injectées** :
- `AppDbContext` (via constructeur)

**Durée de vie DI** : `Scoped`

**Règles métier** :
1. Vérifier que le dresseur et le Pokémon existent.
2. Calculer la probabilité de capture :
   - `baseProb = pokemon.RarityPercentage`
   - `multiplier = GetBallMultiplier(ball)` (1.0, 1.5, 10.0)
   - `finalProb = Math.Min(100, Math.Max(5, baseProb * multiplier))`
3. Tirer un nombre aléatoire entre 0 et 100.
4. Si `random <= finalProb`, capture réussie :
   - Créer une nouvelle `CaughtPokemon`
   - Sauvegarder en base
   - Retourner `CaptureResult` avec `Success = true` et message "Pokémon capturé avec succès !"
5. Sinon, capture échouée :
   - Retourner `CaptureResult` avec `Success = false` et message "La capture a échoué ! Le Pokémon s'est enfui."

**Implémentation (signature de la classe)** :
```csharp
public class CaptureService : ICaptureService
{
    private readonly AppDbContext _context;
    private readonly Random _random = new Random();

    public CaptureService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<CaptureResult> TryCaptureAsync(int trainerId, int pokemonId, BallType ball);
    private double GetBallMultiplier(BallType ball);
}
```

---

## 5. Controllers

### 5.1 `TrainerController`

#### Action : `Index` (GET)

| Aspect | Détail |
|--------|--------|
| **Nom** | `Index` |
| **Verbe HTTP** | GET |
| **Route** | `/Trainer` ou `/Trainer/Index` |
| **Paramètres** | Aucun |
| **Ce qu'elle fait** | Récupère tous les dresseurs avec leur Team (`.Include(t => t.Team)`), mappe en `TrainerIndexViewModel` avec `PokemonCount = t.Team.Count` |
| **Retour** | `View(List<TrainerIndexViewModel>)` |
| **TempData** | Aucune |
| **Cas d'erreur** | Aucun (liste vide si pas de dresseurs) |

#### Action : `Details` (GET)

| Aspect | Détail |
|--------|--------|
| **Nom** | `Details` |
| **Verbe HTTP** | GET |
| **Route** | `/Trainer/Details/{id}` |
| **Paramètres** | `int id` |
| **Ce qu'elle fait** | Récupère le dresseur avec `.Include(t => t.Team).ThenInclude(cp => cp.Pokemon).ThenInclude(p => p.Attacks)`, mappe en `TrainerDetailsViewModel` |
| **Retour** | `View(TrainerDetailsViewModel)` ou `NotFound()` |
| **TempData** | Lecture de `TempData["Success"]`, `["Warning"]`, `["Error"]` pour afficher notifications après capture |
| **Cas d'erreur** | Si `id` invalide : `return NotFound()` |

#### Action : `Create` (GET)

| Aspect | Détail |
|--------|--------|
| **Nom** | `Create` |
| **Verbe HTTP** | GET |
| **Route** | `/Trainer/Create` |
| **Paramètres** | Aucun |
| **Ce qu'elle fait** | Affiche le formulaire vide |
| **Retour** | `View(new CreateTrainerViewModel())` |
| **TempData** | Aucune |
| **Cas d'erreur** | Aucun |

#### Action : `Create` (POST)

| Aspect | Détail |
|--------|--------|
| **Nom** | `Create` |
| **Verbe HTTP** | POST |
| **Route** | `/Trainer/Create` |
| **Paramètres** | `CreateTrainerViewModel model` |
| **Ce qu'elle fait** | Valide le model, crée une entité `Trainer`, sauvegarde, redirige |
| **Retour** | `RedirectToAction("Index")` ou `View(model)` si erreur |
| **TempData** | `TempData["Success"] = "Dresseur créé avec succès !"` |
| **Cas d'erreur** | Si `!ModelState.IsValid` : retour du formulaire avec erreurs |

#### Action : `Edit` (GET)

| Aspect | Détail |
|--------|--------|
| **Nom** | `Edit` |
| **Verbe HTTP** | GET |
| **Route** | `/Trainer/Edit/{id}` |
| **Paramètres** | `int id` |
| **Ce qu'elle fait** | Récupère le dresseur, mappe en `EditTrainerViewModel` |
| **Retour** | `View(EditTrainerViewModel)` ou `NotFound()` |
| **TempData** | Aucune |
| **Cas d'erreur** | Si `id` invalide : `return NotFound()` |

#### Action : `Edit` (POST)

| Aspect | Détail |
|--------|--------|
| **Nom** | `Edit` |
| **Verbe HTTP** | POST |
| **Route** | `/Trainer/Edit/{id}` |
| **Paramètres** | `int id`, `EditTrainerViewModel model` |
| **Ce qu'elle fait** | Valide, récupère l'entité, met à jour, sauvegarde, redirige |
| **Retour** | `RedirectToAction("Index")` ou `View(model)` si erreur |
| **TempData** | `TempData["Success"] = "Dresseur modifié avec succès !"` |
| **Cas d'erreur** | Si `!ModelState.IsValid` ou `id != model.Id` : retour du formulaire ; si dresseur introuvable : `NotFound()` |

#### Action : `Delete` (GET)

| Aspect | Détail |
|--------|--------|
| **Nom** | `Delete` |
| **Verbe HTTP** | GET |
| **Route** | `/Trainer/Delete/{id}` |
| **Paramètres** | `int id` |
| **Ce qu'elle fait** | Récupère le dresseur, affiche la page de confirmation |
| **Retour** | `View(Trainer)` ou `NotFound()` |
| **TempData** | Aucune |
| **Cas d'erreur** | Si `id` invalide : `return NotFound()` |

#### Action : `DeleteConfirmed` (POST)

| Aspect | Détail |
|--------|--------|
| **Nom** | `DeleteConfirmed` |
| **Verbe HTTP** | POST |
| **Route** | `/Trainer/Delete/{id}` (même route que GET, mais POST) |
| **Paramètres** | `int id` |
| **Ce qu'elle fait** | Supprime le dresseur (cascade supprime les `CaughtPokemon`), sauvegarde, redirige |
| **Retour** | `RedirectToAction("Index")` |
| **TempData** | `TempData["Success"] = "Dresseur supprimé avec succès !"` |
| **Cas d'erreur** | Si dresseur introuvable : `NotFound()` |

### 5.2 `EncounterController`

#### Action : `Start` (GET)

| Aspect | Détail |
|--------|--------|
| **Nom** | `Start` |
| **Verbe HTTP** | GET |
| **Route** | `/Encounter/Start` |
| **Paramètres** | `int trainerId` (depuis query string ou route) |
| **Ce qu'elle fait** | Appelle `_encounterService.GetRandomWildPokemonAsync()`, redirige vers `Wild` |
| **Retour** | `RedirectToAction("Wild", new { trainerId, pokemonId })` |
| **TempData** | Aucune |
| **Cas d'erreur** | Si aucun Pokémon disponible : `TempData["Warning"] = "Aucun Pokémon sauvage disponible"`, `RedirectToAction("Details", "Trainer", new { id = trainerId })` |

#### Action : `Wild` (GET)

| Aspect | Détail |
|--------|--------|
| **Nom** | `Wild` |
| **Verbe HTTP** | GET |
| **Route** | `/Encounter/Wild` |
| **Paramètres** | `int trainerId`, `int pokemonId` |
| **Ce qu'elle fait** | Récupère le Pokémon avec `.Include(p => p.Attacks)`, mappe en `WildEncounterViewModel` |
| **Retour** | `View(WildEncounterViewModel)` |
| **TempData** | Aucune |
| **Cas d'erreur** | Si Pokémon ou Trainer introuvable : `NotFound()` |

#### Action : `Throw` (POST)

| Aspect | Détail |
|--------|--------|
| **Nom** | `Throw` |
| **Verbe HTTP** | POST |
| **Route** | `/Encounter/Throw` |
| **Paramètres** | `ThrowBallViewModel model` |
| **Ce qu'elle fait** | Valide le model, appelle `_captureService.TryCaptureAsync()`, définit TempData selon résultat, redirige |
| **Retour** | `RedirectToAction("Details", "Trainer", new { id = model.TrainerId })` |
| **TempData** | Si succès : `TempData["Success"] = result.Message` ; si échec : `TempData["Error"] = result.Message` |
| **Cas d'erreur** | Si `!ModelState.IsValid` : `TempData["Error"] = "Données invalides"`, redirige vers Details |

---

## 6. Vues

### 6.1 `Views/Trainer/Index.cshtml`

| Aspect | Détail |
|--------|--------|
| **Chemin** | `Views/Trainer/Index.cshtml` |
| **Maquette source** | `mockups/trainer-index.html` |
| **Type** | Liste (tableau) |
| **@model** | `IEnumerable<TrainerIndexViewModel>` |
| **Tag helpers** | `asp-action`, `asp-controller`, `asp-route-id` |
| **HTML helpers** | Aucun |
| **Partials** | Aucune |
| **Sections** | Aucune |
| **Liens/Forms** | `<a asp-action="Create">Nouveau dresseur</a>`, `<a asp-action="Details" asp-route-id="@item.Id">Détails</a>`, `<a asp-action="Edit" asp-route-id="@item.Id">Modifier</a>`, `<a asp-action="Delete" asp-route-id="@item.Id">Supprimer</a>` |
| **Foreach** | `@foreach(var item in Model)` pour chaque ligne du tableau |

### 6.2 `Views/Trainer/Details.cshtml`

| Aspect | Détail |
|--------|--------|
| **Chemin** | `Views/Trainer/Details.cshtml` |
| **Maquette source** | `mockups/trainer-details.html` |
| **Type** | Détail + grille de cartes |
| **@model** | `TrainerDetailsViewModel` |
| **Tag helpers** | `asp-action`, `asp-controller`, `asp-route-id`, `asp-route-trainerId` |
| **HTML helpers** | Aucun (sauf TempData lu dans _Layout) |
| **Partials** | `<partial name="_PokemonCard" model="item" />` dans le foreach |
| **Sections** | Aucune |
| **Liens/Forms** | `<a asp-action="Start" asp-controller="Encounter" asp-route-trainerId="@Model.Id">Partir à l'aventure</a>`, `<a asp-action="Edit" asp-route-id="@Model.Id">Modifier</a>`, `<a asp-action="Delete" asp-route-id="@Model.Id">Supprimer</a>` |
| **Foreach** | `@foreach(var item in Model.Team)` pour afficher les cartes Pokémon |

### 6.3 `Views/Trainer/Create.cshtml`

| Aspect | Détail |
|--------|--------|
| **Chemin** | `Views/Trainer/Create.cshtml` |
| **Maquette source** | `mockups/trainer-create.html` |
| **Type** | Formulaire de création |
| **@model** | `CreateTrainerViewModel` |
| **Tag helpers** | `asp-action`, `asp-for`, `asp-validation-for` |
| **HTML helpers** | Aucun |
| **Partials** | `<partial name="_TrainerForm" model="Model" />` |
| **Sections** | `@section Scripts { <partial name="_ValidationScriptsPartial" /> }` |
| **Liens/Forms** | `<form asp-action="Create" method="post">`, `<a asp-action="Index">Annuler</a>` |

### 6.4 `Views/Trainer/Edit.cshtml`

| Aspect | Détail |
|--------|--------|
| **Chemin** | `Views/Trainer/Edit.cshtml` |
| **Maquette source** | `mockups/trainer-edit.html` |
| **Type** | Formulaire de modification |
| **@model** | `EditTrainerViewModel` |
| **Tag helpers** | `asp-action`, `asp-route-id`, `asp-for`, `asp-validation-for` |
| **HTML helpers** | Aucun |
| **Partials** | `<partial name="_TrainerForm" model="Model" />` |
| **Sections** | `@section Scripts { <partial name="_ValidationScriptsPartial" /> }` |
| **Liens/Forms** | `<form asp-action="Edit" asp-route-id="@Model.Id" method="post">`, `<input asp-for="Id" type="hidden" />`, `<a asp-action="Index">Annuler</a>` |

### 6.5 `Views/Trainer/Delete.cshtml`

| Aspect | Détail |
|--------|--------|
| **Chemin** | `Views/Trainer/Delete.cshtml` |
| **Maquette source** | `mockups/trainer-delete.html` |
| **Type** | Confirmation de suppression |
| **@model** | `Trainer` (entité directe) |
| **Tag helpers** | `asp-action`, `asp-route-id` |
| **HTML helpers** | Aucun |
| **Partials** | Aucune |
| **Sections** | Aucune |
| **Liens/Forms** | `<form asp-action="DeleteConfirmed" asp-route-id="@Model.Id" method="post">`, `<a asp-action="Index">Annuler</a>` |

### 6.6 `Views/Encounter/Wild.cshtml`

| Aspect | Détail |
|--------|--------|
| **Chemin** | `Views/Encounter/Wild.cshtml` |
| **Maquette source** | `mockups/encounter-wild.html` |
| **Type** | Interactive (choix de balle + soumission) |
| **@model** | `WildEncounterViewModel` |
| **Tag helpers** | `asp-action`, `asp-for`, `asp-validation-for` |
| **HTML helpers** | `@Html.DropDownListFor()` pour le select Ball (alternative aux tag helpers) |
| **Partials** | Aucune |
| **Sections** | Aucune |
| **Liens/Forms** | `<form asp-action="Throw" asp-controller="Encounter" method="post">`, `<input asp-for="TrainerId" type="hidden" />`, `<input asp-for="PokemonId" type="hidden" />`, `<select asp-for="Ball">`, `<a asp-action="Details" asp-controller="Trainer" asp-route-id="@Model.TrainerId">Fuir</a>` |

---

## 7. Partials et Layout

### 7.1 Partial `_TrainerForm.cshtml`

**Modèle attendu** : `CreateTrainerViewModel` ou `EditTrainerViewModel` (structures identiques)

**Paramètres** : Aucun (utilise directement `@model`)

**Contenu** :
- Champs : `Name`, `Town`, `BadgeCount`
- Tag helpers : `asp-for`, `asp-validation-for`
- Champ caché `Id` **seulement si** appelée depuis Edit (géré dans la vue parente)

**Utilisation** :
```cshtml
<partial name="_TrainerForm" model="Model" />
```

### 7.2 Partial `_PokemonCard.cshtml`

**Modèle attendu** : `CaughtPokemonCardViewModel`

**Paramètres** : Aucun (utilise directement `@model`)

**Contenu** :
- Affiche : image, DisplayName, type badge, date de capture, liste des 2 attaques
- CSS classe : `.pokemon-card`

**Utilisation** :
```cshtml
@foreach(var pokemon in Model.Team)
{
    <partial name="_PokemonCard" model="pokemon" />
}
```

### 7.3 Modifications de `_Layout.cshtml`

#### Navbar
Ajouter le lien "Dresseurs" :
```cshtml
<li class="nav-item">
    <a class="nav-link" asp-controller="Trainer" asp-action="Index">
        <i class="bi bi-person-badge"></i> Dresseurs
    </a>
</li>
```

#### Scripts Toastr (avant `</body>`)
```cshtml
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
<script>
    toastr.options = {
        "closeButton": true,
        "progressBar": true,
        "positionClass": "toast-top-right",
        "timeOut": "3000"
    };
</script>
```

#### CSS Toastr (dans `<head>`)
```cshtml
<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet" />
```

#### Bloc TempData (après le `<div class="container">` principal)
```cshtml
@if (TempData["Success"] != null)
{
    <script>
        toastr.success('@TempData["Success"]', 'Succès');
    </script>
}
@if (TempData["Warning"] != null)
{
    <script>
        toastr.warning('@TempData["Warning"]', 'Attention');
    </script>
}
@if (TempData["Error"] != null)
{
    <script>
        toastr.error('@TempData["Error"]', 'Erreur');
    </script>
}
```

### 7.4 Configuration de la route par défaut

Dans `Program.cs`, **après** `app.UseAuthorization()` :

```csharp
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Trainer}/{action=Index}/{id?}");
```

---

## 8. Liste des Tâches d'Implémentation

### Bloc 1 : Préparation (PRÉPARÉ À L'AVANCE)

#### T01 : Créer le projet ASP.NET Core MVC

| ID | T01 |
|----|-----|
| **Titre** | Créer le projet et configurer la structure |
| **Fichiers créés** | `PokemonApp.csproj`, `Program.cs`, `AppDbContext.cs`, structure de dossiers |
| **Fichiers modifiés** | - |
| **Dépendances** | Aucune |
| **Durée estimée** | 15 min |
| **Mode** | PRÉPARÉ À L'AVANCE |
| **Notion pédagogique** | Structure de projet MVC |
| **Critère de validation** | Le projet compile et démarre sur `https://localhost:5001` |
| **Priorité** | MUST |

#### T02 : Créer les entités Trainer et CaughtPokemon

| ID | T02 |
|----|-----|
| **Titre** | Créer les modèles Trainer, CaughtPokemon, BallType |
| **Fichiers créés** | `Models/Trainer.cs`, `Models/CaughtPokemon.cs`, `Models/BallType.cs` |
| **Fichiers modifiés** | - |
| **Dépendances** | T01 |
| **Durée estimée** | 10 min |
| **Mode** | PRÉPARÉ À L'AVANCE |
| **Notion pédagogique** | Entités EF Core, relations 1-N |
| **Critère de validation** | Les classes compilent sans erreur |
| **Priorité** | MUST |

#### T03 : Configurer DbContext et créer la migration

| ID | T03 |
|----|-----|
| **Titre** | Ajouter DbSets et configuration dans AppDbContext, générer migration |
| **Fichiers créés** | `Migrations/xxx_AddTrainerAndCaughtPokemon.cs` |
| **Fichiers modifiés** | `Data/AppDbContext.cs` |
| **Dépendances** | T02 |
| **Durée estimée** | 15 min |
| **Mode** | PRÉPARÉ À L'AVANCE |
| **Notion pédagogique** | DbContext, migrations EF Core |
| **Critère de validation** | `dotnet ef database update` réussit sans erreur |
| **Priorité** | MUST |

#### T04 : Ajouter les données de seed

| ID | T04 |
|----|-----|
| **Titre** | Seed 2 dresseurs et quelques Pokémon capturés |
| **Fichiers créés** | - |
| **Fichiers modifiés** | `Data/AppDbContext.cs` (OnModelCreating) |
| **Dépendances** | T03 |
| **Durée estimée** | 10 min |
| **Mode** | PRÉPARÉ À L'AVANCE |
| **Notion pédagogique** | Seed data EF Core |
| **Critère de validation** | Après migration, la DB contient Sacha et Ondine |
| **Priorité** | SHOULD |

#### T05 : Configurer _Layout, CSS et toastr

| ID | T05 |
|----|-----|
| **Titre** | Préparer _Layout avec navbar, footer, scripts toastr, CSS site.css |
| **Fichiers créés** | `wwwroot/css/site.css` (copié depuis mockups) |
| **Fichiers modifiés** | `Views/Shared/_Layout.cshtml` |
| **Dépendances** | T01 |
| **Durée estimée** | 20 min |
| **Mode** | PRÉPARÉ À L'AVANCE |
| **Notion pédagogique** | Layout Razor, CSS, CDN, scripts |
| **Critère de validation** | La page d'accueil s'affiche avec navbar et footer stylisés |
| **Priorité** | MUST |

#### T06 : Enregistrer les services dans Program.cs

| ID | T06 |
|----|-----|
| **Titre** | Enregistrer DbContext, services (IEncounterService, ICaptureService) |
| **Fichiers créés** | - |
| **Fichiers modifiés** | `Program.cs` |
| **Dépendances** | T03, T10, T11 |
| **Durée estimée** | 5 min |
| **Mode** | PRÉPARÉ À L'AVANCE |
| **Notion pédagogique** | Dependency Injection, durée de vie (Scoped) |
| **Critère de validation** | L'app démarre sans erreur DI |
| **Priorité** | MUST |

---

### Bloc 2 : Théorie (1h30 - EN LIVE)

#### T07 : Présentation DI et services

| ID | T07 |
|----|-----|
| **Titre** | Expliquer Dependency Injection, Scoped/Transient/Singleton |
| **Fichiers créés** | - |
| **Fichiers modifiés** | - |
| **Dépendances** | T06 |
| **Durée estimée** | 20 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Dependency Injection théorique |
| **Critère de validation** | Les étudiants comprennent le concept de DI |
| **Priorité** | MUST |

#### T08 : Présentation Tag Helpers vs HTML Helpers

| ID | T08 |
|----|-----|
| **Titre** | Montrer asp-action, asp-for, asp-validation-for vs @Html.ActionLink, @Html.TextBoxFor |
| **Fichiers créés** | - |
| **Fichiers modifiés** | - |
| **Dépendances** | Aucune |
| **Durée estimée** | 20 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Tag Helpers, HTML Helpers |
| **Critère de validation** | Les étudiants savent différencier les deux approches |
| **Priorité** | MUST |

#### T09 : Présentation TempData et Toastr

| ID | T09 |
|----|-----|
| **Titre** | Expliquer TempData, pattern PRG, intégration toastr dans _Layout |
| **Fichiers créés** | - |
| **Fichiers modifiés** | - |
| **Dépendances** | T05 |
| **Durée estimée** | 15 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | TempData, Post-Redirect-Get, notifications |
| **Critère de validation** | Les étudiants comprennent le pattern PRG |
| **Priorité** | MUST |

---

### Bloc 3 : Trainer Index et Create (1h30 - EN LIVE)

#### T10 : Créer TrainerController et action Index

| ID | T10 |
|----|-----|
| **Titre** | Créer TrainerController, action Index (GET), ViewModel |
| **Fichiers créés** | `Controllers/TrainerController.cs`, `ViewModels/TrainerIndexViewModel.cs` |
| **Fichiers modifiés** | - |
| **Dépendances** | T03, T07 |
| **Durée estimée** | 20 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Controller, injection DbContext, LINQ Include |
| **Critère de validation** | `/Trainer` affiche la liste vide ou avec Sacha et Ondine |
| **Priorité** | MUST |

#### T11 : Créer la vue Trainer/Index

| ID | T11 |
|----|-----|
| **Titre** | Créer la vue Index avec tableau, liens tag helpers |
| **Fichiers créés** | `Views/Trainer/Index.cshtml` |
| **Fichiers modifiés** | - |
| **Dépendances** | T10 |
| **Durée estimée** | 25 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Vue Razor, @model, @foreach, tag helpers (asp-action, asp-route-id) |
| **Critère de validation** | La page `/Trainer` affiche le tableau avec 2 lignes (Sacha, Ondine) |
| **Priorité** | MUST |

#### T12 : Créer les actions Create (GET et POST)

| ID | T12 |
|----|-----|
| **Titre** | Ajouter actions Create GET et POST dans TrainerController |
| **Fichiers créés** | `ViewModels/CreateTrainerViewModel.cs` |
| **Fichiers modifiés** | `Controllers/TrainerController.cs` |
| **Dépendances** | T10 |
| **Durée estimée** | 20 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Actions GET/POST, ModelState, TempData, PRG |
| **Critère de validation** | Soumission du formulaire crée un dresseur et redirige vers Index avec notification |
| **Priorité** | MUST |

#### T13 : Créer la vue Trainer/Create

| ID | T13 |
|----|-----|
| **Titre** | Créer la vue Create avec formulaire, validation |
| **Fichiers créés** | `Views/Trainer/Create.cshtml` |
| **Fichiers modifiés** | - |
| **Dépendances** | T12 |
| **Durée estimée** | 25 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Formulaires Razor, asp-for, asp-validation-for, _ValidationScriptsPartial |
| **Critère de validation** | Le formulaire `/Trainer/Create` s'affiche et valide correctement (nom vide = erreur) |
| **Priorité** | MUST |

---

### Bloc 4 : Edit, partial _TrainerForm, Delete (1h - EN LIVE)

#### T14 : Créer la partial _TrainerForm

| ID | T14 |
|----|-----|
| **Titre** | Extraire le formulaire commun dans _TrainerForm.cshtml |
| **Fichiers créés** | `Views/Shared/_TrainerForm.cshtml` |
| **Fichiers modifiés** | `Views/Trainer/Create.cshtml` (utilise partial) |
| **Dépendances** | T13 |
| **Durée estimée** | 15 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Partial views, réutilisation de code |
| **Critère de validation** | Le formulaire Create fonctionne toujours après extraction |
| **Priorité** | SHOULD |

#### T15 : Créer les actions Edit (GET et POST)

| ID | T15 |
|----|-----|
| **Titre** | Ajouter actions Edit GET et POST dans TrainerController |
| **Fichiers créés** | `ViewModels/EditTrainerViewModel.cs` |
| **Fichiers modifiés** | `Controllers/TrainerController.cs` |
| **Dépendances** | T10 |
| **Durée estimée** | 15 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Update d'entité, hidden field (Id) |
| **Critère de validation** | Modifier Sacha et changer son nombre de badges fonctionne |
| **Priorité** | MUST |

#### T16 : Créer la vue Trainer/Edit

| ID | T16 |
|----|-----|
| **Titre** | Créer la vue Edit réutilisant _TrainerForm |
| **Fichiers créés** | `Views/Trainer/Edit.cshtml` |
| **Fichiers modifiés** | - |
| **Dépendances** | T14, T15 |
| **Durée estimée** | 10 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Partial views avec données pré-remplies, hidden field |
| **Critère de validation** | Le formulaire Edit affiche les données du dresseur et permet la modification |
| **Priorité** | MUST |

#### T17 : Créer les actions Delete (GET et POST)

| ID | T17 |
|----|-----|
| **Titre** | Ajouter actions Delete GET et DeleteConfirmed POST |
| **Fichiers créés** | - |
| **Fichiers modifiés** | `Controllers/TrainerController.cs` |
| **Dépendances** | T10 |
| **Durée estimée** | 10 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Suppression cascade, confirmation |
| **Critère de validation** | Supprimer Ondine fonctionne et affiche une notification |
| **Priorité** | MUST |

#### T18 : Créer la vue Trainer/Delete

| ID | T18 |
|----|-----|
| **Titre** | Créer la vue Delete avec confirmation |
| **Fichiers créés** | `Views/Trainer/Delete.cshtml` |
| **Fichiers modifiés** | - |
| **Dépendances** | T17 |
| **Durée estimée** | 10 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Page de confirmation, PRG |
| **Critère de validation** | La page `/Trainer/Delete/1` affiche les infos de Sacha et permet la suppression |
| **Priorité** | MUST |

---

### Bloc 5 : Services, EncounterController, vue Wild (1h30 - EN LIVE)

#### T19 : Créer IEncounterService et implémentation

| ID | T19 |
|----|-----|
| **Titre** | Créer interface et classe EncounterService |
| **Fichiers créés** | `Services/IEncounterService.cs`, `Services/EncounterService.cs` |
| **Fichiers modifiés** | - |
| **Dépendances** | T07 |
| **Durée estimée** | 20 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Services métier, injection, LINQ (OrderBy random) |
| **Critère de validation** | Le service compile et peut être injecté |
| **Priorité** | MUST |

#### T20 : Créer ICaptureService et implémentation

| ID | T20 |
|----|-----|
| **Titre** | Créer interface et classe CaptureService avec logique probabiliste |
| **Fichiers créés** | `Services/ICaptureService.cs`, `Services/CaptureService.cs`, `Services/CaptureResult.cs` |
| **Fichiers modifiés** | - |
| **Dépendances** | T07 |
| **Durée estimée** | 30 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Logique métier complexe, Random, calcul probabiliste |
| **Critère de validation** | Le service compile et la méthode TryCaptureAsync existe |
| **Priorité** | MUST |

#### T21 : Créer EncounterController avec actions Start et Wild

| ID | T21 |
|----|-----|
| **Titre** | Créer EncounterController, actions Start (GET) et Wild (GET) |
| **Fichiers créés** | `Controllers/EncounterController.cs`, `ViewModels/WildEncounterViewModel.cs` |
| **Fichiers modifiés** | - |
| **Dépendances** | T19 |
| **Durée estimée** | 20 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Injection de service, redirection avec paramètres |
| **Critère de validation** | `/Encounter/Start?trainerId=1` redirige vers `/Encounter/Wild?trainerId=1&pokemonId=X` |
| **Priorité** | MUST |

#### T22 : Créer la vue Encounter/Wild

| ID | T22 |
|----|-----|
| **Titre** | Créer la vue Wild avec formulaire de choix de balle |
| **Fichiers créés** | `Views/Encounter/Wild.cshtml` |
| **Fichiers modifiés** | - |
| **Dépendances** | T21 |
| **Durée estimée** | 20 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Select avec enum, hidden fields, HTML helpers (@Html.DropDownListFor) |
| **Critère de validation** | La page Wild affiche un Pokémon et le formulaire de choix de balle |
| **Priorité** | MUST |

---

### Bloc 6 : Details avec _PokemonCard et résultat de capture (1h - EN LIVE)

#### T23 : Créer l'action Throw (POST)

| ID | T23 |
|----|-----|
| **Titre** | Ajouter action Throw POST dans EncounterController |
| **Fichiers créés** | `ViewModels/ThrowBallViewModel.cs` |
| **Fichiers modifiés** | `Controllers/EncounterController.cs` |
| **Dépendances** | T20, T21 |
| **Durée estimée** | 15 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Appel de service, TempData selon résultat, PRG |
| **Critère de validation** | Lancer une balle redirige vers Details avec notification succès ou échec |
| **Priorité** | MUST |

#### T24 : Créer l'action Details

| ID | T24 |
|----|-----|
| **Titre** | Ajouter action Details dans TrainerController |
| **Fichiers créés** | `ViewModels/TrainerDetailsViewModel.cs`, `ViewModels/CaughtPokemonCardViewModel.cs`, `ViewModels/AttackViewModel.cs` |
| **Fichiers modifiés** | `Controllers/TrainerController.cs` |
| **Dépendances** | T10 |
| **Durée estimée** | 20 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Include avec ThenInclude, mapping vers ViewModels |
| **Critère de validation** | `/Trainer/Details/1` affiche les infos de Sacha |
| **Priorité** | MUST |

#### T25 : Créer la partial _PokemonCard

| ID | T25 |
|----|-----|
| **Titre** | Créer la partial _PokemonCard.cshtml |
| **Fichiers créés** | `Views/Shared/_PokemonCard.cshtml` |
| **Fichiers modifiés** | - |
| **Dépendances** | T24 |
| **Durée estimée** | 15 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Partial views avec modèle typé, affichage conditionnel |
| **Critère de validation** | La carte affiche correctement le Pokémon avec ses attaques |
| **Priorité** | MUST |

#### T26 : Créer la vue Trainer/Details

| ID | T26 |
|----|-----|
| **Titre** | Créer la vue Details avec grille de _PokemonCard |
| **Fichiers créés** | `Views/Trainer/Details.cshtml` |
| **Fichiers modifiés** | - |
| **Dépendances** | T24, T25 |
| **Durée estimée** | 10 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Partial views dans foreach, lien vers Encounter/Start |
| **Critère de validation** | La page Details affiche l'équipe de Sacha avec 2 Pokémon capturés |
| **Priorité** | MUST |

---

### Bloc 7 : Marge, CSS, questions (30 min - EN LIVE)

#### T27 : Ajustements CSS et responsive

| ID | T27 |
|----|-----|
| **Titre** | Ajuster site.css pour améliorer le responsive et les détails visuels |
| **Fichiers créés** | - |
| **Fichiers modifiés** | `wwwroot/css/site.css` |
| **Dépendances** | T26 |
| **Durée estimée** | 15 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | CSS, media queries, Bootstrap |
| **Critère de validation** | L'app est visuellement correcte sur mobile et desktop |
| **Priorité** | COULD |

#### T28 : Tests de bout en bout et démo

| ID | T28 |
|----|-----|
| **Titre** | Tester le parcours complet : créer dresseur, partir à l'aventure, capturer |
| **Fichiers créés** | - |
| **Fichiers modifiés** | - |
| **Dépendances** | T23, T26 |
| **Durée estimée** | 10 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Tests manuels, débogage |
| **Critère de validation** | Le parcours fonctionne de bout en bout sans erreur |
| **Priorité** | MUST |

#### T29 : Questions/réponses et consolidation

| ID | T29 |
|----|-----|
| **Titre** | Répondre aux questions, clarifier concepts |
| **Fichiers créés** | - |
| **Fichiers modifiés** | - |
| **Dépendances** | T28 |
| **Durée estimée** | 5 min |
| **Mode** | EN LIVE AVEC LES ÉTUDIANTS |
| **Notion pédagogique** | Toutes |
| **Critère de validation** | Les étudiants comprennent le projet global |
| **Priorité** | SHOULD |

---

## 9. Matrice de Couverture des Notions

| Notion | Tâches illustratives |
|--------|---------------------|
| **Controller** | T10, T12, T15, T17, T21, T23, T24 |
| **DbContext** | T03, T10, T19, T20, T24 |
| **Migration** | T03, T04 |
| **ViewModel / Validation** | T12, T13, T15, T22, T23, T24 |
| **@foreach Razor** | T11, T26 |
| **Tag Helpers** | T08, T11, T13, T16, T18, T22, T26 |
| **HTML Helpers** | T22 (DropDownListFor) |
| **Partial Views** | T14, T25, T26 |
| **CRUD complet** | T10 à T18 |
| **Post-Redirect-Get** | T12, T15, T17, T23 |
| **Dependency Injection** | T06, T07, T10, T19, T20, T21 |
| **TempData / Toastr** | T05, T09, T12, T15, T17, T23 |
| **Include / ThenInclude** | T10, T24 |
| **Services métier** | T19, T20, T21, T23 |
| **Logique probabiliste** | T20, T23 |

---

## 10. Points de Contrôle

### PC1 : Fin du Bloc 3 (après T13 - ~11h00)

**État attendu** : CRUD basique Trainer (Index + Create) fonctionne

**Vérification** :
- Accéder à `/Trainer` : tableau avec Sacha et Ondine
- Cliquer "Nouveau dresseur", remplir le formulaire, soumettre
- Vérifier qu'un 3ème dresseur apparaît dans la liste
- Vérifier notification toastr "Dresseur créé avec succès !"

**Si en retard** : Sauter T14 (_TrainerForm), laisser les formulaires en dur dans Create et Edit

---

### PC2 : Fin du Bloc 4 (après T18 - ~12h30)

**État attendu** : CRUD complet Trainer (Edit, Delete) fonctionne

**Vérification** :
- Modifier un dresseur (changer son nombre de badges)
- Supprimer un dresseur (page de confirmation + suppression)
- Vérifier notifications toastr

**Si en retard** : Sauter T14 (partial) si pas déjà fait, et T27 (CSS)

---

### PC3 : Fin du Bloc 5 (après T22 - ~14h30)

**État attendu** : Services créés, Encounter/Wild fonctionne

**Vérification** :
- Accéder à `/Encounter/Start?trainerId=1`
- Vérifier redirection vers `/Encounter/Wild` avec un Pokémon aléatoire
- Formulaire de choix de balle s'affiche

**Si en retard** : Sauter T27 (CSS), T29 (Q&A), réduire T20 (simplifier la logique de capture à une probabilité fixe de 50%)

---

### PC4 : Fin du Bloc 6 (après T26 - ~15h30)

**État attendu** : Capture fonctionne de bout en bout

**Vérification** :
- Partir à l'aventure depuis `/Trainer/Details/1`
- Choisir une balle, lancer
- Vérifier notification succès ou échec
- Si succès, vérifier que le Pokémon apparaît dans l'équipe sur Details

**Si en retard** : Sauter T27, T29, et simplifier T25 (_PokemonCard) en affichant seulement le nom

---

### PC5 : Fin de journée (après T28 - ~16h00)

**État attendu** : Application complète et fonctionnelle

**Vérification** :
- Parcours complet : créer dresseur → partir à l'aventure → capturer Pokémon → voir équipe
- Toutes les notifications toastr fonctionnent
- CSS cohérent sur mobile et desktop

**Si très en retard** : Accepter une version avec CSS basique, sans T27

---

## 11. Pièges Probables des Étudiants

### Piège 1 : Service non enregistré dans Program.cs

**Erreur** : `InvalidOperationException: Unable to resolve service for type 'IEncounterService'`

**Cause** : Oubli de `builder.Services.AddScoped<IEncounterService, EncounterService>()` dans T06

**Comment le repérer** : Exception au démarrage ou lors de l'appel du controller

**Solution** : Vérifier `Program.cs`, ajouter l'enregistrement manquant

---

### Piège 2 : Include oublié lors de la lecture de Team

**Erreur** : `Team` est null ou vide dans la vue Details

**Cause** : Oubli de `.Include(t => t.Team).ThenInclude(cp => cp.Pokemon).ThenInclude(p => p.Attacks)` dans T24

**Comment le repérer** : La grille de Pokémon n'affiche rien même si des captures existent en DB

**Solution** : Ajouter les `Include` dans la requête LINQ

---

### Piège 3 : Champ caché Id manquant dans Edit

**Erreur** : `ModelState.IsValid` est false, ou erreur "id != model.Id"

**Cause** : Oubli de `<input asp-for="Id" type="hidden" />` dans le formulaire Edit

**Comment le repérer** : POST échoue avec erreur de validation ou NotFound

**Solution** : Ajouter le champ caché dans Edit.cshtml

---

### Piège 4 : Nom de champ différent du ViewModel

**Erreur** : Le binding ne fonctionne pas, les valeurs ne sont pas récupérées en POST

**Cause** : Nom du champ HTML (`name="Nom"`) différent de la propriété ViewModel (`Name`)

**Comment le repérer** : Après soumission, le modèle reçu a des valeurs null

**Solution** : Utiliser `asp-for` qui génère automatiquement le bon `name`, ou vérifier la cohérence

---

### Piège 5 : Absence de _ValidationScriptsPartial

**Erreur** : Validation côté client ne fonctionne pas

**Cause** : Oubli de `@section Scripts { <partial name="_ValidationScriptsPartial" /> }` dans Create ou Edit

**Comment le repérer** : Les erreurs n'apparaissent qu'après soumission (validation serveur seule)

**Solution** : Ajouter la section Scripts dans les vues de formulaire

---

### Piège 6 : Erreur de route dans asp-action

**Erreur** : Lien ne fonctionne pas, erreur 404

**Cause** : Nom d'action incorrect (`asp-action="Modify"` au lieu de `"Edit"`)

**Comment le repérer** : Clic sur le lien donne une erreur 404

**Solution** : Vérifier le nom exact de l'action dans le controller

---

### Piège 7 : TempData lu plusieurs fois

**Erreur** : Notification toastr s'affiche une fois puis plus jamais

**Cause** : TempData n'est disponible que pour 1 requête, lecture multiple vide les données

**Comment le repérer** : Première redirection affiche toastr, les suivantes non

**Solution** : Ne lire TempData qu'une fois (dans _Layout), ou utiliser `TempData.Peek()` pour lecture non destructive

---

### Piège 8 : Enum mal bindé dans le formulaire

**Erreur** : Le select Ball ne bind pas correctement l'enum `BallType`

**Cause** : Valeurs du `<option>` ne correspondent pas aux valeurs de l'enum (string vs int)

**Comment le repérer** : POST échoue avec erreur de binding ou valeur par défaut (0)

**Solution** : Utiliser `value="@((int)BallType.PokeBall)"` ou `value="PokeBall"` selon la config

---

## 12. Résumé des Tâches par Priorité

| Priorité | Nombre de tâches | Durée totale estimée |
|----------|------------------|---------------------|
| **MUST** | 25 | 5h30 |
| **SHOULD** | 3 | 30 min |
| **COULD** | 1 | 15 min |
| **TOTAL** | 29 | 6h15 |

**Répartition par mode** :

| Mode | Nombre de tâches | Durée totale |
|------|------------------|--------------|
| **PRÉPARÉ À L'AVANCE** | 6 | 1h15 |
| **EN LIVE AVEC LES ÉTUDIANTS** | 23 | 5h00 |

---

## Notes Finales

1. **Flexibilité** : Si les étudiants avancent plus vite, ajouter une fonctionnalité bonus (ex : surnom lors de la capture, statistiques d'un Pokémon).

2. **Débogage en direct** : Prévoir 10-15 min de marge pour les erreurs imprévues (exceptions, typos).

3. **Participation** : Encourager les étudiants à coder en même temps (live coding collaboratif).

4. **Points d'arrêt** : Faire des pauses aux points de contrôle pour vérifier que tout le monde suit.

5. **Documentation** : Fournir ce plan aux étudiants en fin de journée comme référence.

---

**Fin du Plan d'Implémentation**
