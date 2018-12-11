class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :store_user_location!, if: :storable_location?
  # The callback which stores the current location must be added before you authenticate the user
  # as `authenticate_user!` (or whatever your resource is) will halt the filter chain and redirect
  # before the location can be stored.

  # after_action :track_action

  protect_from_forgery with: :exception

  rescue_from Koala::Facebook::AuthenticationError, with: :user_not_authorized

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || user_path(resource) || request.env['omniauth.origin']
  end

  def access_denied(_auth_error = nil)
    if user_signed_in?
      redirect_to authenticated_root_path
    else
      redirect_to unauthenticated_root_path
    end
  end

  def user_not_authorized(_auth_error = nil)
    flash[:alert] = 'You need to login with Facebook to continue.'

    redirect_to destroy_user_session_path
  end

  def new_session_path(_scope)
    new_user_session_path
  end

  def authenticate
    redirect_to new_user_session_path unless user_signed_in?
  end

  def user_signed_in?
    # converts current_user to a boolean by negating the negation
    !!current_user
  end

  def require_admin
    unless current_user.admin? || current_user.super_admin?

      flash[:alert] = 'Access denied'
      redirect_back fallback_location: movies_path, allow_other_host: false
    end
  end

  def set_user
    return @user if defined? @user

    @user = current_user
  end

  def set_user_reviews
    return @user_reviews if defined? @user_reviews
    @user_reviews = @user.reviews
  end

  private

  # Its important that the location is NOT stored if:
  # - The request method is not GET (non idempotent)
  # - The request is handled by a Devise controller such as
  # Devise::SessionsController as that could cause an infinite redirect loop.
  # - The request is an Ajax request as
  # this can lead to very unexpected behaviour.
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  def track_action
    ahoy.track 'Ran action', request.path_parameters
  end

  def force_json
    request.format = :json
  end
end
