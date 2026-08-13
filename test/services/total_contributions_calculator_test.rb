require 'test_helper'

class TotalContributionsCalculatorTest < ActiveSupport::TestCase
  test 'aud_base_units' do
    TotalPodCalculations.stubs(:total_contributions_by_currency)
      .returns({ 'AUD' => 10_000 })

    assert_equal 10_000, TotalContributionsCalculator.aud_base_units(pods(:general))
  end

  test 'aud_base_units intergration' do
    assert_instance_of Integer, TotalContributionsCalculator.aud_base_units(pods(:general))
  end
end
