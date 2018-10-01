REDIS_URL = Rails.application.credentials.development[:redis_url]
REDIS_PASSWORD = Rails.application.credentials.development[:redis_password]
Sidekiq.configure_server do |config|
  config.redis = { url: REDIS_URL, password: REDIS_PASSWORD }
end

Sidekiq.configure_client do |config|
  config.redis = { url: REDIS_URL, password: REDIS_PASSWORD}
end
