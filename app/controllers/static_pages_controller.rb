class StaticPagesController < ApplicationController
  after_action :start_member_generator

  def welcome
    @member_count = MemberCountService.call
    @contribution_total = TotalContributionsService.formatted
    @dividend_amount = dividend.amount_formatted
    @dividend_date = dividend.date_formatted
  end

  private

  def start_member_generator
    MemberGeneratorJob.perform_now
  end

  def dividend
    DividendService::NextDividend.new(
      total_contributions: TotalContributionsService.amount,
      member_count: @member_count
    )
  end
end
