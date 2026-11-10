MDMSApi2 - Development setup

Quickstart (development)

1) Prerequisites
   - .NET 10 SDK, dotnet CLI
   - PowerShell (recommended) on Windows/macOS/Linux or bash

2) Create and load a dev JWT secret (recommended - user-secrets)
   - From repo root run:

```powershell
./scripts/setup-dev-env.ps1
```

   - To persist as a user environment variable (Windows setx), run:

```powershell
./scripts/setup-dev-env.ps1 -Persist
```

3) Point the API at a database

   `appsettings.json` has no connection string. Production gets it from the App Service configuration. Locally, store yours in user-secrets (see `appsettings.Example.json` for the shape):

```powershell
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "Server=<your-sql-server>;Database=MDMS;Encrypt=True;Authentication=Active Directory Default;"
```

   - Create the schema with `Database/1-Drop-Create-Tables.sql` and `Database/CreateUsersTable.sql`; sample data is in `scripts/SampleData.sql`.

4) Run the app

```powershell
dotnet run --project MDMSApi2.csproj --launch-profile https
```

   - The `https` profile listens on `https://localhost:7219` (used below and by the Angular dev proxy). Plain `dotnet run` uses the `http` profile on `http://localhost:5189` only.

5) Get a token (for testing)

```bash
curl -k -X POST https://localhost:7219/token/demo
```
```PowerShell
Invoke-RestMethod -Method Post https://localhost:7219/token/demo
```

6) Postman (optional)
   - Import `Postman/MDMS_2.0.postman_collection.json` (from the repo root).
   - Create two Postman environments, each with a `baseUrl` variable:

| Environment     | baseUrl                                                            |
|-----------------|--------------------------------------------------------------------|
| MDMS-Local      | `https://localhost:7219`                                           |
| MDMS-Live       | `https://mdms-api-app-ggg5f9dxggfmefby.eastus-01.azurewebsites.net` |

   - Select an environment, then run "Get Demo Token". Its script saves the token to `bearer-token` in the active environment, and the Contacts folder sends it as a Bearer token.
   - Optional: create `bearer-token` yourself first with type "secret" so Postman masks it.
   - Don't commit environment exports. `*.postman_environment.json` is in `.gitignore` because exported environments can contain tokens.

Security notes
- The setup script stores the secret in dotnet user-secrets. Do NOT commit secrets to source control.
- For production, use a managed secrets store (Azure Key Vault, AWS Secrets Manager, etc.) and set Jwt__Key as an environment variable or use the provider integration.
