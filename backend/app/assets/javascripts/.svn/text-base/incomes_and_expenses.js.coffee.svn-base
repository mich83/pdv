# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
window.LoadData = (data) ->
	jQuery("#dialog").append(data)

window.OpenDoc = (url) ->
	jQuery("#dialog").dialog({modal:true,autoopen:false,width:1000,height:600})
	jQuery("#dialog").empty()
	jQuery.get(url,LoadData)
	
