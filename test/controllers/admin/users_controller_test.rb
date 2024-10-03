require 'test_helper'

module Admin
  class UsersControllerTest < ActionDispatch::IntegrationTest
    test 'should redirect to sign in when not authenticated for destroy' do
      delete admin_user_path(users(:inactive))

      assert_redirected_to new_user_session_path
    end

    test 'should redirect to sign in when not admin for destroy' do
      assert_not users(:one).admin?
      sign_in users(:one)

      delete admin_user_path(users(:inactive))

      assert_redirected_to root_path
    end

    test 'should delete destroy as admin' do
      assert_predicate users(:admin), :admin?
      sign_in users(:admin)

      assert_difference 'User.count', -1 do
        delete admin_user_path(users(:inactive))
      end
      assert_equal "User 'inactive@email.com' Destroyed", flash[:success]
      assert_redirected_to inactive_admin_members_path
    end
  end
end
