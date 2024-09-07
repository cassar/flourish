class DistributionService
  class NotTodayError < StandardError; end
  class NoMembersError < StandardError; end
  class BelowMinimumDividendError < StandardError; end

  MINIMUM_DIVIDEND_IN_CENTS = 1000

  attr_accessor :run_today, :members, :total_pool_in_base_units

  def initialize(run_today:, members:, total_pool_in_base_units:)
    @run_today = run_today
    @members = members
    @total_pool_in_base_units = total_pool_in_base_units
  end

  def call
    raise NotTodayError unless run_today
    raise NoMembersError if members.empty?
    raise BelowMinimumDividendError if below_minimum_dividend?

    members.each do |member|
      create_dividend_and_send_notification(member)
    end
  end

  private

  def create_dividend_and_send_notification(member)
    dividend = member.dividends.create!(distribution:)
    NotificationMailer.with(dividend:).dividend_received.deliver_now
  end

  def distribution
    @distribution ||= Distribution.create! dividend_amount_in_base_units:
  end

  def dividend_amount_in_base_units
    total_pool_in_base_units / members.count
  end

  def below_minimum_dividend?
    dividend_amount_in_base_units < MINIMUM_DIVIDEND_IN_CENTS
  end
end
