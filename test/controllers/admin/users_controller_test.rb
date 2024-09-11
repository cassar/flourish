require 'test_helper'

module Admin
  class UsersControllerTest < ActionDispatch::IntegrationTest
    test 'should redirect to sign in when not authenticated for index' do
      get admin_users_path
      assert_redirected_to new_user_session_path
    end

    test 'should redirect to sign in when not admin for index' do
      assert_not users(:one).admin?
      sign_in users(:one)

      get admin_users_path
      assert_redirected_to root_path
    end

    test 'should get index as admin' do
      assert users(:admin).admin?
      sign_in users(:admin)

      get admin_users_path
      assert_response :success
    end
  end
end
