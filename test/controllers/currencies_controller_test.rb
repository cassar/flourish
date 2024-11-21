require 'test_helper'

class CurrenciesControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect to sign in when not authenticated for edit' do
    get edit_currency_path(members(:one))

    assert_redirected_to new_user_session_path
  end

  test 'should get edit' do
    sign_in users(:one)

    get edit_currency_path(members(:one))

    assert_response :success
  end

  test 'should redirect to sign in when not authenticated for update' do
    patch currency_path(members(:one)), params: { member: { currencies: 'new_currencies' } }

    assert_redirected_to new_user_session_path
  end

  test 'should update currency' do
    sign_in users(:one)

    assert_equal 'AUD', members(:one).currency

    patch currency_path(members(:one)), params: { member: { currency: 'HKD' } }

    assert_redirected_to membership_path
    assert_equal 'Currency updated successfully.', flash[:success]
    members(:one).reload

    assert_equal 'HKD', members(:one).currency
  end
end
