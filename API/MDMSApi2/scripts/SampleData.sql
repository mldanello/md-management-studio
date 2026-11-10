-- =============================================
-- MDMS 2.0 Sample Data Script
-- Azure SQL Server Compatible
-- Generated: 2026-07-10
-- Description: Loads sample contacts with addresses, phones, and search tags
-- =============================================

SET NOCOUNT ON;
GO

-- =============================================
-- Clean up existing data (handles FK constraints)
-- =============================================
PRINT 'Cleaning up existing data...';

-- Delete in correct order due to foreign key constraints
-- Child tables first, then parent tables
DELETE FROM ContactSearchTag;
DELETE FROM ContactPhone;
DELETE FROM ContactAddress;
DELETE FROM Contact;
DELETE FROM Tenant;

-- Reset identity seeds to start fresh
DBCC CHECKIDENT ('ContactSearchTag', RESEED, 0);
DBCC CHECKIDENT ('ContactPhone', RESEED, 0);
DBCC CHECKIDENT ('ContactAddress', RESEED, 0);
DBCC CHECKIDENT ('Contact', RESEED, 0);
DBCC CHECKIDENT ('Tenant', RESEED, 0);

PRINT 'Existing data cleaned successfully.';
GO

-- =============================================
-- 1. Create Tenants
-- =============================================
PRINT 'Inserting Tenants...';

SET IDENTITY_INSERT Tenant ON;

INSERT INTO Tenant (Id, Name, Description, IsActive, CreatedAt, ModifiedAt)
VALUES 
	(1, 'Acme Corporation', 'Primary business tenant for sample data', 1, GETUTCDATE(), GETUTCDATE()),
	(2, 'TechStart Inc', 'Technology startup tenant', 1, GETUTCDATE(), GETUTCDATE()),
	(3, 'Global Enterprises', 'International business operations', 1, GETUTCDATE(), GETUTCDATE());

SET IDENTITY_INSERT Tenant OFF;

PRINT 'Tenants inserted successfully.';
GO

-- =============================================
-- 2. Create Contacts (100 sample contacts)
-- =============================================
PRINT 'Inserting Contacts...';

DECLARE @BaseDate DATETIME = GETUTCDATE();

