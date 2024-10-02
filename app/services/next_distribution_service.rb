class NextDistributionService
  class << self
    def distribute!
      DistributionService.new(
        members:,
        name:,
        dividend_amount_in_base_units:
      ).call
    end

    def members
      Member.active
    end

    def member_count
      members.count
    end

    def name
      NextDistributionNameService.call
    end

    def date_formatted
      DistributionDateService.next_date_formatted
    end

    def today?
      DistributionDateService.today?
    end

    def total_pool_formatted
      total_pool.balance_formatted
    end

    def dividend_amount_formatted
      dividend_amount.amount_formatted
    end

    def dividend_amount_in_base_units
      dividend_amount.amount_in_base_units
    end

    private

    def dividend_amount
      DividendAmountService.new(
        total_pool_in_base_units:,
        member_count:
      )
    end

    def total_pool_in_base_units
      total_pool.balance_in_base_units
    end

    def total_pool
      TotalPoolService
    end
  end
end
