require 'test_helper'

class PayidsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
    @member = @user.member
  end

  test 'should redirect to sign in when not authenticated for edit' do
    sign_out @user
    get edit_payid_path(@member)
    assert_redirected_to new_user_session_path
  end

  test 'should get edit' do
    get edit_payid_path(@member)
    assert_response :success
  end

  test 'should redirect to sign in when not authenticated for update' do
    sign_out @user
    patch payid_path(@member), params: { member: { payid: 'new_payid' } }
    assert_redirected_to new_user_session_path
  end

  test 'should update payid' do
    patch payid_path(@member), params: { member: { payid: 'new_payid' } }
    assert_redirected_to pay_outs_path
    assert_equal 'PayID updated successfully.', flash[:success]
    @member.reload
    assert_equal 'new_payid', @member.payid
  end
end
