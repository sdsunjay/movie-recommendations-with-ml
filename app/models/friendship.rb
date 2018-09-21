class Friendship < ApplicationRecord
  belongs_to :user
	belongs_to :friend, class_name: "User"
  validates :user_id, presence: true
  validates :friend_id, uniqueness: { scope: :user_id, message: "You're already friends!" }
end
