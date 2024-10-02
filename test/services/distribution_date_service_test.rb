require 'test_helper'

class DistributionDateServiceTest < ActiveSupport::TestCase
  test 'next date' do
    assert_equal Date, DistributionDateService.next_date.class
  end

  test 'distribution is not today' do
    Time.zone.stubs(:today).returns(Date.parse('Monday 29th Jan 2024'))
    DistributionDateService.stubs(:next_date).returns(Date.parse('Tuesday 30th Jan 2024'))

    assert_not DistributionDateService.today?
  end

  test 'distribution is today' do
    Time.zone.stubs(:today).returns(Date.parse('Friday 2nd Feb 2024'))
    DistributionDateService.stubs(:next_date).returns(Date.parse('Friday 2nd Feb 2024'))

    assert DistributionDateService.today?
  end
end
