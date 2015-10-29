source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
gem 'execjs'
gem 'pg'
gem 'settingslogic'
gem 'faraday'
gem 'devise'
gem 'omniauth-github'
gem 'rails_12factor', group: :production
gem 'rack-rewrite'
gem 'link_header'
gem 'andand'
gem 'bootstrap-sass', '~> 3.3.5'
gem 'sass-rails', '>= 3.2'
gem 'pinglish'
gem 'angular-rails-templates'

# error logging
gem 'rollbar', '~> 1.2.7'

# s3 file uploads
gem 'aws-sdk', '~> 1'

# because I want decimals to render as JSON Numbers
gem 'activesupport-json_encoder'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'bower-rails'

gem 'active_model_serializers'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development
gem 'cancan'
group :development, :test do
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
  gem 'pry-rails'
  gem 'dotenv-rails'
end

group :test do
  gem 'webmock'
  gem 'junklet'
  gem 'rspec-rails', '~> 3.0.0'
end
