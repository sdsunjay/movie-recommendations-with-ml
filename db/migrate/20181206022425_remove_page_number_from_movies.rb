class RemovePageNumberFromMovies < ActiveRecord::Migration[5.2]
  def change
    remove_column :movies, :page_number, :integer
  end
end
