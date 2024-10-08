require 'test_helper'

class ConsolidationDateServiceTest < ActiveSupport::TestCase
  test 'consolidation is not today' do
    Time.zone.stubs(:today).returns(Date.parse('Monday 29th Jan 2024'))
    ConsolidationDateService.stubs(:next_date).returns(Date.parse('Tuesday 30th Jan 2024'))

    assert_not ConsolidationDateService.today?
  end

  test 'consolidation is today' do
    Time.zone.stubs(:today).returns(Date.parse('Tuesday 17th Sep 2024'))
    ConsolidationDateService.stubs(:next_date).returns(Date.parse('Tuesday 17th Sep 2024'))

    assert_predicate ConsolidationDateService, :today?
  end
end
