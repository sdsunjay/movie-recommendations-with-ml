# source: https://gist.github.com/mzaidannas/ee6b6b9bdb795816d4c2006a37d45dde
FROM ruby:2.5.1-alpine
# Set local timezone
RUN apk add --no-cache tzdata
ENV TZ America/Los_Angeles

# use with Yarn
# Install your app's runtime dependencies in the container
# RUN apk add --update --virtual runtime-deps postgresql-client nodejs libffi-dev readline sqlite

# Use virtual build-dependencies tag so we can remove these packages after bundle install
RUN apk update && apk add --update --no-cache --virtual build-dependency build-base ruby-dev mysql-dev postgresql-dev git sqlite-dev


# Install Yarn
#ENV PATH=/root/.yarn/bin:$PATH
#RUN apk add --virtual build-yarn curl && \
#    touch ~/.bashrc && \
#    curl -o- -L https://yarnpkg.com/install.sh | sh && \
#    apk del build-yarn

# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /var/www/movierecommendationswithml
# make a new directory where our project will be copied
RUN mkdir -p $RAILS_ROOT
# Set working directory within container
WORKDIR $RAILS_ROOT

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock


# RUN apk add --virtual build-deps build-base openssl-dev postgresql-dev libc-dev linux-headers libxml2-dev libxslt-dev readline-dev
# RUN gem install bundler && bundle install --jobs 20 --retry 5
# RUN apk del build-deps

# Setting env up
ENV RAILS_ENV production
ENV RAKE_ENV production
ENV RACK_ENV production

RUN bundle install --jobs 20 --retry 5 --without development test
# development/production differs in bundle install
#RUN if [[ "$RAILS_ENV" == "production" ]]; then\
# RUN bundle install --jobs 20 --retry 5 --without development test
# else bundle install --jobs 20 --retry 5; fi
# RUN if [ "$RAILS_ENV" == "production" ] ; then bundle install --jobs 20 --retry 5 --without development test ; else bundle install --jobs 20 --retry 5 ; fi

# Remove build dependencies and install runtime dependencies
RUN apk del build-dependency
RUN apk add --update mariadb-client-libs postgresql-client postgresql-libs sqlite-libs nodejs tzdata


# Adding project files
COPY . .
RUN bundle exec rake assets:precompile
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
