# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

GetID = (element) ->
  names = element.id.split "_"
  id = names[6]
  if id is "new" then id = "new_"+names[7]
  id

get_style = (element) ->
	if element.currentStyle then element.currentStyle else if window.getComputedStyle then window.getComputedStyle(element, null)

SetClientList = (data) ->
	clientlist = jQuery("select#item_doc_card_id")[0]
	oldvalue = clientlist.value
	clientlist.options.length = 0
	clientlist.options[0] = new Option("","")
	clientlist.options[clientlist.options.length] = new Option(client.lastname+" "+client.name+" "+client.surname, client.id) for client in data
	clientlist.value = oldvalue
	
window.UpdateVisibility = () ->
	opcode = parseInt(jQuery("select#item_doc_opcode").attr("value"))
	layer = jQuery("div#client_div")
	stock_layer = jQuery("div#stock_dest_div")
	if opcode < 3 or opcode>6
		layer.hide() 
		jQuery("select#item_doc_card_id").val("")
		if opcode > 6
			stock_layer.show()
		else
			jQuery("select#item_doc_stock_dest_id").val("")
			stock_layer.hide()
	else 
		stock_layer.hide()
		jQuery("select#item_doc_stock_dest_id").val("")
		layer.show()
		if opcode < 5 
			jQuery.getJSON('/suppliers.json',SetClientList)
		else
			jQuery.getJSON('/buyers.json',SetClientList)

window.UpdateTotals = () ->
  total = 0
  jQuery("input.sum").each((item,element)-> if (GetID(element) isnt "new_item")and(get_style(element.parentElement.parentElement)["display"] isnt "none") then total=total+parseFloat element.value)
  jQuery("label#total").html(total)

window.PriceOnChange = (element) ->
  id = GetID element
  price = jQuery("input#item_doc_item_doc_rows_attributes_"+id+"_price").attr("value")
  qty = jQuery("input#item_doc_item_doc_rows_attributes_"+id+"_quantity").attr("value")
  sum = price*qty
  jQuery("input#item_doc_item_doc_rows_attributes_"+id+"_sum").attr("value",sum)
  window.UpdateTotals()

  
window.QuantityOnChange = (element) ->
  id = GetID element
  price = jQuery("input#item_doc_item_doc_rows_attributes_"+id+"_price").attr("value")
  qty = jQuery("input#item_doc_item_doc_rows_attributes_"+id+"_quantity").attr("value")
  sum = price*qty
  jQuery("input#item_doc_item_doc_rows_attributes_"+id+"_sum").attr("value",sum)
  window.UpdateTotals()


window.SumOnChange = (element) ->
  id = GetID element
  sum = jQuery("input#item_doc_item_doc_rows_attributes_"+id+"_sum").attr("value")
  qty = jQuery("input#item_doc_item_doc_rows_attributes_"+id+"_quantity").attr("value")
  price = sum/qty
  jQuery("input#item_doc_item_doc_rows_attributes_"+id+"_price").attr("value",price)
  window.UpdateTotals()

SetPrice = (data) ->
	if data.price is null then price=0 else price=data.price
	jQuery("input#item_doc_item_doc_rows_attributes_"+data.target+"_price").attr("value",price)
	qty = jQuery("input#item_doc_item_doc_rows_attributes_"+data.target+"_quantity").attr("value")
	jQuery("input#item_doc_item_doc_rows_attributes_"+data.target+"_sum").attr("value",price*qty)
	window.UpdateTotals()
	
ItemIterator = (index,element) -> 
	ID = GetID element
	if ID isnt "new_item" 
		url = "/price/"+element.value+"/"+jQuery("select#item_doc_price_type_id").attr("value")+"/"+ID
		jQuery.getJSON(url,SetPrice)

window.PriceTypeOnChange = () ->
	if window.confirm "Изменить цены?"
		jQuery("input.item").each(ItemIterator) 
		  
window.ItemOnChange = (element) ->
  ItemIterator(0,element)

window.GoodSelect = (target,id,name) ->
	field = jQuery("#item_doc_item_doc_rows_attributes_"+target+"_good_id")[0]
	field.value = id
	field.parentNode.childNodes[2].value=name
	jQuery("#dialog").dialog("close")
	ItemOnChange(field)

fillGoods = (data) ->
	jQuery("#dialog_refs").empty()
	jQuery("#dialog_refs").append('<a href="'+"javascript:GoodSelect('"+data.target+"','"+item.id+"','"+item.name+"')"+'">'+item.name+"</a><br>") for item in data.items
	
window.GetData = (target, tag_id) ->
	url = "/goods/tag/"+tag_id+"/"+target+".json"
	jQuery.getJSON(url, fillGoods)

window.SearchData = (tg,st) ->
	jQuery.post("/search.json",{target:tg,search:st},fillGoods,'json')
	
ShowDialog = (data) ->
	jQuery("#dialog").dialog({modal:true,autoopen:false,width:1000,height:600})
	jQuery("#dialog").empty()
	jQuery("#dialog").append('<div id="dialog_search", style="width:980px"><input type="text" style="width:470px;" onchange="javascript:SearchData('+"'"+data.target+"'"+',this.value)"></div>')
	jQuery("#dialog").append('<div id="dialog_tags" style="width:300px;"></div>')
	jQuery("#dialog").append('<div id="dialog_refs" style="width:550px;position:absolute;top:35px;left:350px;"></div>')
	tbl = "<table>"
	for tag_group in data.items
		tbl=tbl+"<tr><td colspan=2>"+tag_group.key+"</td><td width=30></td></tr>"
		for tag in tag_group.value
			tbl=tbl+'<tr><td width="30px"></td><td width=270><a href="'+"javascript:GetData('"+data.target+"','"+tag.id+"')"+'">'+tag.name+"</a></td><td></td></tr>"
	tbl=tbl+"</table>"
	jQuery("#dialog_tags").append(tbl)
	window.GetData(data.target,data.items[0].id)
	jQuery("#dialog").dialog("open")
	
