/*<info serverAlias="DBAGE-bodb02" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

ALTER PROCEDURE [dbo].[sp_Test_C]

AS
/*  
 Created: 20220418@Tacy 
 Task :   Get total Stake within 2 days
 DB: DBAGE/bodb02  
 Original:  
  
 Revisions:  
	- 20220418@Tacy: Create SP [Redmine: #12345]
 
 Param's Explanation:  
 */  
 BEGIN
	DECLARE @Start_date DATE

	SET @Start_date = DATEADD(DAY,-3,GETDATE())

	SELECT status, SUM(stake) total_stake
		, SUM(actual_stake) total_actual_stake
	FROM bettrans WITH (NOLOCK)
	WHERE matchid<>0 
		AND status IN ('WON','LOSE','DRAW')
		AND transdate>@Start_date AND transdate<=GETDATE()
	GROUP BY status

END
GO