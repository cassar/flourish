require 'test_helper'

class TotalDistributionRecontributionsCalculatorTest < ActiveSupport::TestCase
  test 'formatted' do
    TotalPoolCalculations.stubs(:recontributions_by_currency).with(distributions(:one))
      .returns({ 'AUD' => 10_000 })

    assert_equal '$100.00 AUD', TotalDistributionRecontributionsCalculator.new(distributions(:one)).formatted('AUD')
  end

  test 'formatted intergration' do
    stub_eu_central_bank_request

    assert_instance_of String, TotalDistributionRecontributionsCalculator.new(distributions(:one)).formatted('AUD')
  end
end
