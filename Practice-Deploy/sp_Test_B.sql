/*<info serverAlias="DBAGE-bodb02" executers="bodbAdminNet" viewers="" isFunction="0" isNested="1"></info>*/

ALTER PROCEDURE [dbo].[sp_Test_B]
	@SportType SMALLINT
AS
/*  
 Created: 20220418@Tacy 
 Task : Get top 100 Match is running within two days by @SportType  
 DB: DBAGE/bodb02  
 Original:  
  
 Revisions:  
	- 20220418@Tacy: Create SP [Redmine: #12345]
 
 Param's Explanation:  
 */ 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @Start_date DATE

	SET @Start_date = DATEADD(WEEK, -3, GETDATE())

	SELECT TOP (50)
			m.matchid, l.leaguename
			, home.teamname home, away.teamname away
			, eventdate, s.SportName
	FROM [dbo].[match] m WITH (NOLOCK)
		LEFT JOIN dbo.League l  WITH (NOLOCK)	ON m.leagueid	= l.leagueid
		LEFT JOIN dbo.Team	home WITH (NOLOCK)	ON m.homeid		= home.teamid
		LEFT JOIN dbo.Team	away WITH (NOLOCK)	ON m.awayid		= away.teamid
		LEFT JOIN dbtxn.bodb02.dbo.Sports s WITH (NOLOCK) ON m.sporttype=s.SportType
	WHERE eventstatus='completed' 
		AND m.sporttype=@SportType
		AND (eventdate > @Start_date AND eventdate <= GETDATE())
END
GO