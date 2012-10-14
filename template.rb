# ####################
# 
#         Init
# 
# ####################


# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE  # FIXME is this necessary?


# @options hash used for configuration questions
# 
@options = {}
@post_install = []


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
puts "\r\n\r\n\r\n\r\n"
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
end

eos
append_to_file 'Gemfile', gems_test
gem 'rspec-rails',      group: [ :development, :test ]



# Gems :: Global
#
gem 'exception_notification'
gem 'haml-rails'
gem 'bourbon'
gem "neat", git: "git@github.com:iamlacroix/neat.git", branch: "gemify"
gem 'rack-pjax'

unless @options[:platform] == :jruby
  gem 'foreman'
end



# Install core gems
# 
run 'bundle install'

puts "Finished adding core gems"._green





# ========================================================================================================================





# #########################
# 
#      Core Features
# 
# #########################

# 
# Fetch resources
# 
apply "#{@component_path}/resources.rb"


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
# RSpec
# 
apply "#{@component_path}/rspec.rb"


# 
# Modify config files + add customizations
# 
apply "#{@component_path}/configuration.rb"






# ========================================================================================================================





# #########################
# 
#    Optional Features
# 
# #########################

# 
# Authentication
# 
apply "#{@component_path}/auth.rb" if @options[:auth]


# 
# Admin
# 
apply "#{@component_path}/admin.rb" if @options[:admin]


# 
# Uploads
# 
apply "#{@component_path}/uploads.rb" if @options[:uploads]


# 
# Blog
# 
apply "#{@component_path}/blog.rb" if @options[:blog]


# 
# CMS
# 
apply "#{@component_path}/cms.rb" if @options[:cms]


# 
# wysihtml5
# 
if @options[:blog] || @options[:cms] || @options[:admin]
  apply "#{@component_path}/wysihtml5.rb"
end





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
puts "\r\n\r\n"
puts "Be sure to set up your database config – either config/mongoid.yml or config/database.yml"._yellow
puts "\r\n"

if @post_install.empty?
  puts "                                         "._green
  puts "  >>  That's it, your app is ready!  <<  "._green
  puts "                                         "._green
else
  @post_install.each { |msg| puts msg }
end

puts "\r\n"
exit  # <-- Prevents `bundle install` from executing & hiding the exit message, plus it's already been accomplished.