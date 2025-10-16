/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
        Created: Tacy@20250827
        Task: Get MaxCustID [redmine: #236998]
        DB: DBCUST/CustDB
*/
USE CustDB
GO

SELECT MAX(custid) FROM custinfo WITH(NOLOCK)
GO