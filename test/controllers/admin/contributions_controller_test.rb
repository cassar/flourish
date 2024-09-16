require 'test_helper'

module Admin
  class ContributionsControllerTest < ActionDispatch::IntegrationTest
    test 'not authenticated for new' do
      get new_admin_member_contribution_path(members(:one))
      assert_redirected_to new_user_session_path
    end

    test 'not authorized for new' do
      assert_not users(:one).admin?
      sign_in users(:one)

      get new_admin_member_contribution_path(members(:one))
      assert_redirected_to root_path
    end

    test 'get new' do
      assert users(:admin).admin?
      sign_in users(:admin)

      get new_admin_member_contribution_path(members(:one))
      assert_response :success
    end

    test 'not authenticated for create' do
      post admin_member_contributions_path(members(:one))
      assert_redirected_to new_user_session_path
    end

    test 'not authorized for create' do
      assert_not users(:one).admin?
      sign_in users(:one)

      assert_no_difference 'Contribution.count' do
        post admin_member_contributions_path(members(:one)),
             params: { contribution: { transaction_identifier: 'xxxx' } }
      end

      assert_redirected_to root_path
      assert_equal "You don't have access.", flash[:alert]
    end

    test 'creates a new record on post create on valid record' do
      sign_in users(:admin)

      assert_difference 'Contribution.count' do
        post admin_member_contributions_path(members(:one)), params: { contribution: {
          transaction_identifier: 'xxxx',
          amount_in_base_units: 4000
        } }
      end

      assert_redirected_to admin_users_path
      assert_equal 'New contribution created and notification sent', flash[:success]
      assert_equal 'xxxx', Contribution.last.transaction_identifier
    end

    test 'sends a notification on post create on valid record ' do
      sign_in users(:admin)

      mailer_mock = mock('mailer')
      NotificationMailer.stubs(:with).returns(mailer_mock).once
      mailer_mock.stubs(:contribution_received).returns(mailer_mock).once
      mailer_mock.stubs(:deliver_later).returns(true).once

      post admin_member_contributions_path(members(:one)), params: { contribution: {
        transaction_identifier: 'xxxx',
        amount_in_base_units: 4000
      } }
    end

    test 'post create on invalid record' do
      sign_in users(:admin)

      assert_no_difference 'Contribution.count' do
        post admin_member_contributions_path(members(:one)), params: { contribution: {
          transaction_identifier: 'xxxx'
        } }
      end

      assert_response :success
      assert_equal 'Amount in base units is not a number', flash[:alert]
    end
  end
end