# frozen_string_literal: true

# a top level comment
class City < ApplicationRecord
  belongs_to :state
  has_many :educations
  validates :name, presence: true
  validates :state_id, presence: true,
                      uniqueness: { scope: :name,
                                    message: 'City and State already exists!' }
  default_scope { order(name: :asc) }

  def city_and_state
    name + ', ' + state.name
  end

end
