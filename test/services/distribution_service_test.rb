require 'test_helper'

class DistributionServiceTest < ActiveSupport::TestCase
  test 'creates a single distribution' do
    expected_number = 3

    assert_difference 'Distribution.count', 1 do
      DistributionService.new(
        pod: pods(:general),
        number: expected_number,
        members: [members(:one)],
        amounts: [amounts(:one)]
      ).call
    end

    assert_equal expected_number, Distribution.last.number
  end

  test 'saves given amounts' do
    amount = Amount.new(amount_in_base_units: 500)

    assert_difference 'Amount.count', 1 do
      DistributionService.new(
        pod: pods(:general),
        number: 3,
        members: [members(:one)],
        amounts: [amount]
      ).call
    end

    assert_predicate amount, :persisted?
  end

  test 'calls member dividend service' do
    MemberDividendService.any_instance.stubs(:call).returns([]).once

    assert DistributionService.new(
      pod: pods(:general),
      number: 3,
      members: [members(:one)],
      amounts: [amounts(:one)]
    ).call
  end
end
