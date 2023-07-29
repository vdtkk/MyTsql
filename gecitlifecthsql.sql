USE gecitli
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DECLARE  @PerakendeTarih dateTime,@StokInd int,@Miktar int,@TipInd int

DECLARE Hareketler_cursor CURSOR FOR  
SELECT  PerakendeKasaIslemTarihi ,StokInd,Miktar,TipInd from Hareketler where StokInd IN(2259) and TipInd=504 

OPEN Hareketler_cursor;  
-- Perform the first fetch.  
FETCH NEXT FROM Hareketler_cursor INTO  @PerakendeTarih,@StokInd,@Miktar,@TipInd
     

-- Check @@FETCH_STATUS to see if there are any more rows to fetch.  
WHILE @@FETCH_STATUS = 0  
BEGIN  
    -- This is executed as long as the previous fetch succeeds. 
    print 'Stok okundu..'
	 print  @StokInd
	 print 'Tarih:'
	 print @PerakendeTarih
   IF EXISTS (SELECT Top 1 Ind FROM Hareketler Where StokInd =@StokInd and PerakendeKasaIslemTarihi = @PerakendeTarih and TipInd=30 ) 
   BEGIN 
  print 'update oluyor..'
	 print  @StokInd
       UPDATE Hareketler SET Miktar = @Miktar Where StokInd =@StokInd and PerakendeKasaIslemTarihi = @PerakendeTarih and TipInd=30 
   END
  ELSE
     BEGIN
	  print 'ýnsert ediliyor.....'
	 print  @StokInd
	    INSERT INTO Hareketler (Owner,TipInd,Aciklama,StokInd,StokKodu,StokAdi,Miktar,SatisFiyati,AnaBirimAdi,BirimAdi,Carpan,Fiyat,KDVOrani,Iskonto,
           DepoInd,DepoKodu,DepoAdi,DurumInd,PerakendeInd,NetMiktar,PerakendeKasaIslemTarihi,OTVTutar) 
		   SELECT Top 1 Owner,30,Aciklama,StokInd,StokKodu,StokAdi,Miktar,0 ,AnaBirimAdi,BirimAdi,Carpan,Fiyat,KDVOrani,Iskonto,
           DepoInd,DepoKodu,DepoAdi,0,PerakendeInd,0 ,PerakendeKasaIslemTarihi,0 
           FROM Hareketler where StokInd=1088 and TipInd=504 AND   PerakendeKasaIslemTarihi=@PerakendeTarih;
	 END	  
 
FETCH NEXT FROM Hareketler_cursor INTO  @PerakendeTarih,@StokInd,@Miktar,@TipInd

END
CLOSE Hareketler_cursor;  
DEALLOCATE Hareketler_cursor;  

 

