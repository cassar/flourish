class RecontributionService
  attr_accessor :issued_dividends, :notify_enabled_dividends

  def initialize(issued_dividends:, notify_enabled_dividends:)
    @issued_dividends = issued_dividends
    @notify_enabled_dividends = notify_enabled_dividends
  end

  def call
    auto_recontribute_dividends!
    notify_subscribed_members
  end

  def auto_recontribute_dividends!
    issued_dividends.each(&:auto_recontributed!)
  end

  def notify_subscribed_members
    notify_enabled_dividends.each do |dividend|
      NotificationMailer.with(dividend:).dividend_automatically_recontributed.deliver_now
    end
  end
end
