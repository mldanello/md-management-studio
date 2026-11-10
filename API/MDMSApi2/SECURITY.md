Secure JWT secret setup (development and production)

This project reads JWT configuration from configuration keys Jwt:Key, Jwt:Issuer, Jwt:Audience.

Never commit secrets to source control. Recommended options:

1) dotnet user-secrets (recommended for local dev)

- Initialize user-secrets in the project folder (only needs to be done once):

```bash
cd <project-folder>
dotnet user-secrets init
```

- Set the JWT key:

```bash
dotnet user-secrets set "Jwt:Key" "$(openssl rand -base64 48)"
# or on Windows PowerShell:
# dotnet user-secrets set "Jwt:Key" ([Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(48)))
```

2) Environment variable (works in all environments)

- The configuration key Jwt:Key maps to the environment variable name Jwt__Key (double underscore).

- Set it for current shell (Linux/macOS):

```bash
export Jwt__Key="$(openssl rand -base64 48)"
``` 

- Set it in PowerShell (current session):

```powershell
$env:Jwt__Key = [Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(48))
```

- Persist for current user on Windows (PowerShell cmd):

```powershell
setx Jwt__Key "<your-secret-here>"
```

3) Production: use a secrets manager

- Use Azure Key Vault, AWS Secrets Manager, HashiCorp Vault, or similar.
- Provide the secret to the application via secure provider or environment variables.
- Rotate keys periodically and use managed identities where possible.

Validation and verification

- After setting the secret, run the app and request a token from /token/demo (or /token) to verify signing works.
- To inspect which configuration value the app reads (development only), you can temporarily log builder.Configuration["Jwt:Key"] length or existence, but avoid logging secrets.

Notes

- Use a high-entropy secret (32+ bytes). Base64-encoded random bytes are suitable.
- Keep the issuer/audience values consistent between token issuance and validation.
- Consider storing separate keys per environment and enabling key rotation.
