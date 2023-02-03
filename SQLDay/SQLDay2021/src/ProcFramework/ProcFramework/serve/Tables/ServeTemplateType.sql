CREATE TABLE [serve].[ServeTemplateType]
(
	[Id]          INT           NOT NULL,
    [Name]        NVARCHAR (50) NOT NULL,
    [Description] NVARCHAR (255) NULL,
    CONSTRAINT [PK_ServeTemplateType] PRIMARY KEY CLUSTERED ([Id] ASC)
)
