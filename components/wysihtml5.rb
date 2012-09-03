# #########################
# 
#      wysihtml5 Setup
# 
# #########################


puts "Adding wysihtml5 feature"._purple



# Fetch assets
# 
%w( wysihtml5-0.3.0.min.js advanced.js ).each do |f|
  get "#{@resource_path}/vendor/assets/javascripts/wysihtml5/#{f}" ,"vendor/assets/javascripts/wysihtml5/#{f}"
end


# Require dependencies in application.js
# 
inject_into_file 'app/assets/javascripts/application.js', after: /\/\/= require jquery_ujs/ do
  "\r//= require wysihtml5/advanced\r//= require wysihtml5/wysihtml5-0.3.0.min"
end




puts "Finished adding wysihtml5 feature"._green