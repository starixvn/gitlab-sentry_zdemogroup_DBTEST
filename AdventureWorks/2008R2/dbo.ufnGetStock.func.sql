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
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="0"></info>*/