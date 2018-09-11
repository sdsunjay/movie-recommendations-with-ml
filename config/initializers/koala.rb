# In Rails, you could put this in config/initializers/koala.rb
Koala.configure do |config|
  config.app_id = FACEBOOK_CONFIG['app_id']
  config.app_secret = FACEBOOK_CONFIG['secret']
  # See Koala::Configuration for more options, including details on how to send requests through
  # your own proxy servers.
end