INSERT INTO Contact (TenantId, FirstName, MiddleName, LastName, CompanyName, Email, Web, Notes, IsActive, CreatedAt, ModifiedAt)
VALUES
	-- Technology Sector (1-25)
	(1, 'Sarah', 'Jane', 'Johnson', 'Tech Solutions LLC', 'sarah.johnson@techsolutions.example', 'www.techsolutions.example', 'Senior software architect with 15 years experience', 1, @BaseDate, @BaseDate),
	(1, 'Michael', 'David', 'Williams', 'Digital Innovations', 'michael.williams@diginnovate.example', 'www.diginnovate.example', 'CEO and founder, specializes in AI/ML', 1, @BaseDate, @BaseDate),
	(1, 'Jennifer', NULL, 'Brown', 'CloudNet Systems', 'jennifer.brown@cloudnet.example', 'www.cloudnet.example', 'Cloud infrastructure consultant', 1, @BaseDate, @BaseDate),
	(1, 'Robert', 'James', 'Davis', 'DataCore Analytics', 'robert.davis@datacore.example', NULL, 'Data scientist and analytics expert', 1, @BaseDate, @BaseDate),
	(1, 'Emily', 'Rose', 'Miller', 'CyberSecure Pro', 'emily.miller@cybersecure.example', 'www.cybersecure.example', 'Information security specialist', 1, @BaseDate, @BaseDate),
	(1, 'David', NULL, 'Wilson', 'AppDev Studios', 'david.wilson@appdev.example', 'www.appdev.example', 'Mobile application developer', 1, @BaseDate, @BaseDate),
	(1, 'Lisa', 'Marie', 'Moore', 'WebForge Inc', 'lisa.moore@webforge.example', 'www.webforge.example', 'Full-stack web developer', 1, @BaseDate, @BaseDate),
	(1, 'James', 'Andrew', 'Taylor', 'DevOps Central', 'james.taylor@devopscentral.example', NULL, 'DevOps engineer and automation specialist', 1, @BaseDate, @BaseDate),
	(1, 'Patricia', NULL, 'Anderson', 'QA Masters', 'patricia.anderson@qamasters.example', 'www.qamasters.example', 'Quality assurance lead', 1, @BaseDate, @BaseDate),
	(1, 'Christopher', 'Lee', 'Thomas', 'Code Craft Ltd', 'chris.thomas@codecraft.example', 'www.codecraft.example', 'Software engineering manager', 1, @BaseDate, @BaseDate),
	(2, 'Amanda', 'Grace', 'Jackson', 'TechStart Inc', 'amanda.jackson@techstart.example', 'www.techstart.example', 'Startup CTO and technical co-founder', 1, @BaseDate, @BaseDate),
	(2, 'Daniel', NULL, 'White', 'Innovation Labs', 'daniel.white@innovationlabs.example', NULL, 'R&D director focusing on emerging tech', 1, @BaseDate, @BaseDate),
	(2, 'Michelle', 'Lynn', 'Harris', 'Digital Edge', 'michelle.harris@digitaledge.example', 'www.digitaledge.example', 'Digital transformation consultant', 1, @BaseDate, @BaseDate),
	(2, 'Matthew', 'Scott', 'Martin', 'Smart Systems', 'matthew.martin@smartsystems.example', 'www.smartsystems.example', 'IoT solutions architect', 1, @BaseDate, @BaseDate),
	(2, 'Nancy', NULL, 'Thompson', 'AI Ventures', 'nancy.thompson@aiventures.example', 'www.aiventures.example', 'Machine learning engineer', 1, @BaseDate, @BaseDate),
	(2, 'Kevin', 'Paul', 'Garcia', 'Blockchain Solutions', 'kevin.garcia@blockchainsol.example', NULL, 'Blockchain developer and consultant', 1, @BaseDate, @BaseDate),
	(2, 'Karen', 'Elizabeth', 'Martinez', 'UX Design Studio', 'karen.martinez@uxstudio.example', 'www.uxstudio.example', 'Senior UX/UI designer', 1, @BaseDate, @BaseDate),
	(2, 'Steven', NULL, 'Robinson', 'Agile Coaches Inc', 'steven.robinson@agilecoaches.example', 'www.agilecoaches.example', 'Certified Scrum Master and Agile coach', 1, @BaseDate, @BaseDate),
	(2, 'Betty', 'Ann', 'Clark', 'Product Vision', 'betty.clark@productvision.example', NULL, 'Product manager with extensive tech background', 1, @BaseDate, @BaseDate),
	(2, 'Brian', 'Thomas', 'Rodriguez', 'Tech Recruiters Pro', 'brian.rodriguez@techrecruit.example', 'www.techrecruit.example', 'Technical recruitment specialist', 1, @BaseDate, @BaseDate),
	(1, 'Helen', NULL, 'Lewis', 'Network Ninjas', 'helen.lewis@networkninjas.example', 'www.networkninjas.example', 'Network infrastructure specialist', 1, @BaseDate, @BaseDate),
	(1, 'Jason', 'Michael', 'Lee', 'Database Dynamics', 'jason.lee@dbdynamics.example', NULL, 'Database administrator and architect', 1, @BaseDate, @BaseDate),
	(1, 'Carol', 'Jean', 'Walker', 'Systems Integration Co', 'carol.walker@sysintegration.example', 'www.sysintegration.example', 'Systems integration consultant', 1, @BaseDate, @BaseDate),
	(1, 'Ryan', NULL, 'Hall', 'Performance Tuning LLC', 'ryan.hall@perftuning.example', 'www.perftuning.example', 'Performance optimization expert', 1, @BaseDate, @BaseDate),
	(1, 'Sharon', 'Marie', 'Allen', 'API Gateway Inc', 'sharon.allen@apigateway.example', NULL, 'API design and integration specialist', 1, @BaseDate, @BaseDate),

	-- Healthcare Sector (26-50)
	(1, 'Dr. William', 'Edward', 'Young', 'City General Hospital', 'dr.young@cityhospital.example', 'www.cityhospital.example', 'Chief of cardiology', 1, @BaseDate, @BaseDate),
	(1, 'Dr. Barbara', NULL, 'King', 'MedCare Clinic', 'dr.king@medcare.example', 'www.medcare.example', 'Family medicine practitioner', 1, @BaseDate, @BaseDate),
	(1, 'Dr. Richard', 'Charles', 'Wright', 'Surgical Associates', 'dr.wright@surgicalassoc.example', NULL, 'Orthopedic surgeon', 1, @BaseDate, @BaseDate),
	(1, 'Jessica', 'Nicole', 'Lopez', 'Health Systems Inc', 'jessica.lopez@healthsys.example', 'www.healthsys.example', 'Healthcare IT administrator', 1, @BaseDate, @BaseDate),
	(1, 'Dr. Susan', 'Marie', 'Hill', 'Pediatric Partners', 'dr.hill@pedpartners.example', 'www.pedpartners.example', 'Pediatrician specializing in adolescent care', 1, @BaseDate, @BaseDate),
	(3, 'George', NULL, 'Scott', 'Medical Equipment Co', 'george.scott@medequip.example', 'www.medequip.example', 'Medical device sales representative', 1, @BaseDate, @BaseDate),
	(3, 'Dr. Dorothy', 'Ann', 'Green', 'Wellness Center', 'dr.green@wellness.example', NULL, 'Integrative medicine specialist', 1, @BaseDate, @BaseDate),
	(3, 'Donald', 'James', 'Adams', 'PharmaTech Solutions', 'donald.adams@pharmatech.example', 'www.pharmatech.example', 'Pharmaceutical sales manager', 1, @BaseDate, @BaseDate),
	(3, 'Dr. Sandra', NULL, 'Baker', 'Radiology Group', 'dr.baker@radiologygroup.example', 'www.radiologygroup.example', 'Diagnostic radiologist', 1, @BaseDate, @BaseDate),
	(3, 'Mark', 'Anthony', 'Gonzalez', 'Health Insurance Partners', 'mark.gonzalez@healthinsure.example', NULL, 'Healthcare insurance consultant', 1, @BaseDate, @BaseDate),
	(3, 'Dr. Maria', 'Elena', 'Nelson', 'Dermatology Clinic', 'dr.nelson@dermclinic.example', 'www.dermclinic.example', 'Board-certified dermatologist', 1, @BaseDate, @BaseDate),
	(3, 'Paul', NULL, 'Carter', 'Lab Services Inc', 'paul.carter@labservices.example', 'www.labservices.example', 'Clinical laboratory director', 1, @BaseDate, @BaseDate),
	(3, 'Dr. Ruth', 'Marie', 'Mitchell', 'Mental Health Associates', 'dr.mitchell@mentalhealth.example', NULL, 'Clinical psychologist', 1, @BaseDate, @BaseDate),
	(3, 'Timothy', 'John', 'Perez', 'Physical Therapy Center', 'tim.perez@ptcenter.example', 'www.ptcenter.example', 'Physical therapist and rehabilitation specialist', 1, @BaseDate, @BaseDate),
	(3, 'Angela', NULL, 'Roberts', 'Nursing Staff Solutions', 'angela.roberts@nursingstaf.example', 'www.nursingstaf.example', 'Registered nurse and staffing coordinator', 1, @BaseDate, @BaseDate),
	(1, 'Dr. Frank', 'William', 'Turner', 'Dental Excellence', 'dr.turner@dentalexcel.example', 'www.dentalexcel.example', 'Cosmetic dentistry specialist', 1, @BaseDate, @BaseDate),
	(1, 'Rebecca', 'Lynn', 'Phillips', 'Vision Care Center', 'rebecca.phillips@visioncare.example', NULL, 'Optometrist', 1, @BaseDate, @BaseDate),
	(1, 'Dr. Larry', NULL, 'Campbell', 'Emergency Medicine Group', 'dr.campbell@emermed.example', 'www.emermed.example', 'Emergency room physician', 1, @BaseDate, @BaseDate),
	(1, 'Deborah', 'Jane', 'Parker', 'Home Health Services', 'deborah.parker@homehealthsvc.example', 'www.homehealthsvc.example', 'Home healthcare coordinator', 1, @BaseDate, @BaseDate),
	(1, 'Dr. Jeffrey', 'Alan', 'Evans', 'Oncology Center', 'dr.evans@oncologyctr.example', NULL, 'Medical oncologist', 1, @BaseDate, @BaseDate),
	(1, 'Stephanie', NULL, 'Edwards', 'Healthcare Analytics', 'stephanie.edwards@healthanalytics.example', 'www.healthanalytics.example', 'Healthcare data analyst', 1, @BaseDate, @BaseDate),
	(1, 'Eric', 'Scott', 'Collins', 'Medical Billing Inc', 'eric.collins@medbilling.example', 'www.medbilling.example', 'Medical billing specialist', 1, @BaseDate, @BaseDate),
	(1, 'Kathleen', 'Rose', 'Stewart', 'Nutrition Consultants', 'kathleen.stewart@nutritionconsult.example', NULL, 'Registered dietitian', 1, @BaseDate, @BaseDate),
	(1, 'Gregory', NULL, 'Sanchez', 'Ambulance Services', 'gregory.sanchez@ambulance.example', 'www.ambulance.example', 'Paramedic and EMT trainer', 1, @BaseDate, @BaseDate),
	(1, 'Christine', 'Marie', 'Morris', 'Hospital Administration', 'christine.morris@hospadmin.example', 'www.hospadmin.example', 'Healthcare administrator', 1, @BaseDate, @BaseDate),

	-- Finance and Legal (51-70)
	(2, 'Raymond', 'Michael', 'Rogers', 'First Financial Group', 'raymond.rogers@firstfin.example', 'www.firstfin.example', 'Financial advisor and wealth manager', 1, @BaseDate, @BaseDate),
	(2, 'Janet', NULL, 'Reed', 'Legal Eagles LLC', 'janet.reed@legaleagles.example', 'www.legaleagles.example', 'Corporate attorney', 1, @BaseDate, @BaseDate),
	(2, 'Gary', 'Edward', 'Cook', 'Investment Partners', 'gary.cook@investpartners.example', NULL, 'Investment portfolio manager', 1, @BaseDate, @BaseDate),
	(2, 'Diane', 'Lynn', 'Morgan', 'Tax Advisors Inc', 'diane.morgan@taxadvisors.example', 'www.taxadvisors.example', 'Certified public accountant', 1, @BaseDate, @BaseDate),
	(2, 'Harold', NULL, 'Bell', 'Insurance Brokers Co', 'harold.bell@insurebrokers.example', 'www.insurebrokers.example', 'Commercial insurance broker', 1, @BaseDate, @BaseDate),
	(2, 'Virginia', 'Marie', 'Murphy', 'Bankruptcy Solutions', 'virginia.murphy@bankruptcysol.example', NULL, 'Bankruptcy attorney', 1, @BaseDate, @BaseDate),
	(2, 'Dennis', 'James', 'Bailey', 'Real Estate Law', 'dennis.bailey@realestatelaw.example', 'www.realestatelaw.example', 'Real estate attorney', 1, @BaseDate, @BaseDate),
	(2, 'Catherine', NULL, 'Rivera', 'Audit Services LLC', 'catherine.rivera@auditservices.example', 'www.auditservices.example', 'Internal auditor', 1, @BaseDate, @BaseDate),
	(2, 'Peter', 'Anthony', 'Cooper', 'Estate Planning Group', 'peter.cooper@estateplanning.example', NULL, 'Estate planning attorney', 1, @BaseDate, @BaseDate),
	(2, 'Frances', 'Elizabeth', 'Richardson', 'Family Law Associates', 'frances.richardson@familylaw.example', 'www.familylaw.example', 'Family law attorney', 1, @BaseDate, @BaseDate),
	(3, 'Albert', NULL, 'Cox', 'Securities Trading', 'albert.cox@sectrading.example', 'www.sectrading.example', 'Securities trader', 1, @BaseDate, @BaseDate),
	(3, 'Katherine', 'Ann', 'Howard', 'Litigation Partners', 'katherine.howard@litigationp.example', NULL, 'Trial attorney', 1, @BaseDate, @BaseDate),
	(3, 'Douglas', 'William', 'Ward', 'Mortgage Solutions', 'douglas.ward@mortgagesol.example', 'www.mortgagesol.example', 'Mortgage loan officer', 1, @BaseDate, @BaseDate),
	(3, 'Gloria', NULL, 'Torres', 'Contract Law Firm', 'gloria.torres@contractlaw.example', 'www.contractlaw.example', 'Contract law specialist', 1, @BaseDate, @BaseDate),
	(3, 'Arthur', 'Joseph', 'Peterson', 'Credit Union Services', 'arthur.peterson@creditunion.example', NULL, 'Credit union manager', 1, @BaseDate, @BaseDate),
	(3, 'Teresa', 'Marie', 'Gray', 'Patent Law Group', 'teresa.gray@patentlaw.example', 'www.patentlaw.example', 'Patent attorney', 1, @BaseDate, @BaseDate),
	(3, 'Gerald', NULL, 'Ramirez', 'Accounting Associates', 'gerald.ramirez@accountingassoc.example', 'www.accountingassoc.example', 'Forensic accountant', 1, @BaseDate, @BaseDate),
	(3, 'Janice', 'Lynn', 'James', 'Immigration Law', 'janice.james@immigrationlaw.example', NULL, 'Immigration attorney', 1, @BaseDate, @BaseDate),
	(3, 'Walter', 'Charles', 'Watson', 'Financial Planning LLC', 'walter.watson@finplan.example', 'www.finplan.example', 'Certified financial planner', 1, @BaseDate, @BaseDate),
	(3, 'Judith', NULL, 'Brooks', 'Employment Law Firm', 'judith.brooks@employmentlaw.example', 'www.employmentlaw.example', 'Employment law attorney', 1, @BaseDate, @BaseDate),

	-- Education and Non-Profit (71-85)
	(1, 'Henry', 'Thomas', 'Kelly', 'University of Science', 'henry.kelly@unisci.example', 'www.unisci.example', 'Computer science professor', 1, @BaseDate, @BaseDate),
	(1, 'Joyce', NULL, 'Sanders', 'Community College', 'joyce.sanders@commcollege.example', 'www.commcollege.example', 'Mathematics instructor', 1, @BaseDate, @BaseDate),
	(1, 'Carl', 'David', 'Price', 'Education Foundation', 'carl.price@edufoundation.example', 'www.edufoundation.example', 'Non-profit director', 1, @BaseDate, @BaseDate),
	(1, 'Carolyn', 'Ann', 'Bennett', 'Charter School Network', 'carolyn.bennett@charterschool.example', NULL, 'School principal', 1, @BaseDate, @BaseDate),
	(1, 'Russell', NULL, 'Wood', 'Library Services', 'russell.wood@library.example', 'www.library.example', 'Head librarian', 1, @BaseDate, @BaseDate),
	(1, 'Rachel', 'Marie', 'Barnes', 'Youth Programs Inc', 'rachel.barnes@youthprograms.example', 'www.youthprograms.example', 'Youth program coordinator', 1, @BaseDate, @BaseDate),
	(1, 'Eugene', 'James', 'Ross', 'Science Museum', 'eugene.ross@sciencemuseum.example', NULL, 'Museum curator', 1, @BaseDate, @BaseDate),
	(1, 'Evelyn', NULL, 'Henderson', 'Adult Education Center', 'evelyn.henderson@adulted.example', 'www.adulted.example', 'Adult education instructor', 1, @BaseDate, @BaseDate),
	(1, 'Willie', 'Lee', 'Coleman', 'Sports Academy', 'willie.coleman@sportsacademy.example', 'www.sportsacademy.example', 'Athletic director', 1, @BaseDate, @BaseDate),
	(1, 'Donna', 'Lynn', 'Jenkins', 'Arts Foundation', 'donna.jenkins@artsfoundation.example', NULL, 'Arts program director', 1, @BaseDate, @BaseDate),
	(2, 'Billy', NULL, 'Perry', 'Student Services', 'billy.perry@studentservices.example', 'www.studentservices.example', 'Student counselor', 1, @BaseDate, @BaseDate),
	(2, 'Marilyn', 'Rose', 'Powell', 'Environmental Alliance', 'marilyn.powell@envalliance.example', 'www.envalliance.example', 'Environmental advocate', 1, @BaseDate, @BaseDate),
	(2, 'Howard', 'Michael', 'Long', 'Scholarship Fund', 'howard.long@scholarship.example', NULL, 'Scholarship coordinator', 1, @BaseDate, @BaseDate),
	(2, 'Annie', NULL, 'Patterson', 'Community Outreach', 'annie.patterson@outreach.example', 'www.outreach.example', 'Community outreach director', 1, @BaseDate, @BaseDate),
	(2, 'Roy', 'Edward', 'Hughes', 'Research Institute', 'roy.hughes@research.example', 'www.research.example', 'Research scientist', 1, @BaseDate, @BaseDate),

	-- Retail and Service (86-100)
	(2, 'Louis', NULL, 'Flores', 'Retail Solutions Inc', 'louis.flores@retailsol.example', 'www.retailsol.example', 'Retail operations manager', 1, @BaseDate, @BaseDate),
	(2, 'Norma', 'Jean', 'Washington', 'Restaurant Group', 'norma.washington@restaurantgrp.example', NULL, 'Restaurant owner and chef', 1, @BaseDate, @BaseDate),
	(2, 'Carlos', 'Antonio', 'Butler', 'Auto Repair Services', 'carlos.butler@autorepair.example', 'www.autorepair.example', 'Master automotive technician', 1, @BaseDate, @BaseDate),
	(2, 'Ruby', NULL, 'Simmons', 'Beauty Salon Chain', 'ruby.simmons@beautysalon.example', 'www.beautysalon.example', 'Salon owner and stylist', 1, @BaseDate, @BaseDate),
	(2, 'Joe', 'Michael', 'Foster', 'Construction Company', 'joe.foster@construction.example', NULL, 'General contractor', 1, @BaseDate, @BaseDate),
	(3, 'Irene', 'Marie', 'Gonzales', 'Catering Services', 'irene.gonzales@catering.example', 'www.catering.example', 'Catering manager', 1, @BaseDate, @BaseDate),
	(3, 'Johnny', NULL, 'Bryant', 'Landscaping Pro', 'johnny.bryant@landscaping.example', 'www.landscaping.example', 'Landscape architect', 1, @BaseDate, @BaseDate),
	(3, 'Phyllis', 'Ann', 'Alexander', 'Interior Design Studio', 'phyllis.alexander@interiordesign.example', NULL, 'Interior designer', 1, @BaseDate, @BaseDate),
	(3, 'Earl', 'James', 'Russell', 'HVAC Services', 'earl.russell@hvacservices.example', 'www.hvacservices.example', 'HVAC technician and installer', 1, @BaseDate, @BaseDate),
	(3, 'Doris', NULL, 'Griffin', 'Event Planning Co', 'doris.griffin@eventplanning.example', 'www.eventplanning.example', 'Event planner and coordinator', 1, @BaseDate, @BaseDate),
	(3, 'Randy', 'Lee', 'Diaz', 'Fitness Center', 'randy.diaz@fitnesscenter.example', NULL, 'Personal trainer and gym owner', 1, @BaseDate, @BaseDate),
	(3, 'Lillian', 'Marie', 'Hayes', 'Travel Agency', 'lillian.hayes@travelagency.example', 'www.travelagency.example', 'Travel agent and consultant', 1, @BaseDate, @BaseDate),
	(3, 'Jesse', NULL, 'Myers', 'Security Services', 'jesse.myers@securitysvc.example', 'www.securitysvc.example', 'Security consultant', 1, @BaseDate, @BaseDate),
	(3, 'Doreen', 'Elizabeth', 'Ford', 'Pet Care Services', 'doreen.ford@petcare.example', NULL, 'Veterinary technician', 1, @BaseDate, @BaseDate),
	(3, 'Norman', 'Charles', 'Hamilton', 'Printing Services', 'norman.hamilton@printservices.example', 'www.printservices.example', 'Print shop owner', 1, @BaseDate, @BaseDate);

