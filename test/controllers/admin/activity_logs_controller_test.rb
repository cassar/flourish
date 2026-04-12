require 'test_helper'

module Admin
  class ActivityLogsControllerTest < ActionDispatch::IntegrationTest
    test 'not authenticated for index' do
      get admin_activity_logs_path

      assert_redirected_to new_user_session_path
    end

    test 'not authorized for index' do
      assert_not users(:one).admin?
      sign_in users(:one)

      get admin_activity_logs_path

      assert_redirected_to root_path
    end

    test 'get index' do
      sign_in users(:admin)

      get admin_activity_logs_path

      assert_response :success
    end
  end
end
