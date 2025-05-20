require 'test_helper'

class DistributionPreviewDateTest < ActiveSupport::TestCase
  test 'next date' do
    assert_instance_of Date, DistributionPreviewDate.next_date
  end

  test 'distribution is not today' do
    Time.zone.stubs(:today).returns(Date.parse('Monday 29th Jan 2024'))
    DistributionPreviewDate.stubs(:next_date).returns(Date.parse('Tuesday 30th Jan 2024'))

    assert_not DistributionPreviewDate.today?
  end

  test 'distribution is today' do
    Time.zone.stubs(:today).returns(Date.parse('Friday 2nd Feb 2024'))
    DistributionPreviewDate.stubs(:next_date).returns(Date.parse('Friday 2nd Feb 2024'))

    assert_predicate DistributionPreviewDate, :today?
  end
end
