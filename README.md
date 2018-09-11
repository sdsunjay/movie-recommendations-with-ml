# README
movie-recommendations-with-ml
====

> ROR app for users to rate movies and get recommendations for other movies they may like.

### Getting started

```
$ clone repo && cd hitch_a_ride
$ bundle install
```

Create a **config/secrets.yml**

```
development:
  secret_token: 8ff532f2a7cd70372d910d4222aa57c7959faf683420aae287e1b364fceb829d827253e90af602316032368affa85d1310e081abe23abca0cb6852ed0357bdb1
  secret_key_base: SOMEKEY
```

```
$ rake db:migrate
$ rails s
```

### Technologies used

- Ruby On Rails
- Devise for Authentication
