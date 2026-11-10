using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing;

namespace MDMSApi2.Endpoints.SearchTags;

public static class SearchTagRoutes
{
    public static void MapSearchTagRoutes(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/searchtags").RequireAuthorization();

        group.MapGet("/", SearchTagHandlers.GetSearchTagsAsync).WithName("GetSearchTags");
    }
}
