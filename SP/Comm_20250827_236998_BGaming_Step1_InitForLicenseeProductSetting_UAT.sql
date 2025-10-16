/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: Tacy@20250827
	Task: UAT - Add product setting for Licensees [redmine: #236998]
	DB: DBCUST-CustDB
*/
---------------------------------------------------------------------------------
--Dep_LicenseeProductSetting
USE CustDB
GO

INSERT INTO dbo.Dep_LicenseeProductSetting(CustID,ProductSettingID,RepUpdateTime)
SELECT s.custid, t.ProductSettingID, SYSDATETIME()
FROM dbo.Dep_CustSuper s WITH(NOLOCK)
	INNER JOIN bodb_licensee.dbo.Licensees l WITH (NOLOCK) ON l.LicenseeName = s.site
	CROSS APPLY (SELECT ProductSettingID, ProductID
				 FROM Dep_ProductSetting WITH (NOLOCK)
				 WHERE SettingType=9 AND ProductID IN (114)
				) t
	CROSS APPLY (SELECT TOP 1 lp.CustID 
				FROM Dep_LicenseeProductSetting lp WITH (NOLOCK) 
					INNER JOIN Dep_ProductSetting pd WITH (NOLOCK) ON pd.ProductSettingID = lp.ProductSettingID
				WHERE lp.CustID = s.custid AND pd.SettingType = 4
					AND pd.ProductID = t.ProductID
				) AS p_tmp
	LEFT JOIN Dep_LicenseeProductSetting p WITH(NOLOCK) 
		ON p.custid = s.custid
		AND p.ProductSettingID = t.ProductSettingID
WHERE p.custid IS NULL		
	AND l.IsActive = 1
	AND (l.licenseeName IN ('Athena000', 'spondemo') AND s.currency=20)