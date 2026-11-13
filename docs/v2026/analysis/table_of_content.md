# Table of Contents - .NET API/MVC Course

This document contains the extracted table of contents from the PowerPoint presentations used in previous years for the .NET API/MVC course.

## Source Files
- `docs/previousyears/ppt/dotNET-part1-API.pptx`
- `docs/previousyears/ppt/dotNET-part2-MVC.pptx`
- `docs/previousyears/ppt/dotNET-part3-API-MVC-Additional concepts.pptx`

---

## Part 1: Web API REST (94 slides)

### Introduction & Overview
- **Slide 1**: Partie 1: Web API REST - Geoffroy Zoetardt (24,25,26 Novembre 2025)
- **Slide 4**: Table des matières - Introduction Web API REST, Projet Web API, Controller & Routing, EF Core & DbContext, Migrations EF Core, DTOs, Validations, CORS, Swagger, Integration avec Angular

### Introduction Web API REST
- **Slide 5**: Service Oriented Architecture (SOA)
- **Slide 6**: Qu'est-ce qu'un service Web?
- **Slide 7**: SOA - Composants de l'architecture
- **Slide 8**: SOA - Application de l'architecture
- **Slide 9**: REST API
- **Slide 2**: REST API - Composant de l'architecture
- **Slide 3**: REST API - Composant de l'architecture
- **Slide 4**: REST API - HATEOAS
- **Slide 5**: REST API - REST & Web Services (Protocol: HTTP, Requests: URL, http verb, Response: Media type JSON/XML)
- **Slide 6**: REST API - HTTP Verbs
- **Slide 7**: REST API - /items
- **Slide 8**: REST API - /items/42
- **Slide 9**: REST API
- **Slide 10**: Other resources uri - REST API
- **Slide 11**: Exemple - REST API

### HTTP Status Codes
- **Slide 13**: 1xx Hold on… - REST API
- **Slide 14**: 2xx Success - REST API
- **Slide 15**: 3xx Redirection - REST API
- **Slide 16**: 4xx Erreur client - REST API
- **Slide 17**: 5xx Erreur server - REST API

### API Documentation
- **Slide 18**: REST API Descriptions Languages - Swagger, RAML, OpenAPI
- **Slide 19**: REST API - Pyramide de Richardson

### Questions & Review
- **Slide 20**: Questions - C'est quoi REST, HATEOAS, verbes HTTP, différence PUT vs POST
- **Slide 21**: Quel code HTTP renvoyer - Création resource, erreur validation, DB down, utilisateur non authentifié
- **Slide 22**: Quel code HTTP renvoyer - GET liste avec succès, DELETE sur resource POST-only, redirection infinie, URL inconnue

