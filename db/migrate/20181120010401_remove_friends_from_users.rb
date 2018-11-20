class RemoveFriendsFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :friends, :text
  end
end
