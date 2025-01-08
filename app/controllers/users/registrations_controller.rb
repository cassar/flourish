module Users
  class RegistrationsController < Devise::RegistrationsController
    def create
      super do |user|
        return unless user.persisted?

        user.create_member!
        user.member.create_notification_preferences!
      end
    end

    protected

    def after_inactive_sign_up_path_for(_resource)
      check_email_spam_path
    end
  end
end
