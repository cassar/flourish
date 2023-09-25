require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'associations' do
    assert_equal members(:active), users(:one).member

    users(:one).destroy!

    assert_raises ActiveRecord::RecordNotFound do
      members(:active).reload
    end
  end

  test 'should create a member record after user creation' do
    assert_difference('Member.count', 1) do
      user = User.create(email: 'john@example.com', password: 'password')
      assert_equal user.member, Member.last
    end
  end
end
