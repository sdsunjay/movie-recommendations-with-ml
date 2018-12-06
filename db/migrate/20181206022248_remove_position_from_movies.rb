class RemovePositionFromMovies < ActiveRecord::Migration[5.2]
  def change
    remove_column :movies, :position, :integer
  end
end
