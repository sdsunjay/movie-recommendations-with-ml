# user
class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable
	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

	has_many :friendships
	has_many :users, through: :friendships

	has_many :reviews, dependent: :destroy
	has_many :movies, dependent: :destroy
	has_many :visits, class_name: "Ahoy::Visit"
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

		user = User.where(provider: auth.provider, uid: auth.uid).first
		if user.blank?

			# immediately get 60 day auth token
			oauth = Koala::Facebook::OAuth.new(ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_SECRET"])
			new_access_info = oauth.exchange_access_token_info auth.credentials.token

			new_access_token = new_access_info["access_token"]
			# Facebook updated expired attribute
			new_access_expires_at = DateTime.now + new_access_info["expires_in"].to_i.seconds

			user = User.new
			user.provider = auth.provider
			user.uid = auth.uid
			user.email = auth.info.email
			user.password = Devise.friendly_token[0,20]
			user.name = auth.info.name   # assuming the user has a name
			user.image = auth.info.image # assuming the user has an image
			user.gender = auth.extra.raw_info.gender # assuming the user has a gender
			user.access_level = 0
			user.link = auth.extra.raw_info.link
			unless auth.extra.raw_info.location.nil?
				user.location = auth.extra.raw_info.location['name'] # assuming the user has a location
			end
			unless auth.extra.raw_info.hometown.nil?
				user.hometown = auth.extra.raw_info.hometown['name'] # assuming the user has a hometown
			end
			user.token = new_access_token # originally auth.credentials.token
			user.token_expires_at = new_access_expires_at # originally Time.at(auth.credentials.expires_at)
			user.save(validate: false)
		else
			# check access_token
			user.access_token
		end
		user
	end

	def add_movies
		@facebook ||= client
		@movies = @facebook.get_object('me/movies/', {}, api_version: 'v3.1')
		puts @movies
		loop do
			break if @movies.blank?

			help_add_movies
			@movies = @movies.next_page
		end
	end

	def add_friends
		@facebook ||= client
		@friends = @facebook.get_connections('me', 'friends')
		puts @friends
		loop do
			break if @friends.blank?

			help_add_friends
			@friends = @friends.next_page
		end
	end

	def help_add_movies
		movie_names = @movies.collect { |f| f['name'] }
		user_movies = Movie.where('title in (?)', movie_names)
		if user_movies.present?
			user_movies.each do |user_movie|
				Review.create(movie_id: user_movie.id, user_id: id, rating: 5)
			end
		end
	end

		def help_add_friends
			uids = @friends.collect { |f| f['id'].to_s }
			user_friends = User.where('uid IN (?)', uids)
			if user_friends.present?
				user_friends.each do |user_friend|
					Friendship.create(friend_id: user_friend.id, user_id: id)
				end
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
			begin
				Koala::Facebook::API.new(access_token)
			rescue Koala::Facebook::APIError => exception
				if exception.fb_error_type == 190
					puts exception
					# password reset - redirect to auth dialog
				else
					raise "Facebook Error: #{exception.fb_error_type}"
				end
			end
		end

		def access_token
			send("facebook_refresh_token!", token) if expired?
			token
		end

		def facebook_refresh_token!(token)
			begin
				# Get refreshed 60 day auth token
				new_token_info = Koala::Facebook::OAuth.new.exchange_access_token_info(token)
				update(token: new_token_info["access_token"], token_expires_at: Time.zone.now + new_token_info["expires_in"])
			rescue Koala::Facebook::APIError => exception
				if exception.fb_error_type == 190
					puts exception
				else
					puts 'ELSE'
					puts exception
					# raise "Facebook Error: #{exception.fb_error_type}"
				end
			end
		end

    # Post to user's wall
    # TODO manage_pages and publish_pages permission needed
		def put_wall_post(message)
				title = message
				page_link = 'https://google.com'
				link_name = 'Google'
				description = 'Google Doodle'
				image_url = 'https://www.google.com/logos/2010/pacman10-hp.png'
				success_msg = 'Article Posted'
				@facebook ||= client()
				#put_wall_post is method to post an article to the pages
				post_info = @facebook.put_wall_post(title, {
					name: link_name, description: description, picture: image_url, link: page_link
				})
		end

	end
