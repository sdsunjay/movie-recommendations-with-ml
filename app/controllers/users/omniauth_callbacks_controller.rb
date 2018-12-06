require_dependency 'add_friends_to_user_worker'
require_dependency 'add_movies_to_user_worker'
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_user_service

  def facebook
    handle_auth 'Facebook'
  end

  def handle_auth(kind)
    if @user.present?
      # user exists
      @user.access_token
      logger.debug "user is present: #{@user.attributes.inspect}"
      # this will throw if @user is not activated
      sign_in_and_redirect @user, event: :authentication
    else
      logger.debug "help handle auth"
      help_handle_auth(kind)
    end
  end

  def help_handle_auth(kind)
    begin
      # user does not exist
      intent = request.env['omniauth.params']['intent']
      @user = User.from_omniauth(auth)
      if @user.persisted?
        ahoy.track 'New user sign up', name: @user.name
        begin
          AddMoviesToUserWorker.perform_async(@user.id)
          AddFriendsToUserWorker.perform_async(@user.id)
        rescue # StandardError
          logger.debug "Error: Unable to connect to Redis"
        end
        sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
        set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
      else
        session['devise.facebook_data'] = auth
        flash[:notice] = "Error: Your #{kind} account was not connected."
        redirect_back fallback_location: new_user_session_path, allow_other_host: false
      end
    rescue ActiveRecord::RecordNotFound
      # handle not found error
      logger.debug "Record not found"
    rescue ActiveRecord::ActiveRecordError
      # handle other ActiveRecord errors
      logger.debug "ActiveRecord Error"
    rescue Timeout::Error
      logger.debug "Timeout Error"
    rescue Errno::EINVAL
      logger.debug "Errno EINVAL"
    rescue Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      logger.debug "Error: Unable to connect to Redis"
    rescue # StandardError
      logger.debug "Error: Unable to connect to Redis"
      # handle most other errors
    rescue Exception
      # handle everything else
      raise
    end
  end

  def failure
    redirect_back fallback_location: new_user_session_path, allow_other_host: false
    flash[:notice] = "Error: Your Facebook account was not connected."
  end

  def auth
    return request.env['omniauth.auth']
  end

  def set_user_service
    return @user if defined? @user
    if auth
      provider = auth.provider
      uid = auth.uid
      email = auth.info.email
    else
      logger.debug 'returning nil for set_user_service'
    end
    if user_signed_in?
      @user = current_user
    elsif User.where(provider: provider, uid: uid).exists?
      @user = User.where(provider: provider, uid: uid).first
    elsif User.where(email: email).exists?
      # 5. User is logged out and
      # they login to a new account which doesn't match their old one
      flash[:alert] = "An account with this email already exists. Please sign in with that account before connecting your Facebook account."
      redirect_to new_user_session_path
    end
  end
end
