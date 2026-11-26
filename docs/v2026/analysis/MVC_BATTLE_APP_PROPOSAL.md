# Pokemon Battle MVC App - Teaching Proposal

**Created**: 2026-11-25
**Purpose**: Teaching-focused MVC application for .NET cursus
**Prerequisites**: Students have completed API module + Angular Pokedex integration

---

## 🎯 Overview

**Concept**: A simple Pokemon Battle web application where trainers can battle their Pokemon against computer opponents or each other.

**Why This Works for Teaching:**
- ✅ Different from the Pokedex API (no redundancy with Angular app)
- ✅ Engaging and game-like (keeps students motivated)
- ✅ Covers ALL MVC concepts from the cursus
- ✅ Progressive complexity (can build step by step)
- ✅ Visual and interactive (demonstrates MVC strengths)
- ✅ Familiar domain (Pokemon battles are well-understood)

---

## 📚 MVC Concepts Coverage

This app demonstrates every topic from Part 2 of the cursus:

| MVC Concept | Implementation in Battle App |
|-------------|------------------------------|
| **MVC Architecture** | Clear separation: Models (Battle domain), Views (battle UI), Controllers (game logic) |
| **Controllers** | HomeController (dashboard), BattleController (game), TrainerController (profile) |
| **Views & Razor** | Battle arena, Pokemon selection, history list, partial views for Pokemon cards |
| **Layout/Sections** | Shared layout with battle stats header, section for battle scripts |
| **Partial Views** | Pokemon card partial, battle log partial, move selection partial |
| **ViewModels** | `BattleViewModel` (combines 2 Pokemon), `DashboardViewModel` (trainer stats) |
| **Routing** | `/Battle/Start/{pokemonId}`, `/Battle/Attack/{battleId}` |
| **ViewData** | Pass available moves to dropdown |
| **ViewBag** | Pass battle messages dynamically |
| **TempData** | Show battle result after redirect |
| **Session** | Maintain current battle state across requests |
| **Tag Helpers** | Forms for move selection, validation, environment tag for scripts |
| **Html Helpers** | DisplayTemplate for Pokemon, EditorTemplate for move input |
| **Dependency Injection** | `IBattleService`, `IPokemonService` injected into controllers |
| **Toastr** | Battle notifications: "Critical Hit!", "Pikachu fainted!", "You Win!" |

---

## 🎮 Application Features

### 1. **Home/Dashboard** (Simple)
- Welcome page
- Trainer stats (wins/losses/total battles)
- Quick start battle button
- Recent battle history (last 5)

**MVC Concepts**: Basic Controller, View, ViewModel (DashboardViewModel)

---

### 2. **Pokemon Selection** (Medium)
- List of available Pokemon with images
- Filter by type (dropdown)
- Select Pokemon for battle
- Shows Pokemon stats (HP, Attack, Defense)

**MVC Concepts**: Forms, Tag Helpers, ViewBag for dropdown, Html Helpers for Pokemon display

---

### 3. **Battle Arena** (Complex - Main Feature)
- Two Pokemon facing each other
- Current HP bars (visual progress bars)
- Turn-based combat
- Move selection (4 moves per Pokemon)
- Battle log showing what happened
- Win/Loss screen

**MVC Concepts**:
- Complex ViewModel (2 Pokemon, battle state, available moves)
- TempData for battle results
- Session for maintaining battle across turns
- Toastr for move notifications
- Partial views for battle components

---

### 4. **Battle History** (Simple)
- Table of past battles
- Filter by date, opponent, result
- Pagination

**MVC Concepts**: Html Helpers for tables, filtering with forms

---

### 5. **Trainer Profile** (Medium)
- Edit trainer name
- View total stats
- Badge collection (based on wins)

**MVC Concepts**: Form validation, Edit templates, ViewModels

---

## 🗂️ Data Models

### Core Models

