source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby '2.6.0'
gem 'activesupport', '>= 5.2.4.3'
gem 'rack', '>= 2.0.6'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '>= 3.12.4'
# Use SCSS for stylesheets
gem 'bootstrap', '>= 4.3.1'
gem 'sprockets-rails', require: 'sprockets/railtie'
# gem 'compass-rails'
gem 'autoprefixer-rails'
gem 'popper_js', '~> 1.14.3'
gem 'font-awesome-rails'
gem 'jquery-rails'
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# find slow queries
# gem 'bullet', group: :development
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'cocoon'
gem 'devise', '>= 4.7.1', require: true
gem 'omniauth-facebook', require: true
gem 'pagy', '0.19.4'
gem 'koala', '~> 3.0.0'
gem 'seed_dump'
gem 'rubyzip', '>= 1.3.0'
gem 'chartkick', '>= 3.3.0'
gem 'simple_form', '>= 5.0.0'
gem 'country_select', require: 'country_select_without_sort_alphabetical'
gem 'loofah', '>= 2.3.1'
# background jobs
gem 'sidekiq', '~> 5.2.5'
# analytics
gem 'ahoy_matey'
gem 'blazer'
gem 'puma_worker_killer'
# caching
gem 'actionpack-action_caching'
gem 'actionview', '>= 5.2.4.3'
# searching
gem 'ransack', github: 'activerecord-hackery/ransack'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end
gem 'nokogiri', '>= 1.10.8'
group :production do
  gem 'aws-sdk-s3'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
