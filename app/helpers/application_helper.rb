module ApplicationHelper
  def money_format(money)
    number_to_currency(money, :delimiter => '.', :unit => '', :precision => 0)
  end

  def number_format(number)
    number_with_precision(number, :strip_insignificant_zeros => true)
  end

  def iconed_text(icon, text)
    "<span class='#{icon}'></span>#{text}".html_safe
  end

  def terbilang(angka)
    satuan = [''] + %w{satu dua tiga empat lima enam tujuh delapan sembilan sepuluh sebelas}.collect{|x|x+' '}
    triple = [['puluh',10,20,100],['ratus',100,200,1000],['ribu',1000,2000,1000000],['juta',1000000,1000000,1000000000],['milyar',1000000000,1000000000,1000000000000]]
    hasil = satuan[angka] if angka<12
    hasil = terbilang(angka.divmod(10)[1]) + 'belas ' if angka>=12 and angka<20
    hasil = 'seratus '+terbilang(angka-100) if angka>=100 and angka<200
    hasil = 'seribu ' +terbilang(angka-1000) if angka>=1000 and angka<2000
    triple.each{|x|hasil = terbilang(angka.divmod(x[1])[0])+x[0]+' '+terbilang(angka.divmod(x[1])[1]) if angka>=x[2] and angka<x[3]}
    hasil
  end

  def date_format_id(date)
    bulan = [''] + %w{Januari Februari Maret April Mei Juni Juli Agustus September Oktober November Desember}
    "#{date.strftime("%d")} - #{bulan[date.strftime("%m").to_i]} - #{date.strftime("%Y")}"
  end
end