PRINT 'Contacts inserted successfully.';
GO

-- =============================================
-- 3. Create Contact Addresses (varied distribution)
-- =============================================
PRINT 'Inserting Contact Addresses...';

DECLARE @ContactId INT;
DECLARE @AddressDate DATETIME = GETUTCDATE();

-- Get contact IDs and insert addresses with varied distribution
DECLARE contact_cursor CURSOR FOR 
SELECT Id FROM Contact ORDER BY Id;

OPEN contact_cursor;
FETCH NEXT FROM contact_cursor INTO @ContactId;

DECLARE @Counter INT = 0;

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @Counter = @Counter + 1;

	-- 60% get 1 address, 30% get 2 addresses, 10% get 3 addresses
	IF @Counter % 10 < 6
	BEGIN
		-- Single address
		INSERT INTO ContactAddress (ContactId, Street1, Street2, City, County, State, Zip, IsActive, CreatedAt, ModifiedAt)
		VALUES (@ContactId, 
			CASE (@Counter % 20)
				WHEN 0 THEN '1234 Main Street'
				WHEN 1 THEN '5678 Oak Avenue'
				WHEN 2 THEN '9012 Elm Drive'
				WHEN 3 THEN '3456 Pine Road'
				WHEN 4 THEN '7890 Maple Lane'
				WHEN 5 THEN '2345 Cedar Boulevard'
				WHEN 6 THEN '6789 Birch Way'
				WHEN 7 THEN '1234 Willow Court'
				WHEN 8 THEN '4567 Spruce Street'
				WHEN 9 THEN '8901 Ash Avenue'
				WHEN 10 THEN '2345 Cherry Lane'
				WHEN 11 THEN '5678 Walnut Drive'
				WHEN 12 THEN '9012 Poplar Road'
				WHEN 13 THEN '3456 Hickory Way'
				WHEN 14 THEN '7890 Sycamore Court'
				WHEN 15 THEN '1234 Dogwood Street'
				WHEN 16 THEN '4567 Magnolia Avenue'
				WHEN 17 THEN '8901 Redwood Lane'
				WHEN 18 THEN '2345 Sequoia Drive'
				ELSE '6789 Cypress Road'
			END,
			CASE (@Counter % 4) WHEN 0 THEN 'Suite ' + CAST(100 + (@Counter % 50) AS VARCHAR) ELSE NULL END,
			CASE (@Counter % 15)
				WHEN 0 THEN 'Seattle'
				WHEN 1 THEN 'Portland'
				WHEN 2 THEN 'San Francisco'
				WHEN 3 THEN 'Los Angeles'
				WHEN 4 THEN 'San Diego'
				WHEN 5 THEN 'Phoenix'
				WHEN 6 THEN 'Denver'
				WHEN 7 THEN 'Austin'
				WHEN 8 THEN 'Dallas'
				WHEN 9 THEN 'Chicago'
				WHEN 10 THEN 'New York'
				WHEN 11 THEN 'Boston'
				WHEN 12 THEN 'Miami'
				WHEN 13 THEN 'Atlanta'
				ELSE 'Charlotte'
			END,
			CASE (@Counter % 5)
				WHEN 0 THEN 'King County'
				WHEN 1 THEN 'Multnomah County'
				WHEN 2 THEN 'San Francisco County'
				WHEN 3 THEN 'Los Angeles County'
				ELSE 'Maricopa County'
			END,
			CASE (@Counter % 15)
				WHEN 0 THEN 'WA'
				WHEN 1 THEN 'OR'
				WHEN 2 THEN 'CA'
				WHEN 3 THEN 'CA'
				WHEN 4 THEN 'CA'
				WHEN 5 THEN 'AZ'
				WHEN 6 THEN 'CO'
				WHEN 7 THEN 'TX'
				WHEN 8 THEN 'TX'
				WHEN 9 THEN 'IL'
				WHEN 10 THEN 'NY'
				WHEN 11 THEN 'MA'
				WHEN 12 THEN 'FL'
				WHEN 13 THEN 'GA'
				ELSE 'NC'
			END,
			CAST((10000 + (@Counter * 137) % 90000) AS VARCHAR),
			1, @AddressDate, @AddressDate);
	END
	ELSE IF @Counter % 10 < 9
	BEGIN
		-- Two addresses (home and work)
		INSERT INTO ContactAddress (ContactId, Street1, Street2, City, County, State, Zip, IsActive, CreatedAt, ModifiedAt)
		VALUES 
			(@ContactId, CAST((@Counter * 100) AS VARCHAR) + ' Residential Lane', NULL, 'Seattle', 'King County', 'WA', CAST((98000 + @Counter % 200) AS VARCHAR), 1, @AddressDate, @AddressDate),
			(@ContactId, CAST((@Counter * 200) AS VARCHAR) + ' Commerce Street', 'Floor ' + CAST((@Counter % 10) + 1 AS VARCHAR), 'Seattle', 'King County', 'WA', CAST((98201 + @Counter % 150) AS VARCHAR), 1, @AddressDate, @AddressDate);
	END
	ELSE
	BEGIN
		-- Three addresses (home, work, and vacation/mailing)
		INSERT INTO ContactAddress (ContactId, Street1, Street2, City, County, State, Zip, IsActive, CreatedAt, ModifiedAt)
		VALUES 
			(@ContactId, CAST((@ContactId * 50) AS VARCHAR) + ' Home Avenue', NULL, 'Seattle', 'King County', 'WA', '98101', 1, @AddressDate, @AddressDate),
			(@ContactId, CAST((@ContactId * 75) AS VARCHAR) + ' Business Parkway', 'Suite 100', 'Bellevue', 'King County', 'WA', '98004', 1, @AddressDate, @AddressDate),
			(@ContactId, 'PO Box ' + CAST((@ContactId * 10) AS VARCHAR), NULL, 'Issaquah', 'King County', 'WA', '98027', 1, @AddressDate, @AddressDate);
	END

	FETCH NEXT FROM contact_cursor INTO @ContactId;
