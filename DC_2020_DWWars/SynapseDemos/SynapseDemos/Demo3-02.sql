WHILE 
(
    SELECT TOP 1 state_desc
    FROM sys.dm_operation_status
    WHERE 
        1=1
        AND resource_type_desc = 'Database'
        AND major_resource_id = 'MySampleDataWarehouse'
        AND operation = 'ALTER DATABASE'
    ORDER BY
        start_time DESC
) = 'IN_PROGRESS'
BEGIN
    RAISERROR('Scale operation in progress',0,0) WITH NOWAIT;
    WAITFOR DELAY '00:00:05';
END
PRINT 'Complete';