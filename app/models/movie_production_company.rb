# frozen_string_literal: true

# a top level comment
class MovieProductionCompany < ApplicationRecord
  belongs_to :movie
  belongs_to :company
end
