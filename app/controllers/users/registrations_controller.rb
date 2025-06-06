module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :check_hcaptcha, only: :create

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

    def check_hcaptcha
      return if verify_hcaptcha

      redirect_to new_user_registration_path, alert: I18n.t('controllers.users.registrations.alert')
    end
  end
end
