String.class_eval do
  # green on dark-grey
  def _green
    "\e[32m\e[40m#{self}\e[0m"
  end

  # yellow on dark-grey
  def _yellow
    "\e[33m\e[40m#{self}\e[0m"
  end

  # red on dark-grey
  def _red
    "\e[31m\e[40m#{self}\e[0m"
  end

  # purple on dark-grey
  def _purple
    "\e[35m\e[40m#{self}\e[0m"
  end

  # white on dark-grey
  def _white
    "\e[37m\e[40m#{self}\e[0m"
  end

  # blue on dark-grey
  def _blue
    "\e[34m\e[40m#{self}\e[0m"
  end
end

 
puts "\n\n"
puts "                                      "._purple
puts " -------- LaCroix Design Co. -------- "._white
puts "                                      "._purple
puts "         ///   ///    ..oOOOo..       "._purple
puts "        ///   ///  .:OOOOOOOOOOO:.    "._purple
puts "       ///   ///  .OOOOOOOOOOOOOOO.   "._purple
puts "      ///   ///   OOOOOOOOOOOOOOOOO   "._purple
puts "     ///   ///    OOOOOOOOOOOOOOOOO   "._purple
puts "    ///   ///     `OOOOOOOOOOOOOOO'   "._purple
puts "   ///   ///       `:OOOOOOOOOOO:'    "._purple
puts "  ///   ///           ''*OOO*''       "._purple
puts "                                      "._purple


gem "rail_pass"
run "bundle install"
generate :"rail_pass:install", "--destructive"

git :init
git :add => '.'
git :commit => '-am "init"'

exit
