module Users
  class RegistrationsController < Devise::RegistrationsController
    protected

    def after_inactive_sign_up_path_for(_resource)
      check_email_spam_path
    end
  end
end
