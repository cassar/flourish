require 'test_helper'

module Admin
  class DividendsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @dividend = dividends(:one)
      @user = users(:one)
      sign_in @user
    end

    test 'should redirect to sign in when not authenticated for show' do
      sign_out @user
      get admin_dividend_path(@dividend)
      assert_redirected_to new_user_session_path
    end

    test 'should redirect to sign in when not authorized for show' do
      User.any_instance.stubs(:admin?).returns(false)
      get admin_dividend_path(@dividend)
      assert_redirected_to dividends_path
    end

    test 'should get show' do
      User.any_instance.stubs(:admin?).returns(true)
      get admin_dividend_path(@dividend)
      assert_response :success
    end

    test 'should redirect to sign in when not authenticated for update' do
      sign_out @user
      patch admin_dividend_path(@dividend)
      assert_redirected_to new_user_session_path
    end

    test 'should redirect to sign in when not authorized for update' do
      assert_nil @dividend.receipt
      User.any_instance.stubs(:admin?).returns(false)
      patch admin_dividend_path(@dividend), params: { dividend: { receipt: 'new_receipt' } }
      assert_redirected_to dividends_path
      assert_equal "You don't have access.", flash[:alert]
      assert_nil @dividend.receipt
    end

    test 'should patch update' do
      assert_nil @dividend.receipt
      User.any_instance.stubs(:admin?).returns(true)
      patch admin_dividend_path(@dividend), params: { dividend: { receipt: 'new_receipt' } }
      assert_response :success
      assert_equal 'Receipt updated successfully.', flash[:success]
      assert_equal 'new_receipt', @dividend.reload.receipt
    end
  end
end
