class DividendService::Dividend
  class << self
    MINIMUM_DIVIDEND = 10
    NEVER = 'never'
    NOTHING = 0

    def next_dividend_amount
      Money.from_amount(next_paying_period.dividend).format
    rescue DividendService::Period::NoExtraFundsError
      Money.from_amount(NOTHING).format
    end

    def next_dividend_date
      next_paying_period.dividend_date.to_formatted_s(:long_ordinal)
    rescue DividendService::Period::NoExtraFundsError
      NEVER
    end

    private

    def next_paying_period
      periods.find(&:dividend_to_pay?)
    end

    def periods
      periods = [first_period]
      loop do
        return periods if (last_period = periods.last).dividend_to_pay?

        periods << last_period.next_period(
          contributions: TotalContributionsService.amount
        )
      end
    end

    def first_period
      DividendService::Period.new(
        duration: 1.week,
        start_date: Date.today,
        distribution: DividendService::Distribution.new(
          member_count: MemberCountService.call,
          available_funds: TotalContributionsService.amount,
          minimum_dividend: MINIMUM_DIVIDEND
        )
      )
    end
  end
end
