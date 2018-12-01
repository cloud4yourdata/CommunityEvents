DELETE FROM dbo.Models WHERE
ModelLanguage='RevoscaleR' AND ModelName='rxDForest';

INSERT INTO dbo.Models
(ModelLanguage, ModelName,Model)
SELECT 'RevoscaleR','rxDForest', * 
FROM OPENROWSET(BULK N'd:\Repos\Cloud4YourData\Demos\4DevKatowice2018\MLRevoscale\Data\Revoscale\model.rsm', SINGLE_BLOB) rs