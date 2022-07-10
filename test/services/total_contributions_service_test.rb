require 'test_helper'

class TotalContributionsServiceTest < ActiveSupport::TestCase
  test 'formatted' do
    assert_equal "$15.00", TotalContributionsService.formatted
  end

  test 'amount' do
    assert_equal 15, TotalContributionsService.amount
  end
end
