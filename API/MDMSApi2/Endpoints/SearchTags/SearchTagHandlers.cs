using Microsoft.EntityFrameworkCore;
using MDMSApi2.Domain;

namespace MDMSApi2.Endpoints.SearchTags;

public static class SearchTagHandlers
{
    public static async Task<IResult> GetSearchTagsAsync(ApplicationDbContext db, ILogger<Program> log)
    {
        log.LogInformation("Fetching distinct search tags");

        var items = await db.ContactSearchTags
            .Where(t => t.IsActive)
            .Select(t => t.TagText ?? string.Empty)
            .Distinct()
            .OrderBy(t => t)
            .ToListAsync();

        log.LogInformation("Found {Count} distinct search tags", items.Count);
        return Results.Ok(items);
    }
}
