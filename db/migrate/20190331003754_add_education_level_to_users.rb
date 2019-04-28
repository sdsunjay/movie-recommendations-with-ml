class AddEducationLevelToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :education_level, :integer, limit: 1
  end
end
