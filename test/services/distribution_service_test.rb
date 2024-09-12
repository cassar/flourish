require 'test_helper'

class DistributionServiceTest < ActiveSupport::TestCase
  test 'creates a single distribution with the given divindend amount' do
    members = [members(:one), members(:two)]
    dividend_amount_in_base_units = 1000

    assert_difference 'Distribution.count', 1 do
      DistributionService.new(
        run_today: true,
        members:,
        dividend_amount_in_base_units:
      ).call
    end

    assert_equal dividend_amount_in_base_units, Distribution.last.dividend_amount_in_base_units
  end

  test 'creates a dividend for each member' do
    members = [members(:one), members(:two)]

    assert_difference 'Dividend.count', members.count do
      DistributionService.new(
        run_today: true,
        members:,
        dividend_amount_in_base_units: 0
      ).call
    end

    dividend_members = Member.joins(:dividends).where(dividends: { distribution: Distribution.last })
    assert_includes dividend_members, members(:one)
    assert_includes dividend_members, members(:two)
  end

  test 'sends a notification to each member' do
    members = [members(:one), members(:two)]

    mailer_mock = mock('mailer')
    NotificationMailer.stubs(:with).returns(mailer_mock)
    mailer_mock.stubs(:dividend_received).returns(mailer_mock)
    mailer_mock.stubs(:deliver_now).returns(true).times(members.count)

    assert DistributionService.new(
      run_today: true,
      members:,
      dividend_amount_in_base_units: 0
    ).call
  end

  test 'fails when not the day for distributions' do
    assert_raises DistributionService::NotTodayError do
      DistributionService.new(
        run_today: false,
        members: [],
        dividend_amount_in_base_units: 0
      ).call
    end
  end

  test 'fails when no members' do
    assert_raises DistributionService::NoMembersError do
      DistributionService.new(
        run_today: true,
        members: [],
        dividend_amount_in_base_units: 0
      ).call
    end
  end

  test 'all dependent services respond' do
    assert DistributionService.new(
      run_today: true,
      members: [members(:one)],
      dividend_amount_in_base_units: 0
    ).call
  end
end
