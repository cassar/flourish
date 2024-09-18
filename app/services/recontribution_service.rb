class RecontributionService
  DAY_OF_THE_WEEK = 'Tuesday'.freeze

  attr_accessor :issued_dividends

  def initialize(issued_dividends:)
    @issued_dividends = issued_dividends
  end

  def call
    return unless today?

    issued_dividends.each do |dividend|
      recontribute_dividend_and_send_notification(dividend)
    end
  end

  private

  def recontribute_dividend_and_send_notification(dividend)
    dividend.auto_recontributed!
    NotificationMailer.with(dividend:).dividend_automatically_recontributed.deliver_now
  end

  def today?
    Time.zone.today.eql? next_date
  end

  def next_date
    Date.parse DAY_OF_THE_WEEK
  end
end
