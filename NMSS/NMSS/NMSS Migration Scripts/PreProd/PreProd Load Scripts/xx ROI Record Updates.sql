
SELECT x.FileName,IIF(ISDATE(x.ExpiryDate)=1,CAST(x.ExpiryDate AS date) ,NULL) AS ExpiryDate
FROM 
(
SELECT Filename,
IIF(LEN(SUBSTRING(FileName,PATINDEX('%EXP%',FileName)+4,4))=4,SUBSTRING(FileName,PATINDEX('%EXP%',FileName)+4,4),NULL) +'-'+
IIF(LEN(SUBSTRING(FileName,PATINDEX('%EXP%',FileName)+9,2))=2,SUBSTRING(FileName,PATINDEX('%EXP%',FileName)+9,2),NULL) +'-'+
IIF(LEN(SUBSTRING(FileName,PATINDEX('%EXP%',FileName)+12,2))=2 AND SUBSTRING(FileName,PATINDEX('%EXP%',FileName)+12,2) like '%[0-9]%',SUBSTRING(FileName,PATINDEX('%EXP%',FileName)+9,2),'01') AS ExpiryDate
FROM [CFG_NMSS_PREPROD].[dbo].[ROIFilesA]
where FileName LIKE '%exp%'
)x