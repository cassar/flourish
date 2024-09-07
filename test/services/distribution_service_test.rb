require 'test_helper'

class DistributionServiceTest < ActiveSupport::TestCase
  test 'creates dividends' do
    DistributionDateService.stubs(:today?).returns(true)
    Member.stubs(:active).returns([members(:one)])
    TotalPoolService.stubs(:balance_in_base_units).returns(DistributionService::MINIMUM_DIVIDEND_IN_CENTS)

    mailer_mock = mock('mailer')
    NotificationMailer.stubs(:with).returns(mailer_mock)
    mailer_mock.stubs(:new_dividend).returns(mailer_mock)
    mailer_mock.stubs(:deliver_now).returns(true)

    assert_difference 'Dividend.count' do
      DistributionService.new.call
    end
  end

  test 'fails when not the day for distributions' do
    DistributionDateService.stubs(:today?).returns(false)

    assert_raises DistributionService::NotTodayError do
      DistributionService.new.call
    end
  end

  test 'fails when no members' do
    DistributionDateService.stubs(:today?).returns(true)
    Member.stubs(:active).returns([])

    assert_raises DistributionService::NoMembersError do
      DistributionService.new.call
    end
  end

  test 'fails when no money' do
    DistributionDateService.stubs(:today?).returns(true)
    Member.stubs(:active).returns([members(:one)])
    TotalPoolService.stubs(:balance_in_base_units).returns(0)

    assert_raises DistributionService::NoMoneyError do
      DistributionService.new.call
    end
  end

  test 'fails when below minimum dividend' do
    DistributionDateService.stubs(:today?).returns(true)
    Member.stubs(:active).returns([members(:one)])
    TotalPoolService.stubs(:balance_in_base_units).returns(1)

    assert_raises DistributionService::BelowMinimumDividendError do
      DistributionService.new.call
    end
  end
end
