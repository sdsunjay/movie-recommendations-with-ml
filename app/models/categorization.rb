class Categorization < ApplicationRecord
  belongs_to :movie
  belongs_to :genre

  accepts_nested_attributes_for :movie, reject_if: :all_blank
end
