SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
ALTER FUNCTION	dbo.ufnGetDocumentStatusText (
					@Status			TINYINT
				)
RETURNS NVARCHAR(16)
AS
-- Returns the sales order status text representation for the status value.
BEGIN
	DECLARE	@ret	NVARCHAR(16);

	SET	@ret = 
		CASE @Status
			WHEN 1 THEN N'Pending approval'
			WHEN 2 THEN N'Approved'
			WHEN 3 THEN N'Obsolete'
			ELSE N'** Invalid **'
		END;

	RETURN @ret;
END;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="0"></info>*/