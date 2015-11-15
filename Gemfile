source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.1.4'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'execjs'
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
gem 'angular-rails-templates'
gem "jasmine", github: "pivotal/jasmine-gem"

# infra-specific things to move away from here once we have specd in a rails engine
gem 'rollbar', '~> 1.2.7'
gem 'puma'
gem 'pinglish'
gem 'pg'

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