```csharp
// Models/Pokemon.cs
public class Pokemon
{
    public int Id { get; set; }
    public string Name { get; set; }
    public PokemonType Type { get; set; }
    public int HP { get; set; }
    public int Attack { get; set; }
    public int Defense { get; set; }
    public string ImageUrl { get; set; }

    public ICollection<Move> Moves { get; set; }
}

// Models/Move.cs
public class Move
{
    public int Id { get; set; }
    public string Name { get; set; }
    public int Power { get; set; }
    public int Accuracy { get; set; }  // 0-100 percentage
    public MoveType Type { get; set; }

    public int PokemonId { get; set; }
    public Pokemon Pokemon { get; set; }
}

// Models/Battle.cs
public class Battle
{
    public int Id { get; set; }
    public int TrainerId { get; set; }

    // Player Pokemon
    public int PlayerPokemonId { get; set; }
    public int PlayerCurrentHP { get; set; }

    // Opponent Pokemon
    public int OpponentPokemonId { get; set; }
    public int OpponentCurrentHP { get; set; }

    public bool IsPlayerTurn { get; set; }
    public BattleStatus Status { get; set; }  // InProgress, PlayerWon, OpponentWon
    public DateTime StartTime { get; set; }
    public DateTime? EndTime { get; set; }

    // Navigation
    public Trainer Trainer { get; set; }
    public Pokemon PlayerPokemon { get; set; }
    public Pokemon OpponentPokemon { get; set; }
    public ICollection<BattleLog> BattleLogs { get; set; }
}

// Models/BattleLog.cs
public class BattleLog
{
    public int Id { get; set; }
    public int BattleId { get; set; }
    public int Turn { get; set; }
    public string Action { get; set; }  // "Pikachu used Thunderbolt!"
    public int Damage { get; set; }
    public DateTime Timestamp { get; set; }

    public Battle Battle { get; set; }
}

// Models/Trainer.cs
public class Trainer
{
    public int Id { get; set; }
    public string Name { get; set; }
    public int Wins { get; set; }
    public int Losses { get; set; }
    public DateTime CreatedAt { get; set; }

    public ICollection<Battle> Battles { get; set; }
}

public enum BattleStatus
{
    InProgress,
    PlayerWon,
    OpponentWon,
    Draw
}

public enum PokemonType
{
    NORMAL, FIRE, WATER, GRASS, ELECTRIC, ICE,
    FIGHTING, POISON, GROUND, FLYING, PSYCHIC,
    BUG, ROCK, GHOST, DRAGON, DARK, STEEL, FAIRY
}

public enum MoveType
{
    Physical,
    Special,
    Status
}
```

---

## 🎨 ViewModels

```csharp
// ViewModels/BattleViewModel.cs
public class BattleViewModel
{
    public int BattleId { get; set; }

    // Player Pokemon
    public PokemonBattleInfo Player { get; set; }

    // Opponent Pokemon
    public PokemonBattleInfo Opponent { get; set; }

    // Battle State
    public bool IsPlayerTurn { get; set; }
    public List<BattleLogEntry> RecentLogs { get; set; }
    public BattleStatus Status { get; set; }

    // Available Moves for selection
    public List<MoveViewModel> AvailableMoves { get; set; }
}

public class PokemonBattleInfo
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }
    public int CurrentHP { get; set; }
    public int MaxHP { get; set; }
    public int Attack { get; set; }
    public int Defense { get; set; }
    public string ImageUrl { get; set; }

    // Computed
    public int HPPercentage => (CurrentHP * 100) / MaxHP;
    public string HPBarColor => HPPercentage > 50 ? "success" :
                                HPPercentage > 25 ? "warning" : "danger";
}

public class MoveViewModel
{
    public int Id { get; set; }
    public string Name { get; set; }
    public int Power { get; set; }
    public string Type { get; set; }
}

public class BattleLogEntry
{
    public int Turn { get; set; }
    public string Message { get; set; }
    public int Damage { get; set; }
}

// ViewModels/DashboardViewModel.cs
public class DashboardViewModel
{
    public string TrainerName { get; set; }
    public int TotalBattles { get; set; }
    public int Wins { get; set; }
    public int Losses { get; set; }
    public double WinRate => TotalBattles > 0 ? (Wins * 100.0) / TotalBattles : 0;

    public List<RecentBattleViewModel> RecentBattles { get; set; }
    public List<PokemonSummaryViewModel> AvailablePokemon { get; set; }
}

public class RecentBattleViewModel
{
    public int BattleId { get; set; }
    public string PlayerPokemonName { get; set; }
    public string OpponentPokemonName { get; set; }
    public string Result { get; set; }  // "Victory", "Defeat"
    public DateTime Date { get; set; }
}

// ViewModels/PokemonSelectionViewModel.cs
public class PokemonSelectionViewModel
{
    public List<PokemonSummaryViewModel> Pokemon { get; set; }
    public List<SelectListItem> TypeFilters { get; set; }
    public string SelectedType { get; set; }
}

public class PokemonSummaryViewModel
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Type { get; set; }
    public int HP { get; set; }
    public int Attack { get; set; }
    public int Defense { get; set; }
    public string ImageUrl { get; set; }
}
```

