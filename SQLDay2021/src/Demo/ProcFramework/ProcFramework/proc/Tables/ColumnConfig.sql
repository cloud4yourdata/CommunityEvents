CREATE TABLE [proc].[ColumnConfig]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	[TableId] INT NOT NULL,
	[DataSetPropertyId] INT,
	[ColumnName] VARCHAR(255) NOT NULL,
	[DataType] VARCHAR(100) NOT NULL,
	[IsPrimaryKey] BIT,
	[IsHashPart] BIT ,
	CONSTRAINT [FK_ColumnConfig_TableId] FOREIGN KEY ([TableId]) REFERENCES [proc].[TableConfig] ([Id]),
	CONSTRAINT [FK_ColumnConfig_DataSetPropertyId] FOREIGN KEY ([DataSetPropertyId]) REFERENCES [dbo].[DataSetProperty] ([Id]),
)
GO
CREATE UNIQUE INDEX [IX_U_ColumnConfig_TableId_ColumnName] ON [proc].[ColumnConfig]([TableId],[ColumnName]);