<#
PowerShell helper to set up dev JWT secret and config for this project.
Usage:
  - Run from repo root (where the .csproj lives):
	  ./scripts/setup-dev-env.ps1
  - To persist the JWT secret as a user environment variable (Windows), run with -Persist:
	  ./scripts/setup-dev-env.ps1 -Persist
#>
param(
	[switch]$Persist
)

$projectDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
if (-not (Test-Path "$projectDir/MDMSApi2.csproj")) {
	Write-Host "Warning: Could not find MDMSApi2.csproj in script directory. Run from repo root." -ForegroundColor Yellow
}

Write-Host "Initializing dotnet user-secrets (if not already initialized)..."
dotnet user-secrets init | Out-Null

Write-Host "Generating a high-entropy 48-byte Base64 secret..."
$bytes = New-Object byte[] 48
(New-Object System.Security.Cryptography.RNGCryptoServiceProvider).GetBytes($bytes)
$secret = [Convert]::ToBase64String($bytes)

Write-Host "Storing Jwt:Key in user-secrets..."
dotnet user-secrets set "Jwt:Key" "$secret"

# Set issuer/audience defaults in user-secrets as well
dotnet user-secrets set "Jwt:Issuer" "MDMSDevIssuer"
dotnet user-secrets set "Jwt:Audience" "MDMSDevAudience"

Write-Host "Done. Jwt:Key stored in user-secrets. Do NOT commit this value to source control." -ForegroundColor Green

if ($Persist) {
	Write-Host "Persisting as user environment variable Jwt__Key (via setx). This will apply to new processes." -ForegroundColor Yellow
	setx Jwt__Key $secret | Out-Null
	Write-Host "setx done. You may need to restart your shell/IDE to pick up the value." -ForegroundColor Green
}

Write-Host "To verify, run: dotnet user-secrets list" -ForegroundColor Cyan
Write-Host "To request a token: POST /token/demo (no body needed; requires Demo:Enabled = true)" -ForegroundColor Cyan