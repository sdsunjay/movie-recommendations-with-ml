# frozen_string_literal: true

# a top level comment
class Genre < ApplicationRecord
  has_many :categorizations
  has_many :movies, through: :categorizations, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  default_scope { order(name: :desc) }
  accepts_nested_attributes_for :categorizations, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :movies
end
