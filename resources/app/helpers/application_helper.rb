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

  # Flash Messages
  # Iterate through each standard flash type
  # Detect whether the alert is a Hash -or- String
  # 
  #   --String--
  #   flash.notice = "Example title"
  # 
  #   --Hash--
  #   flash.notice = { title: "Example title", message: "Expanded detailed message." }
  # 
  def flash_helper
    flash_types = { message: 'bullhorn', 
        notice: 'ok', 
        warning: 'warning-sign', 
        alert: 'exclamation-sign' }
    flash_messages = []
    flash_types.each do |type, icon|
      # --- Check if this :type exists
      if flash[type]
        if flash[type].is_a?(Hash)
          # --- Format => { title: "Alert Title", message: "Longer alert message detail." }
          title   = flash[type].fetch(:title, nil)
          message = flash[type].fetch(:message, nil)
        elsif flash[type].is_a?(String)
          title   = flash[type]
        end
        # --- Skip if title was not set
        if title
          alert =  "<li class=\"#{type}\"><a class=\"close\" href=\"#\">x</a>"
          alert += "<div class=\"inner\"><div class=\"content\">"
          alert += "<div class=\"title\"><p><i class=\"icon-#{icon}\"></i> #{title} "
          # alert += "<i class=\"icon-caret-down\"></i> " if message
          alert += "<small>@ #{Time.now.strftime("%l:%M%P : %Ss")}</small></p></div>"
          alert += "<div class=\"message\"><p>#{message}</p></div>" if message
          alert += "</div></div></li>"
          flash_messages << alert
        end
      end
    end
    flash_messages.join
  end
  
  # Yes -or- No
  # 
  def yes_no(bool)
    bool ? 'Yes' : 'No'
  end
  
  # Enabled -or- Disabled
  # 
  def enabled_disabled(bool)
    bool ? 'Enabled' : 'Disabled'
  end  
  
  # Substitute N/A for blank data
  # 
  def check(data)
    data.blank? ? 'N/A' : data
  end  
  
  # Date: Jan 1, 2012
  # 
  def date_short(date)
    date.strftime("%b %e, %Y") unless date.blank?
  end  
  
  # Date: 1/1/2012
  # 
  def date_compact(date)
    date.strftime("%-m/%-d/%Y") unless date.blank?
  end  
  
  # Substitute empty string for blank data
  # 
  def exists?(data)
    data.blank? ? '' : data
  end 
end
