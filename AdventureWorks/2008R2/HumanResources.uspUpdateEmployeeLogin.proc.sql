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
/*
	Revisions:
		- 20170419@Larry: Initialize SP
		- 20100123@Henry: Grant execute to Accounting site
		- 20100730@Henry: Grant execute to bodbExtAccNet
*/
BEGIN;
	SET NOCOUNT ON;

	BEGIN TRY
		UPDATE	HumanResources.Employee WITH (ROWLOCK)
		SET	OrganizationNode	= @OrganizationNode 
		,	LoginID				= @LoginID 	
		,	HireDate			= @HireDate 
		,	CurrentFlag			= @CurrentFlag 
		WHERE	BusinessEntityID = @BusinessEntityID;
	END TRY
	BEGIN CATCH
		EXEC dbo.uspLogError
	END CATCH;
END;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="0" isNested="0"></info>*/