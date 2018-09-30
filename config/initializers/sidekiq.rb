
REDIS_URL = Rails.application.secrets.REDIS_URL
REDIS_PASSWORD = Rails.application.secrets.REDIS_PASSWORD
Sidekiq.configure_server do |config|
  config.redis = { url: REDIS_URL, password: REDIS_PASSWORD }
end

Sidekiq.configure_client do |config|
  config.redis = { url: REDIS_URL, password: REDIS_PASSWORD}
end
