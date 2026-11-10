namespace MDMSApi2.Settings;

public class DemoOptions
{
    public const string SectionName = "Demo";
    public bool Enabled { get; set; } = false;
    public string Username { get; set; } = "demouser";
}