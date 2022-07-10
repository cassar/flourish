class DividendService::Dividend
  class << self
    MINIMUM_DIVIDEND = 10

    def next_dividend_amount
      next_paying_period.dividend
    end

    def next_dividend_date
      next_paying_period.dividend_date
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
          contributions: 500
        )
      end
    end

    def first_period
      DividendService::Period.new(
        duration: 1.week,
        start_date: Date.today,
        distribution: DividendService::Distribution.new(
          member_count: MemberCountService.call,
          available_funds: 500,
          minimum_dividend: MINIMUM_DIVIDEND
        )
      )
    end
  end
end
