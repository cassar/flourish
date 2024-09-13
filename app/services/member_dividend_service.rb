class MemberDividendService
  class NoMembersError < StandardError; end

  attr_accessor :members, :distribution

  def initialize(members:, distribution:)
    @members = members
    @distribution = distribution
  end

  def call
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
end
