class Review < ApplicationRecord

  # user will review many movies
	belongs_to :user
	# post will have many reviews
	belongs_to :movie
	validates :user_id, presence: { message: 'Your review must belong to a user'}
	validates :movie_id, presence: { message: 'Your review must belong to a movie'}
  validates :rating, presence: { message: 'You must give the movie a rating'}

	# the driver (owner of the post) can review multiple passengers, but not the same passenger in the same post
  validates :movie_id, uniqueness: { scope: :user_id, message: "You've already reviewed this movie!" }
  def has_review?
    return if Review.exists?(user: user, movie_id: movie_id)
  end

end
