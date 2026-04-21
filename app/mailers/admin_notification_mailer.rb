class AdminNotificationMailer < ApplicationMailer
  FROM_ADDRESS = (Rails.application.credentials.default_admin_notification_email ||
                  'admin-notifications@flourish.test').freeze
  default from: "Flourish Admin <#{FROM_ADDRESS}>"

  def pay_out_requested
    @dividend = params[:dividend]
    @member = @dividend.member
    @user = @member.user
    mail(to: User::ADMIN_EMAIL, subject: I18n.t('mailers.admin_notification_mailer.pay_out_requested_subject'))
  end

  def expenses_added
    @expenses = params[:expenses]
    mail(to: User::ADMIN_EMAIL, subject: I18n.t('mailers.admin_notification_mailer.expenses_added_subject'))
  end
end
