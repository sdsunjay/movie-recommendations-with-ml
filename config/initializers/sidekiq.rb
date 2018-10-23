if Rails.env.development?
  REDIS_URL = Rails.application.credentials.development[:redis_url]
  REDIS_PASSWORD = Rails.application.credentials.development[:redis_password]

  Sidekiq.configure_client do |config|
    config.redis = { url: REDIS_URL, password: REDIS_PASSWORD, size: 2}
  end
  Sidekiq.configure_server do |config|
    config.redis = { url: REDIS_URL, password: REDIS_PASSWORD, size: 20 }
  end

end

if Rails.env.production?
  REDIS_URL = Rails.application.credentials.production[:redis_url]
  REDIS_PASSWORD = Rails.application.credentials.production[:redis_password]

  Sidekiq.configure_client do |config|
    config.redis = { url: REDIS_URL, password: REDIS_PASSWORD, size: 2}
  end

  Sidekiq.configure_server do |config|
    config.redis = { url: REDIS_URL, password: REDIS_PASSWORD, size: 20 }

  end

end


