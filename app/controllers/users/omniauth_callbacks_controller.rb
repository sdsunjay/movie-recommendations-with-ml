class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_user_service

  def facebook
    handle_auth "Facebook"
  end

  def handle_auth(kind)
    if @user.present?
      # user exists
      @user.access_token
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
    else
      # user does not exist
      #user.services.create(service_attrs)
      intent = request.env['omniauth.params']['intent']
      @user = User.from_omniauth(auth)
      if @user.persisted?
        if intent == "sign_up"
          @user.add_friends
          @user.add_movies
        end
        sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
      else
        session["devise.facebook_data"] = auth
        flash[:notice] = "Error: Your #{kind} account was not connected."
        redirect_back fallback_location: new_user_session_path, allow_other_host: false
      end
    end
  end

  def failure
    redirect_back fallback_location: new_user_session_path, allow_other_host: false
    flash[:notice] = "Error: Your #{kind} account was not connected."
  end

  def auth
    request.env['omniauth.auth']
  end

  def set_user_service
    return @user if defined? @user
    if user_signed_in?
      @user = current_user
    else
      @user = User.where(provider: auth.provider, uid: auth.uid).first
      if @user.blank?
        @user = User.where(email: auth.info.email)
        if @user.present?
          puts @user
          # 5. User is logged out and they login to a new account which doesn't match their old one
          flash[:alert] = "An account with this email already exists. Please sign in with that account before connecting your #{auth.provider.titleize} account."
          redirect_to new_user_session_path
        end
      end
    end
  end
end
