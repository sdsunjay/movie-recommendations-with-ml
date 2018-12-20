# frozen_string_literal: true

# a top level comment
class Education < ApplicationRecord
  has_many :users
  belongs_to :city, optional: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  default_scope { order(name: :asc) }

  def city_name
    if city_id
      city.city_and_state
    end
  end

  # attr_writer
  def city_name=(name)
    city_name = name.split(",")
    self.city = City.find_by(name: city_name[0]) if name.present?
  end
end
