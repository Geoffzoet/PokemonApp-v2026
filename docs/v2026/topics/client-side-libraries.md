# Client-Side Libraries (Quick Reference)

---
**Technology Version**: .NET 8.0
**Document Version**: 1.0
**Last Updated**: 2026-11-23
**Author**: PokemonApp Documentation Team
**Target Audience**: Beginners
---

## 1. Overview & Introduction

### What are Client-Side Libraries?

Client-side libraries are collections of pre-written JavaScript and CSS code that run in the user's browser to enhance the functionality and appearance of your web pages. These libraries help you add interactive features, styling, and dynamic behavior without writing everything from scratch.

In ASP.NET Core MVC applications, client-side libraries complement your server-side C# code by handling the frontend user experience. While your C# code generates HTML on the server, client-side libraries make that HTML interactive, responsive, and visually appealing in the browser.

### Why Use Client-Side Libraries?

You should use client-side libraries when:

- **Rapid development** - Save time by using tested, ready-made solutions instead of writing custom JavaScript and CSS
- **Consistent UI** - Use established design systems like Bootstrap for professional, responsive layouts
- **Rich interactions** - Add features like notifications, modals, and form validation without complex coding
- **Cross-browser compatibility** - Libraries handle browser differences so you don't have to
- **Community support** - Popular libraries have extensive documentation and community solutions

### Common Libraries in MVC Applications

**Bootstrap**
- CSS framework for responsive, mobile-first layouts
- Includes pre-styled components (buttons, cards, forms, navigation)
- Grid system for organizing page layout

**jQuery**
- JavaScript library that simplifies DOM manipulation and AJAX calls
- Makes it easier to select elements, handle events, and animate content
- Many other libraries depend on it

**Toastr**
- Notification library for displaying toast messages (success, error, info alerts)
- Non-intrusive, customizable popup notifications

**LibMan (Library Manager)**
- Tool for managing client-side libraries in ASP.NET Core
- Downloads and updates libraries without npm or Node.js
- Integrates with Visual Studio and CLI

### When to Use Client-Side Libraries

**Good use cases:**
- Adding responsive layouts to your MVC views (Bootstrap)
- Displaying user-friendly notifications after form submissions (Toastr)
- Implementing client-side form validation before server submission
- Creating interactive UI elements (modals, dropdowns, tabs)
- Simplifying AJAX calls to your API endpoints (jQuery)

**Not recommended for:**
- Complex Single Page Applications (consider React, Angular, or Blazor instead)
- Applications that need to work without JavaScript enabled
- When you need fine-grained control over every byte downloaded (libraries add overhead)

---

## 2. Installation Guide

### Prerequisites

- ASP.NET Core MVC project created
- Visual Studio, VS Code, or Rider installed
- Basic understanding of HTML and CSS

### Method 1: Using LibMan (Recommended for ASP.NET Core)

LibMan is the simplest way to add client-side libraries to ASP.NET Core projects.

**Step 1: Initialize LibMan**

Create `libman.json` in your project root:

```bash
dotnet tool install -g Microsoft.Web.LibraryManager.Cli
libman init
```

When prompted, choose:
- Provider: `cdnjs` (or `unpkg`)
- Default destination: `wwwroot/lib/`

**Step 2: Install Bootstrap**

```bash
libman install bootstrap@5.3.2 -d wwwroot/lib/bootstrap
```

This downloads Bootstrap CSS and JavaScript files to `wwwroot/lib/bootstrap/`.

**Step 3: Install jQuery**

```bash
libman install jquery@3.7.1 -d wwwroot/lib/jquery
```

**Step 4: Install Toastr**

```bash
libman install toastr.js@2.1.4 -d wwwroot/lib/toastr
```

**Step 5: Verify Installation**

Your `libman.json` should look like:

```json
{
  "version": "1.0",
  "defaultProvider": "cdnjs",
  "libraries": [
    {
      "library": "bootstrap@5.3.2",
      "destination": "wwwroot/lib/bootstrap/"
    },
    {
      "library": "jquery@3.7.1",
      "destination": "wwwroot/lib/jquery/"
    },
    {
      "library": "toastr.js@2.1.4",
      "destination": "wwwroot/lib/toastr/"
    }
  ]
}
```

