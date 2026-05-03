IF DB_ID('UsersDb') IS NULL CREATE DATABASE UsersDb; 
GO
USE UsersDb; 
GO
IF OBJECT_ID('Users','U') IS NULL CREATE TABLE Users (Id INT IDENTITY(1,1) PRIMARY KEY, Username NVARCHAR(100) NOT NULL UNIQUE, Email NVARCHAR(255) NOT NULL UNIQUE, PasswordHash NVARCHAR(255) NOT NULL, IsActive BIT DEFAULT 1, CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME()); 
GO
INSERT INTO Users (Username, Email, PasswordHash, IsActive) VALUES ('elijah', 'elijah@test.com', 'AQAAAAIAAYagAAAAEHeyVDeJcmdBkCLLbmTetfHyEBk+ua3xSV7plYmFfvzvQas5GaejtsKhc03K/gBwOw==', 1), ('bob', 'bob@test.com', 'AQAAAAIAAYagAAAAEJOtNKMbBlnWxdfyMMpb41xpNDKbT9rpcIszfs1hxTTR896BPTPxMu8Lqvdzf5juLA==', 1), ('charlie', 'charlie@test.com', 'AQAAAAIAAYagAAAAEOS0zoooZR/V5UDfyqLvtbI+oSsqyK8kAF+HjXGDUmU0CaEPEvlPQJVqsZQg9I3ncg==', 1), ('diana', 'diana@test.com', 'AQAAAAIAAYagAAAAEIhx3NlPdHg/3P+9pDsr44jfCOqbV7w1xII9vDXkQnIy0Ra1JTsiiXSEspvLC07fKA==', 1), ('edward', 'edward@test.com', 'AQAAAAIAAYagAAAAENRJE0kLrDBgL+rTlLcTP6vNBxfmlPRdql3p/0QYNfR1aVBPr0Yjs2TMYNBJiv5P7Q==', 1);
GO