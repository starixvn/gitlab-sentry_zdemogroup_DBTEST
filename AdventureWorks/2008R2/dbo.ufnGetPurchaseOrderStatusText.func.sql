SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
ALTER FUNCTION	dbo.ufnGetPurchaseOrderStatusText (
					@Status			TINYINT
				)
RETURNS NVARCHAR(15)
AS
-- Returns the sales order status text representation for the status value.
BEGIN
	DECLARE	@ret	NVARCHAR(15);

	SET	@ret = 
		CASE @Status
			WHEN 1 THEN 'Pending'
			WHEN 2 THEN 'Approved'
			WHEN 3 THEN 'Rejected'
			WHEN 4 THEN 'Complete'
			ELSE '** Invalid **'
		END;

	RETURN @ret;
END;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="0"></info>*/