END

CLOSE contact_cursor;
DEALLOCATE contact_cursor;

PRINT 'Contact Addresses inserted successfully.';
GO

-- =============================================
-- 4. Create Contact Phones (varied distribution)
-- =============================================
PRINT 'Inserting Contact Phones...';

DECLARE @PhContactId INT;
DECLARE @PhoneDate DATETIME = GETUTCDATE();

DECLARE phone_cursor CURSOR FOR 
SELECT Id FROM Contact ORDER BY Id;

OPEN phone_cursor;
FETCH NEXT FROM phone_cursor INTO @PhContactId;

DECLARE @PhCounter INT = 0;

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @PhCounter = @PhCounter + 1;

	-- Everyone gets at least 1 phone number
	-- 50% get 1 phone, 35% get 2 phones, 15% get 3+ phones

	IF @PhCounter % 100 < 50
	BEGIN
		-- Single phone (mobile)
		INSERT INTO ContactPhone (ContactId, Number, Type, IsPrimary, IsActive, CreatedAt, ModifiedAt)
		VALUES (@PhContactId, 
			'(' + CAST(200 + (@PhCounter % 800) AS VARCHAR) + ') ' + 
			CAST(200 + ((@PhCounter * 7) % 800) AS VARCHAR) + '-' + 
			RIGHT('0000' + CAST((@PhCounter * 1234) % 10000 AS VARCHAR), 4),
			'Mobile', 1, 1, @PhoneDate, @PhoneDate);
	END
	ELSE IF @PhCounter % 100 < 85
	BEGIN
		-- Two phones (mobile primary, work secondary)
		INSERT INTO ContactPhone (ContactId, Number, Type, IsPrimary, IsActive, CreatedAt, ModifiedAt)
		VALUES 
			(@PhContactId, 
				'(' + CAST(200 + (@PhCounter % 800) AS VARCHAR) + ') ' + 
				CAST(200 + ((@PhCounter * 7) % 800) AS VARCHAR) + '-' + 
				RIGHT('0000' + CAST((@PhCounter * 1234) % 10000 AS VARCHAR), 4),
				'Mobile', 1, 1, @PhoneDate, @PhoneDate),
			(@PhContactId, 
				'(' + CAST(200 + ((@PhCounter + 50) % 800) AS VARCHAR) + ') ' + 
				CAST(200 + ((@PhCounter * 11) % 800) AS VARCHAR) + '-' + 
				RIGHT('0000' + CAST((@PhCounter * 5678) % 10000 AS VARCHAR), 4),
				'Work', 0, 1, @PhoneDate, @PhoneDate);
	END
	ELSE
	BEGIN
		-- Three or more phones (mobile, work, home)
		INSERT INTO ContactPhone (ContactId, Number, Type, IsPrimary, IsActive, CreatedAt, ModifiedAt)
		VALUES 
			(@PhContactId, 
				'(' + CAST(200 + (@PhCounter % 800) AS VARCHAR) + ') ' + 
				CAST(200 + ((@PhCounter * 7) % 800) AS VARCHAR) + '-' + 
				RIGHT('0000' + CAST((@PhCounter * 1234) % 10000 AS VARCHAR), 4),
				'Mobile', 1, 1, @PhoneDate, @PhoneDate),
			(@PhContactId, 
				'(' + CAST(200 + ((@PhCounter + 50) % 800) AS VARCHAR) + ') ' + 
				CAST(200 + ((@PhCounter * 11) % 800) AS VARCHAR) + '-' + 
				RIGHT('0000' + CAST((@PhCounter * 5678) % 10000 AS VARCHAR), 4),
				'Work', 0, 1, @PhoneDate, @PhoneDate),
			(@PhContactId, 
				'(' + CAST(200 + ((@PhCounter + 100) % 800) AS VARCHAR) + ') ' + 
				CAST(200 + ((@PhCounter * 13) % 800) AS VARCHAR) + '-' + 
				RIGHT('0000' + CAST((@PhCounter * 9012) % 10000 AS VARCHAR), 4),
				'Home', 0, 1, @PhoneDate, @PhoneDate);

		-- Some get a fax number too
		IF @PhCounter % 20 = 0
		BEGIN
			INSERT INTO ContactPhone (ContactId, Number, Type, IsPrimary, IsActive, CreatedAt, ModifiedAt)
			VALUES (@PhContactId, 
				'(' + CAST(200 + ((@PhCounter + 150) % 800) AS VARCHAR) + ') ' + 
				CAST(200 + ((@PhCounter * 17) % 800) AS VARCHAR) + '-' + 
				RIGHT('0000' + CAST((@PhCounter * 3456) % 10000 AS VARCHAR), 4),
				'Fax', 0, 1, @PhoneDate, @PhoneDate);
		END
	END

	FETCH NEXT FROM phone_cursor INTO @PhContactId;
