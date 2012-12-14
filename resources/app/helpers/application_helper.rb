module ApplicationHelper

	# Page Titles - Set individual page title elements
  # Accepts a String or Array.
  # Sets yield(:title) to a String for use in <title>.
  # 
  #   --Array--
  #   title ["Example", "Nashville, TN"]
  #   => "Example - Page - Title"
  # 
  #   --String--
  #   title "Example Page Title"
  #   => "Example Page Title"
  # 
  def title title_partials
    title = if title_partials.is_a? String
      title_partials
    elsif title_partials.is_a? Array
      title_partials.reject(&:blank?).join(' - ')
    end
    content_for(:title) { title }
  end
  
	
	# 
	# Yes -or- No
	# 
	def yes_no(bool)
		bool ? 'Yes' : 'No'
	end

	
	# 
	# Enabled -or- Disabled
	# 
	def enabled_disabled(bool)
		bool ? 'Enabled' : 'Disabled'
	end
	
	
	# 
	# Substitute N/A for blank data
	# 
	def check(data)
		data.blank? ? 'N/A' : data
	end
	
	
	
	# 
	# Date: Jan 1, 2012
	# 
	def date_short(date)
		date.strftime("%b %e, %Y") if !date.blank?
	end
	
	
	# 
	# Date: 1/1/2012
	# 
	def date_compact(date)
		date.strftime("%-m/%-d/%Y") if !date.blank?
	end
	
	
	# 
	# Substitute empty string for blank data
	# 
	def exists?(data)
		data.blank? ? '' : data
	end
	
	
	
	
	
	
	# 
	# Alternate object debug
	# 
	def mdebug(object)
		d = object.attributes.inspect.split(',')
		d.map! {|i| i.to_s + '<br>'}
		d.join.delete("{").delete("}")
	end
	
end
