class Movie < ApplicationRecord

    belongs_to :user
    has_many :review
    has_many :categorizations
    has_many :genres, through: :categorizations

    validates :title, presence:true
    validates :overview, presence:true
    validates :poster_path, presence:true
    validates :release_date, presence:true

    accepts_nested_attributes_for :categorizations, :reject_if => :all_blank, :allow_destroy => true
    accepts_nested_attributes_for :genres
    # def facebook
    #  @movies = Facebook.get_object(current_user.token, '/me/movies?fields=name')
    #end
    #
    #

   def self.search(title)
     Movie.where("title LIKE title")
   end

   def has_review(user_id, movie_id)
      return Review.exists?(user: user_id, movie_id: movie_id )
   end
   def movie_review(user_id, movie_id)
     return Review.where(user: user_id, movie_id: movie_id )
   end
end
