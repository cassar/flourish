class StaticPagesController < ApplicationController
  after_action :start_member_generator

  def welcome
    @member_count = MemberCountService.call
    @contribution_total = TotalContributionsService.formatted
    @dividend_amount = DividendService::Dividend.next_dividend_amount
    @dividend_date = DividendService::Dividend.next_dividend_date
  end

  private

  def start_member_generator
    MemberGeneratorJob.perform_now
  end
end
