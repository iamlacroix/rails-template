require 'rubygems'
require 'spork'

# Load with Spork server
# 
Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/rspec'
  require 'shoulda-matchers'
  require 'shoulda/matchers/integrations/rspec'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  # Capybara.javascript_driver = :poltergeist
  # Capybara.default_driver = :selenium

  RSpec.configure do |config|
    config.infer_base_class_for_anonymous_controllers = false
    config.order = "random"

    # Database Cleaner
    # 
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end
    config.before(:each) do
      DatabaseCleaner.start
    end
    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end


# Run each time you run your specs.
# 
Spork.each_run do
end
