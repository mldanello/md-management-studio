using System.Reflection;

namespace MDMSApi2.Endpoints.AppInfo;

public static class AppInfoHandlers
{
    // "2.1.0+<git commit>": set from <Version> in the csproj; .NET adds the commit at build time
    public static readonly string AppVersion =
        Assembly.GetExecutingAssembly()
            .GetCustomAttribute<AssemblyInformationalVersionAttribute>()?.InformationalVersion ?? "unknown";

    public static IResult GetVersion() => Results.Ok(new { appVersion = AppVersion });
}
