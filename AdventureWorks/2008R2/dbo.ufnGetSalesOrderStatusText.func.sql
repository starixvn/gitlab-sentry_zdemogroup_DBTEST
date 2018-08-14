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
EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Input parameter for the scalar function ufnGetSalesOrderStatusText. Enter a valid integer.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'FUNCTION'
		,	@level1name	= N'ufnGetSalesOrderStatusText'
		,	@level2type	= N'PARAMETER'
		,	@level2name	= N'@Status'
		;

EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Scalar function returning the text representation of the Status column in the SalesOrderHeader table.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'FUNCTION'
		,	@level1name	= N'ufnGetSalesOrderStatusText'
		;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="0"></info>*/