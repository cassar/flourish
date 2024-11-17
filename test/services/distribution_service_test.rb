require 'test_helper'

class DistributionServiceTest < ActiveSupport::TestCase
  test 'creates a single distribution' do
    expected_name = '#3'

    assert_difference 'Distribution.count', 1 do
      DistributionService.new(
        name: expected_name,
        members: [members(:one)],
        amounts: [amounts(:one)]
      ).call
    end

    assert_equal expected_name, Distribution.last.name
  end

  test 'saves given amounts' do
    amount = Amount.new(amount_in_base_units: 500)

    assert_difference 'Amount.count', 1 do
      DistributionService.new(
        name: '#3',
        members: [members(:one)],
        amounts: [amount]
      ).call
    end

    assert_predicate amount, :persisted?
  end

  test 'calls member dividend service' do
    MemberDividendService.any_instance.stubs(:call).returns([]).once

    assert DistributionService.new(
      name: '#3',
      members: [members(:one)],
      amounts: [amounts(:one)]
    ).call
  end

  test 'sends a notification to each member' do
    members = [members(:one)]
    mailer_mock = mock('mailer')
    NotificationMailer.stubs(:with).returns(mailer_mock)
    mailer_mock.stubs(:dividend_received).returns(mailer_mock)
    mailer_mock.stubs(:deliver_later).returns(true).times(members.count)

    assert DistributionService.new(
      name: '#3',
      members:,
      amounts: [amounts(:one)]
    ).call
  end
end
