class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.text :message, null: false
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