END

CLOSE phone_cursor;
DEALLOCATE phone_cursor;

PRINT 'Contact Phones inserted successfully.';
GO

-- =============================================
-- 5. Create Contact Search Tags (varied distribution)
-- =============================================
PRINT 'Inserting Contact Search Tags...';

DECLARE @TagContactId INT;
DECLARE @TagDate DATETIME = GETUTCDATE();
DECLARE @IndustryTags TABLE (TagText VARCHAR(50));

-- Define industry/category tags
INSERT INTO @IndustryTags (TagText) VALUES 
	('Technology'), ('Healthcare'), ('Finance'), ('Legal'), ('Education'),
	('Retail'), ('Manufacturing'), ('Consulting'), ('Software'), ('Hardware'),
	('Cloud'), ('Security'), ('AI/ML'), ('Data Science'), ('DevOps'),
	('Medical'), ('Dental'), ('Pharmacy'), ('Insurance'), ('Banking'),
	('Accounting'), ('Tax'), ('Investment'), ('Real Estate'), ('Construction'),
	('Design'), ('Marketing'), ('Sales'), ('HR'), ('Operations'),
	('Management'), ('Executive'), ('Founder'), ('Director'), ('Manager'),
	('Senior'), ('Junior'), ('Lead'), ('Principal'), ('Architect'),
	('Engineer'), ('Developer'), ('Analyst'), ('Consultant'), ('Specialist'),
	('VIP'), ('Partner'), ('Client'), ('Prospect'), ('Vendor');

