class State < ApplicationRecord
  belongs_to :country
  has_many :cities
  validates :name, presence: true

  default_scope { order(name: :asc) }
end
