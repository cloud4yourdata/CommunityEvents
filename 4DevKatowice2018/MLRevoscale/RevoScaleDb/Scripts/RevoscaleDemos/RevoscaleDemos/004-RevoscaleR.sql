EXEC sp_execute_external_script
@language = N'R'
,@script = N'
require(RevoScaleR)
OutputDataSet <- data.frame(ls("package:RevoScaleR"))'
WITH RESULT SETS
(( Functions NVARCHAR(200)))