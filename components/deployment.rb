# #########################
# 
#     Deployment Setup
# 
# #########################

# @options[:deployment] =>
#   :capistrano
#   :heroku


puts "Configuring deployment method"._purple



# Variables
# 
heroku_asset_config = <<-eos
    \r
    # Enable compiling assets on deploy for Heroku
    config.assets.initialize_on_precompile = false
eos


# Set up deployment method
# 
case @options[:deployment]




  ##
  # Capistrano
  ##
  when :capistrano


    # Gems
    # 
    gem 'capistrano'
    run 'bundle install --quiet'


    # Fetch Capistrano recipes
    # 
    get "#{@resource_path}/Capfile", "Capfile"
    get "#{@resource_path}/config/deploy.rb", "config/deploy.rb"

    %w( base.rb check.rb mongodb.rb nginx.rb nodejs.rb postgresql.rb rbenv.rb redis.rb ruby.rb unicorn.rb utilities.rb ).each do |f|
      get "#{@resource_path}/config/recipes/#{f}", "config/recipes/#{f}"
    end

    %w( foreman.erb mongoid.yml.erb nginx_unicorn.erb postgresql.yml.erb unicorn_init.erb unicorn.rb.erb ).each do |f|
      get "#{@resource_path}/config/recipes/templates/#{f}", "config/recipes/templates/#{f}"
    end

    if @options[:db] == :mongodb
      get "#{@resource_path}/config/recipes/mongodb/manage.rb", "config/recipes/mongodb/manage.rb"
    end




  ##
  # Heroku [default]
  ##
  else


    # Gems
    # 
    gem 'dalli'
    gem 'newrelic_rpm'
    run 'bundle install --quiet'


    # Fetch Procfile, Unicorn config, New Relic config
    # 
    %w( Procfile ).each do |f|
      get "#{@resource_path}/#{f}", "#{f}"
    end

    get "#{@resource_path}/config/newrelic.yml", "config/newrelic.yml"

    if @options[:server] == :unicorn
      get "#{@resource_path}/config/unicorn.rb", "config/unicorn.rb"
      get "#{@resource_path}/config/initializers/new_relic.rb", "config/initializers/new_relic.rb"
    end


    # Fix asset compilation during git-push
    # 
    inject_into_file 'config/application.rb', before: "  end\nend" do
      heroku_asset_config
    end



end




puts "Finished configuring deployment method"._green
