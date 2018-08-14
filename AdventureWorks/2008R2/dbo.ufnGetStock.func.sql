SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
ALTER FUNCTION	dbo.ufnGetStock (
					@ProductID		INT
				)
RETURNS INT
AS
-- Returns the stock level for the product. This function is used internally only
BEGIN
	DECLARE	@ret	INT;

	SELECT	@ret = SUM(p.Quantity)
	FROM	Production.ProductInventory AS p WITH (NOLOCK)
	WHERE	p.ProductID = @ProductID
		AND	p.LocationID = '6'; -- Only look at inventory in the misc storage

	IF	@ret IS NULL
		SET	@ret = 0;

	RETURN @ret;
END;
GO
EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Input parameter for the scalar function ufnGetStock. Enter a valid ProductID from the Production.ProductInventory table.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'FUNCTION'
		,	@level1name	= N'ufnGetStock'
		,	@level2type	= N'PARAMETER'
		,	@level2name	= N'@ProductID'
		;

EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Scalar function returning the quantity of inventory in LocationID 6 (Miscellaneous Storage)for a specified ProductID.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'FUNCTION'
		,	@level1name	= N'ufnGetStock'
		;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="0"></info>*/