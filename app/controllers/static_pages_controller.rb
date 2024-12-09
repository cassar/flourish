class StaticPagesController < ApplicationController
  def home
    @last_distribution = Distribution.last || Distribution.new
    unless @last_distribution.settled?
      @last_amount = @last_distribution.default_amount
      @last_distribution_dividends = @last_distribution.dividends
    else
      @next_distribution = NextDistributionService
    end
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