window.EditItem = (element) ->
  ID = GetID(element.parentElement.childNodes[0])
  url = "/jtags/"+ID+".json"
  jQuery.getJSON(url,ShowDialog)

ParseConfirm = () ->
	allow = true
	for element in jQuery(".hidden_dialog_id")
		if element.value == "" 
			allow = false 
	if allow
		jQuery("#dialog2").dialog("close")
		ref = jQuery("a.add_nested_fields")
		for element in jQuery(".hidden_dialog_id")
			ref.click()
		lines = jQuery("[id$='_price']").filter('[id!="item_doc_item_doc_rows_attributes_new_item_doc_rows_price"]').filter(':visible')
		idx = 0
		for element in jQuery(".hidden_dialog_id")
			obj_id = element.value
			obj_name = element.parentNode.childNodes[2].value
			name_in_file = element.parentNode.parentNode.childNodes[0].innerText.replace('Создать товар','')
			if obj_name != name_in_file
				if confirm("Для товара "+name_in_file+" вы выбрали товар "+obj_name+". Переименовать товар в БД?")
					url = '/goods/rename'
					jQuery.post(url,{id:obj_id,new_name:name_in_file})
					obj_name = name_in_file
			row = element.parentNode.parentNode.childNodes
			qty = row[2].innerText
			price = row[3].innerText
			total = row[4].innerText
			ID = GetID(lines[idx])
			field = jQuery("#item_doc_item_doc_rows_attributes_"+ID+"_good_id")[0]
			field.value = obj_id
			field.parentNode.childNodes[2].value=obj_name
			jQuery("input#item_doc_item_doc_rows_attributes_"+ID+"_price").attr("value",price)
			jQuery("input#item_doc_item_doc_rows_attributes_"+ID+"_sum").attr("value",total)
			jQuery("input#item_doc_item_doc_rows_attributes_"+ID+"_quantity").attr("value",qty)
			idx++
		window.UpdateTotals()
	else
		alert("Не все товары выбраны!")

GoodCreated = (response) ->
	button = jQuery("#lastcreatebutton")[0]
	cell = button.parentNode
	block = cell.parentNode.childNodes[1]
	block.childNodes[0].value = response.id
	block.childNodes[2].value = response.name
	cell.removeChild(button)
		
window.CreateGood = (g_name, origin) ->
	origin.id = "lastcreatebutton"
	token = jQuery('[name="authenticity_token"]').attr('value')
	data = {authenticity_token: token, utf8: true, good: {name: g_name}, create_tags: 1}
	jQuery.post("/goods.json",data,GoodCreated)
	

window.OnUpload = (id,filename,response) ->
	if response.success
		jQuery("#dialog2").dialog({modal:true,autoopen:false,width:1450,height:750,buttons:[{text:"OK", click:ParseConfirm}]})
		jQuery("#dialog2").empty()
		table = jQuery("#dialog2").append("<table>")
		table.append('<tr><th>'+"Наименование в файле"+'</th><th>Товар</th><th>'+"Штук"+'</th><th>'+"Цена"+'</th><th>'+"Сумма"+'</th></tr>')
		idstr = 100
		for row in response.data 
			if row.item_obj == null
				name = ""
				val = ""
				createbutton = '<button onclick="CreateGood('+"'"+row.item+"'"+',this)">Создать товар</button>'
			else
				name = row.item_title
				val = row.item_obj
				createbutton = ''
			table.append("<tr><td>"+row.item+createbutton+'</td><td><input class="hidden_dialog_id" id="item_doc_item_doc_rows_attributes_loadfrm'+idstr+'_good_id" type="hidden" value="'+val+'"> <input type="text" size=80 disabled="disabled" value="'+name+'"> <button name="button" onclick="EditItem(this);" style="width:20px;padding:0px;" type="button">...</button></td><td>'+row.qty+"</td><td>"+row.price+"</td><td>"+row.total+"</td></tr>")
			idstr = idstr+1
		jQuery("#dialog2").dialog("open")
	else
		alert("Не верный формат файла!")
	
window.uploader = () -> 
	new qq.FileUploader({element: jQuery('#file-uploader')[0],action: '/parse',	debug: true,onComplete: window.OnUpload})
	
window.onload = window.uploader

OnPricesUpdate = (response) ->
	alert "Цены успешно обновлены!"
	
window.UpdatePrices = () ->
	token = jQuery('[name="authenticity_token"]').attr('value')
	pricetype = jQuery("#item_doc_price_type_id")[0].value
	objects = []
	for tag in jQuery(".price")
		if tag.value != "" 
			good_id = tag.parentElement.parentElement.children[0].children[0].value
			objects.push({good: good_id, price: tag.value})
	data = {authenticity_token: token, utf8: true, price_type: pricetype, prices: objects}
	jQuery.post("/price_update",data,OnPricesUpdate)
