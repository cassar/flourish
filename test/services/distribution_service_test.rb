require 'test_helper'

class DistributionServiceTest < ActiveSupport::TestCase
  test 'creates multiple dividends' do
    mailer_mock = mock('mailer')
    NotificationMailer.stubs(:with).returns(mailer_mock)
    mailer_mock.stubs(:new_dividend).returns(mailer_mock)
    mailer_mock.stubs(:deliver_now).returns(true)

    members = [members(:one), members(:two)]
    total_pool_in_base_units = DistributionService::MINIMUM_DIVIDEND_IN_CENTS * members.count

    assert_difference 'Distribution.count', 1 do
      assert_difference 'Dividend.count', members.count do
        DistributionService.new(
          run_today: true,
          members:,
          total_pool_in_base_units:
        ).call
      end
    end
  end

  test 'fails when not the day for distributions' do
    assert_raises DistributionService::NotTodayError do
      DistributionService.new(
        run_today: false,
        members: [],
        total_pool_in_base_units: 0
      ).call
    end
  end

  test 'fails when no members' do
    assert_raises DistributionService::NoMembersError do
      DistributionService.new(
        run_today: true,
        members: [],
        total_pool_in_base_units: 0
      ).call
    end
  end

  test 'fails when below minimum dividend' do
    assert_raises DistributionService::BelowMinimumDividendError do
      DistributionService.new(
        run_today: true,
        members: [members(:one)],
        total_pool_in_base_units: 0
      ).call
    end
  end

  test 'all dependent services respond' do
    assert DistributionService.new(
      run_today: true,
      members: [members(:one)],
      total_pool_in_base_units: DistributionService::MINIMUM_DIVIDEND_IN_CENTS
    ).call
  end
end
