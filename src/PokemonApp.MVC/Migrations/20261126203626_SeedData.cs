using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace PokemonApp.MVC.Migrations
{
    /// <inheritdoc />
    public partial class SeedData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Pokemons",
                columns: new[] { "Id", "DefensePoints", "HealthPoints", "ImageURL", "Name", "RarityPercentage", "Type" },
                values: new object[,]
                {
                    { 1, 30, 60, "/img/pikachu.svg", "Pikachu", 0.59999999999999998, 4 },
                    { 2, 50, 70, "/img/salameche.svg", "Salamèche", 0.29999999999999999, 1 },
                    { 3, 50, 80, "/img/bulbizarre.svg", "Bulbizarre", 0.29999999999999999, 0 },
                    { 4, 60, 70, "/img/carapuce.svg", "Carapuce", 0.29999999999999999, 3 },
                    { 5, 30, 50, "/img/roucool.svg", "Roucool", 0.69999999999999996, 2 },
                    { 6, 20, 40, "/img/rattata.svg", "Rattata", 0.90000000000000002, 0 }
                });

            migrationBuilder.InsertData(
                table: "Trainers",
                columns: new[] { "Id", "BadgeCount", "Name", "Town" },
                values: new object[,]
                {
                    { 1, 3, "Sacha", "Bourg Palette" },
                    { 2, 1, "Pierre", "Argenta" }
                });

            migrationBuilder.InsertData(
                table: "Attacks",
                columns: new[] { "Id", "Name", "Points", "PokemonId" },
                values: new object[,]
                {
                    { 1, "Éclair", 40, 1 },
                    { 2, "Tonnerre", 60, 1 },
                    { 3, "Charge", 20, 1 },
                    { 4, "Flammèche", 40, 2 },
                    { 5, "Lance-Flammes", 70, 2 },
                    { 6, "Griffe", 30, 2 },
                    { 7, "Fouet Lianes", 45, 3 },
                    { 8, "Tranch'Herbe", 55, 3 },
                    { 9, "Poudre Toxik", 25, 3 },
                    { 10, "Pistolet à O", 40, 4 },
                    { 11, "Hydrocanon", 70, 4 },
                    { 12, "Morsure", 35, 4 },
                    { 13, "Cru-Aile", 35, 5 },
                    { 14, "Tornade", 40, 5 },
                    { 15, "Vive-Attaque", 30, 6 },
                    { 16, "Croc de Mort", 45, 6 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Attacks",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Attacks",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Attacks",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Attacks",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Attacks",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Attacks",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Attacks",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Attacks",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Attacks",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Attacks",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Attacks",
                keyColumn: "Id",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Attacks",
                keyColumn: "Id",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "Attacks",
                keyColumn: "Id",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "Attacks",
                keyColumn: "Id",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "Attacks",
                keyColumn: "Id",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "Attacks",
                keyColumn: "Id",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "Trainers",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Trainers",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Pokemons",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Pokemons",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Pokemons",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Pokemons",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Pokemons",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Pokemons",
                keyColumn: "Id",
                keyValue: 6);
        }
    }
}
