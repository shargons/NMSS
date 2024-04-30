INSERT INTO TFilesC
SELECT [Source Name],REPLACE(REVERSE(SUBSTRING(REVERSE(FilePath),1,PATINDEX('%\%',REVERSE(FilePath)))),'\','') AS FileName,FilePath,FileContentBase64+FileContentBase642 as FileContentBase64 FROM [dbo].[MergedC9000]

