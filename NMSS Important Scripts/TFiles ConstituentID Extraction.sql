SELECT [FileName]
      ,[FilePath]
      ,[FileContentBase64]
	  ,substring([FilePath],PATINDEX('%[1-9]%',[FilePath]),8) AS ConstituentID
	  INTO [CFG_NMSS_QA].[dbo].[TFilesB_ConstitID]
  FROM [CFG_NMSS_QA].[dbo].[TFilesB]




