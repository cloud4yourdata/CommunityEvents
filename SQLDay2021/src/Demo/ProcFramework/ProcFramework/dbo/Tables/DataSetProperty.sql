CREATE TABLE [dbo].[DataSetProperty]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	[DataSetId] INT NOT NULL,
	[Name] VARCHAR(255),
	[DataType]  VARCHAR(255) NOT NULL,
	[DataTypePrecision] INT,
	[IsPrimayKey] BIT NOT NULL,
	[IsNullable] BIT NOT NULL,
	CONSTRAINT [PK_DataSetProperty] PRIMARY KEY CLUSTERED ([Id] ASC),
	CONSTRAINT [FK_DataSetProperty_DataSetId] FOREIGN KEY ([DataSetId]) REFERENCES [dbo].[DataSet] ([Id]),
);

GO
CREATE UNIQUE INDEX [IX_U_DataSetProperty_DataSetId_Name] ON [dbo].[DataSetProperty]([DataSetId],[Name]);
