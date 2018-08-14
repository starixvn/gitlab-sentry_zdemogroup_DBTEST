SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
ALTER FUNCTION	dbo.ufnGetContactInformation (
					@PersonID		INT
				)
RETURNS @retContactInformation TABLE (
	-- Columns returned by the function
	PersonID			INT				NOT NULL
,	FirstName			NVARCHAR(50)	NULL
,	LastName			NVARCHAR(50)	NULL
,	JobTitle			NVARCHAR(50)	NULL
,	BusinessEntityType	NVARCHAR(50)	NULL
)
AS 
-- Returns the first name, last name, job title and business entity type for the specified contact.
-- Since a contact can serve multiple roles, more than one row may be returned.
BEGIN;
	IF	@PersonID IS NOT NULL
	BEGIN;
		IF	EXISTS (
				SELECT	1
				FROM	HumanResources.Employee AS e WITH (NOLOCK)
				WHERE	e.BusinessEntityID = @PersonID
			)
		BEGIN;
			INSERT INTO	@retContactInformation (PersonID, FirstName, LastName, JobTitle, BusinessEntityType)
			SELECT	@PersonID, p.FirstName, p.LastName, e.JobTitle, 'Employee'
			FROM		HumanResources.Employee AS e WITH (NOLOCK)
			INNER JOIN	Person.Person AS p WITH (NOLOCK)
					ON	p.BusinessEntityID = e.BusinessEntityID
			WHERE	e.BusinessEntityID = @PersonID;
		END;

		IF	EXISTS (
				SELECT	1
				FROM		Purchasing.Vendor AS v WITH (NOLOCK)
				INNER JOIN	Person.BusinessEntityContact AS bec WITH (NOLOCK)
						ON	bec.BusinessEntityID = v.BusinessEntityID
				WHERE	bec.PersonID = @PersonID
			)
		BEGIN;
			INSERT INTO	@retContactInformation (PersonID, FirstName, LastName, JobTitle, BusinessEntityType)
			SELECT	@PersonID, p.FirstName, p.LastName, ct.Name, 'Vendor Contact' 
			FROM		Purchasing.Vendor AS v WITH (NOLOCK)
			INNER JOIN	Person.BusinessEntityContact AS bec WITH (NOLOCK)
					ON	bec.BusinessEntityID = v.BusinessEntityID
			INNER JOIN	Person.ContactType AS ct WITH (NOLOCK)
					ON	ct.ContactTypeID = bec.ContactTypeID
			INNER JOIN	Person.Person AS p WITH (NOLOCK)
					ON	p.BusinessEntityID = bec.PersonID
			WHERE	bec.PersonID = @PersonID;
		END;

		IF	EXISTS (
				SELECT	1
				FROM		Sales.Store AS s WITH (NOLOCK)
				INNER JOIN	Person.BusinessEntityContact AS bec WITH (NOLOCK)
						ON	bec.BusinessEntityID = s.BusinessEntityID
				WHERE	bec.PersonID = @PersonID
			)
		BEGIN;
			INSERT INTO @retContactInformation (PersonID, FirstName, LastName, JobTitle, BusinessEntityType)
			SELECT	@PersonID, p.FirstName, p.LastName, ct.Name, 'Store Contact' 
			FROM		Sales.Store AS s WITH (NOLOCK)
			INNER JOIN	Person.BusinessEntityContact AS bec WITH (NOLOCK)
					ON	bec.BusinessEntityID = s.BusinessEntityID
			INNER JOIN	Person.ContactType AS ct WITH (NOLOCK)
					ON	ct.ContactTypeID = bec.ContactTypeID
			INNER JOIN	Person.Person AS p WITH (NOLOCK)
					ON	p.BusinessEntityID = bec.PersonID
			WHERE	bec.PersonID = @PersonID;
		END;

		IF	EXISTS (
				SELECT	1
				FROM		Person.Person AS p WITH (NOLOCK)
				INNER JOIN	Sales.Customer AS c WITH (NOLOCK)
						ON	c.PersonID = p.BusinessEntityID
				WHERE	p.BusinessEntityID = @PersonID
					AND	c.StoreID IS NULL
			)
		BEGIN;
			INSERT INTO @retContactInformation (PersonID, FirstName, LastName, JobTitle, BusinessEntityType)
			SELECT	@PersonID, p.FirstName, p.LastName, NULL, 'Consumer' 
			FROM		Person.Person AS p WITH (NOLOCK)
			INNER JOIN	Sales.Customer AS c WITH (NOLOCK)
					ON	c.PersonID = p.BusinessEntityID
			WHERE	p.BusinessEntityID = @PersonID
				AND	c.StoreID IS NULL;
		END;
	END;

	RETURN;
END;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="1" isNested="0"></info>*/