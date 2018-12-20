class AddPageNumberToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :page_number, :smallint, null: false, default: 0
  end
end
