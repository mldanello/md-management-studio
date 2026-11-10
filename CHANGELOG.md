# Changelog

All notable changes to this project are listed here. Versions follow [Semantic Versioning](https://semver.org/).

## [2.1.0] - 2026-11-10

First public release. This repo starts with a clean history; earlier development history stays private.

### Security
- Passwordless demo login: `POST /token/demo` issues a short-lived JWT for the demo user, whose random password is hashed and discarded at seed time. Returns 404 when `Demo:Enabled` is off.
- Azure SQL uses Entra-only authentication; the API connects with its managed identity, with no database password in config.
- No secrets in the repo: production settings come from App Service configuration, local settings from .NET user secrets. `appsettings.Example.json` shows the expected shape.
- gitleaks secret scan on every push and PR (pinned, SHA-256-verified binary), with a custom rule for passwords in SQL connection strings.
- Patched the vulnerable transitive `System.Security.Cryptography.Pkcs` package by pinning 10.0.14; JwtBearer upgraded to 10.0.14; zero build warnings.

### Added
- Playwright E2E smoke tests (Chromium and Firefox) on push, PR, and a daily schedule: demo login, logged-out redirect, session-expired message, contacts page, keyboard selection, and API version check.
- `GET /version` on the API and `GET /__version` on the UI report the running build.
- Session-expiry handling in the UI: expired tokens are detected client-side and the user sees a session-expired message.
- Contact list accessibility: names are keyboard-focusable buttons, Edit/Delete have named labels, and the list uses list roles.

### Removed
- Template and debug endpoints (`/weather`, `/contacts/test`, `/contacts/testauth`).
