module DistributionsHelper
  def distribution_status(dividend_statuses:)
    return 'Settled' if dividend_statuses.none?('issued')

    return 'Dividends issued to members' if dividend_statuses.all?('issued')

    'Awaiting member action'
  end
end
