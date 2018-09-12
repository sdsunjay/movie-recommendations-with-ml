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
    end
  end
end

  def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.name = auth.info.name   # assuming the user model has a name
    user.image = auth.info.image # assuming the user model has an image
    user.gender = auth.extra.raw_info.gender # assuming the user model has an image
    user.token = auth.credentials.token
  end
  user.add_friends
    user.save
    user
  end

  def add_friends
    @facebook.get_connection("me", "friends").each do |hash|
      self.friendships.where(:name => hash['name'], :uid => hash['id']).first_or_create
    end
  end

  private

  def facebook
    @facebook ||= Koala::Facebook::API.new(token)
  end


  # def facebook()
  #   @facebook ||= Koala::Facebook::API.new(token)
  #  block_given? ? yield(@facebook) : @facebook
    # rescue Koala::Facebook::APIError =>
      # logger.info e.to_s
    #  nil
    # TODO only store Facebook IDs, not other information
    # friends = facebook.get_connections("me", "friends")
    #facebook.get_object("me?fields=movies")
    # get_object("me") {|data| data['education']}  # => only education section of profile
    # return friends
  # end

  # def friends
  #  @friends = facebook { |fb| fb.get_connections("me", "friends") }
  #  user_friends = User.where(uid: @friends.map { |f| f['id'] })
  #  puts user_friends
  #end

end
