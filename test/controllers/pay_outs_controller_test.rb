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

  test 'should get index when has payid' do
    @member.update! payid: 'my_payid'

    get pay_outs_path
    assert_response :success
  end

  test 'should get index when no payid' do
    assert_nil @member.payid

    get pay_outs_path
    assert_response :success
  end
end
