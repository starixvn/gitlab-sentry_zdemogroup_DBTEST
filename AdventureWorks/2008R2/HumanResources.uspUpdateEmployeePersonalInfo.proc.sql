SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
ALTER PROCEDURE	HumanResources.uspUpdateEmployeePersonalInfo
					@BusinessEntityID	INT
				,	@NationalIDNumber	NVARCHAR(15)
				,	@BirthDate			DATETIME
				,	@MaritalStatus		NCHAR(1)
				,	@Gender				NCHAR(1)
WITH EXECUTE AS CALLER
AS
BEGIN;
	SET NOCOUNT ON;

	BEGIN TRY
		UPDATE	HumanResources.Employee WITH (ROWLOCK)
		SET	NationalIDNumber	= @NationalIDNumber 
		,	BirthDate			= @BirthDate 
		,	MaritalStatus		= @MaritalStatus 
		,	Gender				= @Gender 
		WHERE BusinessEntityID = @BusinessEntityID;
	END TRY
	BEGIN CATCH
		EXECUTE	dbo.uspLogError;
	END CATCH;
END;
GO
EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Updates the Employee table with the values specified in the input parameters for the given EmployeeID.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'HumanResources'
		,	@level1type	= N'PROCEDURE'
		,	@level1name	= N'uspUpdateEmployeePersonalInfo'
		;

EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Input parameter for the stored procedure uspUpdateEmployeePersonalInfo. Enter a valid BusinessEntityID from the HumanResources.Employee table.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'HumanResources'
		,	@level1type	= N'PROCEDURE'
		,	@level1name	= N'uspUpdateEmployeePersonalInfo'
		,	@level2type	= N'PARAMETER'
		,	@level2name	= N'@BusinessEntityID'
		;

EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a national ID for the employee.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'HumanResources'
		,	@level1type	= N'PROCEDURE'
		,	@level1name	= N'uspUpdateEmployeePersonalInfo'
		,	@level2type	= N'PARAMETER'
		,	@level2name	= N'@NationalIDNumber'
		;

EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a birth date for the employee.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'HumanResources'
		,	@level1type	= N'PROCEDURE'
		,	@level1name	= N'uspUpdateEmployeePersonalInfo'
		,	@level2type	= N'PARAMETER'
		,	@level2name	= N'@BirthDate'
		;

EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a marital status for the employee.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'HumanResources'
		,	@level1type	= N'PROCEDURE'
		,	@level1name	= N'uspUpdateEmployeePersonalInfo'
		,	@level2type	= N'PARAMETER'
		,	@level2name	= N'@MaritalStatus'
		;

EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a gender for the employee.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'HumanResources'
		,	@level1type	= N'PROCEDURE'
		,	@level1name	= N'uspUpdateEmployeePersonalInfo'
		,	@level2type	= N'PARAMETER'
		,	@level2name	= N'@Gender'
		;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="0" isNested="0"></info>*/