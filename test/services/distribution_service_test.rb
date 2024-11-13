require 'test_helper'

class DistributionServiceTest < ActiveSupport::TestCase
  test 'creates a single distribution' do
    assert_difference 'Distribution.count', 1 do
      DistributionService.new(
        members: [members(:one)],
        name: '#3',
        amount_in_base_units: 1000
      ).call
    end
  end

  test 'creates a single amount' do
    assert_difference 'Amount.count', 1 do
      DistributionService.new(
        members: [members(:one)],
        name: '#3',
        amount_in_base_units: 1000
      ).call
    end
  end

  test 'creates a distribution with a given name' do
    expected_name = '#3'

    DistributionService.new(
      members: [members(:one)],
      name: expected_name,
      amount_in_base_units: 1000
    ).call

    assert_equal expected_name, Distribution.last.name
  end

  test 'creates an amount with the given dividend amount' do
    amount_in_base_units = 1000

    DistributionService.new(
      members: [members(:one)],
      name: '#3',
      amount_in_base_units:
    ).call

    assert_equal amount_in_base_units, Amount.last.amount_in_base_units
  end
end
