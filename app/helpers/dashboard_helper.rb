module DashboardHelper
  def next_distribution_date_formatted
    DistributionDateService.next_date.strftime('%a, %d %b %Y')
  end

  def created_at_formatted(record)
    record.created_at.strftime("#{record.created_at.day.ordinalize} %b %Y")
  end

  def minimum_dividend_formatted
    Money.from_cents(DistributionService::MINIMUM_DIVIDEND_IN_CENTS).format
  end
end
