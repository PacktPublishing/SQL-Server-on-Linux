/* Chapter 4. Database in the Sandbox 
					SQL Source code*/


-- Check how many databases we have on our instance
SELECT name 
FROM sys.databases

--Create a new database called “University”
CREATE DATABASE University

-- Check how many databases we have now on our instance
SELECT name 
FROM sys.databases

--Changing context to "University"
USE University

--Location of database files DATA and LOG
SELECT name, physical_name
FROM sys.database_files

--Create "Students" table 
CREATE TABLE Students (
	StudentID 	int IDENTITY (1,1) PRIMARY KEY,
	LastName 	nvarchar (15) NOT NULL,
	FirstName 	nvarchar (10) NOT NULL,
	Email 		nvarchar (15) NULL,
	Phone 		nvarchar (15) NULL);

--Create "Educators" table 
CREATE TABLE Educators (
	EducatorID 	int IDENTITY (1, 1) PRIMARY KEY,
	LastName 	nvarchar (15) NOT NULL,
	FirstName 	nvarchar (10) NOT NULL,
	Title 		nvarchar (5) NULL,
	Email 		nvarchar (15) NULL);

--Create "Courses" table 
CREATE TABLE Courses (
	CourseID 	int IDENTITY (1, 1) PRIMARY KEY,
	CourseName	nvarchar (15) NOT NULL,
	Active 		bit NOT NULL);

--Create "Grades" table 
CREATE TABLE Grades (
	GradeID 	int IDENTITY (1,1) PRIMARY KEY,
	StudentID 	int NOT NULL CONSTRAINT FK_Students FOREIGN KEY REFERENCES Students (StudentID),
	CourseID 	int NOT NULL CONSTRAINT FK_Courses FOREIGN KEY REFERENCES Courses (CourseID),
	EducatorID 	int NOT NULL CONSTRAINT FK_Educators FOREIGN KEY REFERENCES Educators (EducatorID),
	Grade 		smallint NOT NULL,
	Date 		datetime NOT NULL);

--List of newly created tables in the "University" database
SELECT name,type_desc
FROM sys.objects
WHERE type = 'U'


-- Add one student into "Students" table with a single INSERT statement
INSERT INTO Students
VALUES ('Azemović','Imran','Imran@dba.ba', NULL)

--Add two new students with a single INSERT statement
INSERT INTO Students
VALUES 	('Avdić','Selver', NULL, NULL),
		('Azemović','Sara','Sara@dba','000-111-222'),
		('Mušić','Denis','Denis@dba.ba', NULL)

--Check content of table "Students"
SELECT * 
FROM Students

--Update one record and add email address
UPDATE Students
SET Email = 'Selver@dba.ba'
WHERE StudentID = 2

--Delete one record from the table
DELETE FROM Students
WHERE StudentID = 4

--Check content of table "Students"
SELECT * 
FROM Students

--Add a couple of records to the "Educators" table
INSERT INTO Educators
VALUES 	('Vejzovic','Zanin','Ph.D.',NULL),
		('Music','Denis','Ph.D.',NULL),
		('Bevanda','Vanja','Ph.D.','Vanja@dba.ba')

--Add courses
INSERT INTO Courses
VALUES 	('Programming',1),
		('Databases',1),
		('Networks',1)

--Enter one grade
INSERT INTO Grades
VALUES (1,2,3,10,GETDATE())

--Check content of the table "Grades"
SELECT * 
FROM Grades

--Add new column in to existing table definition
ALTER TABLE Educators
ADD PhoneNumber nvarchar (15) NULL

---Add new column in to existing table definition
ALTER TABLE Students
ADD UserName nvarchar (15) NOT NULL DEFAULT 'user.name' WITH VALUES

--Set UserName to Email value
UPDATE Students
SET UserName = Email

--Create new unique index
CREATE UNIQUE NONCLUSTERED INDEX UQ_user_name 
ON dbo.Students (UserName)

-- Add new students
INSERT INTO Students
(FirstName, LastName, UserName) 
VALUES 
('John','Doe','john.doe')

--Testing unique index
UPDATE Students
SET UserName = 'john.doe'
WHERE StudentID = 1

--Crete simple table
CREATE TABLE Test
(Column1 int, Column2 int)

--
DROP TABLE Test

--Create a view to show only FirtsName, LastName and Email columns from Students table 
CREATE VIEW vStudents
AS
	SELECT FirstName, LastName, Email
	FROM Students

--Testing a view
SELECT * 
FROM vStudents

--Create a stored procedure for searching purpose.
CREATE PROCEDURE usp_Student_search_byID
@StudentID int
AS
	SELECT StudentID,LastName,FirstName,Email 
	FROM Students
	WHERE StudentID = @StudentID


--Execute stored procedure
EXEC usp_Student_search_byID 1

--Create a trigger that will prevent any dropping of database objects 
CREATE TRIGGER Dropping_prevention
ON DATABASE
FOR DROP_TABLE, DROP_VIEW, DROP_PROCEDURE
AS
	PRINT 'Deleting is not permitted, this operation is logged !'
ROLLBACK

--Testing a trigger
DROP PROCEDURE usp_Student_search_byID


--Clean your sandbox
USE master
DROP DATABASE University











