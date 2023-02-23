
Declare @StokInd int
Declare @StokAdi nvarchar(100)
Declare @Owner int
Declare @DevirBakiye2022 Float
Declare @DevirBakiye2023 Float
Declare @DevirTarihi DateTime
 
SET @DevirTarihi = '2022-12-31'

 
CREATE TABLE #SayimStokKontrol (StokInd INT, StokAdi VARCHAR(100),[Owner] int,DevirBakiye2022 float,DevirBakiye2023 float)     
DECLARE   DevirStokUpdate CURSOR FOR
SELECT [Owner],Ind,StokAdi,SUM(Miktar) as DevirBakiye2022, 0 DevirBakiye2023 from  [BozkanIstanbul].[dbo].[EnvanterRaporuPerakendeAnlikFIFOSube] (2,'2022-12-31',0)  SH
Group By  [Owner],Ind,StokAdi
UNION ALL
SELECT [Owner],Ind,StokAdi, 0 DevirBakiye2022,SUM(Miktar) as DevirBakiye2023 from  [2022_BozkanIstanbult].[dbo].[EnvanterRaporuPerakendeAnlikFIFOSube] (2,'2022-12-31',0)  SH
Group By  [Owner],Ind,StokAdi

OPEN DevirStokUpdate;  
FETCH NEXT FROM DevirStokUpdate INTO @Owner,@StokInd,@StokAdi,@DevirBakiye2022 ,@DevirBakiye2023

WHILE @@FETCH_STATUS = 0  
BEGIN

IF EXISTS(SELECT * FROM #SayimStokKontrol WHERE StokInd = @StokInd)
   BEGIN
      UPDATE #SayimStokKontrol SET DevirBakiye2023 = @DevirBakiye2023 where StokInd = @StokInd
   END
ELSE
	BEGIN
		INSERT INTO  #SayimStokKontrol
	    ( Owner,StokInd,StokAdi,DevirBakiye2022,DevirBakiye2023  ) VALUES ( @owner,@StokInd,@StokAdi,@DevirBakiye2022,@DevirBakiye2023 )
    END
FETCH NEXT FROM DevirStokUpdate INTO @Owner,@StokInd,@StokAdi,@DevirBakiye2022 ,@DevirBakiye2023
END
CLOSE DevirStokUpdate;  
DEALLOCATE DevirStokUpdate;

  IF EXISTS(SELECT Owner,StokInd,StokAdi,DevirBakiye2022,DevirBakiye2023,DevirBakiye2022-DevirBakiye2023 as Fark FROM #SayimStokKontrol where DevirBakiye2022 != DevirBakiye2023 )
  BEGIN
	Select 'Hatalý Kayýtlarý getirir' as HataSebebi
	Declare @StokInd_ int
	Declare	@StokAdi_ nvarchar(100)
	Declare	@Owner_ int
	Declare @Miktar_ Float
	 
	DECLARE   DevirStokHata CURSOR FOR
	SELECT Owner,StokInd,StokAdi,DevirBakiye2022,DevirBakiye2023,DevirBakiye2022-DevirBakiye2023 as Fark FROM #SayimStokKontrol where DevirBakiye2022 != DevirBakiye2023 order by StokInd
	OPEN DevirStokHata;  
	FETCH NEXT FROM DevirStokHata INTO @Owner_,@StokInd_,@StokAdi_,@Miktar_
	WHILE @@FETCH_STATUS = 0  
	BEGIN
	FETCH NEXT FROM DevirStokHata INTO @Owner_,@StokInd_,@StokAdi_,@Miktar_
	END
	CLOSE DevirStokHata;  
	DEALLOCATE DevirStokHata;
  END
  ELSE
	BEGIN
		Select 'Hatalý Kayýt Yok' as HataSebebi
	END
DROP TABLE #SayimStokKontrol