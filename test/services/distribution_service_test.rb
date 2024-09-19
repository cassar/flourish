require 'test_helper'

class DistributionServiceTest < ActiveSupport::TestCase
  test 'creates a single distribution with the given divindend amount' do
    members = [members(:one), members(:two)]
    dividend_amount_in_base_units = 1000

    assert_difference 'Distribution.count', 1 do
      DistributionService.new(
        members:,
        dividend_amount_in_base_units:
      ).call
    end

    assert_equal dividend_amount_in_base_units, Distribution.last.dividend_amount_in_base_units
  end

  test 'all dependent services respond' do
    assert DistributionService.new(
      members: [members(:one)],
      dividend_amount_in_base_units: 0
    ).call
  end
end
