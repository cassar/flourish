require 'test_helper'

module Users
  class ConfirmationsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    test 'redirects to membership after confirmation' do
      user = users(:unconfirmed)

      get user_confirmation_path(confirmation_token: user.confirmation_token)

      assert_redirected_to membership_path
      follow_redirect!

      assert_response :success
    end
  end
end
