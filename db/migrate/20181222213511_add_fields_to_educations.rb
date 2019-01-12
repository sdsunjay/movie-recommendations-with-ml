class AddFieldsToEducations < ActiveRecord::Migration[5.2]
  def change
    add_column :educations, :phone, :string
    add_column :educations, :place_id, :string
    add_column :educations, :url, :string
    add_column :educations, :lat, :string
    add_column :educations, :lng, :string
  end
end
