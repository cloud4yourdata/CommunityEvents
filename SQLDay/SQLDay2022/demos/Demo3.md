# SQL 2022 Demo 2

## Demo001_Hash -Databricks

#### Hash Function

```sql
select
  HASH('208860'),
  HASH('104455'),
  XXHASH64('104455'),
  XXHASH64('208860')
```

#### SHA2 Function

```sql
SELECT
  CONCAT(
    '0x',
    UPPER(
      SHA2(CONCAT_WS('||', 'SQL', 'Day', '2022', NULL), 256)
    )
  ) AS Hash,
  '0x26E988413808D03246B14575D87B8A662552A3B67D1479F81B7402F0D97BCFA0' AS SQLServerHash
```

#### HASHBYTES SQL Server (SSMS)

```sql

SELECT HASHBYTES('SHA2_256', CONCAT_WS('||','SQL','Day','2022',NULL))
```

#### Compare results