USE SQLML;

DECLARE @a_value INT = 5;
DECLARE @b_value INT = 10;
DECLARE @res_value INT; 

execute sp_execute_external_script 
@language = N'Python',
@script = N'
import pandas as pd
res = a + b
OutputDataSet = pd.DataFrame([res])',
@params = N'@a INT, @b INT, @res INT OUTPUT',
@a = @a_value,
@b = @b_value,
@res = @res_value OUTPUT
with result sets (([SUM] INT))

select @res_value

GO

-- define Python script
DECLARE @sqlscript_input1 NVARCHAR(MAX);
SET @sqlscript_input1 = N'SELECT Id AS Id, Id AS Value 
					FROM Demo WHERE Id <10'
DECLARE @pscript NVARCHAR(MAX);

SET @pscript = N'
# assign SQL Server dataset to df variable
df1 = InputDataSet
print(df1)
print(type(df1))
print(df1["Id"])';

EXEC sp_execute_external_script
  @language = N'Python',
  @script = @pscript,
  @input_data_1 = @sqlscript_input1;

GO
USE SQLML;
DECLARE @sqlscript_input1 NVARCHAR(MAX);
SET @sqlscript_input1 = N'SELECT Id AS Id, Id AS Value FROM Demo WHERE Id<10'
DECLARE @pscript NVARCHAR(MAX);
SET @pscript = N'
import time
# assign SQL Server dataset to df variable
df1 = InputDataSet1
print(df1)
print(type(df1))
print(df1["Id"])
time.sleep(100)
';

EXEC sp_execute_external_script
  @language = N'Python',
  @script = @pscript,
  @input_data_1 = @sqlscript_input1,
  @input_data_1_name = N'InputDataSet1';

GO
--
USE SQLML;
DECLARE @sqlscript_input1 NVARCHAR(MAX);
SET @sqlscript_input1 = N'SELECT Id AS Id, Id AS Value FROM Demo WHERE Id<10'
DECLARE @pscript NVARCHAR(MAX);
SET @pscript = N'
import pandasaa as pd
# assign SQL Server dataset to df variable
df1 = InputDataSet1
print(df1)
print(type(df1))
#OutputDataSet
Result = pd.DataFrame (df1["Id"])';

EXEC sp_execute_external_script
  @language = N'Python',
  @script = @pscript,
  @input_data_1 = @sqlscript_input1,
  @input_data_1_name = N'InputDataSet1',  
  @output_data_1_name = N'Result'
  WITH RESULT SETS ((Id INT))