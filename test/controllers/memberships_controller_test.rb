require 'test_helper'

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect to sign in when not authenticated for show' do
    get membership_path

    assert_redirected_to new_user_session_path
  end

  test 'should get show with paypalme_handle present' do
    sign_in users(:one)
    members(:one).update! paypalme_handle: 'my_paypalme_handle'

    get membership_url

    assert_response :success
  end

  test 'should get show without paypalme_handle present' do
    sign_in users(:one)

    assert_nil members(:one).paypalme_handle

    get membership_url

    assert_response :success
  end
end
