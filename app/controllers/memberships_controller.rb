class MembershipsController < ApplicationController
  include MemberFinancialSummary

  before_action :authenticate_user!
  before_action :set_member

  def show
    @total_contributed = total_contributed_formatted
    @total_dividends = total_dividends_formatted
    @pending_payout_count = @member.dividends.pending_pay_out.count
    @last_dividend = member_dividends(limit: 10).first
  end

  def dividends
    @dividends = member_dividends(limit: 10)
  end

  def contributions
    @contributions = @member.contributions.order(created_at: :desc).limit(10)
  end

  def notifications
    @notification_preferences = @member.notification_preferences.order(:notification_name)
  end

  private

  def set_member
    @member = current_user.member
  end
end
