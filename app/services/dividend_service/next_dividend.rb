module DividendService
  class NextDividend
    attr_reader :total_contributions, :member_count, :total_pool

    def initialize(total_contributions:, member_count:, total_pool:)
      @total_contributions = total_contributions
      @member_count = member_count
      @total_pool = total_pool
    end

    MINIMUM_DIVIDEND = 10
    PERIOD_DURATION = 1.week
    NEVER = 'never'.freeze
    NOTHING = 0

    def amount
      next_paying_period.dividend
    rescue DividendService::Period::NoExtraFundsError
      NOTHING
    end

    def date
      next_paying_period.dividend_date
    rescue DividendService::Period::NoExtraFundsError
      nil
    end

    def amount_formatted
      Money.from_amount(amount).format
    end

    def date_formatted
      return NEVER if date.nil?

      date.to_fs(:long_ordinal)
    end

    private

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
        start_date: Time.zone.today,
        distribution: DividendService::Distribution.new(
          member_count:,
          available_funds: total_pool,
          minimum_dividend: MINIMUM_DIVIDEND
        )
      )
    end
  end
end
