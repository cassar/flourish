class AdminNotificationMailer < ApplicationMailer
  default from: "Flourish Admin <#{ENV['DEFAULT_ADMIN_NOTIFICATION_EMAIL'] || 'admin-notifications@example.com'}>"

  def pay_out_notification
    @dividend = params[:dividend]
    @member = @dividend.member
    @user = @member.user
    mail(to: User::ADMIN_EMAIL, subject: I18n.t('mailers.admin_notification_mailer.pay_out_notification_subject'))
  end
end
