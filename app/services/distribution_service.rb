class DistributionService
  class NotTodayError < StandardError; end
  class NoMembersError < StandardError; end

  attr_accessor :run_today, :members, :dividend_amount_in_base_units

  def initialize(run_today:, members:, dividend_amount_in_base_units:)
    @run_today = run_today
    @members = members
    @dividend_amount_in_base_units = dividend_amount_in_base_units
  end

  def call
    raise NotTodayError unless run_today
    raise NoMembersError if members.empty?

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
end
