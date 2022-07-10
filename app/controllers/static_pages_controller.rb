class StaticPagesController < ApplicationController
  after_action :start_member_generator

  def welcome
    @member_count = MemberCountService.call
    @contribution_total = ContributionTotalService.call
  end

  private

  def start_member_generator
    MemberGeneratorJob.perform_now
  end
end
