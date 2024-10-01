class NotificationMailer < ApplicationMailer
  default from: "Flourish Notifications <#{ENV['DEFAULT_FROM_EMAIL'] || 'notifications@example.com'}>"

  def contribution_received
    @contribution = params[:contribution]
    @member = @contribution.member
    @user = @member.user
    mail(to: @user.email, subject: I18n.t('mailers.notification_mailer.contribution_received_subject'))
  end

  def dividend_received
    @dividend = params[:dividend]
    @member = @dividend.member
    @distribution = @dividend.distribution
    @user = @member.user
    mail(to: @user.email, subject: I18n.t('mailers.notification_mailer.dividend_received_subject'))
  end

  def dividend_paid_out
    @dividend = params[:dividend]
    @member = @dividend.member
    @distribution = @dividend.distribution
    @user = @member.user
    mail(to: @user.email, subject: I18n.t('mailers.notification_mailer.dividend_paid_out_subject'))
  end

  def dividend_automatically_recontributed
    @dividend = params[:dividend]
    @member = @dividend.member
    @distribution = @dividend.distribution
    @user = @member.user
    mail(to: @user.email, subject: I18n.t('mailers.notification_mailer.dividend_automatically_recontributed_subject'))
  end

  def distribution_settled
    @distribution = params[:distribution]
    @user = params[:user]
    mail(
      to: @user.email,
      subject: I18n.t(
        'mailers.notification_mailer.distribution_settled',
        distribution_name: @distribution.name
      )
    )
  end
end
