require 'test_helper'

class ActiveMemberServiceTest < ActiveSupport::TestCase
  test 'call' do
    assert_predicate members(:active), :active?
    assert_includes ActiveMemberService.call, members(:active)
  end
end