**Step 6: Restore Libraries**

If cloning a project with existing `libman.json`:

```bash
libman restore
```

This downloads all libraries defined in the config file.

### Method 2: Manual Download (Alternative)

If you prefer not to use LibMan:

1. Download libraries from official websites:
   - Bootstrap: https://getbootstrap.com/
   - jQuery: https://jquery.com/download/
   - Toastr: https://github.com/CodeSeven/toastr

2. Extract files to:
   - `wwwroot/lib/bootstrap/`
   - `wwwroot/lib/jquery/`
   - `wwwroot/lib/toastr/`

### Method 3: CDN Links (No Download Required)

You can reference libraries directly from CDN without downloading them. Add to your `_Layout.cshtml`:

```html
<!-- Bootstrap CSS from CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- jQuery from CDN -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- Bootstrap JS from CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Toastr from CDN -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.1.4/toastr.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.1.4/toastr.min.js"></script>
```

**Pros:** No files to manage, always up-to-date, fast CDN delivery
**Cons:** Requires internet connection, external dependency

### Including Libraries in Your Layout

**Edit `Views/Shared/_Layout.cshtml`:**

```cshtml
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>@ViewData["Title"] - Pokemon App</title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="~/lib/bootstrap/dist/css/bootstrap.min.css" />

    <!-- Toastr CSS -->
    <link rel="stylesheet" href="~/lib/toastr/toastr.min.css" />

    <!-- Your custom CSS -->
    <link rel="stylesheet" href="~/css/site.css" asp-append-version="true" />
</head>
<body>
    <header>
        <!-- Navigation -->
    </header>

    <main>
        @RenderBody()
    </main>

    <footer>
        <!-- Footer content -->
    </footer>

    <!-- jQuery (must load before Bootstrap JS and Toastr) -->
    <script src="~/lib/jquery/dist/jquery.min.js"></script>

    <!-- Bootstrap JS -->
    <script src="~/lib/bootstrap/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Toastr JS -->
    <script src="~/lib/toastr/toastr.min.js"></script>

    <!-- Your custom scripts -->
    <script src="~/js/site.js" asp-append-version="true"></script>

    <!-- Optional section for page-specific scripts -->
    @await RenderSectionAsync("Scripts", required: false)
</body>
</html>
```

**Important:** Order matters! jQuery must load before libraries that depend on it (Bootstrap, Toastr).

### Verify Installation

Create a test page to verify everything works:

**Views/Home/Test.cshtml:**

```cshtml
@{
    ViewData["Title"] = "Library Test";
}

<div class="container mt-5">
    <h1>Client Libraries Test</h1>

    <!-- Bootstrap test -->
    <div class="alert alert-success">
        ✅ Bootstrap is working if this alert is styled!
    </div>

    <button class="btn btn-primary" onclick="testToastr()">
        Test Toastr Notification
    </button>
</div>

@section Scripts {
    <script>
        function testToastr() {
            toastr.success('Toastr is working!', 'Success');
        }

        $(document).ready(function() {
            console.log('jQuery version: ' + $.fn.jquery);
        });
    </script>
}
```

Run your application and navigate to `/Home/Test`. You should see:
- Styled alert box (Bootstrap working)
- Clicking button shows notification (Toastr working)
- Console shows jQuery version (jQuery working)

---

## 3. Basic Usage

### Using Bootstrap for Layout and Components

#### Grid System

Bootstrap's grid divides pages into 12 columns for responsive layouts:

```cshtml
<div class="container">
    <div class="row">
        <div class="col-md-4">
            <h3>Column 1</h3>
            <p>Takes 4/12 of width on medium+ screens</p>
        </div>
        <div class="col-md-4">
            <h3>Column 2</h3>
            <p>Takes 4/12 of width</p>
        </div>
        <div class="col-md-4">
            <h3>Column 3</h3>
            <p>Takes 4/12 of width</p>
        </div>
    </div>
</div>
```

**Breakpoints:**
- `col-sm` - Small devices (≥576px)
- `col-md` - Medium devices (≥768px)
- `col-lg` - Large devices (≥992px)
- `col-xl` - Extra large devices (≥1200px)

