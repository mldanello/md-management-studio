using System.Reflection;
using MDMSApi2.Endpoints.AppInfo.Models;
using MDMSApi2.Settings;
using Microsoft.Extensions.Options;

namespace MDMSApi2.Endpoints.AppInfo;

public static class AppInfoHandlers
{
    // "2.1.0+<git commit>": set from <Version> in the csproj; .NET adds the commit at build time
    public static readonly string AppVersion =
        Assembly.GetExecutingAssembly()
            .GetCustomAttribute<AssemblyInformationalVersionAttribute>()?.InformationalVersion ?? "unknown";

    public static IResult GetVersion() => Results.Ok(new { appVersion = AppVersion });
    
    public static IResult GetClientConfig(IOptions<DemoOptions> demoOptions) =>
        Results.Ok(new ClientConfigModel(demoOptions.Value.Enabled));
}
