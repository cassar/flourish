class RecontributionService
  attr_accessor :issued_dividends

  def initialize(issued_dividends:)
    @issued_dividends = issued_dividends
  end

  def call
    issued_dividends.each do |dividend|
      recontribute_dividend_and_send_notification(dividend)
    end
  end

  private

  def recontribute_dividend_and_send_notification(dividend)
    dividend.auto_recontributed!
    NotificationMailer.with(dividend:).dividend_automatically_recontributed.deliver_now
  end
end
