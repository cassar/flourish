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

  test 'should redirect to sign in when not authenticated for payid' do
    sign_out @user
    get payid_path
    assert_redirected_to new_user_session_path
  end

  test 'should get payid' do
    get payid_path
    assert_response :success
  end

  test 'should redirect to sign in when not authenticated for membership' do
    sign_out @user
    patch membership_url, params: { member: { payid: 'new_payid' } }
    assert_redirected_to new_user_session_path
  end

  test 'should update member' do
    patch membership_url, params: { member: { payid: 'new_payid' } }
    assert_redirected_to membership_url
    assert_equal 'PayID updated successfully.', flash[:success]
    @member.reload
    assert_equal 'new_payid', @member.payid
  end

  test 'should redirect to sign in when not authenticated for dividends' do
    sign_out @user
    get dividends_path
    assert_redirected_to new_user_session_path
  end

  test 'should get dividends' do
    get dividends_path
    assert_response :success
  end
end
