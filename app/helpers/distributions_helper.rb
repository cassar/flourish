module DistributionsHelper
  def distribution_status(dividend_statuses:)
    return 'Settled' if dividend_statuses.none?('issued')

    'Awaiting action from members'
  end
end
