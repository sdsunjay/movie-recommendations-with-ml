class CreateCategorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :categorizations do |t|
      t.references :movie, index: true, null: false, foreign_key: true
      t.references :genre, index: true, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