#### Common Bootstrap Components

**Buttons:**

```html
<button class="btn btn-primary">Primary Button</button>
<button class="btn btn-success">Success Button</button>
<button class="btn btn-danger">Danger Button</button>
<a href="#" class="btn btn-info">Link Button</a>
```

**Cards:**

```html
<div class="card" style="width: 18rem;">
    <div class="card-body">
        <h5 class="card-title">Pikachu</h5>
        <p class="card-text">Electric type Pokemon</p>
        <a href="#" class="btn btn-primary">View Details</a>
    </div>
</div>
```

**Alerts:**

```html
<div class="alert alert-success">Operation successful!</div>
<div class="alert alert-danger">An error occurred!</div>
<div class="alert alert-warning">Warning message</div>
<div class="alert alert-info">Informational message</div>
```

**Forms:**

```html
<form>
    <div class="mb-3">
        <label for="pokemonName" class="form-label">Pokemon Name</label>
        <input type="text" class="form-control" id="pokemonName">
    </div>

    <div class="mb-3">
        <label for="pokemonType" class="form-label">Type</label>
        <select class="form-select" id="pokemonType">
            <option>Fire</option>
            <option>Water</option>
            <option>Grass</option>
        </select>
    </div>

    <button type="submit" class="btn btn-primary">Submit</button>
</form>
```

**Modal Dialogs:**

```html
<!-- Button trigger -->
<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#myModal">
    Open Modal
</button>

<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Pokemon Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Modal content goes here</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Save</button>
            </div>
        </div>
    </div>
</div>
```

### Using jQuery for Interactive Features

#### Basic jQuery Syntax

```javascript
$(document).ready(function() {
    // Code runs when page is fully loaded
    console.log('Page ready!');
});

// Shorthand
$(function() {
    // Same as above
});
```

#### Selecting Elements

```javascript
// By ID
$('#pokemonName')

// By class
$('.pokemon-card')

// By tag
$('button')

// Complex selectors
$('div.card .card-title')
```

#### Common jQuery Operations

**Get/Set Content:**

```javascript
// Get text
var name = $('#pokemonName').text();

// Set text
$('#pokemonName').text('Pikachu');

// Get/set input value
var input = $('#pokemonLevel').val();
$('#pokemonLevel').val(25);

// Get/set HTML
$('#container').html('<p>New content</p>');
```

**Show/Hide Elements:**

```javascript
// Hide element
$('#errorMessage').hide();

// Show element
$('#errorMessage').show();

// Toggle visibility
$('#details').toggle();

// Fade in/out
$('#notification').fadeIn();
$('#notification').fadeOut();
```

**Event Handling:**

```javascript
// Click event
$('#submitBtn').click(function() {
    alert('Button clicked!');
});

// Alternative syntax (recommended)
$('#submitBtn').on('click', function() {
    alert('Button clicked!');
});

// Form submit
$('#myForm').on('submit', function(e) {
    e.preventDefault(); // Prevent default form submission
    // Your custom logic
});

// Input change
$('#pokemonType').on('change', function() {
    var selectedType = $(this).val();
    console.log('Selected: ' + selectedType);
});
```

**AJAX Calls:**

```javascript
// GET request
$.ajax({
    url: '/api/pokemon/1',
    type: 'GET',
    success: function(data) {
        console.log('Pokemon:', data);
        $('#pokemonName').text(data.name);
    },
    error: function(error) {
        console.error('Error:', error);
    }
});

// POST request
$.ajax({
    url: '/api/pokemon',
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify({
        name: 'Pikachu',
        type: 'Electric'
    }),
    success: function(result) {
        toastr.success('Pokemon created!');
    },
    error: function(error) {
        toastr.error('Failed to create Pokemon');
    }
});
```

### Using Toastr for Notifications

Toastr provides non-intrusive toast notifications.

#### Basic Notifications

```javascript
// Success notification
toastr.success('Pokemon saved successfully!');

// Error notification
toastr.error('Failed to save Pokemon');

// Warning notification
toastr.warning('Pokemon level is low');

// Info notification
toastr.info('Loading Pokemon data...');
```

#### Notifications with Titles

