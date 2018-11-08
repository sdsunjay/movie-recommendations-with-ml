class Contact < ActiveRecord::Base
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  belongs_to :user

  validates :name, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :message, presence: true

end
