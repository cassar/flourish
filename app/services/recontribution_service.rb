class RecontributionService
  class NotTodayError < StandardError; end

  DAY_OF_THE_WEEK = 'Tuesday'.freeze

  def call
    raise NotTodayError unless today?

    Dividend.issued.each do |dividend|
      recontribute_dividend_and_send_notification(dividend)
    end
  end

  private

  def recontribute_dividend_and_send_notification(dividend)
    dividend.recontributed!
    NotificationMailer.with(dividend:).dividend_recontributed.deliver_now
  end

  def today?
    Time.zone.today.eql? next_date
  end

  def next_date
    Date.parse DAY_OF_THE_WEEK
  end
end
