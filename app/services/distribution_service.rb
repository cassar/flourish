class DistributionService
  attr_reader :name, :members, :amounts
  attr_accessor :distribution, :dividends, :notification_enabled_member_ids

  def initialize(name:, members:, amounts:, notification_enabled_member_ids:)
    @name = name
    @members = members
    @amounts = amounts
    @notification_enabled_member_ids = notification_enabled_member_ids
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
    notification_enabled_dividends.map do |dividend|
      NotificationMailer.with(dividend:).dividend_received.deliver_now
    end
  end

  def notification_enabled_dividends
    dividends.select do |dividend|
      dividend.member_id.in? notification_enabled_member_ids
    end
  end
end
