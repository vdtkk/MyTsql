/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [VKTCNo]
      ,[Alias]
      ,[Unvan]
      ,[Gecerlilik]
      ,[GuncelTarihi]
      ,[Aktif]
  FROM [Efatura].[dbo].[KayitliKullaniciTest]

SELECT 
    [VKTCNo],
    COUNT(*) ToplamAdet
FROM [Efatura].[dbo].[KayitliKullanici]
GROUP BY
 [VKTCNo] 
HAVING 
    COUNT(*) > 1;