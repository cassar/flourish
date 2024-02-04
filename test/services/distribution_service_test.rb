require 'test_helper'

class DistributionTest < ActiveSupport::TestCase
  test 'creates dividends' do
    DistributionDateService.stubs(:today?).returns(true)
    ActiveMemberService.stubs(:call).returns([members(:one)])
    BankAccountService.stubs(:balance).returns(DistributionService::MINIMUM_DIVIDEND_IN_CENTS)

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
    ActiveMemberService.stubs(:call).returns([])

    assert_raises DistributionService::NoMembersError do
      DistributionService.new.call
    end
  end

  test 'fails when no money' do
    DistributionDateService.stubs(:today?).returns(true)
    ActiveMemberService.stubs(:call).returns([members(:one)])
    BankAccountService.stubs(:balance).returns(0)

    assert_raises DistributionService::NoMoneyError do
      DistributionService.new.call
    end
  end

  test 'fails when below minimum dividend' do
    DistributionDateService.stubs(:today?).returns(true)
    ActiveMemberService.stubs(:call).returns([members(:one)])
    BankAccountService.stubs(:balance).returns(1)

    assert_raises DistributionService::BelowMinimumDividendError do
      DistributionService.new.call
    end
  end
end
