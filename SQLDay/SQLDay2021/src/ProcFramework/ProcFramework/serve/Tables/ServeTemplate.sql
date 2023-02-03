CREATE TABLE [serve].[ServeTemplate]
(
	[Id]          INT            NOT NULL IDENTITY(1,1),
    [TypeId]      INT            NOT NULL,
    [Name]        NVARCHAR (50)  NOT NULL,
    [Description] NVARCHAR (50)  NULL,
    [Template]    NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_ServeTemplate] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ServeTemplate_TypeId] FOREIGN KEY ([TypeId]) REFERENCES [serve].[ServeTemplateType] ([Id])
)
