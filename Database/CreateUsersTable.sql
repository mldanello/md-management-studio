-- CreateUsersTable.sql
-- Creates the Users table used by the MDMS API for authentication
-- Run this script in the target database (e.g., MDMS)

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'dbo')
BEGIN
	EXEC('CREATE SCHEMA dbo');
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON t.schema_id = s.schema_id WHERE t.name = 'Users' AND s.name = 'dbo')
BEGIN
	CREATE TABLE dbo.Users
	(
		Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		Username NVARCHAR(256) NOT NULL,
		PasswordHash NVARCHAR(MAX) NOT NULL,
		DisplayName NVARCHAR(256) NULL,
		CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
	);

	-- Ensure usernames are unique
	CREATE UNIQUE INDEX IX_Users_Username ON dbo.Users(Username);
END
ELSE
BEGIN
	PRINT 'Table dbo.Users already exists. No action taken.';
END
GO

-- The demo user ('demouser') is created by the API at startup when Demo:Enabled is true,
-- with a random password that is hashed and discarded. No manual insert is needed.
-- Example insert (commented out). Use only for development/testing.
-- INSERT INTO dbo.Users (Username, PasswordHash, DisplayName)
-- VALUES ('demouser', '<hashed-password-here>', 'Demo User');
