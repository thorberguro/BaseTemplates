
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP procedure if exists [<process schema>].[sp_<topic>_oN_v1_preload]
GO
CREATE procedure [<process schema>].[sp_<topic>_oN_v1_preload]
	@BatchId      int
,	@OriginId     int
,	@RowsInserted int OUTPUT
AS
-- ===================================================================================
-- Object Name: [<process schema>].[sp_<topic>_oN_v1_preload]
-- -----------------------------------------------------------------------------------
-- Company    : <company>
-- Author     : <developer>
-- Created    : <date>
-- Description: This is the preload procedure that exports the data from the indicated
--              origin into a staging table. This procedure is specific for a particular
--              origin (i.e. a source system) and knows how to extract the relevant data
--              to fulfill the datacontract of the relevant version (see name)
--
-- Change Log
-- =============
-- YYYY-MM-DD - By                 - Desc
-- ----------   ----------------   ---------------------------------------------------
-- 
-- ===================================================================================
SET NOCOUNT ON;
begin try
	

	--- REPLACE WITH ORIGIN SPECIFIC CODE ---
	Print '@BatchId: ' + cast(@BatchId as nvarchar(20))
	Print '@OriginId: ' + cast(@OriginId as nvarchar(20))
	Print '@RowsInserted set to: 234'
	
	-- Rows inserted into the staging table should be stored in @RowsInserted
	Set @RowsInserted = 12345; -- <REPLACE>

	-- RETURN AN ADDITIONAL VALUE
	return 13                  -- <REPLACE, OPTIONAL - this can be removed>

end try
begin catch
	Print 'Error in ' + OBJECT_NAME(@@PROCID) + '!'
	Declare @ErrorMessage nvarchar(4000);
	Declare @ErrorSeverity int;
	Declare @ErrorState int;
	Set @ErrorMessage  = ERROR_MESSAGE()
	Set @ErrorSeverity = ERROR_SEVERITY()
	Set @ErrorState    = ERROR_STATE()
	Print 'Error: ' + @ErrorMessage + ' - (severity, state) = ( ' + @ErrorSeverity + ' , ' + @ErrorState + ' )'
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
end catch
GO

