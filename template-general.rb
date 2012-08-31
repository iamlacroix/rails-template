OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
options = {}
git_path = "https://github.com/iamlacroix/rails-template/raw/master"

puts "\r\n\r\n"
puts "#########################"
puts "## Application Options ##"
puts "#########################"



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



# Gems :: Global
#
gem 'foreman'
gem 'exception_notification'
gem 'haml-rails'
gem 'bourbon'
gem 'rack-pjax'


# --------------------------


# Set database
# 
case options[:db]

# -MongoDB
when "2"
  gem "bson_ext"
  gem "mongoid"
  options[:mongodb] = true

# -PostgreSQL [default]
else
  gem 'pg',        group: :production
  gem 'sqlite3',   group: :development
  gem 'rails-erd', group: :development
  options[:postgres] = true
end



# Set app server
# 
case options[:server]

# -Puma
when "2"
  gem 'puma'
  options[:puma] = true

# -Thin
when "3"
  gem 'thin'
  options[:thin] = true

# -Unicorn [default]
else
  gem 'unicorn'
  options[:unicorn] = true
end



# Set deployment type   TODO evaluate this later on instead
# 
case options[:deployment]

  # -Capistrano
  when "1"
    gem 'capistrano'
    options[:capistrano] = true

  # -Heroku [default]
  else
    gem 'dalli'
    gem 'newrelic_rpm'
    options[:heroku] = true
end


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
if options[:cms]
  if options[:mongodb]
    gem 'mongoid-ancestry'
  else
    gem 'ancestry'
  end
end


# CMS? || Blog?
gem 'friendly_id' if (options[:cms] || options[:blog])


# Admin? || Blog?
gem 'will_paginate' if (options[:admin] || options[:blog])



run "bundle install"





# ========================================================================================================================





# 
# Remove & Fetch Files
# 

# Remove Files
# 
run "rm -Rf README* public/index.html app/assets/images/* app/assets/javascripts/* app/assets/stylesheets/* app/views/layouts/* app/helpers/*"


# --------------------------


# Vendor Assets
# 

# -vendor/fonts
%w( fontawesome-webfont.eot fontawesome-webfont.svg fontawesome-webfont.ttf fontawesome-webfont.woff ).each do |f|
  get "#{git_path}/vendor/assets/fonts/#{f}" ,"vendor/assets/fonts/#{f}"
end

# -vendor/javascripts
%w( html5shim.js respond.js lacroixdesign.js jquery-ui.min.js jquery.placeholder.js jquery.ui.touch-punch.min.js lacroixdesign.datepicker.js ).each do |f|
  get "#{git_path}/vendor/assets/javascripts/#{f}" ,"vendor/assets/javascripts/#{f}"
end

# -vendor/stylesheets
%w( lacroixdesign.css.scss font-awesome.scss lacroixdesign.datepicker.css ).each do |f|
  get "#{git_path}/vendor/assets/stylesheets/#{f}" ,"vendor/assets/stylesheets/#{f}"
end


# --------------------------


# App Assets
# 

# -app/javascripts
%w( application.js html5.js responsive.js all.js.coffee ).each do |f|
  get "#{git_path}/app/assets/javascripts/#{f}" ,"app/assets/javascripts/#{f}"
end

# -app/stylesheets
%w( application.css.scss all.css.scss ).each do |f|
  get "#{git_path}/app/assets/stylesheets/#{f}" ,"app/assets/stylesheets/#{f}"
end


# --------------------------


# Views
# 

# -app/helpers
get "#{git_path}/app/helpers/application_helper.rb" ,"app/helpers/application_helper.rb"


# --------------------------


# Views
# 

# -app/views/layout
get "#{git_path}/app/views/layouts/application.html.haml" ,"app/views/layouts/application.html.haml"

# -app/views/shared
%w( _flash.html.haml _form_errors.html.haml ).each do |f|
  get "#{git_path}/app/views/shared/#{f}" ,"app/views/shared/#{f}"
end


# --------------------------


# Initializers & Lib
# 

# -config/initializers
%w( dev_environment.rb ).each do |f|
  get "#{git_path}/config/initializers/#{f}" ,"config/initializers/#{f}"
