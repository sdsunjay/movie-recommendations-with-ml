# frozen_string_literal: true

# a top level comment
class Movie < ApplicationRecord
  default_scope { order(popularity: :desc) }
  has_many :movie_user_recommendations, dependent: :delete_all
  has_many :users, -> { select(:name, :id) }, through: :movie_user_recommendations
  has_many :reviews, -> { select(:rating, :id, :created_at).order(created_at: :desc) }, dependent: :delete_all
  has_many :categorizations, dependent: :delete_all
  has_many :genres, -> { select(:name, :id) }, through: :categorizations

  has_many :movie_production_companies, -> { select(:created_at, :confidence) }, dependent: :delete_all
  has_many :companies, -> { select(:name, :id) }, through: :movie_production_companies
  has_many :movie_lists, dependent: :delete_all
  has_many :lists, -> { select(:name, :id) }, through: :movie_lists

  validates :title, presence: true
  # validates :overview, presence: true
  # validates :poster_path, presence: true
  # validates :release_date, presence: true

  accepts_nested_attributes_for :categorizations,
                                reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :genres

  enum status: { rumored: 1, planned: 2, in_production: 3, post_production: 4, released: 0, cancelled: 5 }

  def self.search(pattern)
    # blank? covers both nil and empty string
    if pattern.blank?
      all
    else
      where(arel_table[:title].lower.matches("%#{pattern}%".downcase))
    end
  end

  def self.released?
    status == 'released' ? (return True) : (return False)
  end
end
