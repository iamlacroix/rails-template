source 'https://rubygems.org'

gem 'rails', '3.2.3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'






group :development, :test do
	gem "rspec-rails", ">= 2.9.0"
	# gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i # Doesn't work on Heroku
end

group :development do
	gem 'sqlite3'
	gem 'quiet_assets'
	gem 'letter_opener'
	gem 'thin'
	gem 'bullet'

	gem 'awesome_print'
	gem 'hirb'
	gem 'rails-erd'  # <- if Active Record
	# gem 'rails_best_practices'

	# gem 'rack-mini-profiler'
	# gem 'guard-spork'
	# gem "guard-rspec"
	# gem 'growl'
	# gem 'mongoid_colored_logger'
end

group :test do
	gem 'fabrication'
	gem "capybara"
	gem 'shoulda-matchers'
	# gem 'fuubar'
	# gem 'database_cleaner'
end


group :production do
	gem 'pg'
end



# gem 'puma'
gem 'unicorn'
gem 'foreman'

gem 'capistrano'
gem 'dalli' # Memcache

gem 'exception_notification'
# gem 'newrelic_rpm'

# gem "bson_ext"
# gem "mongoid"

# gem "slim"
# gem "slim-rails"
gem "haml"
gem "haml-rails"
gem 'bourbon'
gem 'truncate_html'
gem 'rack-pjax'

gem 'sorcery'
gem 'inherited_resources'
# gem 'mobile-fu'

gem 'geocoder'

gem 'aws-sdk'
gem 'paperclip'
# gem 'paperclip-meta'

gem 'friendly_id'
gem 'will_paginate'
gem 'ancestry'
# gem 'mongoid-ancestry'