module Users
  class ConfirmationsController < Devise::ConfirmationsController
    protected

    def after_confirmation_path_for(_resource_name, resource)
      sign_in(resource)
      membership_path
    end
  end
end
