/*<info serverAlias="DBAGE-bodb02" selecters="bodbAdminNet" viewers="" isFunction="1" isNested="1"></info>*/

ALTER FUNCTION dbo.f_Test_F	(@SportType	 SMALLINT)
RETURNS TABLE
AS
/*  
 Created: 20220418@Tacy 
 Task :   Get TOP (100) match order by 'eventdate'
 DB: DBAGE/bodb02  
 Original:  
  
 Revisions:  
	- 20220418@Tacy: Create Function [Redmine: #12345]
 
 Param's Explanation:  
*/  
RETURN		
	SELECT TOP (100)
			m.matchid, l.leaguename
			, home.teamname home, away.teamname away
			, eventdate, s.SportName
	FROM [dbo].[match] m WITH (NOLOCK)
		LEFT JOIN dbo.League l  WITH (NOLOCK)	ON m.leagueid	= l.leagueid
		LEFT JOIN dbo.Team	home WITH (NOLOCK)	ON m.homeid		= home.teamid
		LEFT JOIN dbo.Team	away WITH (NOLOCK)	ON m.awayid		= away.teamid
		LEFT JOIN dbtxn.bodb02.dbo.Sports s WITH (NOLOCK) ON m.sporttype=s.SportType
	WHERE eventstatus='completed' 
		AND m.sporttype<>@SportType
	ORDER BY eventdate
GO