class CreateMovieProductionCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_production_companies do |t|

      t.references :movie, index: true, null: false, foreign_key: true
      t.references :company, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
