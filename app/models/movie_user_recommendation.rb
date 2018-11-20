class MovieUserRecommendation < ApplicationRecord
  default_scope { order(created_at: :desc) }
  # user will have recommendations for many movies
  belongs_to :user
  # movie will be recommended to many users
  belongs_to :movie
end
