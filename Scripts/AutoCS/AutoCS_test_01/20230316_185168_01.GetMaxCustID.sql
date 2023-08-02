/*<info serverAlias="DBCust-CustDB"></info>*/
/*
	Created by: 20230802@Tacy
	Task: get max custID
	DB: DBCust/CustDB
*/ 

SELECT MAX (custid) AS max_custid
FROM custInfo WITH (NOLOCK)