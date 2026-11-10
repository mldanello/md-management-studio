-- Created by GitHub Copilot in SSMS - review carefully before executing
-- This script populates sample data across all contact management tables (Tenant, Contact, 
-- ContactAddress, ContactPhone, and ContactSearchTag) to support testing and demonstration 
-- of the contact system.

-- Insert sample Tenant data
INSERT INTO MDMS.dbo.Tenant ([Name], [Description], IsActive)
VALUES
    (N'Acme Corporation', N'Leading provider of innovative solutions', 1),
    (N'Global Tech Solutions', N'Technology consulting and services', 1),
    (N'Innovation Labs', N'Research and development firm', 1);

-- Insert sample Contact data (6 contacts across 3 tenants)
INSERT INTO MDMS.dbo.Contact (TenantId, FirstName, MiddleName, LastName, CompanyName, Email, Web, Notes, IsActive)
VALUES
    (1, N'John', N'Michael', N'Smith', N'Acme Corporation', N'john.smith@acme.example', N'https://www.acme.example', N'Primary contact for account management', 1),
    (1, N'Sarah', NULL, N'Johnson', N'Acme Corporation', N'sarah.johnson@acme.example', NULL, N'Technical lead', 1),
    (2, N'Robert', N'James', N'Williams', N'Global Tech Solutions', N'robert.williams@globaltech.example', N'https://www.globaltech.example', N'VP of Sales', 1),
    (2, N'Emily', N'Anne', N'Davis', N'Global Tech Solutions', N'emily.davis@globaltech.example', NULL, N'Project Manager', 1),
    (3, N'Michael', NULL, N'Brown', N'Innovation Labs', N'mbrown@innovationlabs.example', N'https://www.innovationlabs.example', N'Chief Technology Officer', 1),
    (3, N'Jessica', N'Marie', N'Wilson', N'Innovation Labs', N'jwilson@innovationlabs.example', NULL, N'Research Scientist', 1);

-- Insert sample ContactAddress data (4 addresses for selected contacts)
INSERT INTO MDMS.dbo.ContactAddress (ContactId, Street1, Street2, City, County, [State], Zip, IsActive)
VALUES
    (1, N'123 Main Street', N'Suite 100', N'New York', N'New York', N'NY', N'10001', 1),
    (1, N'456 Park Avenue', NULL, N'New York', N'New York', N'NY', N'10022', 1),
    (3, N'789 Tech Boulevard', N'Building A', N'San Francisco', N'San Francisco', N'CA', N'94105', 1),
    (5, N'321 Innovation Drive', NULL, N'Boston', N'Suffolk', N'MA', N'02108', 1);

-- Insert sample ContactPhone data (8 phone numbers)
INSERT INTO MDMS.dbo.ContactPhone (ContactId, Number, [Type], IsPrimary, IsActive)
VALUES
    (1, N'(555) 123-4567', N'Office', 1, 1),
    (1, N'(555) 123-4568', N'Mobile', 0, 1),
    (2, N'(555) 234-5678', N'Office', 1, 1),
    (3, N'(555) 345-6789', N'Mobile', 1, 1),
    (3, N'(555) 345-6790', N'Office', 0, 1),
    (4, N'(555) 456-7890', N'Office', 1, 1),
    (5, N'(555) 567-8901', N'Mobile', 1, 1),
    (6, N'(555) 678-9012', N'Office', 1, 1);

-- Insert sample ContactSearchTag data (11 tags for contact discovery)
INSERT INTO MDMS.dbo.ContactSearchTag (ContactId, TagText, IsActive)
VALUES
    (1, N'Executive', 1),
    (1, N'Decision Maker', 1),
    (2, N'Technical', 1),
    (2, N'Developer', 1),
    (3, N'Sales', 1),
    (3, N'VP', 1),
    (4, N'Project Manager', 1),
    (5, N'CTO', 1),
    (5, N'Executive', 1),
    (6, N'Scientist', 1),
    (6, N'Research', 1);