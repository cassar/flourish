class StaticPagesController < ApplicationController
  def home
    @last_distribution = Distribution.last || Distribution.new(created_at: Time.zone.now)
    @last_amount = @last_distribution.default_amount || Amount.new(amount_in_base_units: 0)
    @last_distribution_dividends = @last_distribution.dividends
    @next_distribution = NextDistribution
    @total_pool = TotalPoolService
    authenticated_user
  end

  def about
    @active_member_count = Member.active.count
  end

  private

  def authenticated_user
    @member = if user_signed_in?
                current_user.member
              else
                Member.new(currency: 'AUD')
              end
  end
end
