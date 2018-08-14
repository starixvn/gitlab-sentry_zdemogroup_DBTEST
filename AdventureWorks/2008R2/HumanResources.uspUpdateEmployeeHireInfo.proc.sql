SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
ALTER PROCEDURE	HumanResources.uspUpdateEmployeeHireInfo
					@BusinessEntityID	INT
				,	@JobTitle			NVARCHAR(50)
				,	@HireDate			DATETIME
				,	@RateChangeDate		DATETIME
				,	@Rate				MONEY
				,	@PayFrequency		TINYINT
				,	@CurrentFlag		dbo.Flag
WITH EXECUTE AS CALLER
AS
BEGIN;
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION;

		UPDATE	HumanResources.Employee WITH (ROWLOCK)
		SET	JobTitle	= @JobTitle 
		,	HireDate	= @HireDate 
		,	CurrentFlag	= @CurrentFlag 
		WHERE	BusinessEntityID = @BusinessEntityID;

		INSERT INTO	HumanResources.EmployeePayHistory (BusinessEntityID, RateChangeDate, Rate, PayFrequency) 
		VALUES	(@BusinessEntityID, @RateChangeDate, @Rate, @PayFrequency);

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		-- Rollback any active or uncommittable transactions before
		-- inserting information in the ErrorLog
		IF	@@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION;
		END;

		EXECUTE	dbo.uspLogError;
	END CATCH;
END;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="0" isNested="0"></info>*/