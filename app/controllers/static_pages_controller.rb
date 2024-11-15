class StaticPagesController < ApplicationController
  def home
    @last_distribution = Distribution.last || Distribution.new
    if (@unsettled = @last_distribution.dividends.issued.any?)
      @last_amount = @last_distribution.default_amount
      @last_distribution_dividends = @last_distribution.dividends
    else
      @next_distribution = NextDistributionService
    end
    authenticated_user
  end

  private

  def authenticated_user
    return unless user_signed_in?

    @member = current_user.member
  end
end
