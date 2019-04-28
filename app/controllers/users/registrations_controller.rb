# users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    stored_location_for(resource) || user_path(resource)
    # signed_in_root_path(resource)
  end

  def after_update_path_for(resource)
    signed_in_root_path(resource)
  end

  def sign_up_params
    accessible = %i[name email gender hometown location education_name birthday link password password_confirmation]
    params.require(:user).permit(accessible)
  end

  def account_update_params
    accessible = %i[gender hometown location education_name birthday link]
    params.require(:user).permit(accessible)
  end
end
