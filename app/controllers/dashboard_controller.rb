class DashboardController < ApplicationController
  after_action :start_member_generator

  def welcome
    @member_count = ActiveMemberCountService.call
    @dividend_amount = dividend.amount_formatted
    @total_pool = BankAccountService.balance_formatted
    return unless user_signed_in?

    @member = current_user.member
  end

  private

  def start_member_generator
    MemberGeneratorJob.perform_now
  end

  def dividend
    DividendService::NextDividend.new(
      total_contributions: TotalContributionsService.amount,
      member_count: @member_count,
      total_pool: BankAccountService.balance
    )
  end
end
