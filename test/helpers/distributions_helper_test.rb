require 'test_helper'

class DistributionsHelperTest < ActionView::TestCase
  test 'aggregate_statuses' do
    disaggregate_status_counts = {
      'issued' => 5,
      'manually_recontributed' => 3,
      'auto_recontributed' => 4
    }

    expected_aggregate_status_counts = {
      'issued' => 5,
      'recontributed' => 7
    }

    assert_equal expected_aggregate_status_counts, aggregate_status_counts(disaggregate_status_counts)
  end

  test 'distribution_status when settled' do
    dividend_statuses = %w[paid_out manually_recontributed]
    assert_equal 'Settled', distribution_status(dividend_statuses:)
  end

  test 'distribution_status when not settled' do
    dividend_statuses = %w[paid_out issued]
    assert_equal 'Awaiting action from all members', distribution_status(dividend_statuses:)
  end
end
