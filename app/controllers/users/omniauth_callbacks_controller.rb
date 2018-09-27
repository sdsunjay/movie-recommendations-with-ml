class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    # TODO fix this
    intent = request.env["omniauth.auth"]["intent"]
    @user = User.from_omniauth(request.env["omniauth.auth"])
    # @user = User.from_omniauth(auth, current_user)
    #puts auth
    if @user.persisted?
      #if intent == "sign_in"
        #  puts intent
        # Don't create a new identity
      if intent == "sign_up"
        puts intent
        # sign up flow, such as:
        # @user.add_friends
        # @user.add_movies
      end
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to unauthenticated_root_path
    end
  end

  def failure
    redirect_to unauthenticated_root
    set_flash_message(:notice, :error, :kind => "Facebook") if is_navigational_format?
  end

end
