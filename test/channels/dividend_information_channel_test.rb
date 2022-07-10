require "test_helper"

class DividendInformationChannelTest < ActionCable::Channel::TestCase
  test "subscribes" do
    subscribe
    assert subscription.confirmed?
  end
end
