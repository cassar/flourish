class DividendService::Dividend
  attr_reader :total_contributions, :member_count

  def initialize(total_contributions:, member_count: )
    @total_contributions = total_contributions
    @member_count = member_count
  end

  MINIMUM_DIVIDEND = 10
  PERIOD_DURATION = 1.week
  NEVER = 'never'
  NOTHING = 0

  def amount_formatted
    Money.from_amount(next_dividend_amount).format
  rescue DividendService::Period::NoExtraFundsError
    Money.from_amount(NOTHING).format
  end

  def date_formatted
    next_dividend_date.to_formatted_s(:long_ordinal)
  rescue DividendService::Period::NoExtraFundsError
    NEVER
  end

  private

  def next_dividend_amount
    next_paying_period.dividend
  end

  def next_dividend_date
    next_paying_period.dividend_date
  end

  def next_paying_period
    last_period = first_period
    loop do
      return last_period if last_period.dividend_to_pay?

      last_period = last_period.next_period(contributions: total_contributions)
    end
  end

  def first_period
    DividendService::Period.new(
      duration: PERIOD_DURATION,
      start_date: Date.today,
      distribution: DividendService::Distribution.new(
        member_count: member_count,
        available_funds: total_contributions,
        minimum_dividend: MINIMUM_DIVIDEND
      )
    )
  end
end
