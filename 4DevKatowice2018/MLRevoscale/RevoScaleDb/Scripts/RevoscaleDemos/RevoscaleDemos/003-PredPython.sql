USE RevoScaleDb;
SELECT * FROM dbo.Models
----------------------
DECLARE @model VARBINARY(MAX);
DECLARE @sqlscript_testdata NVARCHAR(MAX);
DECLARE @Predictions TABLE
(
 Id INT,
 PredictedValue FLOAT
);
SET @sqlscript_testdata = N'SELECT 
							 Id,
							 Facidity,
							 Vacidity,
							 Citric,
							 Sugar,
							 Chlorides,
							 Fsulfur,
							 Tsulfur,
							 Density,
							 pH,
							 Sulphates,
							 Alcohol
							FROM dbo.WineTest';

SELECT @model = model
FROM dbo.Models
WHERE ModelName = 'SVR'
	AND ModelLanguage = 'Python';

INSERT INTO @Predictions(Id,PredictedValue)
EXEC sp_execute_external_script
				@language = N'Python',
				@script = N'
import pickle
import pandas as pd
model = pickle.loads(py_model)
# variable we will be predicting on.
columns = wines.columns.drop(["Id"])
target ="Quality"
df = wines
prediction_result = model.predict(df[columns])
predictions_df = pd.DataFrame(prediction_result)
OutputDataSet = pd.concat([ df["Id"],predictions_df], axis=1)
'
, @input_data_1 = @sqlscript_testdata 
, @input_data_1_name = N'wines'
, @params = N'@py_model varbinary(max)'
, @py_model = @model;

--SELECT w.Quality,PredictedValue
--  FROM @Predictions AS p
--JOIN dbo.WineTest AS w ON w.Id = p.Id
--AND w.Quality = ROUND(p.PredictedValue,0)

SELECT w.Quality,PredictedValue
  FROM @Predictions AS p
JOIN dbo.WineTest AS w ON w.Id = p.Id
--AND w.Quality <> ROUND(p.PredictedValue,0)
