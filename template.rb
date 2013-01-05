# ####################
# 
#         Init
# 
# ####################


# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE  # FIXME is this necessary?


# @options hash used for configuration questions
# 
@options = {}
@post_install_tasks = []
@post_install_messages = []


# Set base for git and template file's directory
# 
git_base        = "https://github.com/iamlacroix/rails-template/raw/master"
dir_base        = File.expand_path(File.dirname(__FILE__))
component_dir   = 'components'
resources_dir   = 'resources'


# Set paths for components (template features) & resources (static files)
#   based on whether template files are local or being fetched via git
# 
base_path       = File.directory?(File.join(dir_base, component_dir)) ? dir_base : git_base
@component_path = File.join(base_path, component_dir)
@resource_path  = File.join(base_path, resources_dir)


# Init custom methods/classes
# 
apply "#{@component_path}/methods.rb"





# ========================================================================================================================





# ####################
# 
#       Start Up
# 
# ####################



# Display logo
# 
puts "\n\n\n"
puts "                                      "._purple
puts " -------- LaCroix Design Co. -------- "._white
puts "                                      "._purple
puts "         ///   ///     ..=====..      "._purple
puts "        ///   ///   .:ooooooooooo:.   "._purple
puts "       ///   ///   .ooooooooooooooo.  "._purple
puts "      ///   ///   -ooooooooooooooooo- "._purple
puts "     ///   ///    -ooooooooooooooooo- "._purple
puts "    ///   ///     -ooooooooooooooooo- "._purple
puts "   ///   ///       `ooooooooooooooo'  "._purple
puts "  ///   ///         `:ooooooooooo:'   "._purple
puts " ///   ///             ''=====''      "._purple
puts "                                      "._purple


# Load template option prompts
# 
apply "#{@component_path}/options.rb", verbose: false





# ========================================================================================================================





# #########################
# 
#    Setup/Install Gems
# 
# #########################


puts "Adding core gems"._purple


# Remove sqlite3 gem
# 
gsub_file 'Gemfile', /^gem 'sqlite3'$/, '' unless @options[:platform] == :jruby



# Gems :: Development
# 
if @options[:platform] == :jruby
  gems_dev = <<-eos

  group :development do
    gem 'quiet_assets'
    gem 'letter_opener'
    gem 'bullet'
    gem 'awesome_print'
    gem 'hirb'
  end

  eos
else
  gems_dev = <<-eos

  group :development do
    gem 'sqlite3'
    gem 'quiet_assets'
    gem 'letter_opener'
    gem 'thin'
    gem 'bullet'
    gem 'awesome_print'
    gem 'hirb'
    gem 'better_errors'
    gem 'binding_of_caller'
  end

  eos
end
append_to_file 'Gemfile', gems_dev



# Gems :: Test
# 
gems_test = <<-eos

group :test do
  gem "capybara"
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'spork-rails'
end

eos
append_to_file 'Gemfile', gems_test


gem 'rspec-rails',      group: [ :development, :test ]
gem 'database_cleaner', group: [ :development, :test ]



# Gems :: Global
#
gem 'exception_notification'
gem 'haml-rails'
gem 'bourbon'
gem "neat"

unless @options[:platform] == :jruby
  gem 'foreman'
end





# ========================================================================================================================





# #########################
# 
#      Core Features
# 
# #########################

# 
# Configure database selection
# 
apply "#{@component_path}/database.rb"


# 
# Configure app server selection
# 
apply "#{@component_path}/app_server.rb"


# 
# Configure deployment method
# 
apply "#{@component_path}/deployment.rb"


# 
# Fetch resources
# 
apply "#{@component_path}/resources.rb"


# 
# Modify config files + add customizations
# 
apply "#{@component_path}/configuration.rb"


# 
# Install Gems
# 
run 'bundle install'


# 
# Run post-install tasks
# 
@post_install_tasks.each {|task| task.call}






# ========================================================================================================================





# ####################
# 
#       Wrap Up
# 
# ####################

# Git - init & commit
# 
git :init
git :add => '.'
git :commit => '-am "init"'


# Sayounara!
# 
puts "\n\n"
puts "Be sure to set up your database config – either config/mongoid.yml or config/database.yml"._yellow
puts "\n"

if @post_install_messages.empty?
  puts "                                         "._green
  puts "  >>  That's it, your app is ready!  <<  "._green
  puts "                                         "._green
else
  @post_install_messages.each { |msg| puts msg }
end

puts "\n"
exit  # <-- Prevents `bundle install` from executing & hiding the exit message, plus it's already been accomplished.
