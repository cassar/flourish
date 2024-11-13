require 'test_helper'

class NextDistributionServiceTest < ActiveSupport::TestCase
  test 'distribute!' do
    assert_instance_of Array, NextDistributionService.distribute!
  end

  test 'members' do
    assert NextDistributionService.members
  end

  test 'member_count' do
    result = NextDistributionService.member_count

    assert_instance_of Integer, result
  end

  test 'name' do
    result = NextDistributionService.name

    assert_instance_of String, result
  end

  test 'date_formatted' do
    result = NextDistributionService.date_formatted

    assert_instance_of String, result
  end

  test 'today?' do
    assert_not_nil NextDistributionService.today?
  end

  test 'total_pool_formatted' do
    result = NextDistributionService.total_pool_formatted

    assert_instance_of String, result
  end

  test 'dividend_amount_formatted' do
    result = NextDistributionService.dividend_amount_formatted

    assert_instance_of String, result
  end

  test 'amount_in_base_units' do
    result = NextDistributionService.amount_in_base_units

    assert_instance_of Integer, result
  end
end
