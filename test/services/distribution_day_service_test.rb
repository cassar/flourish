require 'test_helper'

class DistributionDayServiceTest < ActiveSupport::TestCase
  test 'distribution is not today' do
    Time.zone.stubs(:today).returns(Date.parse('Tuesday 30th Jan 2024'))

    assert_not DistributionDayService.today?
  end

  test 'distribution is today' do
    Time.zone.stubs(:today).returns(Date.parse('Friday 2nd Feb 2024'))

    assert DistributionDayService.today?
  end
end
