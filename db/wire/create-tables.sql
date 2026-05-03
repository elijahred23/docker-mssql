USE WireProcessingDB;
GO
CREATE TABLE WireTransactions (
    WireTransactionId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    ClientReferenceId NVARCHAR(100) NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    CurrencyCode CHAR(3) NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    Direction NVARCHAR(20) NOT NULL, -- Outbound / Inbound
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    SubmittedAt DATETIME2 NULL,
    SettledAt DATETIME2 NULL,
    RejectedAt DATETIME2 NULL
);
GO

CREATE UNIQUE INDEX IX_WireTransactions_ClientReferenceId
ON WireTransactions(ClientReferenceId);

GO
CREATE TABLE Parties (
    PartyId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    Name NVARCHAR(200) NOT NULL,
    RoutingNumber NVARCHAR(20) NOT NULL,
    AccountNumber NVARCHAR(50) NOT NULL,
    BIC NVARCHAR(20) NULL,
    AddressLine1 NVARCHAR(200) NULL,
    City NVARCHAR(100) NULL,
    State NVARCHAR(50) NULL,
    Zip NVARCHAR(20) NULL,
    Country NVARCHAR(50) NULL
);

CREATE TABLE WireTransactionParties (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    WireTransactionId UNIQUEIDENTIFIER NOT NULL,
    PartyId UNIQUEIDENTIFIER NOT NULL,
    Role NVARCHAR(50) NOT NULL, -- Debtor / Creditor / Intermediary

    CONSTRAINT FK_WTP_WireTransaction FOREIGN KEY (WireTransactionId)
        REFERENCES WireTransactions(WireTransactionId),

    CONSTRAINT FK_WTP_Party FOREIGN KEY (PartyId)
        REFERENCES Parties(PartyId)
);


Go

CREATE INDEX IX_WTP_WireTransactionId
ON WireTransactionParties(WireTransactionId);

Go


CREATE TABLE IsoMessages (
    IsoMessageId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    WireTransactionId UNIQUEIDENTIFIER NOT NULL,
    MessageType NVARCHAR(50) NOT NULL, -- pacs.008, pacs.002
    Direction NVARCHAR(20) NOT NULL,   -- Outbound / Inbound
    CorrelationId NVARCHAR(100) NOT NULL,
    MessageXml XML NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    ProcessedAt DATETIME2 NULL,

    CONSTRAINT FK_IsoMessages_WireTransaction FOREIGN KEY (WireTransactionId)
        REFERENCES WireTransactions(WireTransactionId)
);

GO
CREATE INDEX IX_IsoMessages_WireTransactionId
ON IsoMessages(WireTransactionId);

GO
CREATE INDEX IX_IsoMessages_CorrelationId
ON IsoMessages(CorrelationId);

GO
CREATE TABLE MessageQueueLogs (
    QueueLogId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    IsoMessageId UNIQUEIDENTIFIER NOT NULL,
    QueueName NVARCHAR(100) NOT NULL,
    ExchangeName NVARCHAR(100) NULL,
    RoutingKey NVARCHAR(100) NULL,
    Status NVARCHAR(50) NOT NULL, -- Published / Consumed / Failed
    ErrorMessage NVARCHAR(MAX) NULL,
    Timestamp DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_QueueLogs_IsoMessage FOREIGN KEY (IsoMessageId)
        REFERENCES IsoMessages(IsoMessageId)
);

GO

CREATE INDEX IX_MessageQueueLogs_IsoMessageId
ON MessageQueueLogs(IsoMessageId);

GO

CREATE TABLE ProcessingLogs (
    ProcessingLogId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    WireTransactionId UNIQUEIDENTIFIER NOT NULL,
    StepName NVARCHAR(100) NOT NULL,
    Status NVARCHAR(50) NOT NULL, -- Success / Failure
    Details NVARCHAR(MAX) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_ProcessingLogs_WireTransaction FOREIGN KEY (WireTransactionId)
        REFERENCES WireTransactions(WireTransactionId)
);


GO

CREATE INDEX IX_ProcessingLogs_WireTransactionId
ON ProcessingLogs(WireTransactionId);

GO

CREATE TABLE WireValidationErrors (
    ValidationErrorId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    WireTransactionId UNIQUEIDENTIFIER NOT NULL,
    ErrorCode NVARCHAR(50) NOT NULL,
    ErrorMessage NVARCHAR(500) NOT NULL,
    FieldName NVARCHAR(100) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_ValidationErrors_WireTransaction FOREIGN KEY (WireTransactionId)
        REFERENCES WireTransactions(WireTransactionId)
);

GO
CREATE INDEX IX_ValidationErrors_WireTransactionId
ON WireValidationErrors(WireTransactionId);
GO


CREATE TABLE IdempotencyKeys (
    IdempotencyKey NVARCHAR(100) NOT NULL PRIMARY KEY,
    WireTransactionId UNIQUEIDENTIFIER NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    ExpiresAt DATETIME2 NULL,

    CONSTRAINT FK_Idempotency_WireTransaction FOREIGN KEY (WireTransactionId)
        REFERENCES WireTransactions(WireTransactionId)
);
GO


CREATE TABLE WireStatusHistory (
    StatusHistoryId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    WireTransactionId UNIQUEIDENTIFIER NOT NULL,
    OldStatus NVARCHAR(50) NULL,
    NewStatus NVARCHAR(50) NOT NULL,
    ChangedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    ChangedBy NVARCHAR(100) NOT NULL,

    CONSTRAINT FK_StatusHistory_WireTransaction FOREIGN KEY (WireTransactionId)
        REFERENCES WireTransactions(WireTransactionId)
);


GO
CREATE INDEX IX_StatusHistory_WireTransactionId
ON WireStatusHistory(WireTransactionId);
GO

CREATE TABLE Accounts (
    AccountId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    AccountNumber NVARCHAR(50) NOT NULL,
    RoutingNumber NVARCHAR(20) NOT NULL,
    Balance DECIMAL(18,2) NOT NULL,
    Currency CHAR(3) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

GO
CREATE UNIQUE INDEX IX_Accounts_AccountNumber
ON Accounts(AccountNumber);
GO