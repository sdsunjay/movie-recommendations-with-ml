class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  # :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  has_many :reviews, dependent: :destroy
  has_many :movies, dependent: :destroy
  has_many :friendships, dependent: :destroy
  validates_uniqueness_of :email

  enum access_level: [:user, :admin, :super_admin]

  # TODO - this may need to be moved
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
      user
    end
    # add_friends(auth.credentials.token)
    # add_movies(auth.credentials.token)
  end

  # fbgraph(token).get_object(id, args, options, &block)
  # @movies = Facebook.get_object(current_user.token, '/me/movies?fields=name,picture,studio')
  # Facebook.get_object(current_user.token, '/me/books?fields=name,picture,written_by')

  def self.add_movies
    @graph = Koala::Facebook::API.new(self.token)
    # movies = @graph.get_object("me", "movies?fields=name")
    # @movies = @graph.get_object("/me/movies?fields=name")
    @movies = @graph.get_object("me/movies/", {}, api_version: "v3.1")
    # TODO - add pagination
    puts 'Movies: '
    puts @movies
    unless @movies.nil?
      @movies.each do |hash|
        # puts hash
        @user_movie = Movie.where("title = ?", hash["name"])
        @user_movie.each do |movie|
          Review.create(movie_id: movie.id, user_id: self.id, rating: 5)
        end
        # Review.where(user: user_id, movie_id: @movie.id).first_or_create
      end
    end
  end

  def self.add_friends
    @facebook ||= Koala::Facebook::API.new(self.token)
    @friends = @facebook.get_connection("me", "friends")
    # TODO - add pagination
    puts @friends
    unless @friends.nil?
      # @user_friends= User.where(["uid = '%s'", @friends.to_s])
      # @user_friends =  User.where(["uid = :id", @friends])
      # @user_friends.each do |friend|
      #  puts @friend.id
      #  User.friendships.create(user_id: user_id, friends_id: @friend.id)
      #end
      # puts 'USERS: '
      # puts @users
      @friends.each do |hash|
        # {"name"=>"Sunjay Dhama", "id"=>"10205306719984646"}
        @user_friends = User.where(["uid = '%s'", hash["id"].to_s])
        @user_friends.each do |friend|
          Friendship.create(friend_id: friend.id, user_id: self.user_id)
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
