$ ->
  $.setAjaxPagination = ->
    $('.pagination a').click (event) ->
      event.preventDefault()
      loading = $ '<div id="loading" style="display: none;"><span><img src="/assets/ajax-loader.gif" alt="cargando..."/></span></div>'
      $('.other_images').prepend loading
      loading.fadeIn()
      $.ajax type: 'GET', url: $(@).attr('href'), dataType: 'script', success: (-> loading.fadeOut -> loading.remove())
      false

  $.setAjaxPagination()


sum_all = (delivery_cost, sum_sub_total, duration) ->
    delivery_cost = 0 if delivery_cost == ''
    duration = 0 if duration == ''
    parseFloat(delivery_cost) + (parseFloat(sum_sub_total) * parseFloat(duration))

divmodBasic = (x, y) ->
  return [(q = Math.floor(x/y)), (r = if x < y then x else x % y)]

terbilang = (amount, pertama = true) ->
    hasil = "" if pertama
    pertama = false
    angka = parseInt(amount)
    satuan = ["", "satu ", "dua ", "tiga ", "empat ", "lima ", "enam ", "tujuh ", "delapan ", "sembilan ", "sepuluh ", "sebelas "]
    triple = [['puluh',10,20,100],['ratus',100,200,1000],['ribu',1000,2000,1000000],['juta',1000000,1000000,1000000000],['milyar',1000000000,1000000000,1000000000000]]
    hasil = hasil + satuan[angka] if angka < 12
    hasil = hasil + terbilang(divmodBasic(angka,10)[1]) + 'belas ' if angka >= 12 and angka < 20
    hasil = hasil + 'seratus ' + terbilang(angka - 100) if angka >= 100 and angka < 200
    hasil = hasil + 'seribu ' + terbilang(angka - 1000) if angka >= 1000 and angka < 2000
    for x in triple then hasil = hasil + terbilang(divmodBasic(angka, x[1])[0]) + x[0] + ' ' + terbilang(divmodBasic(angka, x[1])[1]) if angka >= x[2] and angka < x[3]
    hasil

diff_all = (total, payment) ->
    total = 0 if total == ''
    payment = 0 if payment == ''
    diff = parseFloat(total) - parseFloat(payment)
    diff

numberFormat = (value) ->
    output = value.toString()
    sRegExp = RegExp("(-?[0-9]+)([0-9]{3})")
    while sRegExp.test(output)
      output = output.replace(sRegExp, "$1,$2")
    return output

normalFormat = (value) ->
    output = value.replace(/,/gi, "")
    return output

$(document).ready ->
    payment_amount = $("#payment_amount")
    delivery_cost = $("#order_delivery_cost")
    sum_sub_total = $("#sum_sub_total")
    duration = $("#order_duration_in_days")
    order_payment_status = $("#order_payment_status")
    payment = $("#payment")

    payment_amount.hide()
    
    order_payment_status.change ->
        if (order_payment_status.val() == 'Down Payment')
            payment_amount.slideDown("slow")
        else
            payment_amount.slideUp("slow")

    payment.keyup (e) ->
        value_t = normalFormat($("#total").val())
        value_p = normalFormat($("#payment").val())
        payment.val(numberFormat(value_p))
        total = value_t - value_p
        $("#remain").val(numberFormat(total))
        $("#terbilang_remain").val(terbilang(total))
    
    delivery_cost.keyup (e) ->
        value_dc = normalFormat(delivery_cost.val())
        value_sst = normalFormat(sum_sub_total.val())
        value_dt = duration.val()
        value_p = normalFormat(payment.val())
        delivery_cost.val(numberFormat(value_dc))
        total = sum_all(value_dc, value_sst, value_dt)
        $("#total").val(numberFormat(total))
        $("#remain").val(numberFormat(total - value_p))
        $("#terbilang").val(terbilang(total) + 'rupiah')
        $("#terbilang_remain").val(terbilang(total - value_p))

    duration.keyup (e) ->
        value_dc = normalFormat(delivery_cost.val())
        value_sst = normalFormat(sum_sub_total.val())
        value_dt = duration.val()
        value_p = normalFormat(payment.val())
        total = sum_all(value_dc, value_sst, value_dt)
        $("#total").val(numberFormat(total))
        $("#remain").val(numberFormat(total - value_p))
        $("#terbilang").val(terbilang(total) + 'rupiah')
        $("#terbilang_remain").val(terbilang(total - value_p))
