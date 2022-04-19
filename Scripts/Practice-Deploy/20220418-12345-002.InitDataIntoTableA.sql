/*<info serverAlias="DBAGE-bodb02"></info>*/

/*
	Created: Tacy@20220419
	Database: DBAGE/bodb02
	Step 02: Init data into table A [RedmineID: #12345]
*/
USE tempdb
GO

INSERT INTO ##tmpA (NAME)
	VALUES ('OANH'),('TACY'),('HUGEN'),('QUEEN')
GO