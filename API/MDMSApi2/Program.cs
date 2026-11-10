using System.Reflection;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Microsoft.OpenApi.Models;
using Microsoft.Extensions.Options;
using Microsoft.EntityFrameworkCore;
using MDMSApi2.Domain;
using MDMSApi2.Endpoints.AppInfo;
using MDMSApi2.Endpoints.Contacts;
using MDMSApi2.Repositories;
using MDMSApi2.Endpoints.Token;
using MDMSApi2.Endpoints.SearchTags;
using Serilog;
using MDMSApi2.Settings;
using System.Security.Cryptography;

var builder = WebApplication.CreateBuilder(args);

// Ensure log folder exists before Serilog initializes file sink
try
{
    var logDir = Path.Combine(builder.Environment.ContentRootPath ?? AppContext.BaseDirectory, "Logs");
    if (!Directory.Exists(logDir)) Directory.CreateDirectory(logDir);
}
catch
{
    // ignore folder creation errors
}

// Configure Serilog early
Log.Logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .Enrich.FromLogContext()
    .WriteTo.Console()
    .CreateLogger();

builder.Host.UseSerilog();

// Add services to the container.
// builder.Services.AddControllers(); -- using minimal APIs instead

// EF Core - register DbContext
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") ?? "Server=(localdb)\\mssqllocaldb;Database=MDMS;Trusted_Connection=True;";
builder.Services.AddDbContext<ApplicationDbContext>(options =>
{
    options.UseSqlServer(connectionString, sqlOptions =>
    {
        // Enable retry on connection failures for cloud resilience
        sqlOptions.EnableRetryOnFailure(
            maxRetryCount: 3,
            maxRetryDelay: TimeSpan.FromSeconds(5),
            errorNumbersToAdd: null);
    });
});

// Register repository
builder.Services.AddScoped<IContactRepository, ContactRepository>();

// Swagger / OpenAPI
builder.Services.AddEndpointsApiExplorer();

// register options for JWT authentication
builder.Services.AddOptions<JwtOptions>()
    .Bind(builder.Configuration.GetSection(JwtOptions.SectionName))
    .ValidateDataAnnotations()
    .ValidateOnStart();
// register demo options
builder.Services.AddOptions<DemoOptions>()
    .Bind(builder.Configuration.GetSection(DemoOptions.SectionName));

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer();

// Configure JwtBearer from the validated JwtOptions (runs after the container is built)
builder.Services
    .AddOptions<JwtBearerOptions>(JwtBearerDefaults.AuthenticationScheme)
    .Configure<IOptions<JwtOptions>>((bearerOptions, jwtOptions) =>
    {
        var jwt = jwtOptions.Value;

        bearerOptions.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = jwt.Issuer,
            ValidateAudience = true,
            ValidAudience = jwt.Audience,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwt.Key)),
            ValidateLifetime = true,
            ClockSkew = TimeSpan.FromMinutes(2)
        };
    });


builder.Services.AddSwaggerGen(options =>
{
    var version = AppInfoHandlers.AppVersion;
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "MDMS API",
        Version = version,
        Description = "MDMS API documentation"
    });

    // Include XML comments if present
    var xmlFile = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
    var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);
    if (File.Exists(xmlPath))
    {
        options.IncludeXmlComments(xmlPath);
    }

    // Add JWT Bearer support to Swagger UI
    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "Enter 'Bearer' [space] and then your valid token in the text input below."
    });

    options.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "Bearer" }
            },
            Array.Empty<string>()
        }
    });
});

// Register authorization services required by app.UseAuthorization()
builder.Services.AddAuthorization();

var app = builder.Build();

// Seed a default user for development if none exists
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    var logger = scope.ServiceProvider.GetRequiredService<ILogger<Program>>();
    try
    {
        var demo = scope.ServiceProvider.GetRequiredService<IOptions<DemoOptions>>().Value;

        if (!demo.Enabled)
        {
            logger.LogInformation("Demo login disabled, skipping demo user seed.");
        }
        else if (!db.Users.Any(u => u.Username == demo.Username))
        {
            logger.LogInformation("Demo user '{User}' not found, creating it...", demo.Username);
            var hasher = new Microsoft.AspNetCore.Identity.PasswordHasher<User>();
            var user = new User { Username = demo.Username, DisplayName = "Demo User" };

            // The demo user signs in through /token/demo, so no one needs this password.
            // Generate a random one, hash it, and discard the plaintext.
            var randomPassword = Convert.ToBase64String(RandomNumberGenerator.GetBytes(32));
            user.PasswordHash = hasher.HashPassword(user, randomPassword);

            db.Users.Add(user);
            db.SaveChanges();
            logger.LogInformation("Demo user '{User}' created.", demo.Username);
        }
        else
        {
            logger.LogInformation("Demo user '{User}' already exists, skipping seed.", demo.Username);
        }
    }
    catch (Exception ex)
    {
        logger.LogError(ex, "Error seeding default user during startup.");
    }
}

// Configure the HTTP request pipeline.
// Enable Swagger in all environments for API documentation
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "MDMS API v1");
    if (app.Environment.IsDevelopment())
    {
        c.RoutePrefix = string.Empty; // Serve Swagger UI at app root in Development
    }
    // In Production, Swagger UI will be at /swagger
});

app.UseHttpsRedirection();

// Ensure authentication middleware runs before authorization
app.UseAuthentication();
app.UseAuthorization();

// Token endpoint routed via endpoint classes in Endpoints/Token
app.MapTokenRoutes();

// Map minimal API routes
app.MapAppInfoRoutes();
app.MapContactRoutes();
app.MapSearchTagRoutes();

// Startup diagnostics: validate authentication registration and list schemes
try
{
    using var scope = app.Services.CreateScope();
    var prov = scope.ServiceProvider;

    var schemeProvider = prov.GetService<Microsoft.AspNetCore.Authentication.IAuthenticationSchemeProvider>();
    if (schemeProvider == null)
    {
        app.Logger.LogError("IAuthenticationSchemeProvider is NOT registered. Authentication services may be missing.");
    }
    else
    {
        var schemes = schemeProvider.GetAllSchemesAsync().GetAwaiter().GetResult();
        if (schemes == null || !schemes.Any())
        {
            app.Logger.LogWarning("No authentication schemes were registered.");
        }
        else
        {
            foreach (var s in schemes)
            {
                app.Logger.LogInformation("Registered authentication scheme: Name='{Name}', DisplayName='{DisplayName}', HandlerType='{HandlerType}'",
                    s.Name, s.DisplayName ?? string.Empty, s.HandlerType?.FullName ?? string.Empty);
            }
        }
    }

    var authOptions = prov.GetService<Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Authentication.AuthenticationOptions>>()?.Value;
    if (authOptions != null)
    {
        app.Logger.LogInformation("AuthenticationOptions: DefaultAuthenticateScheme='{DefaultAuthenticate}', DefaultChallengeScheme='{DefaultChallenge}', DefaultScheme='{DefaultScheme}'",
            authOptions.DefaultAuthenticateScheme ?? string.Empty,
            authOptions.DefaultChallengeScheme ?? string.Empty,
            authOptions.DefaultScheme ?? string.Empty);
    }
}
catch (Exception ex)
{
    app.Logger.LogError(ex, "Exception while performing authentication startup diagnostics");
}

app.Run();
