IF DB_ID('AffirmationsDb') IS NULL CREATE DATABASE AffirmationsDb; 
GO
USE AffirmationsDb; 
GO
IF OBJECT_ID('Permissions','U') IS NULL
CREATE TABLE Permissions (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL,
    CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME()
);
GO
IF OBJECT_ID('UserPermissions','U') IS NULL
CREATE TABLE UserPermissions (
    UserId INT NOT NULL,
    PermissionId INT NOT NULL,
    CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME(),

    PRIMARY KEY (UserId, PermissionId),

    CONSTRAINT FK_UserPermissions_Permissions
        FOREIGN KEY (PermissionId) REFERENCES Permissions(Id)
);
GO
INSERT INTO Permissions (Name, Description)
VALUES 
('Affirmations.Create', 'Create new affirmations'),
('Affirmations.Edit', 'Edit existing affirmations'),
('Affirmations.Delete', 'Delete affirmations'),
('Affirmations.ViewAll', 'View all affirmations including others'),
('Admin.Access', 'Access admin dashboard');
GO