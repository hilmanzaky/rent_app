# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

setToNumberFormat = (value) ->
    element = $('#' + value)
    normal = normalFormat(element.val())
    element.val(numberFormat(normal))


jQuery ->
  $('.best_in_place').best_in_place()
  $('.best_in_place').click (event) ->
    $('.bip_sub_total').keyup (e) ->
        setToNumberFormat(e.target.id)


numberFormat = (value) ->
    output = value.toString()
    sRegExp = RegExp("(-?[0-9]+)([0-9]{3})")
    while sRegExp.test(output)
      output = output.replace(sRegExp, "$1,$2")
    return output

normalFormat = (value) ->
    output = value.replace(/,/gi, "")
    return output

# $(document).live ->
#    $('.bip_sub_total').click (event) ->
#        alert(event.target.id)