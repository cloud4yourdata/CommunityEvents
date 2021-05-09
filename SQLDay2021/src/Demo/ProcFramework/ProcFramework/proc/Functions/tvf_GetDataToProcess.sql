CREATE FUNCTION [proc].[tvf_GetDataToProcess] (@etlProc INT)
RETURNS TABLE
AS
RETURN (
		SELECT TableId
			,'%%data_format%%' AS KeyName
			,DataFormat + ' ' + ISNULL(DataFormatOptions, '') AS KeyValue
		FROM [load].DataLoadLog
		WHERE EltProc = @etlProc
		
		UNION ALL
		
		SELECT TableId
			,'%%data_location%%' AS KeyName
			,DataPath AS KeyValue
		FROM [load].DataLoadLog
		WHERE EltProc = @etlProc
		)
