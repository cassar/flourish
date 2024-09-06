require 'test_helper'

class ActiveMemberServiceTest < ActiveSupport::TestCase
  test 'call' do
    assert_includes ActiveMemberService.call, members(:one)
    assert_not_includes ActiveMemberService.call, members(:unconfirmed)
    assert_not_includes ActiveMemberService.call, members(:admin)
  end
end
