SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
ALTER PROCEDURE	HumanResources.uspUpdateEmployeeLogin
						@BusinessEntityID	INT
					,	@OrganizationNode	HIERARCHYID
					,	@LoginID			NVARCHAR(256)
					,	@JobTitle			NVARCHAR(50)
					,	@HireDate			DATETIME
					,	@CurrentFlag		dbo.Flag
WITH EXECUTE AS CALLER
AS
BEGIN;
	SET NOCOUNT ON;

	BEGIN TRY
		UPDATE	HumanResources.Employee WITH (ROWLOCK)
		SET	OrganizationNode	= @OrganizationNode 
		,	LoginID				= @LoginID 
		,	JobTitle			= @JobTitle 
		,	HireDate			= @HireDate 
		,	CurrentFlag			= @CurrentFlag 
		WHERE	BusinessEntityID = @BusinessEntityID;
	END TRY
	BEGIN CATCH
		EXECUTE	dbo.uspLogError;
	END CATCH;
END;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="0" isNested="0"></info>*/