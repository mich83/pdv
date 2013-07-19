# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.MakeBarCode = (dest,id) ->
	start = "2"
	start = start+"0" while start.length+id.length < 12
	start = start+id
	odd = 0
	even = 0
	for i in [1..12]
		digit = parseInt(start[i-1])
		if i % 2 
			even = even+digit
		else
			odd = odd+digit
	sum = even*3 + odd
	csum = sum % 10
	if csum != 0 
		csum = 10-csum
	dest.value = start+csum