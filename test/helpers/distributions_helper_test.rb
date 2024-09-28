require 'test_helper'

class DistributionsHelperTest < ActionView::TestCase
  test 'distribution_status when all actioned' do
    dividend_statuses = %w[paid_out manually_recontributed]
    assert_equal 'All dividends recontributed or paid out to members', distribution_status(dividend_statuses:)
  end

  test 'distribution_status when all issued' do
    dividend_statuses = %w[issued issued]
    assert_equal 'Dividends issued to members', distribution_status(dividend_statuses:)
  end

  test 'distribution_status when some actioned' do
    dividend_statuses = %w[issued manually_recontributed]
    assert_equal 'Awaiting action from members', distribution_status(dividend_statuses:)
  end
end
