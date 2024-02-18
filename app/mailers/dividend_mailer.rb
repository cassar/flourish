class DividendMailer < ApplicationMailer
  default from: "Flourish Notifications <#{ENV['DEFAULT_FROM_EMAIL'] || 'notifications@example.com'}>"

  def new_dividend_notification
    @dividend = params[:dividend]
    @member = @dividend.member
    @distribution = @dividend.distribution
    @user = @member.user
    mail(to: @user.email, subject: I18n.t('mailers.dividend_mailer.new_dividend_notification_subject'))
  end

  def pay_out_notification
    @dividend = params[:dividend]
    @member = @dividend.member
    @user = @member.user
    mail(to: User::ADMIN_EMAIL, subject: I18n.t('mailers.dividend_mailer.pay_out_notification_subject'))
  end

  def paid_out_notification
    @dividend = params[:dividend]
    @member = @dividend.member
    @distribution = @dividend.distribution
    @user = @member.user
    mail(to: @user.email, subject: I18n.t('mailers.dividend_mailer.paid_out_notification_subject'))
  end
end
