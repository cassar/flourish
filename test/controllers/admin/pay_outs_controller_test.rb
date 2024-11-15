require 'test_helper'

module Admin
  class PayOutsControllerTest < ActionDispatch::IntegrationTest
    test 'not authenticated for show' do
      get new_admin_dividend_pay_out_path(dividends(:pending_pay_out))

      assert_redirected_to new_user_session_path
    end

    test 'not authorized for show' do
      assert_not users(:one).admin?
      sign_in users(:one)

      get new_admin_dividend_pay_out_path(dividends(:pending_pay_out))

      assert_redirected_to root_path
    end

    test 'get show' do
      assert_predicate users(:admin), :admin?
      sign_in users(:admin)

      get new_admin_dividend_pay_out_path(dividends(:pending_pay_out))

      assert_response :success
    end

    test 'not authenticated for preview' do
      get preview_admin_dividend_pay_outs_path(dividends(:pending_pay_out))

      assert_redirected_to new_user_session_path
    end

    test 'not authorized for preview' do
      assert_not users(:one).admin?
      sign_in users(:one)

      get preview_admin_dividend_pay_outs_path(dividends(:pending_pay_out))

      assert_redirected_to root_path
    end

    test 'get preview' do
      assert_predicate users(:admin), :admin?
      sign_in users(:admin)

      get preview_admin_dividend_pay_outs_path(
        dividends(:pending_pay_out), params: { pay_out: {
          currency: 'USD',
          amount_in_base_units: 500,
          fees_in_base_units: 3,
          transaction_identifier: 'new_transaction_identifier'
        } }
      )

      assert_response :success
    end

    test 'not authenticated for create' do
      assert_no_difference 'PayOut.count' do
        post admin_dividend_pay_outs_path(dividends(:pending_pay_out))
      end

      assert_redirected_to new_user_session_path
    end

    test 'not authorized for create' do
      assert_not users(:one).admin?
      sign_in users(:one)

      assert_no_difference 'PayOut.count' do
        post admin_dividend_pay_outs_path(dividends(:pending_pay_out)),
             params: { pay_out: { transaction_identifier: 'new_transaction_identifier' } }
      end

      assert_redirected_to root_path
      assert_equal "You don't have access.", flash[:alert]
    end

    test 'post create valid' do
      assert_predicate users(:admin), :admin?
      sign_in users(:admin)

      assert_difference 'PayOut.count' do
        post admin_dividend_pay_outs_path(dividends(:pending_pay_out)),
             params: { pay_out: {
               currency: 'USD',
               amount_in_base_units: 500,
               fees_in_base_units: 3,
               transaction_identifier: 'new_transaction_identifier'
             } }
      end

      assert_response :redirect
      assert_equal 'Pay out created successfully', flash[:success]
      assert_equal 500, PayOut.last.amount_in_base_units
      assert_equal 3, PayOut.last.fees_in_base_units
      assert_equal 'USD', PayOut.last.currency
      assert_equal 'new_transaction_identifier', PayOut.last.transaction_identifier
    end

    test 'post create invalid' do
      assert_predicate users(:admin), :admin?
      sign_in users(:admin)

      assert_no_difference 'PayOut.count' do
        post admin_dividend_pay_outs_path(dividends(:pending_pay_out)),
             params: { pay_out: {
               transaction_identifier: 'new_transaction_identifier'
             } }
      end

      assert_response :success
      assert_equal 'Amount in base units is not a number', flash[:error]
    end
  end
end
