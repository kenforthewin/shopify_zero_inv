  require 'sidekiq/web'
  redis_url = "redis://redis:6379"
  
  Sidekiq.configure_server do |config|
    config.redis = { url: redis_url }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: redis_url }
  end
