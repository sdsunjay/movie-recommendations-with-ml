class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  # :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]
  # has_many :friendships, class_name:  "Friendship",
  #   foreign_key: "friend_id",
  #  dependent:   :destroy
  has_many :reviews, dependent: :destroy
  has_many :movies, dependent: :destroy
  has_many :friendships, dependent: :destroy
  validates_uniqueness_of :email

  enum access_level: [:user, :admin, :super_admin]

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        # user.friends = add_friends
      end
    end
  end

  def self.from_omniauth(auth)

     # immediately get 60 day auth token
    oauth = Koala::Facebook::OAuth.new(ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_SECRET"])
    new_access_info = oauth.exchange_access_token_info auth.credentials.token

    new_access_token = new_access_info["access_token"]
    # Facebook updated expired attribute
    new_access_expires_at = DateTime.now + new_access_info["expires_in"].to_i.seconds

    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
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
      user.token = new_access_token # originally auth.credentials.token
      user.token_expires_at = new_access_expires_at # originally Time.at(auth.credentials.expires_at)
      user.save
      user
    end
  end

  # fbgraph(token).get_object(id, args, options, &block)
  # @movies = Facebook.get_object(current_user.token, '/me/movies?fields=name,picture,studio')
  # Facebook.get_object(current_user.token, '/me/books?fields=name,picture,written_by')

  def add_movies
    @facebook ||= client()
    @movies = @facebook.get_object("me/movies/", {}, api_version: "v3.1")
    loop do
      if @movies.present?
        # TODO do where for all movies on page, (less queries = faster)
        @movies.each do |hash|
          @user_movie = Movie.where("title = ?", hash["name"])
          @user_movie.each do |movie|
            Review.create(movie_id: movie.id, user_id: id, rating: 5)
          end
        end
      else
        break
      end
      @movies = @movies.next_page

    end
  end

  def add_friends
    @facebook ||= client
    @friends = @facebook.get_connections("me", "friends")
    loop do
      if @friends.present?
        # TODO do where for all friends on page, (less queries = faster)
        @friends.each do |hash|
          # {"name"=>"Sunjay Dhama", "id"=>"10205306719984646"}
          @user_friends = User.where(["uid = '%s'", hash["id"].to_s])
          @user_friends.each do |friend|
            Friendship.create(friend_id: friend.id, user_id: id)
          end
        end
      else
        break
      end
      @friends = @friends.next_page
    end

  end

  def client
    # send("#{provider}_client")
    facebook_client
  end

  def expired?
      token_expires_at? && token_expires_at <= Time.zone.now
  end

   def facebook_client
    Koala::Facebook::API.new(access_token)
  end

  def access_token
    # send("#{provider}_refresh_token!", super) if expired?
    facebook_refresh_token if expired?
    token
  end

  def facebook_refresh_token
    # Get refreshed 60 day auth token
    oauth = Koala::Facebook::OAuth.new(ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_SECRET"])
    new_access_info = oauth.exchange_access_token_info token
    update(token: new_access_info["access_token"], token_expires_at: DateTime.now + new_access_info["expires_in"].to_i.seconds)
  end

  def put_wall_post(message)
    @graph.put_wall_post(message)
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
