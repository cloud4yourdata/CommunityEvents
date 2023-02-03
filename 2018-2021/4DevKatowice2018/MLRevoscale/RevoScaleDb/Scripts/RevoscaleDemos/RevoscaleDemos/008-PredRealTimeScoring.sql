USE RevoScaleDb
DECLARE @MLmodel VARBINARY(MAX);
SELECT @MLmodel = Model
FROM dbo.Models
WHERE ModelName = 'rxDTree';
EXEC sp_rxPredict
@model = @MLmodel,
@inputData = N'SELECT Facidity, Vacidity, Citric, Sugar, Chlorides, 
               Fsulfur, Tsulfur, Density, pH,Sulphates, Alcohol,
               CASE WHEN Color =''red'' THEN 1 ELSE 0 END ColNum,
               Quality
        FROM dbo.WineTest'



SELECT * FROM Models