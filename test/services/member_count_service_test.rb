require 'test_helper'

class MemberCountServiceTest < ActiveSupport::TestCase
  test 'call' do
    assert_equal members.select(&:active?).length, MemberCountService.call
  end
end
