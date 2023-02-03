# R reducer UDO definition
# install the signal package,
install.packages('signal_0.7-6.zip', repos = NULL)
# load the signal package,
require(signal)
require(RevoScaleR)
medianFilterTransfrom <- function(dataList) {
    k = 11
    dataList$SmoothMesValue <- c(filter(MedianFilter(k), dataList$MesValue))
    return(dataList)
}

xdfFIleOnADLA = "sample_adla.xdf"
rxImport(inData = inputFromUSQL, outFile = xdfFIleOnADLA, overwrite = TRUE)


outputToUSQL <- rxDataStep(inData = xdfFIleOnADLA,
           transformFunc = medianFilterTransfrom,
           transformVars = c("MesValue"),
           transformPackages = c("signal"),
           overwrite = TRUE)