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
end
