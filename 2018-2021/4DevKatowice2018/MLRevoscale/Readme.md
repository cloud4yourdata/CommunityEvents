# RevoscaleR and RevoscalePy

## Enable external scripts

```sql
EXEC sp_configure  'external scripts enabled'
	RECONFIGURE WITH OVERRIDE;
EXEC sp_configure  'external scripts enabled'
```

## Data sets (wines)

The two data sets containing physicochemical and sensory characteristics of red and white variants of the Portuguese "Vinho Verde" wine were taken from [the UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Wine+Quality). These data sets are the courtesy of [Paulo Cortez](http://www3.dsi.uminho.pt/pcortez/wine/).

There are 1599 samples of red wine and 4898 samples of white wine in the data sets. Each wine sample (row) has the following characteristics (columns):

1. Fixed acidity
2. Volatile acidity
3. Citric acid
4. Residual sugar
5. Chlorides
6. Free sulfur dioxide
7. Total sulfur dioxide
8. Density
9. pH
10. Sulphates
11. Alcohol
12. Quality (score between 0 and 10)

## Load sample data into database (script:002-LoadData.sql)

```sql
TRUNCATE TABLE dbo.Wines;
INSERT INTO dbo.Wines(
	[Facidity],
	[Vacidity],
	[Citric],
	[Sugar],
	[Chlorides],
	[Fsulfur], 
    [Tsulfur],
	[Density],
	[pH],
	[Sulphates],
	[Alcohol],
	[Quality],
	[Color]
)
EXECUTE   sp_execute_external_script                      
@language = N'Python'                     
,@script = N'
import pandas as pd
localWinePath = "d:\\Repos\\Cloud4YourData\\CommunityEvents\\4DevKatowice2018\\MLRevoscale\\Data\\wines.csv"
OutputDataSet = pd.read_csv(localWinePath, sep=";")
'

SELECT COUNT(*) FROM dbo.Wines WHERE Color ='white'   
SELECT COUNT(*) FROM dbo.Wines WHERE Color ='red'  

---
TRUNCATE TABLE [dbo].[WineTrain];
INSERT INTO [dbo].[WineTrain] 
SELECT TOP 70 PERCENT 
[Id] AS [WineId],
[Facidity],
	[Vacidity],
	[Citric],
	[Sugar],
	[Chlorides],
	[Fsulfur], 
    [Tsulfur],
	[Density],
	[pH],
	[Sulphates],
	[Alcohol],
	[Quality],
	[Color]        
FROM [dbo].[Wines] WHERE [Color] ='white'       
UNION ALL
SELECT TOP 70 PERCENT 
[Id] AS [WineId],
[Facidity],
	[Vacidity],
	[Citric],
	[Sugar],
	[Chlorides],
	[Fsulfur], 
    [Tsulfur],
	[Density],
	[pH],
	[Sulphates],
	[Alcohol],
	[Quality],
	[Color]        
FROM [dbo].[Wines] WHERE [Color] ='red' 

TRUNCATE TABLE [dbo].[WineTest];
INSERT INTO [dbo].[WineTest]
SELECT 
[Id] AS [WineId],
[Facidity],
	[Vacidity],
	[Citric],
	[Sugar],
	[Chlorides],
	[Fsulfur], 
    [Tsulfur],
	[Density],
	[pH],
	[Sulphates],
	[Alcohol],
	[Quality],
	[Color]        
FROM [dbo].[Wines] WHERE [Id] NOT 
IN (SELECT [WineId] FROM [dbo].[WineTrain])

SELECT * FROM  [dbo].[WineTrain]
```

## Get information about Python (Script:001-Python.sql)

```sql
USE RevoScaleDb;
EXECUTE sp_execute_external_script 
@language = N'Python',
@script = N'
import sys
print("*************************")
print(sys.path)
print(sys.version)
print("Hello World")
print("*************************")'
```

## Start Jupyter

```bash
cd C:\\Program Files\\Microsoft SQL Server\\MSSQL14.MSSQLSERVER\\PYTHON_SERVICES\\
cd Scripts\
jupyter-notebook.exe
```

Start Jupyter (directory)

```bash
d:\
cd d:\Repos\Cloud4YourData\CommunityEvents\4DevKatowice2018\MLRevoscale\Jupyter\
```

```bash
"C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\PYTHON_SERVICES\Scripts\jupyter-notebook.exe"
```

## Open and run notebook **<u>WineSklearnTrain.ipynb</u>**

### Train and save (in database) models (Jupyter)

## Run prediction on database (script:003-PredPython.sql)

```sql
USE RevoScaleDb;
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
AND w.Quality <> ROUND(p.PredictedValue,0)
```

## Show RevoscaleR Functions (Script:004-RevoscaleR.sql)

```sql
EXEC sp_execute_external_script
@language = N'R'
,@script = N'
require(RevoScaleR)
OutputDataSet <- data.frame(ls("package:RevoScaleR"))'
WITH RESULT SETS
(( Functions NVARCHAR(200)))
```

### Prepare and save R Models (RevoscaleR Project->Script.R)

```R
workDir <- "d:/Repos/Cloud4YourData/CommunityEvents/4DevKatowice2018/MLRevoscale/Data/Revoscale/"
outPath <- paste0(workDir,"wines.xdf")
sqlConnString <- "Driver=SQL Server; server=.; 
                     database=RevoScaleDb; Trusted_Connection = True;"
sqlCC <- RxInSqlServer(connectionString = sqlConnString, numTasks = 1)
sqlQuery <-"SELECT Facidity, Vacidity, Citric, Sugar, Chlorides, 
               Fsulfur, Tsulfur, Density, pH,Sulphates, Alcohol,
               Color,
               Quality
               FROM dbo.WineTest;"
#Change Compute Context
rxSetComputeContext(sqlCC)
rxGetComputeContext()

wines_ds <- RxSqlServerData(sqlQuery = sqlQuery,
       connectionString = sqlConnString)
#rxSummary(formula = ~.,
#       data = wines_ds)
rxGetVarInfo(data = wines_ds)

#Local Compute Context
rxSetComputeContext(RxLocalParallel())
rxGetComputeContext()
wines <- rxImport(inData = wines_ds,
                  outFile = outPath,
                  overwrite = TRUE)
rxGetVarInfo(wines)


transformColor <- function(dataList) {
    dataList$ColNum <- ifelse(dataList$Color == "red",1,0)
    return(dataList)
}
   

wines_data<-rxDataStep(inData = wines,
                   #transforms = list(ColNum = ifelse(Color == "red", 1, 0)),
                   transformFunc = transformColor,
                   rowsPerRead = 250,
                   overwrite = TRUE)

wines_data <- rxDataStep(inData = wines_data,
                   varsToDrop = c("Color"),
                   overwrite = TRUE)

rxGetVarInfo(wines_data)

rxHistogram(~Quality, data = wines_data)

##Split data
outFiles <- rxSplit(inData = wines_data,
        outFilesBase = paste0(workDir, "/modelData"),
        outFileSuffixes = c("Train", "Test"),
        overwrite = TRUE,
        splitByFactor = "splitVar",
        transforms = list(
          splitVar = factor(sample(c("Train", "Test"),
                                   size = .rxNumRows,
                                   replace = TRUE,
                                   prob = c(.70, .30)),
                            levels = c("Train", "Test"))),
                            consoleOutput = TRUE
                            )

wines_train <- rxReadXdf(file = paste0(workDir, "modelData.splitVar.Train.xdf"))
wines_test <- rxReadXdf(file = paste0(workDir, "modelData.splitVar.Test.xdf"))

rxGetInfo(wines_train)
rxGetInfo(wines_test)

colNames <- colnames(wines_train)
modelFormula <- as.formula(paste("Quality ~", paste(colNames[!colNames %in% c("Quality", "splitVar")], collapse = " + ")))
modelFormula
#train model
model = rxDForest(modelFormula, data = wines_train,method = "anova")
summary(model)
#
wines_test <- rxDataStep(inData = wines_test,
                   varsToDrop = c("splitVar"),
                   overwrite = TRUE)
nrow(wines_test)
pred = rxPredict(modelObject = model,
                 data = wines_test,
                 type = "response",
                 predVarNames = "QualityPred",
                 extraVarsToWrite = c("Quality"))


head(pred$QualityPred)
library(MLmetrics)
R2_Score(pred$QualityPred, pred$Quality)

#Serialize model
rxSetComputeContext(RxLocalSeq())
model_ser <- rxSerializeModel(model, realtimeScoringOnly = TRUE)

writeBin(model_ser, paste0(workDir, "model.rsm"))

##
# Estimate a regression neural net 
res2 <- rxNeuralNet(modelFormula, data = wines_train,
     type = "regression")

scoreOut2 <- rxPredict(res2, data = wines_test,
     extraVarsToWrite = "Quality")
scoreOut2
# Plot the rating versus the score with a regression line
rxLinePlot(Quality ~ Score, type = c("r", "smooth"), data = scoreOut2)
```

## Load Model into database (script: 005-LoadModel.sql)

```mssql
DELETE FROM dbo.Models WHERE
ModelLanguage='RevoscaleR' AND ModelName='rxDForest';

INSERT INTO dbo.Models
(ModelLanguage, ModelName,Model)
SELECT 'RevoscaleR','rxDForest', * 
FROM OPENROWSET(BULK N'd:\Repos\Cloud4YourData\Demos\4DevKatowice2018\MLRevoscale\Data\Revoscale\model.rsm', SINGLE_BLOB) rs
```



## Open and run notebook <u>RevoscalePyMicrosoftML.ipynb</u>

### Train and save (in database) models (Jupyter)

## Show models

```mssql
USE RevoScaleDb;
SELECT * FROM dbo.Models
```



### Native Scoring R (Script: 006-PredRevoscaleR.sql)

```mssql
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


```

### Native Scoring Py (Script: 007-PredRevoscalePy.sql)

```mssql
USE RevoScaleDb
DECLARE @model VARBINARY(MAX);
SELECT @model = Model
FROM dbo.Models
WHERE ModelName = 'rxDTree';

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


```

## Enable Realtime Scoring

```bash
cd <SQLInstancePath>\R_SERVICES\library\RevoScaleR\rxLibs\x64\
RegisterRExt.exe /installRts /database:RevoScaleDb

```



## Realtime Scoring (Script: 007-PredRevoscalePy.sql)

```mssql
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

```

