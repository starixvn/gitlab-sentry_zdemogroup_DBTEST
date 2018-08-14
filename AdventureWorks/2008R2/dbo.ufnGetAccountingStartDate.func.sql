SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
ALTER FUNCTION	dbo.ufnGetAccountingStartDate()
RETURNS DATETIME
AS 
BEGIN;
	RETURN CONVERT(DATETIME, '20030701', 112);
END;
GO
EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Scalar function used in the uSalesOrderHeader trigger to set the ending account date.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'FUNCTION'
		,	@level1name	= N'ufnGetAccountingStartDate'
		;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="1"></info>*/