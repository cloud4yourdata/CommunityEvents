CREATE TABLE [dbo].[DataSetType]
(
	[Id]          INT           NOT NULL,
    [Name]        NVARCHAR (50) NOT NULL,
    [Description] NVARCHAR (255) NULL,
    CONSTRAINT [PK_DataSetType] PRIMARY KEY CLUSTERED ([Id] ASC)
)
