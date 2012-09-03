# #########################
# 
#       RSpec Setup
# 
# #########################


# NOTE: gems have already been added in template-base.rb
puts "Configuring RSpec"._purple



# Init
# 
generate 'rspec:install'


# Add Capybara
#
inject_into_file 'spec/spec_helper.rb', after: /require 'rspec\/autorun'/ do
  "\rrequire 'capybara/rspec'"
end


# Disable fixtures
#
gsub_file 'spec/spec_helper.rb', 'config.fixture_path = "#{::Rails.root}/spec/fixtures"', '# config.fixture_path = "#{::Rails.root}/spec/fixtures"'



puts "Finished configuring RSpec"._green