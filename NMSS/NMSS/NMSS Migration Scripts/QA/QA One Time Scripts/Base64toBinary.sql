USE [CFG_NMSS_QA]
GO

/****** Object:  UserDefinedFunction [dbo].[f_Base64ToBinary]    Script Date: 5/13/2024 8:45:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[f_Base64ToBinary](@Base64 VARCHAR(MAX))

RETURNS VARBINARY(MAX)

AS

BEGIN

    DECLARE @Bin VARBINARY(MAX)

   

    /*

        SELECT CONVERT(VARCHAR(MAX), dbo.f_Base64ToBinary('Q29udmVydGluZyB0aGlzIHRleHQgdG8gQmFzZTY0Li4u'))

    */

   

    SET @Bin = CAST(N'' AS XML).value('xs:base64Binary(sql:variable("@Base64"))', 'VARBINARY(MAX)')

 

    RETURN @Bin

END
GO


