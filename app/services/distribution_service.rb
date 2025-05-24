class DistributionService
  attr_reader :number, :members, :amounts
  attr_accessor :distribution, :dividends, :notification_enabled_member_ids

  def initialize(number:, members:, amounts:, notification_enabled_member_ids:)
    @number = number
    @members = members
    @amounts = amounts
    @notification_enabled_member_ids = notification_enabled_member_ids
  end

  def call
    create_distribution
    save_amounts
    create_dividends
    notify_members
    post_to_bluesky
    post_to_mastodon
  end

  private

  def create_distribution
    @distribution = Distribution.create!(number:)
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

  def post_to_bluesky
    BlueskyNewDividendDistribution.new(distribution:).call
  end

  def post_to_mastodon
    MastodonNewDividendDistribution.new(distribution:).call
  end
end
