class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  # :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  has_many :reviews
  has_many :movies
  has_many :friendships
  validates_uniqueness_of :email

  enum access_level: [:user, :admin, :super_admin]

  def self.new_with_session(params, session)
  super.tap do |user|
    if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
      user.email = data["email"] if user.email.blank?
      user.friends = add_friends(user.id, user.token)
    end
  end
end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user has a name
      user.image = auth.info.image # assuming the user has an image
      user.gender = auth.extra.raw_info.gender # assuming the user has a gender
      unless auth.extra.raw_info.location.nil?
        user.location = auth.extra.raw_info.location['name'] # assuming the user has a location
      end
      unless auth.extra.raw_info.hometown.nil?
        user.hometown = auth.extra.raw_info.hometown['name'] # assuming the user has a hometown
      end
      user.token = auth.credentials.token
      # TODO - add this
      # user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save
      add_friends(user.id, user.token)
      add_movies(user.id, user.token)
      user
    end
  end

  # @movies = Facebook.get_object(current_user.token, '/me/movies?fields=name,picture,studio')
  def self.add_movies(user_id, token)
    @graph = Koala::Facebook::API.new(token)
    # movies = @graph.get_object("me", "movies?fields=name")
    movies = @graph.get_object("me?fields=movies")
    # puts movies
    unless movies.nil?
      movies.each_with_index do |hash, index|
        @movies = Movie.where(title: hash[index]['name'])
        @movies.each do |movie|
          Review.where(user: user_id, movie_id: movie.id).first_or_create
        end
      end
    end
  end

  def self.add_friends(user_id, token)
    @facebook ||= Koala::Facebook::API.new(token)
    friends = @facebook.get_connection("me", "friends")
    puts friends
    unless friends.nil?
      friends.each_with_index do |hash, index|
        @users = User.where(uid: hash[index]['id'])
        @users.each do |friend|
          Friendship.where(user: user_id, friend_id: friend.id).first_or_create
        end
      end
    end
  end

  private

  def old_friends(token)
    @facebook ||= Koala::Facebook::API.new(token)
    #facebook.get_object("me?fields=name,picture")
    # TODO only store Facebook IDs, not other information
    friends = @facebook.get_connections("me", "friends")
    return friends
  end
  # def friends
  #  @friends = facebook { |fb| fb.get_connections("me", "friends") }
  #  user_friends = User.where(uid: @friends.map { |f| f['id'] })
  #  puts user_friends
  #end

  #def facebook
  #  @facebook ||= Koala::Facebook::API.new(token)
  #end


  # def facebook()
    # @facebook ||= Koala::Facebook::API.new(token)
    # block_given? ? yield(@facebook) : @facebook
    # rescue Koala::Facebook::APIError =>
    # logger.info e.to_s
    #  nil
    # TODO only store Facebook IDs, not other information
    # friends = facebook.get_connections("me", "friends")
    #facebook.get_object("me?fields=movies")
    # get_object("me") {|data| data['education']}  # => only education section of profile
    # return friends
  # end

end
