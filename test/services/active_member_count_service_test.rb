require 'test_helper'

class ActiveMemberCountServiceTest < ActiveSupport::TestCase
  test 'call' do
    assert_equal members.select(&:active?).length, ActiveMemberCountService.call
  end
end
