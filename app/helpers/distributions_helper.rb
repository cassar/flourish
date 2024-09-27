module DistributionsHelper
  def distribution_status(dividend_statuses:)
    return 'All dividends recontributed or paid out' if dividend_statuses.none?('issued')

    'Dividends issued to members'
  end
end
