$(window).load ->
	
	init_google_maps = ->
		
		lat = parseFloat $('#map-canvas').attr('data-lat')
		lng = parseFloat $('#map-canvas').attr('data-lng')
		location = new google.maps.LatLng(lat, lng)
		
		myOptions =
			# center: new google.maps.LatLng(36.14249, -86.818855)
			# center: new google.maps.LatLng(-34.397, 150.644)
			center: location
			zoom: 9
			disableDefaultUI: true
			mapTypeId: google.maps.MapTypeId.ROADMAP
			
		map = new google.maps.Map( document.getElementById('map-canvas'), myOptions )
		
		marker = new google.maps.Marker(
			position: location
		)
		
		marker.setMap(map)
	
	
	init_google_maps()