app_dir  =  File.expand_path("../..", __FILE__)
shared_dir  =  "#{app_dir}/tmp"

environment ENV["RACK_ENV"] ||  "development"
threads_count  =  Integer(ENV["MAX_THREADS"] ||  1) # this is should be calculated so (web_concurrency * max_threads * num dynos) PLUS whatever other db threads will be used (by workers for example) is < than allowed heroku pg connections.
threads threads_count, threads_count

preload_app!
rackup DefaultRackup

if  ENV["RACK_ENV"].nil? ||  ENV["RACK_ENV"] ==  "development"  # don't need this for production just local
  port ENV["PORT"] ||  3000
else
  # easier to debug if development is running in single process
  workers Integer(ENV["WEB_CONCURRENCY"] ||  1) # this should be upped in prod as it's using 3 for 1x dyno, 6 for 2x
  # bind "ssl://127.0.0.1:#{ENV['SSL_PORT'] || 3001}?key=#{ENV['SSL_KEY']}&cert=#{ENV['SSL_CERT']}"
  # Deamonize puma server to run in background
  daemonize
  # Set up puma to listen on unix socket location(instead of tcp)
  #bind "unix://#{shared_dir}/sockets/rev1.sock?umask=0111"
  port ENV["PORT"] ||  3000
  # Redirect puma logs(access and error) for this site to shared/logs dir
  stdout_redirect "#{shared_dir}/logs/rev1.stdout.log", "#{shared_dir}/logs/rev1.stderr.log", true
  # Set master PID and state locations
  pidfile "#{shared_dir}/pids/rev1.pid"
  state_path "#{shared_dir}/pids/rev1.state"
  activate_control_app
end

before_fork do
  require  "puma_worker_killer"
  unless  Rails.env.development? ||  Rails.env.test?
    PumaWorkerKiller.enable_rolling_restart(3  *  3600)
  end
  ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end

on_restart do
  Sidekiq.redis.shutdown(&:close)
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
