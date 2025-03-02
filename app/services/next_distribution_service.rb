class NextDistributionService
  class << self
    def distribute!
      DistributionService.new(
        number:,
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
      Distribution.new(number:).name
    end

    def date_formatted
      DistributionDateService.next_date_formatted
    end

    def total_pool_formatted(currency)
      total_pool.balance_formatted(currency)
    end

    def dividend_amount_formatted(currency)
      dividend_amount.amount_formatted(currency)
    end

    delegate :today?, to: :DistributionDateService

    private

    def number
      NextDistributionNumberService.call
    end

    def amounts
      DividendAmountsService.new(
        amount_in_base_units:,
        currency: 'AUD'
      ).call
    end

    def amount_in_base_units
      dividend_amount.amount_in_aud_base_units
    end

    def dividend_amount
      DividendAmountService.new(
        total_pool_in_aud_base_units:,
        member_count:
      )
    end

    def total_pool_in_aud_base_units
      total_pool.balance_in_aud_base_units
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
