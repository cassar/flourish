require 'test_helper'

module Admin
  class DividendsControllerTest < ActionDispatch::IntegrationTest
    test 'should redirect to sign in when not authenticated for show' do
      get admin_dividend_path(dividends(:one))
      assert_redirected_to new_user_session_path
    end

    test 'should redirect to sign in when not authorized for show' do
      assert_not users(:one).admin?
      sign_in users(:one)

      get admin_dividend_path(dividends(:one))
      assert_redirected_to dividends_path
    end

    test 'should get show' do
      assert users(:admin).admin?
      sign_in users(:admin)

      get admin_dividend_path(dividends(:one))
      assert_response :success
    end

    test 'should redirect to sign in when not authenticated for update' do
      patch admin_dividend_path(dividends(:one))
      assert_redirected_to new_user_session_path
    end

    test 'should redirect to sign in when not authorized for update' do
      assert_not users(:one).admin?
      sign_in users(:one)

      assert_nil dividends(:one).receipt
      patch admin_dividend_path(dividends(:one)), params: { dividend: { receipt: 'new_receipt' } }

      assert_redirected_to dividends_path
      assert_equal "You don't have access.", flash[:alert]
      assert_nil dividends(:one).receipt
    end

    test 'should patch update' do
      assert users(:admin).admin?
      sign_in users(:admin)

      assert_nil dividends(:one).receipt
      patch admin_dividend_path(dividends(:one)), params: { dividend: { receipt: 'new_receipt' } }

      assert_response :success
      assert_equal 'Receipt updated successfully.', flash[:success]
      assert_equal 'new_receipt', dividends(:one).reload.receipt
    end
  end
end
