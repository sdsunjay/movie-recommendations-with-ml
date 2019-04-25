# frozen_string_literal: true

# a top level comment
class MovieList < ApplicationRecord
  default_scope { order(created_at: :desc) }
  # list can have many  movies
  belongs_to :list
  # list can have many movies
  belongs_to :movie, -> { order(created_at: :desc) }
  validates :list_id,
            presence: { message: 'Movie must belong to a list' }
  validates :movie_id,
            presence: { message: 'Specify Movie ID' }
  # the user cannot add the same movie to a list twice
  validates :movie_id,
            uniqueness: { scope: :list_id,
                          message: "You've already added this movie!" }

  # no more than 100 movies per list
  def limit_exceeded?(max = 100)
    self.lists.count >= max
  end

end
