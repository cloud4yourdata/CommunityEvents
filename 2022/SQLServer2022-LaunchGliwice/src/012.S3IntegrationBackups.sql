USE DCSQLServer2022MeetupGliwice;

---OPEN MASTER KEY 
OPEN MASTER KEY DECRYPTION BY PASSWORD = 'P@$$w0rd1234!';


--CREATE CREDENTIAL (NAME STORAGE ENDPOINT)
IF NOT EXISTS
(
	SELECT *
	FROM sys.credentials
	WHERE
		name = N's3://s3.eu-west-1.amazonaws.com/mszpot-analityka'
)
BEGIN
 CREATE  CREDENTIAL [s3://s3.eu-west-1.amazonaws.com/mszpot-analityka]
 WITH IDENTITY = 'S3 Access Key',
 SECRET = '********';
END



--CHECK CREDENTIAL
SELECT * FROM sys.credentials

--CREATE BACKUP (REMOVE EXISTING FILES OR CHANGE BACKUP NAME)
BACKUP DATABASE DataVirtualizationDemo
TO URL='s3://s3.eu-west-1.amazonaws.com/mszpot-analityka/sqlserver2022/Backups/DataVirtualizationDemo_V111.bak'

---DROP EXISTING RESTORED
IF (DB_ID('DataVirtualizationDemoRestored') IS NOT NULL)
BEGIN
	DROP DATABASE DataVirtualizationDemoRestored
END
GO

--RESTORE DATABASE FROM BACKUP S3
RESTORE DATABASE DataVirtualizationDemoRestored
FROM URL='s3://s3.eu-west-1.amazonaws.com/mszpot-analityka/sqlserver2022/Backups/DataVirtualizationDemo_V111.bak'
WITH RECOVERY,  
   MOVE 'DataVirtualizationDemo' TO 'c:\Temp\Databases\DataVirtualizationDemo.mdf',   
   MOVE 'DataVirtualizationDemo_log' TO 'c:\Temp\Databases\DataVirtualizationDemo_log.ldf';  