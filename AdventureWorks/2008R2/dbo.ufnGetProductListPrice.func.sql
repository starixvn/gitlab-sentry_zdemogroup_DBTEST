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
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="0"></info>*/