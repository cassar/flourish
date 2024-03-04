require 'test_helper'

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
    @member = @user.member
  end

  test 'should redirect to sign in when not authenticated for show' do
    sign_out @user
    get membership_path
    assert_redirected_to new_user_session_path
  end

  test 'should get show' do
    get membership_url
    assert_response :success
  end
end
