class DistributionService
  class NotTodayError < StandardError; end
  class NoMembersError < StandardError; end
  class NoMoneyError < StandardError; end
  class BelowMinimumDividendError < StandardError; end

  MINIMUM_DIVIDEND_IN_CENTS = 1000

  def call
    raise NotTodayError unless distribution_is_today?
    raise NoMembersError if member_count.zero?
    raise NoMoneyError if no_money?
    raise BelowMinimumDividendError if below_minimum_dividend?

    members.each do |member|
      create_dividend_and_send_notification(member)
    end
  end

  private

  def create_dividend_and_send_notification(member)
    dividend = member.dividends.create!(distribution:)
    NotificationMailer.with(dividend:).new_dividend.deliver_now
  end

  def distribution
    @distribution ||= Distribution.create! dividend_amount_in_base_units:
  end

  def dividend_amount_in_base_units
    total_amount_in_base_units / member_count
  end

  def member_count
    members.count
  end

  def below_minimum_dividend?
    dividend_amount_in_base_units < minimum_dividend
  end

  def minimum_dividend
    MINIMUM_DIVIDEND_IN_CENTS
  end

  def members
    Member.active
  end

  def no_money?
    total_amount_in_base_units.zero?
  end

  def total_amount_in_base_units
    @total_amount_in_base_units ||= TotalPoolService.balance_in_base_units
  end

  def distribution_is_today?
    DistributionDateService.today?
  end
end
