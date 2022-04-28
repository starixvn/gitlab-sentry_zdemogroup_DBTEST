/*<info serverAlias="DBAGE-bodb02" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

ALTER PROCEDURE [dbo].[sp_Test_A]
	@SportType SMALLINT

AS
/*  
 Created: 20220418@Tacy 
 Task :   
 DB: DBAGE/bodb02  
 Original:  
  
 Revisions:  
	- 20220418@Tacy: Create SP [Redmine: #12345]
	- 20220428@Larry: test
 
 Param's Explanation:  
 */  
 BEGIN
	SET NOCOUNT ON
	
	CREATE TABLE #tmpMatch (
			matchid			INT
		,	leaguename		VARCHAR(500)	
		,	HomeTeam		VARCHAR(500)
		,	AwayTeam		VARCHAR(500)
		,	eventdate		DATETIME
		,	SportName		VARCHAR(500)
	)

	INSERT INTO #tmpMatch(matchid,leaguename,HomeTeam,AwayTeam,eventdate,SportName)
	EXECUTE dbo.sp_Test_B @sporttype

	INSERT INTO #tmpMatch(matchid,leaguename,HomeTeam,AwayTeam,eventdate,SportName)
	SELECT matchid, leaguename, home, away
		, eventdate, SportName
	FROM dbo.f_Test_F(@sporttype)

	SELECT *
	FROM #tmpMatch

	DROP TABLE #tmpMatch
END
GO