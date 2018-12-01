USE RevoScaleDb;
SELECT * FROM dbo.Models;

DECLARE @model VARBINARY(MAX);
SELECT @model = Model
FROM dbo.Models
WHERE ModelName = 'rxDForest'
	AND ModelLanguage = 'RevoscaleR';

WITH wines
AS (
	SELECT Facidity, Vacidity, Citric, Sugar, Chlorides, 
               Fsulfur, Tsulfur, Density, pH,Sulphates, Alcohol,
               CASE WHEN Color ='red' THEN 1 ELSE 0 END ColNum,
               Quality,Id
        FROM dbo.WineTest
	)
SELECT p.Quality_Pred AS QualityP
	,w.Quality,w.Id
FROM PREDICT(MODEL = @model, DATA = wines AS w)  
 WITH (
		Quality_Pred FLOAT
		) AS p;

