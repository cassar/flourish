class MembershipsController < ApplicationController
  before_action :authenticate_user!

  def show
    @member = current_user.member
    @dividends = member_dividends
    @contributions = @member.contributions.order(created_at: :desc).limit(10)
    @notification_preferences = @member.notification_preferences.order(:notification_name)
    @total_contributed = total_contributed_formatted
    @total_dividends = total_dividends_formatted
    @pending_payout_count = @member.dividends.pending_pay_out.count
  end

  private

  def member_dividends
    @member.dividends
      .includes(:amount, :pay_out, :distribution)
      .joins(:amount)
      .order('amounts.created_at DESC')
      .limit(10)
  end

  def total_contributed_formatted
    cents = @member.contributions.where(currency: 'AUD').sum(:amount_in_base_units)
    Money.new(cents, 'AUD').format(no_cents: true)
  end

  def total_dividends_formatted
    cents = @member.dividends
      .joins(:amount)
      .where(amounts: { currency: 'AUD' })
      .sum('amounts.amount_in_base_units')
    Money.new(cents, 'AUD').format(no_cents: true)
  end
end
