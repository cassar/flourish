class DashboardController < ApplicationController
  after_action :start_member_generator

  def welcome
    @member_count = ActiveMemberCountService.call
    @dividend_amount = Money.from_amount(DividendService::NextDividend::MINIMUM_DIVIDEND).format
    @total_pool = BankAccountService.balance_formatted
    return unless user_signed_in?

    @member = current_user.member
  end

  private

  def start_member_generator
    MemberGeneratorJob.perform_now
  end
end
