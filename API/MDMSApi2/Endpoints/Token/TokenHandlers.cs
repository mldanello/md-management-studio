using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using MDMSApi2.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using MDMSApi2.Settings;

namespace MDMSApi2.Endpoints.Token;

public static class TokenHandlers
{
    public static async Task<IResult> HandleTokenRequest([FromBody] MDMSApi2.Models.Credentials? creds, 
        ILogger<Program> logger, IOptions<JwtOptions> jwtOptions, ApplicationDbContext db)
    {
        if (creds is null)
        {
            logger.LogWarning("Token request received with empty body or wrong content-type.");
            return Results.BadRequest(new { error = "Missing credentials in request body" });
        }

        logger.LogInformation("Token request for username='{User}'", creds.Username);

        // look up user in database
        var user = await db.Users.SingleOrDefaultAsync(u => u.Username == creds.Username);
        if (user is null)
        {
            logger.LogWarning("Invalid credentials for username='{User}' (user not found)", creds.Username);
            return Results.Unauthorized();
        }

        var hasher = new PasswordHasher<User>();
        var verify = hasher.VerifyHashedPassword(user, user.PasswordHash, creds.Password);
        if (verify != PasswordVerificationResult.Success && verify != PasswordVerificationResult.SuccessRehashNeeded)
        {
            logger.LogWarning("Invalid credentials for username='{User}' (bad password)", creds.Username);
            return Results.Unauthorized();
        }

        return IssueToken(user, jwtOptions.Value, logger);
    }

    public static async Task<IResult> HandleDemoTokenRequest(
        ILogger<Program> logger, IOptions<JwtOptions> jwtOptions, 
        IOptions<DemoOptions> demoOptions, ApplicationDbContext db)
    {
        var demo = demoOptions.Value;
        if(!demo.Enabled)
        {
            return Results.NotFound();      // when demo is off, act like the endpoint doesn't exist
        }

        var user = await db.Users.SingleOrDefaultAsync(u => u.Username == demo.Username);
        if (user is null)
        {
            logger.LogError("Demo login is enabled but demo user '{User}' was not found.", demo.Username);
            return Results.Problem("Demo login is not available.", statusCode: StatusCodes.Status503ServiceUnavailable);
        }

        return IssueToken(user, jwtOptions.Value, logger);
    }
    private static IResult IssueToken(User user, JwtOptions jwt, ILogger logger)
    {
        logger.LogDebug("Generating JWT token for user '{User}' with expiration {Minutes} minutes", user.Username, jwt.ExpirationMinutes);

        var claims = new[] {
            new Claim(JwtRegisteredClaimNames.Sub, user.Username),
            new Claim(ClaimTypes.Name, user.Username),
            new Claim("user_id", user.Id.ToString()),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            new Claim(JwtRegisteredClaimNames.Iat, DateTimeOffset.UtcNow.ToUnixTimeSeconds().ToString(), ClaimValueTypes.Integer64)
        };

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwt.Key));
        var credsSigning = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: jwt.Issuer,
            audience: jwt.Audience,
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(jwt.ExpirationMinutes),
            signingCredentials: credsSigning
        );

        var tokenString = new JwtSecurityTokenHandler().WriteToken(token);

        logger.LogInformation("Successfully generated JWT token for user '{User}'", user.Username);

        return Results.Ok(new { access_token = tokenString, token_type = "Bearer", expires_in = jwt.ExpirationMinutes * 60 });
    }
}
