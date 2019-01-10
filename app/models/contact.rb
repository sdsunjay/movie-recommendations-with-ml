# frozen_string_literal: true

# a top level comment
class Contact < ActiveRecord::Base
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  belongs_to :user, optional: true

  validates :name, presence: true
  validates :email, presence: true
  validates :message, presence: true

  default_scope { order(created_at: :desc) }
end
