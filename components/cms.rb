# #########################
# 
#        CMS Setup
# 
# #########################


puts "Adding CMS feature"._purple



# Gems
# 
if @options[:db] == :mongodb
  gem 'mongoid-ancestry'
else
  gem 'ancestry'
end

gem 'friendly_id'
run 'bundle install'




puts "Finished adding CMS feature"._green