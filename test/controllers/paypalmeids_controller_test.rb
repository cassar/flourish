require 'test_helper'

class PaypalmeidsControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect to sign in when not authenticated for edit' do
    get edit_paypalmeid_path(members(:one))

    assert_redirected_to new_user_session_path
  end

  test 'should get edit' do
    sign_in users(:one)

    get edit_paypalmeid_path(members(:one))

    assert_response :success
  end

  test 'should redirect to sign in when not authenticated for update' do
    patch paypalmeid_path(members(:one)), params: { member: { paypalmeid: 'new_paypalmeid' } }

    assert_redirected_to new_user_session_path
  end

  test 'should update paypalmeid' do
    sign_in users(:one)

    patch paypalmeid_path(members(:one)), params: { member: { paypalmeid: 'new_paypalmeid' } }

    assert_redirected_to membership_path
    assert_equal 'PayPal.Me ID updated successfully.', flash[:success]
    members(:one).reload

    assert_equal 'new_paypalmeid', members(:one).paypalmeid
  end
end
