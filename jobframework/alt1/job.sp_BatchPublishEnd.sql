if not exists(select [name] from sys.[schemas] where [name] = 'job')
begin
	Declare @sqlstmt nvarchar(500) = 'create schema job'
	Exec (@sqlstmt)
end
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP procedure if exists [job].[sp_BatchPublishEnd]
GO
CREATE procedure [job].[sp_BatchPublishEnd]
	@BatchId          int
,   @RowsInserted     int
,   @RowsUpdated      int
,   @RowsDeleted      int
AS
-- ===================================================================================
-- Object Name: [dbo].[sp_BatchPublishEnd]
-- -----------------------------------------------------------------------------------
-- Company    : n/a
-- Author     : Thorberguro
-- Created    : 2023-09-27
-- Description: Updates a Batch indicating the end of a Publish step
--
-- Change Log
-- =============
-- YYYY-MM-DD - By                 - Desc
-- ----------   ----------------   ---------------------------------------------------
-- 
-- ===================================================================================
SET NOCOUNT ON;
begin try
	Declare @msg nvarchar(2000);
	Declare @rc int;

	Update job.Batch
	   set [PublishEnd]          = GETUTCDATE()
		 , [PublishDuration]     = datediff(SECOND, [PublishStart], GETUTCDATE())
		 , [PublishRowsInserted] = @RowsInserted
		 , [PublishRowsUpdated]  = @RowsUpdated
		 , [PublishRowsDeleted]  = @RowsDeleted
	 where id = @BatchId;
	Set @rc = @@ROWCOUNT

	if @rc = 0
	begin
		Set @msg = 'No Batch found for @BatchId = ' + cast(@BatchId as nvarchar(20)) + ' - batch not found'
		RAISERROR(@msg, 16, 1);
	end;
end try
begin catch
	Print 'Error in ' + OBJECT_NAME(@@PROCID) + '!'
	Declare @ErrorMessage nvarchar(4000);
	Declare @ErrorSeverity int;
	Declare @ErrorState int;
	Set @ErrorMessage  = ERROR_MESSAGE()
	Set @ErrorSeverity = ERROR_SEVERITY()
	Set @ErrorState    = ERROR_STATE()
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
end catch
go