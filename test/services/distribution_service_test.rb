require 'test_helper'

class DistributionServiceTest < ActiveSupport::TestCase
  test 'creates a single distribution' do
    expected_name = '#3'

    assert_difference 'Distribution.count', 1 do
      DistributionService.new(
        name: expected_name,
        members: [members(:one)],
        amounts: [amounts(:one)],
        notification_enabled_member_ids: []
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
        amounts: [amount],
        notification_enabled_member_ids: []
      ).call
    end

    assert_predicate amount, :persisted?
  end

  test 'calls member dividend service' do
    MemberDividendService.any_instance.stubs(:call).returns([]).once

    assert DistributionService.new(
      name: '#3',
      members: [members(:one)],
      amounts: [amounts(:one)],
      notification_enabled_member_ids: []
    ).call
  end

  test 'sends notification for preference enabled' do
    ActionMailer::Base.deliveries.clear

    DistributionService.new(
      name: '#3',
      members: [members(:one)],
      amounts: [amounts(:one)],
      notification_enabled_member_ids: [members(:one).id]
    ).call

    assert_equal 1, ActionMailer::Base.deliveries.count
    assert(ActionMailer::Base.deliveries.all? do |mail|
      mail.subject.match?(/New Dividend Distributed/)
    end)
  end

  test 'does not send a notification for preference disabled' do
    ActionMailer::Base.deliveries.clear

    DistributionService.new(
      name: '#3',
      members: [members(:one)],
      amounts: [amounts(:one)],
      notification_enabled_member_ids: []
    ).call

    assert_equal 0, ActionMailer::Base.deliveries.count
  end
end
