# frozen_string_literal: true

# a top level comment
class Review < ApplicationRecord
  # user will review many movies
  belongs_to :user
  # movie will have many reviews
  belongs_to :movie
  validates :user_id,
            presence: { message: 'Your review must belong to a user' }
  validates :movie_id,
            presence: { message: 'Your review must belong to a movie' }
  validates :rating,
            presence: { message: 'You must give the movie a rating' }
  validates_numericality_of :rating,
                            only_integer: true, allow_nil: false,
                            greater_than_or_equal_to: 1,
                            less_than_or_equal_to: 5,
                            message: 'Rating can only be whole number between 1 and 5.'
  # the user cannot review the same movie twice
  validates :movie_id,
            uniqueness: { scope: :user_id,
                          message: "You've already reviewed this movie!" }

  def reviewed?(movie_id)
    return if Review.exists?(user: user, movie_id: movie_id)
  end

end
