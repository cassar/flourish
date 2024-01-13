require 'test_helper'

class ActiveMemberServiceTest < ActiveSupport::TestCase
  test 'call' do
    assert_includes ActiveMemberService.call, members(:one)
  end
end
