using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace PokemonApp.API.Filters;

public class CustomExceptionFilter : IExceptionFilter
{
    private readonly ILogger<CustomExceptionFilter> _logger;
    private readonly IHostEnvironment _hostEnvironment;

    public CustomExceptionFilter(
        ILogger<CustomExceptionFilter> logger,
        IHostEnvironment hostEnvironment)
    {
        _logger = logger;
        _hostEnvironment = hostEnvironment;
    }

    public void OnException(ExceptionContext context)
    {
        _logger.LogError(context.Exception, "An unhandled exception occurred");

        var statusCode = context.Exception switch
        {
            ArgumentException => StatusCodes.Status400BadRequest,
            UnauthorizedAccessException => StatusCodes.Status401Unauthorized,
            KeyNotFoundException => StatusCodes.Status404NotFound,
            _ => StatusCodes.Status500InternalServerError
        };

        var problemDetails = new ProblemDetails
        {
            Status = statusCode,
            Title = GetTitle(context.Exception),
            Detail = _hostEnvironment.IsDevelopment() ? context.Exception.Message : null,
            Instance = context.HttpContext.Request.Path
        };

        if (_hostEnvironment.IsDevelopment())
        {
            problemDetails.Extensions["stackTrace"] = context.Exception.StackTrace;
        }

        context.Result = new ObjectResult(problemDetails)
        {
            StatusCode = statusCode
        };

        context.ExceptionHandled = true;
    }

    private static string GetTitle(Exception exception)
    {
        return exception switch
        {
            ArgumentException => "Requête invalide",
            UnauthorizedAccessException => "Accès non autorisé",
            KeyNotFoundException => "Ressource introuvable",
            _ => "Une erreur s'est produite"
        };
    }
}
