class CreateStates < ActiveRecord::Migration[5.2]
  def change
    create_table :states do |t|
      t.string :iso, size: 2
      t.string :name, size: 80, null: false
      t.references :country, index: true, null: false, foreign_key: true, default: 214
      t.timestamps
    end
  end
end
