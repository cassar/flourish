class ActivationsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @member = current_user.member
    @dividend_amount = current_next_dividend.amount_formatted
    @dividend_date = current_next_dividend.date_formatted
    @direction_of_amount_change_message = new_member_next_dividend_amount_compare.formatted
    @direction_of_time_change_message = new_member_next_dividend_date_compare.formatted
  end

  def update
    @member = current_user.member

    @member.active!
    flash[:success] = I18n.t('controllers.activations.update.success')
    redirect_to root_path
  end

  private

  def new_member_next_dividend_amount_compare
    DividendService::NextDividendAmountCompare.new(current_next_dividend:, future_next_dividend:)
  end

  def new_member_next_dividend_date_compare
    DividendService::NextDividendDateCompare.new(current_next_dividend:, future_next_dividend:)
  end

  def current_next_dividend
    DividendService::NextDividend.new(
      total_contributions: TotalContributionsService.amount,
      member_count: active_member_count
    )
  end

  def future_next_dividend
    DividendService::NextDividend.new(
      total_contributions: future_total_contributions,
      member_count: future_active_member_count
    )
  end

  def future_total_contributions
    TotalContributionsService.amount + @member.contribution_amount
  end

  def future_active_member_count
    active_member_count + 1
  end

  def active_member_count
    ActiveMemberCountService.call
  end
end
