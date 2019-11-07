USE SQLML

DECLARE @sqlscript_testdata NVARCHAR(MAX);

SET @sqlscript_testdata = N'SELECT [Sepal.Length]
	,[Sepal.Width]
	,[Petal.Length]
	,[Petal.Width]
	,[Species] FROM vw_iris_test';

USE SQLML
DECLARE @model VARBINARY(MAX);
SELECT @model = model
FROM dbo.iris_models
WHERE model_name = 'rxDTree'
	AND model_language = 'Python';

	WITH itd
AS (
	SELECT Id
		,[Sepal.Length]
		,[Sepal.Width]
		,[Petal.Length]
		,[Petal.Width]
		,[Species]
	FROM vw_iris_test
	)
SELECT p.*, CASE 
		WHEN p.setosa_Pred > 0.5
			THEN 'setosa'
		WHEN p.versicolor_Pred > 0.5
			THEN 'versicolor'
		WHEN p.virginica_Pred > 0.5
			THEN 'virginica'
		END AS Predicted
	,d.Species AS "Species.Actual"
	,d.id  
FROM PREDICT(MODEL = @model, DATA = itd AS d)   WITH (
		setosa_Pred FLOAT
		,versicolor_Pred FLOAT
		,virginica_Pred FLOAT

		) AS p;

----R

GO

DECLARE @model VARBINARY(MAX);

SELECT @model = model
FROM dbo.iris_models
WHERE model_name = 'rxDTree'
	AND model_language = 'R';

WITH itd
AS (
	SELECT Id
		,[Sepal.Length]
		,[Sepal.Width]
		,[Petal.Length]
		,[Petal.Width]
		,[Species]
	FROM vw_iris_test
	)
SELECT p.*, CASE 
		WHEN p.setosa_Pred > 0.5
			THEN 'setosa'
		WHEN p.versicolor_Pred > 0.5
			THEN 'versicolor'
		WHEN p.virginica_Pred > 0.5
			THEN 'virginica'
		END AS Predicted
	,d.Species AS "Species.Actual"
	,d.id  
FROM PREDICT(MODEL = @model, DATA = itd AS d)   WITH (
		setosa_Pred FLOAT
		,versicolor_Pred FLOAT
		,virginica_Pred FLOAT

		) AS p;