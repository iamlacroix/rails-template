# #########################
# 
#       Uploads Setup
# 
# #########################


puts "Adding upload feature"._purple



# Gems
# 
gem 'aws-sdk'
gem 'paperclip'
run 'bundle install'


# Fetch assets
# 
%w( load-circle.gif load.gif loading.gif progressbar.gif ).each do |f|
  get "#{@resource_path}/vendor/assets/images/jquery_upload/#{f}" ,"vendor/assets/images/jquery_upload/#{f}"
end

%w( jquery.fileupload-ui.js jquery.fileupload.js jquery.iframe-transport.js jquery.ui.widget.js load-image.min.js tmpl.min.js ).each do |f|
  get "#{@resource_path}/vendor/assets/javascripts/jquery_upload/#{f}" ,"vendor/assets/javascripts/jquery_upload/#{f}"
end

%w( jquery.fileupload-ui.css.scss ).each do |f|
  get "#{@resource_path}/vendor/assets/stylesheets/jquery_upload/#{f}" ,"vendor/assets/stylesheets/jquery_upload/#{f}"
end

%w( _image_script.html.erb _image_uploader.html.haml ).each do |f|
  get "#{@resource_path}/app/views/shared/#{f}" ,"app/views/shared/#{f}"
end

get "#{@resource_path}/app/assets/javascripts/jquery_upload.js.coffee" ,"app/assets/javascripts/jquery_upload.js.coffee"


# Require dependencies in application.js
# 
inject_into_file 'app/assets/javascripts/application.js', after: /\/\/= require jquery_ujs/ do
  "\r//= require jquery_upload/jquery.ui.widget\r//= require jquery_upload/tmpl.min\r//= require jquery_upload/load-image.min\r//= require jquery_upload/jquery.fileupload\r//= require jquery_upload/jquery.fileupload-ui\r//= require jquery_upload/jquery.iframe-transport"
end


# Add RSpec should matchers for Paperclip
# 
inject_into_file 'spec/spec_helper.rb', after: /require 'rspec\/autorun'/ do
  "\rrequire 'paperclip/matchers'"
end
inject_into_file 'spec/spec_helper.rb', after: /RSpec\.configure do \|config\|/ do
  "\r  config.include Paperclip::Shoulda::Matchers"
end




puts "Finished adding upload feature"._green