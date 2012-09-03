# #########################
# 
#      App Server Setup
# 
# #########################

# @options[:server] =>
#   :unicorn
#   :puma
#   :thin


puts "Configuring app server selection"._purple




# Set up application server
# 
case @options[:server]



  ##
  # Puma
  ##
  when :puma


    # Gems
    # 
    gem 'puma'
    run 'bundle install'




  ##
  # Thin
  ##
  when :puma


    # Gems
    # 
    gem 'thin'
    run 'bundle install'




  ##
  # Unicorn [default]
  ##
  else


    # Gems
    # 
    gem 'unicorn'
    run 'bundle install'



end




puts "Finished configuring app server selection"._green