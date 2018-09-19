class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
      # @user.update token: request.env['omniauth.auth'].credentials.token
      # @user.update friends: User.add_friends(@user.token)
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
    set_flash_message(:notice, :error, :kind => "Facebook") if is_navigational_format?
  end

end
