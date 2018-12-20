class AddPositionToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :position, :integer, null: false, default: 0
  end
end
