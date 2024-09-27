class StaticPagesController < ApplicationController
  def home
    @member_count = Member.active.count
    @total_pool = TotalPoolService.balance_formatted
    @last_distribution = Distribution.last
    @unsettled = @last_distribution.nil? || @last_distribution.dividends.issued.any?
    @next_dividend_amount_formatted = DividendAmountService.new(
      total_pool_in_base_units: TotalPoolService.balance_in_base_units,
      member_count: @member_count
    ).amount_formatted
    return unless user_signed_in?

    @member = current_user.member
  end
end
