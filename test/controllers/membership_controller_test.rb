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

  test 'membership page links to dividends, contributions and notifications pages' do
    sign_in users(:one)

    get membership_path

    assert_select "a[href='#{dividends_membership_path}']"
    assert_select "a[href='#{contributions_membership_path}']"
    assert_select "a[href='#{notifications_membership_path}']"
  end

  test 'dividends page requires sign in' do
    get dividends_membership_path

    assert_redirected_to new_user_session_path
  end

  test 'dividends page shows dividends when present' do
    sign_in users(:one)

    get dividends_membership_path

    assert_response :success
    assert_select 'div', text: /No dividends yet/, count: 0
  end

  test 'dividends page shows empty state' do
    sign_in users(:admin)

    get dividends_membership_path

    assert_select 'div', text: /No dividends yet/
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
