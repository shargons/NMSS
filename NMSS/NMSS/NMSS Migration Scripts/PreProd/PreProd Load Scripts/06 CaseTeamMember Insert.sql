USE [CFG_NMSS_PREPROD]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/26/2024 11:28:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


SELECT DISTINCT
 NULL AS ID
,OwnerId AS MemberID
,A.ID AS ParentID
,B.ID AS TeamRoleId
INTO CaseTeamMember_Insert
FROM [Case] A
LEFT JOIN [CaseTeamRole] B
ON B.Name = 'Owner'

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE CaseTeamMember_Insert
ALTER COLUMN ID NVARCHAR(18)

--====================================================================
--INSERTING DATA USING DBAMP - CaseTeamMember
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PREPROD','CaseTeamMember_Insert'

