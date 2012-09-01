OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
options = {}
git_path = "https://github.com/iamlacroix/rails-template/raw/master"

# Output green text on dark-grey background
# 
def success_output(content)
  puts "\e[32m\e[40m#{content}\e[0m"
end

# Output yellow text on dark-grey background
# 
def info_output(content)
  puts "\e[33m\e[40m#{content}\e[0m"
end




# ####################
# 
#       Boot Up
# 
# ####################


# Purple on dark-grey
# 
def logo_output(content)
  puts "\e[37m\e[40m#{content}\e[0m"
end

# White on dark-grey
# 
def title_output(content)
  puts "\e[35m\e[40m#{content}\e[0m"
end


# Display logo
# 
puts "\r\n\r\n\r\n\r\n"
logo_output  "                                      "
title_output " -------- LaCroix Design Co. -------- "
logo_output  "                                      "
logo_output  "         ///   ///     ..=====..      "
logo_output  "        ///   ///   .:ooooooooooo:.   "
logo_output  "       ///   ///   .ooooooooooooooo.  "
logo_output  "      ///   ///   -ooooooooooooooooo- "
logo_output  "     ///   ///    -ooooooooooooooooo- "
logo_output  "    ///   ///     -ooooooooooooooooo- "
logo_output  "   ///   ///       `ooooooooooooooo'  "
logo_output  "  ///   ///         `:ooooooooooo:'   "
logo_output  " ///   ///             ''=====''      "
logo_output  "                                      "




# ####################
# 
#     App Config
# 
# ####################


##
# Config
##

def generate_ask(question, choices)
  ask("\r\n\r\n\e[40m\e[32m#{question}\e[0m\r\n\r\n#{choices}\r\n\r\n\e[40m\e[37mChoose:\e[0m")
end

# Database
options[:db] = generate_ask "Which database would you like to use?", "(1) PostgreSQL [default]\r\n(2) MongoDB"

# App server
options[:server] = generate_ask "Which application server would you like to use?", "(1) Unicorn [default]\r\n(2) Puma\r\n(3) Thin"

# Type of production deployment
options[:deployment] = generate_ask "How will you be deploying?", "(1) Capistrano\r\n(2) Heroku [default]"



## 
# Options
## 

def generate_question(question)
  yes?("\r\n\r\n\e[40m\e[33m#{question}\e[0m\r\n\e[37m[yN]\e[0m")
end

# Authentication?
options[:auth] = generate_question "Would you like to add authentication? (installs 'sorcery')"

# Admin?
options[:admin] = generate_question "Will this app have an admin feature? (installs 'inherited_resources')"

# Attachments?
options[:attachment] = generate_question "Will you be uploading images/attachments to S3? (installs 'aws-sdk' & 'paperclip')"

# Blog?
options[:blog] = generate_question "Will this app have a blog feature? (installs 'friendly_id')"

# CMS?
options[:cms] = generate_question "Will this app have a CMS feature? (installs 'ancestry' & 'friendly_id')"





# ========================================================================================================================





# #########################
# 
#    Setup/Install Gems
# 
# #########################

gsub_file 'Gemfile', /^gem 'sqlite3'$/, ''

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
  gem 'factory_girl_rails'
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



# Set deployment type
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





# #########################
# 
#   Remove & Fetch Files
# 
# #########################

# 
# Remove Files
# 
run "rm -Rf README* public/index.html app/assets/images/* app/assets/javascripts/* app/assets/stylesheets/* app/views/layouts/* app/helpers/* app/controllers/* test/"

if options[:mongodb]
  run "rm -Rf config/database.yml"
end


# --------------------------


# 
# Vendor Assets
# 

# -vendor/fonts
# 
%w( fontawesome-webfont.eot fontawesome-webfont.svg fontawesome-webfont.ttf fontawesome-webfont.woff ).each do |f|
  get "#{git_path}/vendor/assets/fonts/#{f}" ,"vendor/assets/fonts/#{f}"
end

# -vendor/javascripts
# 
%w( html5shim.js respond.js lacroixdesign.js jquery-ui.min.js jquery.placeholder.js jquery.ui.touch-punch.min.js lacroixdesign.datepicker.js ).each do |f|
  get "#{git_path}/vendor/assets/javascripts/#{f}" ,"vendor/assets/javascripts/#{f}"
