 
Declare @Database2023 nvarchar(100)
Declare @Ind int
Declare @HesapKodu nvarchar(100)
Declare @HesapAdi nvarchar(100)
Declare @Owner int
Declare @DevirBakiye2022 Float
Declare @DevirBakiye2023 Float
Declare @DevirTarihi DateTime


CREATE TABLE #DevirBankaKontrol (Ind int, Owner int,HesapKodu NVARCHAR(100),HesapAdi VARCHAR(100),DevirBakiye2022 float,DevirBakiye2023 float)     
DECLARE   DevirBankaUpdate CURSOR FOR
SELECT [Ind],[Owner],[HesapKodu],[HesapAdi],SUM([Bakiye]) Bakiye_2022,0 from [2022_HakanHitit].[dbo].[BankaBakiyeListesi]
GROUP BY [Ind],[Owner],[HesapKodu],[HesapAdi]
UNION ALL
SELECT [Ind],[Owner],[HesapKodu],[HesapAdi],0,SUM([Bakiye]) Bakiye_2023 from [HakanHitit].[dbo].[BankaBakiyeListesi]
GROUP BY [Ind],[Owner],[HesapKodu],[HesapAdi]

OPEN DevirBankaUpdate;  
FETCH NEXT FROM DevirBankaUpdate INTO @Ind,@Owner,@HesapKodu,@HesapAdi,@DevirBakiye2022 ,@DevirBakiye2023

WHILE @@FETCH_STATUS = 0  
BEGIN

IF EXISTS(SELECT * FROM #DevirBankaKontrol WHERE Ind = @Ind)
   BEGIN
      UPDATE #DevirBankaKontrol SET DevirBakiye2023 = @DevirBakiye2023 where Ind = @Ind
   END
ELSE
	BEGIN
		INSERT INTO  #DevirBankaKontrol
	    ( [Ind],[Owner],[HesapKodu],[HesapAdi],DevirBakiye2022,DevirBakiye2023  ) VALUES ( @Ind,@Owner,@HesapKodu,@HesapAdi,@DevirBakiye2022,@DevirBakiye2023 )
    END
FETCH NEXT FROM DevirBankaUpdate INTO @Ind,@Owner,@HesapKodu,@HesapAdi,@DevirBakiye2022 ,@DevirBakiye2023 
END
CLOSE DevirBankaUpdate;  
DEALLOCATE DevirBankaUpdate;
 
SELECT [Ind],[Owner],[HesapKodu],[HesapAdi], FORMAT(DevirBakiye2022, 'C', 'tr-TR') DevirBakiye2022,   FORMAT(DevirBakiye2023, 'C', 'tr-TR')  DevirBakiye2023,
FORMAT(DevirBakiye2022-DevirBakiye2023, 'C', 'tr-TR') as Fark FROM #DevirBankaKontrol where DevirBakiye2022 != DevirBakiye2023  
order by Ind
DROP TABLE #DevirBankaKontrol

