require 'test_helper'

class DashboardHelperTest < ActionView::TestCase
  test 'should return next friday date' do
    today = Date.new(2024, 1, 14)
    Time.zone.stubs(:today).returns(today)
    expected_date = 'Fri, 19 Jan 2024'
    assert_equal expected_date, next_friday_date_formatted
  end
end
