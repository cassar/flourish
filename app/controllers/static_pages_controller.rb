class StaticPagesController < ApplicationController
  def home
    @last_distribution = Distribution.last || Distribution.new
    if (@unsettled = @last_distribution.dividends.issued.any?)
      @last_distribution_dividends = @last_distribution.dividends
    else
      distribution_preview
    end
    authenticated_user
  end

  private

  def distribution_preview
    @member_count = Member.active.count
    @total_pool = TotalPoolService.balance_formatted
    @next_dividend_amount_formatted = DividendAmountService.new(
      total_pool_in_base_units: TotalPoolService.balance_in_base_units,
      member_count: @member_count
    ).amount_formatted
  end

  def authenticated_user
    return unless user_signed_in?

    @member = current_user.member
  end
end
