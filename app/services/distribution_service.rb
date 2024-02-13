class DistributionService
  class NotTodayError < StandardError; end
  class NoMembersError < StandardError; end
  class NoMoneyError < StandardError; end
  class BelowMinimumDividendError < StandardError; end

  MINIMUM_DIVIDEND_IN_CENTS = 1000

  def call
    raise NotTodayError unless distribution_is_today?
    raise NoMembersError if member_count.zero?
    raise NoMoneyError if total_amount.zero?
    raise BelowMinimumDividendError if dividend_amount_in_base_units < minimum_dividend

    members.each do |member|
      create_dividend_and_send_notification(member)
    end
  end

  private

  def create_dividend_and_send_notification(member)
    dividend = member.dividends.create!(distribution:)
    DividendMailer.with(dividend:).new_dividend_notification.deliver_now
  end

  def distribution
    @distribution ||= Distribution.create! dividend_amount_in_base_units:
  end

  def dividend_amount_in_base_units
    total_amount / member_count
  end

  def member_count
    members.length
  end

  def minimum_dividend
    MINIMUM_DIVIDEND_IN_CENTS
  end

  def members
    ActiveMemberService.call
  end

  def total_amount
    @total_amount ||= TotalPoolService.balance_in_base_units
  end

  def distribution_is_today?
    DistributionDateService.today?
  end
end
