class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.references :user, index: true, null: false, foreign_key: true
      t.timestamps
    end
  end
end
