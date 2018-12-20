# frozen_string_literal: true

# a top level comment
class Country < ApplicationRecord
  has_many :states
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  default_scope { order(name: :asc) }
end
