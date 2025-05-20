require 'test_helper'

class ConsolidationDateTest < ActiveSupport::TestCase
  test 'consolidation is not today' do
    Time.zone.stubs(:today).returns(Date.parse('Monday 29th Jan 2024'))
    ConsolidationDate.stubs(:next_date).returns(Date.parse('Tuesday 30th Jan 2024'))

    assert_not ConsolidationDate.today?
  end

  test 'consolidation is today' do
    Time.zone.stubs(:today).returns(Date.parse('Tuesday 17th Sep 2024'))
    ConsolidationDate.stubs(:next_date).returns(Date.parse('Tuesday 17th Sep 2024'))

    assert_predicate ConsolidationDate, :today?
  end
end
