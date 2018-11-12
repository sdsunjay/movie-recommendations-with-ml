json.extract! movie_user_recommendation, :id, :movie_id, :user_id, :confidence, :user_rating, :created_at, :updated_at
json.url movie_user_recommendation_url(movie_user_recommendation, format: :json)
