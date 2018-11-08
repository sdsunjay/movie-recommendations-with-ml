# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
# threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
# threads threads_count, threads_count

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch("RAILS_ENV") { "development" }
threads_count  =  Integer(ENV["MAX_THREADS"] ||  1) # this is should be calculated so (web_concurrency * max_threads * num dynos) PLUS whatever other db threads will be used (by workers for example) is < than allowed heroku pg connections.
threads threads_count, threads_count

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
preload_app!
rackup DefaultRackup

  # easier to debug if development is running in single process
  # Specifies the number of `workers` to boot in clustered mode.
  # Workers are forked webserver processes. If using threads and workers together
  # the concurrency of the application would be max `threads` * `workers`.
  # Workers do not work on JRuby or Windows (both of which do not support
  # processes).
  #

  workers Integer(ENV["WEB_CONCURRENCY"] ||  1) # this should be upped in prod as it's using 3 for 1x dyno, 6 for 2x
  # bind "ssl://127.0.0.1:#{ENV['SSL_PORT'] || 3001}?key=#{ENV['SSL_KEY']}&cert=#{ENV['SSL_CERT']}"
  # Deamonize puma server to run in background
  # daemonize
  # Set up puma to listen on unix socket location(instead of tcp)
  #bind "unix://#{shared_dir}/sockets/rev1.sock?umask=0111"
  port ENV["PORT"] ||  3000
  # Redirect puma logs(access and error) for this site to shared/logs dir
  #stdout_redirect "shared/logs/rev1.stdout.log", "shared/logs/rev1.stderr.log", true
  # Set master PID and state locations
 # pidfile "shared/pids/rev1.pid"
  #state_path "shared/pids/rev1.state"
  #activate_control_app

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart


# Because we are using preload_app, an instance of our app is created by master process (calling our initializers) and then memory space
# is forked. So we should close DB connection in the master process to avoid connection leaks.
# https://github.com/puma/puma/issues/303
# http://stackoverflow.com/questions/17903689/puma-cluster-configuration-on-heroku
# http://www.rubydoc.info/gems/puma/2.14.0/Puma%2FDSL%3Abefore_fork
# Dont have to worry about Sidekiq's connection to Redis because connections are only created when needed. As long as we are not
# queuing workers when rails is booting, there will be no redis connections to disconnect, so it should be fine.

before_fork do
  puts "Puma master process about to fork. Closing existing Active record connections."
  require  "puma_worker_killer"
  unless  Rails.env.development? ||  Rails.env.test?
    PumaWorkerKiller.config do |config|
      config.ram           = 1024 # mb
      config.frequency     = 5    # seconds
      config.percent_usage = 0.98
      config.rolling_restart_frequency = 12 * 3600 # 12 hours in seconds, or 12.hours if using Rails
    end
    PumaWorkerKiller.start
  end
  ActiveRecord::Base.connection_pool.disconnect!
end
on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
