using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
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

// Configure Swagger/OpenAPI
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Pokemon API",
        Version = "2.0.0",
        Description = "API REST pour gérer une collection de Pokémon",
        Contact = new OpenApiContact
        {
            Name = "Pokemon App Support",
            Email = "support@pokemonapp.com"
        },
        License = new OpenApiLicense
        {
            Name = "MIT",
            Url = new Uri("https://opensource.org/licenses/MIT")
        }
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(options =>
    {
        options.SwaggerEndpoint("/swagger/v1/swagger.json", "Pokemon API v2.0.0");
        options.RoutePrefix = string.Empty; // Swagger UI at root (/)
    });
}

app.UseHttpsRedirection();

app.MapControllers();

app.Run();
