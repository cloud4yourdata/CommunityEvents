csvDataDir <- "d:\\AppData\\BIGDATA\\Mort\\MortSmall\\"
mortXdfFileName <- file.path(csvDataDir, "mortDefaultSmall.xdf")

## Load csv files to xdf
loadInputData <- function(inputfiles, xdffile) {
    st <- Sys.time()
    first <- TRUE
    for (input in inputfiles) {
        append <- if (first == TRUE) "none" else "rows"
        if (first == TRUE) {
            first <- FALSE
        }
        rxImport(inData = input, outFile = xdffile,
                 overwrite = TRUE, append = append)
    }
    return(Sys.time() - st)
}

#List files
dataFiles <- list.files(csvDataDir, pattern = "*.csv", full.names = TRUE)

#Load Data
totalTime <- loadInputData(dataFiles, mortXdfFileName)

mortDS <- rxReadXdf(mortXdfFileName);

#Show data
nrow(mortDS)
rxGetInfo(mortDS, numRows = 5)
rxSummary(~., data = mortDS, blocksPerRead = 2)

mortDSDefaultTrue <- rxDataStep(inData = mortDS,
    rowSelection = default == 1)

mortDSDefaultFalse <- rxDataStep(inData = mortDS,
    rowSelection = default == 0)


nrow(mortDSDefaultTrue)
nrow(mortDSDefaultFalse)

mortDSDefaultFalse10 <- rxSplit(inData = mortDSDefaultFalse,
        splitByFactor = "splitVar",
        overwrite = TRUE,
        transforms = list(
          splitVar = factor(sample(c("90", "10"),
                                   size = .rxNumRows,
                                   replace = TRUE,
                                   prob = c(.90, .10)),
                            levels = c("90", "10"))),
        rngSeed = 17,
        consoleOutput = TRUE)

rxGetInfo(mortDSDefaultFalse10, numRows = 5)

creditScore <- c(300, 700)
yearsEmploy <- c(2, 8)
ccDebt <- c(5000, 10000)
year <- c(2008, 2009)
houseAge <- c(5, 20)


predictDF <- data.frame(
        creditScore = rep(creditScore, times = 16),
        yearsEmploy = rep(rep(yearsEmploy, each = 2), times = 8),
        ccDebt = rep(rep(ccDebt, each = 4), times = 4),
        year = rep(rep(year, each = 8), times = 2),
        houseAge = rep(houseAge, each = 16))

head(predictDF)


system.time(
            logitObj <- rxLogit(default ~ F(houseAge) + F(year) +
                        creditScore + yearsEmploy + ccDebt,
                        data = mortDS, blocksPerRead = 2, reportProgress = 1))

summary(logitObj)

cc <- coef(logitObj)
df <- data.frame(Coefficient = cc[2:41], HouseAge = 0:39)
rxLinePlot(Coefficient ~ HouseAge, data = df, type = "p")



require(signal)
k = 11
inputFromUSQL$sv <- c(filter(MedianFilter(k), inputFromUSQL$v))
outputToUSQL <- data.frame(Id = inputFromUSQL$Id,
                           sv = inputFromUSQL$sv,
                           md = inputFromUSQL$md,
                           mv = inputFromUSQL$nv)