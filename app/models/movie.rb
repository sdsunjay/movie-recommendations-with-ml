class Movie < ApplicationRecord

  belongs_to :user
  has_many :review, dependent: :delete_all
  has_many :categorizations, dependent: :delete_all
  has_many :genres, through: :categorizations

  validates :title, presence:true
  validates :overview, presence:true
  validates :poster_path, presence:true
  validates :release_date, presence:true

  accepts_nested_attributes_for :categorizations, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :genres

  def self.search(pattern)
    if pattern.blank?  # blank? covers both nil and empty string
      all
    else
      where('title LIKE ?', "%#{pattern}%")
    end
  end

  def movie_review(user_id, movie_id)
    return Review.where(user: user_id, movie_id: movie_id )
  end
end
