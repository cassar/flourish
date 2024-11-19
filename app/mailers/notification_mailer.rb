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
    @amount = @dividend.amount
    @user = @member.user
    mail(to: @user.email, subject: I18n.t('mailers.notification_mailer.dividend_received_subject'))
  end

  def dividend_paid_out
    @pay_out = params[:pay_out]
    @dividend = @pay_out.dividend
    @member = @dividend.member
    @amount = @dividend.amount
    @user = @member.user
    mail(to: @user.email, subject: I18n.t('mailers.notification_mailer.dividend_paid_out_subject'))
  end

  def dividend_automatically_recontributed
    @dividend = params[:dividend]
    @member = @dividend.member
    @amount = @dividend.amount
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

  def distribution_preview
    @user = params[:user]
    @member = @user.member
    @next_distribution = NextDistributionService
    @recent_contributions = Contribution.where(created_at: 1.week.ago..Time.zone.now)
    @expenses = WeeklyExpensesService.last_weeks_expenses
    @total_expenses_formatted = WeeklyExpensesService.last_weeks_expeneses_total_formatted
    mail(
      to: @user.email,
      subject: I18n.t(
        'mailers.notification_mailer.distribution_preview',
        distribution_name: @next_distribution.name
      )
    )
  end
end
