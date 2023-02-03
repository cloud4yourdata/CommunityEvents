# SQL Day 2022 Demo 5

#### Show data source (Notebook Demo004_DWH_Model)

```sql
SHOW DATABASES
```

```sql
USE dsadventureworks2019
```

```sql
SHOW TABLES
```

```sql
SELECT * FROM person_person LIMIT 100
```

```sql
DESCRIBE FORMATTED person_person
```

```sql
DROP DATABASE IF EXISTS DWHDLTDemo2 CASCADE
```

```sql
CREATE DATABASE IF NOT EXISTS DWHDLTDemo2 LOCATION 'dbfs:/mnt/datalake/analytics_zone/DWHS/DWHDLTDemo2';
```



#### Show and explain Demo_DLT_DWH_Model (SQLDay2022\DLTDWH\Demo_DLT_DWH_Model)

#### Create Delta Live Tables

##### Open Jobs->Delta Live Tables->Create Pipeline



| Product Edition                      | Advanced                                                     |
| ------------------------------------ | ------------------------------------------------------------ |
| Pipeline name                        | DWHDLTDemo2-SQLDay2022DemoOnline20220511                     |
| Notebook libraries                   | /Users/tkrawczyk@future-processing.com/SQLDay2022/DLTDWH/Demo_DLT_DWH_Model |
| Target                               | DWHDLTDemo20220511                                           |
| Storage location                     | dbfs:/mnt/datalake/analytics_zone/DWHS/DWHDLTDemo20220511    |
| Pipeline mode                        | Triggered                                                    |
| Autopilot options/Enable autoscaling | Unchecked                                                    |
| Cluster/Workers                      | 1                                                            |

##### Start pipeline

##### Start pipeline (once again)
