require 'test_helper'

class TotalDistributionRecontributionsCalculatorTest < ActiveSupport::TestCase
  test 'formatted' do
    TotalPoolCalculationsService.stubs(:recontributions_by_currency).with(distributions(:one))
      .returns({ 'AUD' => 10_000 })

    assert_equal '$100.00 AUD', TotalDistributionRecontributionsCalculator.new(distributions(:one)).formatted('AUD')
  end

  test 'formatted intergration' do
    assert_instance_of String, TotalDistributionRecontributionsCalculator.new(distributions(:one)).formatted('AUD')
  end
end
