module DashboardHelper
  def next_friday_date_formatted
    today = Time.zone.today
    days_until_friday = (5 - today.wday + 7) % 7
    next_friday = today + days_until_friday
    next_friday.strftime('%a, %d %b %Y')
  end
end