### Création du projet Web API
- **Slide 24**: Création du projet Web API - Création du projet, Analyse de la structure
- **Slide 25**: Setup & middlewares - Setup: services & configs, Middlewares
- **Slide 26**: Setup - Configuration (Settings files, environment variables, Azure key vault, App configuration, custom providers, In-memory .NET objects)
- **Slide 27**: Setup - Points importants (Sécurité: ne jamais stocker secrets en clair, Hiérarchie des configurations)
- **Slide 28**: Middleware - Composant logiciel dans pipeline pour gérer requêtes/réponses HTTP ("Chain of responsibility" design pattern)
- **Slide 29**: Middleware - Types (Use, Map, Run)
- **Slide 30**: Middleware - Hiérarchie et middlewares intégrés (Gestion d'erreur en premier, Gestion de la sécurité)

### Controllers & Routing
- **Slide 31**: Controllers & Routing - Routing: redirection requêtes HTTP vers fonctions, Controllers: classes contenant actions
- **Slide 32**: Controllers & Routing - Sélection d'une action (table de routage, route template, liberté forme URL)
- **Slide 33**: Controllers & Routing - Types de routing (Conventionnel, Par attribut)
- **Slide 35**: Controllers & Routing - Autres exemples
- **Slide 36**: Controllers & Routing - Points d'attention (Ordre endpoints: plus spécifique en premier, Catch-all, Contraintes)
- **Slide 37**: Controllers & Routing - Questions (Product_Details_custom/4, /Home/Index, etc.)
- **Slide 38**: Controllers & Routing - Controller répond aux requêtes, execute action, retourne résultat
- **Slide 39**: Controllers & Routing - Controller action retourne ActionResult (plusieurs types étendus)

### Exercice PokemonApp.API
- **Slide 40**: Exercice - Créer solution PokemonApp avec projet PokemonApp.API, dossier Models (Pokemon, Owner classes)

### Entity Framework Core & DbContext
- **Slide 41**: EF Core & DbContext - ORM = Object-Relational Mapping (pont entre code OO et DB relationnelle)
- **Slide 42**: EF Core & DbContext - Avantages & Inconvénients (Productivité, Type-safety, LINQ vs Performance, Overhead)
- **Slide 43**: EF Core & DbContext - DbContext représente session avec DB (responsabilités: gérer connexion, suivre changements, exécuter requêtes)
- **Slide 44**: EF Core & DbContext - Installation & configuration (AddDbContext, configurer provider)
- **Slide 46**: EF Core & DbContext - Configuration (Program.cs, ajout DbContext avec Dependency Injection)
- **Slide 47**: Exercice - Créer base de données PokemonApp dans SSMS, Setup Program.cs, Créer DbContext

### Migrations EF Core
- **Slide 48**: Migrations EF Core - Gèrent évolution schéma DB (facilite mise à jour DB, versionning, collaboration équipe)
- **Slide 49**: Migration EF core - How to (3 commandes: add, update, remove)
- **Slide 50**: Migration EF Core - Exemple de workflow (InitialCreate, appliquer, ajouter propriété, nouvelle migration)

### DTOs (Data Transfer Objects)
- **Slide 51**: DTOs - Raisons d'être (Sécurité: masquer données sensibles, Performance, Versioning API)
- **Slide 52**: DTOs - DTO à ne pas exposer (exemple entité Pokemon)
- **Slide 53**: DTOs - DTOs à exposer (PokemonDto, CreatePokemonDto, UpdatePokemonDto)
- **Slide 54**: DTOs - Mapping Entity to DTOs (exemple dans Controller)
- **Slide 55**: DTOs - AutoMapper (problème: mapping manuel répétitif, solution: AutoMapper)
- **Slide 57**: DTOs - AutoMapper configuration (créer Profile, configuration mappings)
- **Slide 58**: DTOs - Raisons d'être des DTOs (répétition)

### Validations
- **Slide 59**: Validations - Validation côté serveur et client (System.ComponentModel.DataAnnotations)
- **Slide 60**: Validations - Validations via attribut (Required, StringLength, Range, RegularExpression, etc.)
- **Slide 61**: Validations - Exemple (CreatePokemonDto avec attributs)
- **Slide 62**: Validations - Réponse d'erreur automatique (exemple requête POST invalide)
- **Slide 63**: Exercice - Ajouter règles de validation (nom max 50 caractères, nom et type obligatoires, etc.)

### Swagger / OpenAPI
- **Slide 64**: Swagger / OpenAPI - Outil de documentation interactive API (interface web pour tester, documentation automatique)
- **Slide 65**: Swagger / OpenAPI - Configuration (Program.cs, AddSwaggerGen)
- **Slide 66**: Swagger / OpenAPI - How to (Lancer API, ouvrir localhost, tester endpoints)

### Exemples & Exercices
- **Slide 68**: Exemple - Création endpoint GetAllPokemon (quelles étapes?)
- **Slide 69**: Exemple - Création endpoint CreatePokemon (quelles étapes?)
- **Slide 70**: Exercise - Réaliser endpoints: GetPokemon, DeletePokemon, UpdatePokemon

### CORS (Cross Origin Resource Sharing)
- **Slide 71**: CORS - Problème: navigateur bloque requêtes cross-origin (Angular localhost:4200 vs API localhost:5000)
- **Slide 72**: CORS - Configuration (Program.cs, AddCors, AllowAnyOrigin/Header/Method)
- **Slide 73**: CORS - Debugging (erreur CORS dans console, vérifications UseCors, AllowAnyOrigin)

### Integration avec Angular
- **Slide 74**: Integration avec Angular - Côté API (.NET): CORS configuré, DTOs retournés, validation, codes HTTP corrects, Swagger actif
- **Slide 75**: Integration avec Angular - Service Angular (pokemon.service.ts, HttpClient)
- **Slide 76**: Integration avec Angular - Interface TypeScript – DTOs C# (correspondance types)
- **Slide 77**: Exercise - Intégrer back-end avec front-end Angular

### Additional Slides (EF Core detailed)
- **Slide 82**: 1.4 Entity Framework Core & DbContext - ORM pour .NET 9
- **Slide 83**: Qu'est-ce qu'Entity Framework Core? (ORM moderne et léger, abstraction DB, utilise classes C#)
- **Slide 84**: Packages NuGet nécessaires (.NET 9) - EntityFrameworkCore.SqlServer, Tools, Design
- **Slide 85**: Création du DbContext - Structure de base (hérite de DbContext, DbSet properties)
- **Slide 86**: Configuration dans Program.cs (.NET 9) - AddDbContext avec Dependency Injection
- **Slide 87**: Configuration avancée - OnModelCreating (configuration entité Pokemon)
- **Slide 88**: Relations entre entités (1-N) - Navigation properties, Foreign Keys
- **Slide 90**: Seed Data depuis JSON (lire fichier JSON, désérialiser, HasData)
- **Slide 91**: Configuration multi-plateforme (.NET 9) - Détection automatique OS (Windows vs Mac/Linux)
- **Slide 92**: Seed Data - Données initiales (environnement dev: données test, prod: données référence)
- **Slide 93**: Configuration multi-plateforme - Problème: SQL Server n'existe pas sur Mac, Solution: SQLite
- **Slide 94**: Prochaine étape: Migrations - Créer schéma DB, commandes dotnet ef migrations

### Conclusion
- **Slide 79**: Thank you for your attention

---

## Part 2: MVC (74 slides)

### Introduction & Overview
- **Slide 1**: Partie 2: MVC - Geoffroy Zoetardt (24,25,26 Novembre 2025)
- **Slide 34**: Table des matières - Introduction MVC, Architecture MVC, MVC vs API, Projet MVC, Controller MVC, Views & Razor Pages, ViewModels, Routing, Passages de données, Tag Helpers, Html Helpers, Dependency Injection, Toastr

### Introduction MVC
- **Slide 56**: Introduction MVC - Pattern de conception pour structurer applications web (3 couches: Model, View, Controller)
- **Slide 67**: Introduction MVC - MVC en 2025? (pas mort! Cas d'usage: systèmes legacy, back-offices, Server-Side Rendering SEO)

### Architecture MVC
- **Slide 73**: Architecture MVC
- **Slide 74**: Architecture MVC - Model (représente objet business avec règles et contraintes, POCO classes)
- **Slide 10**: Architecture MVC - View (représente données UI, template dynamique, format Razor cshtml)
- **Slide 11**: Architecture MVC - Controller (contrôle actions liées aux requêtes HTTP, manipule modèles, impacte vues)

### MVC vs API
- **Slide 12**: MVC vs API - Différences principales (Base class, Objet retourné, Validation, Routing)
- **Slide 13**: MVC vs API - Exemple (MVC Controller vs API Controller)

### Création d'un projet MVC
- **Slide 14**: Création d'un projet - dotnet new mvc --name PokemonApp.MVC
- **Slide 6**: Création du projet - Analyse de la structure

### Controller MVC
- **Slide 15**: Controller MVC - Gère requêtes HTTP (responsabilités: recevoir requête, récupérer données, passer à vue, retourner vue)
- **Slide 16**: Controller MVC - Structure (hérite de Controller, constructeur avec injection dépendance, une méthode par action)

### Views & Razor Syntax
- **Slide 17**: Views & Razor syntaxe - Razor = syntaxe template pour générer HTML (@variable, @{}, @if, @foreach)
- **Slide 18**: Views & Razor syntaxe - Structure (dossier Views, dossiers contrôleur, Shared, _ViewStart, _ViewImport)
- **Slide 19**: Views & Razor page - Shared folder (_Layout.cshtml, Errors, Editor/view templates)
- **Slide 20**: Views & Razor page - Layout.cshtml (définition template, contient @RenderBody)
- **Slide 21**: Views & Razor page - Viewstart.cshtml (automatiquement appelé en premier, définition code toutes vues)
- **Slide 22**: Views & Razor page - _ViewImports.cshtml ("Using" applicables toutes vues, enregistrement tag helpers)
- **Slide 23**: Views & Razor page - Layout: Body (chaque page référence Layout, @RenderBody génère page enfant)
- **Slide 24**: Views & Razor page - Layout: Section (@RenderSection avec options required)
- **Slide 25**: Views & Razor page - Vue partielle (réutilisation partie vue, Shared Folder, Html.RenderPartial/Partial)
- **Slide 26**: Views & Razor page - Vue Typée (défini via @Model, passé par contrôleur via View(model))
- **Slide 27**: Razor - HTML + C#/Vb.NET (léger, extension cshtml, code inline, bloc multi-lignes)
- **Slide 28**: Razor - HTML + C#/Vb.NET (boucle ou bloc if, balise <text> pour forcer texte)

### ViewModel
- **Slide 29**: ViewModel - Problème: ne pas exposer entités directement (Entity vs ViewModel vs DTO)
- **Slide 30**: ViewModel - Exemple (PokemonEditViewModel avec validations)

### Routing
- **Slide 31**: Routing
- **Slide 25**: Routing

### Passage des données
- **Slide 32**: Passage des données - Persistance temporaire (ViewData, ViewBag, TempData, Session)
- **Slide 33**: Passage de données - ViewData (dictionnaire clé=string, value=object, accessible contrôleur et vue)
- **Slide 34**: Passage de données - ViewBag (type dynamic, ajout propriété dynamiquement)
- **Slide 35**: Passage de données - ViewBag vs ViewData
- **Slide 36**: Passage de données - TempData (stockage temporaire sous-requête, valeur supprimée dès lecture, utile redirections)
- **Slide 37**: Passage de données - Session (propriété HttpContext, valide durée session, nécessite cast)
- **Slide 38**: Passage de données - Session (Program.cs configuration, AddSession avec IdleTimeout)
- **Slide 39**: Passage de données - Resumé
- **Slide 40**: Passage de données - Exemple live (incrémenter homeCounter en session)

### Tag Helper
- **Slide 41**: Tag Helper - Aide création tags/attributs HTML (plus proche HTML que HtmlHelper)
- **Slide 42**: Tag Helper - Exemples (anchor asp-controller/action, environment, form asp-action)
- **Slide 43**: Tag Helper - Validation (span asp-validation-for, div asp-validation-summary)

### Html Helper
- **Slide 44**: Html Helper - Outil pour générer code HTML (accès via propriété Html, retourne IHtmlContent)
- **Slide 45**: Html Helper - Exemple
- **Slide 46**: Html Helper - Exemple (Html.Label, Textbox, TextArea, Password, Hidden, DropDownList, RadioButton, CheckBox)
- **Slide 47**: Html Helper - DisplayTemplate (permet définir comment afficher un Type, dossier Shared/DisplayTemplates)
- **Slide 48**: Html Helper - EditorTemplate (comment afficher Type en édition, dossier Shared/EditorTemplate)
- **Slide 49**: Display & Editor template - Assignation manuelle template via UIHintAttribute
- **Slide 50**: Display & Editor template - Possible passer nom template au DisplayFor/EditorFor
- **Slide 51**: Gestion des html attributs (paramètre IDictionary<string,object>, objet anonyme)

### Dependency Injection
- **Slide 52**: Dependency Injection - Design pattern pour réaliser Inversion of Control (IoC)
- **Slide 53**: Dependency Injection - Inversion de contrôle (framework prend contrôle flux exécution)
- **Slide 54**: Dependency Injection - Raison utilisation (couplage faible, testabilité, maintenabilité, flexibilité)
- **Slide 55**: Dependency Injection - Exemple sans DI (couplage fort, difficile tester)
- **Slide 56**: Dependency Injection - Exemple avec DI (interface IUserService, implémentation UserService)
- **Slide 57**: Dependency Injection - Exemple sans DI (Program.cs, enregistrement services AddScoped)
- **Slide 58**: Dependency Injection - Durée de vie des services (Transient, Scoped, Singleton)
- **Slide 59**: Dependency Injection - Exemple (affichage valeur alternative par type durée vie)
- **Slide 60**: Dependency Injection - Exemple (ILifetimeService avec GetInfo)

### Toastr
- **Slide 61**: Toastr - Bibliothèque JavaScript pour notifications toast non-bloquantes
- **Slide 62**: Toastr - Avantages (non-bloquante, personnalisable, pas dépendance, responsive, légère, Install-Package Toastr)
- **Slide 63**: Toastr - Set up (link stylesheet, script, configuration)
- **Slide 64**: Toastr - Personnalisation (4 types: Success, Info, Warning, Error)
- **Slide 65**: Toastr - Personnalisation (configuration globale: closeButton, positionClass, timeOut, etc.)

### Exercices Finaux
- **Slide 66**: Exercise final - Réaliser pokedex sous forme table (création, modification, vue détaillée, suppression)
- **Slide 67**: Exercise Final MVC Part 1 - Pokedex (lister Pokemons tableau, filtre nom/type, boutons actions)
- **Slide 68**: Exercise Final MVC Part 2 - Création Pokemon (lister champs, sauvegarder, valider, rediriger pokedex, toaster success/error)
- **Slide 69**: Exercise Final MVC Part 3 - Modification Pokemon (champs modifiables, sauvegarder, valider, toaster, annuler)
- **Slide 70**: Exercise Final MVC Part 4 - Vue détails Pokemon (champs non modifiables, passer mode édition, retour pokedex, suppression)
- **Slide 71**: Exercise Final MVC Part 4 - Suppression Pokemon (pop-up confirmation, suppression, toaster success, refresh liste)

### Notes
- **Slide 45**: REVOIR - selectlistitem pour dropdown, displayname pour labels, utilité viewmodel, selectionner item dropdown

### Conclusion
- **Slide 70**: Thank you for your attention

---

## Part 3: Additional Concepts (7 slides)

### Introduction & Overview
- **Slide 1**: Partie 3: Additional concepts - Geoffroy Zoetardt (24,25,26 Novembre 2025)
- **Slide 2**: Je suis Geoffroy Zoetardt (UCL – EPL – Sciences Informatique, Imagor/Pluxee)
- **Slide 4**: Table des matières - Toastr, Filters, Areas, JWT Tokens, Programmation asynchrone, Swashbuckle, Repository pattern, N-Tier architecture, Blazor

### Conclusion
- **Slide 5**: Thank you for your attention

---

## Summary

The course covers three main parts:

1. **Part 1: Web API REST** (94 slides) - Covers REST API fundamentals, HTTP protocols, project setup, controllers & routing, Entity Framework Core, migrations, DTOs, validations, CORS, Swagger, and Angular integration.

2. **Part 2: MVC** (74 slides) - Covers MVC pattern, architecture, views & Razor syntax, ViewModels, routing, data passing, tag helpers, HTML helpers, dependency injection, Toastr notifications, and comprehensive exercises.

3. **Part 3: Additional Concepts** (7 slides) - Overview of additional topics including Filters, Areas, JWT Tokens, async programming, Repository pattern, N-Tier architecture, and Blazor.

**Total**: 175 slides across all three presentations.

Generated on: 2026-11-13
