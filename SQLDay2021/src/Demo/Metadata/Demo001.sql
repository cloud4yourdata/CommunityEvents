--USE [procframework];

SELECT * FROM [proc].ProcTemplate;


SELECT t.[Name] AS TableName,
c.ColumnName,
c.DataType,
c.IsPrimaryKey,
c.IsHashPart
FROM [proc].TableConfig AS t
JOIN [proc].ColumnConfig AS c ON c.TableId = t.Id
ORDER BY t.Id;

SELECT TableId,DropStageStatement,CreateStageStatement,MergeStatement 
FROM [proc].tvf_GetProcessingJobs(2)