---

## 🎯 Controllers

### HomeController
```csharp
public class HomeController : Controller
{
    private readonly ITrainerService _trainerService;
    private readonly IBattleService _battleService;
    private readonly IPokemonService _pokemonService;

    public IActionResult Index()
    {
        var trainer = _trainerService.GetOrCreateTrainer(HttpContext.Session);
        var recentBattles = _battleService.GetRecentBattles(trainer.Id, 5);
        var availablePokemon = _pokemonService.GetRandomPokemon(6);

        var viewModel = new DashboardViewModel
        {
            TrainerName = trainer.Name,
            TotalBattles = trainer.Wins + trainer.Losses,
            Wins = trainer.Wins,
            Losses = trainer.Losses,
            RecentBattles = recentBattles,
            AvailablePokemon = availablePokemon
        };

        return View(viewModel);
    }
}
```

### BattleController
```csharp
public class BattleController : Controller
{
    private readonly IBattleService _battleService;
    private readonly IPokemonService _pokemonService;

    // GET: Battle/Select
    public IActionResult Select()
    {
        var pokemon = _pokemonService.GetAll();
        var viewModel = new PokemonSelectionViewModel
        {
            Pokemon = pokemon,
            TypeFilters = GetTypeFilters()
        };
        return View(viewModel);
    }

    // POST: Battle/Start
    [HttpPost]
    public IActionResult Start(int pokemonId)
    {
        var trainer = _trainerService.GetOrCreateTrainer(HttpContext.Session);
        var battle = _battleService.StartBattle(trainer.Id, pokemonId);

        // Store battle ID in session
        HttpContext.Session.SetInt32("CurrentBattleId", battle.Id);

        TempData["Message"] = "Battle started!";
        return RedirectToAction("Arena", new { id = battle.Id });
    }

    // GET: Battle/Arena/5
    public IActionResult Arena(int id)
    {
        var battle = _battleService.GetBattle(id);

        if (battle == null)
            return NotFound();

        var viewModel = _battleService.GetBattleViewModel(battle);
        return View(viewModel);
    }

    // POST: Battle/Attack
    [HttpPost]
    public IActionResult Attack(int battleId, int moveId)
    {
        var battle = _battleService.GetBattle(battleId);

        if (battle.Status != BattleStatus.InProgress)
            return RedirectToAction("Result", new { id = battleId });

        // Player attacks
        var playerResult = _battleService.ExecuteMove(battleId, moveId, isPlayer: true);

        // Check if opponent fainted
        if (battle.OpponentCurrentHP <= 0)
        {
            _battleService.EndBattle(battleId, BattleStatus.PlayerWon);
            TempData["BattleResult"] = "Victory!";
            TempData["ResultMessage"] = $"{battle.OpponentPokemon.Name} fainted! You win!";
            return RedirectToAction("Result", new { id = battleId });
        }

        // Opponent attacks
        var opponentResult = _battleService.ExecuteAIMove(battleId);

        // Check if player fainted
        if (battle.PlayerCurrentHP <= 0)
        {
            _battleService.EndBattle(battleId, BattleStatus.OpponentWon);
            TempData["BattleResult"] = "Defeat";
            TempData["ResultMessage"] = $"{battle.PlayerPokemon.Name} fainted! You lose!";
            return RedirectToAction("Result", new { id = battleId });
        }

        // Battle continues
        TempData["PlayerMove"] = playerResult.Message;
        TempData["OpponentMove"] = opponentResult.Message;

        return RedirectToAction("Arena", new { id = battleId });
    }

    // GET: Battle/Result/5
    public IActionResult Result(int id)
    {
        var battle = _battleService.GetBattle(id);
        var viewModel = _battleService.GetBattleResultViewModel(battle);
        return View(viewModel);
    }
}
```

---

## 🎨 Key Views

