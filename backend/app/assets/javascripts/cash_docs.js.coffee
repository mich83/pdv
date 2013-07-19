# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

SetClientList = (data) ->
	clientlist = jQuery("select#cash_doc_card_id")[0]
	oldvalue = clientlist.value
	clientlist.options.length = 0
	clientlist.options[0] = new Option("","")
	clientlist.options[clientlist.options.length] = new Option(client.lastname+" "+client.name+" "+client.surname, client.id) for client in data
	clientlist.value = oldvalue

window.UpdateVisibility = () ->
	opcode = parseInt(jQuery("select#cash_doc_opcode").attr("value"))
	layer = jQuery("div#client_div")
	if opcode > 2 
		jQuery.getJSON('/suppliers.json',SetClientList)
	else
		jQuery.getJSON('/buyers.json',SetClientList)

