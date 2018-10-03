# users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    signed_in_root_path(resource)
  end

  def after_update_path_for(resource)
    signed_in_root_path(resource)
  end
end
