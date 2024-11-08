require 'test_helper'

class TotalPoolServiceTest < ActiveSupport::TestCase
  test 'balance_in_base_units' do
    Contribution.stubs(:sum).returns(10_000)
    Expense.stubs(:sum).returns(1_000)

    Distribution.stubs(:joins).returns(Distribution)
    Distribution.stubs(:merge).returns(Distribution)
    Distribution.stubs(:sum).returns(1_500)

    assert_equal 7_500, TotalPoolService.balance_in_base_units
  end

  test 'balance in base units integration' do
    assert_instance_of Integer, TotalPoolService.balance_in_base_units
  end

  test 'balance_formatted' do
    TotalPoolService.stubs(:balance_in_base_units).returns(10_000)

    assert_equal '$100.00 AUD', TotalPoolService.balance_formatted
  end

  test 'balance formatted integration' do
    assert_instance_of String, TotalPoolService.balance_formatted
  end
end