### Views/Home/Index.cshtml
```cshtml
@model DashboardViewModel

<div class="container mt-4">
    <div class="jumbotron">
        <h1>Welcome, @Model.TrainerName!</h1>
        <p class="lead">Ready for a Pokemon battle?</p>
        <a asp-controller="Battle" asp-action="Select" class="btn btn-primary btn-lg">
            Start New Battle
        </a>
    </div>

    <!-- Stats Cards -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card text-center">
                <div class="card-body">
                    <h2 class="display-4">@Model.TotalBattles</h2>
                    <p class="text-muted">Total Battles</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center bg-success text-white">
                <div class="card-body">
                    <h2 class="display-4">@Model.Wins</h2>
                    <p>Wins</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center bg-danger text-white">
                <div class="card-body">
                    <h2 class="display-4">@Model.Losses</h2>
                    <p>Losses</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center">
                <div class="card-body">
                    <h2 class="display-4">@Model.WinRate.ToString("F1")%</h2>
                    <p class="text-muted">Win Rate</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Battles -->
    <h3>Recent Battles</h3>
    @Html.Partial("_RecentBattlesTable", Model.RecentBattles)

    <!-- Available Pokemon -->
    <h3 class="mt-4">Quick Select Pokemon</h3>
    <div class="row">
        @foreach (var pokemon in Model.AvailablePokemon)
        {
            @Html.Partial("_PokemonCard", pokemon)
        }
    </div>
</div>
```

### Views/Battle/Arena.cshtml
```cshtml
@model BattleViewModel

<div class="container mt-4">
    <div class="battle-arena">
        <!-- Battle Status -->
        <div class="row mb-4">
            <div class="col-12 text-center">
                <h2>Battle Arena</h2>
                @if (Model.IsPlayerTurn)
                {
                    <span class="badge badge-primary">Your Turn</span>
                }
                else
                {
                    <span class="badge badge-secondary">Opponent's Turn</span>
                }
            </div>
        </div>

        <!-- Pokemon Display -->
        <div class="row mb-4">
            <!-- Player Pokemon -->
            <div class="col-md-5">
                <div class="pokemon-container player">
                    <img src="@Model.Player.ImageUrl" alt="@Model.Player.Name" class="pokemon-sprite" />
                    <h3>@Model.Player.Name</h3>
                    <span class="badge badge-info">@Model.Player.Type</span>

                    <!-- HP Bar -->
                    <div class="mt-3">
                        <label>HP: @Model.Player.CurrentHP / @Model.Player.MaxHP</label>
                        <div class="progress">
                            <div class="progress-bar bg-@Model.Player.HPBarColor"
                                 role="progressbar"
                                 style="width: @Model.Player.HPPercentage%"
                                 aria-valuenow="@Model.Player.HPPercentage"
                                 aria-valuemin="0"
                                 aria-valuemax="100">
                            </div>
                        </div>
                    </div>

                    <div class="stats mt-2">
                        <small>ATK: @Model.Player.Attack | DEF: @Model.Player.Defense</small>
                    </div>
                </div>
            </div>

            <!-- VS -->
            <div class="col-md-2 text-center d-flex align-items-center justify-content-center">
                <h1 class="display-3 text-muted">VS</h1>
            </div>

            <!-- Opponent Pokemon -->
            <div class="col-md-5">
                <div class="pokemon-container opponent">
                    <img src="@Model.Opponent.ImageUrl" alt="@Model.Opponent.Name" class="pokemon-sprite" />
                    <h3>@Model.Opponent.Name</h3>
                    <span class="badge badge-info">@Model.Opponent.Type</span>

                    <!-- HP Bar -->
                    <div class="mt-3">
                        <label>HP: @Model.Opponent.CurrentHP / @Model.Opponent.MaxHP</label>
                        <div class="progress">
                            <div class="progress-bar bg-@Model.Opponent.HPBarColor"
                                 role="progressbar"
                                 style="width: @Model.Opponent.HPPercentage%">
                            </div>
                        </div>
                    </div>

                    <div class="stats mt-2">
                        <small>ATK: @Model.Opponent.Attack | DEF: @Model.Opponent.Defense</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Move Selection -->
        @if (Model.IsPlayerTurn && Model.Status == BattleStatus.InProgress)
        {
            <div class="row mb-4">
                <div class="col-12">
                    <h4>Choose Your Move:</h4>
                    <form asp-action="Attack" method="post" class="battle-moves">
                        <input type="hidden" name="battleId" value="@Model.BattleId" />

                        <div class="row">
                            @foreach (var move in Model.AvailableMoves)
                            {
                                <div class="col-md-3 mb-2">
                                    <button type="submit"
                                            name="moveId"
                                            value="@move.Id"
                                            class="btn btn-lg btn-outline-primary w-100">
                                        <strong>@move.Name</strong><br/>
                                        <small>Power: @move.Power | Type: @move.Type</small>
                                    </button>
                                </div>
                            }
                        </div>
                    </form>
                </div>
            </div>
        }

        <!-- Battle Log -->
        <div class="row">
            <div class="col-12">
                <h4>Battle Log</h4>
                <div class="battle-log">
                    @foreach (var log in Model.RecentLogs.OrderByDescending(l => l.Turn))
                    {
                        <div class="log-entry">
                            <span class="badge badge-secondary">Turn @log.Turn</span>
                            @log.Message
                            @if (log.Damage > 0)
                            {
                                <span class="text-danger">(-@log.Damage HP)</span>
                            }
                        </div>
                    }
                </div>
            </div>
        </div>
    </div>
</div>

@section Scripts {
    <script>
        // Show Toastr notifications for moves
        @if (TempData["PlayerMove"] != null)
        {
            <text>
            toastr.info('@TempData["PlayerMove"]');
            </text>
        }

        @if (TempData["OpponentMove"] != null)
        {
            <text>
            toastr.warning('@TempData["OpponentMove"]');
            </text>
        }
    </script>
}
```

