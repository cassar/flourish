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

  test 'membership page links to needs met, contributions and notifications pages' do
    sign_in users(:one)

    get membership_path

    assert_select "a[href='#{needs_met_membership_path}']"
    assert_select "a[href='#{contributions_membership_path}']"
    assert_select "a[href='#{notifications_membership_path}']"
  end

  test 'needs met page requires sign in' do
    get needs_met_membership_path

    assert_redirected_to new_user_session_path
  end

  test 'needs met page shows dividends when present' do
    sign_in users(:one)

    get needs_met_membership_path

    assert_response :success
    assert_select 'div', text: /No needs met yet/, count: 0
  end

  test 'needs met page shows empty state' do
    sign_in users(:admin)

    get needs_met_membership_path

    assert_select 'div', text: /No needs met yet/
  end

  test 'contributions page requires sign in' do
    get contributions_membership_path

    assert_redirected_to new_user_session_path
  end

  test 'contributions page shows contributions when present' do
    sign_in users(:one)

    get contributions_membership_path

    assert_response :success
    assert_select 'div', text: /No contributions yet/, count: 0
  end

  test 'contributions page shows empty state' do
    sign_in users(:admin)

    get contributions_membership_path

    assert_select 'div', text: /No contributions yet/
  end

  test 'notifications page requires sign in' do
    get notifications_membership_path

    assert_redirected_to new_user_session_path
  end

  test 'notifications page shows notification preferences' do
    sign_in users(:one)

    get notifications_membership_path

    assert_response :success
    assert_select 'p', text: /Dividend Issued/
  end
end
