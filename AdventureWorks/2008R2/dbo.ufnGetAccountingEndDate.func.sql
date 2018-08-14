SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
ALTER FUNCTION	dbo.ufnGetAccountingEndDate()
RETURNS DATETIME
AS 
BEGIN;
	RETURN DATEADD(MILLISECOND, -2, CONVERT(DATETIME, '20040701', 112));
END;
GO
EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Scalar function used in the uSalesOrderHeader trigger to set the starting account date.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'FUNCTION'
		,	@level1name	= N'ufnGetAccountingEndDate'
		;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="1"></info>*/