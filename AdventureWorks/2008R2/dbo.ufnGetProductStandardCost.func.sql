SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
ALTER FUNCTION	dbo.ufnGetProductStandardCost (
					@ProductID		INT
				,	@OrderDate		DATETIME
				)
RETURNS MONEY
AS
-- Returns the standard cost for the product on a specific date.
BEGIN
	DECLARE @StandardCost MONEY;

	SELECT	@StandardCost = pch.StandardCost
	FROM		Production.Product AS p WITH (NOLOCK)
	INNER JOIN	Production.ProductCostHistory AS pch WITH (NOLOCK)
			ON	p.ProductID = pch.ProductID
			AND	p.ProductID = @ProductID
			AND	@OrderDate BETWEEN pch.StartDate AND COALESCE(pch.EndDate, CONVERT(DATETIME, '99991231', 112)); -- Make sure we get all the prices!

	RETURN @StandardCost;
END;
GO
EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Input parameter for the scalar function ufnGetProductStandardCost. Enter a valid ProductID from the Production.Product table.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'FUNCTION'
		,	@level1name	= N'ufnGetProductStandardCost'
		,	@level2type	= N'PARAMETER'
		,	@level2name	= N'@ProductID'
		;

EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Input parameter for the scalar function ufnGetProductStandardCost. Enter a valid order date.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'FUNCTION'
		,	@level1name	= N'ufnGetProductStandardCost'
		,	@level2type	= N'PARAMETER'
		,	@level2name	= N'@OrderDate'
		;

EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Scalar function returning the standard cost for a given product on a particular order date.'
		,	@level0type = N'SCHEMA'
		,	@level0name = N'dbo'
		,	@level1type = N'FUNCTION'
		,	@level1name = N'ufnGetProductStandardCost'
		;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="0"></info>*/