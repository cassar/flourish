require 'test_helper'

class NextDistributionTest < ActiveSupport::TestCase
  test 'distribute!' do
    stub_eu_central_bank_request
    BlueskyNewDividendDistribution.any_instance.stubs(:call).returns(true)
    MastodonNewDividendDistribution.any_instance.stubs(:call).returns(true)

    assert_instance_of TrueClass, NextDistribution.distribute!
  end

  test 'members' do
    assert NextDistribution.members
  end

  test 'member_count' do
    result = NextDistribution.member_count

    assert_instance_of Integer, result
  end

  test 'name' do
    result = NextDistribution.name

    assert_instance_of String, result
  end

  test 'date_formatted' do
    result = NextDistribution.date_formatted

    assert_instance_of String, result
  end

  test 'today?' do
    assert_not_nil NextDistribution.today?
  end

  test 'total_pool_formatted' do
    stub_eu_central_bank_request

    result = NextDistribution.total_pool_formatted('AUD')

    assert_instance_of String, result
  end

  test 'dividend_amount_formatted' do
    stub_eu_central_bank_request

    result = NextDistribution.dividend_amount_formatted('HKD')

    assert_instance_of String, result
  end
end
