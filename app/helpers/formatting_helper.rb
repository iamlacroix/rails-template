module FormattingHelper
	
	def yes_no(bool)
		bool ? 'Yes' : 'No'
	end
	
	def enabled_disabled(bool)
		bool ? 'Enabled' : 'Disabled'
	end
	
	
	# def yes_no_embedded(bool)
	# 	bool ? 'Yes' : 'No'
	# end
	
	
	def check(data)
		data.blank? ? 'N/A' : data
	end
	
	
	# Only if UserDetail exists
	def check_embedded(data, document)
		document && !document.read_attribute(data).blank? ? document.read_attribute(data) : 'N/A'
	end
	
	
	def check_step(blogger)
		case blogger.step
		when nil
			blogger.approved ? '<i class="icon-ok-sign icon-white"></i> Activated' : '<i class="icon-question-sign icon-white"></i> Approval'
		when "2"
			'<i class="icon-list-alt icon-white"></i> Step 2'
		when "3"
			'<i class="icon-list-alt icon-white"></i> Step 3'
		else
			'N/A'
		end
	end
	
	
	def check_step_label(blogger)
		case blogger.step
		when nil
			blogger.approved ? 'label-success' : 'label-warning'
			# TODO add 'activation required' ?? (red) -> 'label-important'
		# when "2"
		# 	'label-warning'
		# when "3"
		# 	'label-warning'
		# else
		# 	''
		end
	end
	
	
	def check_unsanitized(data)
		data.blank? ? 'N/A' : simple_format(data, {}, :sanitize => false)
	end
	
	
	def date_short(date)
		date.strftime("%b %e, %Y") if !date.blank?
	end
	
	
	def date_compact(date)
		date.strftime("%-m/%-d/%Y") if !date.blank?
	end
	
	
	def exists?(data)
		data.blank? ? '' : data
	end
	
	
	# Login Check -- Name/Email
	def login_or_name
		current_user ? current_user.role.name_or_email : 'Sign In'
	end
	
	
	
	
	
	
	# def video_link(vimeo_id)
	# 	# !vimeo_id.blank? ? '<a href="http://player.vimeo.com/video/' + vimeo_id + '?title=0&byline=0&portrait=0&color=E11734&api=1" target="_blank">Yes</a>' : 'No'
	# 	!vimeo_id.blank? ? '<a href="http://vimeo.com/' + vimeo_id + '" target="_blank">Yes</a>' : 'No'
	# end
	
	
	# def show_news_image(news_item, size)
	# 	if !news_item.news_image.size.blank?
	# 		news_item.news_image(size)
	# 	elsif !news_item.bus_stop_id.blank?
	# 		news_item.bus_stop.photos.order("position asc").sample.image(:large)
	# 	else
	# 		'news-item-default.jpeg'
	# 	end
	# end
	
	
	# def news_item_link(news_item)
	# 	if !news_item.body.blank?
	# 		remote = false # True when using AJAX
	# 		href = news_item_path(news_item)
	# 		cls = 'read-more'
	# 		target = '_self'
	# 	else
	# 		remote = false
	# 		href = news_item.source_link.start_with?("http://") ? news_item.source_link : ("http://" + news_item.source_link)
	# 		cls = ''
	# 		target = '_blank'
	# 	end
	# 	link_to 'Read More', href, {:class => cls, :target => target, :remote => remote}
	# end
	
	
	# def carousel_hashlinks(link, url)
	# 	url == root_url ? link : (root_url + link)
	# end
	
	
	def mdebug(object)
		d = object.attributes.inspect.split(',')
		d.map! {|i| i.to_s + '<br>'}
		d.join.delete("{").delete("}")
	end
	
end