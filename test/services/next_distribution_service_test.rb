require 'test_helper'

class NextDistributionServiceTest < ActiveSupport::TestCase
  test 'distribute!' do
    stub_eu_central_bank_request

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
    stub_eu_central_bank_request

    result = NextDistributionService.total_pool_formatted('AUD')

    assert_instance_of String, result
  end

  test 'dividend_amount_formatted' do
    stub_eu_central_bank_request

    result = NextDistributionService.dividend_amount_formatted('HKD')

    assert_instance_of String, result
  end

  test 'amount_in_base_units' do
    stub_eu_central_bank_request

    result = NextDistributionService.amount_in_base_units

    assert_instance_of Integer, result
  end
end
