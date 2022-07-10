class DividendService::Period
  attr_reader :duration, :start_date, :distribution

  class NoExtraFundsError < StandardError; end

  def initialize duration:, start_date:, distribution:
    @duration = duration
    @start_date = start_date
    @distribution = distribution
  end

  def dividend_to_pay?
    distribution.dividend_to_pay?
  end

  def undistributed_funds
    distribution.available_funds
  end

  def dividend
    distribution.dividend
  end

  def dividend_date
    start_date + duration
  end

  def next_period contributions:
    raise NoExtraFundsError unless contributions.positive?

    DividendService::Period.new(
      duration: duration,
      start_date: next_start_date,
      distribution: DividendService::Distribution.new(
        member_count: distribution.member_count,
        available_funds: undistributed_funds + contributions,
        minimum_dividend: distribution.minimum_dividend
      )
    )
  end

  private

  def next_start_date
    start_date + duration
  end
end
