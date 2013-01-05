# #########################
# 
#      Database Setup
# 
# #########################

# @options[:db] =>
#   :postgres
#   :mongodb


# Variables
# 
mongo_railties = <<-eos
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"
eos





# Set up specific database
# 
case @options[:db]




  ##
  # MongoDb
  ##
  when :mongodb


    # Gems
    # 
    gem "bson_ext" unless @options[:platform] == :jruby
    gem "mongoid"


    # Tasks
    # 
    @post_install_tasks << Proc.new do
      puts "Configuring database selection"._purple
      
      # Remove default database config file &
      #   create MongoDB config in it's place
      # 
      run "rm -Rf config/database.yml"
      generate 'mongoid:config'

      # Disable ActiveRecord references within the application's config files
      # 
      gsub_file 'config/application.rb', /require 'rails\/all'/, mongo_railties
      gsub_file 'config/application.rb', "config.active_record.whitelist_attributes = true", "# config.active_record.whitelist_attributes = true"
      gsub_file 'config/environments/development.rb', "config.active_record.auto_explain_threshold_in_seconds = 0.5", "# config.active_record.auto_explain_threshold_in_seconds = 0.5"
      gsub_file 'config/environments/development.rb', "config.active_record.mass_assignment_sanitizer = :strict", "# config.active_record.mass_assignment_sanitizer = :strict"
    end




  ##
  # PostgreSQL [default]
  ##
  else


    # Gems
    # 
    if @options[:platform] == :jruby
      gem 'activerecord-jdbcpostgresql-adapter', group: :production
    else
      gem 'pg',        group: :production
      gem 'sqlite3',   group: :development
      gem 'rails-erd', group: :development
    end




end
