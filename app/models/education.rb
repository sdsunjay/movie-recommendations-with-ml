# frozen_string_literal: true

# a top level comment
class Education < ApplicationRecord
  has_many :users
  validates :name, presence: true

  default_scope { order(name: :asc) }
end
