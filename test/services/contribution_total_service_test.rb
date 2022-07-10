require 'test_helper'

class ContributionTotalServiceTest < ActiveSupport::TestCase
  test 'call' do
    assert_equal members.pluck(:contribution_amount).sum, ContributionTotalService.call
  end
end
