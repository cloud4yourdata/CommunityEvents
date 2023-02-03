CREATE FUNCTION [proc].tvf_GetProcessingJobs (@etlProc INT)
RETURNS TABLE
AS
RETURN (
		SELECT p.TableId
			,p.DropStageStatement
			,p.CreateStageStatement
			,p.MergeStatement
		FROM [load].[DataLoadLog] AS elt
		CROSS APPLY [proc].tvf_GetProcStatements(elt.TableId,elt.EltProc) AS p
		WHERE elt.EltProc = @etlProc
		)
