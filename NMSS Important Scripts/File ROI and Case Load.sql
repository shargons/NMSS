SELECT Filename,Folder+'\'+Filename as FilePath,SUBSTRING(Folder,PATINDEX('%[0-9]%',Folder),8) as ConstituentId
--INTO CFG_NMSS_PROD.dbo.T_ROIFiles
FROM CFG_NMSS_PROD.dbo.DFileSize
WHERE CAST([Filesize in MB] AS DECIMAL) < 40
AND FileName like '%ROI%'
ORDER BY FilePath

SELECT Filename,Folder+'\'+Filename as FilePath,SUBSTRING(Folder,PATINDEX('%[0-9]%',Folder),8) as ConstituentId
--INTO CFG_NMSS_PROD.dbo.T_CaseFiles
FROM CFG_NMSS_PROD.dbo.DFileSize
WHERE CAST([Filesize in MB] AS DECIMAL) < 40
AND FileName not like '%ROI%'
ORDER BY FilePath

select * from CFG_NMSS_PROD.dbo.DFileSize
WHERE CAST([Filesize in MB] AS DECIMAL) >= 40