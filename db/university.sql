IF DB_ID('SchoolUniversityDb') IS NULL CREATE DATABASE SchoolUniversityDb; 
GO
USE SchoolUniversityDb; 
GO
IF OBJECT_ID('Departments','U') IS NULL CREATE TABLE Departments (Id INT IDENTITY(1,1) PRIMARY KEY, Name NVARCHAR(150) NOT NULL UNIQUE, Description NVARCHAR(255) NULL, CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME()); 
GO
IF OBJECT_ID('Instructors','U') IS NULL CREATE TABLE Instructors (Id INT IDENTITY(1,1) PRIMARY KEY, FirstName NVARCHAR(100) NOT NULL, LastName NVARCHAR(100) NOT NULL, Email NVARCHAR(150) NOT NULL UNIQUE, Phone NVARCHAR(50) NULL, HireDate DATE NULL, DepartmentId INT NOT NULL, IsActive BIT DEFAULT 1, CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME(), CONSTRAINT FK_Instructors_Departments FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)); 
GO
IF OBJECT_ID('Students','U') IS NULL CREATE TABLE Students (Id INT IDENTITY(1,1) PRIMARY KEY, FirstName NVARCHAR(100) NOT NULL, LastName NVARCHAR(100) NOT NULL, Email NVARCHAR(150) NOT NULL UNIQUE, Phone NVARCHAR(50) NULL, DateOfBirth DATE NULL, EnrollmentDate DATE DEFAULT CAST(SYSUTCDATETIME() AS DATE), DepartmentId INT NULL, GPA DECIMAL(3,2) NULL, IsActive BIT DEFAULT 1, CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME(), CONSTRAINT FK_Students_Departments FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)); 
GO
IF OBJECT_ID('Courses','U') IS NULL CREATE TABLE Courses (Id INT IDENTITY(1,1) PRIMARY KEY, CourseCode NVARCHAR(20) NOT NULL UNIQUE, Title NVARCHAR(255) NOT NULL, Description NVARCHAR(MAX) NULL, Credits INT NOT NULL, DepartmentId INT NOT NULL, CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME(), CONSTRAINT FK_Courses_Departments FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)); 
GO
IF OBJECT_ID('Semesters','U') IS NULL CREATE TABLE Semesters (Id INT IDENTITY(1,1) PRIMARY KEY, Name NVARCHAR(50) NOT NULL UNIQUE, StartDate DATE NOT NULL, EndDate DATE NOT NULL, CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME()); 
GO
IF OBJECT_ID('Classrooms','U') IS NULL CREATE TABLE Classrooms (Id INT IDENTITY(1,1) PRIMARY KEY, Building NVARCHAR(100) NOT NULL, RoomNumber NVARCHAR(20) NOT NULL, Capacity INT NOT NULL, CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME(), CONSTRAINT UQ_Classrooms UNIQUE (Building, RoomNumber)); 
GO
IF OBJECT_ID('CourseSections','U') IS NULL CREATE TABLE CourseSections (Id INT IDENTITY(1,1) PRIMARY KEY, CourseId INT NOT NULL, InstructorId INT NOT NULL, SemesterId INT NOT NULL, ClassroomId INT NULL, SectionNumber NVARCHAR(10) NOT NULL, Schedule NVARCHAR(100) NULL, MaxEnrollment INT DEFAULT 30, CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME(), CONSTRAINT FK_CourseSections_Courses FOREIGN KEY (CourseId) REFERENCES Courses(Id), CONSTRAINT FK_CourseSections_Instructors FOREIGN KEY (InstructorId) REFERENCES Instructors(Id), CONSTRAINT FK_CourseSections_Semesters FOREIGN KEY (SemesterId) REFERENCES Semesters(Id), CONSTRAINT FK_CourseSections_Classrooms FOREIGN KEY (ClassroomId) REFERENCES Classrooms(Id), CONSTRAINT UQ_CourseSections UNIQUE (CourseId, SemesterId, SectionNumber)); 
GO
IF OBJECT_ID('Enrollments','U') IS NULL CREATE TABLE Enrollments (Id INT IDENTITY(1,1) PRIMARY KEY, StudentId INT NOT NULL, CourseSectionId INT NOT NULL, EnrollmentDate DATETIME2 DEFAULT SYSUTCDATETIME(), Status NVARCHAR(50) DEFAULT 'Enrolled', FinalGrade NVARCHAR(5) NULL, CONSTRAINT FK_Enrollments_Students FOREIGN KEY (StudentId) REFERENCES Students(Id) ON DELETE CASCADE, CONSTRAINT FK_Enrollments_CourseSections FOREIGN KEY (CourseSectionId) REFERENCES CourseSections(Id) ON DELETE CASCADE, CONSTRAINT UQ_Enrollments UNIQUE (StudentId, CourseSectionId)); 
GO
IF OBJECT_ID('Attendance','U') IS NULL CREATE TABLE Attendance (Id INT IDENTITY(1,1) PRIMARY KEY, EnrollmentId INT NOT NULL, AttendanceDate DATE NOT NULL, Status NVARCHAR(20) NOT NULL, CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME(), CONSTRAINT FK_Attendance_Enrollments FOREIGN KEY (EnrollmentId) REFERENCES Enrollments(Id) ON DELETE CASCADE, CONSTRAINT UQ_Attendance UNIQUE (EnrollmentId, AttendanceDate)); 
GO
IF OBJECT_ID('Assignments','U') IS NULL CREATE TABLE Assignments (Id INT IDENTITY(1,1) PRIMARY KEY, CourseSectionId INT NOT NULL, Title NVARCHAR(255) NOT NULL, Description NVARCHAR(MAX) NULL, DueDate DATETIME2 NOT NULL, MaxScore DECIMAL(5,2) NOT NULL, CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME(), CONSTRAINT FK_Assignments_CourseSections FOREIGN KEY (CourseSectionId) REFERENCES CourseSections(Id) ON DELETE CASCADE); 
GO
IF OBJECT_ID('Grades','U') IS NULL CREATE TABLE Grades (Id INT IDENTITY(1,1) PRIMARY KEY, AssignmentId INT NOT NULL, StudentId INT NOT NULL, Score DECIMAL(5,2) NOT NULL, GradedDate DATETIME2 DEFAULT SYSUTCDATETIME(), Feedback NVARCHAR(500) NULL, CONSTRAINT FK_Grades_Assignments FOREIGN KEY (AssignmentId) REFERENCES Assignments(Id) ON DELETE CASCADE, CONSTRAINT FK_Grades_Students FOREIGN KEY (StudentId) REFERENCES Students(Id) ON DELETE CASCADE, CONSTRAINT UQ_Grades UNIQUE (AssignmentId, StudentId)); 
GO
IF OBJECT_ID('Advisors','U') IS NULL CREATE TABLE Advisors (Id INT IDENTITY(1,1) PRIMARY KEY, InstructorId INT NOT NULL, StudentId INT NOT NULL, AssignedDate DATETIME2 DEFAULT SYSUTCDATETIME(), CONSTRAINT FK_Advisors_Instructors FOREIGN KEY (InstructorId) REFERENCES Instructors(Id) ON DELETE CASCADE, CONSTRAINT FK_Advisors_Students FOREIGN KEY (StudentId) REFERENCES Students(Id) ON DELETE CASCADE, CONSTRAINT UQ_Advisors UNIQUE (InstructorId, StudentId)); 
GO
IF OBJECT_ID('Clubs','U') IS NULL CREATE TABLE Clubs (Id INT IDENTITY(1,1) PRIMARY KEY, Name NVARCHAR(150) NOT NULL UNIQUE, Description NVARCHAR(255) NULL, CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME()); 
GO
IF OBJECT_ID('ClubMembers','U') IS NULL CREATE TABLE ClubMembers (ClubId INT NOT NULL, StudentId INT NOT NULL, JoinedDate DATETIME2 DEFAULT SYSUTCDATETIME(), Role NVARCHAR(50) DEFAULT 'Member', PRIMARY KEY (ClubId, StudentId), CONSTRAINT FK_ClubMembers_Clubs FOREIGN KEY (ClubId) REFERENCES Clubs(Id) ON DELETE CASCADE, CONSTRAINT FK_ClubMembers_Students FOREIGN KEY (StudentId) REFERENCES Students(Id) ON DELETE CASCADE); 
GO
IF NOT EXISTS (SELECT 1 FROM Departments) INSERT INTO Departments (Name, Description) VALUES ('Computer Science','Department focusing on computing and software development'), ('Mathematics','Department dedicated to mathematical sciences'), ('Business Administration','Department for business and management studies'), ('English','Department for literature and language studies'), ('Biology','Department for life sciences'); 
GO
IF NOT EXISTS (SELECT 1 FROM Instructors) INSERT INTO Instructors (FirstName, LastName, Email, Phone, HireDate, DepartmentId) VALUES ('Alan','Turing','alan.turing@university.edu','555-1001','2015-08-15',1), ('Ada','Lovelace','ada.lovelace@university.edu','555-1002','2016-01-10',1), ('Katherine','Johnson','katherine.johnson@university.edu','555-1003','2014-03-12',2), ('Peter','Drucker','peter.drucker@university.edu','555-1004','2013-09-01',3), ('William','Shakespeare','william.shakespeare@university.edu','555-1005','2012-05-20',4); 
GO
IF NOT EXISTS (SELECT 1 FROM Students) INSERT INTO Students (FirstName, LastName, Email, Phone, DateOfBirth, DepartmentId, GPA) VALUES ('John','Doe','john.doe@student.edu','555-2001','2002-04-15',1,3.75), ('Jane','Smith','jane.smith@student.edu','555-2002','2001-09-21',1,3.90), ('Michael','Brown','michael.brown@student.edu','555-2003','2003-01-10',2,3.60), ('Emily','Davis','emily.davis@student.edu','555-2004','2002-12-05',3,3.80), ('Daniel','Wilson','daniel.wilson@student.edu','555-2005','2001-07-18',4,3.50), ('Sophia','Martinez','sophia.martinez@student.edu','555-2006','2003-03-22',5,3.85), ('Liam','Anderson','liam.anderson@student.edu','555-2007','2002-11-11',1,3.70), ('Olivia','Thomas','olivia.thomas@student.edu','555-2008','2001-05-30',3,3.65), ('Noah','Taylor','noah.taylor@student.edu','555-2009','2003-08-14',2,3.55), ('Ava','Moore','ava.moore@student.edu','555-2010','2002-02-27',5,3.95); 
GO
IF NOT EXISTS (SELECT 1 FROM Courses) INSERT INTO Courses (CourseCode, Title, Description, Credits, DepartmentId) VALUES ('CS101','Introduction to Computer Science','Fundamentals of computing and programming.',3,1), ('CS201','Data Structures','Study of data organization and algorithms.',3,1), ('MATH101','Calculus I','Differential and integral calculus.',4,2), ('BUS101','Principles of Management','Introduction to business management.',3,3), ('ENG101','English Literature','Survey of classic and modern literature.',3,4), ('BIO101','General Biology','Introduction to biological concepts.',4,5); 
GO
IF NOT EXISTS (SELECT 1 FROM Semesters) INSERT INTO Semesters (Name, StartDate, EndDate) VALUES ('Fall 2025','2025-08-20','2025-12-15'), ('Spring 2026','2026-01-10','2026-05-05'), ('Summer 2026','2026-06-01','2026-08-01'); 
GO
IF NOT EXISTS (SELECT 1 FROM Classrooms) INSERT INTO Classrooms (Building, RoomNumber, Capacity) VALUES ('Science Hall','101',40), ('Technology Center','202',35), ('Business Building','303',50), ('Liberal Arts','404',45), ('Biology Lab','505',30); 
GO
IF NOT EXISTS (SELECT 1 FROM CourseSections) INSERT INTO CourseSections (CourseId, InstructorId, SemesterId, ClassroomId, SectionNumber, Schedule, MaxEnrollment) VALUES (1,1,2,2,'A','Mon/Wed 09:00-10:30',30), (2,2,2,2,'A','Tue/Thu 11:00-12:30',30), (3,3,2,1,'A','Mon/Wed/Fri 10:00-11:00',40), (4,4,2,3,'A','Tue/Thu 13:00-14:30',35), (5,5,2,4,'A','Mon/Wed 14:00-15:30',30), (6,3,2,5,'A','Fri 09:00-12:00',25); 
GO
IF NOT EXISTS (SELECT 1 FROM Enrollments) INSERT INTO Enrollments (StudentId, CourseSectionId, Status, FinalGrade) VALUES (1,1,'Enrolled','A'), (2,1,'Enrolled','A'), (3,3,'Enrolled','B+'), (4,4,'Enrolled','A-'), (5,5,'Enrolled','B'), (6,6,'Enrolled','A'), (7,2,'Enrolled','B+'), (8,4,'Enrolled','A'), (9,3,'Enrolled','B'), (10,6,'Enrolled','A'); 
GO
IF NOT EXISTS (SELECT 1 FROM Assignments) INSERT INTO Assignments (CourseSectionId, Title, Description, DueDate, MaxScore) VALUES (1,'Programming Assignment 1','Basic programming exercises.',DATEADD(DAY,7,SYSUTCDATETIME()),100), (1,'Programming Assignment 2','Object-oriented programming.',DATEADD(DAY,21,SYSUTCDATETIME()),100), (2,'Data Structures Project','Implementation of linked lists.',DATEADD(DAY,30,SYSUTCDATETIME()),100), (3,'Calculus Homework','Integration problems.',DATEADD(DAY,10,SYSUTCDATETIME()),100), (4,'Management Case Study','Business analysis.',DATEADD(DAY,15,SYSUTCDATETIME()),100); 
GO
IF NOT EXISTS (SELECT 1 FROM Grades) INSERT INTO Grades (AssignmentId, StudentId, Score, Feedback) VALUES (1,1,95,'Excellent work'), (1,2,92,'Great job'), (2,1,88,'Good effort'), (3,7,90,'Well done'), (4,3,85,'Solid understanding'), (5,4,93,'Outstanding analysis'); 
GO
IF NOT EXISTS (SELECT 1 FROM Advisors) INSERT INTO Advisors (InstructorId, StudentId) VALUES (1,1), (1,2), (2,7), (3,3), (4,4), (5,5); 
GO
IF NOT EXISTS (SELECT 1 FROM Clubs) INSERT INTO Clubs (Name, Description) VALUES ('Computer Science Club','Promotes coding and technology activities'), ('Math Society','Encourages interest in mathematics'), ('Business Leaders','Networking for business students'), ('Literature Circle','Discussion of literary works'), ('Biology Association','Activities related to life sciences'); 
GO
IF NOT EXISTS (SELECT 1 FROM ClubMembers) INSERT INTO ClubMembers (ClubId, StudentId, Role) VALUES (1,1,'President'), (1,2,'Member'), (2,3,'Member'), (3,4,'Member'), (4,5,'Member'), (5,6,'Member'), (1,7,'Member'), (3,8,'Member'), (2,9,'Member'), (5,10,'Member'); 
GO