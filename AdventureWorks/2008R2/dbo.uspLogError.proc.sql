SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
-- uspLogError logs error information in the ErrorLog table about the 
-- error that caused execution to jump to the CATCH block of a 
-- TRY...CATCH construct. This should be executed from within the scope 
-- of a CATCH block otherwise it will return without inserting error 
-- information. 
ALTER PROCEDURE	dbo.uspLogError
					@ErrorLogID		INT		= 0		OUTPUT	-- contains the ErrorLogID of the row inserted
AS															-- by uspLogError in the ErrorLog table
BEGIN
	SET NOCOUNT ON;

	-- Output parameter value of 0 indicates that error 
	-- information was not logged
	SET	@ErrorLogID = 0;

	BEGIN TRY
		-- Return if there is no error information to log
		IF	ERROR_NUMBER() IS NULL
			RETURN;

		-- Return if inside an uncommittable transaction.
		-- Data insertion/modification is not allowed when 
		-- a transaction is in an uncommittable state.
		IF	XACT_STATE() = -1
		BEGIN
			PRINT 'Cannot log error since the current transaction is in an uncommittable state. '
				+ 'Rollback the transaction before executing uspLogError in order to successfully log error information.'
				;
			RETURN;
		END;

		INSERT INTO	bo.ErrorLog (UserName, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage)
		VALUES	(CONVERT(sysname, CURRENT_USER), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

		-- Pass back the ErrorLogID of the row inserted
		SET	@ErrorLogID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		PRINT 'An error occurred in stored procedure uspLogError: ';
		EXECUTE	dbo.uspPrintError;
		RETURN -1;
	END CATCH;
END;
GO
EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Logs error information in the ErrorLog table about the error that caused execution to jump to the CATCH block of a TRY...CATCH construct. Should be executed from within the scope of a CATCH block otherwise it will return without inserting error information.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'PROCEDURE'
		,	@level1name	= N'uspLogError'
		;

EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Output parameter for the stored procedure uspLogError. Contains the ErrorLogID value corresponding to the row inserted by uspLogError in the ErrorLog table.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'PROCEDURE'
		,	@level1name	= N'uspLogError'
		,	@level2type	= N'PARAMETER'
		,	@level2name	= N'@ErrorLogID'
		;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="0" isNested="1"></info>*/