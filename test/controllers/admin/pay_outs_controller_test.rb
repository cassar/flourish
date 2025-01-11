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
      assert_predicate dividends(:pending_pay_out).reload, :pay_out_complete?
    end

    test 'sends notification for preference enabled' do
      ActionMailer::Base.deliveries.clear
      sign_in users(:admin)
      notification_preference = notification_preferences(:dividend_paid_out)
      dividend = dividends(:pending_pay_out)

      assert_equal dividend.member, notification_preference.member
      assert_predicate notification_preference, :enabled

      perform_enqueued_jobs do
        post admin_dividend_pay_outs_path(dividend),
             params: { pay_out: {
               currency: 'USD',
               amount_in_base_units: 500,
               fees_in_base_units: 3,
               transaction_identifier: 'new_transaction_identifier'
             } }
      end

      assert_equal 1, ActionMailer::Base.deliveries.count
      assert(ActionMailer::Base.deliveries.all? do |mail|
        mail.subject.match?(/Your Dividend has been Paid Out/)
      end)
    end

    test 'does not send a notification for preference disabled' do
      ActionMailer::Base.deliveries.clear
      sign_in users(:admin)
      notification_preference = notification_preferences(:dividend_paid_out_disabled)
      dividend = dividends(:pending_pay_out_two)

      assert_equal dividend.member, notification_preference.member
      assert_not_predicate notification_preference, :enabled

      perform_enqueued_jobs do
        post admin_dividend_pay_outs_path(dividend),
             params: { pay_out: {
               currency: 'USD',
               amount_in_base_units: 500,
               fees_in_base_units: 3,
               transaction_identifier: 'new_transaction_identifier'
             } }
      end

      assert_equal 0, ActionMailer::Base.deliveries.count
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
      assert_predicate dividends(:pending_pay_out).reload, :pending_pay_out?
    end
  end
end
