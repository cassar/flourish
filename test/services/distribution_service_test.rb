require 'test_helper'

class DistributionTest < ActiveSupport::TestCase
  test 'creates dividends' do
    assert_difference 'Dividend.count' do
      total_amount = DividendService::NextDividend::MINIMUM_DIVIDEND
      DistributionService.new(
        members: [members(:active)],
        total_amount:
      ).call
    end
  end

  test 'fails when no members' do
    assert_raises DistributionService::NoMembersError do
      DistributionService.new(members: [], total_amount: 1).call
    end
  end

  test 'fails when no money' do
    assert_raises DistributionService::NoMoneyError do
      DistributionService.new(members: [members(:active)], total_amount: 0).call
    end
  end

  test 'fails when below minimum dividend' do
    assert_raises DistributionService::BelowMinimumDividendError do
      DistributionService.new(members: [members(:active)], total_amount: 1).call
    end
  end
end
