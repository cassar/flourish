require 'test_helper'

class DistributionServiceTest < ActiveSupport::TestCase
  test 'creates multiple dividends' do
    mailer_mock = mock('mailer')
    NotificationMailer.stubs(:with).returns(mailer_mock)
    mailer_mock.stubs(:dividend_received).returns(mailer_mock)
    mailer_mock.stubs(:deliver_now).returns(true)

    members = [members(:one), members(:two)]

    assert_difference 'Distribution.count', 1 do
      assert_difference 'Dividend.count', members.count do
        DistributionService.new(
          run_today: true,
          members:,
          dividend_amount_in_base_units: 0
        ).call
      end
    end
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
