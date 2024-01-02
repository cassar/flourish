class DistributionService
  attr_accessor :members, :total_amount

  class NoMembersError < StandardError; end
  class NoMoneyError < StandardError; end
  class BelowMinimumDividendError < StandardError; end

  def initialize(members:, total_amount:)
    @members = members
    @total_amount = total_amount
  end

  def call
    raise NoMembersError if member_count.zero?
    raise NoMoneyError if total_amount.zero?
    raise BelowMinimumDividendError if dividend_amount < minimum_dividend

    members.each do |member|
      create_dividend_and_send_notification(member)
    end
  end

  private

  def create_dividend_and_send_notification(member)
    dividend = member.dividends.create!(distribution:)
    DividendMailer.with(dividend:).new_dividend_notification.deliver_later
  end

  def distribution
    @distribution ||= Distribution.create! dividend_amount:
  end

  def dividend_amount
    total_amount / member_count
  end

  def member_count
    members.length
  end

  def minimum_dividend
    DividendService::NextDividend::MINIMUM_DIVIDEND
  end
end
