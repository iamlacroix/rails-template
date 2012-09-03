$(document).ready ->

	if $('#fileupload').size()
		# Initialize the jQuery File Upload widget:
		$('#fileupload').fileupload()
		# 
		# Load existing files:
		$.getJSON $('#fileupload').prop('action'), (files)->
			fu = $('#fileupload').data('fileupload')
			fu._adjustMaxNumberOfFiles(-files.length)
			template = fu._renderDownload(files).appendTo($('#fileupload .files'))
			# Force reflow:
			fu._reflow = fu._transition && template.length && template[0].offsetWidth
			template.addClass('in')
			$('#loading').remove()
		
		
		$('#fileupload').bind('fileuploadstart', (e)->
			# Show loading gif
			$('.loading-bar div').fadeIn()
		).bind 'fileuploadstop', (e)->
			# Hide loading gif
			$('.loading-bar div').fadeOut()
