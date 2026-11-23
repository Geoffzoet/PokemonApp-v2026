using System.Diagnostics;
using Microsoft.AspNetCore.Mvc.Filters;

namespace PokemonApp.API.Filters;

public class PerformanceLoggingFilter : IAsyncActionFilter
{
    private readonly ILogger<PerformanceLoggingFilter> _logger;

    public PerformanceLoggingFilter(ILogger<PerformanceLoggingFilter> logger)
    {
        _logger = logger;
    }

    public async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
    {
        var stopwatch = Stopwatch.StartNew();
        var actionName = context.ActionDescriptor.DisplayName;

        _logger.LogInformation("Executing action: {ActionName}", actionName);

        var resultContext = await next();

        stopwatch.Stop();
        var elapsedMs = stopwatch.ElapsedMilliseconds;

        if (resultContext.Exception != null)
        {
            _logger.LogWarning(
                "Action {ActionName} failed after {ElapsedMs}ms with exception: {Exception}",
                actionName, elapsedMs, resultContext.Exception.Message);
        }
        else
        {
            _logger.LogInformation(
                "Action {ActionName} completed in {ElapsedMs}ms",
                actionName, elapsedMs);

            if (elapsedMs > 1000)
            {
                _logger.LogWarning(
                    "Slow action detected: {ActionName} took {ElapsedMs}ms",
                    actionName, elapsedMs);
            }
        }
    }
}
