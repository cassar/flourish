require 'test_helper'

class TotalPoolServiceTest < ActiveSupport::TestCase
  test 'all disaggregate statuses accounted for' do
    all_statuses = Dividend.statuses.keys
    declared_statuses = AggregateStatusCountsService::AGGREGATE_STATUSES.values.flatten
    new_statuses = all_statuses - declared_statuses

    assert_empty new_statuses, 'Add the new dividend statuses to AGGREGATE_STATUSES'
  end

  test 'counts' do
    disaggregate_status_counts = {
      'issued' => 5,
      'manually_recontributed' => 3,
      'auto_recontributed' => 4
    }

    expected_aggregate_status_counts = {
      'issued' => 5,
      'recontributed' => 7
    }

    actual_aggregate_status_counts = AggregateStatusCountsService.counts(disaggregate_status_counts)
    assert_equal expected_aggregate_status_counts, actual_aggregate_status_counts
  end

  test 'aggregate_status' do
    assert_equal 'paid_out', AggregateStatusCountsService.aggregate_status('pending_pay_out')
  end
end
