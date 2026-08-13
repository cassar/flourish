require 'test_helper'

class TotalDividendsCalculatorTest < ActiveSupport::TestCase
  test 'formatted' do
    TotalPodCalculations.stubs(:total_dividends_by_currency)
      .returns({ 'AUD' => 10_000 })

    assert_equal '$100.00 AUD', TotalDividendsCalculator.formatted(pods(:general), 'AUD')
  end

  test 'formatted intergration' do
    stub_eu_central_bank_request

    assert_instance_of String, TotalDividendsCalculator.formatted(pods(:general), 'AUD')
  end
end
