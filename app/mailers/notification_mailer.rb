class NotificationMailer < ApplicationMailer
  default from: "Flourish Notifications <#{ENV['DEFAULT_FROM_EMAIL'] || 'notifications@example.com'}>"

  def new_contribution_notification
    @contribution = params[:contribution]
    @member = @contribution.member
    @user = @member.user
    mail(to: @user.email, subject: I18n.t('mailers.notification_mailer.new_contribution_notification_subject'))
  end

  def new_dividend_notification
    @dividend = params[:dividend]
    @member = @dividend.member
    @distribution = @dividend.distribution
    @user = @member.user
    mail(to: @user.email, subject: I18n.t('mailers.notification_mailer.new_dividend_notification_subject'))
  end

  def paid_out_notification
    @dividend = params[:dividend]
    @member = @dividend.member
    @distribution = @dividend.distribution
    @user = @member.user
    mail(to: @user.email, subject: I18n.t('mailers.notification_mailer.paid_out_notification_subject'))
  end
end
