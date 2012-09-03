Rails Template
=====

Ruby on Rails application template used at LaCroix Design Co.


Usage
-----

```
rails new myapp -m https://github.com/iamlacroix/rails-template/raw/master/template-base.rb
```

Features
-----

### Front-end libraries/features
* Haml boilerplate layout
* Sass boilerplate stylesheet
* [respond.js](https://github.com/scottjehl/Respond)
* [html5shiv](https://github.com/aFarkas/html5shiv)
* [Bootstrap](http://twitter.github.com/bootstrap/), modified to use [Font Awesome](https://github.com/FortAwesome/Font-Awesome)
* [Font Awesome](https://github.com/FortAwesome/Font-Awesome)
* [jQuery Placeholder](https://github.com/mathiasbynens/jquery-placeholder)
* [jQuery UI](https://github.com/jquery/jquery-ui) + [jQuery UI Touch Punch](https://github.com/furf/jquery-ui-touch-punch)
* Some basic helper methods in `helpers/application_helper.rb`
* Adds a `.gitignore`-ed initializer file called `dev_environment.rb` to hold ENV variables
* Adds newrelic.yml if Heroku is selected (and a newrelic/unicorn initializer if Unicorn is also selected)
* Automatically injects config's for:
    * rack-pjax
    * autoload of `lib/modules`
    * US/Central time zone
    * `config.assets.initialize_on_precompile = false` if Heroku deployment is select, to enable asset compiling during Git push
    * removes Active Record railtie if MongoDB is selected
    * SendGrid SMTP
    * letter_opener

### Gems
* foreman
* haml-rails
* bourbon
* rack-pjax
* exception_notification

### Gems | Development
* sqlite3 (unless configured for MongoDB; refer to the following section)
* quiet_assets
* letter_opener
* thin
* bullet
* awesome_print
* hirb

### Gems | Testing
* RSpec Rails
* Capybara
* shoulda-matchers
* factory_girl


Configuration
-----

Prompts for the following options:

##### Database:
* PostgreSQL [default]
* MongoDB (w/ Mongoid)

##### Application server:
* Unicorn [default]
* Puma
* Thin

##### Deployment
* Capistrano
* Heroku [default]

##### Authentication? [yN]
* Adds [sorcery](https://github.com/NoamB/sorcery) gem & runs `rails g sorcery:install`

##### Admin section? [yN]
* Creates /admin namespace: `admin/application_controller.rb`, `admin/home_controller.rb`, and adds routing to that namespace
* Adds [inherited_resources](https://github.com/josevalim/inherited_resources) gem; `admin/application_controller.rb` subclasses `InheritedResources::Base`
* Adds [will_paginate](https://github.com/mislav/will_paginate) gem
* Adds [wysihtml5](https://github.com/xing/wysihtml5) dependencies & requires them in `app/assets/application.js`

##### S3 uploads? [yN]
* Adds [paperclip](https://github.com/thoughtbot/paperclip) gem & requires it's shoulda matchers in `spec/spec_helper.rb`
* Adds [aws-sdk](https://github.com/amazonwebservices/aws-sdk-for-ruby) gem
* Adds [jquery-file-upload](https://github.com/blueimp/jQuery-File-Upload) dependencies, requires them in `app/assets/application.js`, adds the template script & an example form in `app/views/shared`, and an example binding in `app/assets/javascripts`

##### Blog feature? [yN]
* Adds [friendly_id](https://github.com/norman/friendly_id), [truncate_html](https://github.com/hgmnz/truncate_html), and [will_paginate](https://github.com/mislav/will_paginate) gems
* Adds [wysihtml5](https://github.com/xing/wysihtml5) dependencies & requires them in `app/assets/application.js`

##### CMS feature? [yN]
* Adds [ancestry](https://github.com/stefankroes/ancestry) -or- [mongoid-ancestry](https://github.com/skyeagle/mongoid-ancestry) gem depending on which databse option was selected
* Adds [friendly_id](https://github.com/norman/friendly_id) gem
* Adds [wysihtml5](https://github.com/xing/wysihtml5) dependencies & requires them in `app/assets/application.js`


Todo
-----
* Break this gargantuan template file into smaller components


License
-----
Copyright (c) 2012 Michael LaCroix  
Released under the MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.