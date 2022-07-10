require 'test_helper'

class MemberCountServiceTest < ActiveSupport::TestCase
  test 'call' do
    assert_equal members.length, MemberCountService.call
  end
end
