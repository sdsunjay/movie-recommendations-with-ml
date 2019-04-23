class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :name, null: false
      t.text :description
      t.references :user, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
