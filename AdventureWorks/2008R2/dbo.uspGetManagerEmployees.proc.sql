SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
ALTER PROCEDURE	dbo.uspGetManagerEmployees
					@BusinessEntityID	INT
AS
BEGIN;
	SET NOCOUNT ON;

	-- Use recursive query to list out all Employees required for a particular Manager
	WITH EMP_cte(BusinessEntityID, OrganizationNode, FirstName, LastName, RecursionLevel) -- CTE name and columns
	AS (
		SELECT	e.BusinessEntityID, e.OrganizationNode, p.FirstName, p.LastName, 0 -- Get the initial list of Employees for Manager n
		FROM		HumanResources.Employee AS e WITH (NOLOCK)
		INNER JOIN	Person.Person AS p WITH (NOLOCK)
				ON	p.BusinessEntityID = e.BusinessEntityID
		WHERE	e.BusinessEntityID = @BusinessEntityID
		UNION ALL
		SELECT	e.BusinessEntityID, e.OrganizationNode, p.FirstName, p.LastName, cte.RecursionLevel + 1 -- Join recursive member to anchor
		FROM		HumanResources.Employee AS e WITH (NOLOCK)
		INNER JOIN	EMP_cte AS cte
				ON	e.OrganizationNode.GetAncestor(1) = cte.OrganizationNode
		INNER JOIN	Person.Person AS p WITH (NOLOCK)
				ON	p.BusinessEntityID = e.BusinessEntityID
	)
	-- Join back to Employee to return the manager name 
	SELECT cte.RecursionLevel, cte.OrganizationNode.ToString() AS OrganizationNode, p.FirstName AS ManagerFirstName, p.LastName AS ManagerLastName, cte.BusinessEntityID, cte.FirstName, cte.LastName -- Outer select from the CTE
	FROM		EMP_cte AS cte
	INNER JOIN	HumanResources.Employee AS e WITH (NOLOCK)
			ON	cte.OrganizationNode.GetAncestor(1) = e.OrganizationNode
	INNER JOIN	Person.Person AS p WITH (NOLOCK)
			ON	p.BusinessEntityID = e.BusinessEntityID
	ORDER BY RecursionLevel, cte.OrganizationNode.ToString()
	OPTION (MAXRECURSION 25); 
END;
GO
EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Stored procedure using a recursive query to return the direct and indirect employees of the specified manager.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'PROCEDURE'
		,	@level1name	= N'uspGetManagerEmployees'
		;

EXECUTE	sys.sp_addextendedproperty
			@name		= N'MS_Description'
		,	@value		= N'Input parameter for the stored procedure uspGetManagerEmployees. Enter a valid BusinessEntityID of the manager from the HumanResources.Employee table.'
		,	@level0type	= N'SCHEMA'
		,	@level0name	= N'dbo'
		,	@level1type	= N'PROCEDURE'
		,	@level1name	= N'uspGetManagerEmployees'
		,	@level2type	= N'PARAMETER'
		,	@level2name	= N'@BusinessEntityID'
		;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="0" isNested="0"></info>*/