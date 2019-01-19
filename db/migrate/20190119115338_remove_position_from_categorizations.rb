class RemovePositionFromCategorizations < ActiveRecord::Migration[5.2]
  def change
    remove_column :categorizations, :position, :integer
  end
end
