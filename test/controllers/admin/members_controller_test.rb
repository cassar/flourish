require 'test_helper'

module Admin
  class MembersControllerTest < ActionDispatch::IntegrationTest
    test 'should redirect to sign in when not authenticated for active' do
      get active_admin_members_path
      assert_redirected_to new_user_session_path
    end

    test 'should redirect to sign in when not admin for active' do
      assert_not users(:one).admin?
      sign_in users(:one)

      get active_admin_members_path
      assert_redirected_to root_path
    end

    test 'should get active as admin' do
      assert users(:admin).admin?
      sign_in users(:admin)

      get active_admin_members_path
      assert_response :success
    end

    test 'should redirect to sign in when not authenticated for inactive' do
      get inactive_admin_members_path
      assert_redirected_to new_user_session_path
    end

    test 'should redirect to sign in when not admin for inactive' do
      assert_not users(:one).admin?
      sign_in users(:one)

      get inactive_admin_members_path
      assert_redirected_to root_path
    end

    test 'should get inactive as admin' do
      assert users(:admin).admin?
      sign_in users(:admin)

      get inactive_admin_members_path
      assert_response :success
    end
  end
end
