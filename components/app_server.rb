# #########################
# 
#      App Server Setup
# 
# #########################

# @options[:server] =>
#   :unicorn
#   :puma
#   :thin
#   :torquebox


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




  ##
  # Thin
  ##
  when :thin

    # Gems
    # 
    gem 'thin'




  ##
  # TorqueBox
  ##
  when :torquebox

    # Add post-install instructions
    # 
    @post_install << "TorqueBox"._purple + " be sure to run " + "torquebox rails"._white




  ##
  # Unicorn [default]
  ##
  when :unicorn

    # Gems
    # 
    gem 'unicorn'



end

run 'bundle install --quiet'




puts "Finished configuring app server selection"._green
