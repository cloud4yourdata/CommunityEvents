CREATE TABLE [dbo].[DataSet]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	[DataSourceId] INT NOT NULL,
	[DataSetTypeId] INT NOT NULL,
	[Name] NVARCHAR(255) NOT NULL,
	[Descrition] NVARCHAR(255) NOT NULL,
	CONSTRAINT [PK_DataSet] PRIMARY KEY CLUSTERED ([Id] ASC),
	CONSTRAINT [FK_DataSet_DataSourceId] FOREIGN KEY ([DataSourceId]) REFERENCES [dbo].[DataSource] ([Id]),
	CONSTRAINT [FK_DataSet_DataSetTypeId] FOREIGN KEY ([DataSetTypeId]) REFERENCES [dbo].[DataSetType] ([Id])
);

GO
CREATE UNIQUE INDEX [IX_U_DataSet_DataSourceId_Name] ON [dbo].[DataSet]([DataSourceId],[Name]);
