require 'test_helper'

class DistributionServiceTest < ActiveSupport::TestCase
  test 'creates a single distribution' do
    assert_difference 'Distribution.count', 1 do
      DistributionService.new(
        members: [members(:one)],
        dividend_amount_in_base_units: 1000
      ).call
    end
  end

  test 'creates a distribution with the given dividend amount' do
    dividend_amount_in_base_units = 1000

    DistributionService.new(
      members: [members(:one)],
      dividend_amount_in_base_units:
    ).call

    assert_equal dividend_amount_in_base_units, Distribution.last.dividend_amount_in_base_units
  end
end
