require 'test_helper'

module Membership
  class ContributionsControllerTest < ActionDispatch::IntegrationTest
    def setup
      @user = users(:one)
      sign_in @user
      @member = @user.member
    end

    test 'should redirect to sign in when not authenticated for index' do
      sign_out @user
      get membership_contributions_path

      assert_redirected_to new_user_session_path
    end

    test 'should get index' do
      get membership_contributions_path

      assert_response :success
    end
  end
end
