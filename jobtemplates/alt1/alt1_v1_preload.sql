
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP procedure if exists [<process schema>].[sp_<topic>_v1_preload]
GO
CREATE procedure [<process schema>].[sp_<topic>_v1_preload]
	@BatchId      int
,	@OriginId     int
,	@RowsInserted int OUTPUT
AS
-- ===================================================================================
-- Object Name: [<process schema>].[sp_<topic>_v1_preload]
-- -----------------------------------------------------------------------------------
-- Company    : <company>
-- Author     : <developer>
-- Created    : <date>
-- Description: This is a generic preload procedure that wraps the origin specific
--              procedures. This is the procedure called from the orchestration job.
--              which should be agnosti to origin specific behaviours. This procedure
--              enfources a strict naming convension.
--
-- Change Log
-- =============
-- YYYY-MM-DD - By                 - Desc
-- ----------   ----------------   ---------------------------------------------------
-- 
-- ===================================================================================
SET NOCOUNT ON;
begin try
	Declare @msg nvarchar(4000);
	
	-- PARSE, VALIDATE AND BUILD A CALL TO THE SUB PROCEDURE
	Declare @procName     nvarchar(300)  = OBJECT_NAME(@@PROCID);
	Declare @schemaName   nvarchar(200)  = OBJECT_SCHEMA_NAME(@@PROCID);
	Declare @versionPos   int            = PATINDEX('%[_]v%',@procName);       -- the '_' character is a wildcard by itself and thus must be enclosed
	Declare @preloadPos   int            = PATINDEX('%[_]preload%',@procName); -- the '_' character is a wildcard by itself and thus must be enclosed
	Declare @version      nvarchar(40)   = SUBSTRING(@procName,@versionPos+2,@preloadPos-@versionPos-2);
	Declare @procBaseName nvarchar(300)  = SUBSTRING(@procName,1,@versionPos-1);
	Declare @subproc      nvarchar(4000) = '[' + @schemaName + '].[' + @procBaseName + '_o' + cast(@OriginId as nvarchar(10)) + '_v' + @version + '_preload]'

	-- PREPARE THE SQL STATEMENT AND EXECUTE
	Declare @sqlstmt      nvarchar(1000) = N'EXEC @retval_out = ' + @subproc + ' @BatchId = @BatchId_in, @OriginId = @OriginId_in, @RowsInserted = @RowsInserted_out OUTPUT'
	Declare @param_def    nvarchar(500)  = N'@BatchId_in int, @OriginId_in int, @RowsInserted_out int OUT, @retval_out int OUT'
	Declare @Retval int;
	EXEC sp_executesql @sqlstmt, @param_def, @BatchId, @OriginId, @RowsInserted OUT, @Retval OUT

	-- RETURN VALUES (some orchestrators prefer select results over OUTPUT parameters. RetVal can be used to return additional information not available as output parameter)
	Select RowsInserted = @RowsInserted, Retval = @Retval

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


