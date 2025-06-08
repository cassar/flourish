require 'test_helper'

class TotalPayOutsCalculatorTest < ActiveSupport::TestCase
  test 'formatted' do
    TotalPoolCalculations.stubs(:total_paid_out_by_currency)
      .returns({ 'AUD' => 10_000 })

    assert_equal '$100.00 AUD', TotalPool.total_paid_out_formatted('AUD')
  end

  test 'formatted intergration' do
    assert_instance_of String, TotalPool.total_paid_out_formatted('AUD')
  end
end
