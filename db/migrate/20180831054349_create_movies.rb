class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.references :user, index: true, null: false, foreign_key: true
      t.integer :vote_count
      t.numeric :vote_average, precision: 3, scale: 2
      t.string :title, null: false, unique: true
      t.string :tagline
      t.integer :status
      t.string :poster_path
      t.string :original_language
      t.string :backdrop_path
      t.boolean :adult
      t.text :overview
      t.numeric :popularity, precision: 6, scale: 3
      t.datetime :release_date, null: false
      t.bigint :budget
      t.string :revenue
      t.integer :runtime

      t.timestamps
    end
  end
end
