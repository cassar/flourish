require 'test_helper'

class TotalPoolServiceTest < ActiveSupport::TestCase
  test 'balance_in_base_units' do
    Contribution.stubs(:sum).returns(10_000)

    Distribution.stubs(:joins).returns(Distribution)
    Distribution.stubs(:merge).returns(Distribution)
    Distribution.stubs(:sum).returns(1_500)

    assert_equal 8_500, TotalPoolService.balance_in_base_units
  end

  test 'balance_formatted' do
    Contribution.stubs(:sum).returns(10_000)

    Distribution.stubs(:joins).returns(Distribution)
    Distribution.stubs(:merge).returns(Distribution)
    Distribution.stubs(:sum).returns(1_500)

    assert_equal '$85.00 AUD', TotalPoolService.balance_formatted
  end

  test 'integration' do
    assert_equal String, TotalPoolService.balance_formatted.class
  end
end
