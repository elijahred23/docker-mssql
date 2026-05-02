IF DB_ID('UsersDb') IS NULL CREATE DATABASE UsersDb; 
GO
USE UsersDb; 
GO
IF OBJECT_ID('Users','U') IS NULL CREATE TABLE Users (Id INT IDENTITY(1,1) PRIMARY KEY, Username NVARCHAR(100) NOT NULL UNIQUE, Email NVARCHAR(255) NOT NULL UNIQUE, PasswordHash NVARCHAR(255) NOT NULL, IsActive BIT DEFAULT 1, CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME()); 
GO
INSERT INTO Users (Username, Email, PasswordHash, IsActive) VALUES ('elijah', 'elijah@test.com', 'test', 1), ('bob', 'bob@test.com', 'test', 1), ('charlie', 'charlie@test.com', 'test', 1), ('diana', 'diana@test.com', 'test', 1), ('edward', 'edward@test.com', 'test', 1);
GO