```javascript
toastr.success('The Pokemon has been added to your team', 'Success');
toastr.error('The Pokemon could not be found', 'Error');
```

#### Configuring Toastr

```javascript
// Set global options
toastr.options = {
    "closeButton": true,
    "progressBar": true,
    "positionClass": "toast-top-right",
    "timeOut": "3000",
    "extendedTimeOut": "1000"
};

// Now all toasts use these settings
toastr.success('Configured notification');
```

**Position options:**
- `toast-top-right` (default)
- `toast-top-left`
- `toast-bottom-right`
- `toast-bottom-left`
- `toast-top-center`
- `toast-bottom-center`

#### Using Toastr in MVC

**Display notification after controller action:**

```csharp
// Controller
public IActionResult Create(Pokemon pokemon)
{
    if (ModelState.IsValid)
    {
        _service.Create(pokemon);
        TempData["SuccessMessage"] = "Pokemon created successfully!";
        return RedirectToAction("Index");
    }
    return View(pokemon);
}
```

**Show notification in view:**

```cshtml
@if (TempData["SuccessMessage"] != null)
{
    <script>
        toastr.success('@TempData["SuccessMessage"]');
    </script>
}

@if (TempData["ErrorMessage"] != null)
{
    <script>
        toastr.error('@TempData["ErrorMessage"]');
    </script>
}
```

Or create a partial view for reusable notifications:

**Views/Shared/_Notifications.cshtml:**

```cshtml
@if (TempData["SuccessMessage"] != null)
{
    <script>
        toastr.success('@TempData["SuccessMessage"]');
    </script>
}

@if (TempData["ErrorMessage"] != null)
{
    <script>
        toastr.error('@TempData["ErrorMessage"]');
    </script>
}

@if (TempData["WarningMessage"] != null)
{
    <script>
        toastr.warning('@TempData["WarningMessage"]');
    </script>
}

@if (TempData["InfoMessage"] != null)
{
    <script>
        toastr.info('@TempData["InfoMessage"]');
    </script>
}
```

**Include in _Layout.cshtml:**

```cshtml
<body>
    <!-- ... -->

    <partial name="_Notifications" />
</body>
```

---

## 4. Practical Examples

### Example 1: Form with Client-Side Validation

**Scenario:** Create a Pokemon form with real-time client-side validation.

**Views/Pokemon/Create.cshtml:**

