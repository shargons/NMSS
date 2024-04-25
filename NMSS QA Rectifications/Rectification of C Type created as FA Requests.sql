
SELECT A.DWUI_Interaction_Detail_ID__c,A.DWUI_Interaction_ID__c 
--INTO FA_Request__c_Delete
FROM FA_Request__c_Direct_Load_Result A
INNER JOIN 
NMSS_SRC.CFG_NMSS_QA.dbo.FA_Request_CType B
ON a.DWUI_Interaction_Detail_ID__c = b.DWUI_Interaction_Detail_ID__c
where Error ='Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'FA_Request__c_Delete'