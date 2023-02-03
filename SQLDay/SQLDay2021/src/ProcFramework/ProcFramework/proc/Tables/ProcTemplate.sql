CREATE TABLE [proc].[ProcTemplate] (
    [Id]          INT            NOT NULL IDENTITY(1,1),
    [TypeId]      INT            NOT NULL,
    [Name]        NVARCHAR (50)  NOT NULL,
    [Description] NVARCHAR (50)  NULL,
    [Template]    NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_ProcTemplate] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProcTemplate_TypeId] FOREIGN KEY ([TypeId]) REFERENCES [proc].[ProcTemplateType] ([Id])
);

