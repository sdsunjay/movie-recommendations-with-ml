# In Rails, you could put this in config/initializers/koala.rb
Koala.configure do |config|
  config.app_id = FACEBOOK_APP_ID
  config.app_secret = FACEBOOK_SECRET
  config.api_version = 'v3.1'
  # See Koala::Configuration for more options, including details on how to send requests through
  # your own proxy servers.
end
