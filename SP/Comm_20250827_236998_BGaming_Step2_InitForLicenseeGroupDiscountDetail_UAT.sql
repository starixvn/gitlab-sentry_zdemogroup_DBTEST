/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
        Created: Tacy@20250827
        Task: UAT - Init data LicenseeGroupDiscountDetail for BGaming [redmine: #236998]
        DB: DBCUST/bodb_Licensee
*/
USE bodb_Licensee
GO

DECLARE @tmpProduct TABLE (ProductID INT, IsFinished BIT DEFAULT 0)
DECLARE @ProductID INT
        
INSERT INTO @tmpProduct        (ProductID)
SELECT (114)
        
WHILE(1=1)
BEGIN
        UPDATE TOP (1) t
        SET IsFinished = 1,
                @ProductID = ProductID
        FROM @tmpProduct t
        WHERE IsFinished = 0
                
        IF @@ROWCOUNT = 0
                BREAK;
                        
        --3k rows
        INSERT INTO [dbo].[LicenseeGroupDiscountDetail]
                                ([GroupDiscountID]
                                ,[Licenseeid]
                                ,[Sporttype]
                                ,[Bettype]
                                ,[Discount])
        SELECT GroupDiscountID, gd.Licenseeid, t.Sporttype, t.Bettype, 0 as Discount
        FROM LicenseeGroupDiscount gd WITH(NOLOCK)
                CROSS APPLY (SELECT DISTINCT l.LicenseeID, pd.Sporttype, pd.Bettype
                                         FROM CustDB.dbo.Dep_CustSuper cs WITH(NOLOCK)
                                                INNER JOIN Licensees l WITH(NOLOCK) ON cs.site = l.LicenseeName
                                                INNER JOIN CustDB.dbo.Dep_LicenseeProductSetting lp WITH (NOLOCK) on cs.custid = lp.CustID
                                                INNER JOIN CustDB.dbo.Dep_ProductSetting p WITH (NOLOCK) ON p.ProductSettingID = lp.ProductSettingID
                                                INNER JOIN CustDB.dbo.Dep_ProductSettingDetail pd WITH (NOLOCK) ON pd.ProductSettingID = p.ProductSettingID 
                                         WHERE p.SettingType = 4
                                                AND p.ProductID = @ProductID
                                                AND l.IsActive = 1
                                                AND l.LicenseeID = gd.LicenseeID
                                                AND l.licenseeName IN ('Athena000', 'spondemo')
                                        )t

        WAITFOR DELAY '0:0:0.280'
END