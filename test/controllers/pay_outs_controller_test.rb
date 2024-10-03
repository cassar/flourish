require 'test_helper'

class PayOutsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
    @member = @user.member
  end

  test 'should redirect to sign in when not authenticated for index' do
    sign_out @user
    get pay_outs_path

    assert_redirected_to new_user_session_path
  end

  test 'should get index' do
    get pay_outs_path

    assert_response :success
  end
end
