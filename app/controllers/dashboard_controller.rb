class DashboardController < ApplicationController
  def welcome
    @member_count = ActiveMemberCountService.call
    @dividend_amount = Money.from_amount(DividendService::NextDividend::MINIMUM_DIVIDEND).format
    @total_pool = BankAccountService.balance_formatted
    return unless user_signed_in?

    @member = current_user.member
  end
end
