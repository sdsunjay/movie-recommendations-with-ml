class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friendship, class_name: 'User', foreign_key: 'friend_id'
  validates :user_id, presence: true, uniqueness: { scope: :friend_id, message: 'You cannot be friends with yourself!' }
  validates :friend_id, uniqueness: { scope: :user_id, message: "You're already friends!" }
end
