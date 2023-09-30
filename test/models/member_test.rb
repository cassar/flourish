require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  test 'associations' do
    assert_equal users(:one), members(:active).user
  end

  test 'new member defaults to inactive' do
    member = Member.create!(user: users(:no_member))

    assert member.inactive?
  end

  test 'active enum inactive state' do
    assert members(:inactive).inactive?
  end

  test 'active enum active state' do
    assert members(:active).active?
  end

  test 'member contribution cannot be less than 0' do
    assert members(:active).contribution_amount >= 0

    error = assert_raises ActiveRecord::RecordInvalid do
      members(:active).update! contribution_amount: -1
    end

    assert_equal 'Validation failed: Contribution amount must be greater than or equal to 0',
                 error.message
  end

  test 'should broadcast changes after save commit' do
    ActionCable::Server::Base.any_instance.stubs(:broadcast).times(4)
    members(:active).update contribution_amount: 5
  end
end
