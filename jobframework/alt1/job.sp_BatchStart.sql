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
DROP procedure if exists [job].[sp_BatchStart]
GO
CREATE procedure [job].[sp_BatchStart]
	@PlatformType        nvarchar(50) = NULL
,	@PlatformContainer   nvarchar(50) = NULL
,	@PlatformRunId       nvarchar(50) = NULL
,   @Module              nvarchar(200)
,   @ModuleId            nvarchar(50) = NULL
,   @OriginId            int
,   @Classification      nvarchar(50) = 'ETL'
,   @BatchId             int OUTPUT
AS
-- ===================================================================================
-- Object Name: [dbo].[sp_BatchStart]
-- -----------------------------------------------------------------------------------
-- Company    : n/a
-- Author     : Thorberguro
-- Created    : 2023-09-27
-- Description: Adds a new batch identifier into the BATCH table and returns the ID.
--
-- Change Log
-- =============
-- YYYY-MM-DD - By                 - Desc
-- ----------   ----------------   ---------------------------------------------------
-- 
-- ===================================================================================
SET NOCOUNT ON;
begin try
	Declare @output Table(id int);

	-- Create the BATCH entry and store the generated ID in the table variables
	insert into job.Batch
	(
		[PlatformType]
	,	[PlatformContainer]
	,	[PlatformRunId]
	,	[Module]
	,	[ModuleId]
	,   [OriginId]
	,   [Classification]
	,	[Status]
	,	[BatchStart]
	,	[idSLA]
	)
	output Inserted.Id into @output
	values
	(
		@PlatformType
	,	@PlatformContainer
	,   @PlatformRunId
	,   @Module
	,   @ModuleId
	,   @OriginId
	,   @Classification
	,   'Running'
	,   GETUTCDATE()
	,   -1
	)

	-- Assign the return value to @BatchID
	select @BatchId = ID from @output
	select BatchId = @BatchId;
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