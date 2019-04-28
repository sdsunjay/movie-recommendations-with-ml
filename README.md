# README
movie-recommendations-with-ml
====

> ROR app for users to rate movies and get recommendations for other movies they may like.

### Getting started

```
$ clone repo && cd movie-recommendations-with-ml
$ bundle install
```

Edit **config/credentials.yml.enc**. See [rails 5.2 encrypted credentials](https://gorails.com/episodes/rails-5-2-encrypted-credentials) for more info.

```
development:
  facebook_app_id: <APP_ID>
  facebook_secret: <SECRET>
  redis_url: redis://127.0.0.1:6379
  redis_password: <PASSWORD>
  facebook_callback_url:<CALLBACK_URL>
  blazer_database_url: <BLAZER_DATABASE_URL>
  send_grid_username: <USERNAME>
  send_grid_password: <PASSWORD>
```

```
$ rake db:create
$ rake db:migrate
$ rake genres:seed_genres
$ rake users:seed_users
$ rake movies:seed_movies # files hidden
$ redis-server /usr/local/etc/redis.conf
$ bundle exec sidekiq -C config/sidekiq.yml
$ bundle exec puma -C config/puma.rb
```

To release to production with Docker
```
$ docker-compose build
$ docker-compose run app rake db:create db:migrate

# Optional
$ docker-compose up
$ docker ps
```

Remove all containers
```
# bash/zsh
$ docker volume prune
$ docker volume ls
$ docker-compose rm -f
$ docker rm $(docker ps -a -q) -f
$ docker rmi $(docker images -q)

# fish
$ docker rm (docker ps -a -q)
$ docker rmi (docker images -q)
```

### Technologies used

- Ruby On Rails
- Devise for Authentication
- Omniauth and Koala for Facebook
- Sidekiq
- Redis
- Puma
- Docker
