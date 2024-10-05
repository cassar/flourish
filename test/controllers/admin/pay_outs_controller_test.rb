require 'test_helper'

module Admin
  class PayOutsControllerTest < ActionDispatch::IntegrationTest
    test 'should redirect to sign in when not authenticated for show' do
      get edit_admin_pay_out_path(dividends(:one))

      assert_redirected_to new_user_session_path
    end

    test 'should redirect to sign in when not authorized for show' do
      assert_not users(:one).admin?
      sign_in users(:one)

      get edit_admin_pay_out_path(dividends(:one))

      assert_redirected_to dividends_path
    end

    test 'should get show' do
      assert_predicate users(:admin), :admin?
      sign_in users(:admin)

      get edit_admin_pay_out_path(dividends(:one))

      assert_response :success
    end

    test 'should redirect to sign in when not authenticated for update' do
      patch admin_pay_out_path(dividends(:one))

      assert_redirected_to new_user_session_path
    end

    test 'should redirect to sign in when not authorized for update' do
      assert_not users(:one).admin?
      sign_in users(:one)

      assert_nil dividends(:one).transaction_identifier
      patch admin_pay_out_path(dividends(:one)),
            params: { dividend: { transaction_identifier: 'new_transaction_identifier' } }

      assert_redirected_to dividends_path
      assert_equal "You don't have access.", flash[:alert]
      assert_nil dividends(:one).transaction_identifier
    end

    test 'should patch update' do
      assert_predicate users(:admin), :admin?
      sign_in users(:admin)

      assert_nil dividends(:one).transaction_identifier
      patch admin_pay_out_path(dividends(:one)),
            params: { dividend: { transaction_identifier: 'new_transaction_identifier' } }

      assert_response :success
      assert_equal 'Receipt updated successfully.', flash[:success]
      assert_equal 'new_transaction_identifier', dividends(:one).reload.transaction_identifier
    end
  end
end
