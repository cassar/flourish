class RecontributionService
  DAY_OF_THE_WEEK = 'Tuesday'.freeze
  BATCH_SIZE = 10

  def call
    return unless today?

    Dividend.issued.take(BATCH_SIZE).each do |dividend|
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
