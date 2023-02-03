USE SQLML
DECLARE @irismodel varbinary(max)
SELECT @irismodel = model from iris_models
WHERE model_name = 'rxDForest';

DECLARE @score_result TABLE
(
 seqId INT IDENTITY(1,1),
 setosa_prob FLOAT,
 versicolor_prob FLOAT,
 virginica_prob FLOAT,
 Species_Pred VARCHAR(100)
);
INSERT INTO @score_result
(
    setosa_prob,
    versicolor_prob,
    virginica_prob,
    Species_Pred
)
EXEC sp_rxPredict
@model = @irismodel,
@inputData = N'SELECT * FROM vw_iris_test ORDER BY Id';

WITH TestDataSet AS
(
 SELECT ROW_NUMBER() OVER (ORDER BY Id) AS seqId,  Species FROM vw_iris_test 
)
SELECT * FROM @score_result sr
JOIN TestDataSet AS t ON t.seqId = sr.seqId 
