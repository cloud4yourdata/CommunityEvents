select * from iris_models
select * from iris_data
select * from Demo

select * from vw_iris_test

SELECT model
FROM dbo.iris_models
WHERE model_name = 'rxDTree'
	AND model_language = 'Python';