DECLARE tag_cursor CURSOR FOR 
SELECT Id FROM Contact ORDER BY Id;

OPEN tag_cursor;
FETCH NEXT FROM tag_cursor INTO @TagContactId;

DECLARE @TagCounter INT = 0;

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @TagCounter = @TagCounter + 1;

	-- 70% get 1-3 tags, 20% get 4-6 tags, 10% get no tags
	DECLARE @NumTags INT = CASE 
		WHEN @TagCounter % 10 = 0 THEN 0  -- 10% no tags
		WHEN @TagCounter % 10 < 8 THEN 1 + (@TagCounter % 3)  -- 70% get 1-3 tags
		ELSE 4 + (@TagCounter % 3)  -- 20% get 4-6 tags
	END;

	-- Insert tags based on contact position in list (simulate industry grouping)
	IF @NumTags > 0
	BEGIN
		-- Technology sector tags (contacts 1-25)
		IF @TagContactId <= 25
		BEGIN
			INSERT INTO ContactSearchTag (ContactId, TagText, IsActive, CreatedAt, ModifiedAt)
			SELECT TOP (@NumTags) @TagContactId, TagText, 1, @TagDate, @TagDate
			FROM @IndustryTags
			WHERE TagText IN ('Technology', 'Software', 'Cloud', 'Security', 'AI/ML', 'Data Science', 'DevOps', 'Engineer', 'Developer', 'Architect', 'VIP')
			ORDER BY NEWID();
		END
		-- Healthcare sector tags (contacts 26-50)
		ELSE IF @TagContactId <= 50
		BEGIN
			INSERT INTO ContactSearchTag (ContactId, TagText, IsActive, CreatedAt, ModifiedAt)
			SELECT TOP (@NumTags) @TagContactId, TagText, 1, @TagDate, @TagDate
			FROM @IndustryTags
			WHERE TagText IN ('Healthcare', 'Medical', 'Dental', 'Pharmacy', 'Insurance', 'Specialist', 'Director', 'Senior', 'VIP', 'Partner')
			ORDER BY NEWID();
		END
		-- Finance/Legal sector tags (contacts 51-70)
		ELSE IF @TagContactId <= 70
		BEGIN
			INSERT INTO ContactSearchTag (ContactId, TagText, IsActive, CreatedAt, ModifiedAt)
			SELECT TOP (@NumTags) @TagContactId, TagText, 1, @TagDate, @TagDate
			FROM @IndustryTags
			WHERE TagText IN ('Finance', 'Legal', 'Banking', 'Accounting', 'Tax', 'Investment', 'Real Estate', 'Consultant', 'Partner', 'VIP', 'Executive')
			ORDER BY NEWID();
		END
		-- Education/Non-Profit sector tags (contacts 71-85)
		ELSE IF @TagContactId <= 85
		BEGIN
			INSERT INTO ContactSearchTag (ContactId, TagText, IsActive, CreatedAt, ModifiedAt)
			SELECT TOP (@NumTags) @TagContactId, TagText, 1, @TagDate, @TagDate
			FROM @IndustryTags
			WHERE TagText IN ('Education', 'Consulting', 'Management', 'Director', 'Operations', 'Senior', 'Lead', 'Manager', 'Partner')
			ORDER BY NEWID();
		END
		-- Retail/Service sector tags (contacts 86-100)
		ELSE
		BEGIN
			INSERT INTO ContactSearchTag (ContactId, TagText, IsActive, CreatedAt, ModifiedAt)
			SELECT TOP (@NumTags) @TagContactId, TagText, 1, @TagDate, @TagDate
			FROM @IndustryTags
			WHERE TagText IN ('Retail', 'Manufacturing', 'Construction', 'Design', 'Marketing', 'Sales', 'Operations', 'Manager', 'Vendor', 'Client')
			ORDER BY NEWID();
		END
	END

	FETCH NEXT FROM tag_cursor INTO @TagContactId;
