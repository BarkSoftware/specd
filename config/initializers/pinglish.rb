Rails.application.config.middleware.tap do |middleware|
  middleware.use Pinglish, path: '/_ping' do |ping|
    ping.check :database do
      ActiveRecord::Base.connected?
    end

    app_name = Rails.application.class.parent_name.underscore
    ping.check(:app_name) { app_name }
  end
end
