require 'test_helper'

class ContributionTotalServiceTest < ActiveSupport::TestCase
  test 'call' do
    assert_equal "$15.00", ContributionTotalService.call
  end
end
