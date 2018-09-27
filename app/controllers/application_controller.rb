class ApplicationController < ActionController::Base

  before_action :store_user_location!, if: :storable_location?
  # The callback which stores the current location must be added before you authenticate the user
  # as `authenticate_user!` (or whatever your resource is) will halt the filter chain and redirect
  # before the location can be stored.


  protect_from_forgery with: :exception

  rescue_from Koala::Facebook::AuthenticationError, with: :user_not_authorized

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || movies_path
  end

  def access_denied _auth_error = nil
    redirect_to authenticated_root_path
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

  def set_user
    @user = current_user
  end

  private
    # Its important that the location is NOT stored if:
    # - The request method is not GET (non idempotent)
    # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an
    #    infinite redirect loop.
    # - The request is an Ajax request as this can lead to very unexpected behaviour.
    def storable_location?
      request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
    end

    def store_user_location!
      # :user is the scope we are authenticating
      store_location_for(:user, request.fullpath)
    end


end
