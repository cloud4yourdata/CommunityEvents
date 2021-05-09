CREATE TABLE [dbo].[DataSource]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	[DataSourceTypeId] INT NOT NULL,
	[Name] VARCHAR(255) NOT NULL,
	[Description] NVARCHAR(255) NOT NULL,
	CONSTRAINT [PK_DataSource] PRIMARY KEY CLUSTERED ([Id] ASC),
	CONSTRAINT [FK_DataSourceDataSourceTypeId] FOREIGN KEY ([DataSourceTypeId]) REFERENCES [dbo].[DataSourceType] ([Id])
);

GO
CREATE UNIQUE INDEX [IX_U_DataSource_Name] ON [dbo].[DataSource]([Name]);