END

CLOSE tag_cursor;
DEALLOCATE tag_cursor;

PRINT 'Contact Search Tags inserted successfully.';
GO

-- =============================================
-- 6. Summary Statistics
-- =============================================
PRINT '';
PRINT '==============================================';
PRINT 'Sample Data Load Complete!';
PRINT '==============================================';

-- Use variables to store counts for PRINT statements
DECLARE @TenantCount INT = (SELECT COUNT(*) FROM Tenant);
DECLARE @ContactCount INT = (SELECT COUNT(*) FROM Contact);
DECLARE @AddressCount INT = (SELECT COUNT(*) FROM ContactAddress);
DECLARE @PhoneCount INT = (SELECT COUNT(*) FROM ContactPhone);
DECLARE @TagCount INT = (SELECT COUNT(*) FROM ContactSearchTag);

PRINT 'Tenants:              ' + CAST(@TenantCount AS VARCHAR);
PRINT 'Contacts:             ' + CAST(@ContactCount AS VARCHAR);
PRINT 'Contact Addresses:    ' + CAST(@AddressCount AS VARCHAR);
PRINT 'Contact Phones:       ' + CAST(@PhoneCount AS VARCHAR);
PRINT 'Contact Search Tags:  ' + CAST(@TagCount AS VARCHAR);
PRINT '==============================================';
PRINT '';

-- Show distribution examples
PRINT 'Sample Contacts with Relationships:';
SELECT TOP 5 
	c.Id,
	c.FirstName + ' ' + c.LastName AS ContactName,
	c.CompanyName,
	(SELECT COUNT(*) FROM ContactAddress WHERE ContactId = c.Id) AS AddressCount,
	(SELECT COUNT(*) FROM ContactPhone WHERE ContactId = c.Id) AS PhoneCount,
	(SELECT COUNT(*) FROM ContactSearchTag WHERE ContactId = c.Id) AS TagCount
FROM Contact c
ORDER BY c.Id;

PRINT '';
PRINT 'Script execution completed successfully.';
GO