### Views/Shared/_PokemonCard.cshtml (Partial)
```cshtml
@model PokemonSummaryViewModel

<div class="col-md-2 mb-3">
    <div class="card pokemon-card">
        <img src="@Model.ImageUrl" class="card-img-top" alt="@Model.Name" />
        <div class="card-body">
            <h5 class="card-title">@Model.Name</h5>
            <span class="badge badge-@GetTypeBadgeClass(Model.Type)">@Model.Type</span>
            <ul class="list-unstyled mt-2">
                <li><small>HP: @Model.HP</small></li>
                <li><small>ATK: @Model.Attack</small></li>
                <li><small>DEF: @Model.Defense</small></li>
            </ul>
            <a asp-controller="Battle"
               asp-action="Start"
               asp-route-pokemonId="@Model.Id"
               class="btn btn-sm btn-primary w-100">
                Choose
            </a>
        </div>
    </div>
</div>
```

---

## 🔧 Services

```csharp
public interface IBattleService
{
    Battle StartBattle(int trainerId, int playerPokemonId);
    Battle GetBattle(int battleId);
    BattleViewModel GetBattleViewModel(Battle battle);
    MoveResult ExecuteMove(int battleId, int moveId, bool isPlayer);
    MoveResult ExecuteAIMove(int battleId);
    void EndBattle(int battleId, BattleStatus result);
    List<RecentBattleViewModel> GetRecentBattles(int trainerId, int count);
}

public class BattleService : IBattleService
{
    private readonly ApplicationDbContext _context;
    private readonly IPokemonService _pokemonService;
    private readonly Random _random;

    public Battle StartBattle(int trainerId, int playerPokemonId)
    {
        var playerPokemon = _context.Pokemon.Include(p => p.Moves).FirstOrDefault(p => p.Id == playerPokemonId);
        var opponentPokemon = _pokemonService.GetRandomOpponent();

        var battle = new Battle
        {
            TrainerId = trainerId,
            PlayerPokemonId = playerPokemonId,
            PlayerCurrentHP = playerPokemon.HP,
            OpponentPokemonId = opponentPokemon.Id,
            OpponentCurrentHP = opponentPokemon.HP,
            IsPlayerTurn = true,
            Status = BattleStatus.InProgress,
            StartTime = DateTime.Now
        };

        _context.Battles.Add(battle);
        _context.SaveChanges();

        return battle;
    }

    public MoveResult ExecuteMove(int battleId, int moveId, bool isPlayer)
    {
        var battle = _context.Battles
            .Include(b => b.PlayerPokemon).ThenInclude(p => p.Moves)
            .Include(b => b.OpponentPokemon).ThenInclude(p => p.Moves)
            .FirstOrDefault(b => b.Id == battleId);

        var move = _context.Moves.Find(moveId);
        var attacker = isPlayer ? battle.PlayerPokemon : battle.OpponentPokemon;
        var defender = isPlayer ? battle.OpponentPokemon : battle.PlayerPokemon;

        // Calculate damage
        int damage = CalculateDamage(attacker, defender, move);

        // Apply damage
        if (isPlayer)
            battle.OpponentCurrentHP = Math.Max(0, battle.OpponentCurrentHP - damage);
        else
            battle.PlayerCurrentHP = Math.Max(0, battle.PlayerCurrentHP - damage);

        // Log the move
        var log = new BattleLog
        {
            BattleId = battleId,
            Turn = battle.BattleLogs.Count + 1,
            Action = $"{attacker.Name} used {move.Name}!",
            Damage = damage,
            Timestamp = DateTime.Now
        };

        _context.BattleLogs.Add(log);
        _context.SaveChanges();

        return new MoveResult
        {
            Message = log.Action,
            Damage = damage,
            IsHit = damage > 0
        };
    }

    private int CalculateDamage(Pokemon attacker, Pokemon defender, Move move)
    {
        // Simple damage formula
        // Damage = (Attack * MovePower / Defense) * RandomFactor

        double baseDamage = (attacker.Attack * move.Power) / (double)defender.Defense;
        double randomFactor = 0.85 + (_random.NextDouble() * 0.3); // 0.85 to 1.15

        // Check if move hits (based on accuracy)
        if (_random.Next(100) >= move.Accuracy)
            return 0; // Miss!

        int damage = (int)(baseDamage * randomFactor);
        return Math.Max(1, damage); // Minimum 1 damage
    }
}
```

