# frozen_string_literal: true

# a top level comment
class Categorization < ApplicationRecord
  belongs_to :movie
  belongs_to :genre

  accepts_nested_attributes_for :movie, reject_if: :all_blank
end
