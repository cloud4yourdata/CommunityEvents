CREATE TABLE [proc].[ProcTemplateParm] (
    [Id]          INT            NOT NULL,
    [Name]        NVARCHAR (50)  NOT NULL,
    [Description] NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_ProcTemplateParm] PRIMARY KEY CLUSTERED ([Id] ASC)
);

