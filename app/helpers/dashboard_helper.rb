module DashboardHelper
  def next_distribution_date_formatted
    DistributionDateService.next_date.strftime('%a, %d %b %Y')
  end
end