end

# -lib/modules
%w( shared_methods.rb ).each do |f|
  get "#{git_path}/lib/modules/#{f}" ,"lib/modules/#{f}"
end


# --------------------------


# Conditional Fetches
# 

# -heroku
if options[:heroku]
  %w( Procfile Procfile.dev Procfile.production ).each do |f|
    get "#{git_path}/#{f}" ,"#{f}"
  end

  get "#{git_path}/config/newrelic.yml" ,"config/newrelic.yml"

  if options[:unicorn]
    get "#{git_path}/config/unicorn.rb" ,"config/unicorn.rb"
    get "#{git_path}/config/initializers/new_relic.rb" ,"config/initializers/new_relic.rb"
  end
end


# -capistrano
if options[:capistrano]
  get "#{git_path}/Capfile" ,"Capfile"
  get "#{git_path}/config/deploy.rb" ,"config/deploy.rb"

  %w( base.rb check.rb mongodb.rb nginx.rb nodejs.rb postgresql.rb rbenv.rb redis.rb ruby.rb unicorn.rb utilities.rb ).each do |f|
    get "#{git_path}/config/recipes/#{f}" ,"config/recipes/#{f}"
  end

  %w( foreman.erb mongoid.yml.erb nginx_unicorn.erb postgresql.yml.erb unicorn_init.erb unicorn.rb.erb ).each do |f|
    get "#{git_path}/config/recipes/templates/#{f}" ,"config/recipes/templates/#{f}"
  end

  if options[:mongodb]
    get "#{git_path}/config/recipes/mongodb/manage.rb" ,"config/recipes/mongodb/manage.rb"
  end
end


# -mongodb
if options[:mongodb]
  get "#{git_path}/config/mongoid.yml" ,"config/mongoid.yml"
end


# -wysihtml5
if options[:blog] || options[:cms] || options[:admin]
  %w( wysihtml5-0.3.0.min.js advanced.js ).each do |f|
    get "#{git_path}/vendor/assets/javascripts/wysihtml5/#{f}" ,"vendor/assets/javascripts/wysihtml5/#{f}"
  end
end


# -attachments
if options[:attachment]
  %w( load-circle.gif load.gif loading.gif progressbar.gif ).each do |f|
    get "#{git_path}/vendor/assets/images/jquery_upload/#{f}" ,"vendor/assets/images/jquery_upload/#{f}"
  end

  %w( jquery.fileupload-ui.js jquery.fileupload.js jquery.iframe-transport.js jquery.ui.widget.js load-image.min.js tmpl.min.js ).each do |f|
    get "#{git_path}/vendor/assets/javascripts/jquery_upload/#{f}" ,"vendor/assets/javascripts/jquery_upload/#{f}"
  end

  %w( jquery.fileupload-ui.css.scss ).each do |f|
    get "#{git_path}/vendor/assets/stylesheets/jquery_upload/#{f}" ,"vendor/assets/stylesheets/jquery_upload/#{f}"
  end

  %w( _image_script.html.erb _image_uploader.html.haml ).each do |f|
    get "#{git_path}/app/views/shared/#{f}" ,"app/views/shared/#{f}"
  end

  get "#{git_path}/app/assets/javascripts/jquery_upload.js.coffee" ,"app/assets/javascripts/jquery_upload.js.coffee"
end



# FUTURE lib/tasks/*





# ========================================================================================================================





# 
# Run Generators
# 

# -rspec
generate 'rspec:install'

# -home controller
generate 'controller home'

# -admin
generate 'controller admin/home' if options[:admin]

# -sorcery
generate 'sorcery:install' if options[:auth]





# ========================================================================================================================





# 
# Modify Files
# 

# TODO modify files
# application.rb (precompile, railties, time-zone, autoload_paths(lib)), development.rb (letter_opener), production.rb (email, precompile)
# routes (root|admin), rack-pjax, pjax (js), inherited resources, wysihtml5, jquery_upload
# FUTURE rspec_config

# General


# MongoDB





# ========================================================================================================================





# 
# Messages
# 

say "\r\n\r\nBe sure to set up your database config – either config/mongoid.yml or config/database.yml\r\n\r\n"