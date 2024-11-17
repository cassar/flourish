class DistributionService
  attr_reader :name, :members, :amounts
  attr_accessor :distribution, :dividends

  def initialize(name:, members:, amounts:)
    @name = name
    @members = members
    @amounts = amounts
  end

  def call
    create_distribution
    save_amounts
    create_dividends
    notify_members
  end

  private

  def create_distribution
    @distribution = Distribution.create!(name:)
  end

  def save_amounts
    amounts.each do |amount|
      amount.distribution = distribution
      amount.save
    end
  end

  def create_dividends
    @dividends = MemberDividendService.new(members:, amounts:).call
  end

  def notify_members
    dividends.map do |dividend|
      NotificationMailer.with(dividend:).dividend_received.deliver_later
    end
  end
end
