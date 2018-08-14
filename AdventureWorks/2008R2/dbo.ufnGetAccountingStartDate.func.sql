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
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="1"></info>*/