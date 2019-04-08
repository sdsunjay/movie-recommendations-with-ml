class List < ApplicationRecord
  default_scope { order(created_at: :desc) }
  # user can have many lists of movies
  belongs_to :user
  has_many :movie_lists, dependent: :delete_all
  has_many :movies, -> { select(:title, :id, :poster_path, :updated_at, :popularity ) }, through: :movie_lists
  validates :user_id,
            presence: { message: 'Your list must belong to a user' }
  validates :name,
            presence: { message: 'Your list must have a name' }

  def owned_by?(user_id)
    self.user_id == user_id
  end

end
