
--- Constituents with A letter without ROI

SELECT [Path]
      ,[Main Drive]
      ,[SubFolder]
      ,[Constituent]
      ,[ConstituentID]
      ,[FileName]
      ,[SubFileName]
  INTO [CFG_NMSS_QA].[dbo].[TFile_A_CASE]
  FROM [CFG_NMSS_QA].[dbo].[TFile_A]
  WHERE FileName NOT like '%ROI%'


  --- Constituents with A letter with ROI

SELECT [Path]
      ,[Main Drive]
      ,[SubFolder]
      ,[Constituent]
      ,[ConstituentID]
      ,[FileName]
      ,[SubFileName]
  INTO [CFG_NMSS_QA].[dbo].[TFile_A_ROI]
  FROM [CFG_NMSS_QA].[dbo].[TFile_A]
  WHERE FileName like '%ROI%'