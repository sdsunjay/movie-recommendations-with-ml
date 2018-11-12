class RemoveUserIdFromMovies < ActiveRecord::Migration[5.2]
  def change
    remove_column :movies, :user_id, :integer
  end
end
