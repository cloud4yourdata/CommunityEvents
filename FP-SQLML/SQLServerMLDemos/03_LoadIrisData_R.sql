USE SQLML;

INSERT INTO iris_data (
	"Sepal.Length"
	,"Sepal.Width"
	,"Petal.Length"
	,"Petal.Width"
	,"Species"
	) 
	EXECUTE   sp_execute_external_script                      
	 @language = N'R'                     
	,@script = N'iris_data <- iris;'                                          
	,@output_data_1_name = N'iris_data';
GO

select * from iris_data
--truncate table iris_data