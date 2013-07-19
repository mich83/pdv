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
		table = jQuery("#dialog2").append("<table>")
		table.append('<tr><th>'+"Наименование в файле"+'</th><th>Товар</th></tr>')
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
			table.append("<tr><td>"+createbutton+row.item+'</td><td><input class="hidden_dialog_id" id="item_doc_item_doc_rows_attributes_loadfrm'+idstr+'_good_id" type="hidden" value="'+val+'"> <input type="label" size=50 disabled="disabled" value="'+name+'"></td></tr>')
			idstr = idstr+1
	else
		alert("Не верный формат файла!")
window.uploader = () -> 
	new qq.FileUploader({element: jQuery('#file-uploader')[0],action: '/parse',	debug: true,onComplete: window.OnUpload})
	
window.onload = window.uploader