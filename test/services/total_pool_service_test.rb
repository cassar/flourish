require 'test_helper'

class TotalPoolServiceTest < ActiveSupport::TestCase
  setup do
    UpBank::AccountBalance.any_instance.stubs(:call).returns(10_000)
    OutstandingDividendsService.stubs(:total_amount_in_base_units).returns(1_500)
  end

  test 'balance_in_base_units' do
    assert_equal 8_500, TotalPoolService.balance_in_base_units
  end

  test 'balance_formatted' do
    assert_equal '$85.00', TotalPoolService.balance_formatted
  end

  test 'integration' do
    assert_equal String, TotalPoolService.balance_formatted.class
  end
end
