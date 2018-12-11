#!/bin/sh
# https://stackoverflow.com/a/38732187/1935918
set -e

if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

# bundle exec rake db:create 2>/dev/null
bundle exec rake db:migrate 2>/dev/null

exec bundle exec "$@"

# rake genres:seed_genres
# rake db:seed:movies1
# rake db:seed:movies2
# rake db:seed:movies3
# rake db:seed:categorizations1
# rake db:seed:categorizations2
# rake db:seed:companies1
# rake db:seed:companies2
