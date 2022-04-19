/*<info serverAlias="DBAGE-bodb02"></info>*/

/*
	Step 01: Create table A
	Created: Tacy@20220419
	Database: DBAGE/bodb02
*/
USE tempdb
GO

CREATE TABLE ##tmpA (
		ID INT IDENTITY(1,1) PRIMARY KEY
	,	NAME VARCHAR(300) NOT NULL
)
GO