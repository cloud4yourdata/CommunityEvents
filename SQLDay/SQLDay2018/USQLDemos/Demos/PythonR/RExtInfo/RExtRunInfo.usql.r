# R reducer UDO definition
outputToUSQL <- data.frame(Par = inputFromUSQL$Par,
                           Pid = as.character(Sys.getpid()),
                           Machine = c(Sys.info()['nodename']))
