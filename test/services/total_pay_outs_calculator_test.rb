require 'test_helper'

class TotalPayOutsCalculatorTest < ActiveSupport::TestCase
  test 'formatted' do
    TotalPodCalculations.stubs(:total_paid_out_by_currency)
      .returns({ 'AUD' => 10_000 })

    assert_equal '$100.00 AUD', TotalPayOutsCalculator.formatted(pods(:general), 'AUD')
  end

  test 'formatted intergration' do
    assert_instance_of String, TotalPayOutsCalculator.formatted(pods(:general), 'AUD')
  end
end
