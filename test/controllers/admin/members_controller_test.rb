require 'test_helper'

module Admin
  class MembersControllerTest < ActionDispatch::IntegrationTest
    test 'index requires sign in' do
      get admin_members_path

      assert_redirected_to new_user_session_path
    end

    test 'index redirects non-admins to root' do
      sign_in users(:one)

      get admin_members_path

      assert_redirected_to root_path
    end

    test 'index renders for admins' do
      sign_in users(:admin)

      get admin_members_path

      assert_response :success
    end

    test 'index filters by query' do
      sign_in users(:admin)

      get admin_members_path, params: { q: users(:one).email }

      assert_response :success
      assert_select 'body', text: /#{Regexp.escape(users(:one).email)}/
    end

    test 'show requires sign in' do
      get admin_member_path(members(:one))

      assert_redirected_to new_user_session_path
    end

    test 'show redirects non-admins to root' do
      sign_in users(:one)

      get admin_member_path(members(:one))

      assert_redirected_to root_path
    end

    test 'show renders for admins' do
      sign_in users(:admin)

      get admin_member_path(members(:one))

      assert_response :success
    end
  end
end
