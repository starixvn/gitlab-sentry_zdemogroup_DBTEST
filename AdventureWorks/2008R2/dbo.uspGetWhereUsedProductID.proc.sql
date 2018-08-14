SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
ALTER PROCEDURE	dbo.uspGetWhereUsedProductID
					@StartProductID		INT
				,	@CheckDate			DATETIME
AS
BEGIN;
	SET NOCOUNT ON;

	--Use recursive query to generate a multi-level Bill of Material (i.e. all level 1 components of a level 0 assembly, all level 2 components of a level 1 assembly)
	WITH BOM_cte(ProductAssemblyID, ComponentID, ComponentDesc, PerAssemblyQty, StandardCost, ListPrice, BOMLevel, RecursionLevel) -- CTE name and columns
	AS (
		SELECT	b.ProductAssemblyID, b.ComponentID, p.Name, b.PerAssemblyQty, p.StandardCost, p.ListPrice, b.BOMLevel, 0 -- Get the initial list of components for the bike assembly
		FROM		Production.BillOfMaterials AS b WITH (NOLOCK)
		INNER JOIN	Production.Product AS p WITH (NOLOCK)
				ON	b.ProductAssemblyID = p.ProductID
		WHERE	b.ComponentID = @StartProductID
			AND	@CheckDate >= b.StartDate
			AND	@CheckDate <= ISNULL(b.EndDate, @CheckDate)
		UNION ALL
		SELECT	b.ProductAssemblyID, b.ComponentID, p.Name, b.PerAssemblyQty, p.StandardCost, p.ListPrice, b.BOMLevel, cte.RecursionLevel + 1 -- Join recursive member to anchor
		FROM		BOM_cte AS cte
		INNER JOIN	Production.BillOfMaterials AS b WITH (NOLOCK)
				ON	cte.ProductAssemblyID = b.ComponentID
		INNER JOIN	Production.Product AS p WITH (NOLOCK)
				ON	b.ProductAssemblyID = p.ProductID 
		WHERE	@CheckDate >= b.StartDate 
			AND	@CheckDate <= ISNULL(b.EndDate, @CheckDate)
		)
	-- Outer select from the CTE
	SELECT	b.ProductAssemblyID, b.ComponentID, b.ComponentDesc, SUM(b.PerAssemblyQty) AS TotalQuantity , b.StandardCost, b.ListPrice, b.BOMLevel, b.RecursionLevel
	FROM	BOM_cte AS b
	GROUP BY b.ComponentID, b.ComponentDesc, b.ProductAssemblyID, b.BOMLevel, b.RecursionLevel, b.StandardCost, b.ListPrice
	ORDER BY b.BOMLevel, b.ProductAssemblyID, b.ComponentID
	OPTION (MAXRECURSION 25); 
END;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="0" isNested="0"></info>*/