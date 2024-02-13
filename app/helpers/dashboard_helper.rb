module DashboardHelper
  def next_distribution_date_formatted
    DistributionDateService.next_date.strftime('%a, %d %b %Y')
  end

  def created_at_formatted(record)
    record.created_at.strftime("#{record.created_at.day.ordinalize} %b %Y")
  end

  def status_count(label, dividends)
    dividends.count do |dividend|
      dividend.status.eql? label
    end
  end
end