end

# -vendor/stylesheets
# 
%w( lacroixdesign.css.scss font-awesome.scss lacroixdesign.datepicker.css ).each do |f|
  get "#{git_path}/vendor/assets/stylesheets/#{f}" ,"vendor/assets/stylesheets/#{f}"
end


# --------------------------


# 
# App Assets
# 

# -app/javascripts
# 
%w( application.js html5.js responsive.js all.js.coffee ).each do |f|
  get "#{git_path}/app/assets/javascripts/#{f}" ,"app/assets/javascripts/#{f}"
end

# -app/stylesheets
# 
%w( application.css.scss all.css.scss ).each do |f|
  get "#{git_path}/app/assets/stylesheets/#{f}" ,"app/assets/stylesheets/#{f}"
end


# --------------------------


## 
# Helpers
## 

# -app/helpers
# 
get "#{git_path}/app/helpers/application_helper.rb" ,"app/helpers/application_helper.rb"


# --------------------------


## 
# Views
## 

# -app/views/layout
# 
get "#{git_path}/app/views/layouts/application.html.haml" ,"app/views/layouts/application.html.haml"

# -app/views/shared
# 
%w( _flash.html.haml _form_errors.html.haml ).each do |f|
  get "#{git_path}/app/views/shared/#{f}" ,"app/views/shared/#{f}"
end


# --------------------------


## 
# Initializers & Lib
## 

# -config/initializers
# 
%w( dev_environment.rb ).each do |f|
  get "#{git_path}/config/initializers/#{f}" ,"config/initializers/#{f}"
end

# -lib/modules
# 
%w( shared_methods.rb ).each do |f|
  get "#{git_path}/lib/modules/#{f}" ,"lib/modules/#{f}"
end


# --------------------------


## 
# Controllers
## 

# -home
# 
%w( application_controller.rb home_controller.rb ).each do |f|
  get "#{git_path}/app/controllers/#{f}" ,"app/controllers/#{f}"
end

# -admin
# 
if options[:admin]
  %w( application_controller.rb home_controller.rb ).each do |f|
    get "#{git_path}/app/controllers/admin/#{f}" ,"app/controllers/admin/#{f}"
  end
end


# --------------------------


## 
# Conditional Fetches
## 

# -heroku
# 
if options[:heroku]
  %w( Procfile ).each do |f|
    get "#{git_path}/#{f}" ,"#{f}"
  end

  get "#{git_path}/config/newrelic.yml" ,"config/newrelic.yml"

  if options[:unicorn]
    get "#{git_path}/config/unicorn.rb" ,"config/unicorn.rb"
    get "#{git_path}/config/initializers/new_relic.rb" ,"config/initializers/new_relic.rb"
  end
end


# -capistrano
# 
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


# -wysihtml5
# 
if options[:blog] || options[:cms] || options[:admin]
  %w( wysihtml5-0.3.0.min.js advanced.js ).each do |f|
    get "#{git_path}/vendor/assets/javascripts/wysihtml5/#{f}" ,"vendor/assets/javascripts/wysihtml5/#{f}"
  end
end


# -attachments
# 
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


# --------------------------


# FUTURE lib/tasks/*




# ========================================================================================================================





# ####################
# 
#    Run Generators
# 
# ####################

# -mongodb
# 
generate 'mongoid:config'


# -rspec
# 
generate 'rspec:install'


# -sorcery
# 
generate 'sorcery:install' if options[:auth]





# ========================================================================================================================





# ####################
# 
#     Modify Files
# 
# ####################


##
# application.rb
##


# -load paths
# 
gsub_file 'config/application.rb', /# config.autoload_paths.+/, 'config.autoload_paths += %W( #{config.root}/lib/modules )'


# -time zone
# 
gsub_file 'config/application.rb', /# config.time_zone = '.+'/, "config.time_zone = 'Central Time (US & Canada)'"


# -PJAX
# 
inject_into_file 'config/application.rb', before: "  end\nend" do
  <<-eos
    \r
    # PJAX
    # 
    config.middleware.use Rack::Pjax
  eos
end


# -heroku: asset compiler fix
# 
if options[:heroku]
  inject_into_file 'config/application.rb', before: "  end\nend" do
    <<-eos
    \r
    # Enable compiling assets on deploy for Heroku
    config.assets.initialize_on_precompile = false
    eos
  end
