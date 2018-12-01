# R reducer UDO definition
df <- data.frame(Columns = character(), stringsAsFactors = FALSE)
df[nrow(df) + 1,] = c(paste(colnames(inputFromUSQL), collapse = '|'))
outputToUSQL <- df