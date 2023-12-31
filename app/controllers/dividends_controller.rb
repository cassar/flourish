class DividendsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorise_user!
  before_action :check_dividend_in_issued_state!

  def pay_out
    dividend.pay_out!
    DividendMailer.with(dividend:).pay_out_notification.deliver_later
    redirect_to dividends_path, notice: I18n.t('controllers.dividends.pay_out.success')
  end

  private

  def authorise_user!
    return if dividend.member == current_user.member

    redirect_to dividends_path, alert: I18n.t('controllers.dividends.pay_out.not_authorised')
  end

  def check_dividend_in_issued_state!
    return if dividend.issued?

    redirect_to dividends_path, alert: I18n.t('controllers.dividends.pay_out.already_marked_for_pay_out')
  end

  def dividend
    Dividend.find params[:id]
  end
end
