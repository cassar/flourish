require "test_helper"

class MemberTest < ActiveSupport::TestCase
  test "member contribution cannot be less than 0" do
    assert members(:robert).contribution_amount >= 0

    error = assert_raises ActiveRecord::RecordInvalid do
      members(:robert).update! contribution_amount: -1
    end

    assert_equal 'Validation failed: Contribution amount must be greater than or equal to 0',
      error.message
  end

  test "should broadcast changes after save commit" do
    ActionCable::Server::Base.any_instance.stubs(:broadcast).times(3)
    members(:robert).update contribution_amount: 5
  end
end
