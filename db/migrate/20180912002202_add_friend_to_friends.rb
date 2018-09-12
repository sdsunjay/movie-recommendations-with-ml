class AddFriendToFriends < ActiveRecord::Migration[5.2]
  def change
    add_column :friendships, :friend_id, :bigint
    add_index :friendships, :friend_id
    add_foreign_key :friendships, :users, column: :friend_id, primary_key: :id, on_delete: :cascade
  end
end
