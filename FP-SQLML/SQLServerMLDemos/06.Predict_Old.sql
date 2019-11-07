USE SQLML;
DECLARE @model VARBINARY(MAX);
DECLARE @sqlscript_testdata NVARCHAR(MAX);
DECLARE @Predictions TABLE
(
 Id INT,
 PredictedValue VARCHAR(100)
);
SET @sqlscript_testdata = N'SELECT Id, [Sepal.Length]
	,[Sepal.Width]
	,[Petal.Length]
	,[Petal.Width]
	,Species FROM vw_iris_test';

SELECT @model = model
FROM dbo.iris_models
WHERE model_name = 'SVM'
	AND model_language = 'Python';

INSERT INTO @Predictions(Id,PredictedValue)
EXEC sp_execute_external_script
				@language = N'Python',
				@script = N'
import pickle
import pandas as pd
svn_model = pickle.loads(py_model)
# variable we will be predicting on.
target = "Species"
columns = ["Sepal.Length", "Sepal.Width","Petal.Length","Petal.Width"];
df = iris_score_data
prediction_result = svn_model.predict(df[columns])
predictions_df = pd.DataFrame(prediction_result)

OutputDataSet = pd.concat([ df["Id"],predictions_df], axis=1)
'
, @input_data_1 = @sqlscript_testdata 
, @input_data_1_name = N'iris_score_data'
, @params = N'@py_model varbinary(max)'
, @py_model = @model
--with result sets ((Id INT,"Predicted" VARCHAR(100)))
;

SELECT Species,PredictedValue FROM @Predictions AS p
JOIN dbo.iris_data AS ids ON ids.Id = p.Id
--WHERE ids.Species <> p.PredictedValue