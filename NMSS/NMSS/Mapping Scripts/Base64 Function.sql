use CFG_NMSS_QA;

SET ANSI_NULLS ON 
GO 
SET QUOTED_IDENTIFIER ON 
GO 
ALTER FUNCTION [dbo].[ns_txt_file_read]  
    (@os_file_name NVARCHAR(256))
   RETURNS VARBINARY(MAX)
/* Reads a text file into @text_file 
* 
* Transactions: may be in a transaction but is not affected 
* by the transaction. 
* 
* Error Handling: Errors are not trapped and are thrown to 
* the caller. 
* 
* Example: 
    declare @t varchar(max) 
    exec ns_txt_file_read 'c:\temp\SampleTextDoc.txt', @t output 
    select @t as [SampleTextDoc.txt] 
* 
* History: 
* WHEN       WHO        WHAT 
* ---------- ---------- --------------------------------------- 
* 2007-02-06 anovick    Initial coding 
**************************************************************/  
AS 
BEGIN
DECLARE @sql NVARCHAR(MAX) 
      , @parmsdeclare NVARCHAR(4000)  
	  , @text_file VARBINARY(MAX) 

SET @text_file=(select * from openrowset ( 
           bulk ''' + @os_file_name + ''' 
           ,SINGLE_BLOB) x 
           )

EXEC @sql;

RETURN @text_file
END