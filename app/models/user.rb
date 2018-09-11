class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  # :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  has_many :reviews
  has_many :movies
  validates_uniqueness_of :email

  def self.new_with_session(params, session)
  super.tap do |user|
    if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
      user.email = data["email"] if user.email.blank?
    end
  end
end

  def self.from_omniauth(auth)
    puts auth
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.name = auth.info.name   # assuming the user model has a name
    user.image = auth.info.image # assuming the user model has an image
    user.gender = auth.extra.raw_info.gender # assuming the user model has an image
    user.token = auth.credentials.token
  end
end

  def self.koala(auth)
    access_token = auth.token
    facebook = Koala::Facebook::API.new(access_token)
    #facebook.get_object("me?fields=name,picture")
    # TODO only store Facebook IDs, not other information
    friends = facebook.get_connections("me", "friends")
    return friends
  end

end