end


# -mongodb: disable Active Record
# 
if options[:mongodb]
  gsub_file 'config/application.rb', /require 'rails\/all'/ do
    <<-eos
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"
    eos
  end
end


# --------------------------


##
# development.rb
##

# -letter_opener
# 
inject_into_file 'config/environments/development.rb', after: /^.*::Application.configure do/ do
  <<-eos
  \n
  # 
  # Open emails in browser
  # 
  config.action_mailer.delivery_method = :letter_opener
  # config.action_mailer.default_url_options = { host: "localhost:3000" }  # FIXME replace with correct :host
  eos
end


# --------------------------


##
# production.rb
##

# -precompile files
# 
gsub_file 'config/environments/production.rb', /# config.assets.precompile.*/, 'config.assets.precompile += %w( responsive.js html5.js )'


# -email settings
# 
inject_into_file 'config/environments/production.rb', after: /^.*::Application.configure do/ do
  <<-eos
  \n
  # 
  # Sending Email :: SendGrid
  # 
  # config.action_mailer.default_url_options = { host: "EXAMPLE.COM" }  # FIXME replace with proper :host
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com'  # FIXME replace with proper :domain
  }
  eos
end


# --------------------------


##
# routes.rb
##

# -home route
#
inject_into_file 'config/routes.rb', after: /^.*::Application.routes.draw do/ do
  <<-eos
  \n
  root to: 'home#index'
  eos
end


# -admin route
# 
if options[:admin]
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
end


# --------------------------


##
# PJAX
##

# -all.js.coffee
#
inject_into_file 'app/assets/javascripts/all.js.coffee', after: /\$\(document\)\.ready ->/ do
  <<-eos
\n
\t# ===== PJAX =====
\t# 
\t$('a:not([data-remote]):not([data-behavior]):not([data-skip-pjax])').pjax
\t\tcontainer: '[data-pjax-container]'
\t\ttimeout:   1500
eos
end


# --------------------------


##
# application.js
##

# -wysihtml5
#
if options[:blog] || options[:cms] || options[:admin]
  inject_into_file 'app/assets/javascripts/application.js', after: /\/\/= require jquery_ujs/ do
    "\r//= require wysihtml5/advanced\r//= require wysihtml5/wysihtml5-0.3.0.min"
  end
end


# -jquery_upload
#
if options[:attachment]
  inject_into_file 'app/assets/javascripts/application.js', after: /\/\/= require jquery_ujs/ do
    "\r//= require jquery_upload/jquery.ui.widget\r//= require jquery_upload/tmpl.min\r//= require jquery_upload/load-image.min\r//= require jquery_upload/jquery.fileupload\r//= require jquery_upload/jquery.fileupload-ui\r//= require jquery_upload/jquery.iframe-transport"
  end
end


# --------------------------


##
# RSpec
##

# -capybara
#
inject_into_file 'spec/spec_helper.rb', after: /require 'rspec\/autorun'/ do
  "\rrequire 'capybara/rspec'"
end


# -remove fixtures
#
gsub_file 'spec/spec_helper.rb', 'config.fixture_path = "#{::Rails.root}/spec/fixtures"', '# config.fixture_path = "#{::Rails.root}/spec/fixtures"'


# -paperclip shoulda matchers
# 
if options[:attachment]
  inject_into_file 'spec/spec_helper.rb', after: /require 'rspec\/autorun'/ do
    "\rrequire 'paperclip/matchers'"
  end
  inject_into_file 'spec/spec_helper.rb', after: /RSpec\.configure do \|config\|/ do
    "\r  config.include Paperclip::Shoulda::Matchers"
  end
end


# --------------------------


##
# git
##

# -update .gitignore w/ env var file & .powder
# 
inject_into_file '.gitignore', after: /\/tmp/ do
  <<-eos
\n
config/initializers/dev_environment.rb
.powder
  eos
end




# ========================================================================================================================





# ####################
# 
#       Wrap Up
# 
# ####################

# git
# 
git :init
git :add => '.'
git :commit => '-am "init"'


# -exit message
# 
puts "\r\n\r\n"
info_output "Be sure to set up your database config – either config/mongoid.yml or config/database.yml"
puts "\r\n"
success_output "All set!"
puts "\r\n"