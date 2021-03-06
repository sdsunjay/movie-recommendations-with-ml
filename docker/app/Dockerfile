# source: https://gist.github.com/mzaidannas/ee6b6b9bdb795816d4c2006a37d45dde
FROM ruby:2.6.0-alpine
# Set local timezone
RUN apk add --no-cache tzdata
ENV TZ America/Los_Angeles

# Use virtual build-dependencies tag so we can remove these packages after bundle install
RUN apk update && apk add --update --no-cache --virtual build-dependency build-base ruby-dev mysql-dev postgresql-dev git sqlite-dev

# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /movierecommendationswithml
# make a new directory where our project will be copied
RUN mkdir -p $RAILS_ROOT
# Set working directory within container
WORKDIR $RAILS_ROOT

# Do not install gem documentation
RUN echo 'gem: --no-ri --no-rdoc' > ~/.gemrc

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
COPY db/ db/
COPY lib/scripts/ lib/scripts/
# Setting env up
# ENV BUNDLE_PATH=/usr/local/bundle \
#    BUNDLE_BIN=/usr/local/bundle/bin \
#    GEM_HOME=/usr/local/bundle
#ENV PATH="${BUNDLE_BIN}:${PATH}"

ENV RAILS_ENV production
ENV RAKE_ENV production
ENV RACK_ENV production
ENV WEB_CONCURRENCY 4
ENV MAX_THREADS 2
ENV PORT 3000

ENV BUNDLE_PATH /bundle_cache
ENV GEM_PATH /bundle_cache
ENV GEM_HOME /bundle_cache
ENV BUNDLE_BIN /bundle_cache/bin
ENV PATH "${BUNDLE_BIN}:${PATH}"

RUN gem install bundler
RUN bundle config --global path "$GEM_HOME" && bundle config --global bin "$GEM_HOME/bin"
RUN bundle install --binstubs path="$BUNDLE_PATH" --without development test --jobs=4
RUN bundle update

# Remove build dependencies and install runtime dependencies
RUN apk del build-dependency
RUN apk add --update mariadb-client postgresql-client postgresql-libs sqlite-libs nodejs tzdata


# Adding project files
COPY . .

# In production you will very likely reverse proxy Rails with nginx.
# This sets up a volume so that nginx can read in the assets from
# the Rails Docker image without having to copy them to the Docker host.
VOLUME ["$RAILS_ROOT/public"]
RUN bundle exec rake assets:precompile
# This scripts runs `rake db:create` and `rake db:migrate` before
# running the command given
EXPOSE 3000
ENTRYPOINT ["lib/scripts/docker-entrypoint.sh"]
CMD ["bin/bundle", "exec", "puma", "-C", "config/puma.rb"]
