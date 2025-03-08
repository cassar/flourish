require 'test_helper'

class TotalContributedAndRecontributedCalculatorTest < ActiveSupport::TestCase
  test 'formatted' do
    TotalPoolCalculationsService.stubs(:total_contributions_by_currency)
      .returns({ 'AUD' => 10_000 })

    TotalPoolCalculationsService.stubs(:total_recontributions_by_currency)
      .returns({ 'AUD' => 10_000 })

    assert_equal '$200.00 AUD', TotalContributedAndRecontributedCalculator.formatted('AUD')
  end

  test 'formatted intergration' do
    assert_instance_of String, TotalContributedAndRecontributedCalculator.formatted('AUD')
  end
end
