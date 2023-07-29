/****** Script for SelectTopNRows command from SSMS  ******/
SELECT StokInd, StokAdi,*
  FROM [kule].[dbo].[Hareketler] where TipInd=504 



  declare @barkod nvarchar(max)
  declare cursor_duzeltme cursor for select StokKodu from Hareketler where TipInd=504 
  open cursor_duzeltme

  fetch next from cursor_duzeltme INTO @barkod
  WHILE @@FETCH_STATUS =0
  BEGIN
  print @barkod
	update Hareketler set Barkod=@barkod where TipInd=504 
	print @barkod
	 fetch next from cursor_duzeltme INTO @barkod
	 end
	 close cursor_duzeltme
	 deallocate cursor_duzeltme