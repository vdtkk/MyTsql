
--select * from Hareketler where BaslikInd='499469'
   


  declare @stokkodu nvarchar(50),@stokAdi nvarchar(50), @stokInd nvarchar(10)
  declare cursor_yapi cursor for select StokKodu,StokAdi,StokInd from Hareketler where TipInd=3 and BaslikInd=499469  and  Owner=2
  open cursor_yapi
  fetch next from cursor_yapi Into @stokkodu, @stokAdi,@stokInd
  while @@FETCH_STATUS=0
	begin
	update Hareketler set StokKodu=@stokkodu ,StokAdi=@stokAdi where StokInd=@stokInd and  TipInd=29 and BaslikInd=499469 
  print @stokkodu
  fetch next from cursor_yapi Into @stokkodu,@stokAdi,@stokInd
  end
  close cursor_yapi
  deallocate cursor_yapi
