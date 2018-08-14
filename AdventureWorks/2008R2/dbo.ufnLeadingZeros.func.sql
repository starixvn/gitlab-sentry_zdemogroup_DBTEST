SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
ALTER FUNCTION	dbo.ufnLeadingZeros (
					@Value		INT
				)
RETURNS VARCHAR(8)
WITH SCHEMABINDING
AS
BEGIN
	DECLARE	@ReturnValue	VARCHAR(8);

	SET	@ReturnValue = CONVERT(VARCHAR(8), @Value);
	SET	@ReturnValue = REPLICATE('0', 8 - DATALENGTH(@ReturnValue)) + @ReturnValue;

	RETURN (@ReturnValue);
END;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="1"></info>*/