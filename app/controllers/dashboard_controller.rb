class DashboardController < ApplicationController
  def dashboard
    @member_count = ActiveMemberCountService.call
    @total_pool = TotalPoolService.balance_formatted
    return unless user_signed_in?

    @member = current_user.member
  end

  def distributions
    @distributions = Distribution.order(created_at: :desc).preload(:dividends)
  end
end
