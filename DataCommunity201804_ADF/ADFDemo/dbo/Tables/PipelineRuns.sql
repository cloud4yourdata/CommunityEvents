CREATE TABLE [dbo].[PipelineRuns]
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[DataFactory] VARCHAR(255),
	[Pipeline] VARCHAR(255),
	[RunId] UNIQUEIDENTIFIER,
	[TriggerType] VARCHAR(255),
	[TriggerId] VARCHAR(50),
	[ScheduledTime] DATETIME2,
	[StartTime] DATETIME2,
	[Param1] INT
)
