class AddCityIdToEducations < ActiveRecord::Migration[5.2]
  def change
    add_column :educations, :city_id, :integer
  end
end
