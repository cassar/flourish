class MemberDividendService
  class NoMembersError < StandardError; end

  attr_accessor :members, :amount

  def initialize(members:, amount:)
    @members = members
    @amount = amount
  end

  def call
    raise NoMembersError if members.empty?

    members.each do |member|
      create_dividend_and_send_notification(member)
    end
  end

  private

  def create_dividend_and_send_notification(member)
    dividend = member.dividends.create!(amount:)
    NotificationMailer.with(dividend:).dividend_received.deliver_now
  end
end