```cshtml
@model PokemonCreateViewModel

@{
    ViewData["Title"] = "Create Pokemon";
}

<div class="container mt-4">
    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="card">
                <div class="card-header">
                    <h3>Add New Pokemon</h3>
                </div>
                <div class="card-body">
                    <form id="pokemonForm" asp-action="Create" method="post">
                        <div class="mb-3">
                            <label asp-for="Name" class="form-label">Pokemon Name</label>
                            <input asp-for="Name" class="form-control" id="pokemonName" required>
                            <span asp-validation-for="Name" class="text-danger"></span>
                            <div class="invalid-feedback">
                                Pokemon name is required (3-50 characters)
                            </div>
                        </div>

                        <div class="mb-3">
                            <label asp-for="Type" class="form-label">Type</label>
                            <select asp-for="Type" class="form-select" id="pokemonType" required>
                                <option value="">-- Select Type --</option>
                                <option value="Fire">Fire</option>
                                <option value="Water">Water</option>
                                <option value="Grass">Grass</option>
                                <option value="Electric">Electric</option>
                                <option value="Psychic">Psychic</option>
                            </select>
                            <span asp-validation-for="Type" class="text-danger"></span>
                        </div>

                        <div class="mb-3">
                            <label asp-for="Level" class="form-label">Level</label>
                            <input asp-for="Level" type="number" class="form-control"
                                   id="pokemonLevel" min="1" max="100" value="1" required>
                            <span asp-validation-for="Level" class="text-danger"></span>
                            <small class="form-text text-muted">Level must be between 1 and 100</small>
                        </div>

                        <div class="mb-3">
                            <label asp-for="HP" class="form-label">HP</label>
                            <input asp-for="HP" type="number" class="form-control"
                                   id="pokemonHP" min="1" max="255" value="50" required>
                            <span asp-validation-for="HP" class="text-danger"></span>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                Create Pokemon
                            </button>
                            <a asp-action="Index" class="btn btn-secondary">
                                Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

@section Scripts {
    @* Include jQuery validation *@
    <script src="~/lib/jquery-validation/dist/jquery.validate.min.js"></script>
    <script src="~/lib/jquery-validation-unobtrusive/jquery.validate.unobtrusive.min.js"></script>

    <script>
        $(document).ready(function() {
            // Custom client-side validation
            $('#pokemonForm').on('submit', function(e) {
                var isValid = true;

                // Validate name length
                var name = $('#pokemonName').val();
                if (name.length < 3 || name.length > 50) {
                    $('#pokemonName').addClass('is-invalid');
                    isValid = false;
                } else {
                    $('#pokemonName').removeClass('is-invalid');
                }

                // Validate type selected
                var type = $('#pokemonType').val();
                if (!type) {
                    $('#pokemonType').addClass('is-invalid');
                    toastr.error('Please select a Pokemon type');
                    isValid = false;
                } else {
                    $('#pokemonType').removeClass('is-invalid');
                }

                // Validate level range
                var level = parseInt($('#pokemonLevel').val());
                if (level < 1 || level > 100) {
                    $('#pokemonLevel').addClass('is-invalid');
                    toastr.error('Level must be between 1 and 100');
                    isValid = false;
                } else {
                    $('#pokemonLevel').removeClass('is-invalid');
                }

                if (!isValid) {
                    e.preventDefault(); // Stop form submission
                    return false;
                }

                // Show loading notification
                toastr.info('Creating Pokemon...', 'Please wait');
            });

            // Real-time validation on name input
            $('#pokemonName').on('input', function() {
                var name = $(this).val();
                if (name.length < 3) {
                    $(this).addClass('is-invalid');
                } else {
                    $(this).removeClass('is-invalid');
                    $(this).addClass('is-valid');
                }
            });

            // Update level display
            $('#pokemonLevel').on('change', function() {
                var level = $(this).val();
                toastr.info('Level set to ' + level);
            });
        });
    </script>
}
```

---

### Example 2: Dynamic Pokemon List with AJAX

**Scenario:** Load and filter Pokemon list dynamically without page reload.

**Views/Pokemon/Index.cshtml:**

