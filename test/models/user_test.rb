require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'associations' do
    assert_equal members(:one), users(:one).member

    users(:one).destroy!

    assert_raises ActiveRecord::RecordNotFound do
      members(:one).reload
    end
  end

  test 'should create a member record after user creation' do
    assert_difference('Member.count', 1) do
      user = User.create(email: 'john@example.com', password: 'password')
      assert_equal user.member, Member.last
    end
  end

  test '#admin? should return true if admin' do
    users(:one).email = User::ADMIN_EMAIL

    assert users(:one).admin?
  end

  test '#admin? should return false if not admin' do
    not_admin_email = 'not_admin@email.com'
    assert_not_equal not_admin_email, User::ADMIN_EMAIL
    users(:one).email = not_admin_email

    assert_not users(:one).admin?
  end
end
