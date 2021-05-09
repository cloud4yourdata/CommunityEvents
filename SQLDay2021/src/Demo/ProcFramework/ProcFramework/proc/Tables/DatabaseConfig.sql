CREATE TABLE [proc].[DatabaseConfig]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	[DataSourceId] INT,
	[Name] VARCHAR(255) NOT NULL,
	[Description] NVARCHAR(255) NOT NULL,
	[Location] VARCHAR(1024) NOT NULL,
	[StageDatabaseName] VARCHAR(255) NOT NULL,
	CONSTRAINT [PK_DatabaseConfig] PRIMARY KEY CLUSTERED ([Id] ASC),
	CONSTRAINT [FK_DatabaseConfig_DataSourceId] FOREIGN KEY ([DataSourceId]) REFERENCES [dbo].[DataSource] ([Id]),
)

GO
CREATE UNIQUE INDEX [IX_U_DatabaseConfig_Name] ON [proc].[DatabaseConfig]([Name]);
