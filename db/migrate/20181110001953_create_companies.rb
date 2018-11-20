class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.text :description
      t.string :headquarters
      t.string :homepage
      t.string :logo_path
      t.string :origin_country
      t.references :company, index: true, foreign_key: true

      t.timestamps
    end
  end
end
