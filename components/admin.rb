# #########################
# 
#       Admin Setup
# 
# #########################


puts "Adding admin feature"._purple



# Gems
# 
gem 'inherited_resources'
gem 'will_paginate'
run 'bundle install'


# Fetch 'admin/application_controller.rb' & 'admin/home_controller.rb'
# 	subclass InheritedResources::Base
# 
%w( application_controller.rb home_controller.rb ).each do |f|
  get "#{@resource_path}/app/controllers/admin/#{f}" ,"app/controllers/admin/#{f}"
end


# Add routes to /admin namespace
# 
inject_into_file 'config/routes.rb', after: /^.*::Application.routes.draw do/ do
  <<-eos
  \n
  # Admin
  # 
  namespace :admin do
    root to: 'home#index'
  end
  eos
end




puts "Finished adding admin feature"._green