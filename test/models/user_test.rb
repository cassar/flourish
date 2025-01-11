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

  test 'active scope' do
    assert_includes User.active, users(:active)

    assert_not_includes User.active, users(:admin)
    assert_not_includes User.active, users(:inactive)
  end

  test 'inactive scope' do
    assert_includes User.inactive, users(:inactive)

    assert_not_includes User.inactive, users(:active)
    assert_not_includes User.inactive, users(:admin)
  end

  test 'distribution_preview_notify_enabled scope' do
    assert_includes User.distribution_preview_notify_enabled, users(:one)

    assert_not_includes User.distribution_preview_notify_enabled, users(:two)
  end

  test 'distribution_settled_notify_enabled' do
    assert_includes User.distribution_settled_notify_enabled, users(:one)

    assert_not_includes User.distribution_settled_notify_enabled, users(:two)
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