```cshtml
@{
    ViewData["Title"] = "Pokemon List";
}

<div class="container mt-4">
    <div class="row mb-3">
        <div class="col-md-6">
            <h2>Pokemon Collection</h2>
        </div>
        <div class="col-md-6">
            <div class="input-group">
                <span class="input-group-text">Filter:</span>
                <select id="typeFilter" class="form-select">
                    <option value="">All Types</option>
                    <option value="Fire">Fire</option>
                    <option value="Water">Water</option>
                    <option value="Grass">Grass</option>
                    <option value="Electric">Electric</option>
                </select>
                <button id="loadBtn" class="btn btn-primary">
                    Load Pokemon
                </button>
            </div>
        </div>
    </div>

    <div id="loadingSpinner" class="text-center" style="display: none;">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
        <p>Loading Pokemon...</p>
    </div>

    <div id="pokemonContainer" class="row">
        <!-- Pokemon cards will be inserted here dynamically -->
    </div>
</div>

@section Scripts {
    <script>
        $(document).ready(function() {
            // Load Pokemon on page load
            loadPokemon();

            // Load button click
            $('#loadBtn').on('click', function() {
                loadPokemon();
            });

            // Filter change
            $('#typeFilter').on('change', function() {
                loadPokemon();
            });

            function loadPokemon() {
                var type = $('#typeFilter').val();
                var url = '/api/pokemon';

                if (type) {
                    url += '?type=' + type;
                }

                // Show loading spinner
                $('#loadingSpinner').show();
                $('#pokemonContainer').empty();

                $.ajax({
                    url: url,
                    type: 'GET',
                    success: function(data) {
                        $('#loadingSpinner').hide();

                        if (data.length === 0) {
                            $('#pokemonContainer').html(
                                '<div class="col-12"><div class="alert alert-info">No Pokemon found</div></div>'
                            );
                            return;
                        }

                        // Create card for each Pokemon
                        data.forEach(function(pokemon) {
                            var card = createPokemonCard(pokemon);
                            $('#pokemonContainer').append(card);
                        });

                        toastr.success('Loaded ' + data.length + ' Pokemon');
                    },
                    error: function(error) {
                        $('#loadingSpinner').hide();
                        toastr.error('Failed to load Pokemon');
                        console.error('Error:', error);
                    }
                });
            }

            function createPokemonCard(pokemon) {
                var typeColor = getTypeColor(pokemon.type);

                return `
                    <div class="col-md-4 mb-4">
                        <div class="card h-100">
                            <div class="card-body">
                                <h5 class="card-title">${pokemon.name}</h5>
                                <span class="badge bg-${typeColor}">${pokemon.type}</span>
                                <p class="card-text mt-2">
                                    <strong>Level:</strong> ${pokemon.level}<br>
                                    <strong>HP:</strong> ${pokemon.hp}
                                </p>
                                <a href="/Pokemon/Details/${pokemon.id}" class="btn btn-sm btn-primary">
                                    View Details
                                </a>
                                <button class="btn btn-sm btn-danger" onclick="deletePokemon(${pokemon.id})">
                                    Delete
                                </button>
                            </div>
                        </div>
                    </div>
                `;
            }

            function getTypeColor(type) {
                switch(type) {
                    case 'Fire': return 'danger';
                    case 'Water': return 'primary';
                    case 'Grass': return 'success';
                    case 'Electric': return 'warning';
                    default: return 'secondary';
                }
            }
        });

        // Delete function (global so onclick can access it)
        function deletePokemon(id) {
            if (!confirm('Are you sure you want to delete this Pokemon?')) {
                return;
            }

            $.ajax({
                url: '/api/pokemon/' + id,
                type: 'DELETE',
                success: function() {
                    toastr.success('Pokemon deleted successfully');
                    // Reload the list
                    $('#loadBtn').click();
                },
                error: function() {
                    toastr.error('Failed to delete Pokemon');
                }
            });
        }
    </script>
}
```

---

### Example 3: Modal for Quick Pokemon View

**Scenario:** View Pokemon details in a modal without leaving the current page.

**Views/Pokemon/Index.cshtml (add to previous example):**

```cshtml
<!-- Add modal markup -->
<div class="modal fade" id="pokemonModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Pokemon Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="modalBody">
                <!-- Details will be loaded here -->
                <div class="text-center">
                    <div class="spinner-border" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

@section Scripts {
    <script>
        // ... previous code ...

        // Update createPokemonCard to use modal
        function createPokemonCard(pokemon) {
            var typeColor = getTypeColor(pokemon.type);

            return `
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <div class="card-body">
                            <h5 class="card-title">${pokemon.name}</h5>
                            <span class="badge bg-${typeColor}">${pokemon.type}</span>
                            <p class="card-text mt-2">
                                <strong>Level:</strong> ${pokemon.level}<br>
                                <strong>HP:</strong> ${pokemon.hp}
                            </p>
                            <button class="btn btn-sm btn-info" onclick="showPokemonDetails(${pokemon.id})">
                                Quick View
                            </button>
                            <a href="/Pokemon/Details/${pokemon.id}" class="btn btn-sm btn-primary">
                                Full Details
                            </a>
                        </div>
                    </div>
                </div>
            `;
        }

        function showPokemonDetails(id) {
            // Show modal
            var modal = new bootstrap.Modal(document.getElementById('pokemonModal'));
            modal.show();

            // Load Pokemon details via AJAX
            $.ajax({
                url: '/api/pokemon/' + id,
                type: 'GET',
                success: function(pokemon) {
                    var typeColor = getTypeColor(pokemon.type);

                    $('#modalTitle').text(pokemon.name);
                    $('#modalBody').html(`
                        <div class="row">
                            <div class="col-12">
                                <h4>${pokemon.name}
                                    <span class="badge bg-${typeColor}">${pokemon.type}</span>
                                </h4>
                                <hr>
                                <dl class="row">
                                    <dt class="col-sm-4">Level</dt>
                                    <dd class="col-sm-8">${pokemon.level}</dd>

                                    <dt class="col-sm-4">HP</dt>
                                    <dd class="col-sm-8">
                                        ${pokemon.hp}
                                        <div class="progress">
                                            <div class="progress-bar bg-danger"
                                                 role="progressbar"
                                                 style="width: ${(pokemon.hp / 255 * 100)}%">
                                            </div>
                                        </div>
                                    </dd>

                                    <dt class="col-sm-4">Type</dt>
                                    <dd class="col-sm-8">${pokemon.type}</dd>
                                </dl>
                            </div>
                        </div>
                    `);
                },
                error: function() {
                    $('#modalBody').html('<div class="alert alert-danger">Failed to load Pokemon details</div>');
                }
            });
        }
    </script>
}
```

