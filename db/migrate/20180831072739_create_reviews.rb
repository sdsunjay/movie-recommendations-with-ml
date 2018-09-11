class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :user, index: true, null: false, foreign_key: true
      t.references :movie, index: true, null: false, foreign_key: true
      t.integer :rating, null: false, default: 0

      t.timestamps
    end
  end
end
