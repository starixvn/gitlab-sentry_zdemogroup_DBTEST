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
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="1"></info>*/