using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing;

namespace MDMSApi2.Endpoints.Token;

public static class TokenRoutes
{
    public static void MapTokenRoutes(this IEndpointRouteBuilder routes)
    {
        routes.MapPost("/token", TokenHandlers.HandleTokenRequest)
            .WithName("GetToken")
            .Accepts<MDMSApi2.Models.Credentials>("application/json")
            .Produces(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status400BadRequest)
            .Produces(StatusCodes.Status401Unauthorized);

        routes.MapPost("/token/demo", TokenHandlers.HandleDemoTokenRequest)
            .WithName("GetDemoToken")
            .Produces(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status404NotFound);
    }
}
