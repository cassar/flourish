require 'test_helper'

class DividendAmountServiceTest < ActiveSupport::TestCase
  test 'amount_in_base_units' do
    assert_equal 5_000, DividendAmountService.new(
      total_pool_in_base_units: 10_000,
      member_count: 2
    ).amount_in_base_units
  end

  test 'returns 0 if total_pool_in_base_units is 0' do
    assert_equal 0, DividendAmountService.new(
      total_pool_in_base_units: 0,
      member_count: 2
    ).amount_in_base_units
  end

  test 'returns 0 if member_count is 0' do
    assert_equal 0, DividendAmountService.new(
      total_pool_in_base_units: 10_000,
      member_count: 0
    ).amount_in_base_units
  end

  test 'amount_formatted' do
    assert_equal '$50.00 AUD', DividendAmountService.new(
      total_pool_in_base_units: 10_000,
      member_count: 2
    ).amount_formatted
  end
end