---

### Example 4: Reusable Notification Helper

**Create a JavaScript helper file:**

**wwwroot/js/notifications.js:**

```javascript
// Reusable notification functions
var Notifications = {
    success: function(message, title) {
        toastr.success(message, title || 'Success');
    },

    error: function(message, title) {
        toastr.error(message, title || 'Error');
    },

    warning: function(message, title) {
        toastr.warning(message, title || 'Warning');
    },

    info: function(message, title) {
        toastr.info(message, title || 'Information');
    },

    // Confirmation dialog
    confirm: function(message, onConfirm) {
        if (confirm(message)) {
            onConfirm();
        }
    },

    // Form validation error
    validationError: function(fieldName) {
        this.error(`Please check the ${fieldName} field`, 'Validation Error');
    },

    // AJAX error handler
    ajaxError: function(xhr, status, error) {
        var message = 'An error occurred';

        if (xhr.responseJSON && xhr.responseJSON.message) {
            message = xhr.responseJSON.message;
        } else if (xhr.statusText) {
            message = xhr.statusText;
        }

        this.error(message, 'Request Failed');
    }
};

// Configure Toastr globally
toastr.options = {
    "closeButton": true,
    "progressBar": true,
    "positionClass": "toast-top-right",
    "timeOut": "4000"
};
```

**Include in _Layout.cshtml:**

```html
<script src="~/js/notifications.js"></script>
```

**Usage in your pages:**

```javascript
// Simple notifications
Notifications.success('Pokemon saved!');
Notifications.error('Failed to load data');

// With AJAX
$.ajax({
    url: '/api/pokemon',
    type: 'POST',
    data: pokemonData,
    success: function(result) {
        Notifications.success('Pokemon created successfully!');
    },
    error: function(xhr, status, error) {
        Notifications.ajaxError(xhr, status, error);
    }
});

// Confirmation
Notifications.confirm('Delete this Pokemon?', function() {
    // User confirmed, perform delete
    deletePokemon(id);
});
```

---

## Summary

This quick reference covered the essentials of using client-side libraries in ASP.NET Core MVC:

**Key Takeaways:**

1. **LibMan** is the recommended way to manage client-side libraries in ASP.NET Core
2. **Bootstrap** provides responsive layouts and pre-styled components
3. **jQuery** simplifies JavaScript operations and AJAX calls
4. **Toastr** offers user-friendly notifications
5. Load libraries in correct order: jQuery first, then others that depend on it
6. Combine server-side MVC with client-side libraries for rich user experiences
7. Use AJAX for dynamic content loading without page refreshes
8. Implement client-side validation to improve user experience

**Best Practices:**

- Keep JavaScript organized in separate files
- Use Bootstrap classes for consistent styling
- Validate on both client and server side
- Show user feedback with Toastr notifications
- Use modal dialogs for quick actions
- Implement loading indicators for async operations

**Next Steps:**

- Explore **Tag Helpers** for cleaner Razor syntax
- Learn **jQuery Validation** for advanced form validation
- Study **Bootstrap 5 documentation** for all available components
- Consider **Blazor** for building interactive UIs with C# instead of JavaScript

---

**Estimated Reading Time**: 35-40 minutes

**Prerequisites**: HTML basics, JavaScript basics, MVC fundamentals

**Related Topics**: Razor Views (POK-23), Tag Helpers, Form Handling, AJAX in MVC

---

## Document Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-11-23 | Initial quick reference guide for client-side libraries |
