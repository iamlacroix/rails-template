String.class_eval do

  # Output green text on dark-grey background
  # 
  def _green
    "\e[32m\e[40m#{self}\e[0m"
  end

  # Output yellow text on dark-grey background
  # 
  def _yellow
    "\e[33m\e[40m#{self}\e[0m"
  end

  # Output red text on dark-grey background
  # 
  def _red
    "\e[31m\e[40m#{self}\e[0m"
  end

  # Output purple text on dark-grey background
  # 
  def _purple
    "\e[35m\e[40m#{self}\e[0m"
  end

  # Output white text on dark-grey background
  # 
  def _white
    "\e[37m\e[40m#{self}\e[0m"
  end

  # Output blue text on dark-grey background
  # 
  def _blue
    "\e[34m\e[40m#{self}\e[0m"
  end

end
