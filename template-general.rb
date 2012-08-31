OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
options = {}

puts "\r\n\r\n"
puts "#########################"
puts "## Application Options ##"
puts "#########################"
# puts "\r\n"



# 
# App Config
# 

# Database
options[:db] = ask("\r\n\r\nWhich database would you like to use?\r\n\r\n(1) PostgreSQL [default]\r\n(2) MongoDB\r\n\r\nChoose:")

# App server
options[:server] = ask("\r\n\r\nWhich application server would you like to use?\r\n\r\n(1) Unicorn [default]\r\n(2) Puma\r\n(3) Thin\r\n\r\nChoose:")

# Type of production deployment
options[:deployment] = ask("\r\n\r\nHow will you be deploying?\r\n\r\n(1) Capistrano\r\n(2) Heroku [default]\r\n\r\nChoose:")



# 
# Options
# 

# Authentication?
options[:auth] = yes?("\r\n\r\nWould you like to add authentication? (installs 'sorcery') [yN]")

# Admin?
options[:admin] = yes?("\r\n\r\nWill this app have an admin feature? (installs 'inherited_resources') [yN]")

# Attachments?
options[:attachment] = yes?("\r\n\r\nWill you be uploading images/attachments to S3? (installs 'aws-sdk' & 'paperclip') [yN]")

# Blog?
options[:blog] = yes?("\r\n\r\nWill this app have a blog feature? (installs 'friendly_id') [yN]")

# CMS?
options[:cms] = yes?("\r\n\r\nWill this app have a CMS feature? (installs 'ancestry' & 'friendly_id') [yN]")





# ========================================================================================================================





# 
# Begin Initialization
# 

# comment_lines 'Gemfile', /sqlite3/


# Gems :: Development
# 
gems_dev = <<-eos

group :development do
  gem 'sqlite3'
  gem 'quiet_assets'
  gem 'letter_opener'
  gem 'thin'
  gem 'bullet'
  gem 'awesome_print'
  gem 'hirb'
end

eos
append_to_file 'Gemfile', gems_dev

# gem 'quiet_assets',         group: :development
# gem 'letter_opener',        group: :development
# gem 'thin',                 group: :development
# gem 'bullet',               group: :development
# gem 'awesome_print',        group: :development
# gem 'hirb',                 group: :development
# gem 'rails_best_practices', group: :development



# Gems :: Test
# 
gems_test = <<-eos

group :test do
  gem "capybara"
  gem 'shoulda-matchers'
end

eos
append_to_file 'Gemfile', gems_test
gem 'rspec-rails',      group: [ :development, :test ]

# gem "capybara",         group: :test
# gem 'shoulda-matchers', group: :test



# Gems :: Global
#
gem 'foreman'
gem 'dalli'
gem 'exception_notification'
gem 'haml-rails'
gem 'bourbon'
gem 'rack-pjax'


# --------------------------


# Authentication?
gem 'sorcery' if options[:auth]


# Admin?
gem 'inherited_resources' if options[:admin]


# Attachments?
if options[:attachment]
  gem 'aws-sdk'
  gem 'paperclip'
end


# Blog?
gem 'truncate_html' if options[:blog]


# CMS?
gem 'ancestry' if options[:cms]


# CMS? || Blog?
gem 'friendly_id' if (options[:cms] || options[:blog])


# Admin? || Blog?
gem 'will_paginate' if (options[:admin] || options[:blog])


# --------------------------


# Set database
# 
case options[:db]

# -MongoDB
when "2"
  gem "bson_ext"
  gem "mongoid"

# -PostgreSQL [default]
else
  gem 'pg',        group: :production
  gem 'sqlite3',   group: :development
  gem 'rails-erd', group: :development
end



# Set app server
# 
case options[:server]

# -Puma
when "2"
  gem 'puma'

# -Thin
when "3"
  gem 'thin'

# -Unicorn [default]
else
  gem 'unicorn'
end



# Set deployment type   TODO evaluate this later on instead
# 
case options[:deployment]

  # -Capistrano
  when "1"
    gem 'capistrano'
    capistrano = true
    # TODO fetch capistrano config+recipes in the following section

  # -Heroku [default]
  else
    gem 'newrelic_rpm'
end





# ========================================================================================================================





# 
# Remove & Fetch Files
# 

run "rm -Rf README public/index.html app/assets/images/* app/assets/javascripts/* app/assets/stylesheets/* app/views/layouts/* app/helpers/*"

# TODO remove files
# 


# TODO fetch files

# vendor/assets/fonts/*, vendor/assets/images/*, vendor/assets/javascripts/*, vendor/assets/stylesheets/*
# app/assets/javascripts/*, app/assets/stylesheets/*, app/views/{layouts|shared}/*, application_helper.rb
# lib/modules/*, lib/tasks/*, dev_environment.rb, unicorn.rb, newrelic.yml, newrelic.rb (unicorn), mongoid.yml

# Capfile, Procfile, Procfile.dev, Procfile.production
# deploy.rb (cap), config/recipes/*





# ========================================================================================================================





# 
# Run Generators
# 

# TODO run generators
# controller home, sorcery:install, controller admin/home, rspec:install





# ========================================================================================================================





# 
# Modify Files
# 

# TODO modify files
# application.rb (precompile, railties, time-zone), development.rb (letter_opener), production.rb (email, precompile)
# rack-pjax, pjax (js), inherited resources
# TODO [::later::] rspec_config

# General


# MongoDB











# 
# Get additional files
# 
# get "https://github.com/iamlacroix/VVVVV/raw/master/gitignore" ,".gitignore"
# get "https://github.com/iamlacroix/VVVVV/raw/master/build.rake", "lib/tasks/build.rake"