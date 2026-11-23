using Microsoft.EntityFrameworkCore;
using PokemonApp.API.Data;
using PokemonApp.API.Interfaces;
using PokemonApp.API.Repositories;
using PokemonApp.API.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllers();

// Configure Entity Framework Core with SQLite
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("DefaultConnection")));

// Register Repository
builder.Services.AddScoped<IPokemonRepository, PokemonRepository>();

// Register Service
builder.Services.AddScoped<IPokemonService, PokemonService>();

var app = builder.Build();

// Configure the HTTP request pipeline
app.UseHttpsRedirection();

app.MapControllers();

app.Run();
