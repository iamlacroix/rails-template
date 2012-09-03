$(document).ready ->
	
	# Enable form input on Dropdowns
	$('.dropdown-menu').find('form').click (e)->
		e.stopPropagation()
	
	
	# Auto-close Success alerts
	$(".alert.alert-success").each ->
		e = $(this)
		setTimeout ->
			e.alert('close')
		,
			7000
			
			
	# Enable Placeholder on legacy browsers
	$('input[placeholder], textarea[placeholder]').placeholder()