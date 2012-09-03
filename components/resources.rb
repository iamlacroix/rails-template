# #########################
# 
#   Remove & Fetch Files
# 
# #########################


puts "Fetching resources"._purple




##
# Remove Files
##
run "rm -Rf README* public/index.html app/assets/images/* app/assets/javascripts/* app/assets/stylesheets/* app/views/layouts/* app/helpers/* app/controllers/* test/"




# --------------------------




##
# Vendor Assets
##

# -vendor/fonts
# 
%w( fontawesome-webfont.eot fontawesome-webfont.svg fontawesome-webfont.ttf fontawesome-webfont.woff ).each do |f|
  get "#{@resource_path}/vendor/assets/fonts/#{f}" ,"vendor/assets/fonts/#{f}"
end

# -vendor/javascripts
# 
%w( html5shim.js respond.js lacroixdesign.js jquery-ui.min.js jquery.placeholder.min.js jquery.ui.touch-punch.min.js lacroixdesign.datepicker.js ).each do |f|
  get "#{@resource_path}/vendor/assets/javascripts/#{f}" ,"vendor/assets/javascripts/#{f}"
end

# -vendor/stylesheets
# 
%w( lacroixdesign.css.scss font-awesome.scss lacroixdesign.datepicker.css ).each do |f|
  get "#{@resource_path}/vendor/assets/stylesheets/#{f}" ,"vendor/assets/stylesheets/#{f}"
end




# --------------------------




##
# App Assets
##

# -app/javascripts
# 
%w( application.js html5.js responsive.js all.js.coffee ).each do |f|
  get "#{@resource_path}/app/assets/javascripts/#{f}" ,"app/assets/javascripts/#{f}"
end

# -app/stylesheets
# 
%w( application.css.scss all.css.scss ).each do |f|
  get "#{@resource_path}/app/assets/stylesheets/#{f}" ,"app/assets/stylesheets/#{f}"
end




# --------------------------




## 
# Helpers
## 

# -app/helpers
# 
get "#{@resource_path}/app/helpers/application_helper.rb" ,"app/helpers/application_helper.rb"




# --------------------------




## 
# Views
## 

# -app/views/layout
# 
get "#{@resource_path}/app/views/layouts/application.html.haml" ,"app/views/layouts/application.html.haml"

# -app/views/shared
# 
%w( _flash.html.haml _form_errors.html.haml ).each do |f|
  get "#{@resource_path}/app/views/shared/#{f}" ,"app/views/shared/#{f}"
end




# --------------------------




## 
# Initializers & Lib
## 

# -config/initializers
# 
%w( dev_environment.rb ).each do |f|
  get "#{@resource_path}/config/initializers/#{f}" ,"config/initializers/#{f}"
end

# -lib/modules
# 
%w( shared_methods.rb ).each do |f|
  get "#{@resource_path}/lib/modules/#{f}" ,"lib/modules/#{f}"
end

# FUTURE: lib/tasks/*




# --------------------------




## 
# Controllers
## 

# -home
# 
%w( application_controller.rb home_controller.rb ).each do |f|
  get "#{@resource_path}/app/controllers/#{f}" ,"app/controllers/#{f}"
end



puts "Finished fetching resources"._green