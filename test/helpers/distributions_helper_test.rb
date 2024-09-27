require 'test_helper'

class DistributionsHelperTest < ActionView::TestCase
  test 'distribution_status when settled' do
    dividend_statuses = %w[paid_out manually_recontributed]
    assert_equal 'All dividends recontributed or paid out', distribution_status(dividend_statuses:)
  end

  test 'distribution_status when not settled' do
    dividend_statuses = %w[paid_out issued]
    assert_equal 'Dividends issued to members', distribution_status(dividend_statuses:)
  end
end
