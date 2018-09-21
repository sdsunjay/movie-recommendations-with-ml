class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  rescue_from Koala::Facebook::AuthenticationError, with: :user_not_authorized


  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  def access_denied _auth_error = nil
    redirect_to root_path
  end

  def user_not_authorized _auth_error = nil
    flash[:alert] = 'You need to login with Facebook to continue.'

    redirect_to destroy_user_session_path
  end

  def new_session_path(_scope)
    new_user_session_path
  end

  def authenticate
  	redirect_to :login unless user_signed_in?
  end

  def user_signed_in?
  	# converts current_user to a boolean by negating the negation
  	!!current_user
  end

  def require_admin
    unless current_user.admin? || current_user.super_admin?
      redirect_to movies_path, alert: 'Access denied.'
    end
  end

end
