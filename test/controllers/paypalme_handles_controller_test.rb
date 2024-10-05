require 'test_helper'

class PaypalmeHandlesControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect to sign in when not authenticated for edit' do
    get edit_paypalme_handle_path(members(:one))

    assert_redirected_to new_user_session_path
  end

  test 'should get edit' do
    sign_in users(:one)

    get edit_paypalme_handle_path(members(:one))

    assert_response :success
  end

  test 'should redirect to sign in when not authenticated for update' do
    patch paypalme_handle_path(members(:one)), params: { member: { paypalme_handle: 'new_paypalme_handle' } }

    assert_redirected_to new_user_session_path
  end

  test 'should update paypalme_handle' do
    sign_in users(:one)

    patch paypalme_handle_path(members(:one)), params: { member: { paypalme_handle: 'new_paypalme_handle' } }

    assert_redirected_to membership_path
    assert_equal 'PayPal.Me handle updated successfully.', flash[:success]
    members(:one).reload

    assert_equal 'new_paypalme_handle', members(:one).paypalme_handle
  end
end
