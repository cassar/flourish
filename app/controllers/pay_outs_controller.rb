class PayOutsController < ApplicationController
  before_action :authenticate_user!

  def index
    @member = current_user.member
    @dividends = @member.dividends.pay_out_complete
                        .or(@member.dividends.pending_pay_out)
                        .order(created_at: :desc)
                        .preload(:pay_out)
  end
end
