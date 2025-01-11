class NextDistributionService
  class << self
    def distribute!
      DistributionService.new(
        name:,
        members:,
        amounts:,
        notification_enabled_member_ids:
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

    def total_pool_formatted(currency)
      total_pool.balance_formatted(currency)
    end

    def dividend_amount_formatted(currency)
      dividend_amount.amount_formatted(currency)
    end

    private

    def amounts
      DividendAmountsService.new(
        amount_in_base_units:,
        currency: 'AUD'
      ).call
    end

    delegate :amount_in_base_units, to: :dividend_amount

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

    def notification_enabled_member_ids
      members
        .joins(:notification_preferences)
        .where(notification_preferences: {
          id: NotificationPreference.dividend_received,
          enabled: true
        })
        .pluck(:id)
    end
  end
end
