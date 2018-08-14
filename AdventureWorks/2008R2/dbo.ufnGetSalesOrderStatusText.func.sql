SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
ALTER FUNCTION	dbo.ufnGetSalesOrderStatusText (
					@Status			TINYINT
				)
RETURNS NVARCHAR(15)
AS
-- Returns the sales order status text representation for the status value.
BEGIN
	DECLARE	@ret	NVARCHAR(15);

	SET	@ret = 
		CASE @Status
			WHEN 1 THEN 'In process'
			WHEN 2 THEN 'Approved'
			WHEN 3 THEN 'Backordered'
			WHEN 4 THEN 'Rejected'
			WHEN 5 THEN 'Shipped'
			WHEN 6 THEN 'Cancelled'
			ELSE '** Invalid **'
		END;

	RETURN @ret;
END;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="0"></info>*/