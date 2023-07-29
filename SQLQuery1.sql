declare @isim nvarchar(max)
set @isim ='opet'

if @isim='opet'
	begin
	print 'yes'
	select @isim
	end
else
	print 'hayýr'
	-----------------------------------------------------
	select * from  Hesaplar where HesapAdi like 'opet%'
	If @@ROWCOUNT>0
	begin
		print 'evet'
		print 'evet evet'
	end
	else
		begin
		print 'hayýr'
		print 'hayýr hayýr'
		end
		---------------------------------------------
declare @adi nvarchar(max)='VEDAT CARÝSÝ', @kodu nvarchar(max)='C9999'
select * from Hesaplar where HesapAdi=@adi and HesapKodu=@kodu
If @@ROWCOUNT >0 
print 'evet'
else 
begin

print 'hayýr'
print 'ekleniyor..'
Insert Hesaplar(HesapAdi,HesapKodu,TipInd) Values(@adi,@kodu,201)
end




