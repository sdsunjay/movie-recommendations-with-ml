class AddIndexToReviews < ActiveRecord::Migration[5.2]
  def change
    add_index(:reviews, [:movie_id, :user_id])
  end
end
