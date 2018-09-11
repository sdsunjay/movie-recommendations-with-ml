class Genre < ApplicationRecord

  has_many :categorizations
  has_many :movies, through: :categorizations

  validates :name, presence:true

  accepts_nested_attributes_for :categorizations, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :movies
end
