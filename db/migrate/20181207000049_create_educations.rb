class CreateEducations < ActiveRecord::Migration[5.2]
  def change
    create_table :educations do |t|
      t.string :name, null: false
      t.string :address
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :homepage
      t.string :abbreviation

      t.timestamps
    end
  end
end
