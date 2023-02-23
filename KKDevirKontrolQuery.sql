 
Declare @Database2023 nvarchar(100)
Declare @Ind int
Declare @BankaInd int
Declare @HesapKodu nvarchar(100)
Declare @HesapAdi nvarchar(100)
Declare @Owner int
Declare @DevirBakiye2022 Float
Declare @DevirBakiye2023 Float
Declare @DevirTarihi DateTime

CREATE TABLE #DevirKKKontrol (Owner int,BankaInd int,Ind int,HesapKodu NVARCHAR(100),HesapAdi VARCHAR(100),DevirBakiye2022 float,DevirBakiye2023 float)     
DECLARE   DevirKKUpdate CURSOR FOR
SELECT [Owner],[BankaInd],[Ind],[HesapKodu],[HesapAdi],SUM([Bakiye]) Bakiye_2022,0 from [2022_HakanHitit].[dbo].[KKartlariWithBakiye]
GROUP BY [Owner],[BankaInd],[Ind],[HesapKodu],[HesapAdi]
UNION ALL
SELECT [Owner],[BankaInd],[Ind],[HesapKodu],[HesapAdi],0,SUM([Bakiye]) Bakiye_2023 from [HakanHitit].[dbo].[KKartlariWithBakiye]
GROUP BY [Owner],[BankaInd],[Ind],[HesapKodu],[HesapAdi]  

OPEN DevirKKUpdate;  
FETCH NEXT FROM DevirKKUpdate INTO @Owner,@BankaInd,@Ind,@HesapKodu,@HesapAdi,@DevirBakiye2022 ,@DevirBakiye2023

WHILE @@FETCH_STATUS = 0  
BEGIN

IF EXISTS(SELECT * FROM #DevirKKKontrol WHERE Ind = @Ind)
   BEGIN
      UPDATE #DevirKKKontrol SET DevirBakiye2023 = @DevirBakiye2023 where Ind = @Ind
   END
ELSE
	BEGIN
		INSERT INTO  #DevirKKKontrol
	    ( [Owner],[BankaInd],[Ind],[HesapKodu],[HesapAdi],DevirBakiye2022,DevirBakiye2023  ) VALUES ( @Owner,@BankaInd,@Ind,@HesapKodu,@HesapAdi,@DevirBakiye2022,@DevirBakiye2023 )
    END
FETCH NEXT FROM DevirKKUpdate INTO @Owner,@BankaInd,@Ind,@HesapKodu,@HesapAdi,@DevirBakiye2022 ,@DevirBakiye2023 
END
CLOSE DevirKKUpdate;  
DEALLOCATE DevirKKUpdate;
 
SELECT [Owner],[BankaInd],[Ind],[HesapKodu],[HesapAdi],   FORMAT(DevirBakiye2022, 'C', 'tr-TR') DevirBakiye2022,   FORMAT(DevirBakiye2023, 'C', 'tr-TR')  DevirBakiye2023,
FORMAT(DevirBakiye2022-DevirBakiye2023, 'C', 'tr-TR') as Fark FROM #DevirKKKontrol where DevirBakiye2022 != DevirBakiye2023  
order by Ind
DROP TABLE #DevirKKKontrol