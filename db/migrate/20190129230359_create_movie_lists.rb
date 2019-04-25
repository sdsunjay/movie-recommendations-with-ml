class CreateMovieLists < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_lists do |t|
      t.references :movie, index: true, null: false, foreign_key: true
      t.references :list, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
