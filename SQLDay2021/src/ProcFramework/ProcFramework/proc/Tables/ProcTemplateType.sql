﻿CREATE TABLE [proc].[ProcTemplateType] (
    [Id]          INT           NOT NULL,
    [Name]        NVARCHAR (50) NOT NULL,
    [Description] NVARCHAR (255) NULL,
    CONSTRAINT [PK_ProcTemplateType] PRIMARY KEY CLUSTERED ([Id] ASC)
);

