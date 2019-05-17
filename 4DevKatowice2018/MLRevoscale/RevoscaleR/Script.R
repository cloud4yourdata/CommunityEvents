workDir <- "d:/Repos/Cloud4YourData/CommunityEvents/4DevKatowice2018/MLRevoscale/Data/Revoscale/"
outPath <- paste0(workDir,"wines.xdf")
sqlConnString <- "Driver=SQL Server; server=.; database=RevoScaleDb; Trusted_Connection = True;"

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
    dataList$ColNum <- ifelse(dataList$Color == "red", 1, 0)
    return(dataList)
}
   

wines_data <- rxDataStep(inData = wines,
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
model = rxDForest(modelFormula, data = wines_train, method = "anova")
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
rxGetComputeContext()
rxSetComputeContext(RxLocalSeq())
rxGetComputeContext()
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