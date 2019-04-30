#!/bin/sh
# https://stackoverflow.com/a/38732187/1935918
set -e

# Remove a potentially pre-existing server.pid for Rails.
if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

# bundle exec rake assets:precompile
# bundle exec rake db:create 2>/dev/null
# bundle exec rake db:migrate 2>/dev/null
# bundle exec rake db:reset DISABLE_DATABASE_ENVIRONMENT_CHECK=1

bundle exec rake db:environment:set RAILS_ENV=production

if [[ $? != 0 ]]; then
  echo
  echo "== Failed to migrate. Running setup first."
  echo
  bundle exec rake db:setup
fi
# bundle check || bundle install --binstubs="$BUNDLE_BIN"
# Execute the given or default command:
exec "$@"
