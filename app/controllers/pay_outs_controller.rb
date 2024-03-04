class PayOutsController < ApplicationController
  before_action :authenticate_user!

  def index
    @member = current_user.member
    @dividends = @member.dividends.paid_out.or(@member.dividends.pending_pay_out).order(created_at: :desc)
  end
end
