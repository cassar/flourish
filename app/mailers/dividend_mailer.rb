class DividendMailer < ApplicationMailer
  default from: ENV['default_from_email'] || 'notifications@example.com'

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
    mail(to: User::ADMIN_EMAIL, subject: "#{@user.email} has requested a Pay Out")
  end
end
