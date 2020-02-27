--Run on Master
SELECT
     db.name [Database]
,	ds.edition [Edition]
,	ds.service_objective [Service Objective]
FROM
     sys.database_service_objectives ds
JOIN
     sys.databases db ON ds.database_id = db.database_id
WHERE 
    db.name = 'devlabDW';

ALTER DATABASE devlabDW
MODIFY (SERVICE_OBJECTIVE = 'DW2000c')