---

## 📋 Implementation Steps (Progressive Learning)

### **Phase 1: Foundation** (2-3 hours)
Students create basic MVC structure:
1. Create MVC project
2. Create basic models (Pokemon, Trainer)
3. Setup DbContext
4. Create Home controller with dashboard
5. Create simple layout

**Teaches**: Project setup, Models, Controllers basics, Views basics

---

### **Phase 2: Pokemon Selection** (2-3 hours)
Students add Pokemon selection:
1. Create PokemonSelectionViewModel
2. Add BattleController with Select action
3. Create selection view with cards
4. Add filter dropdown (ViewBag)

**Teaches**: ViewModels, Forms, Tag Helpers, ViewBag, Partial Views

---

### **Phase 3: Battle Logic** (3-4 hours)
Students implement battle:
1. Create Battle model
2. Create BattleService with DI
3. Implement StartBattle action
4. Create Arena view
5. Add Session for battle state

**Teaches**: Services, Dependency Injection, Session, Complex ViewModels

---

### **Phase 4: Turn-Based Combat** (2-3 hours)
Students add combat mechanics:
1. Add Move model
2. Implement Attack action
3. Add battle log
4. Use TempData for move results

**Teaches**: TempData, Form submission, POST actions

---

### **Phase 5: Polish** (2-3 hours)
Students add finishing touches:
1. Add Toastr notifications
2. Create DisplayTemplates for Pokemon
3. Add battle history
4. Add validation

**Teaches**: Toastr, Html Helpers, Display/Editor templates, Validation

---

## 📊 Database Schema

```sql
-- Pokemon table (pre-populated with ~20 Pokemon)
CREATE TABLE Pokemon (
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Type VARCHAR(20),
    HP INT,
    Attack INT,
    Defense INT,
    ImageUrl VARCHAR(200)
);

-- Moves table (pre-populated with moves for each Pokemon)
CREATE TABLE Moves (
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Power INT,
    Accuracy INT,
    Type VARCHAR(20),
    PokemonId INT FOREIGN KEY REFERENCES Pokemon(Id)
);

-- Trainers table
CREATE TABLE Trainers (
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Wins INT DEFAULT 0,
    Losses INT DEFAULT 0,
    CreatedAt DATETIME
);

-- Battles table
CREATE TABLE Battles (
    Id INT PRIMARY KEY,
    TrainerId INT FOREIGN KEY REFERENCES Trainers(Id),
    PlayerPokemonId INT FOREIGN KEY REFERENCES Pokemon(Id),
    PlayerCurrentHP INT,
    OpponentPokemonId INT FOREIGN KEY REFERENCES Pokemon(Id),
    OpponentCurrentHP INT,
    IsPlayerTurn BIT,
    Status INT,
    StartTime DATETIME,
    EndTime DATETIME NULL
);

-- BattleLogs table
CREATE TABLE BattleLogs (
    Id INT PRIMARY KEY,
    BattleId INT FOREIGN KEY REFERENCES Battles(Id),
    Turn INT,
    Action VARCHAR(200),
    Damage INT,
    Timestamp DATETIME
);
```

