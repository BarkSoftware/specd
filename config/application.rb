require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Specd
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
      # redirect old urls
      r301      %r{/client/(.*)},    '/$1'
    end

    ActiveSupport::JSON::Encoding.encode_big_decimal_as_string = false

    config.angular_templates.ignore_prefix = []
    config.angular_templates.module_name    = 'templates'
    config.angular_templates.ignore_prefix  = %w(templates/)
    config.angular_templates.inside_paths   = [Rails.root.join('app', 'assets')]
    config.angular_templates.markups        = %w(erb html)
    config.angular_templates.htmlcompressor = false
  end
end
