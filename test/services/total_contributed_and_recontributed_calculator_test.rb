require 'test_helper'

class TotalContributedAndRecontributedCalculatorTest < ActiveSupport::TestCase
  test 'formatted' do
    TotalContributionsCalculator.stubs(:aud_base_units)
      .returns(10_000)

    TotalPoolCalculations.stubs(:total_recontributions_by_currency)
      .returns({ 'AUD' => 10_000 })

    assert_equal '$200.00 AUD', TotalContributedAndRecontributedCalculator.formatted('AUD')
  end

  test 'formatted intergration' do
    stub_eu_central_bank_request

    assert_instance_of String, TotalContributedAndRecontributedCalculator.formatted('AUD')
  end
end
