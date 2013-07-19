# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

ValueRecieved = (data) ->
	jQuery("#value_"+data.stock_id)[0].innerHTML = data.value

window.OnSelectPriceType = (elem) ->
	stock_id = elem.name.replace "pricetype_", ""
	price_id = elem.value
	if price_id == ""
		jQuery("#value_"+stock_id)[0].innerHTML = 0
	else
		jQuery.getJSON('/stocks/value/'+stock_id+'/'+price_id,ValueRecieved)
	