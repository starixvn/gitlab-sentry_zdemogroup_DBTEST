SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
--A stored procedure which demonstrates integrated full text search
ALTER PROCEDURE	dbo.uspSearchCandidateResumes
						@searchString		NVARCHAR(1000)
					,	@useInflectional	BIT				= 0
					,	@useThesaurus		BIT				= 0
					,	@language			INT				= 0
WITH EXECUTE AS CALLER
AS
BEGIN;
	SET NOCOUNT ON;

	DECLARE @string NVARCHAR(1050);

	--setting the lcid to the default instance LCID if needed
	IF	@language IS NULL OR @language = 0
	BEGIN 
		SELECT	@language = CONVERT(INT, SERVERPROPERTY('lcid'));
	END;

		--FREETEXTTABLE case as inflectional and Thesaurus were required
	IF	@useThesaurus = 1 AND @useInflectional = 1
	BEGIN
		SELECT	FT_TBL.JobCandidateID, KEY_TBL.RANK
		FROM		HumanResources.JobCandidate AS FT_TBL WITH (NOLOCK)
		INNER JOIN	FREETEXTTABLE(HumanResources.JobCandidate, *, @searchString, LANGUAGE @language) AS KEY_TBL
				ON	FT_TBL.JobCandidateID = KEY_TBL.[KEY];
	END;
	ELSE IF	@useThesaurus = 1
	BEGIN
		SELECT	@string = 'FORMSOF(THESAURUS,"' + @searchString + '"' + ')';
		SELECT	FT_TBL.JobCandidateID, KEY_TBL.RANK
		FROM		HumanResources.JobCandidate AS FT_TBL WITH (NOLOCK)
		INNER JOIN	CONTAINSTABLE(HumanResources.JobCandidate, *, @string, LANGUAGE @language) AS KEY_TBL
				ON	FT_TBL.JobCandidateID = KEY_TBL.[KEY];
	END;
	ELSE IF	@useInflectional = 1
	BEGIN;
		SELECT	@string = 'FORMSOF(INFLECTIONAL,"' + @searchString + '"' + ')';
		SELECT	FT_TBL.JobCandidateID, KEY_TBL.RANK
		FROM		HumanResources.JobCandidate AS FT_TBL WITH (NOLOCK)
		INNER JOIN	CONTAINSTABLE(HumanResources.JobCandidate, *, @string, LANGUAGE @language) AS KEY_TBL
				ON	FT_TBL.JobCandidateID = KEY_TBL.[KEY];
	END;
	ELSE --base case, plain CONTAINSTABLE
	BEGIN
		SELECT	@string = '"' + @searchString + '"';
		SELECT	FT_TBL.JobCandidateID,KEY_TBL.RANK
		FROM		HumanResources.JobCandidate AS FT_TBL WITH (NOLOCK)
		INNER JOIN	CONTAINSTABLE(HumanResources.JobCandidate, *, @string, LANGUAGE @language) AS KEY_TBL
				ON	FT_TBL.JobCandidateID = KEY_TBL.[KEY];
	END;
END;
GO
/*<info serverAlias="DBTEST-AdventureWorks2008R2" executers="" viewers="" isFunction="0" isNested="0"></info>*/