---

## 🎓 Teaching Progression

### Week 1: MVC Basics
- **Day 1**: Introduction, Project setup, Models, Basic controller
- **Day 2**: Views, Razor syntax, Layout, ViewModels
- **Day 3**: Pokemon selection page (ViewBag, Tag Helpers)

### Week 2: Battle Mechanics
- **Day 4**: Services, DI, Battle start
- **Day 5**: Turn-based combat, TempData, Session
- **Day 6**: Battle log, Partial views

### Week 3: Polish & Advanced
- **Day 7**: Html Helpers, Display templates
- **Day 8**: Toastr, Validation, Forms
- **Day 9**: Battle history, Final touches

---

## 🎯 Learning Outcomes

After completing this project, students will:

✅ Understand MVC architecture (Model-View-Controller separation)
✅ Create Controllers with actions
✅ Build Views with Razor syntax
✅ Use Layout, Sections, and Partial Views
✅ Create and use ViewModels
✅ Pass data with ViewData, ViewBag, TempData, Session
✅ Use Tag Helpers for forms and links
✅ Create Display and Editor templates
✅ Implement Dependency Injection
✅ Add Toastr notifications
✅ Build a complete interactive web application

---

## 🚀 Why This App is Perfect for Teaching

1. **Engaging**: Pokemon battles are fun and familiar
2. **Visual**: Easy to see MVC concepts in action (HP bars, battle animations)
3. **Progressive**: Can build in steps, each teaching a concept
4. **Complete**: Uses EVERY MVC concept from the cursus
5. **Different**: Not redundant with API + Angular (new use case)
6. **Interactive**: User actions trigger immediate feedback
7. **Game-like**: State management (session) is natural
8. **Practical**: Real-world patterns (services, repositories)

---

## 💡 Optional Extensions

For advanced students:

1. **Multiplayer**: Two trainers battle each other (SignalR)
2. **Team Battles**: 3v3 Pokemon
3. **Items**: Potions, revives (inventory management)
4. **Leaderboard**: Global rankings
5. **Pokemon Evolution**: After X wins
6. **Type Effectiveness**: Fire > Grass, Water > Fire
7. **Status Effects**: Poison, paralysis, sleep
8. **Battle Animations**: CSS animations for attacks

---

## 📁 Project Structure

```
PokemonBattle.Web/
├── Controllers/
│   ├── HomeController.cs
│   ├── BattleController.cs
│   └── TrainerController.cs
├── Models/
│   ├── Pokemon.cs
│   ├── Move.cs
│   ├── Battle.cs
│   ├── BattleLog.cs
│   └── Trainer.cs
├── ViewModels/
│   ├── BattleViewModel.cs
│   ├── DashboardViewModel.cs
│   ├── PokemonSelectionViewModel.cs
│   └── BattleResultViewModel.cs
├── Views/
│   ├── Shared/
│   │   ├── _Layout.cshtml
│   │   ├── _PokemonCard.cshtml
│   │   ├── _BattleLog.cshtml
│   │   └── DisplayTemplates/
│   │       └── PokemonDisplay.cshtml
│   ├── Home/
│   │   └── Index.cshtml
│   ├── Battle/
│   │   ├── Select.cshtml
│   │   ├── Arena.cshtml
│   │   └── Result.cshtml
│   └── Trainer/
│       └── Profile.cshtml
├── Services/
│   ├── IBattleService.cs
│   ├── BattleService.cs
│   ├── IPokemonService.cs
│   └── PokemonService.cs
├── Data/
│   ├── ApplicationDbContext.cs
│   └── SeedData.cs
└── wwwroot/
    ├── css/
    │   └── battle.css
    ├── js/
    │   └── battle.js
    └── images/
        └── pokemon/
```

---

## ✅ Conclusion

This Pokemon Battle MVC app is the **perfect companion** to the Pokemon API + Angular Pokedex:

- **API Project**: REST API with EF Core, authentication, Angular integration
- **MVC Project**: Interactive web app with battles, state management, game logic

Students get:
- Full-stack experience (.NET backend + frontend)
- Different architectural approaches (API vs MVC)
- Complete understanding of .NET web development
- Fun, engaging learning experience

**Ready to implement? Let me know and I'll create detailed step-by-step tickets!** 🚀
