# #########################
# 
#   Remove & Fetch Files
# 
# #########################


puts "Fetching resources"._purple




##
# Remove Files
##
run "rm -Rf README* public/index.html app/assets/images/* app/assets/javascripts/* app/assets/stylesheets/* app/views/layouts/* app/helpers/* app/controllers/* test/ spec/spec_helper.rb vendor/plugins"


##
# Make Dir
##
run "mkdir -p app/views/home"
run "touch app/views/home/index.html.haml"




# --------------------------




##
# Vendor Assets
##

# -vendor/fonts/fontawesome
# 
%w( fontawesome-webfont.eot fontawesome-webfont.ttf fontawesome-webfont.woff ).each do |f|
  get "#{@resource_path}/vendor/assets/fonts/fontawesome/#{f}" ,"vendor/assets/fonts/fontawesome/#{f}"
end

# -vendor/fonts/icomoon
# 
%w( icomoon.eot icomoon.svg icomoon.ttf icomoon.woff ).each do |f|
  get "#{@resource_path}/vendor/assets/fonts/icomoon/#{f}" ,"vendor/assets/fonts/icomoon/#{f}"
end

# -vendor/javascripts
# 
%w( jquery-ui.min.js jquery.placeholder.min.js jquery.ui.touch-punch.min.js swipe.js ).each do |f|
  get "#{@resource_path}/vendor/assets/javascripts/#{f}" ,"vendor/assets/javascripts/#{f}"
end

# -vendor/javascripts/polyfills
# 
%w( html5shim.js respond.js selectivizr.js ).each do |f|
  get "#{@resource_path}/vendor/assets/javascripts/polyfills/#{f}" ,"vendor/assets/javascripts/polyfills/#{f}"
end

# -vendor/stylesheets
# 
%w( normalize.css lacroixdesignco-base.css.scss font-awesome.scss icomoon.scss ).each do |f|
  get "#{@resource_path}/vendor/assets/stylesheets/#{f}" ,"vendor/assets/stylesheets/#{f}"
end




# --------------------------




##
# App Assets
##

# -app/javascripts
# 
%w( application.js html5.js responsive.js polyfills.js scripts.js.coffee ).each do |f|
  get "#{@resource_path}/app/assets/javascripts/#{f}" ,"app/assets/javascripts/#{f}"
end

# -app/stylesheets
# 
%w( application.css.scss style.css.scss ).each do |f|
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
# %w().each do |f|
#   get "#{@resource_path}/app/views/shared/#{f}" ,"app/views/shared/#{f}"
# end




# --------------------------




## 
# Initializers & Lib
## 

# -config/initializers
# 
%w( dev_environment.rb ).each do |f|
  get "#{@resource_path}/config/initializers/#{f}" ,"config/initializers/#{f}"
end




# --------------------------




## 
# Controllers
## 

# -home
# 
%w( application_controller.rb home_controller.rb ).each do |f|
  get "#{@resource_path}/app/controllers/#{f}" ,"app/controllers/#{f}"
end



# --------------------------




## 
# Tests
## 

# -spec
# 
%w( spec_helper.rb ).each do |f|
  get "#{@resource_path}/spec/#{f}" ,"spec/#{f}"
end

get "#{@resource_path}/.rspec" ,".rspec"
