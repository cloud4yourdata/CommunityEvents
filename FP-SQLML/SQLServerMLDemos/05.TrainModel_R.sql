USE SQLML
--SELECT *
--FROM vw_iris_test

--SELECT *
--FROM vw_iris_training

---Train the model
DECLARE @sqlscript_traindata NVARCHAR(MAX);

SET @sqlscript_traindata = N'SELECT [Sepal.Length]
	,[Sepal.Width]
	,[Petal.Length]
	,[Petal.Width]
	,[Species] FROM vw_iris_training';

DECLARE @trained_model VARBINARY(max)
	,@native_trained_model VARBINARY(max);

EXECUTE sp_execute_external_script          
 @language = N'R'       
	,@script = N'
# Build decision tree model to predict species based on sepal/petal attributes
iris_model <- rxDTree(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, data = iris_rx_data);
# Serialize model to binary format for storage in SQL Server
trained_model <- as.raw(serialize(iris_model, connection=NULL));
# Serialize model to native binary format for scoring using PREDICT function in SQL Server
native_trained_model <- rxSerializeModel(iris_model, realtimeScoringOnly = TRUE)
'       
	,@input_data_1 = @sqlscript_traindata       
	,@input_data_1_name = N'iris_rx_data'       
	,@params = N'
@trained_model varbinary(max) OUTPUT, @native_trained_model varbinary(max) OUTPUT'       
	,@trained_model = @trained_model OUTPUT       
	,@native_trained_model = @native_trained_model OUTPUT;



DELETE FROM dbo.iris_models WHERE model_name ='DTree' AND model_language='R'
DELETE FROM dbo.iris_models WHERE model_name ='rxDTree' AND model_language='R'
INSERT INTO dbo.iris_models (model,model_name,model_language)
VALUES (@trained_model,'DTree','R'),
(@native_trained_model,'rxDTree','R'); 

SELECT *, DATALENGTH(model) FROM dbo.iris_models

