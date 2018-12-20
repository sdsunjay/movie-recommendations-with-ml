class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.string :iso, size: 2
      t.string :name, size: 80, null: false
      t.string :printable_name, size: 80
      t.string :iso3, size: 3
      t.integer :numcode

      t.timestamps
    end
  end
end
