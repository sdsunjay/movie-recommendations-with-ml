# frozen_string_literal: true

# a top level comment
class Company < ApplicationRecord
  has_many :movie_production_companies
  has_many :movies, through: :movie_production_companies, dependent: :destroy

  validates :name, presence: true

  default_scope { order(name: :desc) }
end
