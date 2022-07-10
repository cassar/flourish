require "test_helper"

class MemberCountChannelTest < ActionCable::Channel::TestCase
  test "subscribes" do
    subscribe
    assert subscription.confirmed?
  end
end
