# frozen_string_literal: true

# a top level comment
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable,
         omniauth_providers: [:facebook]

  has_many :friendships, -> { order(created_at: :desc) }
  has_many :friends, through: :friendships, dependent: :destroy
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  has_many :movie_user_recommendations, -> { order(created_at: :desc) }
  has_many :movies, through: :movie_user_recommendations, dependent: :destroy
  has_many :reviews, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :lists, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :visits, class_name: 'Ahoy::Visit'
  belongs_to :education, optional: true
  after_create :create_list
  validates_presence_of :name
  validates_uniqueness_of :email
  validate :validate_age, if: proc { |u| u.birthday.present? }
  has_one_attached :photo

  ACCESS_LEVEL = %i[user admin super_admin]
  enum access_level: ACCESS_LEVEL
  enum education_level: %i[in_high_school high_school trade_school in_college undergrad_degree in_grad_school grad_degree]

  def create_list
    list = List.create(user_id: self.id, name: 'Watchlist', description: 'Movies you have not seen, but would like to watch.')
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if session['devise.facebook_data'] &&
         session['devise.facebook_data']['extra']['raw_info']
        user.email = session['devise.facebook_data']['email'] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    if user.blank?
      user = create_new_user(auth)
    else
      # check access_token
      user.access_token
    end
    user
  end

  def self.create_new_user(auth)
    # immediately get 60 day auth token
    oauth = Koala::Facebook::OAuth.new(
      ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET']
    )
    new_access_info = oauth.exchange_access_token_info auth.credentials.token

    new_access_token = new_access_info['access_token']
    # Facebook updated expired attribute
    new_access_expires_at = DateTime.now +
                            new_access_info['expires_in'].to_i.seconds

    user = User.new
    user.provider = auth.provider
    user.uid = auth.uid

    nil if check_user_email?(auth.info.email) == false
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    user.name = auth.info.name   # assuming the user has a name
    user.image = auth.info.image # assuming the user has an image
    user.gender = auth.extra.raw_info.gender # assuming the user has a gender
    user.access_level = 0
    user.link = auth.extra.raw_info.link
    # TODO - Add back this permission once it is approved by Facebook
    # unless auth.extra.raw_info.birthday.nil?
      # the user has a birthday
      # user.birthday = Date.strptime(auth.extra.raw_info.birthday,'%m/%d/%Y')
    # end
    unless auth.extra.raw_info.location.nil?
      # the user has a location
      user.location = auth.extra.raw_info.location['name']
    end
    unless auth.extra.raw_info.hometown.nil?
      # assuming the user has a hometown
      user.hometown = auth.extra.raw_info.hometown['name']
    end
    # originally auth.credentials.token
    user.token = new_access_token
    # originally Time.at(auth.credentials.expires_at)
    user.token_expires_at = new_access_expires_at
    if user.save(validate: false)
      user
    else
      logger.debug "User did not save: #{user}"
       nil
      # throw error
    end
  end

  def check_user_email?(email)
    if email.include? 'tfbnw.net'
      logger.debug "Bad user! Did not save: #{auth.info.email}"
      false
    end
    if email.include? 'geogatedproject'
      logger.debug "Bad user! Did not save: #{auth.info.email}"
      false
    end
    true
  end

  # TODO: paging does not work anymore
  def add_movies
    # @facebook ||= client
    # @graph = Koala::Facebook::API.new(access_token)
    # @movies = @graph.get_object('me?fields=movies', {}, api_version: 'v3.1')
    # @movies = @graph.get_object('me?fields=movies')
    # logger.debug "movies are present: #{@movies['data']}"
    @facebook ||= client
    @movies = @facebook.get_object('me?fields=movies.limit(500)')
    unless @movies.nil?
      help_add_movies
    end
    rescue Koala::Facebook::APIError => exception
      logger.debug "Facebook client error. Type unknown: #{exception}"
      nil
  end

  def add_friends
    @facebook ||= client
    @friends = @facebook.get_connections('me', 'friends')
    logger.debug 'Friends are present: #{@friends}'
    loop do
      break if @friends.blank?

      help_add_friends
      @friends = @friends.next_page
    end
  end

  def help_add_movies
    # julian suggested this and it doesn't work
    # movie_names = @movies["movies"]["data"].pluck(:name)
    movie_names = @movies['movies']['data'].collect { |f| f['name'] }
    # puts movie_names
    logger.debug 'movie_names are present: #{movie_names}'
    # TODO - this does not work when a title appears in db more than once
    # Both are added to the user's liked movies, like in the case of aaron and 'Superbad'
    user_movies = Movie.where(title: movie_names)
    # puts user_movies
    user_movies.each do |user_movie|
      Review.create(movie_id: user_movie.id, user_id: id, rating: 5)
    end
  end

  def help_add_friends
    # julian suggested this and it doesn't work
    # uids = @friends.pluck(:id)
    uids = @friends.collect { |f| f['id'].to_s }
    logger.debug 'user Facebook ids are present: #{uids}'
    user_friends = User.where(uid: uids)
    user_friends.each do |user_friend|
      Friendship.create(friend_id: user_friend.id, user_id: id)
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
  rescue Koala::Facebook::APIError => exception
    if exception.fb_error_type == 190
      logger.debug "Facebook client error. Type 190: #{exception}"
      nil
      # TODO: password reset - redirect to auth dialog
    else
      logger.debug "Facebook client error. Type unknown: #{exception}"
      nil
      # raise "Facebook Error: #{exception.fb_error_type}"
      # TODO: handle unknown error
    end
  end

  def access_token
    send('facebook_refresh_token!', token) if expired?
    token
  end

  def facebook_refresh_token!(token)
    # Get refreshed 60 day auth token
    new_token_info = Koala::Facebook::OAuth.new
                                           .exchange_access_token_info(token)
    update(token: new_token_info['access_token'],
           token_expires_at: Time.zone.now + new_token_info['expires_in'])
  rescue Koala::Facebook::APIError => exception
    if exception.fb_error_type == 190
      logger.debug "Facebook refresh token. Error type 190: #{exception}"
      nil
    else
      logger.debug "Facebook refresh token. Error type unknown: #{exception}"
      nil
      # raise "Facebook Error: #{exception.fb_error_type}"
    end
  end

  # Post to user's wall
  # TODO: manage_pages and publish_pages permission needed
  # TODO: actually test this
  def put_wall_post(message)
    title = message
    page_link = 'https://google.com'
    link_name = 'Google'
    description = 'Google Doodle'
    image_url = 'https://www.google.com/logos/2010/pacman10-hp.png'
    @facebook ||= client
    # put_wall_post is method to post an article to the pages
    # @graph.put_connections("me", "feed", message: "I am writing on my wall!")
    post_info = @facebook.put_wall_post(title,
                                        name: link_name,
                                        description: description,
                                        picture: image_url,
                                        link: page_link)
  end

  def reviewed?(movie_id)
    Review.where(movie_id: movie_id, user_id: id).exists?
  end

  def review(movie_id)
    Review.where(movie_id: movie_id, user_id: id).first
  end

  def education_name
    if education_id
      education.name
    end
  end

  # attr_writer
  def education_name=(name)
    self.education = Education.find_or_create_by(name: name) if name.present?
  end

  def check_user(user_id)
    if not user_id
      return self
    end
    if id == user_id
      return self
    else
      if Friendship.where(user_id: id, friend_id: user_id).exists?
        return User.find(user_id)
      end
    end
    return self
  end

  # no more than 2 lists per user
  def list_limit_exceeded?(max = 2)
    self.lists.count >= max
  end

  private

  def validate_age
    return if valid_date_range.include?(birthday)
    errors.add(:birthday, 'invalid. Must be 12-100 years of age')
  end

  def valid_date_range
    maximum_date..minimum_date
  end

  def minimum_date
    12.years.ago.to_date
  end

  def maximum_date
    100.years.ago.to_date
  end


end
