# frozen_string_literal: true

# a top level comment
class Friendship < ApplicationRecord
  after_create :create_inverse_relationship
  after_destroy :destroy_inverse_relationship

  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  validate :not_self
  validates :user_id, presence: true,
                      uniqueness: { scope: :friend_id,
                                    message: :"You're already friends!" }
  validates :friend_id,
            uniqueness: { scope: :user_id,
                          message: "You're already friends!" }

  private

  def create_inverse_relationship
    friend.friendships.create(friend: user)
  end

  def destroy_inverse_relationship
    friendship = friend.friendships.find_by(friend: user)
    friendship.destroy if friendship
  end

  def not_self
    errors.add(:friend, "can't be equal to user") if user == friend
  end

end
