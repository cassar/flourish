class NotificationMailer < ApplicationMailer
  default from: "Flourish Notifications <#{ENV['DEFAULT_FROM_EMAIL'] || 'notifications@example.com'}>"

  def new_contribution
    @contribution = params[:contribution]
    @member = @contribution.member
    @user = @member.user
    mail(to: @user.email, subject: I18n.t('mailers.notification_mailer.new_contribution_subject'))
  end

  def new_dividend
    @dividend = params[:dividend]
    @member = @dividend.member
    @distribution = @dividend.distribution
    @user = @member.user
    mail(to: @user.email, subject: I18n.t('mailers.notification_mailer.new_dividend_subject'))
  end

  def paid_out
    @dividend = params[:dividend]
    @member = @dividend.member
    @distribution = @dividend.distribution
    @user = @member.user
    mail(to: @user.email, subject: I18n.t('mailers.notification_mailer.paid_out_subject'))
  end

  def dividend_recontributed
    @dividend = params[:dividend]
    @member = @dividend.member
    @distribution = @dividend.distribution
    @user = @member.user
    mail(to: @user.email, subject: I18n.t('mailers.notification_mailer.dividend_recontributed_subject'))
  end
end
