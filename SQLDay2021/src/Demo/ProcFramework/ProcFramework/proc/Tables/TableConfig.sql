CREATE TABLE [proc].[TableConfig]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	[DatabaseConfigId] INT NOT NULL,
	[DataSetId] INT,
	[Name] VARCHAR(255),
	[Description] NVARCHAR(255),
	CONSTRAINT [PK_TableConfig] PRIMARY KEY CLUSTERED ([Id] ASC),
	CONSTRAINT [FK_TableConfig_DatabaseConfigId] FOREIGN KEY ([DatabaseConfigId]) REFERENCES [proc].[DatabaseConfig] ([Id]),
	CONSTRAINT [FK_DatabaseConfig_DataSetId] FOREIGN KEY ([DataSetId]) REFERENCES [dbo].[DataSet] ([Id])
)
GO
CREATE UNIQUE INDEX [IX_U_TableConfig_DatabaseId_Name] ON [proc].[TableConfig]([DatabaseConfigId],[Name]);