SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
ALTER FUNCTION	dbo.ufnGetProductDealerPrice (
					@ProductID		INT
				,	@OrderDate		DATETIME
				)
RETURNS MONEY
AS
-- Returns the dealer price for the product on a specific date.
BEGIN;
	DECLARE @DealerPrice MONEY;
	DECLARE @DealerDiscount MONEY;

	SET @DealerDiscount = 0.60;  -- 60% of list price

	SELECT	@DealerPrice = plph.ListPrice * @DealerDiscount 
	FROM		Production.Product AS p WITH (NOLOCK)
	INNER JOIN	Production.ProductListPriceHistory AS plph WITH (NOLOCK)
			ON	p.ProductID = plph.ProductID
			AND	p.ProductID = @ProductID
			AND	@OrderDate BETWEEN plph.StartDate AND COALESCE(plph.EndDate, CONVERT(DATETIME, '99991231', 112)); -- Make sure we get all the prices!

	RETURN @DealerPrice;
END;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="0"></info>*/