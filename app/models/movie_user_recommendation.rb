# frozen_string_literal: true

# a top level comment
class MovieUserRecommendation < ApplicationRecord
  default_scope { order(created_at: :desc) }
  # user will have recommendations for many movies
  belongs_to :user
  # movie will be recommended to many users
  belongs_to :movie
  validates_numericality_of :user_rating,
                            only_integer: true, allow_nil: true,
                            greater_than_or_equal_to: 1,
                            less_than_or_equal_to: 5,
                            message: 'Rating can only be whole number between 1 and 5.'
  validates :user_id, presence: true, uniqueness: { scope: :movie_id, message: :"This movie has already been recommended!" }
end
