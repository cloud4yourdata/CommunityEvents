CREATE PROCEDURE [dbo].[usp_AddRunInfo]
 @DataFactory VARCHAR(255),
 @Pipeline VARCHAR(255),
 @RunId UNIQUEIDENTIFIER,
 @TriggerType VARCHAR(255),
 @TriggerId VARCHAR(50),
 @ScheduledTime DATETIME2,
 @StartTime DATETIME2,
 @Param1 INT
AS
BEGIN
	INSERT INTO dbo.PipelineRuns(DataFactory,Pipeline,RunId,TriggerType,TriggerId,ScheduledTime,StartTime,Param1)
	SELECT @DataFactory,@Pipeline, @RunId, @TriggerType, @TriggerId, @ScheduledTime, @StartTime, @Param1
END
