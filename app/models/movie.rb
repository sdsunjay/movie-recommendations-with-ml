# frozen_string_literal: true

# a top level comment
class Movie < ApplicationRecord
  belongs_to :user
  has_many :review, dependent: :delete_all
  has_many :categorizations, dependent: :delete_all
  has_many :genres, ->{ select(:name, :id) }, through: :categorizations

  validates :title, presence: true
  validates :overview, presence: true
  validates :poster_path, presence: true
  validates :release_date, presence: true

  accepts_nested_attributes_for :categorizations,
                                reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :genres

  def self.search(pattern)
    # blank? covers both nil and empty string
    if pattern.blank?
      all
    else
      where(arel_table[:title].lower.matches("%#{pattern}%".downcase))
    end
  end

  def movie_review(user_id, movie_id)
    Review.where(user: user_id, movie_id: movie_id).first
  end
end
