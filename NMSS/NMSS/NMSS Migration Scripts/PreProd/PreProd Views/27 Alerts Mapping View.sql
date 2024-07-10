USE [CFG_NMSS_QA]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/26/2024 11:28:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






USE [CFG_NMSS_QA]
GO

/****** Object:  View [dbo].[vw_DW_SFDC_Warning__c]    Script Date: 4/19/2024 12:30:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



  
  
-- =====================================================  
-- Author:       Traction  
-- Create date:   
-- Description:   
  
-- Alter date: 2019-04-26  
-- Description: changed the ActiveFlag filter(NMSSI-226).  
--  
-- Alter date: 2019-05-21  
-- Description: changed the ActiveFlag filter(NMSSI-302).
-- ======================================================  
-- Alter date: 2019-11-216
-- Author: Vinnie Pisaniello
-- Description: DS_675 bug correction. Included existing COI warnnings.
-- ====================================================== 
  
CREATE OR ALTER View [dbo].[vw_DW_SFDC_Warning__c] AS   
  SELECT    
   XREF.SFID                        AS [Id] -- Salesforce ID
  ,  LEFT(CW.Comment,80)							 AS [Name] -- Alert Name
  ,   CW.ConstituentWarningId                        AS [Data_Warehouse_ID__c]  -- Source Warehouse_id   
  ,   CW.CreatedDate                                 AS [CreatedDate] --  datetime  
  ,   CW.UpdatedDate                                 AS [LastModifiedDate] --  datetime  
  ,   CW.ConstituentId                               AS [Source_Contact__c]  -- Source ID for look up to Contact  
  ,   CW.ActiveFlag                                  AS [Active__c] --  bit  
  ,   CW.StartDate                                   AS [Start_Date__c] --  date  
  ,   CW.EndDate                                     AS [End_Date__c] --  date  
  ,   CW.Comment                                     AS [Comment__c] --  ntext(2000)  
  FROM 
   [TommiQA1].[dbo].apfx_ConstituentWarning AS CW  WITH(NOLOCK)   
  JOIN [TommiQA1].[dbo].apfx_Entity AS E  WITH(NOLOCK)  
   ON E.EntityId = CW.ConstituentId  
  LEFT JOIN [SFINTEGRATION].dbo.XREF_DW_SFDC_Warning__c AS XREF WITH(NOLOCK)  
   ON XREF.DWID = CW.ConstituentWarningId
  LEFT JOIN [SFINTEGRATION].dbo.XREF_Contact XC on XC.DWID = e.EntityId
  LEFT JOIN [CFG_NMSS_QA].dbo.tbl_Qualified_Entity AS QE on qe.EntityId = e.EntityId
  WHERE E.EntityCategoryCode = 'I' AND XREF.SFID IS NULL
  and cw.ActiveFlag = 1
		and Comment not like 'Financial%'
		and Comment not like '%Financial Assistance%'
		and comment not like 'FinancialAssistanc%'
		and comment not like 'FInancia Assistance%'
		and Comment not like 'FA History Warning%'
		and comment not like 'Fin. Hist.%'
		and comment not like '%FA HISTORY WARNING%'
		and comment not like 'FA History%'
		and comment not like 'DFA History%'
		and comment not like ' DFA FA HISTORY%'
		and comment not like 'DFA HISTORY%'
		and comment not like ' DFA HISTORY'
		and comment not like 'HA HISTORY WARNING%'
		and comment not like 'FA FY%'
		and comment not like 'FY HISTORY%'
		and comment not like 'Test%'
		and comment not like 'PMSC provider%'
		and comment not like '%PMSC provider%'
		and comment not like 'FA app%'
		and comment not like 'DFA%'
		and comment not in ('1249','1252','1255','155148227','93013368', 'CREATED IN ERROR', 'error', 'None Provided', 'text here','x')
		and comment not like 'FA HISTORY WARNING%'
		and comment not like 'FA%'
		and comment not like 'LC%'
		and comment not like '%Sibenac%'
  AND XREF.DWID IS NOT NULL
  OR (E.EntityCategoryCode = 'I'
    and XREF.DWID IS NULL AND CW.ActiveFlag = 1 
	and xc.DWID is not null 
	)
   
 UNION
  
  SELECT    
   XREF.SFID                        AS [Id] -- Salesforce ID   
  ,   'DWUI Migration Alert'					     AS [Name] -- Alert Name
  ,   CW.ConstituentWarningId                        AS [Data_Warehouse_ID__c]  -- Source Warehouse_id   
  ,   CW.CreatedDate                                 AS [CreatedDate] --  datetime  
  ,   CW.UpdatedDate                                 AS [LastModifiedDate] --  datetime  
  ,   CW.ConstituentId                               AS [Source_Contact__c]  -- Source ID for look up to Contact  
  ,   CW.ActiveFlag                                  AS [Active__c] --  bit  
  ,   CW.StartDate                                   AS [Start_Date__c] --  date  
  ,   CW.EndDate                                     AS [End_Date__c] --  date  
  ,   CW.Comment                                     AS [Comment__c] --  ntext(2000)  
  FROM [CFG_NMSS_QA].dbo.tbl_Qualified_Entity AS QE WITH(NOLOCK)  
  JOIN [TommiQA1].[dbo].apfx_ConstituentWarning AS CW  WITH(NOLOCK)  
   ON QE.EntityId = CW.ConstituentId  
  LEFT JOIN [SFINTEGRATION].dbo.XREF_DW_SFDC_Warning__c AS XREF WITH(NOLOCK)  
   ON XREF.DWID = CW.ConstituentWarningId  
  WHERE CW.ActiveFlag = 1 
  		and Comment not like 'Financial%'
		and Comment not like '%Financial Assistance%'
		and comment not like 'FinancialAssistanc%'
		and comment not like 'FInancia Assistance%'
		and Comment not like 'FA History Warning%'
		and comment not like 'Fin. Hist.%'
		and comment not like '%FA HISTORY WARNING%'
		and comment not like 'FA History%'
		and comment not like 'DFA History%'
		and comment not like ' DFA FA HISTORY%'
		and comment not like 'DFA HISTORY%'
		and comment not like ' DFA HISTORY'
		and comment not like 'HA HISTORY WARNING%'
		and comment not like 'FA FY%'
		and comment not like 'FY HISTORY%'
		and comment not like 'Test%'
		and comment not like 'PMSC provider%'
		and comment not like '%PMSC provider%'
		and comment not like 'FA app%'
		and comment not like 'DFA%'
		and comment not in ('1249','1252','1255','155148227','93013368', 'CREATED IN ERROR', 'error', 'None Provided', 'text here','x')
		and comment not like 'FA HISTORY WARNING%'
		and comment not like 'FA%'
		and comment not like 'LC%'
		and comment not like '%Sibenac%'
  AND XREF.SFID IS NULL   
  
GO


