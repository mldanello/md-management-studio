namespace MDMSApi2.Endpoints.AppInfo;

public static class AppInfoRoutes
{
    public static void MapAppInfoRoutes(this WebApplication app)
    {
        app.MapGet("/version", AppInfoHandlers.GetVersion)
            .WithName("GetVersion")
            .AllowAnonymous();
    }
}
