# ADF - Azure SQL Manage Identity

Set Active Directory admin (Azure SQL)

Login using Active Directory Account

Create User 

```mssql
CREATE USER [adflabdemos] FOR EXTERNAL PROVIDER;
```

Add user to role

```mssql
ALTER ROLE [db_owner] ADD MEMBER [adflabdemos];
```





