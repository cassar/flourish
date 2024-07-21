require 'test_helper'

class PaypalmeidsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
    @member = @user.member
  end

  test 'should redirect to sign in when not authenticated for edit' do
    sign_out @user
    get edit_paypalmeid_path(@member)
    assert_redirected_to new_user_session_path
  end

  test 'should get edit' do
    get edit_paypalmeid_path(@member)
    assert_response :success
  end

  test 'should redirect to sign in when not authenticated for update' do
    sign_out @user
    patch paypalmeid_path(@member), params: { member: { paypalmeid: 'new_paypalmeid' } }
    assert_redirected_to new_user_session_path
  end

  test 'should update paypalmeid' do
    patch paypalmeid_path(@member), params: { member: { paypalmeid: 'new_paypalmeid' } }
    assert_redirected_to membership_path
    assert_equal 'PayID updated successfully.', flash[:success]
    @member.reload
    assert_equal 'new_paypalmeid', @member.paypalmeid
  end
end
