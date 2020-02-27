class AddPoliticsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :politics, :integer, limit: 1
  end
end
