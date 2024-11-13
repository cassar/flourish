require 'test_helper'

module Admin
  class PayOutsControllerTest < ActionDispatch::IntegrationTest
    test 'not authenticated for show' do
      get edit_admin_pay_out_path(pay_outs(:pending_pay_out))

      assert_redirected_to new_user_session_path
    end

    test 'not authorized for show' do
      assert_not users(:one).admin?
      sign_in users(:one)

      get edit_admin_pay_out_path(pay_outs(:pending_pay_out))

      assert_redirected_to root_path
    end

    test 'get show' do
      assert_predicate users(:admin), :admin?
      sign_in users(:admin)

      get edit_admin_pay_out_path(pay_outs(:pending_pay_out))

      assert_response :success
    end

    test 'not authenticated for update' do
      patch admin_pay_out_path(pay_outs(:pending_pay_out))

      assert_redirected_to new_user_session_path
    end

    test 'not authorized for update' do
      assert_not users(:one).admin?
      sign_in users(:one)

      assert_nil pay_outs(:pending_pay_out).transaction_identifier
      patch admin_pay_out_path(pay_outs(:pending_pay_out)),
            params: { pay_out: { transaction_identifier: 'new_transaction_identifier' } }

      assert_redirected_to root_path
      assert_equal "You don't have access.", flash[:alert]
      assert_nil pay_outs(:pending_pay_out).transaction_identifier
    end

    test 'patch update' do
      assert_predicate users(:admin), :admin?
      sign_in users(:admin)

      assert_nil pay_outs(:pending_pay_out).transaction_identifier
      patch admin_pay_out_path(pay_outs(:pending_pay_out)),
            params: { pay_out: { transaction_identifier: 'new_transaction_identifier' } }

      assert_response :redirect
      assert_equal 'Receipt updated successfully.', flash[:success]
      assert_equal 'new_transaction_identifier', pay_outs(:pending_pay_out).reload.transaction_identifier
    end
  end
end
