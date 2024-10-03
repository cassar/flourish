require 'test_helper'

class RecontributionDateServiceTest < ActiveSupport::TestCase
  test 'recontribution is not today' do
    Time.zone.stubs(:today).returns(Date.parse('Monday 29th Jan 2024'))
    RecontributionDateService.stubs(:next_date).returns(Date.parse('Tuesday 30th Jan 2024'))

    assert_not RecontributionDateService.today?
  end

  test 'recontribution is today' do
    Time.zone.stubs(:today).returns(Date.parse('Tuesday 17th Sep 2024'))
    RecontributionDateService.stubs(:next_date).returns(Date.parse('Tuesday 17th Sep 2024'))

    assert_predicate RecontributionDateService, :today?
  end
end
