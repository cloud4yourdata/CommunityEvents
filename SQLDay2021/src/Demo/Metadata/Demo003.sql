SELECT [dwh_IsCurrent]
      ,[UserId]
      ,[UserName]
      ,[UserRole]
      ,[dwh_ValidFrom]
      ,[dwh_ValidTo]
      ,[dwh_SurKey]
      ,[dwh_RowHash]
      ,[dwh_MergeKey]
  FROM [dbo].[vwUserManagedIdentity]

  SELECT [dwh_IsCurrent]
      ,[UserId]
      ,[UserName]
      ,[UserRole]
      ,[dwh_ValidFrom]
      ,[dwh_ValidTo]
      ,[dwh_SurKey]
      ,[dwh_RowHash]
      ,[dwh_MergeKey]
  FROM [dbo].[vwUserUserIdentity]