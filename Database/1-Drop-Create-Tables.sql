-- Creates Tenant and Contact tables with Foreign Key constraint in MDMS database

-- Drop dependent tables first (if they exist)
IF EXISTS (SELECT 1 FROM MDMS.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ContactSearchTag' AND TABLE_SCHEMA = 'dbo')
BEGIN
    DROP TABLE MDMS.dbo.ContactSearchTag;
    PRINT 'Table MDMS.dbo.ContactSearchTag has been dropped.';
END;

IF EXISTS (SELECT 1 FROM MDMS.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ContactPhone' AND TABLE_SCHEMA = 'dbo')
BEGIN
    DROP TABLE MDMS.dbo.ContactPhone;
    PRINT 'Table MDMS.dbo.ContactPhone has been dropped.';
END;

IF EXISTS (SELECT 1 FROM MDMS.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ContactAddress' AND TABLE_SCHEMA = 'dbo')
BEGIN
    DROP TABLE MDMS.dbo.ContactAddress;
    PRINT 'Table MDMS.dbo.ContactAddress has been dropped.';
END;

-- Drop Contact before Tenant (FK dependency)
IF EXISTS (SELECT 1 FROM MDMS.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Contact' AND TABLE_SCHEMA = 'dbo')
BEGIN
    DROP TABLE MDMS.dbo.Contact;
    PRINT 'Table MDMS.dbo.Contact has been dropped.';
END;

-- Drop Tenant
IF EXISTS (SELECT 1 FROM MDMS.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Tenant' AND TABLE_SCHEMA = 'dbo')
BEGIN
    DROP TABLE MDMS.dbo.Tenant;
    PRINT 'Table MDMS.dbo.Tenant has been dropped.';
END;

-- Create Tenant table (parent)
CREATE TABLE MDMS.dbo.Tenant
(
    Id    			INT IDENTITY(1,1)     	NOT NULL PRIMARY KEY CLUSTERED,
    [Name]  		NVARCHAR(256)         	NOT NULL,
	[Description]  	NVARCHAR(2500)        	NULL,
    IsActive    	BIT                   	NOT NULL CONSTRAINT DF_Tenant_IsActive DEFAULT (1),
    CreatedAt   	DATETIME2(3)         	NOT NULL CONSTRAINT DF_Tenant_CreatedAt DEFAULT (SYSUTCDATETIME()),
    ModifiedAt  	DATETIME2(3)         	NOT NULL CONSTRAINT DF_Tenant_ModifiedAt DEFAULT (SYSUTCDATETIME()),
    [RowVersion]   	ROWVERSION            NOT NULL  
);

-- Create Contact table (child) with FK to Tenant
CREATE TABLE MDMS.dbo.Contact
(
    Id    		 	INT IDENTITY(1,1)     NOT NULL PRIMARY KEY CLUSTERED,
    TenantID     	INT                   NOT NULL,
    FirstName    	NVARCHAR(100)         NOT NULL,
	MiddleName   	NVARCHAR(100)         NULL, 	
    LastName     	NVARCHAR(100)         NOT NULL,
	CompanyName		NVARCHAR(500)         NULL, 
	Email			NVARCHAR(256)         NULL, 
	Web				NVARCHAR(500)         NULL, 
	Notes			NVARCHAR(2500)        NULL,
    IsActive     	BIT                   NOT NULL CONSTRAINT DF_Contact_IsActive DEFAULT (1),
    CreatedAt    	DATETIME2(3)          NOT NULL CONSTRAINT DF_Contact_CreatedAt DEFAULT (SYSUTCDATETIME()),
    ModifiedAt   	DATETIME2(3)          NOT NULL CONSTRAINT DF_Contact_ModifiedAt DEFAULT (SYSUTCDATETIME()),
	RowVersion   	ROWVERSION            NOT NULL 
    CONSTRAINT FK_Contact_TenantId FOREIGN KEY (TenantId) REFERENCES MDMS.dbo.Tenant(Id)
);

-- Create supporting indexes
CREATE INDEX IX_Contact_TenantId ON MDMS.dbo.Contact(TenantId);
--CREATE INDEX IX_Contact_Email ON MDMS.dbo.Contact(Email);

CREATE TABLE dbo.ContactAddress 
( Id				INT IDENTITY(1,1)		NOT NULL PRIMARY KEY CLUSTERED, 
  ContactId			INT						NOT NULL,
  Street1			NVARCHAR(200)			NULL, 
  Street2			NVARCHAR(200)			NULL, 
  City				NVARCHAR(100)			NULL, 
  County			NVARCHAR(100)			NULL, 
  [State]			NVARCHAR(100)			NULL, 
  Zip				NVARCHAR(20)			NULL,
  --Country      	NVARCHAR(100)         	NULL, 
  IsActive     		BIT                   	NOT NULL CONSTRAINT DF_ContactAddress_IsActive DEFAULT (1), 
  CreatedAt    		DATETIME2(3)         	NOT NULL CONSTRAINT DF_ContactAddress_CreatedAt DEFAULT (SYSUTCDATETIME()), 
  ModifiedAt   		DATETIME2(3)         	NOT NULL CONSTRAINT DF_ContactAddress_ModifiedAt DEFAULT (SYSUTCDATETIME()), 
  CONSTRAINT FK_ContactAddress_ContactId FOREIGN KEY (ContactId) REFERENCES MDMS.dbo.Contact(Id)
 ); 
CREATE INDEX IX_ContactAddress_ContactId ON MDMS.dbo.ContactAddress(ContactId);


CREATE TABLE dbo.ContactPhone
( Id					INT IDENTITY(1,1)   NOT NULL PRIMARY KEY CLUSTERED, 
  ContactId			INT					    NOT NULL,
  Number				NVARCHAR(50)        NOT NULL, 
  [Type]				NVARCHAR(100)       NULL, 
  IsPrimary			    BIT                 NOT NULL CONSTRAINT DF_Phone_IsPrimary DEFAULT (1),
  IsActive     BIT                   		NOT NULL CONSTRAINT DF_ContactPhone_IsActive DEFAULT (1), 
  CreatedAt    DATETIME2(3)         		NOT NULL CONSTRAINT DF_ContactPhone_CreatedAt DEFAULT (SYSUTCDATETIME()), 
  ModifiedAt   DATETIME2(3)         		NOT NULL CONSTRAINT DF_ContactPhone_ModifiedAt DEFAULT (SYSUTCDATETIME()), 
  CONSTRAINT FK_ContactPhone_ContactId FOREIGN KEY (ContactId) REFERENCES MDMS.dbo.Contact(Id)  
);	
CREATE INDEX IX_ContactPhone_ContactId ON MDMS.dbo.ContactPhone(ContactId);

CREATE TABLE dbo.ContactSearchTag 
( Id			INT IDENTITY(1,1)			NOT NULL PRIMARY KEY CLUSTERED, 
  ContactId		INT							NOT NULL,
  TagText		NVARCHAR(50)				NULL, 
  IsActive     BIT                   		NOT NULL CONSTRAINT DF_ContactSearchTag_IsActive DEFAULT (1), 
  CreatedAt    DATETIME2(3)         		NOT NULL CONSTRAINT DF_ContactSearchTag_CreatedAt DEFAULT (SYSUTCDATETIME()), 
  ModifiedAt   DATETIME2(3)         		NOT NULL CONSTRAINT DF_ContactSearchTag_ModifiedAt DEFAULT (SYSUTCDATETIME()), 
  CONSTRAINT FK_ContactSearchTag_ContactId FOREIGN KEY (ContactId) REFERENCES MDMS.dbo.Contact(Id)   
 ); 
CREATE INDEX IX_ContactSearchTag_ContactId ON MDMS.dbo.ContactSearchTag(ContactId);

PRINT 'Tables MDMS.dbo.Tenant and MDMS.dbo.Contact created successfully.';