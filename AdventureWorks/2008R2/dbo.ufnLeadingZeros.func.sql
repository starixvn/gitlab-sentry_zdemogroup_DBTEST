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
EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Input parameter for the scalar function ufnLeadingZeros. Enter a valid integer.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'FUNCTION'
		,	@level1name	= N'ufnLeadingZeros'
		,	@level2type	= N'PARAMETER'
		,	@level2name	= N'@Value'
		;

EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Scalar function used by the Sales.Customer table to help set the account number.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'FUNCTION'
		,	@level1name	= N'ufnLeadingZeros'
		;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="1"></info>*/