class CreateMovieUserRecommendations < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_user_recommendations do |t|
      t.references :movie, index: true, null: false, foreign_key: true
      t.references :user, index: true, null: false, foreign_key: true
      t.decimal :confidence, precision: 15, scale: 15
      t.integer :user_rating, limit: 1
      t.timestamps
    end
  end
end
