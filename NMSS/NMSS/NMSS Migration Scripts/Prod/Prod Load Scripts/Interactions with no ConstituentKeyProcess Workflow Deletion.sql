SELECT A.ID
INTO Case_Delete
FROM [Case] A
INNER JOIN
Interactions_Delete B
ON A.Data_Warehouse_ID__c = b.InteractionId


DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'Case_Delete'

