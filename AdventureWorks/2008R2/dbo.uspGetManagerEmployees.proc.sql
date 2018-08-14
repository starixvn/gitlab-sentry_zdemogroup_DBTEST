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
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="0" isNested="0"></info>*/