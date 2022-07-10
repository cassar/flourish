require 'test_helper'

class TotalContributionsServiceTest < ActiveSupport::TestCase
  test 'call' do
    assert_equal "$15.00", TotalContributionsService.call
  end
end
