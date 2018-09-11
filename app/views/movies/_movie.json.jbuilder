json.extract! movie, :id, :imdb_id, :title, :tagline, :status, :poster_path, :genre_id, :overview, :popularity, :budget, :release_date, :revenue, :runtime, :created_at, :updated_at
json.url movie_url(movie, format: :json)
