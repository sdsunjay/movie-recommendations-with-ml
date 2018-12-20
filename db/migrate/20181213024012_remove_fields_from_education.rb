class RemoveFieldsFromEducation < ActiveRecord::Migration[5.2]
  def change
    remove_column :educations, :city, :string
    remove_column :educations, :state, :string
  end
end
