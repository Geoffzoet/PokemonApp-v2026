using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;

namespace PokemonApp.API.Controllers;

[ApiController]
[ApiExplorerSettings(IgnoreApi = true)]
public class ErrorController : ControllerBase
{
    private readonly ILogger<ErrorController> _logger;

    public ErrorController(ILogger<ErrorController> logger)
    {
        _logger = logger;
    }

    [Route("/error")]
    public IActionResult HandleError()
    {
        var exceptionHandlerFeature = HttpContext.Features.Get<IExceptionHandlerFeature>();

        if (exceptionHandlerFeature != null)
        {
            var exception = exceptionHandlerFeature.Error;
            _logger.LogError(exception, "An unhandled exception occurred");
        }

        return Problem(
            statusCode: 500,
            title: "Une erreur s'est produite lors du traitement de votre requête"
        );
    }

    [Route("/error-development")]
    public IActionResult HandleErrorDevelopment([FromServices] IHostEnvironment hostEnvironment)
    {
        if (!hostEnvironment.IsDevelopment())
        {
            return NotFound();
        }

        var exceptionHandlerFeature = HttpContext.Features.Get<IExceptionHandlerFeature>();

        if (exceptionHandlerFeature != null)
        {
            var exception = exceptionHandlerFeature.Error;
            _logger.LogError(exception, "An unhandled exception occurred");

            return Problem(
                detail: exception.StackTrace,
                title: exception.Message,
                statusCode: 500
            );
        }

        return Problem();
    }
}
