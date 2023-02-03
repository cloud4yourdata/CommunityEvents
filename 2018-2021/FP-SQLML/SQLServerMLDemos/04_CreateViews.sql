USE SQLML;
DROP VIEW IF EXISTS dbo.vw_iris_training;
GO

DROP VIEW IF EXISTS dbo.vw_iris_test;
GO
----
CREATE VIEW dbo.vw_iris_training
AS
SELECT [Id]
	,[Sepal.Length]
	,[Sepal.Width]
	,[Petal.Length]
	,[Petal.Width]
	,[Species]
FROM (
	SELECT TOP 35 [Id]
		,[Sepal.Length]
		,[Sepal.Width]
		,[Petal.Length]
		,[Petal.Width]
		,[Species]
	FROM [dbo].[iris_data]
	WHERE Species = 'setosa'
	ORDER BY Id
	) AS setosa

UNION ALL

SELECT [Id]
	,[Sepal.Length]
	,[Sepal.Width]
	,[Petal.Length]
	,[Petal.Width]
	,[Species]
FROM (
	SELECT TOP 35 [Id]
		,[Sepal.Length]
		,[Sepal.Width]
		,[Petal.Length]
		,[Petal.Width]
		,[Species]
	FROM [dbo].[iris_data]
	WHERE Species = 'versicolor'
	ORDER BY Id ASC
	) AS versicolor

UNION ALL

SELECT [Id]
	,[Sepal.Length]
	,[Sepal.Width]
	,[Petal.Length]
	,[Petal.Width]
	,[Species]
FROM (
	SELECT TOP 35 [Id]
		,[Sepal.Length]
		,[Sepal.Width]
		,[Petal.Length]
		,[Petal.Width]
		,[Species]
	FROM [dbo].[iris_data]
	WHERE Species = 'virginica'
	ORDER BY Id ASC
	) AS virginica;

	GO
----
CREATE VIEW dbo.vw_iris_test
AS
 SELECT  ids.[Id]
		,ids.[Sepal.Length]
		,ids.[Sepal.Width]
		,ids.[Petal.Length]
		,ids.[Petal.Width]
		,ids.[Species]
	FROM [dbo].[iris_data] AS ids
	LEFT JOIN dbo.vw_iris_training AS tds ON ids.Id = tds.Id
	WHERE tds.Id IS NULL;