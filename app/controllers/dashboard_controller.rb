class DashboardController < ApplicationController
  def welcome
    @member_count = ActiveMemberCountService.call
    @total_pool = BankAccountService.balance_formatted
    return unless user_signed_in?

    @member = current_user.member
  end
end
