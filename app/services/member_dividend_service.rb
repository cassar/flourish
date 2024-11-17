class MemberDividendService
  class NoMembersError < StandardError; end
  class NoAmountError < StandardError; end

  attr_accessor :members, :amounts

  def initialize(members:, amounts:)
    @members = members
    @amounts = amounts
  end

  def call
    raise NoMembersError if members.empty?

    members.map do |member|
      member.dividends.create!(amount: amount(member.currency))
    end
  end

  private

  def amount(currency)
    amounts.find do |amount|
      amount.currency == currency
    end || raise(NoAmountError)
  end
end
