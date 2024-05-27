
--DROP TABLE T_ROIFiles
SELECT Filename,Folder+'\'+Filename as FilePath,SUBSTRING(Folder,PATINDEX('%[0-9]%',Folder),8) as ConstituentId
INTO CFG_NMSS_PREPROD.dbo.T_ROIFiles
FROM CFG_NMSS_QA.dbo.TDriveFiles
WHERE CAST([Filesize in MB] AS DECIMAL) < 40
AND FileName like '%ROI%'

--DROP TABLE T_CaseFiles
SELECT Filename,Folder+'\'+Filename as FilePath,SUBSTRING(Folder,PATINDEX('%[0-9]%',Folder),8) as ConstituentId
INTO CFG_NMSS_PREPROD.dbo.T_CaseFiles
FROM CFG_NMSS_QA.dbo.TDriveFiles
WHERE CAST([Filesize in MB] AS DECIMAL) < 40
AND FileName not like '%ROI%'

