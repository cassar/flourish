require 'test_helper'

class ActiveMemberCountServiceTest < ActiveSupport::TestCase
  test 'call' do
    assert_equal User.where.not(confirmed_at: nil).count, ActiveMemberCountService.call
  end
end
