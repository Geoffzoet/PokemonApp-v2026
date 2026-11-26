# Simple Pokemon Battle MVC - 1.5 Day Plan

**Duration**: 1.5 days (12 hours)
**Complexity**: Minimal - Perfect for teaching MVC basics
**Database**: Uses existing Pokemon database (Pokemon table with Attacks, DefensePoints, HealthPoints)

---

## 🎯 App Overview

**Super Simple Concept**:
1. User clicks "Start Battle"
2. App picks 2 random Pokemon from database
3. User clicks attack buttons to fight
4. Battle history shows what happened
5. Winner is declared
6. Repeat!

**That's it!** No login, no profiles, no teams, no complexity.

---

## 📋 Features (Minimal)

### 1. **Home Page** (30 min)
- Welcome message
- "Start Random Battle" button
- Link to view battle history

**MVC Concepts**: Basic Controller, Basic View

---

### 2. **Battle Arena** (3 hours)
- Shows 2 random Pokemon (image, name, HP, stats)
- 4 attack buttons (Pokemon's attacks)
- Current HP bars
- "Attack!" action
- Battle log showing moves

**MVC Concepts**: ViewModel, Forms, Tag Helpers, ViewBag, Razor syntax

---

### 3. **Battle Result** (1 hour)
- Winner announcement
- Final stats
- "Battle Again" button

**MVC Concepts**: TempData, Redirects

---

### 4. **Battle History** (2 hours)
- Table of past battles
- Shows: Pokemon names, winner, date
- Simple list, no filters

**MVC Concepts**: Html Helpers, Display templates

---

### 5. **Polish** (1.5 hours)
- Toastr notifications ("Critical hit!", "X wins!")
- Layout with navigation
- Basic CSS styling

**MVC Concepts**: Toastr, Layouts, Sections

---

## 🗂️ Data Models (Using Your Existing DB)

### Existing Tables (No Changes Needed!)
```csharp
// Models/Pokemon.cs (Already exists in your API)
public class Pokemon
{
    public int Id { get; set; }
    public string Name { get; set; }
    public PokemonType Type { get; set; }
    public int DefensePoints { get; set; }
    public int HealthPoints { get; set; }
    public double RarityPercentage { get; set; }
    public string? ImageURL { get; set; }
    public ICollection<Attack> Attacks { get; set; }
}

// Models/Attack.cs (Already exists)
public class Attack
{
    public int Id { get; set; }
    public string Name { get; set; }
    public int Points { get; set; }
    public int PokemonId { get; set; }
    public Pokemon Pokemon { get; set; }
}
```

### New Table (Simple!)
```csharp
// Models/BattleHistory.cs (NEW - only table to add)
public class BattleHistory
{
    public int Id { get; set; }
    public int Pokemon1Id { get; set; }
    public string Pokemon1Name { get; set; }
    public int Pokemon2Id { get; set; }
    public string Pokemon2Name { get; set; }
    public int WinnerId { get; set; }
    public string WinnerName { get; set; }
    public DateTime BattleDate { get; set; }
    public string BattleLog { get; set; }  // JSON string of moves
}
```

---

## 🎨 ViewModels (Minimal)

```csharp
// ViewModels/BattleViewModel.cs
public class BattleViewModel
{
    // Pokemon 1
    public int Pokemon1Id { get; set; }
    public string Pokemon1Name { get; set; }
    public int Pokemon1HP { get; set; }
    public int Pokemon1MaxHP { get; set; }
    public int Pokemon1Defense { get; set; }
    public string Pokemon1Image { get; set; }
    public List<AttackViewModel> Pokemon1Attacks { get; set; }

    // Pokemon 2
    public int Pokemon2Id { get; set; }
    public string Pokemon2Name { get; set; }
    public int Pokemon2HP { get; set; }
    public int Pokemon2MaxHP { get; set; }
    public int Pokemon2Defense { get; set; }
    public string Pokemon2Image { get; set; }
    public List<AttackViewModel> Pokemon2Attacks { get; set; }

    // Battle State
    public int Turn { get; set; }
    public List<string> BattleLog { get; set; }
    public bool IsFinished { get; set; }
    public string Winner { get; set; }

    // Helpers
    public int Pokemon1HPPercent => (Pokemon1HP * 100) / Pokemon1MaxHP;
    public int Pokemon2HPPercent => (Pokemon2HP * 100) / Pokemon2MaxHP;
}

public class AttackViewModel
{
    public int Id { get; set; }
    public string Name { get; set; }
    public int Power { get; set; }
}

// ViewModels/BattleHistoryViewModel.cs
public class BattleHistoryViewModel
{
    public List<BattleHistoryItem> Battles { get; set; }
}

public class BattleHistoryItem
{
    public int Id { get; set; }
    public string Pokemon1Name { get; set; }
    public string Pokemon2Name { get; set; }
    public string Winner { get; set; }
    public DateTime Date { get; set; }
}
```

---

## 🎮 Controllers (Simple)

### HomeController
```csharp
public class HomeController : Controller
{
    public IActionResult Index()
    {
        return View();
    }
}
```

### BattleController
```csharp
public class BattleController : Controller
{
    private readonly IBattleService _battleService;

    public BattleController(IBattleService battleService)
    {
        _battleService = battleService;
    }

    // GET: Battle/Start
    public IActionResult Start()
    {
        // Pick 2 random Pokemon
        var battle = _battleService.CreateRandomBattle();

        // Store in session
        HttpContext.Session.SetString("CurrentBattle", JsonSerializer.Serialize(battle));

        return View("Arena", battle);
    }

    // POST: Battle/Attack
    [HttpPost]
    public IActionResult Attack(int attackId)
    {
        // Get battle from session
        var battleJson = HttpContext.Session.GetString("CurrentBattle");
        var battle = JsonSerializer.Deserialize<BattleViewModel>(battleJson);

        // Execute attack
        var result = _battleService.ExecuteAttack(battle, attackId);

        // Check if finished
        if (result.IsFinished)
        {
            _battleService.SaveBattleHistory(result);
            TempData["Winner"] = result.Winner;
            TempData["Message"] = $"{result.Winner} wins!";
            return RedirectToAction("Result", new { winner = result.Winner });
        }

        // Update session
        HttpContext.Session.SetString("CurrentBattle", JsonSerializer.Serialize(result));

        // Show notification
        TempData["LastMove"] = result.BattleLog.Last();

        return View("Arena", result);
    }

    // GET: Battle/Result
    public IActionResult Result(string winner)
    {
        ViewBag.Winner = winner;
        return View();
    }

    // GET: Battle/History
    public IActionResult History()
    {
        var history = _battleService.GetBattleHistory();
        return View(history);
    }
}
```

---

## 🔧 Service Layer (Simple)

```csharp
public interface IBattleService
{
    BattleViewModel CreateRandomBattle();
    BattleViewModel ExecuteAttack(BattleViewModel battle, int attackId);
    void SaveBattleHistory(BattleViewModel battle);
    BattleHistoryViewModel GetBattleHistory();
}

public class BattleService : IBattleService
{
    private readonly ApplicationDbContext _context;
    private readonly Random _random;

    public BattleService(ApplicationDbContext context)
    {
        _context = context;
        _random = new Random();
    }

    public BattleViewModel CreateRandomBattle()
    {
        // Get 2 random Pokemon with their attacks
        var allPokemon = _context.Pokemon.Include(p => p.Attacks).ToList();
        var pokemon1 = allPokemon[_random.Next(allPokemon.Count)];
        var pokemon2 = allPokemon[_random.Next(allPokemon.Count)];

        return new BattleViewModel
        {
            Pokemon1Id = pokemon1.Id,
            Pokemon1Name = pokemon1.Name,
            Pokemon1HP = pokemon1.HealthPoints,
            Pokemon1MaxHP = pokemon1.HealthPoints,
            Pokemon1Defense = pokemon1.DefensePoints,
            Pokemon1Image = pokemon1.ImageURL,
            Pokemon1Attacks = pokemon1.Attacks.Select(a => new AttackViewModel
            {
                Id = a.Id,
                Name = a.Name,
                Power = a.Points
            }).ToList(),

            Pokemon2Id = pokemon2.Id,
            Pokemon2Name = pokemon2.Name,
            Pokemon2HP = pokemon2.HealthPoints,
            Pokemon2MaxHP = pokemon2.HealthPoints,
            Pokemon2Defense = pokemon2.DefensePoints,
            Pokemon2Image = pokemon2.ImageURL,
            Pokemon2Attacks = pokemon2.Attacks.Select(a => new AttackViewModel
            {
                Id = a.Id,
                Name = a.Name,
                Power = a.Points
            }).ToList(),

            Turn = 1,
            BattleLog = new List<string>(),
            IsFinished = false
        };
    }

    public BattleViewModel ExecuteAttack(BattleViewModel battle, int attackId)
    {
        // Find the attack
        var attack = battle.Pokemon1Attacks.FirstOrDefault(a => a.Id == attackId)
                  ?? battle.Pokemon2Attacks.FirstOrDefault(a => a.Id == attackId);

        bool isPlayer1 = battle.Pokemon1Attacks.Any(a => a.Id == attackId);

        // Calculate damage (simple formula)
        int damage = attack.Power - (isPlayer1 ? battle.Pokemon2Defense / 2 : battle.Pokemon1Defense / 2);
        damage = Math.Max(1, damage); // At least 1 damage

        // Apply damage
        if (isPlayer1)
        {
            battle.Pokemon2HP -= damage;
            battle.BattleLog.Add($"Turn {battle.Turn}: {battle.Pokemon1Name} used {attack.Name}! {damage} damage to {battle.Pokemon2Name}.");
        }
        else
        {
            battle.Pokemon1HP -= damage;
            battle.BattleLog.Add($"Turn {battle.Turn}: {battle.Pokemon2Name} used {attack.Name}! {damage} damage to {battle.Pokemon1Name}.");
        }

        battle.Turn++;

        // Check if battle is finished
        if (battle.Pokemon1HP <= 0)
        {
            battle.IsFinished = true;
            battle.Winner = battle.Pokemon2Name;
            battle.Pokemon1HP = 0;
        }
        else if (battle.Pokemon2HP <= 0)
        {
            battle.IsFinished = true;
            battle.Winner = battle.Pokemon1Name;
            battle.Pokemon2HP = 0;
        }
        else if (!isPlayer1)
        {
            // If it was Pokemon2's turn, let Pokemon1 attack automatically
            var randomAttack = battle.Pokemon1Attacks[_random.Next(battle.Pokemon1Attacks.Count)];
            return ExecuteAttack(battle, randomAttack.Id);
        }

        return battle;
    }

    public void SaveBattleHistory(BattleViewModel battle)
    {
        var history = new BattleHistory
        {
            Pokemon1Id = battle.Pokemon1Id,
            Pokemon1Name = battle.Pokemon1Name,
            Pokemon2Id = battle.Pokemon2Id,
            Pokemon2Name = battle.Pokemon2Name,
            WinnerId = battle.Winner == battle.Pokemon1Name ? battle.Pokemon1Id : battle.Pokemon2Id,
            WinnerName = battle.Winner,
            BattleDate = DateTime.Now,
            BattleLog = JsonSerializer.Serialize(battle.BattleLog)
        };

        _context.BattleHistories.Add(history);
        _context.SaveChanges();
    }

    public BattleHistoryViewModel GetBattleHistory()
    {
        var battles = _context.BattleHistories
            .OrderByDescending(b => b.BattleDate)
            .Take(20)
            .Select(b => new BattleHistoryItem
            {
                Id = b.Id,
                Pokemon1Name = b.Pokemon1Name,
                Pokemon2Name = b.Pokemon2Name,
                Winner = b.WinnerName,
                Date = b.BattleDate
            })
            .ToList();

        return new BattleHistoryViewModel { Battles = battles };
    }
}
```

---

## 🎨 Views (Simple)

### Views/Home/Index.cshtml
```cshtml
@{
    ViewData["Title"] = "Pokemon Battle";
}

<div class="container text-center mt-5">
    <h1 class="display-3">⚔️ Pokemon Battle Arena</h1>
    <p class="lead">Random Pokemon battles!</p>

    <div class="mt-5">
        <a asp-controller="Battle" asp-action="Start" class="btn btn-primary btn-lg">
            🎲 Start Random Battle
        </a>
    </div>

    <div class="mt-4">
        <a asp-controller="Battle" asp-action="History" class="btn btn-secondary">
            📜 View Battle History
        </a>
    </div>
</div>
```

### Views/Battle/Arena.cshtml
```cshtml
@model BattleViewModel

<div class="container mt-4">
    <h2 class="text-center">Battle Arena - Turn @Model.Turn</h2>

    <!-- Pokemon Display -->
    <div class="row mt-4">
        <!-- Pokemon 1 -->
        <div class="col-md-5">
            <div class="card">
                <img src="@Model.Pokemon1Image" class="card-img-top" alt="@Model.Pokemon1Name" style="height: 200px; object-fit: contain;">
                <div class="card-body">
                    <h4>@Model.Pokemon1Name</h4>
                    <p>HP: @Model.Pokemon1HP / @Model.Pokemon1MaxHP</p>
                    <div class="progress">
                        <div class="progress-bar bg-success" style="width: @Model.Pokemon1HPPercent%"></div>
                    </div>
                    <p class="mt-2"><small>Defense: @Model.Pokemon1Defense</small></p>
                </div>
            </div>
        </div>

        <!-- VS -->
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <h1 class="display-3">VS</h1>
        </div>

        <!-- Pokemon 2 -->
        <div class="col-md-5">
            <div class="card">
                <img src="@Model.Pokemon2Image" class="card-img-top" alt="@Model.Pokemon2Name" style="height: 200px; object-fit: contain;">
                <div class="card-body">
                    <h4>@Model.Pokemon2Name</h4>
                    <p>HP: @Model.Pokemon2HP / @Model.Pokemon2MaxHP</p>
                    <div class="progress">
                        <div class="progress-bar bg-danger" style="width: @Model.Pokemon2HPPercent%"></div>
                    </div>
                    <p class="mt-2"><small>Defense: @Model.Pokemon2Defense</small></p>
                </div>
            </div>
        </div>
    </div>

    <!-- Attack Buttons -->
    <div class="row mt-4">
        <div class="col-md-12 text-center">
            <h4>Choose Your Attack:</h4>
            <form asp-action="Attack" method="post">
                @foreach (var attack in Model.Pokemon1Attacks)
                {
                    <button type="submit" name="attackId" value="@attack.Id" class="btn btn-primary btn-lg m-2">
                        @attack.Name<br/>
                        <small>(Power: @attack.Power)</small>
                    </button>
                }
            </form>
        </div>
    </div>

    <!-- Battle Log -->
    <div class="row mt-4">
        <div class="col-md-12">
            <h4>Battle Log:</h4>
            <div class="card">
                <div class="card-body" style="max-height: 300px; overflow-y: auto;">
                    @foreach (var log in Model.BattleLog)
                    {
                        <p>@log</p>
                    }
                </div>
            </div>
        </div>
    </div>
</div>

@section Scripts {
    <script>
        @if (TempData["LastMove"] != null)
        {
            <text>toastr.info('@TempData["LastMove"]');</text>
        }
    </script>
}
```

### Views/Battle/Result.cshtml
```cshtml
@{
    var winner = ViewBag.Winner;
}

<div class="container text-center mt-5">
    <h1 class="display-1">🏆</h1>
    <h2 class="display-4">@winner Wins!</h2>

    <div class="mt-5">
        <a asp-action="Start" class="btn btn-primary btn-lg">Battle Again</a>
        <a asp-action="History" class="btn btn-secondary btn-lg">View History</a>
        <a asp-controller="Home" asp-action="Index" class="btn btn-outline-primary">Home</a>
    </div>
</div>

@section Scripts {
    <script>
        toastr.success('@winner wins the battle!', 'Victory!');
    </script>
}
```

### Views/Battle/History.cshtml
```cshtml
@model BattleHistoryViewModel

<div class="container mt-4">
    <h2>Battle History</h2>

    <table class="table table-striped mt-4">
        <thead>
            <tr>
                <th>Date</th>
                <th>Pokemon 1</th>
                <th>Pokemon 2</th>
                <th>Winner</th>
            </tr>
        </thead>
        <tbody>
            @foreach (var battle in Model.Battles)
            {
                <tr>
                    <td>@battle.Date.ToString("yyyy-MM-dd HH:mm")</td>
                    <td>@battle.Pokemon1Name</td>
                    <td>@battle.Pokemon2Name</td>
                    <td><strong>@battle.Winner</strong></td>
                </tr>
            }
        </tbody>
    </table>

    <a asp-controller="Home" asp-action="Index" class="btn btn-primary">Back to Home</a>
</div>
```

---

## 📅 1.5 Day Teaching Plan

### **Day 1 Morning (3 hours) - Setup & Models**
1. Create new MVC project
2. Add existing database connection (your Pokemon DB)
3. Create BattleHistory model
4. Add migration and update database
5. Test database connection

**Students Learn**: Project setup, DbContext, Models, Migrations

---

### **Day 1 Afternoon (3 hours) - Battle Logic**
1. Create BattleViewModel
2. Create IBattleService interface
3. Implement BattleService (CreateRandomBattle, ExecuteAttack)
4. Configure DI in Program.cs
5. Create BattleController skeleton

**Students Learn**: ViewModels, Services, Dependency Injection

---

### **Day 1 Evening (2 hours) - Basic Views**
1. Create Home/Index view
2. Create Battle/Arena view (without attacks yet)
3. Create Layout with navigation
4. Test random battle selection

**Students Learn**: Controllers, Views, Razor syntax, Layouts

---

### **Day 2 Morning (2 hours) - Battle Mechanics**
1. Add attack form to Arena view
2. Implement Attack POST action
3. Add Session for battle state
4. Test battle flow

**Students Learn**: Forms, Tag Helpers, Session, POST actions

---

### **Day 2 Afternoon (2 hours) - History & Polish**
1. Implement SaveBattleHistory
2. Create History view with table
3. Add TempData messages
4. Add Toastr notifications

**Students Learn**: Html Helpers, TempData, Toastr

---

## ✅ MVC Concepts Covered

| Concept | Where Used |
|---------|------------|
| **Controllers** | HomeController, BattleController |
| **Actions** | Index, Start, Attack, Result, History |
| **Views** | Index, Arena, Result, History |
| **Razor Syntax** | @Model, @foreach, @if |
| **Layout** | _Layout.cshtml with navigation |
| **ViewModels** | BattleViewModel, BattleHistoryViewModel |
| **Forms** | Attack selection form |
| **Tag Helpers** | asp-controller, asp-action |
| **Html Helpers** | Table for history |
| **Session** | Store current battle |
| **TempData** | Show winner message |
| **ViewBag** | Pass winner to result page |
| **Dependency Injection** | IBattleService → BattleService |
| **Toastr** | Battle notifications |

---

## 🚀 That's It!

**Total code**: ~500 lines
**Total files**: 10 files
**Teaching time**: 1.5 days
**Result**: Working Pokemon battle game with history!

Simple, clean, and covers ALL the key MVC concepts. Perfect for teaching! 🎓
