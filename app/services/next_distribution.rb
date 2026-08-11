class NextDistribution
  attr_reader :pool

  def initialize(pool:)
    @pool = pool
  end

  def self.today?
    DistributionDateService.today?
  end

  def distribute!
    DistributionService.new(
      pool:,
      number:,
      members:,
      amounts:,
      notification_enabled_member_ids:
    ).call
  end

  def members
    pool.recipients.merge(Member.active)
  end

  def member_count
    members.count
  end

  def name
    Distribution.new(number:).name
  end

  private

  def number
    NextDistributionNumberService.call(pool)
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
    TotalPool.new(pool)
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
