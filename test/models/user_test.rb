require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'has one user association' do
    assert_equal members(:one), users(:one).member
  end

  test 'dependent destroy relationship with member' do
    users(:one).destroy!

    assert_raises ActiveRecord::RecordNotFound do
      members(:one).reload
    end
  end

  test '#admin? should return true if admin' do
    users(:one).email = User::ADMIN_EMAIL

    assert_predicate users(:one), :admin?
  end

  test '#admin? should return false if not admin' do
    not_admin_email = 'not_admin@email.com'

    assert_not_equal not_admin_email, User::ADMIN_EMAIL
    users(:one).email = not_admin_email

    assert_not users(:one).admin?
  end
end
