USE RevoScaleDb
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
               Quality
        FROM dbo.WineTest
	)
SELECT p.Quality_Pred AS QualityP
	,w.Quality
FROM PREDICT(MODEL = @model, DATA = wines AS w)   WITH (
		Quality_Pred FLOAT
		) AS p;

