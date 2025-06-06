ruby '3.4.2'

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Ruby on Rails
gem 'rails', github: 'rails/rails', branch: 'main'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 6.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'

# A Ruby Library for dealing with money and currency conversion.
gem 'money'

# Calculates the exchange rate using published rates from European Central Bank
gem 'eu_central_bank'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
gem 'sassc-rails'

# Usable, fast, simple HTTP 1.1 for Ruby
gem 'excon'

# Simple Rails app configuration
gem 'figaro', git: 'https://github.com/laserlemon/figaro'

# Flexible authentication solution for Rails with Warden.
gem 'devise', github: 'heartcombo/devise', branch: 'main'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'

# Ruby exception and error tracking
gem 'honeybadger', '~> 5.4'

# Simple, efficient background processing for Ruby
gem 'sidekiq'

# OpenStruct implementation
gem 'ostruct'

gem 'httparty'

gem 'hcaptcha', '~> 7.1'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # A Ruby static code analyzer and formatter, based on the community Ruby style guide.
  gem 'rubocop', require: false

  # A RuboCop extension focused on enforcing Rails best practices and coding conventions.
  gem 'rubocop-rails', require: false

  # Code style checking for Minitest files.
  gem 'rubocop-minitest', require: false

  # Code style checking for Capybara files.
  gem 'rubocop-capybara', require: false

  # Preview mail in the browser instead of sending.
  gem 'letter_opener'

  # A static analysis security vulnerability scanner for Ruby on Rails applications
  gem 'brakeman'

  # Patch-level verification for Bundler
  gem 'bundler-audit'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'

  # A browser automation framework and ecosystem.
  gem 'selenium-webdriver'

  # A mocking and stubbing library for Ruby
  gem 'mocha'

  # Library for stubbing and setting expectations on HTTP requests in Ruby.
  gem 'webmock'
end
