/*<info serverAlias="DBCust-CustDB"></info>*/
/*
	Created by: Tacy@20230802
	Task: Test Auto CS
	DB: DBCust/CustDB and all replicated server
*/ 
-- BEGIN: DEPLOY THIS SP --------
ALTER PROCEDURE [dbo].[Acc_DynamicCustomerInfo_09]
	 @CustList		VARCHAR(MAX)
	,@target		VARCHAR(20)=''
AS
BEGIN
	SET NOCOUNT ON
	
	--IF (@target = 'REPLICATED' AND @@SERVERNAME IN ('DBCUST','SITDBCUST','TESTDBCUST','DB-60\DEVDBCUST')) RETURN -- run at all replicated servers
	--IF (@target = 'DBCUST' AND @@SERVERNAME NOT IN ('DBCUST','SITDBCUST','TESTDBCUST','DB-60\DEVDBCUST')) RETURN -- run at DBCUST only
	
	--IF  dbo.f_CheckRepTable('CustProductStatus') = 0	RETURN
	
	CREATE TABLE #CustList (CustID INT PRIMARY KEY)

	DECLARE @bitmapOrder TINYINT

	SET @bitmapOrder=29	--WM
	
	INSERT INTO #CustList(CustID)
	SELECT TRIM(value) AS CustID
	FROM STRING_SPLIT(@CustList,',')
	WHERE TRIM(value)<>''	
	
	UPDATE cs
	SET	bitmapIsHidden = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (cs.bitmapIsHidden, @bitmapOrder, 1)),
		bitmapIsDisabled = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (cs.bitmapIsDisabled, @bitmapOrder, 1)),
		bitmapHasSynced = (SELECT NewBitmap FROM dbo.f_CustSetting_GenerateProductStatus (cs.bitmapHasSynced, @bitmapOrder, 1))
	FROM [dbo].CustProductStatus cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #CustList b ON cs.CustID = b.CustID 

	DROP TABLE #CustList
END
GO

-- END: DEPLOY THIS SP --------
------------------------------------------------------	
PRINT N'Step 2: Start on ' + CAST(GETDATE() AS NVARCHAR(30)) + N'.';

--DECLARE @target VARCHAR(20)

--IF @@SERVERNAME IN ('DBCUST','SITDBCUST','TESTDBCUST','DB-60\DEVDBCUST')
--	SET @target = 'DBCUST'
--ELSE 
--	SET @target = 'REPLICATED'

--Print 'Server Name : ' + @target

CREATE TABLE #tbCustomer(CustID	INT PRIMARY KEY)

CREATE TABLE #Customer_batch(CustID	INT PRIMARY KEY)

DECLARE @max_custid INT, 
		@Cust_cnt	INT,
		@CustList	VARCHAR(MAX)

SELECT @max_custid = xxx

INSERT INTO #tbCustomer(CustID)
SELECT top 10000 ci.custid
FROM customer ci WITH (NOLOCK) 
WHERE ci.srecommend IN (SELECT custid FROM CustSuper WITH(NOLOCK))
	AND ci.custid <= @max_custid
	
-- For deployer info
---------------------------------------------------------------------------------------------
SELECT @Cust_cnt = COUNT(1)
FROM #tbCustomer

DECLARE @msg_total NVARCHAR(200) = 'Total of Customers Affected: %d.'

RAISERROR (@msg_total, 0, 1, @Cust_cnt) WITH NOWAIT

WHILE (1=1)
BEGIN
	DELETE FROM #Customer_batch

	DELETE TOP (2000) T
	OUTPUT deleted.CustID
		INTO #Customer_batch(CustID)
	FROM #tbCustomer t 

	IF @@ROWCOUNT = 0 BREAK

	SELECT @CustList=STUFF((SELECT ',' + CAST(CUSTID AS VARCHAR)
							FROM #Customer_batch
							FOR XML PATH('')),1,1,'')
	
	EXEC dbo.Acc_DynamicCustomerInfo_09 
			 @CustList = @CustList
			--,@target = @target

	WAITFOR DELAY '00:00:0.050'

	SET @msg_total = 'Curdt: ' + CONVERT(VARCHAR(50), GETDATE(), 121)

	RAISERROR (@msg_total, 0, 1) WITH NOWAIT
END	

DROP TABLE #tbCustomer, #Customer_batch
GO	

PRINT N'Step 2: End on ' + CAST(GETDATE() AS NVARCHAR(30)) + N'.';
GO
