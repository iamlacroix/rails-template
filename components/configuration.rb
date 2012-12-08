# ####################
# 
#     Modify Files
# 
# ####################


puts "Customizing config files"._purple




##
#   application.rb
##


# Add autoload paths
# 
gsub_file 'config/application.rb', /# config.autoload_paths.+/, 'config.autoload_paths += %W( #{config.root}/lib/modules )'


# Set time zone to US/Central
# 
gsub_file 'config/application.rb', /# config.time_zone = '.+'/, "config.time_zone = 'Central Time (US & Canada)'"




# --------------------------




##
#   development.rb
##

# Set letter_opener for development email delivery
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
#   production.rb
##

# Add custom files to precompile
# 
gsub_file 'config/environments/production.rb', /# config.assets.precompile.*/, 'config.assets.precompile += %w( responsive.js html5.js polyfills.js )'


# Set SendGrid for production email delivery
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
#   routes.rb
##

# Add 'home#index' as the root url in the router
#
inject_into_file 'config/routes.rb', after: /^.*::Application.routes.draw do/ do
  <<-eos
  \n
  root to: 'home#index'
  eos
end




# --------------------------




##
#   PJAX
##

# Enable PJAX for links by default
#
inject_into_file 'app/assets/javascripts/scripts.js.coffee', after: /\$\(document\)\.ready ->/ do
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
#   git
##

# Update .gitignore w/ env var file & .powder
# 
inject_into_file '.gitignore', after: /\/tmp/ do
  <<-eos
\n
config/initializers/dev_environment.rb
.powder
  eos
end




puts "Finished customizing config files"._green
