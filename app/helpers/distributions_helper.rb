module DistributionsHelper
  def distribution_status(dividend_statuses:)
    return 'All dividends recontributed or paid out to members' if dividend_statuses.none?('issued')

    return 'Dividends issued to members' if dividend_statuses.all?('issued')

    'Awaiting action from members'
  end
end
