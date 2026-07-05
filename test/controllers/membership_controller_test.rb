require 'test_helper'

class MembershipControllerTest < ActionDispatch::IntegrationTest
  test 'redirects to login when not signed in' do
    get membership_path

    assert_redirected_to new_user_session_path
  end

  test 'renders membership page when signed in' do
    sign_in users(:one)

    get membership_path

    assert_response :success
  end

  test 'membership page shows member email' do
    user = users(:one)
    sign_in user

    get membership_path

    assert_select 'p', text: /#{Regexp.escape(user.email)}/
  end

  test 'membership page shows PayPal.Me warning when handle is missing' do
    sign_in users(:one)

    get membership_path

    assert_select 'p', text: /No PayPal.Me handle set/
  end

  test 'membership page does not show PayPal.Me warning when handle is present' do
    sign_in users(:has_paypalme_handle)

    get membership_path

    assert_select 'p', text: /No PayPal.Me handle set/, count: 0
  end

  test 'membership page shows dividends when present' do
    sign_in users(:one)

    get membership_path

    assert_select 'div', text: /No dividends yet/, count: 0
  end

  test 'membership page shows contributions when present' do
    sign_in users(:one)

    get membership_path

    assert_select 'div', text: /No contributions yet/, count: 0
  end

  test 'membership page shows empty state for dividends' do
    sign_in users(:admin)

    get membership_path

    assert_select 'div', text: /No needs met yet/
  end

  test 'membership page shows empty state for contributions' do
    sign_in users(:admin)

    get membership_path

    assert_select 'div', text: /No contributions yet/
  end

  test 'membership page shows notification preferences' do
    sign_in users(:one)

    get membership_path

    assert_select 'p', text: /Dividend Issued/
  end
end
