class DividendsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorise_user!, only: %i[show pay_out recontribute]
  before_action :check_dividend_in_issued_state!, only: %i[pay_out recontribute]

  def index
    @dividends = current_user.member.dividends.order(created_at: :desc).preload(:distribution)
  end

  def show; end

  def pay_out
    dividend.pending_pay_out!
    AdminNotificationMailer.with(dividend:).pay_out_notification.deliver_later
    redirect_to dividends_path, notice: I18n.t('controllers.dividends.pay_out.success')
  end

  def recontribute
    dividend.recontributed!
    redirect_to dividends_path, notice: I18n.t('controllers.dividends.recontribute.success')
  end

  private

  def authorise_user!
    return if dividend.member == current_user.member

    redirect_to dividends_path, alert: I18n.t('controllers.dividends.not_authorised')
  end

  def check_dividend_in_issued_state!
    return if dividend.issued?

    redirect_to dividends_path, alert: I18n.t('controllers.dividends.already_updated')
  end

  def dividend
    @dividend ||= Dividend.find params[:id]
  end
end
