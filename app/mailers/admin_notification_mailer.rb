class AdminNotificationMailer < ApplicationMailer
  default from: "Flourish Admin <#{ENV['DEFAULT_ADMIN_NOTIFICATION_EMAIL'] || 'admin-notifications@example.com'}>"

  def pay_out_requested
    @pay_out = params[:pay_out]
    @member = @pay_out.dividend.member
    @user = @member.user
    mail(to: User::ADMIN_EMAIL, subject: I18n.t('mailers.admin_notification_mailer.pay_out_requested_subject'))
  end

  def expenses_added
    @expenses = params[:expenses]
    mail(to: User::ADMIN_EMAIL, subject: I18n.t('mailers.admin_notification_mailer.expenses_added_subject'))
  end
end
