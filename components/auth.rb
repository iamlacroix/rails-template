# #########################
# 
#    Authentication Setup
# 
# #########################


puts "Adding auth feature"._purple



# Gems
# 
gem 'sorcery'
run 'bundle install'


# Init for ActiveRecord
# 	creates migration & adds User model
# 
unless @options[:db] == :mongodb
	generate 'sorcery:install'
end




puts "Finished adding auth feature"._green