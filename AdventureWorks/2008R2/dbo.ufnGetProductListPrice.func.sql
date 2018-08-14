SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
ALTER FUNCTION	dbo.ufnGetProductListPrice (
					@ProductID		INT
				,	@OrderDate		DATETIME
				)
RETURNS MONEY
AS
BEGIN;
	DECLARE	@ListPrice	MONEY;

	SELECT	@ListPrice = plph.ListPrice
	FROM		Production.Product AS p WITH (NOLOCK)
	INNER JOIN	Production.ProductListPriceHistory plph 
			ON	p.ProductID = plph.ProductID 
			AND	p.ProductID = @ProductID 
			AND	@OrderDate BETWEEN plph.StartDate AND COALESCE(plph.EndDate, CONVERT(DATETIME, '99991231', 112)); -- Make sure we get all the prices!

	RETURN @ListPrice;
END;
GO
EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Input parameter for the scalar function ufnGetProductListPrice. Enter a valid ProductID from the Production.Product table.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'FUNCTION'
		,	@level1name	= N'ufnGetProductListPrice'
		,	@level2type	= N'PARAMETER'
		,	@level2name	= N'@ProductID'
		;

EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Input parameter for the scalar function ufnGetProductListPrice. Enter a valid order date.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'FUNCTION'
		,	@level1name	= N'ufnGetProductListPrice'
		,	@level2type	= N'PARAMETER'
		,	@level2name	= N'@OrderDate'
		;

EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Scalar function returning the list price for a given product on a particular order date.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'FUNCTION'
		,	@level1name	= N'ufnGetProductListPrice'
		;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="0"></info>*/