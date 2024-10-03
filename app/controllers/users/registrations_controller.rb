module Users
  class RegistrationsController < Devise::RegistrationsController
    def create
      super do |user|
        user.create_member! if user.persisted?
      end
    end

    protected

    def after_inactive_sign_up_path_for(_resource)
      check_email_spam_path
    end
  end
end
